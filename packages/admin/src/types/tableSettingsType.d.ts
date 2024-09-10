import {FormFieldProps, IColumns, IPages, ITableProps} from "@/types/table";
import {DefaultRecordType} from "ant-design-vue/es/vc-table/interface";
import {Key} from "ant-design-vue/lib/table/interface";
import {type Ref} from "vue";
import {FormInstance, FormProps, PaginationProps, TableProps} from "ant-design-vue";
import {Props, ValidateInfo, validateOptions,} from "ant-design-vue/lib/form/useForm";
import type {RuleError} from "ant-design-vue/lib/form/interface";
import {FormLayout, FormType, IOptions, Rules} from "@/types/form";
import {IModalProps} from "@/components/IComponents/IModal/types";
import type {TableRowSelection} from "ant-design-vue/es/table/interface";
import {CustomFormProps} from "@/components/IComponents/IOther/CustomForm/index.vue";

/**
 * 表示操作按钮或操作类型的枚举。
 * @typedef {('refresh' | 'delete' | 'create' | 'expand' | 'row-detail' | 'row-update' | 'row-delete')} Operation
 */
export declare type Operation =
  | "refresh"
  | "delete"
  | "create"
  | "expand"
  | 'row-sortable'
  | "row-detail"
  | "row-update"
  | "row-delete";

/**
 * CancelFormType 表示取消表单的类型。
 * @typedef {0| 1 | 2} ModalType
 *
 * @property {0} 0 - 新增
 * @property {1} 1 - 编辑
 * @property {2} 2 - 详情
 */
export declare type ModalType = 0 | 1 | 2

/**
 * 自定义 params 入参
 */
export declare type CustomParamsKey = "queryAll" | "confirmForm";

export declare type DefaultQueryFormType = Record<string, any> | undefined;

export declare type DefaultFieldsType = {
  id?: Key;
};

interface ModalCallback<T = any> {
  beforeOpen?: (...args: T) => void
  afterOpen?: (...args: T) => void
  beforeClose?: (...args: T) => void
  afterClose?: (...args: T) => void
}

export interface QueryAllOptions {
  /** 是否显示列表数据 默认: true */
  showDataSource?: boolean;
  /** 是否显示分页数据 默认: true */
  showPages?: boolean;
}

export interface PrivateApi {
  /**
   * 插入或更新项
   * @param {Object} itemData - 需要插入或更新的项的数据
   * @returns {Promise} - 返回插入或更新结果的 Promise
   */
  upsert: Function;
  /**
   * 查找项列表
   * @param {Object} query - 查询参数
   * @returns {Promise} - 返回项列表的 Promise
   */
  find: Function;
  /**
   * 根据ID查找项
   * @param {number|string} id - 项的唯一标识符
   * @returns {Promise} - 返回单个项的 Promise
   */
  findById: Function;
  /**
   * 删除项
   * @param {number|string} id - 项的唯一标识符
   * @returns {Promise} - 返回删除结果的 Promise
   */
  delete: Function;
  /**
   * 拖拽排序
   * @param {number} id - 主键值
   * @param {number} targetId - 排序位置主键值
   */
  sortable: Function;
}

