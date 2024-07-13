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

export class UpsertAdminDto {
  @IsInt({message: '类型格式不正确'})
  @IsNotEmpty({message: '类型格式不能为空'})
  type: 1 | 2; // 1 管理员列表新增管理员; 2 用户信息修改

  @IsInt({message: 'id格式不正确'})
  @IsOptional()
  id?: number | null;

  @IsNotEmpty({message: '用户名不能为空'})
  username: string;

  @ValidateIf((dto) => !dto.id && !dto.password)
  @IsNotEmpty({message: '密码不能为空'})
  @MinLength(6, {message: '密码长度不能小于6位'})
  password: string;

  @IsNotEmpty({message: '昵称不能为空'})
  nickname: string;

  @ArrayNotEmpty({message: '角色组不能为空'})
  @ValidateIf((dto) => dto.type === 1)
  roleIds: number[];

  @IsString({message: '头像格式不正确'})
  @IsOptional()
  avatar?: string | null;

  @ValidateIf((dto) => dto.email)
  @IsEmail({}, {message: '邮箱格式不正确'})
  email?: string | null;

  @ValidateIf((dto) => dto.phone)
  @IsMobilePhone('zh-CN', {}, {message: '手机号格式不正确'})
  phone?: string | null;

  @IsNumber({}, {message: '状态错误'})
  status: number;
}
