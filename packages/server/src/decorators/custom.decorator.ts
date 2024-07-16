import {LogCallType} from '@/types';
import {createParamDecorator, ExecutionContext, SetMetadata,} from '@nestjs/common';

export const Custom = (...args: string[]) => SetMetadata('custom', args);

/**
 * @description 设置登录
 * @returns
 */
export const RequireLogin = () => SetMetadata('require-login', true);

/**
 * @description 设置权限
 * @param permissions 权限列表
 * @returns
 */
export const RequirePermissions = (...permissions: string[]) =>
  SetMetadata('require-permissions', permissions);

/**
 * @description 获取用户信息
 * @param key 键 默认为 null
 * @param ctx 上下文
 * @returns 用户信息 或者 用户信息的某个值 如果没有用户信息则返回 null
 */
export const UserInfo = createParamDecorator(
  (key: string, ctx: ExecutionContext) => {
    const request = ctx.switchToHttp().getRequest();

    if (!request.user) {
      return null;
    }

    return key ? request.user[key] : request.user;
  },
);

/**
 * @description 获取用户信息
 * @param key 键 默认为 null
 * @param ctx 上下文
 * @returns 用户信息 或者 用户信息的某个值 如果没有用户信息则返回 null
 */
export const RealIp = createParamDecorator(
  (key: string, ctx: ExecutionContext) => {
    const request = ctx.switchToHttp().getRequest();
    return request.realIp
  },
);

/**
 * @description 获取请求的host
 * @param key 键 默认为 null
 * @param ctx 上下文
 */
export const ProtocolHost = createParamDecorator(
  (key: string, ctx: ExecutionContext) => {
    const request = ctx.switchToHttp().getRequest();

    return request.protocol + '://' + request.get('host');
  },
);

/**
 * @description 记录调用 日志 用于记录用户和管理员的操作 用于审计 用于日志记录 用于调试 用于性能分析 用于错误追踪 用于问题排查 用于问题定位
 * @param type
 * @returns
 */
export const LogCall = (type: LogCallType, title?: string) => {
  return SetMetadata('log-call', [type, title]);
};
