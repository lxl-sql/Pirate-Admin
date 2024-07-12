import {FormType, RuleType} from "@/types/form";

/**
 * 配置项
 */
export interface ConfigItem {
  // 分组id
  groupId?: number
  // 分组
  group?: string
  // 变量标题
  title: string
  // 变量字段
  name: string
  // 变量类型
  type: FormType
  // 提示信息
  tip?: string
  // 校验规则
  rule?: RuleType[]
  // 字典数据
  content?: string
  // 默认value值
  value?: string
  // FormItem 扩展属性
  extend?: Record<string, any>
  // Input 扩展属性
  inputExtend?: Record<string, any>
  // 权重
  weight?: number
}
