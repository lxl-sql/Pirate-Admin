import {ApiProperty} from "@nestjs/swagger";
import {IsArray, IsEnum, IsInt, IsNotEmpty, IsOptional} from 'class-validator';
import {Status} from '@/enums';

export class UpsertRoleDto {
  @ApiProperty({description: '角色 ID', example: 1, required: false})
  @IsInt()
  @IsOptional()
  id: number;

  @ApiProperty({description: '父角色 ID', example: 0, required: false})
  @IsInt({message: '父角色ID必须为整数'})
  @IsOptional()
  parentId: number;

  @ApiProperty({description: '角色名称', example: '管理员'})
  @IsNotEmpty({message: '名称不能为空'})
  name: string;

  @ApiProperty({description: '角色标识', example: 'admin'})
  @IsNotEmpty({message: '角色标识不能为空'})
  slug: string;

  @ApiProperty({description: '权限 ID 列表', example: [1, 2, 3], isArray: true})
  @IsArray({message: '权限必须为数组'})
  @IsNotEmpty({message: '权限不能为空'})
  permissionIds: number[];

  @ApiProperty({description: '角色描述', example: '系统管理员角色', required: false})
  @IsOptional()
  description: string;

  @ApiProperty({description: '排序字段', example: 1, required: false})
  @IsInt()
  @IsOptional()
  sort: number;

  @ApiProperty({description: '角色状态', example: Status.ENABLED, enum: Status, required: false})
  @IsEnum(Status, {message: '状态值不正确'})
  @IsOptional()
  status: Status;
}
