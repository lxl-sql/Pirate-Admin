import {AdminLogService} from '@/modules/admin-log/admin-log.service';
import {LogCallType, LogCallTypeEnum} from '@/types/enum';
import {trimmedIp} from '@/utils/tools';
import {CallHandler, ExecutionContext, Inject, Injectable, NestInterceptor,} from '@nestjs/common';
import {Reflector} from '@nestjs/core';
import {Request, Response} from 'express';
import {catchError, Observable, tap} from 'rxjs';
import {JwtService} from '@nestjs/jwt';
import {JwtUserData} from '@/guards/login.guard';
import IP2Region from "ip2region";

// const IP2Region = require('ip2region').default;

@Injectable()
export class CustomLoggerInterceptor implements NestInterceptor {
  @Inject(Reflector)
  private readonly reflector: Reflector;

  @Inject(JwtService)
  private readonly jwtService: JwtService;

  @Inject(AdminLogService)
  private readonly adminLogService: AdminLogService;

  private readonly IP2RegionQuery = new IP2Region();

  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    const logCall = this.reflector.get<[LogCallType, string]>(
      'log-call',
      context.getHandler(),
    );
    if (!logCall) return next.handle();
    const [type, title] = logCall || [];

    const request = context.switchToHttp().getRequest<Request>();
    const response = context.switchToHttp().getResponse<Response>();
    const now = Date.now();
    return next.handle().pipe(
      tap((data) => {
        const responseTime = Date.now() - now;
        this.loggerCreate(type, title, request, response, data, responseTime);
      }),
      catchError((error) => {
        const responseTime = Date.now() - now;
        this.loggerCreate(type, title, request, response, error, responseTime);
        throw error;
      }),
    );
  }

  /**
   * @description 创建日志
   * @param type 日志类型 ADMIN | USER
   * @param title 标题
   * @param request 请求
   * @param response 响应
   * @param data 响应数据 | 错误
   * @param responseTime 响应时间
   */
  private async loggerCreate(
    type: LogCallType,
    title: string,
    request: Request,
    response: Response,
    data: any,
    responseTime: number,
  ) {
    const user = this.getUser(request, data);
    // 没有 userId 不记录日志 token失效了 我还记录你干毛球
    if (!user.userId) return;

    const {statusCode} = response;

    const ip = trimmedIp(request.realIp || request.ip)

    const ipAddress = this.IP2RegionQuery.search(ip)

    // 默认参数
    const params = {
      userId: user.userId, // 登录时使用 userInfo
      username: user.username,
      title: title,
      ip: ip,
      ipAddress: [ipAddress.country, ipAddress.province, ipAddress.city].filter(Boolean).join('-'),
      method: request.method,
      url: request.url,
      params: this.paramsToString(this.getParams(request)),
      userAgent: request.headers['user-agent'],
      result: this.paramsToString(data),
      status: data.status || statusCode || 500, // 默认500
      responseTime: responseTime,
    };
    switch (type) {
      case LogCallTypeEnum.ADMIN:
        await this.adminLogService.loggerCreate(params);
        break;
      case LogCallTypeEnum.USER:
        // await this.userLogService.logRequest(request);
        break;
      default:
        break;
    }
  }

  /**
   * @description 获取请求参数
   * @param request
   * @returns
   */
  private getParams(request: Request) {
    const {body, params, query} = request;
    return body || params || query || '';
  }

  /**
   * @description 将参数转换为字符串
   * @param params 参数
   * @returns
   */
  private paramsToString(params: any) {
    return JSON.stringify(params);
  }

  private getUser(request: Request, data: any) {
    /**
     * * 如果请求头包含用户数据
     */
    if (request.user) {
      return request.user;
    }
    const _data = data.data;
    /**
     * * 默认是 登录时接口返回用户信息
     */
    if (_data?.userInfo) {
      return {
        ..._data.userInfo,
        userId: _data.userInfo.id,
      };
    }
    /**
     * * 默认是 refreshToken时接口返回用户信息
     */
    if (_data?.accessToken) {
      const data = this.jwtService.verify<JwtUserData>(_data.accessToken);
      return {
        userId: data.userId,
        username: data.username,
      };
    }
    return {};
  }
}
