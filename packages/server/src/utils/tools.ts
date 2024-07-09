import {
  Between,
  Entity,
  FindManyOptions,
  FindOperator,
  FindOptionsWhere,
  Like,
  ObjectLiteral,
  Repository,
  TreeRepository,
} from 'typeorm';
import { BadRequestException, HttpException, HttpStatus } from '@nestjs/common';
import * as crypto from 'crypto';
import * as dayjs from 'dayjs';
import { DateValue, PageFormat } from 'src/types';
import { Request } from 'express';

// 加盐
const salt = '6D35z8%W$jrH@pirate';

export function md5(str: string) {
  const hash = crypto.createHash('md5');
  hash.update(salt).update(str);
  return hash.digest('hex');
}

/**
 * @description 生成随机字符串
 * @param len 长度 默认6
 * @returns
 */
export function randomString(len = 6) {
  return Math.random().toString().slice(-len);
}

/**
 * @description 字符串转数字
 * @param name 默认提示
 * @param defaultValue 默认值
 * @returns
 */
export function generateParseIntPipe(name: string, defaultValue: number) {
  return {
    transform(value: string) {
      return parseInt(value, 10) || defaultValue;
    },
    exceptionFactory() {
      throw new BadRequestException(name + ' 应该传数字');
    },
  };
}

/**
 * @description 过滤假值 '' null undefined NaN
 * @param value
 * @param callback 回调 过滤条件 默认过滤假值
 * @returns
 */
export function filterFalsyValues<Value>(
  value: Value,
  callback?: (value: Value) => boolean,
) {
  if (value === '' || Number.isNaN(value) || value === null) {
    return undefined;
  }
  if (callback) {
    return callback(value) ? value : undefined;
  }
  return value;
}

/**
 * @description 解析日期字符串
 * @param str
 * @returns
 * @example "['2024-01-01', '2024-02-02']" --> ['2024-01-01', '2024-02-02']; "2024-01-01, 2024-02-02" --> ['2024-01-01', '2024-02-02'];
 */
