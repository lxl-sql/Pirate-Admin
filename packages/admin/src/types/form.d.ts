import {Rule} from "ant-design-vue/es/form";
import {Dayjs} from "dayjs";
import type {RuleType as AntRuleType} from "ant-design-vue/es/form/interface";

// 一行多列 | 水平的 | 一行展示 | 垂直的
export type FormLayout = 'multiple-columns' | 'horizontal' | 'inline' | 'vertical';

// Input框 type
export type FormType =
  | "input"
  | "input-password"
  | "input-number"
  | "textarea"
  | "select"
  | "tree"
  | "tree-select"
  | "cascader"
  | "checkbox"
  | "radio"
  | "radio-button"
  | "date-picker"
  | "range-picker"
  | "time-picker"
  | "upload"
  | "key-value"
  | "switch"
  | "editor"
  | "city"
  | "color"
  | "icon"

export enum FormTypeEnum {
  "input" = "输入框",
  "input-password" = "密码输入框",
  "input-number" = "数字输入框",
  "textarea" = "文本域",
  "select" = "选择框",
  "tree-select" = "树选择框",
  "cascader" = "级联选择",
  "checkbox" = "多选",
  "radio" = "单选",
  "radio-button" = "单选按钮",
  "date-picker" = "日期选择器",
  "range-picker" = "范围选择器",
  "time-picker" = "时间选择器",
  "upload" = "上传",
  "key-value" = "键值对",
  "switch" = "开关",
  "editor" = "富文本编辑器",
  "city" = "城市选择器",
  "color" = "颜色选择器",
  "icon" = "图标选择"
}

// 校验 type
export type RuleType =
  'required' // 必填
  | 'phone' // 手机号
  | 'idCard' // 身份证号
  | 'username' // 用户名
  | 'password' // 密码
  | 'array'
  | AntRuleType

export enum RuleTypeEnum {
  'required' = "必填",
  'phone' = "手机号",
  'idCard' = "身份证号",
  'username' = "用户名",
  'password' = "密码",
  'array' = "数组",
  'string' = "字符串",
  'number' = "数字",
  'boolean' = "布尔值",
  'method' = "方法",
  'regexp' = "正则表达式",
  'integer' = "整数",
  'float' = "浮点数",
  'object' = "对象",
  'enum' = "枚举",
  'date' = "日期",
  'url' = "URL",
  'hex' = "十六进制",
  'email' = "邮箱",
}

export interface IOptions {
  label?: string;
  value?: any;
}

export type Rules = Record<string, Rule[] | undefined>;

export type DateRangeTuple = [Dayjs?, Dayjs?];
