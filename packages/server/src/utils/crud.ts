import { IdsDto } from '@/common/dtos/remove.dto';
import { UpsertDto } from '@/common/dtos/upsert.dto';
import { DefaultEntity } from '@/common/entities/default.entity';
import { HttpException, HttpStatus } from '@nestjs/common';
import { validateOrReject } from 'class-validator';
import { In, Repository, TreeRepository } from 'typeorm';

/**
 * @description 删除用户
 * @param id
 * @returns
 */
export async function removePublic<Entity = any, D = IdsDto>(
  respository: Repository<Entity>,
  body: D,
  key = 'ids',
) {
  try {
    await respository.delete(body[key]);
    return '删除成功';
  } catch (error) {
    throw new HttpException('删除失败', HttpStatus.BAD_REQUEST);
  }
}

/**
 * @description 删除用户
 * @param id
 * @returns
 */
export async function treeRemovePublic<Entity = any, D = IdsDto>(
  respository: Repository<Entity>,
  body: D,
  key = 'ids',
) {
  const condition = { parentId: In(body[key]) };
  // 删除菜单的同时不能删除子菜单
  const children = await respository.findBy(condition as any);
  // 继续
  if (children.length) {
    throw new HttpException('请先删除子菜单', HttpStatus.BAD_REQUEST);
  }
  await removePublic(respository, body);
}
/**
 * 异步插入或更新公共函数
 *
 * @param repository 仓库对象，支持Repository和TreeRepository类型，用于数据操作
 * @param body 插入或更新的数据对象，遵循UpsertDto接口约束
 * @param callback 可选回调函数，当数据实体被创建或找到后调用，可用于额外的逻辑处理
 * @returns 返回一个字符串，表示操作结果，如果存在id则为'编辑成功'，否则为'添加成功'
 */
export async function upsertPublic<
  Entity = DefaultEntity,
  D extends UpsertDto = any,
>(
  repository: Repository<Entity> | TreeRepository<Entity>,
  body: D,
  callback?: (entity: Entity) => Promise<Entity> | Entity,
) {
  await validateOrReject(body);

  let entity: Entity;
  if (body.id) {
    const conddition = { id: body.id };
    entity = await repository.findOneBy(conddition as any);
    if (!entity) {
      throw new HttpException('数据不存在', HttpStatus.BAD_REQUEST);
    }
  } else {
    entity = repository.create();
  }

  repository.merge(entity, body as any, await callback?.(entity));
  await repository.save(entity);
  return body.id ? '编辑成功' : '添加成功';
}
/**
 * 异步更新或插入公开数据树结构中的实体。
 *
 * @param repository - 实体的仓库或树形结构的仓库，用于数据操作。
 * @param body - 包含要更新或插入的数据实体信息，以及父级ID。
 * @param callback - 可选回调函数，用于在实体更新或插入后执行额外的操作。
 * @returns {Promise<string>} 没有返回值的Promise。
 * @throws {HttpException} 如果尝试将实体的ID设置为其父ID，将抛出HTTP异常。
 */
export async function treeUpsertPublic<
  Entity = any,
  D extends UpsertDto & { parentId: number } = any,
>(
  repository: Repository<Entity> | TreeRepository<Entity>,
  body: D,
  callback?: (entity: Entity) => Promise<Entity> | Entity,
): Promise<string> {
  if (body.id && body.id === body.parentId) {
    throw new HttpException(
      '父级 ID 不能和当前 ID 相同',
      HttpStatus.BAD_REQUEST,
    );
  }
  return await upsertPublic(repository, body, callback);
}
