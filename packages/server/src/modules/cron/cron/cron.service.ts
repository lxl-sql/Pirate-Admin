import {
  HttpException,
  HttpStatus,
  Inject,
  Injectable,
  OnModuleDestroy,
  OnModuleInit,
} from '@nestjs/common';
import { CronJob } from 'cron';
import { like, pageFormat } from '@/utils/tools';
import { Status } from '@/enums/status.enum';
import { WeekEnum, WeekNameEnum } from '@/enums/week.enum';
import { CronCycleTypeEnum } from '@/enums/cron-cycle-type.enum';
import { WINSTON_LOGGER_TOKEN } from '@/const/winston.const';
import { BackupService } from '@/common/backup/backup.service';
import { AppLogger } from '@/common/logger/app-logger.service';
import { ShellTaskService } from '@/common/shell-task/shell-task.service';
import { Cron } from './entities/cron.entity';
import { UpsertCronDto } from './dto/upsert-cron.dto';
import { CronRepository } from './cron.repository';
import { QueryCronDto } from './dto/query-cron.dto';
import { LogService } from '../log/log.service';
import { removePublic, upsertPublic } from '@/utils/crud';
import { IdsDto } from '@/dtos/remove.dto';
import { StatusDto } from '@/dtos/status.dto';
import { In } from 'typeorm';

interface CronExpression {
  cron: string;
  cycleName: string;
}

@Injectable()
export class CronService implements OnModuleInit, OnModuleDestroy {
  @Inject(CronRepository)
  private readonly cronRepository: CronRepository;

  @Inject(BackupService)
  private readonly backupService: BackupService;

  @Inject(ShellTaskService)
  private readonly shellTaskService: ShellTaskService;

  @Inject(LogService)
  private readonly logService: LogService;

  private readonly jobs: Map<number, CronJob> = new Map();

  constructor(
    @Inject(WINSTON_LOGGER_TOKEN) private readonly logger: AppLogger,
  ) {
    this.logger.setContext(CronService.name);
  }

  async onModuleInit() {
    const crons = await this.cronRepository.find();
    crons.forEach((cron) => {
      this.startJob(cron);
    });
  }

  onModuleDestroy() {
    this.clearJobs();
  }

  /**
   * 清除所有定时任务
   */
  private clearJobs() {
    for (const [id, job] of this.jobs) {
      job.stop();
      this.logger.log(`Stopped job with ID: ${id}`);
    }
    this.jobs.clear();
    this.logger.log('All scheduled jobs have been stopped and cleared.');
  }
  /**
   * 查询定时任务列表
   * @param page 页码
   * @param size 每页数量
   * @param query 查询条件
   * @returns
   */
  public async list(page: number, size: number, query: QueryCronDto) {
    const condition = {
      name: like(query.name),
      type: query.type,
    };

    const [records, total] = await this.cronRepository.findAndCountAll(
      page,
      size,
      condition,
    );

    return pageFormat(page, size, total, records);
  }

  /**
   * 删除定时任务
   * @param body 删除条件
   * @returns
   */
  public async remove(body: IdsDto) {
    await removePublic(this.cronRepository, body);
    return '删除成功';
  }

  /**
   * 新增/编辑定时任务
   * @param upsertCronDto
   * @returns
   */
  async upsert(body: UpsertCronDto) {
    const cron = await upsertPublic<Cron, UpsertCronDto>(
      this.cronRepository,
      body,
      async (cron) => {
        const cron_expression = this.generateCronExpression(
          cron.cycleType,
          cron.cycle,
        );
        if (cron_expression) {
          cron.cron = cron_expression.cron;
          cron.cycleName = cron_expression.cycleName;
        }
        return cron;
      },
    );
    this.startJob(cron);
    return body.id ? '定时任务更新成功' : '定时任务创建成功';
  }

