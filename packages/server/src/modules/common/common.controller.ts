import {Controller, Get, Inject, Session} from '@nestjs/common';
import {CommonService} from './common.service';
import {CaptchaService} from '@/common/captcha/captcha.service';

@Controller('common')
export class CommonController {
  @Inject(CaptchaService)
  private readonly captchaService: CaptchaService;

  constructor(private readonly commonService: CommonService) {
  }

  @Get('svg-captcha')
  public async svgCaptcha(@Session() session: Record<string, any>) {
    return await this.captchaService.svgCaptcha(session);
  }

}
