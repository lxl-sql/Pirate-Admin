import {Injectable} from "@nestjs/common";
import {DataSource, Repository} from "typeorm";
import {Config} from "./entities/config.entity";

@Injectable()
export class ConfigRepository extends Repository<Config> {
  constructor(private readonly dataSource: DataSource) {
    super(Config, dataSource.createEntityManager());
  }

  async findAll(relations?: string[]) {
    return await this.find({
      order: {
        weight: "DESC"
      },
      relations
    });
  }
}
