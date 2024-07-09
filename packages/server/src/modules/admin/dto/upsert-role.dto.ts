import { IsArray, IsInt, IsNotEmpty, IsOptional } from 'class-validator';

export class UpsertRoleDto {
  @IsInt()
  @IsOptional()
  id: number;

  @IsInt()
  @IsOptional()
  parentId: number;

  @IsNotEmpty({ message: '名称不能为空' })
  name: string;

  @IsNotEmpty({ message: '角色标识不能为空' })
  slug: string;

  @IsArray({ message: '权限必须为数组' })
  @IsNotEmpty({ message: '权限不能为空' })
  permissionIds: number[];

  @IsOptional()
  description: string;

  @IsInt()
  @IsOptional()
  sort: number;

  @IsInt()
  @IsOptional()
  status: number; // 1 启用 2 禁用
}
