import {Injectable} from "@nestjs/common";
import {DataSource, FindOperator, TreeRepository} from "typeorm";
import {Role} from "./entities/role.entity";
import {StatusDto} from "@/dtos/status.dto";

@Injectable()
export class RoleRepository extends TreeRepository<Role> {
  constructor(private readonly dataSource: DataSource) {
    super(Role, dataSource.createEntityManager());
  }

  public async findById(id: number | FindOperator<number>, relations?: string[]) {
    return await this.find({
      where: {id},
      relations
    })
  }

  public async findOneById(id: number, relations?: string[]) {
    return await this.findOne({
      where: {id},
      relations
    })
  }

  public async status(body: StatusDto) {
    return await this
      .createQueryBuilder()
      .update(Role)
      .set({status: body.status})
      .whereInIds(body.ids)
      .execute();
  }
}
