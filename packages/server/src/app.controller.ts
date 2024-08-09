import { Controller, Get } from '@nestjs/common';
import { AppService } from './app.service';
import {
  RequireLogin,
  RequirePermissions,
  UserInfo,
} from '@/decorators/custom.decorator';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

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
