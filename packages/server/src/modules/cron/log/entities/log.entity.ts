import {Column, Entity, ManyToOne} from 'typeorm';
import {Status} from '@/enums';
import {CreateTimeEntity} from '@/entities/create-time.entity';
import {Cron} from '../../cron/entities/cron.entity';

@Entity('cron-log')
export class Log extends CreateTimeEntity {
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

  @Column({
    name: 'backup_file_path',
    type: 'varchar',
    length: 255,
    comment: '备份文件路径',
    nullable: true,
  })
  backupFilePath: string | null;

  @ManyToOne(() => Cron, (cron) => cron.logs, {
    onDelete: 'CASCADE', // 当任务被删除时，删除相关日志
  })
  cron: Cron;
}
