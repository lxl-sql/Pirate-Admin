import {Inject, Injectable} from '@nestjs/common';
import {removePublic} from "@/utils/crud";
import {pageFormat} from "@/utils/tools";
import {IdsDto} from "@/dtos/remove.dto";
import {Log} from './entities/log.entity';
import {LogRepository} from "./log.repository";
import {QueryLogDto} from './dto/query-log.dto';
import {CronJob} from "cron";
import {MoreThanOrEqual} from "typeorm";

@Injectable()
export class LogService {
  @Inject(LogRepository)
  private readonly logRepository: LogRepository;

  private jobs: CronJob[] = []

  public async list(page: number, size: number, query: QueryLogDto) {
    const condition = {
      userId: query.userId,
    };

    const [records, total] = await this.logRepository.findAndCountAll(page, size, condition)

    return pageFormat(
      page,
      size,
      total,
      records,
    )
  }

  /**
   * @description: 创建日志
   * @param options
   */
  public async loggerCreate(options: Omit<Log, 'id' | 'updateTime' | 'createTime'>,) {
    const new_logger = this.logRepository.create(options);
    await this.logRepository.save(new_logger);
  }

  public async detail(id: number) {
    return await this.logRepository.findOneBy({id});
  }

  /**
   *
   * @param body [0] 清空日志 [...ids] 删除对应id
   */
  public async remove(body: IdsDto) {
    const [firstId] = body.ids
    if (firstId === 0) {
      // 清空日志
      await this.logRepository.clear()
    } else {
      // 删除对应的 id | ids
      await removePublic(this.logRepository, body)
    }
    return '删除成功'
  }

  /**
   * 清除在某时间范围外旧的操作日志
   */
  private async clearOldLogs() {
    // daysToKeep 0 默认不清除
    const daysToKeep = 0
    const cutoff_date = new Date()
    cutoff_date.setDate(cutoff_date.getDate() - daysToKeep)

    const delete_result = await this.logRepository.delete({
      createTime: MoreThanOrEqual(cutoff_date)
    })

    console.log(`Deleted ${delete_result.affected} logs older than ${daysToKeep} days.`);
  }

  /**
   * 计划日志清理
   */
  public async scheduleLogCleanup(cronTime: string) {
    const job = new CronJob(cronTime, this.clearOldLogs)
  }
}
