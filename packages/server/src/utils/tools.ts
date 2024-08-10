import {BadRequestException, HttpException, HttpStatus} from '@nestjs/common';
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
import * as crypto from 'crypto';
import * as dayjs from 'dayjs';
import {Request} from 'express';
import * as yaml from 'js-yaml';
import * as safeEval from 'safe-eval';
import {DateValue, PageFormat} from '@/types';

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
    if (typeof message === 'string') {
      if (message.indexOf("$key") > -1) {
        message = message.replace(/\$key/gi, key as string)
      }
      if (message.indexOf("$value") > -1) {
        message = message.replace(/\$value/gi, value as string)
      }
    }
    throw new HttpException(message, status);
  }
}

/**
 * 解析 textarea 数据为对象。
 * 每行数据格式应为 key=value。
 * 行之间以 '\n' 分隔。值会被自动转换为适当的类型，包括布尔值、数组、对象和函数。
 *
 * @param {string} textareaData - textarea 数据字符串。
 * @returns {Object} - 解析后的包含键值对的对象。
 */
export function parseTextareaData(textareaData?: string) {
  if (!textareaData) return null;

  // 按换行符 '\n' 分割输入字符串，得到每个键值对
  const lines = textareaData.split('\n');

  // 创建一个空对象来存储解析后的键值对
  const result = {};

  // 遍历每一行
  lines.forEach(line => {
    // 按等号 '=' 分割每一行，得到键和值
    const [key, value] = line.split('=');

    // 如果键和值都定义，则将它们添加到结果对象中
    if (key && value !== undefined) {
      // 根据值的内容进行类型转换
      try {
        if (value === 'true') {
          result[key] = true;
        } else if (value === 'false') {
          result[key] = false;
        } else if (value.startsWith('[') || value.startsWith('{')) {
          // 使用 js-yaml 解析 JSON 形式的数组和对象
          result[key] = yaml.load(value);
        } else if (value.startsWith('function') || value.includes('=>')) {
          // 使用 safe-eval 解析函数
          result[key] = safeEval(value);
        } else {
          result[key] = value;
        }
      } catch (error) {
        console.error(`Error parsing value for key "${key}":`, error);
        result[key] = value;
      }
    }
  });

  return result;
}
