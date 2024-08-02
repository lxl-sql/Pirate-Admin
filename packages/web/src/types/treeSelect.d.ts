import {CSSProperties} from "vue";
import {TreeSelectProps} from "ant-design-vue";

interface FieldNames {
  label?: string;
  value?: string;
  children?: string;
}

export interface ITreeSelectProps<OptionType = any> {
  /** treeNodes 数据，如果设置则不需要手动构造 TreeNode 节点（value 在整个树范围内唯一） */
  treeData: OptionType[];
  /**	替换 treeNode 中 label,value,children 字段为 treeData 中对应的字段 */
  fieldNames?: FieldNames;
  /** 下拉菜单的样式 */
  dropdownStyle?: CSSProperties;
  /** 指定当前选中的条目 */
  value?: string | string[] | number | number[];
  /** 选择框默认文字 */
  placeholder?: string;
  /** 输入项过滤对应的 treeNode 属性 */
  treeNodeFilterProp?: string;
  /** 最多显示多少个 tag */
  maxTagCount?: number;
  /** 支持多选（当设置 treeCheckable 时自动变为 true） */
  multiple?: boolean;
  /** 在下拉中显示搜索框(仅在单选模式下生效) */
  showSearch?: boolean;
  /** 显示清除按钮 */
  allowClear?: boolean;
  spliceParentTitle?: boolean;
  /** 默认展开所有树节点 */
  treeDefaultExpandAll?: boolean;
  /**	显示 checkbox */
  treeCheckable?: boolean
  /**	定义选中项回填的方式。
   * - `TreeSelect.SHOW_ALL`: 显示所有选中节点(包括父节点).
   * - `TreeSelect.SHOW_PARENT`: 只显示父节点(当父节点下所有子节点都选中时).
   * - `TreeSelect.SHOW_CHILD`: 默认只显示子节点
   */
  showCheckedStrategy?: TreeSelectProps['showCheckedStrategy'];
}
