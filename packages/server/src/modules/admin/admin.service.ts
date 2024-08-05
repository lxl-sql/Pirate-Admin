import {HttpException, HttpStatus, Inject, Injectable} from '@nestjs/common';
import {UpsertAdminDto} from './dto/upsert-admin.dto';
import {LoginAdminDto} from './dto/login-admin.dto';
import {InjectEntityManager, InjectRepository} from '@nestjs/typeorm';
import {Admin} from './entities/admin.entity';
import {EntityManager, In, Repository, TreeRepository} from 'typeorm';
import {existsByOnFail, like, listToTree, mapTree, md5, requestHost, sortTree, trimmedIp,} from '@/utils/tools';
import {AdminLoginInfoVo} from './vo/login-admin.vo';
import {JwtService} from '@nestjs/jwt';
import {ConfigService} from '@nestjs/config';
import {TokenService} from '@/common/token/token.service';
import {QueryAdminDto} from './dto/query-admin.dto';
import {AdminRole} from './entities/role-admin.entity';
import {RemoveAdminDto} from './dto/remove-admin.dto';
import {AdminPermission} from './entities/permission-admin.entity';
import {UpsertPermissionDto} from './dto/upsert-permission.dto';
import {RemovePermissionDto} from './dto/remove-permission.dto';
import {removePublic, treeRemovePublic, treeUpsertPublic} from '@/utils/crud';
import * as dayjs from 'dayjs';
import {IdsDto} from '@/dtos/remove.dto';
import {StatusPermissionDto} from './dto/status-permission.dto';
import {UpsertRoleDto} from './dto/upsert-role.dto';
import {QueryRoleDto} from './dto/query-role.dto';
import {CaptchaService} from "@/common/captcha/captcha.service";
import {VerifyCaptchaDto} from "@/common/captcha/dto/verify-captcha.dto";
import {CaptchaTypeEnum} from "@/types/enum";
import {AdminProfileInfoVo} from "@/modules/admin/vo/profile-info-admin.vo";
import {NotPaginationVo, PaginationVo} from "@/vos/response.vo";
import {AdminRoleVo} from "@/modules/admin/vo/role-admin.vo";
import {AdminPermissionVo} from "@/modules/admin/vo/permission-admin.vo";

@Injectable()
export class AdminService {
  @Inject(JwtService)
  private readonly jwtService: JwtService;

  @Inject(ConfigService)
  private readonly configService: ConfigService;

  @Inject(TokenService)
  private readonly tokenService: TokenService;

  @InjectEntityManager()
  private readonly entityManager: EntityManager;

  @Inject(CaptchaService)
  private captchaService: CaptchaService;

  @InjectRepository(Admin)
  private readonly adminRepository: Repository<Admin>;

  @InjectRepository(AdminRole)
  private readonly roleRepository: TreeRepository<AdminRole>;

  @InjectRepository(AdminPermission)
  private readonly permissionRepository: Repository<AdminPermission>;