  /**
   * 启动所有的定时任务
   */
  public async start() {
    const crons = await this.cronRepository.find({
      where: { status: Status.ENABLED },
    });

    for (const cron of crons) {
      if (!this.jobs.has(cron.id)) {
        this.startJob(cron);
      } else {
        this.logger.log(
          `Cron job "${cron.name}" (ID: ${cron.id}) is already running. Skipping.`,
        );
      }
    }

    const msg = `Started ${this.jobs.size} cron jobs.`;

    this.logger.log(msg);
    return msg;
  }

  /**
   * 启动单个定时任务
   * @param id 定时任务ID
   * @param cron 定时任务表达式 测试cron表达式
   */
  public async startOne(id: number, cron?: string) {
    const found_cron = await this.cronRepository.findOne({ where: { id } });
    if (!found_cron) {
      throw new HttpException('定时任务不存在', HttpStatus.NOT_FOUND);
    }
    if (cron) {
      found_cron.cron = cron;
    }
    // await this.cronRepository.save(found_cron);
    this.startJob(found_cron);
    return '定时任务启动成功';
  }

  /**
   * 修改定时任务状态
   * @param body 修改条件
   * @returns
   */
  public async status(body: StatusDto) {
    await this.cronRepository.status(body);
    if (body.status === Status.DISABLED) {
      body.ids.forEach((id) => {
        this.stopJob({ status: body.status, id });
      });
    } else {
      const crons = await this.cronRepository.find({
        where: { id: In(body.ids) },
      });
      crons.forEach((cron) => {
        this.startJob(cron);
      });
    }
    return '修改成功';
  }
  /**
   * 停止单个定时任务
   * @param cron 定时任务实体
   */
  private async stopJob(cron: Pick<Cron, 'status' | 'id'>) {
    const job = this.jobs.get(cron.id);
    if (job) {
      job.stop();
      this.jobs.delete(cron.id);
      const msg = `修改定时任务状态为: ${cron.status}，停止定时任务: ${cron.id}`;
      this.logger.log(msg);
      this.logService.create({
        cronId: cron.id,
        result: msg,
        status: cron.status,
      });
    }
  }

  /**
   * 启动单个定时任务
   * @param cron Cron任务实体
   */
  private startJob(cron: Cron) {
    const expression = cron.cron;
    if (!expression) {
      this.logger.warn(
        `Cron job "${cron.name}" (ID: ${cron.id}) has no expression. Skipping.`,
      );
      return;
    }

    try {
      const job = new CronJob(
        expression, // 定时任务的cron表达式
        () => this.executeJob(cron), // 要执行的函数
        null, // 任务完成时的回调函数，null表示没有
        true, // 是否立即启动任务
        'Asia/Shanghai', // 时区设置
      );
      job.start();
      this.jobs.set(cron.id, job);
      this.logger.log(
        `Started cron job "${cron.name}" (ID: ${cron.id}) with expression: ${expression}`,
      );
    } catch (error) {
      this.logger.error(
        `Error starting cron job "${cron.name}" (ID: ${cron.id}): ${error.message}`,
      );
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
    } else if (cron.type === 'shell_script') {
      await this.performShellScript(cron);
    } else {
      // 添加其他类型的任务处理...
      const msg = `Cron job "${cron.name}" (ID: ${cron.id}) has no type. Skipping.`;
      this.logger.warn(msg);
      await this.logService.create({
        cronId: cron.id,
        result: msg,
        status: Status.DISABLED,
      });
    }
    // 更新上次执行时间
    await this.cronRepository.update(cron.id, {
      lastExecutionTime: new Date(),
    });
  }

  /**
   * 执行SQL备份任务
   * @param cron 当前执行的Cron任务实体
   */
  private async performSqlBackup(cron: Cron) {
    try {
      const result = await this.backupService.createSqlBackup();
      await this.logService.createAndMaintainLogs(
        cron.id,
        result,
        cron.maxSave,
      );
    } catch (error) {
      this.logger.error(
        `SQL backup failed for cron job "${cron.name}" (ID: ${cron.id}): ${error.message}`,
      );
      await this.logService.create({
        cronId: cron.id,
        result: `Backup failed: ${error.message}`,
        status: Status.DISABLED,
      });
    }
  }

