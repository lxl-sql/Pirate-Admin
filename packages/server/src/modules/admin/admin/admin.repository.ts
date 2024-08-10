import {DataSource, Repository} from "typeorm";
import {Admin} from "./entities/admin.entity";
import {HttpException, HttpStatus, Injectable} from "@nestjs/common";
import {WhereOptions} from "@/types";

@Injectable()
export class AdminRepository extends Repository<Admin> {
  constructor(private readonly dataSource: DataSource) {
    super(Admin, dataSource.createEntityManager());
  }

  public async existsByUsername(username: string) {
    return await this.existsBy({username})
  }

  /**
   * 根据 username 查询信息
   * @param username
   * @param relations
   * @returns
   */
  public async findOneByUsername(username: string, relations?: string[]) {
    return await this.findOne({
      where: {username},
      relations
    })
  }

  /**
   * 根据 Id 查询信息
   * @param id
   * @param relations
   * @returns
   */
  public async findOneById(id: number, relations?: string[]) {
    const found_admin = await this.findOne({
      select: [
        'id',
        'username',
        'nickname',
        'avatar',
        'email',
        'phone',
        'status',
        'motto',
        'password',
        'lastLoginIp',
        'lastLoginTime',
        'updateTime',
      ],
      where: {id},
      relations,
    });

    if (!found_admin) {
      throw new HttpException('用户不存在', HttpStatus.NOT_FOUND);
    }

    return found_admin;
  }

  /**
   * 获取列表数据
   * @param page
   * @param size
   * @param where
   */
  public async findAndCountAll(page: number, size: number, where: WhereOptions<Admin>) {
    return await this.findAndCount({
      skip: (page - 1) * size,
      take: size,
      select: [
        'id',
        'username',
        'nickname',
        'avatar',
        'email',
        'phone',
        'status',
        'lastLoginIp',
        'lastLoginTime',
        'updateTime',
        'createTime',
      ],
      where: where,
      relations: ['roles'],
      order: {
        createTime: 'DESC',
      },
    });
  }
}
