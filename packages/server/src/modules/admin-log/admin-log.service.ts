import { HttpException, HttpStatus, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { AdminLog } from './entities/admin-log.entity';
import { QueryAdminLogDto } from './dtos/query-admin-log.dto';

@Injectable()
export class AdminLogService {
  @InjectRepository(AdminLog)
  private readonly adminLogRepository: Repository<AdminLog>;

  public async list(page: number, size: number, query: QueryAdminLogDto) {
    const conddition = {
      userId: query.userId,
    };

    const [records, total] = await this.adminLogRepository.findAndCount({
      select: [
        'id',
        'userId',
        'username',
        'title',
        'url',
        'ip',
        'method',
        'responseTime',
        'userAgent',
        'createTime',
      ],
      skip: (page - 1) * size,
      take: size,
      order: {
        createTime: 'DESC',
      },
      where: conddition,
    });

    return {
      page,
      size,
      total,
      records,
    };
  }

  /**
   * @description: 创建日志
   * @param options
   */
  public async loggerCreate(
    options: Omit<AdminLog, 'id' | 'updateTime' | 'createTime'>,
  ) {
    const new_logger = this.adminLogRepository.create(options);
    await this.adminLogRepository.save(new_logger);
  }

  public async detail(id: number) {
    return await this.adminLogRepository.findOneBy({ id });
  }
}
