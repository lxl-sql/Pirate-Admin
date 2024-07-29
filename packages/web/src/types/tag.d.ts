import type {VNode} from "vue";
import type {PresetColorType} from "ant-design-vue/es/_util/colors";

export interface ITagProps {
  /** 标签色 */
  color?: "error" | "default" | "success" | "processing" | "warning" | PresetColorType
  /**  标签是否可以关闭 */
  closable?: boolean
  /** 自定义关闭按钮 */
  closeIcon?: VNode
  /** 设置图标   */
  icon?: VNode
  /** 是否有边框 */
  bordered?: boolean
}
