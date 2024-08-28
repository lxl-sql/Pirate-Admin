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

  /**
   * 根据`name` 获取数据
   * @param name
   */
  async findOneByName(name: string) {
    return await this.findOneBy({name});
  }


  /**
   * 获取日志保存天数
   */
  async getValueByName(name: string, title: string, default_value?: string): Promise<string> {
    const exits_daysToKeep = await this.existsBy({name})
    if (!exits_daysToKeep) {
      const params = {
        name,
        title,
        value: default_value,
      }
      const config = this.create(params)
      await this.save(config);
      return default_value
    }
    if (default_value) {
      await this.update({name}, {
        value: default_value
      })
    }
    const found_config = await this.findOneBy({
      name
    });
    return found_config ? found_config.value : default_value;
  }
}
