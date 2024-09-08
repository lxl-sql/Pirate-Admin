import { Inject, Injectable, OnModuleDestroy, OnModuleInit } from '@nestjs/common';
import { CronJob } from "cron";
import { WINSTON_LOGGER_TOKEN } from "@/const/winston.const";
import { AppLogger } from "@/common/logger/app-logger.service";
import { Cron } from "./entities/cron.entity";
import { CreateCronDto } from './dto/create-cron.dto';
import { UpdateCronDto } from './dto/update-cron.dto';
import { pageFormat } from '@/utils/tools';
import { CronRepository } from './cron.repository';
import { QueryCronDto } from './dto/query-cron.dto';
import { BackupService, SqlBackupResult } from '@/common/backup/backup.service';
import { LogService } from '../log/log.service';
import { Status } from '@/enums/status.enum';

@Injectable()
export class CronService implements OnModuleInit, OnModuleDestroy {
  @Inject(CronRepository)
  private readonly cronRepository: CronRepository


  @Inject(BackupService)
  private readonly backupService: BackupService;

  @Inject(LogService)
  private readonly logService: LogService;

  private jobs: Map<number, CronJob> = new Map();

  constructor(
    @Inject(WINSTON_LOGGER_TOKEN) private readonly logger: AppLogger
  ) {
    this.logger.setContext(CronService.name)
  }

  async onModuleInit() {
    const crons = await this.cronRepository.find();
    crons.forEach(cron => {
      this.startJob(cron)
    })
  }

  onModuleDestroy() {
    this.clearJobs()
  }

  /**
   * 清除所有定时任务
   */
  private clearJobs() {
    for (const [id, job] of this.jobs) {
      job.stop();
      this.logger.log(`Stopped job with ID: ${id}`);
    }
    this.jobs.clear()
    this.logger.log('All scheduled jobs have been stopped and cleared.');
  }

  /**
   * 新增定时任务
   * @param createCronDto 
   * @returns 
   */
  async create(createCronDto: CreateCronDto) {
    const new_cron = this.cronRepository.create(createCronDto)

    const cron = await this.cronRepository.save(new_cron)

    this.startJob(cron)

    return '定时任务创建成功'
  }

  public async list(page: number, size: number, query: QueryCronDto) {
    const condition = {
    };

    const [records, total] = await this.cronRepository.findAndCountAll(page, size, condition)

    return pageFormat(
      page,
      size,
      total,
      records,
    )
  }

  /**
   * 启动所有的定时任务
   */
  public async start() {
    const crons = await this.cronRepository.find({ where: { status: Status.ENABLED } });
    console.log('crons', crons);


    for (const cron of crons) {
      if (!this.jobs.has(cron.id)) {
        this.startJob(cron);
      } else {
        this.logger.log(`Cron job "${cron.name}" (ID: ${cron.id}) is already running. Skipping.`);
      }
    }

    this.logger.log(`Started ${this.jobs.size} cron jobs.`);

    return `Started ${this.jobs.size} cron jobs.`
  }

  /**
   * 启动单个定时任务
   * @param cron Cron任务实体
   */
  private startJob(cron: Cron) {
    const expression = '30 8 0 * * *' || cron.cron
    if (!expression) {
      this.logger.warn(`Cron job "${cron.name}" (ID: ${cron.id}) has no expression. Skipping.`);
      return;
    }

    try {
      const job = new CronJob(
        expression,                    // 定时任务的cron表达式
        () => this.executeJob(cron),   // 要执行的函数
        null,                          // 任务完成时的回调函数，null表示没有
        true,                          // 是否立即启动任务
        'Asia/Shanghai'                // 时区设置
      );
      job.start();
      this.jobs.set(cron.id, job);
      this.logger.log(`Started cron job "${cron.name}" (ID: ${cron.id}) with expression: ${expression}`);
    } catch (error) {
      this.logger.error(`Error starting cron job "${cron.name}" (ID: ${cron.id}): ${error.message}`);
    }
  }


  /**
   * 执行定时任务
   * @param cron Cron任务实体
   */
  private async executeJob(cron: Cron) {
    this.logger.log(`Executing cron job: ${cron.name} (ID: ${cron.id})`);
    // 在这里执行定时任务的具体逻辑
    // 例如：
    if (cron.type === 'sql_backup') {
      await this.performSqlBackup(cron);
    }
    // 添加其他类型的任务处理...
  }

  /**
   * 执行SQL备份任务
   * @param cron 当前执行的Cron任务实体
   */
  private async performSqlBackup(cron: Cron) {
    try {
      const result = await this.backupService.createSqlBackup();
      await this.logService.create({
        cronId: cron.id,
        result: result.logs.join('\n'),
        status: result.success ? Status.ENABLED : Status.DISABLED,
        backupFilePath: result.filePath
      });
    } catch (error) {
      this.logger.error(`SQL backup failed for cron job "${cron.name}" (ID: ${cron.id}): ${error.message}`);
      await this.logService.create({
        cronId: cron.id,
        result: `Backup failed: ${error.message}`,
        status: Status.DISABLED
      });
    }
  }


  findOne(id: number) {
    return `This action returns a #${id} cron`;
  }

  update(id: number, updateCronDto: UpdateCronDto) {
    return `This action updates a #${id} cron`;
  }

  remove(id: number) {
    return `This action removes a #${id} cron`;
  }
}
