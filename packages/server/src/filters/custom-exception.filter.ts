import {
  ArgumentsHost,
  Catch,
  ExceptionFilter,
  HttpException,
} from '@nestjs/common';
import { Request, Response } from 'express';
import * as dayjs from 'dayjs';

@Catch(HttpException)
export class CustomExceptionFilter implements ExceptionFilter {
  catch(exception: HttpException, host: ArgumentsHost) {
    const request = host.switchToHttp().getRequest<Request>();
    // console.log('request', request);
    const response = host.switchToHttp().getResponse<Response>();
    const statusCode = exception.getStatus();

    response.statusCode = statusCode;

    const res = exception.getResponse() as { message: string; error: string };

    const [message] =
      typeof res === 'string'
        ? [res]
        : typeof res.message === 'string'
        ? [res.message]
        : res.message;

    response
      .json({
        code: statusCode || 500,
        timestamp: dayjs().format('YYYY-MM-DD HH:mm:ss'),
        message: message || '系统繁忙，请稍后再试',
        path: request.url,
        data: null,
      })
      .end();
  }
}
