import {HttpException, HttpStatus, Inject, Injectable} from "@nestjs/common";
import {In} from "typeorm";
import {treeRemovePublic, treeUpsertPublic} from "@/utils/crud";
import {existsByOnFail, listToTree} from "@/utils/tools";
import {IdsDto} from "@/dtos/remove.dto";
import {NotPaginationVo} from "@/vos/response.vo";
import {Permission} from "./entities/permission.entity";
import {PermissionRepository} from "./permission.repository";
import {UpsertPermissionDto} from './dto/upsert-permission.dto'
import {PermissionVo} from './vo/permission.vo'
import {StatusDto} from "@/dtos/status.dto";

@Injectable()
export class PermissionService {
  @Inject(PermissionRepository)
  private readonly permissionRepository: PermissionRepository

  /**
   * @description 获取用户菜单规则
   * @returns
   */
  public async list(): Promise<NotPaginationVo<PermissionVo>> {
    const permissions = await this.permissionRepository.findAll()

    return {
      records: listToTree(permissions),
      remark: '',
    };
  }

  /**
   * @description 新增角色组管理
   * @param permission
   * @returns
   */
  public async upsert(body: UpsertPermissionDto) {
    const permissionRepository = this.permissionRepository;
    try {
      return await treeUpsertPublic(
        permissionRepository,
        body,
        async (permission: Permission) => {
          permission.updateTime = new Date();
          return permission;
        },
      );
    } catch (error) {
      if (error.code === 'ER_DUP_ENTRY') {
        await existsByOnFail(
          permissionRepository,
          'name',
          body.name,
          '权限名称已存在',
        );
      } else {
        const message = error.message || body.id ? '编辑失败' : '新增失败';
        throw new HttpException(message, HttpStatus.BAD_REQUEST);
      }
    }
  }

  /**
   * @description 删除菜单
   * @param body
   */
  public remove = async (body: IdsDto) => {
    await treeRemovePublic(this.permissionRepository, body);
  };

  /**
   * @description 菜单详情
   * @param id
   * @returns
   */
  public async detail(id: number): Promise<PermissionVo> {
    const found_permission = await this.permissionRepository.findOneBy({
      id,
    });

    if (!found_permission) {
      throw new HttpException('菜单不存在', HttpStatus.NOT_FOUND);
    }
    found_permission.parentId = found_permission.parentId || null;

    return found_permission;
  }

  /**
   * @description 修改菜单状态
   * @param body
   * @returns
   */
  public async status(body: StatusDto) {
    try {
      await this.permissionRepository.status(body);
      return '修改成功';
    } catch (error) {
      throw new HttpException('修改失败', HttpStatus.BAD_REQUEST);
    }
  }

  /**
   * 拖拽排序
   * @param id 排序主键值
   * @param targetId 排序位置主键值
   */
  public async sortable(id: number, targetId: number) {
    const list = await this.permissionRepository.findById(In([id, targetId]));

    const data = list.find((item) => item.id === id);
    const target_permission = list.find((item) => item.id === targetId);
    if (!data || !target_permission) {
      throw new HttpException(
        `提供的${data ? 'targetId' : 'id'}无效。`,
        HttpStatus.BAD_REQUEST,
      );
    }
    // 获取最大排序
    const max_sort = target_permission.sort > data.sort ? target_permission.sort : data.sort;
    const items = await this.permissionRepository.findMaxSort(target_permission.parentId, max_sort)

    const current_index = items.findIndex((item) => item.id === id);
    const target_index = items.findIndex((item) => item.id === targetId);

    // 移动当前项到目标位置
    items.splice(target_index, 0, items.splice(current_index, 1)[0]);

    let sort = max_sort;
    for (let i = 0; i < items.length; i++) {
      items[i].sort = sort;
      sort--;
    }

    this.permissionRepository.save(items);

    return '修改成功';
  }
}
