import {ApiProperty} from "@nestjs/swagger";
import {Status} from '@/enums';
import {DefaultVo} from "@/vos/default.vo";

export class RoleVo extends DefaultVo {
  @ApiProperty({description: '父角色 ID', example: 0})
  parentId?: number;

  @ApiProperty({description: '角色名称', example: '管理员'})
  name?: string;

  @ApiProperty({description: '角色标识', example: 'admin'})
  slug?: string;

  @ApiProperty({description: '角色描述', example: '系统管理员角色'})
  description?: string;

  @ApiProperty({description: '排序字段', example: 1})
  sort?: number;

  @ApiProperty({description: '角色状态', enum: Status})
  status?: Status;

  @ApiProperty({
    description: '子角色列表',
    type: () => RoleVo,
    isArray: true
  })
  children?: RoleVo[];

  @ApiProperty({description: '权限列表id', example: [1, 2]})
  permissionIds?: number[];
}
