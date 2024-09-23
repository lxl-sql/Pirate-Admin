import {ApiProperty} from "@nestjs/swagger";
import {
  ArrayNotEmpty,
  IsEmail,
  IsInt,
  IsMobilePhone,
  IsNotEmpty,
  IsNumber,
  IsOptional,
  IsString,
  MinLength,
  ValidateIf,
} from 'class-validator';
import {Status} from '@/enums';

export class UpsertAdminDto {
  @ApiProperty({description: '类型', enum: [1, 2], example: 1})
  @IsInt({message: '类型格式不正确'})
  @IsNotEmpty({message: '类型格式不能为空'})
  type: 1 | 2; // 1 管理员列表新增管理员; 2 用户信息修改

  @ApiProperty({description: 'ID', example: 1, required: false})
  @IsInt({message: 'id格式不正确'})
  @IsOptional()
  id?: number | null;

  @ApiProperty({description: '用户名', example: 'admin'})
  @IsNotEmpty({message: '用户名不能为空'})
  username: string;

  @ApiProperty({description: '密码', example: 'password123', required: false})
  @ValidateIf((dto) => !dto.id && !dto.password)
  @IsNotEmpty({message: '密码不能为空'})
  @MinLength(6, {message: '密码长度不能小于6位'})
  password: string;

  @ApiProperty({description: '昵称', example: '管理员'})
  @IsNotEmpty({message: '昵称不能为空'})
  nickname: string;

  @ApiProperty({description: '角色组', example: [1, 2, 3]})
  @ArrayNotEmpty({message: '角色组不能为空'})
  @ValidateIf((dto) => dto.type === 1)
  roleIds: number[];

  @ApiProperty({description: '头像', example: 'https://example.com/avatar.png', required: false})
  @IsString({message: '头像格式不正确'})
  @IsOptional()
  avatar?: string | null;

  @ApiProperty({description: '邮箱', example: 'admin@example.com', required: false})
  @ValidateIf((dto) => dto.email)
  @IsEmail({}, {message: '邮箱格式不正确'})
  email?: string | null;

  @ApiProperty({description: '手机号', example: '12345678901', required: false})
  @ValidateIf((dto) => dto.phone)
  @IsMobilePhone('zh-CN', {}, {message: '手机号格式不正确'})
  phone?: string | null;

  @ApiProperty({description: '状态', example: Status.ENABLED})
  @IsNumber({}, {message: '状态错误'})
  status: Status;
}
