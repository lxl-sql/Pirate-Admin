import {
  CanActivate,
  ExecutionContext,
  Inject,
  Injectable,
  UnauthorizedException,
} from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { Observable } from 'rxjs';

@Injectable()
export class PermissionGuard implements CanActivate {
  @Inject()
  private reflector: Reflector;

  canActivate(
    context: ExecutionContext,
  ): boolean | Promise<boolean> | Observable<boolean> {
    const request = context.switchToHttp().getRequest();

    if (!request.user) {
      return true;
    }

    const permissions = request.user.permissions;

    const requirePermissions = this.reflector.getAllAndOverride<string[]>(
      'require-permissions',
      [context.getClass(), context.getHandler()],
    );

    if (!requirePermissions) {
      // 如果没有设置权限，则默认为有权限
      return true;
    }

    const isPermission = requirePermissions.some(
      (permission) => !permissions.includes(permission),
    );

    if (isPermission) {
      throw new UnauthorizedException('您没有访问该接口的访问权限');
    }

    return true;
  }
}
