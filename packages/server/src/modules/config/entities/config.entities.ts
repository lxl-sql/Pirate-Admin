// 快捷配置入口
import {DefaultEntity} from '@/common/entities/default.entity';
import {Column, Entity, JoinColumn, ManyToOne} from 'typeorm';
import {ConfigGroup} from "./config-group.entities";

@Entity({
  name: 'config',
})
export class Config extends DefaultEntity {
  @ManyToOne(() => ConfigGroup, (group) => group.configs)
  @JoinColumn({name: 'group_id'})
  group: ConfigGroup;

  @Column({
    length: 100,
    comment: '字段标题',
  })
  title: string;

  @Column({
    length: 100,
    comment: '字段名',
    unique: true,
  })
  name: string;

  @Column({
    length: 100,
    comment: '字段类型',
  })
  type: string;

  @Column({
    length: 300,
    comment: '提示信息',
    nullable: true
  })
  tip: string;

  @Column({
    length: 300,
    comment: '校验规则',
    nullable: true
  })
  rule: string;

  @Column({
    length: 300,
    comment: '字典数据',
    nullable: true
  })
  content: string;

  @Column({
    length: 300,
    comment: '默认value值',
    nullable: true,
  })
  value: string;

  @Column({
    length: 300,
    comment: 'FormItem 扩展属性',
    nullable: true,
  })
  extend: string;

  @Column({
    name: 'input_extend',
    length: 300,
    comment: 'input 扩展属性',
    nullable: true,
  })
  inputExtend: string;

  @Column({
    type: 'int',
    comment: '权重',
    default: 0,
  })
  weight: number;
}
