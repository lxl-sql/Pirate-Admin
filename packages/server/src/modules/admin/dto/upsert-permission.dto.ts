import { IsInt, IsNotEmpty, IsOptional, ValidateIf } from 'class-validator';

export class UpsertPermissionDto {
  @IsInt()
  @IsOptional()
  id: number;

  @IsInt()
  @IsOptional()
  parentId: number;

  @IsNotEmpty({ message: '规则类型不能为空' })
  @IsInt()
  type: number; // 1 菜单目录 2 菜单项 3 按钮

  @IsNotEmpty({ message: '规则标题不能为空' })
  title: string;

  @IsNotEmpty({ message: '规则名称不能为空' })
  name: string;

  @ValidateIf((o) => o.type !== 3)
  @IsNotEmpty({ message: '规则路径不能为空' })
  path: string;

  @IsOptional()
  icon: string;

  @IsNotEmpty({ message: '菜单类型不能为空' })
  @IsInt()
  frame: number; // 1 选项卡 2 外链 3 iframe

  @IsOptional()
  commonent: string;

  @IsOptional()
  description: string;

  @IsInt()
  @IsOptional()
  sort: number;

  @IsInt()
  @IsOptional()
  cache: number; // 是否缓存 1 缓存 2 不缓存

  @IsInt()
  @IsOptional()
  status: number; // 1 启用 2 禁用
}
