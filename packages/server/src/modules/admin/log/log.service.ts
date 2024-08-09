import {Injectable} from '@nestjs/common';
import {InjectRepository} from '@nestjs/typeorm';
import {Repository} from 'typeorm';
import {findManyOption, pageFormat} from "@/utils/tools";
import {IdsDto} from "@/dtos/remove.dto";
import {Log} from './entities/log.entity';
import {QueryLogDto} from './dto/query-log.dto';
import {removePublic} from "@/utils/crud";

@Injectable()
export class LogService {
  @InjectRepository(Log)
  private readonly adminLogRepository: Repository<Log>;

  public async list(page: number, size: number, query: QueryLogDto) {
    const condition = {
      userId: query.userId,
    };

    const [records, total] = await this.adminLogRepository.findAndCount(
      findManyOption<Log>(page, size, {
        select: [
          'id',
          'userId',
          'username',
          'title',
          'url',
          'ip',
          'ipAddress',
          'method',
          'responseTime',
          'userAgent',
          'createTime',
        ],
        where: condition,
        order: {
          createTime: 'DESC',
        },
      })
    );

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
    const new_logger = this.adminLogRepository.create(options);
    await this.adminLogRepository.save(new_logger);
  }

  public async detail(id: number) {
    return await this.adminLogRepository.findOneBy({id});
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
    await this.adminLogRepository.clear()
  }

  /**
   * 删除对应的id
   * @param body
   * @private
   */
  private async removeIds(body: IdsDto) {
    await removePublic(this.adminLogRepository, body)
  }
}
