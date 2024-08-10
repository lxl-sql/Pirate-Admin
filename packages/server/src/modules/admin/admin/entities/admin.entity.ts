import {Column, Entity, JoinTable, ManyToMany} from 'typeorm';
import {DateFormatTransformer} from '@/utils/transformer';
import {Status} from "@/enums/status.enum";
import {DefaultEntity} from '@/entities/default.entity';
import {Role} from '../../role/entities/role.entity';

@Entity({
  name: 'admins',
})
export class Admin extends DefaultEntity {
  @Column({
    length: 50,
    comment: '用户名',
  })
  username: string;

  @Column({
    length: 50,
    comment: '密码',
  })
  password: string;

  @Column({
    length: 50,
    comment: '昵称',
  })
  nickname: string;

  @Column({
    length: 100,
    comment: '头像',
    nullable: true,
  })
  avatar: string;

  @Column({
    length: 50,
    comment: '邮箱',
    nullable: true,
  })
  email: string;

  @Column({
    length: 50,
    comment: '手机号',
    nullable: true,
  })
  phone: string;

  @Column({
    length: 250,
    comment: '座右铭',
    nullable: true,
  })
  motto: string;

  @Column({
    comment: '状态 0 禁用 1 启用',
    type: 'tinyint',
    default: Status.ENABLED,
  })
  status: Status;

  @Column({
    length: 50,
    name: 'last_login_ip',
    comment: '最后登录ip',
    nullable: true,
  })
  lastLoginIp: string;

  @Column({
    name: 'last_login_time',
    comment: '最后登录时间',
    nullable: true,
    transformer: new DateFormatTransformer(),
  })
  lastLoginTime: Date;

  @ManyToMany(() => Role)
  @JoinTable({
    name: 'admin_roles_relation',
    joinColumn: {
      name: 'admin_id',
      referencedColumnName: 'id',
    },
    inverseJoinColumn: {
      name: 'role_id',
      referencedColumnName: 'id',
    },
  })
  roles: Role[];
}
