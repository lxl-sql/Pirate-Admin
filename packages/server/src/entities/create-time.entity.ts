/**
 * 默认实体类
 */
import {CreateDateColumn, PrimaryGeneratedColumn,} from 'typeorm';
import {DateFormatTransformer} from "@/utils/transformer";

export abstract class CreateTimeEntity {
  @PrimaryGeneratedColumn()
  id: number;

  @CreateDateColumn({
    name: 'create_time',
    type: 'timestamp',
    comment: '创建时间',
    transformer: new DateFormatTransformer()
  })
  createTime: Date;
}
