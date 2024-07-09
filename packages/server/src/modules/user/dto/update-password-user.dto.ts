import { IsNotEmpty, MinLength } from 'class-validator';
import { VerifyCaptchaDto } from '@/common/captcha/dto/verify-captcha.dto';

export class UpdatePasswordUserDto extends VerifyCaptchaDto {
  @IsNotEmpty({ message: '密码不能为空' })
  @MinLength(6, { message: '密码长度不能小于6位' })
  password: string;
}
