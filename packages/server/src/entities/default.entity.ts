/**
 * 默认实体类
 */
import {CreateDateColumn, PrimaryGeneratedColumn, UpdateDateColumn,} from 'typeorm';
import {DateFormatTransformer} from "@/utils/transformer";

export abstract class DefaultEntity {
  @PrimaryGeneratedColumn()
  id: number;

  @UpdateDateColumn({
    name: 'update_time',
    type: 'timestamp',
    comment: '更新时间',
    transformer: new DateFormatTransformer()
  })
  updateTime: Date;

  @CreateDateColumn({
    name: 'create_time',
    type: 'timestamp',
    comment: '创建时间',
    transformer: new DateFormatTransformer()
  })
  createTime: Date;
}
