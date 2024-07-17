import {ApiProperty} from "@nestjs/swagger";

export class BaseUserInfoVo {
  @ApiProperty({description: '用户 ID', example: 1})
  id: number;

  @ApiProperty({description: '用户名', example: 'admin'})
  username: string;

  @ApiProperty({description: '昵称', example: '管理员'})
  nickname: string;

  @ApiProperty({description: '邮箱地址', example: 'admin@example.com'})
  email: string;

  @ApiProperty({description: '电话号码', example: '1234567890'})
  phone: string;

  @ApiProperty({description: '头像 URL', example: 'https://example.com/avatar.png'})
  avatar: string;

  @ApiProperty({description: '状态 0 禁用 1 启用', example: 1})
  status: number;

  @ApiProperty({description: '上次登录 IP', example: '192.168.0.1', required: false})
  lastLoginIp?: string;

  @ApiProperty({description: '上次登录时间', example: '2023-07-10T00:00:00Z', required: false})
  lastLoginTime?: Date;

  @ApiProperty({description: '更新时间', example: '2023-07-10T00:00:00Z', required: false})
  updateTime?: Date;

  @ApiProperty({description: '创建时间', example: '2023-07-10T00:00:00Z', required: false})
  createTime?: Date;

  @ApiProperty({description: '角色列表', example: ['admin', 'user'], required: false})
  roles?: string[];

  @ApiProperty({description: '权限列表', example: ['read', 'write'], required: false})
  permissions?: string[];
}