export interface TableSettingColumn<RecordType = DefaultRecordType> extends IColumns<RecordType> {
  /** 是否显示表单 */
  form?: boolean | ((fields?: Record<string, any>) => boolean)
  /** 表单内容类型 */
  formType?: FormType;
  /** 回填到表单展示的属性名称，默认是 column 的label值。比如表单展示不同名称，此值可以更换名称。 */
  formLabelProp?: string;
  /** 回填到表单数据 Value 的属性值，默认是 column 的 dataIndex 值。比如表单展示不同字段，此值可以更换字段。 */
  formValueProp?: string;
  /** 表单排序 */
  formSort?: number;
  /** 表单位宽度 */
  formSpan?: number;
  /** 表单插槽 */
  formSlot?: boolean;
  /** 表单item配置 */
  formItemConfig?: any;
  /** 表单内容配置 */
  formFieldConfig?: FormFieldProps | ((fields?: Record<string, any>) => FormFieldProps);
  /** 是否在详情中展示此字段 */
  detail?: boolean | ((fields?: Record<string, any>) => boolean);
  /** 回填到详情展示的属性名称，默认是 column 的label值。比如表单展示不同名称，此值可以更换名称。 */
  detailLabelProp?: string;
  /** 回填到详情数据 Value 的属性值，默认是 column 的 dataIndex 值。比如表单展示不同字段，此值可以更换字段。 */
  detailValueProp?: string;
  /** 详情排序 */
  detailSort?: number;
  /** 详情占位宽度 */
  detailSpan?: number;
  /** 详情插槽 */
  detailSlot?: boolean;
  /** 详情自定义渲染 */
  detailRender?: <V extends keyof RecordType = any, T = any>(value: V, fields: RecordType) => T
  /** select/radio/tree 选择项 */
  options?: IColumns<RecordType>['options'] | ((dataSource?: RecordType[], fields?: Record<string, any>) => IOptions[])
}

/**
 * 表格设置的列类型
 */
export type TableSettingColumns<
  Layout extends FormLayout = 'horizontal',
  RecordType = DefaultRecordType
> = Layout extends 'multiple-columns'
  ? TableSettingColumn<RecordType>[][]
  : TableSettingColumn<RecordType>[]

export interface TableReactive<
  RecordType = DefaultRecordType,
  QueryForm = DefaultQueryFormType
> extends TableProps<RecordType> {
  /** 表格列配置 */
  columns?: TableSettingColumn<RecordType>[];
  /** 查询表单数据 */
  dataSource?: RecordType[];
  /** 操作按钮 */
  operations?: Operation[];
  /** 选中的行 */
  selectedRowKeys?: Key[];
  /** 分页信息 */
  pages?: IPages;
  /** 分页配置 */
  pagination?: PaginationProps;
  /** 查询表单 */
  queryForm?: QueryForm;
  /** 国际化前缀 */
  i18nPrefix?: ITableProps["i18nPrefix"];
  /** 列表项是否可选择，[配置项](https://next.antdv.com/components/table-cn#rowselection) */
  rowSelection?: Omit<TableRowSelection<RecordType>, 'selectedRowKeys' | 'onChange'>
  /** 表格行 key 的取值 */
  rowKey?: string;
  /** 表格备注 */
  remark?: string;
  /** 格式为简单css选择器的字符串，使列表单元中符合选择器的元素成为拖动的手柄，只有按住拖动手柄才能使列表单元进行拖动 */
  dragClassname?: string;
  /** 父级id key */
  parentKey?: string;
  /** 表单布局 */
  defaultSpan?: number;
  /** 多选框最大可选数 */
  maxSelectedCount?: number;
  /** 表格 loading */
  loading?: boolean;
  /** 列表行支持拖拽 */
  draggable?: boolean;
  /** 初始时，是否展开所有行 */
  defaultExpandAllRows?: boolean;
  /** 控制表格字段下的 form-modal 对话框的可见性，默认为 true */
  displayFormModal?: boolean;
  /** 控制表格字段下的 detail-modal 对话框的可见性，默认为 true */
  displayDetailModal?: boolean;
  /** 是否显示 `remark` 默认: true */
  showRemark?: boolean;
}


export interface FormReactive<Fields = DefaultFieldsType> {
  /** 表单数据对象 */
  fields: Fields;
  /** 表单配置 */
  formConfig?: Pick<FormProps, CustomFormProps>;
  /** 表单验证规则 */
  rules?: Rules;
  /** 表单名称，会作为表单字段 id 前缀使用 */
  name?: string;
  /** 国际化前缀 */
  i18nPrefixProp?: string;
  /** 表单布局 */
  layout?: FormLayout;
  /** 表单布局 */
  defaultSpan?: number;
  /** 表单弹窗配置 */
  modal: IModalProps & ModalCallback;
}

