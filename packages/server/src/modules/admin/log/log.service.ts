import {
  Inject,
  Injectable,
  Logger,
  OnModuleDestroy,
  OnModuleInit,
} from '@nestjs/common';
import { LessThan } from 'typeorm';
import { CronJob } from 'cron';
import { removePublic } from '@/utils/crud';
import { pageFormat } from '@/utils/tools';
import { IdsDto } from '@/dtos/remove.dto';
import { Log } from './entities/log.entity';
import { LogRepository } from './log.repository';
import { QueryLogDto } from './dto/query-log.dto';
import { ConfigRepository } from '../../config/config/config.repository';

@Injectable()
export class LogService implements OnModuleInit, OnModuleDestroy {
  private readonly logger = new Logger(LogService.name);

  @Inject(LogRepository)
  private readonly logRepository: LogRepository;

  @Inject(ConfigRepository)
  private readonly configRepository: ConfigRepository;

  private jobs: CronJob[] = [];

  async onModuleInit() {
    await this.clear('7');
  }

  onModuleDestroy() {
    this.clearJobs();
  }

  public async list(page: number, size: number, query: QueryLogDto) {
    const condition = {
      userId: query.userId,
    };

    const [records, total] = await this.logRepository.findAndCountAll(
      page,
      size,
      condition,
    );

    return pageFormat(page, size, total, records);
  }

  /**
   * @description: 创建日志
   * @param options
   */
  public async loggerCreate(
    options: Omit<Log, 'id' | 'updateTime' | 'createTime'>,
  ) {
    const new_logger = this.logRepository.create(options);
    await this.logRepository.save(new_logger);
  }

  public async detail(id: number) {
    return await this.logRepository.findOneBy({ id });
  }

  /**
   *
   * @param body [0] 清空日志 [...ids] 删除对应id
   */
  public async remove(body: IdsDto) {
    const [firstId] = body.ids;
    if (firstId === 0) {
      // 清空日志
      await this.logRepository.clear();
    } else {
      // 删除对应的 id | ids
      await removePublic(this.logRepository, body);
    }
    return '删除成功';
  }

  private clearJobs() {
    this.jobs.forEach((job) => job.stop());
    this.jobs = [];
    this.logger.log('All scheduled jobs have been stopped and cleared.');
  }

  /**
   * 清除在某时间范围外旧的操作日志
   */
  private async clearOldLogs(daysToKeep: number) {
    // daysToKeep 0 默认不清除
    if (daysToKeep === 0) {
      this.logger.log('No logs were cleared because daysToKeep is set to 0.');
      return;
    }

    const cutoff_date = new Date();
    cutoff_date.setDate(cutoff_date.getDate() - daysToKeep);

    const delete_result = await this.logRepository.delete({
      createTime: LessThan(cutoff_date),
    });

    console.log(
      `Deleted ${delete_result.affected} logs older than ${daysToKeep} days.`,
    );
  }

  /**
   * 计划日志清理
   */
  private async scheduleLogCleanup(cronTime: string, daysToKeep: number) {
    const job = new CronJob(cronTime, () => {
      this.clearOldLogs(daysToKeep).catch((err) => {
        this.logger.error('Failed to clear old logs', err);
      });
    });

    job.start();
    this.jobs.push(job); // 将任务保存到 jobs 数组中
    this.logger.log(
      `Scheduled log cleanup job with cron time: ${cronTime}, daysToKeep: ${daysToKeep}`,
    );
  }

  /**
   * 清空指定天数之外的日志
   * @param day 日期 默认保留最近 7 天的日志
   */
  public async clear(day = '7') {
    // 先清除
    this.clearJobs();

    const cronTime = '0 0 4 * * *'; // 每天凌晨四点

    const daysToKeep = await this.configRepository.getValueByName(
      'daysToKeep',
      '日志保留天数',
      day,
    );

    await this.scheduleLogCleanup(cronTime, +daysToKeep);

    return daysToKeep;
  }
}
