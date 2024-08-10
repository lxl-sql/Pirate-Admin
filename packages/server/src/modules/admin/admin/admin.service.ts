import {HttpException, HttpStatus, Inject, Injectable} from '@nestjs/common';
import {ConfigService} from '@nestjs/config';
import {In, Not} from 'typeorm';
import * as dayjs from 'dayjs';
import {like, md5, requestHost, trimmedIp,} from '@/utils/tools';
import {removePublic} from '@/utils/crud';
import {CaptchaTypeEnum} from "@/types/enum";
import {CaptchaService} from "@/common/captcha/captcha.service";
import {TokenService} from '@/common/token/token.service';
import {VerifyCaptchaDto} from "@/common/captcha/dto/verify-captcha.dto";
import {IdsDto} from '@/dtos/remove.dto';
import {PaginationVo} from "@/vos/response.vo";
import {Role} from '../role/entities/role.entity';
import {Admin} from './entities/admin.entity';
import {RoleRepository} from "../role/role.repository";
import {AdminRepository} from "./admin.repository";
import {UpsertAdminDto} from './dto/upsert-admin.dto';
import {LoginAdminDto} from './dto/login-admin.dto';
import {QueryAdminDto} from './dto/query-admin.dto';
import {AdminProfileInfoVo} from "./vo/profile-info-admin.vo";
import {AdminLoginInfoVo} from './vo/login-admin.vo';
import {forEachTree} from "@/utils/tree";

@Injectable()
export class AdminService {
  @Inject(ConfigService)
  private readonly configService: ConfigService;

  @Inject(TokenService)
  private readonly tokenService: TokenService;

  @Inject(CaptchaService)
  private captchaService: CaptchaService;

  @Inject(AdminRepository)
  private readonly adminRepository: AdminRepository;

  @Inject(RoleRepository)
  private readonly roleRepository: RoleRepository;


  /**
   * @description 创建/编辑管理员
   * @param admin
   * @returns
   */
  public async upsert(admin: UpsertAdminDto & { roles?: Role[] }) {
    if (admin.id) {
      return await this.update(admin);
    } else {
      return await this.create(admin);
    }
  }

  /**
   * @description 创建数据
   * @param admin
   */
  private async create(admin: UpsertAdminDto) {
    const exist_admin = await this.adminRepository.existsByUsername(admin.username);

    if (exist_admin) {
      throw new HttpException('用户名已存在', HttpStatus.CONFLICT);
    }

    try {
      const new_admin = this.adminRepository.create(admin);
      const roles = await this.roleRepository.findById(In(admin.roleIds));

      new_admin.roles = roles;
      new_admin.password = md5(admin.password);
      await this.adminRepository.save(new_admin);
      return '创建成功';
    } catch (error) {
      throw new HttpException('创建失败', HttpStatus.BAD_REQUEST);
    }
  }

  /**
   * @description 更新数据
   * @param admin
   * @param originAdmin
   */
  private async update(admin: UpsertAdminDto & { roles?: Role[] }) {
    const found_admin = await this.adminRepository.findOneById(admin.id, ['roles']);

    try {
      if (admin.roleIds) {
        const sameRoles = found_admin.roles.every((role) => admin.roleIds.includes(role.id),);
        if (found_admin.roles.length !== admin.roleIds.length || !sameRoles) {
          admin.roles = await this.roleRepository.findById(In(admin.roleIds))
        }
      }
      this.adminRepository.merge(found_admin, admin, {
        email: found_admin.email, // TODO 不允许通过接口更新，只能通过绑定用户数据更新
        phone: found_admin.phone, // TODO 不允许通过接口更新，只能通过绑定用户数据更新
        avatar: admin.avatar || null,
        updateTime: new Date(),
        password: admin.password ? md5(admin.password) : found_admin.password,
      });
      found_admin.roles = admin.roles || found_admin.roles
      await this.adminRepository.save(found_admin);
      return '修改成功';
    } catch (error) {
      throw new HttpException('修改失败', HttpStatus.BAD_REQUEST);
    }
  }

  /**
   * @description 获取管理员头像
   * @param username 管理员
   * @returns
   */
  public async avatar(username: string, protocolHost: string) {
    const found_admin = await this.adminRepository.findOneByUsername(username)
    return requestHost(protocolHost, found_admin.avatar);
  }

