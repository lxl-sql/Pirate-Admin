import {
  IsEmail,
  IsMobilePhone,
  IsNotEmpty,
  ValidateIf,
} from 'class-validator';

export class VerifyCaptchaDto {
  @IsNotEmpty({ message: '注册类型不能为空' })
  type: number; // 1: 邮箱注册 2: 手机注册

  @ValidateIf((dto) => dto.type === 1)
  @IsNotEmpty({ message: '邮箱不能为空' })
  @IsEmail({}, { message: '邮箱格式不正确' })
  email: string;

  @ValidateIf((dto) => dto.type === 2)
  @IsNotEmpty({ message: '手机号不能为空' })
  @IsMobilePhone('zh-CN', {}, { message: '手机号格式不正确' })
  phone: string;

  @IsNotEmpty({ message: '验证码不能为空' })
  captcha: string;
}
