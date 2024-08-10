import {HttpException, HttpStatus, Inject, Injectable, Logger, UnauthorizedException,} from '@nestjs/common';
import {InjectEntityManager, InjectRepository} from '@nestjs/typeorm';
import {EntityManager, Repository} from 'typeorm';
import {JwtService} from '@nestjs/jwt';
import {ConfigService} from '@nestjs/config';
import * as svgCaptcha from 'svg-captcha-fixed';
import {like, md5, trimmedIp} from '@/utils/tools';
import {mapTree} from "@/utils/tree";
import {CaptchaService} from '@/common/captcha/captcha.service';
import {RedisService} from '@/common/redis/redis.service';
import {BaseUserInfoVo} from '@/common/token/vo/user-info.vo';
import {CaptchaTypeEnum} from "@/types/enum";
import {Status} from "@/enums/status.enum";
import {UserRole} from './entities/role-user.entity';
import {User} from './entities/user.entity';
import {UpdatePasswordUserDto} from './dto/update-password-user.dto';
import {RegisterUserDto} from './dto/register-user.dto';
import {UpdateUserDto} from './dto/update-user.dto';
import {FrozenUserDto} from './dto/frozen-user.dto';
import {LoginUserDto} from './dto/login-user.dto';
import {QueryUserDto} from './dto/query-user.dto';
import {UserProfileInfoVo} from "./vo/profile-info-user.vo";
import {UserLoginInfoVo} from './vo/login-user.vo'

@Injectable()
export class UserService {
  private logger = new Logger();
  @Inject(CaptchaService)
  private captchaService: CaptchaService;

  @Inject(RedisService)
  private redisService: RedisService;

  @Inject(JwtService)
  private jwtService: JwtService;

  @Inject(ConfigService)
  private configService: ConfigService;

  @InjectEntityManager()
  private entityManager: EntityManager;

  @InjectRepository(User)
  private userRepository: Repository<User>;

  @InjectRepository(UserRole)
  private roleRepository: Repository<UserRole>;

  /**
   * @description 用户注册
   * @param user 注册用户 dto
   * @returns
   */
  public async register(user: RegisterUserDto) {
    const redis_key = await this.captchaService.verifyCaptcha(
      'user_captcha',
      user,
    );

    const found_user = await this.userRepository.findOneBy({
      username: user.username,
    });

    if (found_user) {
      throw new HttpException('用户名已存在', HttpStatus.BAD_REQUEST);
    }

    const new_user = this.userRepository.create(user);
    new_user.password = md5(user.password);

    console.log('new_user', new_user);
    try {
      await this.userRepository.save(new_user);
      this.redisService.del(redis_key);
      return '注册成功';
    } catch (error) {
      return '注册失败';
    }
  }

  /**
   * @description 发送验证码
   * @param type {email|phone} email: 邮箱注册 phone: 手机注册
   * @param address 邮箱或手机号
   * @returns
   */
  public async captcha(type: CaptchaTypeEnum, address: string) {
    return await this.captchaService.generateCaptcha({
      key: `user_captcha_${address}`,
      address,
      type,
      subject: '注册验证码',
    });
  }

  /**
   * @description 用户登录
   * @param loginUser 登录用户 dto
   * @param session Request 对象
   * @param ip 用户 ip
   * @returns
   */
  public async login(
    loginUser: LoginUserDto,
    session: Record<string, any>,
    ip: string,
  ) {
    const user = await this.userRepository.findOne({
      where: {
        username: loginUser.username,
      },
      relations: ['roles', 'roles.permissions'], // 关联查询 user_roles 和 user_permissions 表
    });

    if (!user || user.password !== md5(loginUser.password)) {
      // 不能告诉用户是用户名错误还是密码错误 否则会有安全隐患 可以使用 HttpStatus.UNAUTHORIZED 代替 HttpStatus.BAD_REQUEST 返回
      throw new HttpException(
        '用户名或密码错误，请确认用户名后登录',
        HttpStatus.BAD_REQUEST,
      );
    }
    if (
      session.captcha?.toLocaleLowerCase() !==
      loginUser.captcha?.toLocaleLowerCase()
    ) {
      throw new HttpException('验证码错误', HttpStatus.BAD_REQUEST);
    }

    if (user.status === Status.DISABLED) {
      throw new HttpException(
        '用户账户已被禁用，请联系管理员获取更多信息。',
        HttpStatus.BAD_REQUEST,
      );
    }

    const vo = new UserLoginInfoVo();
    vo.userInfo.sign = user.sign;
    vo.userInfo = this.generateUserInfo(user);

    const {accessToken, refreshToken} = this.generateToken(vo.userInfo);
    vo.accessToken = accessToken;
    vo.refreshToken = refreshToken;
    session.captcha = null;

    vo.userInfo.lastLoginIp = trimmedIp(ip);
    vo.userInfo.lastLoginTime = new Date();

    this.userRepository.update(user.id, {
      lastLoginIp: vo.userInfo.lastLoginIp,
      lastLoginTime: vo.userInfo.lastLoginTime,
    });

    return vo;
  }

