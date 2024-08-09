import {Injectable} from "@nestjs/common";
import {DataSource, EntityTarget, FindOperator, Repository, TreeRepository} from "typeorm";
import {RelationOptions} from "@/types";

@Injectable()
export class BaseRepository<Entity> {
  protected readonly repository: Repository<Entity> | TreeRepository<Entity>;
  protected readonly entity: EntityTarget<Entity>
  protected readonly dataSource: DataSource

  constructor(
    entity: EntityTarget<Entity>,
    dataSource: DataSource
  ) {
    // super(entity, dataSource.createEntityManager());

    this.entity = entity
    this.dataSource = dataSource

    const entityMetadata = dataSource.getMetadata(entity);

    if (entityMetadata.treeType) {
      this.repository = dataSource.getTreeRepository(entity)
    } else {
      this.repository = dataSource.getRepository(entity)
    }

  }

  public async findById(id: number | FindOperator<number>, relations?: RelationOptions<Entity>): Promise<Entity[] | undefined> {
    const where: any = {id}
    return await this.repository.find({
      where,
      relations
    })
  }

  public async findOneById(id: number, relations?: RelationOptions<Entity>): Promise<Entity | undefined> {
    const where: any = {id}
    return await this.repository.findOne({
      where,
      relations
    })
  }
}
