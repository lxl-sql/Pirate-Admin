import {Injectable} from "@nestjs/common";
import {DataSource, TreeRepository} from "typeorm";
import {Permission} from "./entities/permission.entity";

@Injectable()
export class PermissionRepository extends TreeRepository<Permission> {
  constructor(private readonly dataSource: DataSource) {
    super(Permission, dataSource.createEntityManager());
  }

  public async findOneById(id: number, relations?: string[]) {
    return await this.findOne({
      where: {id},
      relations
    })
  }

  public async findAll() {
    return await this.find({
      select: [
        'id',
        'parentId',
        'title',
        'icon',
        'name',
        'sort',
        'code',
        'component',
        'type',
        'cache',
        'status',
        'createTime',
        'updateTime',
      ],
      order: {
        sort: 'DESC', // 按照 sort 字段升序排序
      },
    });
  }
}
