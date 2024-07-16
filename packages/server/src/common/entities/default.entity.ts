/**
 * 默认实体类
 */
import { DateFormatTransformer } from '@/utils/transformer';
import {
  CreateDateColumn,
  PrimaryGeneratedColumn,
  UpdateDateColumn,
} from 'typeorm';

export abstract class DefaultEntity {
  @PrimaryGeneratedColumn()
  id: number;

  @UpdateDateColumn({
    name: 'update_time',
    comment: '更新时间',
    transformer: new DateFormatTransformer(),
  })
  updateTime: Date;

  @CreateDateColumn({
    name: 'create_time',
    comment: '创建时间',
    transformer: new DateFormatTransformer(),
    nullable: true
  })
  createTime: Date;
}
