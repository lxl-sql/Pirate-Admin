import {Controller, Get, Inject, Query} from '@nestjs/common';
import {CaptchaService} from '@/common/captcha/captcha.service';
import {CommonService} from './common.service';

@Controller('common')
export class CommonController {
  @Inject(CaptchaService)
  private readonly captchaService: CaptchaService;

  constructor(private readonly commonService: CommonService) {
  }

  @Get('svg-captcha')
  public async svgCaptcha(
    @Query('uuid') uuid: string
  ) {
    return await this.captchaService.svgCaptcha(uuid);
  }
}
