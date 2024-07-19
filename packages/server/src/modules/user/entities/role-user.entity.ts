import {
  Column,
  Entity,
  JoinColumn,
  JoinTable,
  ManyToMany,
  Tree,
  TreeChildren,
  TreeParent,
} from 'typeorm';
import { UserPermission } from './permission-user.entity';
import { DefaultEntity } from '@/entities/default.entity';

// 用户角色表
@Entity({
  name: 'user_roles',
})
@Tree('closure-table')
export class UserRole extends DefaultEntity {
  @Column({
    length: 50,
    comment: '角色名',
  })
  name: string;

  @Column({
    length: 50,
    comment: '角色标识',
  })
  slug: string;

  @Column({
    length: 255,
    comment: '描述',
  })
  description: string;

  @Column({
    comment: '排序',
    default: 0,
  })
  sort: number;

  @Column({
    comment: '状态',
    type: 'tinyint',
    default: 1,
  })
  status: number;

  @TreeParent({
    onDelete: 'CASCADE', // 删除父级角色时，子级角色也删除
  })
  @JoinColumn({ name: 'parent_id', referencedColumnName: 'id' })
  parent: UserRole;

  @TreeChildren()
  children: UserRole[];

  @ManyToMany(() => UserPermission)
  @JoinTable({
    name: 'user_role_permissions_relation',
    joinColumn: {
      name: 'role_id',
      referencedColumnName: 'id',
    },
    inverseJoinColumn: {
      name: 'permission_id',
      referencedColumnName: 'id',
    },
  })
  permissions: UserPermission[];
}
