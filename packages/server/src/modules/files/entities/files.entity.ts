import { DefaultEntity } from '@/entities/default.entity';
import { Column, Entity } from 'typeorm';

@Entity({
  name: 'files',
  comment: '附件表',
})
export class File extends DefaultEntity {
  @Column({
    length: 255,
    comment: '附件名',
  })
  name: string;

  @Column({
    length: 255,
    comment: '附件 hash',
  })
  hash: string;

  @Column({
    length: 255,
    comment: '附件路径',
  })
  path: string;

  @Column({
    length: 100,
    comment: '附件类型',
  })
  mimetype: string;

  @Column({
    comment: '附件大小',
  })
  size: number;

  // 上传次数
  @Column({
    name: 'upload_count',
    default: 1,
    comment: '上传次数',
  })
  uploadCount: number;

  @Column({
    length: 50,
    comment: '用户名称',
  })
  username: string;

  @Column({
    type: 'tinyint',
    comment: '用户类型 1: 管理员 2: 普通用户',
    nullable: true,
  })
  usertype: number;
}
