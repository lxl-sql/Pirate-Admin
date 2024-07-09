import { VerifyCaptchaDto } from '@/common/captcha/dto/verify-captcha.dto';
export class UpdateUserDto extends VerifyCaptchaDto {
  avatar: string;

  nickname: string;

  sign: string;
}
