import {Injectable, NestMiddleware} from '@nestjs/common';
import {NextFunction, Request, Response} from 'express';

@Injectable()
export class RealIpMiddleware implements NestMiddleware {
  use(req: Request, res: Response, next: NextFunction) {
    const xForwardedFor = req.headers['x-forwarded-for'];
    if (typeof xForwardedFor === 'string') {
      req.realIp = xForwardedFor.split(',')[0];
    } else if (Array.isArray(xForwardedFor)) {
      req.realIp = xForwardedFor[0];
    } else {
      req.realIp = req.connection.remoteAddress;
    }
    next();
  }
}
