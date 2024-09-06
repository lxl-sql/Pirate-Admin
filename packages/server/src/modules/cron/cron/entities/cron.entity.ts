import {Column, Entity, OneToMany} from "typeorm";
import {CronCycleTypeEnum} from "@/enums/cron-cycle-type.enum";
import {CronTypeEnum} from "@/enums/cron-type.enum";
import {Status} from "@/enums/status.enum";
import {DefaultEntity} from "@/entities/default.entity";
import {Log} from "../../log/entities/log.entity";

@Entity('cron')
export class Cron extends DefaultEntity {
  @Column({
    type: 'varchar',
    length: 255,
    comment: '任务名称',
    unique: true
  })
  name: string;

  @Column({
    type: 'varchar',
    length: 255,
    comment: '任务类型',
    default: CronTypeEnum.SERVICE
  })
  type: CronTypeEnum;

  @Column({
    type: 'varchar',
    length: 255,
    comment: '任务描述',
  })
  description: string;

  @Column({
    type: 'char',
    length: 20,
    comment: 'Cron 表达式',
    nullable: true
  })
  cron: string;

  @Column({
    name: 'cycle_type',
    type: 'varchar',
    length: 255,
    comment: '执行周期类型',
    nullable: true
  })
  cycleType: CronCycleTypeEnum;

  @Column({
    type: 'varchar',
    length: 255,
    comment: '执行周期拼接',
    nullable: true
  })
  cycle: string;

  @Column({
    type: 'int',
    comment: '已保存数量 保存到本地',
    nullable: true
  })
  save: number;

  @Column({
    type: 'int',
    comment: '排序',
    default: 0
  })
  sort: number;

  @Column({
    type: 'tinyint',
    comment: '是否启用通知',
    default: Status.DISABLED,
  })
  notice: Status;

  @Column({
    name: 'notice_channel',
    type: 'varchar',
    length: 255,
    comment: '通知渠道',
    nullable: true
  })
  noticeChannel: string;

  @Column({
    type: 'tinyint',
    comment: '状态 0 禁用 1 启用',
    default: Status.ENABLED,
  })
  status: Status;

  @OneToMany(() => Log, log => log.cron)
  logs: Log[];
}
