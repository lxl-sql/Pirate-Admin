import {Injectable} from '@nestjs/common';
import {CreateLogDto} from './dto/create-log.dto';
import {UpdateLogDto} from './dto/update-log.dto';
import {InjectRepository} from '@nestjs/typeorm';
import {Log} from '@/modules/cron/log/entities/log.entity';
import {Repository} from 'typeorm';
import {Status} from '@/enums';

interface ExecutionResult {
  logs: string[];
  success: boolean;
  filePath?: string;
}

@Injectable()
export class LogService {
  @InjectRepository(Log)
  private readonly logRepository: Repository<Log>;

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

  findAll() {
    return `This action returns all log`;
  }

  findOne(id: number) {
    return `This action returns a #${id} log`;
  }

  update(id: number, updateLogDto: UpdateLogDto) {
    return `This action updates a #${id} log`;
  }

  remove(id: number) {
    return `This action removes a #${id} log`;
  }
}
