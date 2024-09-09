import { Injectable } from '@nestjs/common';
import { DataSource, Repository } from 'typeorm';
import { findManyOption } from '@/utils/tools';
import { WhereOptions } from '@/types';
import { Log } from './entities/log.entity';

@Injectable()
export class LogRepository extends Repository<Log> {
  constructor(private readonly dataSource: DataSource) {
    super(Log, dataSource.createEntityManager());
  }

  public async findAndCountAll(
    page: number,
    size: number,
    where: WhereOptions<Log>,
  ) {
    return await this.findAndCount(
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
        where: where,
        order: {
          createTime: 'DESC',
        },
      }),
    );
  }
}
