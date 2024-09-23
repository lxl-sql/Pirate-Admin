import {ApiProperty} from "@nestjs/swagger";
import {Status} from '@/enums'
import {DefaultVo} from "@/vos/default.vo";

export class BaseUserInfoVo extends DefaultVo {
  @ApiProperty({description: '用户名', example: 'admin'})
  username?: string;

  @ApiProperty({description: '昵称', example: '管理员'})
  nickname?: string;

  @ApiProperty({description: '邮箱地址', example: 'admin@example.com'})
  email?: string;

  @ApiProperty({description: '电话号码', example: '12345678901'})
  phone?: string;

  @ApiProperty({description: '头像 URL', example: 'https://example.com/avatar.png'})
  avatar?: string;

  @ApiProperty({description: '状态 0 禁用 1 启用', enum: Status, example: Status.ENABLED})
  status?: Status;

  @ApiProperty({description: '上次登录 IP', example: '192.168.0.1'})
  lastLoginIp?: string;

  @ApiProperty({description: '上次登录时间', example: '2023-07-10 12:00:00'})
  lastLoginTime?: Date | string;

  @ApiProperty({description: '角色列表', example: ['admin', 'user']})
  roles?: string[];

  @ApiProperty({description: '权限列表', example: ['read', 'write']})
  permissions?: string[];
}
