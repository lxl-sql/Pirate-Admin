import {Inject, Injectable, UnauthorizedException} from '@nestjs/common';
import {JwtService} from '@nestjs/jwt';
import {BaseUserInfoVo} from './vo/user-info.vo';
import {ConfigService} from '@nestjs/config';
import {BaseTokenVo} from "@/common/token/vo/base-token.vo";

interface refreshToken {
  id: number;
}

@Injectable()
export class TokenService {
  @Inject(JwtService)
  private readonly jwtService: JwtService;

  @Inject(ConfigService)
  private readonly configService: ConfigService;

  /**
   * @description 刷新 token
   * @param sign 签名 用于区分不同的 token 例如：用户 token 和 管理员 token 等
   * @param refreshToken
   * @param callback 用于处理 token 中的数据 返回用户信息
   * @returns
   */
  public async refreshToken(
    sign: string,
    refreshToken: string,
    callback: (data: refreshToken) => Promise<BaseUserInfoVo>,
  ) {
    try {
      const data = await this.jwtService.verify(refreshToken);

      if (data.sign !== sign) {
        throw new UnauthorizedException('token 已失效，请重新登录');
      }

      return this.generateToken(sign, await callback(data));
    } catch (error) {
      throw new UnauthorizedException('token 已失效，请重新登录');
    }
  }

  /**
   * @description 生成 token 和 refreshToken
   * @param sign  签名 用于区分不同的 token 例如：用户 token 和 管理员 token 等
   * @param userInfo 用户信息
   * @param remember 是否记住登录 0: 不记住 1: 记住 默认为 1 当不保持会话时 默认过期时间为 1 天 保持会话时 默认使用 refresh 刷新token
   * @returns
   */
  public generateToken(
    sign: string,
    userInfo: BaseUserInfoVo,
    remember: 0 | 1 = 1,
  ): BaseTokenVo {
    const isRemember = remember === 1;

    const accessExpiresIn = this.configService.get('JWT_ACCESS_TOKEN_EXPIRES_IN',);
    const refreshExpiresIn = this.configService.get('JWT_REFRESH_TOKEN_EXPIRES_IN',);

    // 生成 token
    const accessToken = this.jwtService.sign(
      {
        sign: sign,
        userId: userInfo.id,
        username: userInfo.username,
        roles: userInfo.roles,
        permissions: userInfo.permissions,
        accessToken: true, // 区分 accessToken 和 refreshToken
      },
      {
        expiresIn: isRemember ? accessExpiresIn || '30m' : '1d',
      },
    );

    // 生成 refreshToken
    const refreshToken = isRemember
      ? this.jwtService.sign(
        {
          sign: sign,
          userId: userInfo.id,
          username: userInfo.username,
        },
        {
          expiresIn: refreshExpiresIn || '7d',
        },
      )
      : null;

    return {accessToken, refreshToken};
  }
}
