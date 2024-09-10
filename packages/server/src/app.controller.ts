import {
  Controller,
  Get,
  HttpException,
  HttpStatus,
  Param,
  ParseIntPipe,
} from '@nestjs/common';
import { AppService } from './app.service';
import {
  RequireLogin,
  RequirePermissions,
  UserInfo,
} from '@/decorators/custom.decorator';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get('error/:status')
  getError(@Param('status', ParseIntPipe) status: number): string {
    if (status) {
      throw new HttpException(`This is a custom message ${status}`, status);
    }
    return 'error';
  }

  @Get()
  getHello(): string {
    return this.appService.getHello();
  }

  @Get('aaa')
  @RequireLogin()
  @RequirePermissions('ccc')
  getAaa(@UserInfo('username') username: string, @UserInfo() userInfo): string {
    console.log(username, userInfo);
    return 'aaa';
  }

  @Get('bbb')
  getBbb(): string {
    return 'bbb';
  }
}
