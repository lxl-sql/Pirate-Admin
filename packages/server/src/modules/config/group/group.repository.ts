import {Injectable} from "@nestjs/common";
import {DataSource, Repository} from "typeorm";
import {Group} from "./entities/group.entity";

@Injectable()
export class GroupRepository extends Repository<Group> {
  constructor(private readonly dataSource: DataSource) {
    super(Group, dataSource.createEntityManager());
  }

  /**
   * 查询所有配置项分组
   */
  public async findAll() {
    return await this.find()
  }
}
