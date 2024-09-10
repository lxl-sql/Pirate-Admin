import { Injectable } from '@nestjs/common';
import { DataSource, Repository } from 'typeorm';
import { findManyOption } from '@/utils/tools';
import { WhereOptions } from '@/types';
import { Cron } from './entities/cron.entity';
import { StatusDto } from '@/dtos/status.dto';

@Injectable()
export class CronRepository extends Repository<Cron> {
  constructor(private readonly dataSource: DataSource) {
    super(Cron, dataSource.createEntityManager());
  }

  public async findAndCountAll(
    page: number,
    size: number,
    where: WhereOptions<Cron>,
  ) {
    return await this.findAndCount(
      findManyOption<Cron>(page, size, {
        where: where,
        order: {
          createTime: 'DESC',
        },
      }),
    );
  }

  public async status(body: StatusDto) {
    return await this.createQueryBuilder()
      .update(Cron)
      .set({ status: body.status })
      .whereInIds(body.ids)
      .execute();
  }
}
