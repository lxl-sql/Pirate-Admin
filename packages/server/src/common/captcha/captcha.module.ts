import {Global, Module} from '@nestjs/common';
import {CaptchaService} from './captcha.service';

@Global()
@Module({
  providers: [CaptchaService],
  exports: [CaptchaService],
})
export class CaptchaModule {
}