  /**
   * @description 获取 svg 验证码
   * @param session session 对象
   * @returns
   */
  public async svgCaptcha(session: Record<string, any>) {
    // let captcha = svgCaptcha.create(options); //字母和数字随机验证码
    // let captcha = svgCaptcha.createMathExpr(options) //数字算数随机验证码
    const {data, text} = svgCaptcha.createMathExpr({
      size: 4,
      ignoreChars: '0o1iIl',
      noise: 3,
      color: true,
      // background: '#fff',
      fontSize: 60,
      width: 100,
      height: 38,
      // 数字的时候，设置下面属性。最大，最小，加或者减
      mathMin: 1,
      mathMax: 30,
      // mathOperator: '+',
    });
    session.captcha = text;
    return data;
  }

  /**
   * @description 刷新 token
   * @param refreshToken
   * @returns
   */
  public async refreshToken(refreshToken: string) {
    try {
      const data = await this.jwtService.verify(refreshToken);

      const relations = ['roles', 'roles.permissions'];

      const user = await this.userRepository.findOne({
        where: {
          id: data.id,
        },
        relations, // 关联查询 roles 和 permissions 表
      });

      return this.generateToken(this.generateUserInfo(user, relations));
    } catch (error) {
      throw new UnauthorizedException('token 已失效，请重新登录');
    }
  }

  /**
   * @description 获取用户信息
   * @param userId 用户 id
   * @returns
   */
  public async info(userId: number) {
    const user = await this.findOneById(userId);

    const vo = new BaseUserInfoVo();
    const userInfo = this.generateUserInfo(user);
    return Object.assign(vo, userInfo);
  }

  /**
   * @description 获取用户头像
   * @param username 用户名
   * @returns
   */
  public async avatar(username: string) {
    const user = await this.userRepository.findOneBy({
      username,
    });

    return user?.avatar;
  }

  /**
   * @description 根据 id 查找用户
   * @param id 用户 id
   * @returns
   */
  private async findOneById(id: number) {
    return await this.userRepository.findOneBy({
      id,
    });
  }

  /**
   * @description 生成用户信息
   * @param user
   * @param relations 是否需要角色和权限
   * @returns
   */
  private generateUserInfo(user: User, relations?: string[]): UserProfileInfoVo {
    const userInfo: UserProfileInfoVo = {
      id: user.id,
      username: user.username,
      nickname: user.nickname,
      avatar: user.avatar,
      gender: user.gender,
      email: user.email,
      phone: user.phone,
      sign: user.sign,
      status: user.status,
      lastLoginIp: user.lastLoginIp,
      lastLoginTime: user.lastLoginTime,
      updateTime: user.updateTime,
      createTime: user.createTime,
    };

    if (!relations) return userInfo;

    return {
      ...userInfo,
      roles: relations.includes('roles')
        ? user.roles.map((role) => role.name)
        : undefined,
      permissions: relations.includes('roles.permissions')
        ? user.roles.reduce((acc, cur) => {
          cur.permissions.forEach((permission) => {
            // 去重
            if (!acc.includes(permission.code)) acc.push(permission.code);
          });
          return acc;
        }, [])
        : undefined,
    };
  }

  /**
   * @description 生成 token 和 refreshToken
   * @param userInfo 用户信息
   * @returns
   */
  private generateToken(userInfo: UserProfileInfoVo) {
    // 生成 token
    const accessToken = this.jwtService.sign(
      {
        userId: userInfo.id,
        username: userInfo.username,
        roles: userInfo.roles,
        permissions: userInfo.permissions,
        accessToken: true, // 区分 accessToken 和 refreshToken
      },
      {
        expiresIn:
          this.configService.get('JWT_ACCESS_TOKEN_EXPIRES_IN') || '30m',
      },
    );

    // 生成 refreshToken
    const refreshToken = this.jwtService.sign(
      {
        id: userInfo.id,
      },
      {
        expiresIn:
          this.configService.get('JWT_REFRESH_TOKEN_EXPIRES_IN') || '7d',
      },
    );

    return {accessToken, refreshToken};
  }

