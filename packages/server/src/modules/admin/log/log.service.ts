import {Inject, Injectable} from '@nestjs/common';
import {removePublic} from "@/utils/crud";
import {pageFormat} from "@/utils/tools";
import {IdsDto} from "@/dtos/remove.dto";
import {Log} from './entities/log.entity';
import {LogRepository} from "./log.repository";
import {QueryLogDto} from './dto/query-log.dto';

@Injectable()
export class LogService {
  @Inject(LogRepository)
  private readonly logRepository: LogRepository;

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
  public async loggerCreate(
    options: Omit<Log, 'id' | 'updateTime' | 'createTime'>,
  ) {
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
      await this.clearAll()
    } else {
      await this.removeIds(body)
    }
    return '删除成功'
  }

  /**
   * 删除所有日志
   * @private
   */
  private async clearAll() {
    await this.logRepository.clear()
  }

  /**
   * 删除对应的id
   * @param body
   * @private
   */
  private async removeIds(body: IdsDto) {
    await removePublic(this.logRepository, body)
  }
}
