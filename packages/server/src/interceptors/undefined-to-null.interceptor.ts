import {
  CallHandler,
  ExecutionContext,
  Injectable,
  NestInterceptor,
} from '@nestjs/common';
import { Observable, map } from 'rxjs';

@Injectable()
export class UndefinedToNullInterceptor implements NestInterceptor {
  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    return next
      .handle()
      .pipe(map((data) => this.transUndefinedformToNull(data)));
  }

  private transUndefinedformToNull(data: any) {
    if (typeof data === 'object' && data !== null) {
      for (const key in data) {
        if (data[key] === undefined || data[key] === '') {
          data[key] = null;
        } else if (Object.prototype.hasOwnProperty.call(data, key)) {
          data[key] = this.transUndefinedformToNull(data[key]);
        }
      }
    }
    return data;
  }
}
