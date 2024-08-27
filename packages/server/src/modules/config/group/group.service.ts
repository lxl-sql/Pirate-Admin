import {Inject, Injectable} from "@nestjs/common";
import {existsByOnFail} from "@/utils/tools";
import {GroupRepository} from "./group.repository";
import {CreateGroupDto} from "./dto/create-group.dto";

@Injectable()
export class GroupService {

  @Inject(GroupRepository)
  private readonly groupRepository: GroupRepository;

  /**
   * 查询所有配置项分组
   */
  public async findAll() {
    return await this.groupRepository.findAll()
  }

  /**
   * 新增配置项分组
   */
  public async create(body: CreateGroupDto) {
    try {
      const new_config = this.groupRepository.create(body);
      await this.groupRepository.save(new_config)
      return '保存成功'
    } catch (error) {
      if (error.code === 'ER_DUP_ENTRY') {
        await existsByOnFail(this.groupRepository, 'name', body.name, '$value 字段名已存在');
      }
    }
  }
}
