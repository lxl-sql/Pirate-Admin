import {Column, Entity, JoinColumn, JoinTable, ManyToMany, Tree, TreeChildren, TreeParent,} from 'typeorm';
import {Status} from "@/enums/status.enum";
import {DefaultEntity} from '@/entities/default.entity';
import {Permission} from '../../permission/entities/permission.entity';

// 用户角色表
@Entity({
  name: 'admin_roles',
})
@Tree('closure-table')
export class Role extends DefaultEntity {
  @Column({
    length: 50,
    comment: '角色名',
    unique: true,
  })
  name: string;

  @Column({
    length: 50,
    comment: '角色标识',
    unique: true,
  })
  slug: string;

  @Column({
    length: 255,
    comment: '描述',
    nullable: true,
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
    default: Status.ENABLED,
  })
  status: Status;

  // 可选：如果需要 parentId，你可以添加一个字段来保存 parent 的 id
  @Column({
    name: 'parent_id',
    nullable: true,
  })
  parentId: number;

  @TreeParent({
    onDelete: 'CASCADE', // 删除父级角色时，子级角色也删除
  })
  @JoinColumn({name: 'parent_id', referencedColumnName: 'id'})
  parent: Role;

  @TreeChildren()
  children: Role[];

  @ManyToMany(() => Permission)
  @JoinTable({
    name: 'admin_role_permissions_relation',
    joinColumn: {
      name: 'role_id',
      referencedColumnName: 'id',
    },
    inverseJoinColumn: {
      name: 'permission_id',
      referencedColumnName: 'id',
    },
  })
  permissions: Permission[];
}
