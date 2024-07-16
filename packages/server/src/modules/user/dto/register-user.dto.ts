import {IsNotEmpty, MinLength} from 'class-validator';
import {VerifyCaptchaDto} from '@/common/captcha/dto/verify-captcha.dto';

export class RegisterUserDto extends VerifyCaptchaDto {
  @IsNotEmpty({message: '用户名不能为空'})
  username: string;

  @IsNotEmpty({message: '密码不能为空'})
  @MinLength(6, {message: '密码长度不能小于6位'})
  password: string;

  @IsNotEmpty({message: '昵称不能为空'})
  nickname: string;
}
