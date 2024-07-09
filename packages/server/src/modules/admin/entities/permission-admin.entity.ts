import { DefaultEntity } from '@/common/entities/default.entity';
import { Column, Entity } from 'typeorm';

// 管理员权限表
@Entity({
  name: 'admin_permissions',
})
export class AdminPermission extends DefaultEntity {
  @Column({
    length: 50,
    comment: '标题',
  })
  title: string;

  @Column({
    length: 50,
    comment: '图标',
    nullable: true,
  })
  icon: string;

  @Column({
    length: 50,
    comment: '名称',
    unique: true,
  })
  name: string;

  @Column({
    length: 50,
    comment: '路径',
    nullable: true,
  })
  path: string;

  @Column({
    length: 50,
    comment: '组件', // 用于菜单展示
    nullable: true,
  })
  component: string;

  @Column({
    comment: '父级ID', // 用于菜单层级
    nullable: true,
  })
  parentId: number;

  @Column({
    comment: '排序', // 用于菜单排序
    default: 0,
  })
  sort: number;

  @Column({
    comment: '类型', // 1: 菜单目录 2: 菜单项 3: 按钮
  })
  type: number;

  @Column({
    length: 50,
    comment: '权限标识', // 例如: admin:adminUser:list (模块:操作:权限) 用于控制按钮级别的权限
    nullable: true,
  })
  code: string;

  @Column({
    length: 255,
    comment: '描述',
    nullable: true,
  })
  description: string;

  @Column({
    comment: '是否外链',
    type: 'tinyint',
    default: 1, // 1: 选项卡 2: 外链 3: iframe
  })
  frame: number;

  @Column({
    comment: '是否缓存',
    type: 'tinyint',
    default: 0, // 1: 启用 0: 禁用
  })
  cache: number;

  @Column({
    comment: '状态',
    type: 'tinyint',
    default: 1, // 1: 启用 0: 禁用
  })
  status: number;
}
