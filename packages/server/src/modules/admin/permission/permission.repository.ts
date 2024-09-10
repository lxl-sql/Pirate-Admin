import { Injectable } from '@nestjs/common';
import { DataSource, FindOperator, TreeRepository } from 'typeorm';
import { Permission } from './entities/permission.entity';
import { StatusDto } from '@/dtos/status.dto';
import { Role } from '@/modules/admin/role/entities/role.entity';

@Injectable()
export class PermissionRepository extends TreeRepository<Permission> {
  constructor(private readonly dataSource: DataSource) {
    super(Permission, dataSource.createEntityManager());
  }

  public async findById(
    id: number | FindOperator<number>,
    relations?: string[],
  ) {
    return await this.find({
      where: { id },
      relations,
    });
  }

  public async findOneById(id: number, relations?: string[]) {
    return await this.findOne({
      where: { id },
      relations,
    });
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

  public async status(body: StatusDto) {
    return await this.createQueryBuilder()
      .update(Role)
      .set({ status: body.status })
      .whereInIds(body.ids)
      .execute();
  }

  public async findMaxSort(parentId: number, sort: number) {
    return this.createQueryBuilder('p')
      .where('p.parentId = :parentId', { parentId: parentId })
      .andWhere('p.sort <= :sort', { sort: sort })
      .orderBy('p.sort', 'DESC')
      .getMany();
  }
}