  /**
   * 执行shell脚本
   * @param cron 当前执行的Cron任务实体
   */
  private async performShellScript(cron: Cron) {
    if (!cron.content) {
      return await this.logService.create({
        cronId: cron.id,
        result: 'Shell script execution failed: 任务内容为空',
        status: Status.DISABLED,
      });
    }
    try {
      const result = await this.shellTaskService.executeCommand(cron.content);
      await this.logService.createAndMaintainLogs(
        cron.id,
        result,
        cron.maxSave,
      );
    } catch (error) {
      this.logger.error(
        `Shell script execution failed for cron job "${cron.name}" (ID: ${cron.id}): ${error.message}`,
      );
      await this.logService.create({
        cronId: cron.id,
        result: `Shell script execution failed: ${error.message}`,
        status: Status.DISABLED,
      });
    }
  }

  /**
   * 查询单个定时任务 包括关联的日志
   * @param id 定时任务ID
   * @returns
   */
  async detail(id: number) {
    const cron = await this.cronRepository.findOne({
      where: { id },
      relations: ['logs'],
    });
    return cron;
  }

  // 根据 cycleType 和 cycle 生成 cron 表达式
  private generateCronExpression(
    cycleType: CronCycleTypeEnum,
    cycle?: string,
  ): CronExpression | null {
    if (!cycle) {
      return null;
    }
    // cycle 格式为 周,月,日,时,分,秒
    const cycle_arr = cycle.split(',');
    switch (cycleType) {
      case CronCycleTypeEnum.DAY: {
        // 每天 N 点 N 分 0 秒 执行
        const [hour, minute] = cycle_arr;
        return {
          cron: `0 ${minute} ${hour} * * *`,
          cycleName: `每天，${hour}点 ${minute}分 执行`,
        };
      }
      case CronCycleTypeEnum.DAY_N: {
        // 每月第 N 天 N 点 N 分 0 秒 执行
        const [day, hour, minute] = cycle_arr;
        return {
          cron: `0 ${minute} ${hour} ${day} * *`,
          cycleName: `每月，第${day}天，${hour}点 ${minute}分 执行`,
        };
      }
      case CronCycleTypeEnum.HOUR: {
        // 每小时 N 分 0 秒 执行
        const [minute] = cycle_arr;
        return {
          cron: `0 ${minute} * * * *`,
          cycleName: `每小时，${minute}分 执行`,
        };
      }
      case CronCycleTypeEnum.HOUR_N: {
        // 每隔 N 小时 N 分 0 秒 执行
        const [hour, minute] = cycle_arr;
        return {
          cron: `0 ${minute} */${hour} * * *`,
          cycleName: `每隔${hour}小时，${minute}分 执行`,
        };
      }
      case CronCycleTypeEnum.MINUTE_N: {
        // 每隔 N 分钟 执行
        const [minute] = cycle_arr;
        return {
          cron: `0 */${minute} * * * *`,
          cycleName: `每隔${minute}分钟 执行`,
        };
      }
      case CronCycleTypeEnum.WEEK: {
        // 每周几 N 点 N 分 0 秒 执行
        // week 格式为 1,2,3,4,5,6,7 指 1（星期天）到 7（星期六）
        const [week, hour, minute] = cycle_arr;
        const week_name = WeekNameEnum[WeekEnum[week]];
        return {
          cron: `0 ${minute} ${hour} * * ${week}`,
          cycleName: `每周${week_name}，${hour}点 ${minute}分 执行`,
        };
      }
      case CronCycleTypeEnum.MONTH: {
        // 每月 N 点 N 分 0 秒 执行
        const [day, hour, minute] = cycle_arr;
        return {
          cron: `0 ${minute} ${hour} ${day} * *`,
          cycleName: `每月，第${day}天，${hour}点 ${minute}分 执行`,
        };
      }
      default:
        return null;
    }
  }
}
