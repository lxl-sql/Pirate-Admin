import {Column, Entity, ManyToOne} from "typeorm";
import {DefaultEntity} from "@/entities/default.entity";
import {Cron} from "../../cron/entities/cron.entity";
import {Status} from "@/enums/status.enum";

@Entity('cron-log')
export class Log extends DefaultEntity {

  @Column({
    type: 'text',
    comment: '执行结果描述，例如成功或失败原因',
  })
  result: string;

  @Column({
    type: 'tinyint',
    comment: '状态 0 失败 1 成功',
    default: Status.ENABLED,
  })
  status: Status;

  @ManyToOne(() => Cron, cron => cron.logs, {
    onDelete: 'CASCADE', // 当任务被删除时，删除相关日志
  })
  cron: Cron
}