  /**
   * @description 创建/编辑管理员
   * @param admin
   * @returns
   */
  public async upsert(admin: UpsertAdminDto & { roles?: AdminRole[] }) {
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
    const exist_admin = await this.adminRepository.existsBy({
      username: admin.username,
    });

    if (exist_admin) {
      throw new HttpException('用户名已存在', HttpStatus.CONFLICT);
    }

    try {
      const new_admin = this.adminRepository.create(admin);
      const roles = await this.roleRepository.findBy({
        id: In(admin.roleIds),
      });
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
  private async update(admin: UpsertAdminDto & { roles?: AdminRole[] }) {
    const found_admin = await this.findOneById(admin.id, ['roles']);

    try {
      if (admin.roleIds) {
        const sameRoles = found_admin.roles.every((role) => admin.roleIds.includes(role.id),);
        if (found_admin.roles.length !== admin.roleIds.length || !sameRoles) {
          admin.roles = await this.roleRepository.findBy({
            id: In(admin.roleIds),
          });
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
    const found_admin = await this.adminRepository.findOneBy({
      username,
    });

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
  public async login(
    loginAdmin: LoginAdminDto,
    ip: string,
    protocolHost: string,
  ): Promise<AdminLoginInfoVo> {
    const redis_key = await this.captchaService.validateCaptcha('admin_login_captcha', loginAdmin.uuid, loginAdmin.captcha)

    const admin = await this.adminRepository.findOne({
      where: {username: loginAdmin.username},
      relations: ['roles', 'roles.permissions'],
    });

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

        const user = await this.adminRepository.findOne({
          where: {
            id: data.id,
          },
          relations, // 关联查询 roles 和 permissions 表
        });

        return this.generateUserInfo(user, relations, protocolHost);
      },
    );
  }

  /**
   * @description 生成用户信息
   * @param user
   * @param relations 是否需要角色和权限
   * @returns
   */
  private generateUserInfo(
    info: Admin,
    relations: string[],
    protocolHost: string,
  ): AdminProfileInfoVo {
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
   * @description 获取用户列表
   * @param page 页码
   * @param size 每页数量
   * @param query 查询条件
   * @param protocolHost 请求的host
   * @param userId 当前登录用户的 id
   * @returns
   */
  public async list(
    page: number,
    size: number,
    query: QueryAdminDto,
    protocolHost: string,
    userId: number,
  ): Promise<PaginationVo<AdminProfileInfoVo>> {
    const condition = {
      nickname: like(query.nickname),
    };

    const [user, total] = await this.adminRepository.findAndCount({
      select: [
        'id',
        'username',
        'nickname',
        'avatar',
        'email',
        'phone',
        'status',
        'lastLoginIp',
        'lastLoginTime',
        'createTime',
      ],
      skip: (page - 1) * size,
      take: size,
      where: condition,
      relations: ['roles'],
      order: {
        createTime: 'DESC',
      },
    });
    const records = user
      .filter((item) => item.id !== userId)
      .map((item) => {
        return this.generateUserInfo(item, ['roles'], protocolHost);
      });

    return {
      page,
      size,
      total: total - 1, // 不算自己
      records,
      remark: '管理员列表不会将自己算入，请注意',
    };
  }

  /**
   * @description 获取角色列表 用于下拉框 返回所有角色的 id 和 name
   * @returns
   */
  public async role(query: QueryRoleDto) {
    const roles = await this.roleRepository.findTrees();

    const records = mapTree(
      roles,
      (item: AdminRole & { parentId: number }, _index, _list, parent) => {
        item.parentId = parent?.id || 0;
      },
    );

    return {
      records: sortTree(records, (a, b) => a.sort - b.sort),
      remark: '',
    };
  }

  /**
   * @description 新增角色权限
   * @param body
   * @returns
   */
  public async roleUpsert(body: UpsertRoleDto) {
    const roleRepository = this.roleRepository;
    try {
      return await treeUpsertPublic(
        roleRepository,
        body,
        async (role: AdminRole) => {
          if (body.permissionIds?.length) {
            role.permissions = await this.permissionRepository.findBy({
              id: In(body.permissionIds),
            });
          }
          if (body.parentId) {
            role.parent = await roleRepository.findOneBy({
              id: body.parentId,
            });
          }
          role.updateTime = new Date();
          return role;
        },
      );
    } catch (error) {
      if (error.code === 'ER_DUP_ENTRY') {
        await existsByOnFail(roleRepository, 'name', body.name, '角色名已存在');
        await existsByOnFail(roleRepository, 'slug', body.slug, '角色标识重复');
      } else {
        const message: string = error.message || (body.id ? '编辑失败' : '新增失败');
        throw new HttpException(message, HttpStatus.BAD_REQUEST);
      }
    }
  }

  /**
   * @description 删除角色
   * @param body
   */
  public roleRemove = async (body: IdsDto) => {
    await treeRemovePublic(this.roleRepository, body);
  };

  /**
   * @description 角色详情
   * @param id
   * @returns
   */
  public async roleDetail(id: number): Promise<AdminRoleVo> {
    const found_role = await this.roleRepository.findOne({
      where: {
        id,
      },
      relations: ['permissions'],
    });
    if (!found_role) {
      throw new HttpException('角色不存在', HttpStatus.NOT_FOUND);
    }
    const permissionIds = found_role.permissions.map((permission) => permission.id);
    return {
      id: found_role.id,
      name: found_role.name,
      slug: found_role.slug,
      description: found_role.description,
      sort: found_role.sort,
      status: found_role.status,
      children: found_role.children,
      parentId: found_role.parentId,
      createTime: found_role.createTime,
      updateTime: found_role.updateTime,
      permissionIds,
    };
  }

  /**
   * @description 删除用户
   * @param id
   * @returns
   */
  public remove = async (body: RemoveAdminDto) => {
    await removePublic(this.adminRepository, body);
  };

  /**
   * @description 获取用户详情 but 不返回密码 以及其他敏感信息 用于编辑
   * @param id
   * @returns
   */
  public async detail(id: number, protocolHost: string) {
    const found_admin = await this.findOneById(id, ['roles']);
    return {
      ...found_admin,
      avatar: found_admin.avatar,
      avatarFull: requestHost(protocolHost, found_admin.avatar),
      password: null,
      roles: undefined,
      roleIds: found_admin.roles.map((role) => role.id),
    };
  }

  /**
   * 根据 Id 查询信息
   * @param id
   * @param relations
   * @returns
   */
  private async findOneById(id: number, relations?: string[]) {
    const found_admin = await this.adminRepository.findOne({
      select: [
        'id',
        'username',
        'nickname',
        'avatar',
        'email',
        'phone',
        'status',
        'motto',
        'password',
        'lastLoginIp',
        'lastLoginTime',
        'updateTime',
      ],
      where: {id},
      relations,
    });

    if (!found_admin) {
      throw new HttpException('用户不存在', HttpStatus.NOT_FOUND);
    }

    return found_admin;
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

  /**
   * @description 获取用户菜单规则
   * @returns
   */
  public async menus(): Promise<NotPaginationVo<AdminPermissionVo>> {
    const permissions = await this.permissionRepository.find({
      select: [
        'id',
        'parentId',
        'title',
        'icon',
        'name',
        'sort',
        'code',
        'component',
        'type',
        'cache',
        'status',
        'createTime',
        'updateTime',
      ],
      order: {
        sort: 'DESC', // 按照 sort 字段升序排序
      },
    });

    return {
      records: listToTree(permissions),
      remark: '',
    };
  }

  /**
   * @description 新增角色组管理
   * @param permission
   * @returns
   */
  public async menuUpsert(body: UpsertPermissionDto) {
    const permissionRepository = this.permissionRepository;
    try {
      return await treeUpsertPublic(
        permissionRepository,
        body,
        async (permission: AdminPermission) => {
          permission.updateTime = new Date();
          return permission;
        },
      );
    } catch (error) {
      if (error.code === 'ER_DUP_ENTRY') {
        await existsByOnFail(
          permissionRepository,
          'name',
          body.name,
          '权限名称已存在',
        );
      } else {
        const message = error.message || body.id ? '编辑失败' : '新增失败';
        throw new HttpException(message, HttpStatus.BAD_REQUEST);
      }
    }
  }

  /**
   * @description 删除菜单
   * @param body
   */
  public menuRemove = async (body: RemovePermissionDto) => {
    await treeRemovePublic(this.permissionRepository, body);
  };

  /**
   * @description 菜单详情
   * @param id
   * @returns
   */
  public async menuDetail(id: number): Promise<AdminPermissionVo> {
    const found_permission = await this.permissionRepository.findOneBy({
      id,
    });

    if (!found_permission) {
      throw new HttpException('菜单不存在', HttpStatus.NOT_FOUND);
    }
    found_permission.parentId = found_permission.parentId || null;

    return found_permission;
  }

  /**
   * @description 修改菜单状态
   * @param body
   * @returns
   */
  public async menuStatus(body: StatusPermissionDto) {
    try {
      await this.permissionRepository
        .createQueryBuilder()
        .update(AdminPermission)
        .set({status: body.status})
        .whereInIds(body.ids)
        .execute();
      return '修改成功';
    } catch (error) {
      throw new HttpException('修改失败', HttpStatus.BAD_REQUEST);
    }
  }

  /**
   * 拖拽排序
   * @param id 排序主键值
   * @param targetId 排序位置主键值
   */
  public async menuSortable(id: number, targetId: number) {
    const list = await this.permissionRepository.find({
      where: {
        id: In([id, targetId]),
      },
    });
    const data = list.find((item) => item.id === id);
    const targetData = list.find((item) => item.id === targetId);
    if (!data || !targetData) {
      throw new HttpException(
        `提供的${data ? 'targetId' : 'id'}无效。`,
        HttpStatus.BAD_REQUEST,
      );
    }
    // 获取最大排序
    const maxSort = targetData.sort > data.sort ? targetData.sort : data.sort;
    const items = await this.permissionRepository
      .createQueryBuilder('p')
      .where('p.parentId = :parentId', {parentId: targetData.parentId})
      .andWhere('p.sort <= :sort', {sort: maxSort})
      .orderBy('p.sort', 'DESC')
      .getMany();

    const currentIndex = items.findIndex((item) => item.id === id);
    const targetIndex = items.findIndex((item) => item.id === targetId);

    // 移动当前项到目标位置
    items.splice(targetIndex, 0, items.splice(currentIndex, 1)[0]);

    let sort = maxSort;
    for (let i = 0; i < items.length; i++) {
      items[i].sort = sort;
      sort--;
    }

    this.permissionRepository.save(items);

    return '修改成功';
  }
}
