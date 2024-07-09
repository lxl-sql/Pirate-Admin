import { IsEmail, IsNotEmpty, IsOptional, IsString } from 'class-validator';
import { ConfigEmailDto } from './config-email.dto';

export class GenerateEmailDto extends ConfigEmailDto {
  @IsEmail({}, { message: '发件人邮箱格式不正确' })
  @IsNotEmpty({ message: '发件人邮箱不能为空' })
  address: string;

  @IsEmail({}, { message: '收件人邮箱格式不正确' })
  @IsNotEmpty({ message: '收件人邮箱不能为空' })
  to: string;

  @IsNotEmpty({ message: '邮件主题不能为空' })
  subject: string;

  @IsString()
  @IsOptional()
  html: string;
}
