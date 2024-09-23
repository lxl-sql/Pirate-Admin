import {ApiProperty} from "@nestjs/swagger";
import {IsInt, IsNotEmpty, IsOptional, ValidateIf} from 'class-validator';
import {Status} from '@/enums';

export class UpsertPermissionDto {
  @ApiProperty({description: '权限 ID', example: 1, required: false})
  @IsInt()
  @IsOptional()
  id: number;

  @ApiProperty({description: '父权限 ID', example: 0, required: false})
  @IsInt()
  @IsOptional()
  parentId: number;

  @ApiProperty({description: '规则类型', example: 1, enum: [1, 2, 3]})
  @IsNotEmpty({message: '规则类型不能为空'})
  @IsInt()
  type: number; // 1 菜单目录 2 菜单项 3 按钮

  @ApiProperty({description: '规则标题', example: '权限管理'})
  @IsNotEmpty({message: '规则标题不能为空'})
  title: string;

  @ApiProperty({description: '规则名称', example: 'permission'})
  @IsNotEmpty({message: '规则名称不能为空'})
  name: string;

  @ApiProperty({description: '规则路径', example: '/permission', required: false})
  @ValidateIf((o) => o.type !== 3)
  @IsNotEmpty({message: '规则路径不能为空'})
  path: string;

  @ApiProperty({description: '图标', example: 'icon-permission', required: false})
  @IsOptional()
  icon: string;

  @ApiProperty({description: '菜单类型', example: 1, enum: [1, 2, 3]})
  @IsInt()
  @IsNotEmpty({message: '菜单类型不能为空'})
  frame: number; // 1 选项卡 2 外链 3 iframe

  @ApiProperty({description: '组件', example: 'PermissionComponent', required: false})
  @IsOptional()
  component: string;

  @ApiProperty({description: '描述', example: '管理权限', required: false})
  @IsOptional()
  description: string;

  @ApiProperty({description: '排序字段', example: 1, required: false})
  @IsInt()
  @IsOptional()
  sort: number;

  @ApiProperty({description: '缓存状态', example: Status.ENABLED, enum: Status, required: false})
  @IsInt()
  @IsOptional()
  cache: Status;

  @ApiProperty({description: '状态', example: Status.ENABLED, enum: Status, required: false})
  @IsInt()
  @IsOptional()
  status: Status;
}