export interface DetailReactive<Fields = DefaultFieldsType> {
  /** 表单数据对象 */
  fields: Fields;
  /** 一行的 DescriptionItems 数量，可以写成像素值或支持响应式的对象写法 { xs: 8, sm: 16, md: 24} */
  column?: number;
  /** 表单布局 */
  defaultSpan?: number;
  /** 表单弹窗配置 */
  modal: IModalProps & ModalCallback;
  /** 国际化前缀 */
  i18nPrefixProp?: string;
}


/**
 * 对话框
 */
export interface ModalReactive extends IModalProps {
  open?: boolean;
}

declare type namesType = string | string[];

/**
 * 表单 ref
 */
export interface FormRefs
  extends Pick<FormInstance, "validate" | "resetFields"> {
  modelRef: Props | Ref<Props>;
  rulesRef: Props | Ref<Props>;
  initialModel: Props;
  validateInfos: validateInfos;
  resetFields: (newValues?: Props) => void;
  validate: <T = any>(
    names?: namesType,
    option?: validateOptions
  ) => Promise<T>;
  /** This is an internal usage. Do not use in your prod */
  validateField: (
    name: string,
    value: any,
    rules: Record<string, unknown>[],
    option?: validateOptions
  ) => Promise<RuleError[]>;
  mergeValidateInfo: (items: ValidateInfo | ValidateInfo[]) => ValidateInfo;
  clearValidate: (names?: namesType) => void;
}

export declare interface TableSettingsType<
  RecordType = DefaultRecordType,
  QueryForm = DefaultQueryFormType,
  Fields = DefaultFieldsType
> {
  /**
   * 默认接口数据对象
   */
  _api?: PrivateApi;

  /**
   * 表格数据对象
   */
  readonly table: TableReactive<RecordType, QueryForm>

  /**
   * 表单数据对象
   */
  readonly form: FormReactive<Fields>

  /**
   * 详情数据对象
   */
  readonly detail: DetailReactive<Fields>

  /**
   * 公共 modal 配置
   */
  readonly modal: ModalReactive

  /**
   * 表单ref
   */
  formRefs?: FormRefs;

  /**
   * 自定义表单提交数据
   */
  customParams?: Record<CustomParamsKey, Function>;

  /**
   * 表格数据查询
   */
  queryAll(options?: QueryAllOptions): Promise<void> | void;

  /**
   * 删除数据
   * @param type {string} delete 表格头部多选删除 row-delete 单行数据杉删除
   * @param ids {(string | number)[]}
   */
  deleteByIds(
    type: Extract<Operation, "delete" | "row-delete">,
    ids: Key[]
  ): Promise<void> | void;

  /**
   * 获取详情接口
   * @param type {ModalType}
   * @param id {(string | number)[]}
   * @param success {Function}
   */
  detailById(type: ModalType, id: Key, success?: Function): Promise<void> | void;

  /**
   * 分页
   * @param pages {page: number, size: number, total: number}
   */
  pagesChange(pages: IPages): Promise<void> | void;

  /**
   * 表格选择
   * @param selectedRowKeys {(string | number)[]}
   */
  selectChange(selectedRowKeys: Key[]): Promise<void> | void;

  /**
   * 打开表单弹窗
   * @param type {0 | 1}0 新增 1 编辑
   * @param id {(string | number)[]}
   * @param success {Function}
   */
  openForm(type: 0 | 1, id?: Key, success?: Function): Promise<void> | void;

  /**
   * 关闭表单
   */
  cancelForm(type: CancelFormType): Promise<void> | void;

  /**
   * 确认表单
   */
  confirmForm(): Promise<void> | void;

  /**
   * 打开详情弹窗
   * @param id {(string | number)[]}
   * @param success {Function}
   */
  openDetail(id: Key, success?: Function): Promise<void> | void;

  /**
   * 功能接口 转换 queryParams 为接口所需要的数据
   */
  transformParams(): QueryForm | undefined;
}