  /**
   * @description 管理员登录
   * @param loginAdmin
   * @param session
   * @param ip
   * @param protocolHost
   * @returns
   */
  public async login(loginAdmin: LoginAdminDto, ip: string, protocolHost: string): Promise<AdminLoginInfoVo> {
    const redis_key = await this.captchaService.validateCaptcha('admin_login_captcha', loginAdmin.uuid, loginAdmin.captcha)

    const admin = await this.adminRepository.findOneByUsername(loginAdmin.username, ['roles', 'roles.permissions'])

    if (!admin || admin.password !== md5(loginAdmin.password)) {
      // 不能告诉用户是用户名错误还是密码错误 否则会有安全隐患 可以使用 HttpStatus.UNAUTHORIZED 代替 HttpStatus.BAD_REQUEST 返回
      throw new HttpException(
        '用户名或密码错误，请确认用户名后登录',
        HttpStatus.BAD_REQUEST,
      );
    }

    if (admin.status === 0) {
      throw new HttpException(
        '用户账户已被禁用，请联系管理员获取更多信息。',
        HttpStatus.BAD_REQUEST,
      );
    }

    const vo = new AdminLoginInfoVo();
    vo.userInfo = this.generateUserInfo(
      admin,
      ['roles', 'roles.permissions'],
      protocolHost,
    );

    const sign = this.configService.get('JWT_REFRESH_SIGN_ADMIN');

    if (!sign) {
      throw new HttpException(
        'token sign 未配置',
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }

    const {accessToken, refreshToken} = this.tokenService.generateToken(
      sign,
      vo.userInfo,
      loginAdmin.remember,
    );

    vo.accessToken = accessToken;
    vo.refreshToken = refreshToken;

    await this.captchaService.delCaptcha(redis_key)

    const date = new Date()

    vo.userInfo.lastLoginIp = trimmedIp(ip);
    vo.userInfo.lastLoginTime = dayjs(date).format('YYYY-MM-DD HH:mm:ss')

    this.adminRepository.update(admin.id, {
      lastLoginIp: vo.userInfo.lastLoginIp,
      lastLoginTime: date,
    });

    return vo
  }

  /**
   * @description 刷新accessToken
   * @param refreshToken
   * @param protocolHost
   * @returns
   */
  public async refreshToken(refreshToken: string, protocolHost: string) {
    const sign = this.configService.get('JWT_REFRESH_SIGN_ADMIN');

    if (!sign) {
      throw new HttpException(
        'token sign 未配置',
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
    return await this.tokenService.refreshToken(
      sign,
      refreshToken,
      async (data) => {
        const relations = ['roles', 'roles.permissions'];

        const found_admin = await this.adminRepository.findOneById(data.id, relations)

        return this.generateUserInfo(found_admin, relations, protocolHost);
      },
    );
  }

  /**
   * @description 生成用户信息
   * @param user
   * @param relations 是否需要角色和权限
   * @returns
   */
  private generateUserInfo(info: Admin, relations: string[], protocolHost: string,): AdminProfileInfoVo {
    const userInfo: AdminProfileInfoVo = {
      id: info.id,
      username: info.username,
      nickname: info.nickname,
      avatar: requestHost(protocolHost, info.avatar),
      email: info.email,
      phone: info.phone,
      status: info.status,
      lastLoginIp: info.lastLoginIp,
      lastLoginTime: info.lastLoginTime,
      createTime: info.createTime,
      updateTime: info.updateTime,
    };

    if (!relations) return userInfo;

    return {
      ...userInfo,
      roles: relations.includes('roles')
        ? info.roles.map((role) => role.name)
        : undefined,
      permissions: relations.includes('roles.permissions')
        ? info.roles.reduce((acc, cur) => {
          cur.permissions.forEach((permission) => {
            // 去重
            if (!acc.includes(permission.name)) acc.push(permission.name);
          });
          return acc;
        }, [])
        : undefined,
    };
  }

  /**
   * 根据用户 id 返回包含自身角色的所有的子级角色
   * @param id
   * @private
   */
  private async findIdWithRoleIds(id: number) {
    const found_admin = await this.adminRepository.findOneById(id, ['roles'])
    const admin_roleIds = found_admin.roles.map(role => role.id)
    const roles = await this.roleRepository.findTrees()
    let bool = false
    let roleIds: number[] = []
    // 从最外层循环 只要找到数据 就不在查找
    forEachTree(roles, (role, _i, _l, _p, level) => {
      if (admin_roleIds.includes(role.id) && !bool) {
        bool = true
        roleIds.push(role.id)
        forEachTree(role.children, r => {
          roleIds.push(r.id)
        })
        return false
      }
      return true
    })
    return roleIds
  }

  /**
   * @description 获取用户列表
   * @param page 页码
   * @param size 每页数量
   * @param query 查询条件
   * @param protocolHost 请求的host
   * @param userId 当前登录用户的 id
   * @returns
   */
  public async list(page: number, size: number, query: QueryAdminDto, protocolHost: string, userId: number): Promise<PaginationVo<AdminProfileInfoVo>> {
    const roleIds = await this.findIdWithRoleIds(userId)

    const condition = {
      id: Not(userId),
      nickname: like(query.nickname),
      roles: {
        id: In(roleIds)
      }
    };

    const [user, total] = await this.adminRepository.findAndCountAll(page, size, condition)

    const records = user.map((item) => {
      return this.generateUserInfo(item, ['roles'], protocolHost);
    });

    return {
      page,
      size,
      total,
      records,
      remark: '管理员列表不会将自己算入，请注意',
    };
  }

  /**
   * @description 删除用户
   * @param id
   * @returns
   */
  public remove = async (body: IdsDto) => {
    return await removePublic(this.adminRepository, body);
  };

  /**
   * @description 获取用户详情 but 不返回密码 以及其他敏感信息 用于编辑
   * @param id
   * @returns
   */
  public async detail(id: number, protocolHost: string) {
    const found_admin = await this.adminRepository.findOneById(id, ['roles']);
    return {
      ...found_admin,
      avatar: found_admin.avatar,
      avatarFull: requestHost(protocolHost, found_admin.avatar),
      password: undefined,
      roles: undefined,
      roleIds: found_admin.roles.map((role) => role.id),
    };
  }

  /**
   * 获取绑定邮箱/手机号验证码
   * @param type
   * @param address
   */
  public async bindCaptcha(type: CaptchaTypeEnum, address: string) {
    return await this.captchaService.generateCaptcha({
      key: `admin_bind_captcha_${address}`,
      type,
      address,
      subject: `获取绑定${type === 'email' ? '邮箱' : '手机号'}验证码`,
    })
  }

  /**
   * 绑定管理员关键信息
   * @param bindInfoDot
   */
  public async bindInfo(userId: number, bindInfo: VerifyCaptchaDto) {
    await this.captchaService.verifyCaptcha('admin_bind_captcha', bindInfo)
    this.adminRepository.update(userId, {
      [bindInfo.type]: bindInfo.address
    })
    return '绑定成功'
  }
}
