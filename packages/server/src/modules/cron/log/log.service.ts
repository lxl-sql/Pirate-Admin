import {Inject, Injectable} from '@nestjs/common';
import {CreateLogDto} from './dto/create-log.dto';
import {Log} from '@/modules/cron/log/entities/log.entity';
import {Status} from '@/enums';
import {pageFormat} from "@/utils/tools";
import {IdsDto} from "@/dtos/remove.dto";
import {removePublic} from "@/utils/crud";
import {LogRepository} from "./log.repository";
import {QueryLogDto} from "./dto/query-log.dto";

interface ExecutionResult {
  logs: string[];
  success: boolean;
  filePath?: string;
}

@Injectable()
export class LogService {
  @Inject(LogRepository)
  private readonly logRepository: LogRepository;

  public async create(createLogDto: CreateLogDto): Promise<Log> {
    const new_log = this.logRepository.create({
      ...createLogDto,
      cron: {id: createLogDto.cronId},
    });
    return await this.logRepository.save(new_log);
  }

  /**
   * 创建并维护日志
   * @param cronId 任务ID
   * @param result 执行结果
   * @param maxSave 最大保存数量
   * @returns 新创建的日志
   */
  async createAndMaintainLogs(
    cronId: number,
    result: ExecutionResult,
    maxSave: number,
  ): Promise<Log> {
    // 创建新日志
    const newLog = await this.create({
      cronId,
      result: result.logs.join('\n'),
      status: result.success ? Status.ENABLED : Status.DISABLED,
      backupFilePath: result.filePath,
    });

    // 移除超出保存限制的旧日志
    await this.removeByMaxSave(cronId, maxSave);

    return newLog;
  }

  /**
   * 根据最大保存数量删除日志
   * @param cronId
   */
  public async removeByMaxSave(cronId: number, maxSave: number) {
    if (maxSave <= 0) return;

    const logs = await this.logRepository.find({
      where: {cron: {id: cronId}},
      order: {id: 'DESC'},
      take: maxSave,
    });
    if (logs.length > 0) {
      return await this.logRepository.remove(logs);
    }
    return null;
  }

  public async list(page: number, size: number, query: QueryLogDto) {
    const condition = {
      cron: {id: query.cronId},
      status: query.status,
    };

    const [records, total] = await this.logRepository.findAndCountAll(
      page,
      size,
      condition,
    );

    const result: Log[] = records.map(log => {
      return {
        ...log,
        cronId: log.cron.id,
        cron: null
      }
    })

    return pageFormat(page, size, total, result);
  }

  public async detail(id: number) {
    return await this.logRepository.findOneBy({id});
  }

  /**
   *
   * @param body [0] 清空日志 [...ids] 删除对应id
   */
  public async remove(body: IdsDto) {
    await removePublic(this.logRepository, body);
    return '删除成功';
  }
}
