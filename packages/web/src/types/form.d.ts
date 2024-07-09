import {Rule} from "ant-design-vue/es/form";
import {Dayjs} from "dayjs";

export type FormType =
  | "input"
  | "input-password"
  | "input-number"
  | "textarea"
  | "select"
  | "tree-select"
  | "cascader"
  | "radio"
  | 'radio-button'
  | "date-picker"
  | "range-picker"
  | "upload"
  | 'icon'

export interface IOptions {
  label?: string;
  value?: any;
}

export type Rules = Record<string, Rule[] | undefined>;

export type DateRangeTuple = [Dayjs?, Dayjs?];
