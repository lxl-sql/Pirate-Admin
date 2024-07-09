import {DefaultRecordType} from "ant-design-vue/es/vc-table/interface";

export interface Response<T> {
  code?: number;
  data: T;
  message?: string;
}

export interface ResponseList<RecordType = DefaultRecordType> {
  page: number;
  size: number;
  total: number;
  records: RecordType[];
  remark: string
}
