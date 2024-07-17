/**
 * @file src/types/index.d.ts
 * @description 全局类型定义
 */
import {Dayjs} from 'dayjs';

export type DateValue = string | number | Date | Dayjs | undefined | null;

export type Nullable<T> = T | null;

export type Optional<T> = T | undefined;

export type AnyObject = Record<string, any>;

export type AnyArray = any[];

export type AnyFunction = (...args: any[]) => any;

export type AnyConstructor = new (...args: any[]) => any;


/**
 * @description 分页格式
 */
export interface PageFormat<T = any> {
  page: number;
  size: number;
  total: number;
  records: T[];
  remark?: string;
}

declare module 'express-session' {
  interface Session {
    captcha: string;
  }
}
