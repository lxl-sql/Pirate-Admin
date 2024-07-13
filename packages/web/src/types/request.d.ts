import {DefaultRecordType} from "ant-design-vue/es/vc-table/interface";
import {Key} from "ant-design-vue/lib/table/interface";

export interface Response<T> {
  code?: number;
  data: T;
  message?: string;
}

/**
 * ResponseList 接口，用于描述带有分页信息的响应数据结构。
 *
 * @template RecordType - 表示记录的类型，默认为 DefaultRecordType。
 */
export interface ResponseList<RecordType = DefaultRecordType> {
  /**
   * 当前页码。
   *
   * @type {number}
   */
  page: number;

  /**
   * 每页记录数。
   *
   * @type {number}
   */
  size: number;

  /**
   * 总记录数。
   *
   * @type {number}
   */
  total: number;

  /**
   * 当前页的记录列表。
   *
   * @type {RecordType[]}
   */
  records: RecordType[];

  /**
   * 备注信息。
   *
   * @type {string}
   */
  remark: string;
}

/**
 * DeleteParams 接口，用于描述删除操作所需的参数。
 */
export interface DeleteParams {
  /**
   * 要删除的记录的 ID 列表。
   *
   * @type {Key[]}
   */
  ids: Key[];
}

export type CaptchaType = number

export interface CaptchaParams {
  type: CaptchaType;
  address: string
}
