import { Column, Entity, OneToMany } from 'typeorm';
import { DateFormatTransformer } from '@/utils/transformer';
import { CronType, CronCycleType, Status } from '@/enums';
import { DefaultEntity } from '@/entities/default.entity';
import { Log } from '../../log/entities/log.entity';

@Entity('cron')
export class Cron extends DefaultEntity {
  @Column({
    type: 'varchar',
    length: 255,
    comment: '任务名称',
  })
  name: string;

  @Column({
    type: 'varchar',
    length: 255,
    comment: '任务类型',
    default: CronType.SERVICE,
  })
  type: CronType;

  @Column({
    type: 'text',
    comment: 'shell脚本 任务内容 排除规则 等',
    nullable: true,
  })
  content: string;

  @Column({
    type: 'varchar',
    length: 255,
    comment: '任务描述',
    nullable: true,
  })
  description: string;

  @Column({
    type: 'char',
    length: 20,
    comment: 'Cron 表达式',
    nullable: true,
  })
  cron: string;

  @Column({
    name: 'cycle_type',
    type: 'varchar',
    length: 255,
    comment: '执行周期类型',
    nullable: true,
  })
  cycleType: CronCycleType;

  @Column({
    type: 'varchar',
    length: 255,
    comment: '执行周期拼接',
    nullable: true,
  })
  cycle: string;

  @Column({
    name: 'cycle_name',
    type: 'varchar',
    length: 255,
    comment: '执行周期名称',
    nullable: true,
  })
  cycleName: string;

  @Column({
    type: 'int',
    comment: '已保存数量 保存到本地',
    nullable: true,
  })
  save: number;

  // 最大保存数量
  @Column({
    type: 'int',
    comment: '最大保存数量',
    nullable: true,
  })
  maxSave: number;

  @Column({
    type: 'int',
    comment: '排序',
    default: 0,
  })
  sort: number;

  @Column({
    type: 'tinyint',
    comment: '是否启用通知',
    default: Status.DISABLED,
    nullable: true,
  })
  notice: Status;

  @Column({
    name: 'notice_channel',
    type: 'varchar',
    length: 255,
    comment: '通知渠道',
    nullable: true,
  })
  noticeChannel: string;

  @Column({
    type: 'tinyint',
    comment: '状态 0 禁用 1 启用',
    default: Status.ENABLED,
  })
  status: Status;

  @Column({
    name: 'last_execution_time',
    type: 'datetime',
    comment: '上次执行时间',
    transformer: new DateFormatTransformer(),
    nullable: true,
  })
  lastExecutionTime: Date;

  @OneToMany(() => Log, (log) => log.cron)
  logs: Log[];
}
