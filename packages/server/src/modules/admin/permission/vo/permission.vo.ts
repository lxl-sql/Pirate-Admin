import {ApiProperty} from "@nestjs/swagger";
import {Status} from '@/enums';
import {DefaultVo} from "@/vos/default.vo";

export class PermissionVo extends DefaultVo {
  @ApiProperty({description: '标题', example: '权限管理'})
  title: string;

  @ApiProperty({description: '图标', example: 'icon-permission'})
  icon: string;

  @ApiProperty({description: '名称', example: 'Permission'})
  name: string;

  @ApiProperty({description: '路径', example: '/permission'})
  path: string;

  @ApiProperty({description: '组件', example: 'PermissionComponent'})
  component: string;

  @ApiProperty({description: '父ID', example: 0})
  parentId: number;

  @ApiProperty({description: '排序字段', example: 1})
  sort: number;

  @ApiProperty({description: '类型', example: 1})
  type: number;

  @ApiProperty({description: '编码', example: 'permission:manage'})
  code: string;

  @ApiProperty({description: '描述', example: '管理权限'})
  description: string;

  @ApiProperty({description: '菜单类型', example: 1, enum: [1, 2, 3]})
  frame: number;

  @ApiProperty({description: '是否缓存', example: Status.ENABLED, enum: Status})
  cache: Status;

  @ApiProperty({description: '状态', example: Status.ENABLED, enum: Status})
  status: Status;
}
