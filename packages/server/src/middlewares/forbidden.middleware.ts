import { Injectable, NestMiddleware } from '@nestjs/common';

@Injectable()
export class ForbiddenMiddleware implements NestMiddleware {
  use(req: any, res: any, next: () => void) {
    console.log('brefore');
    next();
    console.log('after');
  }
}
