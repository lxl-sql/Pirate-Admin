import { DefaultEntity } from '@/entities/default.entity';
import { Column, Entity } from 'typeorm';

// 用户权限表
@Entity({
  name: 'user_permissions',
})
export class UserPermission extends DefaultEntity {
  @Column({
    length: 50,
    comment: '权限码',
  })
  code: string;

  @Column({
    comment: '状态',
    type: 'tinyint',
    default: 1, // 1: 启用 0: 禁用
  })
  status: number;

  @Column({
    length: 300,
    comment: '权限描述',
  })
  description: string;
}