  /**
   * @description 修改密码
   * @param userId 用户 id
   * @param passwordDto 修改密码 dto
   * @returns
   */
  public async updatePassword(
    userId: number,
    passwordDto: UpdatePasswordUserDto,
  ) {
    const redis_key = await this.captchaService.verifyCaptcha(
      'user_update_password_captcha',
      passwordDto,
    );

    try {
      this.userRepository.update(userId, {
        password: md5(passwordDto.password),
      });
      this.redisService.del(redis_key);
      return '用户信息修改成功';
    } catch (error) {
      this.logger.error(error, UserService);
      return '用户信息修改失败';
    }
  }

  /**
   * @description 修改密码验证码
   * @param type {email|phone} email: 邮箱注册 phone: 手机注册
   * @param address 邮箱或手机号
   * @returns
   */
  public async updatePasswordCaptcha(type: CaptchaTypeEnum, address: string) {
    return await this.captchaService.generateCaptcha({
      key: `user_update_password_captcha_${address}`,
      address,
      type,
      subject: '修改密码验证码',
    });
  }

  /**
   * @description 更新用户信息
   * @param userId 用户 id
   * @param updateUserDto 更新用户信息 dto
   * @returns
   */
  public async update(userId: number, updateUserDto: UpdateUserDto) {
    const redis_key = await this.captchaService.verifyCaptcha(
      'user_update_captcha',
      updateUserDto,
    );

    try {
      this.userRepository.update(userId, {
        nickname: updateUserDto.nickname,
        avatar: updateUserDto.avatar,
        sign: updateUserDto.sign,
      });

      this.redisService.del(redis_key);
      return '更新成功';
    } catch (error) {
      this.logger.error(error, UserService);
      return '更新失败';
    }
  }

  /**
   * @description 更新用户信息验证码
   * @param type {email|phone} email: 邮箱注册 phone: 手机注册
   * @param address 邮箱或手机号
   * @returns
   */
  public async updateCaptcha(type: CaptchaTypeEnum, address: string) {
    return await this.captchaService.generateCaptcha({
      key: `user_update_captcha_${address}`,
      address,
      type,
      subject: '更新用户信息验证码',
    });
  }

  /**
   * @description 冻结用户
   * @param frozenUser 冻结用户 dto
   * @returns
   */
  public async frozen(frozenUser: FrozenUserDto) {
    try {
      this.userRepository.update(frozenUser.userId, {
        status: frozenUser.status,
      });
      return true;
    } catch (error) {
      this.logger.error(error, UserService);
      return false;
    }
  }

  /**
   * @description 获取用户列表
   * @returns
   */
  public async list(page: number, size: number, query: QueryUserDto) {
    const condition = {
      nickname: like(query.nickname),
    };

    const [user, total] = await this.userRepository.findAndCount({
      select: [
        'id',
        'username',
        'nickname',
        'avatar',
        'gender',
        'email',
        'phone',
        'sign',
        'status',
        'lastLoginIp',
        'lastLoginTime',
        'createTime',
      ],
      skip: (page - 1) * size,
      take: size,
      where: condition,
      relations: ['roles'],
    });
    // console.log(user);
    const records = user.map((item) => {
      return this.generateUserInfo(item, ['roles']);
    });

    return {
      page,
      size,
      total,
      records,
    };
  }

  /**
   * @description 获取角色列表 用于下拉框 返回所有角色的 id 和 name
   * @returns
   */
  public async roles() {
    const roles = await this.entityManager
      .getTreeRepository(UserRole)
      .findTrees();

    return mapTree(
      roles,
      (item: UserRole & { parentId: number }, _index, _list, parent) => {
        item.parentId = parent?.id || 0;
      },
    );
  }

  /**
   * @description 获取权限列表 表格展示
   * @returns
   */
  public async listRoles(page: number, size: number) {
    const [roles, total] = await this.roleRepository.findAndCount({
      select: ['id', 'name', 'status'],
      skip: (page - 1) * size,
      take: size,
    });

    return {
      page,
      size,
      total,
      records: roles,
    };
  }
}
