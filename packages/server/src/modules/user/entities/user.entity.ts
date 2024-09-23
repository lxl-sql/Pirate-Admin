import {Column, Entity, JoinTable, ManyToMany} from 'typeorm';
import {DateFormatTransformer} from '@/utils/transformer';
import {Gender, Status} from '@/enums';
import {DefaultEntity} from '@/entities/default.entity';
import {UserRole} from './role-user.entity';

@Entity({
  name: 'users',
})
export class User extends DefaultEntity {
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
    type: 'tinyint',
    comment: '性别 0:保密 1:男 2:女',
    nullable: true,
    default: Gender.UNKNOWN,
  })
  gender: Gender;

  @Column({
    length: 20,
    comment: '邮箱',
    nullable: true,
  })
  email: string;

  @Column({
    length: 20,
    comment: '手机号',
    nullable: true,
  })
  phone: string;

  @Column({
    length: 300,
    comment: '签名',
    nullable: true,
  })
  sign: string;

  @Column({
    type: 'tinyint',
    comment: '状态 0:禁用 1:启用',
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

  @ManyToMany(() => UserRole)
  @JoinTable({
    name: 'user_roles_relation',
    joinColumn: {
      name: 'user_id',
      referencedColumnName: 'id',
    },
    inverseJoinColumn: {
      name: 'role_id',
      referencedColumnName: 'id',
    },
  })
  roles: UserRole[];
}
