import {HttpException, HttpStatus, Inject, Injectable} from "@nestjs/common";
import {In} from "typeorm";
import {existsByOnFail, mapTree, sortTree} from "@/utils/tools";
import {treeRemovePublic, treeUpsertPublic} from "@/utils/crud";
import {IdsDto} from "@/dtos/remove.dto";
import {Role} from "./entities/role.entity";
import {PermissionRepository} from "../permission/permission.repository";
import {RoleRepository} from "./role.repository";
import {UpsertRoleDto} from './dto/upsert-role.dto'
import {QueryRoleDto} from './dto/query-role.dto'
import {RoleVo} from './vo/role.vo'

@Injectable()
export class RoleService {
  @Inject(RoleRepository)
  private readonly roleRepository: RoleRepository

  @Inject(PermissionRepository)
  private readonly permissionRepository: PermissionRepository

  /**
   * @description 获取角色列表 用于下拉框 返回所有角色的 id 和 name
   * @returns
   */
  public async list(query: QueryRoleDto) {
    const roles = await this.roleRepository.findTrees();

    const records = mapTree(
      roles,
      (item: Role & { parentId: number }, _index, _list, parent) => {
        item.parentId = parent?.id || 0;
      },
    );

    return {
      records: sortTree(records, (a, b) => a.sort - b.sort),
      remark: '',
    };
  }

  /**
   * @description 新增角色权限
   * @param body
   * @returns
   */
  public async upsert(body: UpsertRoleDto) {
    const roleRepository = this.roleRepository;
    try {
      return await treeUpsertPublic(
        roleRepository,
        body,
        async (role: Role) => {
          if (body.permissionIds?.length) {
            role.permissions = await this.permissionRepository.findBy({
              id: In(body.permissionIds),
            });
          }
          if (body.parentId) {
            role.parent = await roleRepository.findOneBy({
              id: body.parentId,
            });
          }
          role.updateTime = new Date();
          return role;
        },
      );
    } catch (error) {
      if (error.code === 'ER_DUP_ENTRY') {
        await existsByOnFail(roleRepository, 'name', body.name, '角色名已存在');
        await existsByOnFail(roleRepository, 'slug', body.slug, '角色标识重复');
      } else {
        const message: string = error.message || (body.id ? '编辑失败' : '新增失败');
        throw new HttpException(message, HttpStatus.BAD_REQUEST);
      }
    }
  }

  /**
   * @description 删除角色
   * @param body
   */
  public remove = async (body: IdsDto) => {
    await treeRemovePublic(this.roleRepository, body);
  };

  /**
   * @description 角色详情
   * @param id
   * @returns
   */
  public async detail(id: number): Promise<RoleVo> {
    const found_role = await this.roleRepository.findOneById(id, ['permissions'])

    if (!found_role) {
      throw new HttpException('角色不存在', HttpStatus.NOT_FOUND);
    }
    const permissionIds = found_role.permissions.map((permission) => permission.id);
    return {
      id: found_role.id,
      name: found_role.name,
      slug: found_role.slug,
      description: found_role.description,
      sort: found_role.sort,
      status: found_role.status,
      children: found_role.children,
      parentId: found_role.parentId,
      createTime: found_role.createTime,
      updateTime: found_role.updateTime,
      permissionIds,
    };
  }

}
