import { IsNotEmpty, IsOptional } from 'class-validator';

export class LoginAdminDto {
  @IsNotEmpty({ message: '用户名不能为空' })
  username: string;

  @IsNotEmpty({ message: '密码不能为空' })
  password: string;

  @IsNotEmpty({ message: '验证码不能为空' })
  captcha: string;

  @IsOptional()
  remember: 0 | 1; // 0 不保持会话 1 保持会话
}
