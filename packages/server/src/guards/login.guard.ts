import {
  CanActivate,
  ExecutionContext,
  HttpException,
  HttpStatus,
  Inject,
  Injectable,
  UnauthorizedException,
} from '@nestjs/common';
import {Reflector} from '@nestjs/core';
import {JwtService} from '@nestjs/jwt';
import {Observable} from 'rxjs';

export interface JwtUserData {
  userId: number;
  username: string;
  sign: string;
  accessToken: boolean;
  roles: string[];
  permissions: string[];
}

// 注册全局的用户信息
declare module 'express' {
  interface Request {
    user: JwtUserData;
    // 扩展 Request 类型，添加 realIp 属性
    realIp?: string;
  }
}

@Injectable()
export class LoginGuard implements CanActivate {
  @Inject()
  private reflector: Reflector;

  @Inject(JwtService)
  private jwtService: JwtService;

  canActivate(
    context: ExecutionContext,
  ): boolean | Promise<boolean> | Observable<boolean> {
    const request = context.switchToHttp().getRequest();

    const requireLogin = this.reflector.getAllAndOverride('require-login', [
      context.getClass(),
      context.getHandler(),
    ]);

    if (!requireLogin) {
      return true;
    }

    const authorization = request.headers.authorization;

    if (!authorization) {
      throw new UnauthorizedException('用户未登录');
    }

    try {
      const [bearer, token] = authorization.split(' ') || [];
      if (bearer !== 'Bearer' || !token) {
        throw new HttpException('token格式错误', HttpStatus.BAD_REQUEST);
      }

      const data = this.jwtService.verify<JwtUserData>(token);

      if (!data.accessToken) {
        throw new UnauthorizedException('token 已失效，请重新登录');
      }

      request.user = {
        userId: data.userId,
        username: data.username,
        sign: data.sign,
        roles: data.roles,
        permissions: data.permissions,
      };

      return true;
    } catch (error) {
      if (error.response) {
        throw new HttpException(error.response, error.status);
      } else {
        throw new UnauthorizedException('token 已失效，请重新登录');
      }
    }
  }
}