export function parseDateString(str) {
  // 将字符串中的单引号替换为双引号
  str = str.replace(/'|"/g, '"');

  // 使用 try-catch 块尝试解析 JSON 字符串
  try {
    const dates = JSON.parse(str);

    // 如果解析成功且结果为数组，则返回结果
    if (Array.isArray(dates)) {
      return dates;
    }
  } catch (error) {
    // 解析失败则忽略错误
  }

  // 如果解析失败或结果不是数组，则尝试使用逗号分隔符分割字符串
  return str.split(',').map((date) => date.trim());
}

/**
 * @description like查询
 * @param value
 * @returns
 */
export function like(value: string) {
  return filterFalsyValues(value) ? Like(`%${value}%`) : undefined;
}

export function between<T extends Date | number | string>(
  from: T | T[],
  to: T | 'date' | 'number' | 'string',
): FindOperator<T> | undefined {
  if (to === 'date' && from && typeof from === 'string') {
    const [start, end] = parseDateString(from) || [];
    // example "['2024-01-01', '2024-01-01']" --> ['2024-01-01 00:00:00', '2024-01-02 00:00:00']; 需要加 1 天
    return from && to
      ? Between(
          dayjs(start).toDate() as T,
          dayjs(end).add(1, 'day').toDate() as T,
        )
      : undefined;
  }
  return from && to ? Between(from as T, to as T) : undefined;
}

/**
 * @description 是否是日期格式的数据
 * @param value
 * @returns
 */
export function isDate(value: DateValue) {
  return value ? dayjs(value).isValid() : false;
}

export function isString(value: any) {
  return typeof value === 'string';
}

/**
 * @description 日期格式化
 * @param value 日期
 * @param format
 * @returns
 */
export function dateFormat(value: DateValue, format: string): string | null {
  return value ? dayjs(value).format(format) : null;
}

/**
 * @description 过滤ip
 * @param ip
 * @returns
 */
export function trimmedIp(ip: string): string | null {
  if (!isString(ip)) return null;
  // ipv6 转 ipv4 兼容 ::ffff:
  if (ip.startsWith('::ffff:') && ip.includes(':')) {
    return ip.split(':').pop();
  }
  return ip;
}

/**
 *
 * @param list 数据
 * @param children 子级字段 默认children
 * @param cb 回调
 * @param parent 父级 默认null
 * @returns
 */
export function mapTree<T>(
  list: T[],
  callback: (item: T, index: number, list: T[], parent: T) => void,
  children = 'children',
  parent: T | null = null,
) {
  if (!Array.isArray(list)) {
    return list;
  }
  return list.map((item, index) => {
    callback?.(item, index, list, parent);
    if (item[children] && item[children].length) {
      item[children] = mapTree(item[children], callback, children, item);
    } else {
      item[children] = null;
    }
    return item;
  });
}

/**
 * sort tree 排序
 * @param list
 * @param callback
 * @param children
 * @returns
 */
export function sortTree<T>(
  list: T[],
  callback: (a: T, b: T) => number,
  children = 'children',
) {
  // 首先对当前层级的节点进行排序
  list.sort(callback);

  // 递归地对每个子节点进行排序
  list.forEach((node) => {
    if (node[children]?.length) {
      node[children] = sortTree(node[children], callback, children);
    }
  });

  return list;
}

/**
 * @description 获取请求的host
 * @param request
 * @param path
 * @returns
 */
export function requestHost(request: Request | string, path?: string) {
  if (typeof request === 'string') {
    return path ? `${request}${path}` : null;
  }
  return path ? `${request.protocol}://${request.get('host')}${path}` : null;
}

/**
 * 分页查询 生成查询条件 {skip, take, ...option} 用于typeorm查询 findAndCount find findMany 等
 * @param page 页码
 * @param size 每页数量
 * @param option 查询条件
 * @returns {skip, take, ...option}
 */
export function findManyOption<Entity extends ObjectLiteral = any>(
  page: number,
  size: number,
  option: FindManyOptions<Entity>,
): FindManyOptions<Entity> {
  return {
    skip: (page - 1) * size,
    take: size,
    ...option,
  };
}

/**
 * 分页格式化 返回数据 格式 {page, size, total, records, remark}
 * @param page 页码
 * @param size 每页数量
 * @param total 总数
 * @param records 数据
 * @param remark 备注
 * @returns {page, size, total, records, remark}
 */
export function pageFormat<T = any>(
  page: number,
  size: number,
  total: number,
  records: T[],
  remark?: string,
): PageFormat<T> {
  return {
    page,
    size,
    total,
    records,
    remark,
  };
}

/**
 * @description 数据转树形结构
 * @param list 数据
 * @param id id字段 默认id
 * @param parentId 父级id字段 默认parentId
 * @param children 子级字段 默认children
 * @returns
 */
export function listToTree<T>(
  list: T[],
  callback?: (cur: T) => void,
  id = 'id',
  parentId = 'parentId',
  children = 'children',
) {
  return list.reduce((acc, cur: T) => {
    callback?.(cur);
    const parent = list.find((item) => item[id] === cur[parentId]);
    if (parent) {
      if (!parent[children]) {
        parent[children] = [];
      }
      cur[parentId] = parent[id];
      parent[children].push(cur);
    } else {
      acc.push(cur);
    }
    return acc;
  }, []);
}
/**
 * 检查数据库中是否存在指定条件的实体。
 * 如果存在，则抛出一个带有自定义消息和状态码的HTTP异常。
 *
 * @param repository - 实体的仓库，可以是任何实现了TreeRepository或Repository接口的仓库。
 * @param key - 实体对象的属性键，用于查询条件。
 * @param value - 对应于属性键的值，用于查询条件。
 * @param message - 当实体存在时，抛出的HTTP异常的消息。可以是简单的字符串或包含更多细节的对象。
 * @param status - 抛出的HTTP异常的状态码，默认为HttpStatus.CONFLICT（409）。
 * @returns 无返回值。如果存在匹配的实体，则会抛出异常。
 */
export async function existsByOnFail<Entity = any, Value = any>(
  repository: TreeRepository<Entity> | Repository<Entity>,
  key: keyof Entity,
  value: Value,
  message: string | Record<string, any>,
  status: number = HttpStatus.CONFLICT,
) {
  if (!(key in Entity)) {
    throw new Error(`Invalid key: ${String(key)}`);
  }

  const exist = await repository.existsBy({
    [key]: value,
  } as FindOptionsWhere<Entity>);

  if (exist) {
    throw new HttpException(message, status);
  }
}
