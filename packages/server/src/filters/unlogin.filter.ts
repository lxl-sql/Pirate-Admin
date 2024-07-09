import {
  ArgumentsHost,
  Catch,
  ExceptionFilter,
  HttpStatus,
} from '@nestjs/common';
import { Response } from 'express';

export class UnloginException {
  message: string;

  constructor(message?: string) {
    this.message = message;
  }
}

@Catch(UnloginException)
export class UnloginFilter implements ExceptionFilter {
  catch(exception: UnloginException, host: ArgumentsHost) {
    const response = host.switchToHttp().getResponse<Response>();

    response
      .json({
        code: HttpStatus.UNAUTHORIZED,
        message: exception.message || '用户未登录',
        data: null,
      })
      .end();
  }
}
