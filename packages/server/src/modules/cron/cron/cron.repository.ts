import { Injectable } from "@nestjs/common";
import { DataSource, Repository } from "typeorm";
import { findManyOption } from "@/utils/tools";
import { WhereOptions } from "@/types";
import { Cron } from "./entities/cron.entity";

@Injectable()
export class CronRepository extends Repository<Cron> {
  constructor(private readonly dataSource: DataSource) {
    super(Cron, dataSource.createEntityManager());
  }


  public async findAndCountAll(page: number, size: number, where: WhereOptions<Cron>) {
    return await this.findAndCount(
      findManyOption<Cron>(page, size, {
        // select: [
        //   'id',
        //   'createTime',
        // ],
        where: where,
        order: {
          createTime: 'DESC',
        },
      })
    );
  }
}
