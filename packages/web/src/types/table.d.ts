import {
  DatePickerProps,
  FormProps,
  InputProps,
  PaginationProps,
  RadioProps,
  SelectProps,
  TableProps,
  TextAreaProps,
  TreeSelectProps,
  UploadProps,
} from "ant-design-vue";
import {FormType, IOptions} from "@/types/form";
import {CSSPropertiesType, TStyle} from "@/types/style";
import {ColumnType} from "ant-design-vue/es/table";
import {DefaultRecordType} from "ant-design-vue/es/vc-table/interface";
import {TableRowSelection} from "ant-design-vue/es/table/interface";
import {RangePickerProps} from "ant-design-vue/lib/date-picker";

type CustomHeaderCellType = {
  style: CSSPropertiesType;
};

// 	设置选择器类型
type Picker = "date" | "week" | "month" | "quarter" | "year";

export type FormFieldProps<T extends FormType = "input"> = T extends | "input"
  | "input-password"
  | "input-number"
  ? InputProps
  : T extends "textarea"
    ? TextAreaProps
    : T extends "select"
      ? SelectProps
      : T extends "tree-select"
        ? TreeSelectProps
        : T extends "radio"
          ? RadioProps
          : T extends "date-picker"
            ? DatePickerProps
            : T extends "range-picker"
              ? RangePickerProps
              : T extends "upload"
                ? UploadProps
                : never;

export interface IColumns<RecordType = DefaultRecordType> extends ColumnType<RecordType> {
  /** key 需要必填 */
  dataIndex: Required<string>;
  /** 默认表单内容类型 */
  type?: FormType;
  /** select/radio/tree 选择项 */
  options?: IOptions[] | ((dataSource?: RecordType[], fields?: Record<string, any>) => IOptions[]);
  /** 日期格式 */
  picker?: Picker;
  /** 占位内容 */
  placeholder?: string | ((fields: Record<string, any>) => string);
  /** 国际化 */
  i18nName?: string;
  // responsive?: string[];
  /** 搜索框占位宽度 */
  span?: number | string;
  /** 表头宽度 */
  width?: number | string;
  /** 拖动列最小宽度，会受到表格自动调整分配宽度影响 */
  minWidth?: number;
  /** 拖动列最大宽度，会受到表格自动调整分配宽度影响 */
  maxWidth?: number;
  /** 表头样式 */
  style?: TStyle;
  /** 是否开始当前列国际化 */
  isI18n?: boolean;
  /** 是否允许搜索 */
  search?: boolean;
  /** 表格搜索内容类型 */
  searchType?: FormType;
  /** 回填到查询表单展示的属性名称，默认是 column 的label值。比如表单展示不同名称，此值可以更换名称。 */
  searchLabelProp?: string;
  /** 回填到查询表单数据 Value 的属性值，默认是 column 的 dataIndex 值。比如表单展示不同字段，此值可以更换字段。 */
  searchValueProp?: string;
  /** 是否隐藏 */
  hide?: boolean;
  /** 默认排序 */
  sort?: number;
  /** 表头是否可伸缩 */
  resizable?: boolean;
  /** 查询表单排序 */
  querySort?: number;
  /** 搜索框配置项 */
  queryFieldConfig?: any;

  /** 设置头部单元格属性 */
  customHeaderCell?(column: IColumns): CustomHeaderCellType;
}

/**
 * 接口分页参数
 */
export interface IPages {
  /** 当前页 */
  size: number;
  /** 当前页码 */
  page: number;
  /** 总条数 */
  total: number;
}

/**
 * 分页参数
 */
export type IPagination = PaginationProps;

/**
 * 默认表格字段
 */
export interface RecordType {
  id?: number;
  key?: string | number;
  updateTime?: string;
  createTime?: string;
  children?: RecordType[];
}

interface I18nPrefix {
  table: string;
  columns: string;
  form: string;
}

export interface ITableProps {
  /** 表格列的配置描述 */
  columns?: IColumns[];
  /** 数据数组 */
  dataSource?: TableProps["dataSource"];
  /** 表格行是否可选择 */
  rowSelection?: TableRowSelection;
  /** 指定每页可以显示多少条 */
  pagination?: TableProps["pagination"];
  /** 页码 */
  pages?: IPages; // 页码
  /** model */
  model?: FormProps["model"];
  /** a-form 表单查询配置项 */
  queryConfig?: FormProps;
  /** a-table 表格配置项 */
  tableOptions?: TableProps;
  /** 表格操作列默认字段 */
  operationKey?: string;
  /** 表格大小 */
  size?: TableProps["size"];
  /** 表格行 key 的取值 */
  rowKey?: TableProps["rowKey"];
  /** 设置横向或纵向滚动，也可用于指定滚动区域的宽和高 */
  scroll?: TableProps["scroll"];
  /** 国际化前缀 */
  i18nPrefix?: string;
  /** 是否全局开启国际化 */
  isI18nGlobal?: boolean;
  /**指定树形结构的列名 默认 children */
  childrenColumnName?: TableProps["childrenColumnName"];
  /**关键字搜索框 占位内容 */
  keywordPlaceholder?: string;
  /** 注意提示 */
  remark?: string;
  /** 格式为简单css选择器的字符串，使列表单元中符合选择器的元素成为拖动的手柄，只有按住拖动手柄才能使列表单元进行拖动 */
  dragClassname?: string,
  /** 查询表单展示行列 */
  defaultSpan?: number;
  /**是否显示关键字搜索框 */
  keywordVisible?: boolean;
  /**表格加载状态 */
  loading?: boolean;
  /**控制展开所有行 */
  defaultExpandAllRows?: boolean;
  /**是否允许拖拽行 搭配 class drop-row-btn */
  draggable?: boolean;
}

/**
 * @description: 默认列表状态值
 */
export interface DefaultTableState<
  RecordType = DefaultRecordType,
  QueryFormType = any
> {
  isTableLoading: boolean;
  pages: IPages;
  remark?: string;
  queryForm: QueryFormType;
  dataSource: RecordType[];
}

/** 1 是 0 否 */
export type DefaultStatus = 0 | 1;
