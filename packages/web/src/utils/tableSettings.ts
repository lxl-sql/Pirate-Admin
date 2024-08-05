import {onMounted, reactive} from "vue";
import {calculateNextPage, formatDateRange} from "@/utils/common";
import {Form, notification} from "ant-design-vue";
import i18n from "@/locales";
import type {IPages} from "@/types";
import {
  CustomParamsKey,
  DefaultFieldsType,
  DetailReactive,
  FormReactive,
  FormRefs,
  ModalReactive,
  ModalType,
  Operation,
  PrivateApi,
  TableReactive,
  TableSettingsType,
} from "@/types/tableSettingsType";
import type {Key} from "ant-design-vue/lib/table/interface";
import type {DefaultRecordType} from "ant-design-vue/es/vc-table/interface";
import {cloneDeep, isArray, merge} from "lodash-es";
import dayjs from "dayjs";
import {DateRangeTuple, Rules} from "@/types/form";
import Sortable from "sortablejs";

const {t} = i18n.global;

export const tableSettingKey = Symbol("tableSettings");

export default class TableSettings<
  RecordType = DefaultRecordType,
  QueryForm = DefaultRecordType,
  Fields extends DefaultFieldsType = DefaultFieldsType
> implements TableSettingsType<RecordType, QueryForm, Fields> {
  private api: PrivateApi;

  /** @type {boolean} 保存初始化时的 默认展开表格 */
  private defaultExpandAllRows: boolean = false;

  /** @type {cacheFields} 保存初始化时的 form fields */
  private cacheFields: Fields | null = null;

  public readonly table = reactive({
    columns: [],
    dataSource: [],
    selectedRowKeys: [],
    operations: [],
    pages: {
      page: 1,
      size: 10,
      total: 0,
    },
    pagination: {
      // 可能是这边的问题 要是有分页问题吧
      pageSize: 10,
      current: 1,
      total: 0,
    },
    queryForm: {} as QueryForm,
    scroll: {x: true},
    rowSelection: {
      fixed: true, // 把选择框列固定在左边
    },
    rowKey: "id",
    dragClassname: '.drag-row-item',
    parentKey: 'parentId',
    i18nPrefix: undefined,
    remark: undefined,
    defaultSpan: 6,
    loading: false,
    draggable: false,
    defaultExpandAllRows: false,
    showRemark: true,
    displayFormModal: true,
    displayDetailModal: true,
  }) as TableReactive<RecordType, QueryForm>;

  public readonly form = reactive({
    fields: {} as Fields,
    formConfig: undefined,
    rules: undefined,
    defaultSpan: 24,
    i18nPrefixProp: 'form',
    modal: {
      open: false,
      maskClosable: false,
    }
  }) as FormReactive<Fields>;

  public readonly detail = reactive({
    fields: {} as Fields,
    i18nPrefixProp: 'detail',
    column: 2,
    modal: {
      open: false,
      footer: null,
      closable: true,
    },
  }) as DetailReactive<Fields>

  public readonly modal = reactive({
    loading: false,
    draggable: true,
  }) as ModalReactive

  public formRefs?: FormRefs;

  public customParams?: TableSettingsType["customParams"];

  constructor(options: any) {
    /**
     * Options for configuring the CRUD component.
     * @typedef {Object} Options
     * @property {Object} api - The API endpoints and methods for the CRUD operations.
     * @property {Object} table - The table configuration object.
     * @property {Object} form - The form configuration object.
     * @property {Object} modal - The global modal configuration object.
     * @property {Object} customParams - Custom parameters for additional configurations.
     */
    const {api, table, form, detail, modal, customParams} = options;

    this.api = api;
    this.customParams = customParams;

    if (table.defaultExpandAllRows) {
      this.defaultExpandAllRows = table.defaultExpandAllRows
      table.defaultExpandAllRows = false;
    }
    if (form) {
      this.cacheFields = cloneDeep(form.fields)
    }
    merge(this.table, table);
    merge(this.form, form);
    merge(this.detail, detail);
    merge(this.modal, modal)
    this.mounted();
  }

  /** 表格初始化 */
  public mounted = () => {
    onMounted(async () => {
      await this.initApi()
      this.initFormRefs();
      this.table.draggable && this.initRowDraggable();
    });
  };

  private initApi = async () => {
    await Promise.all([this.queryAll()]);
  }

  /**
   * 给formRefs赋值
   */
  private initFormRefs = () => {
    this.formRefs = Form.useForm(
      this.form.fields,
      this.transformRules(this.form.rules)
    );
  };

  private getParams(key: CustomParamsKey, params: Record<string, any> = {}) {
    return cloneDeep(this.customParams?.[key]?.(params) || params);
  }

  /**
   * 获取分页参数
   * @private
   */
  private getPagesParams() {
    if (this.table.pagination) {
      return {
        page: calculateNextPage(this.table.pages),
        size: this.table.pages?.size,
      }
    }
    return undefined
  }

  // region API请求方法
  public queryAll = async () => {
    if (!this.api?.find) return;
    const query = {
      ...this.getPagesParams(),
      ...this.transformParams(),
    };
    const params = this.getParams("queryAll", query);
    this.table.loading = true;
    try {
      const {data} = await this.api?.find(params);
      if (this.table.showRemark) {
        this.table.remark = data.remark;
      }
      this.table.dataSource = data.records;

      this.table.pages = {
        size: data.size,
        page: data.page,
        total: data.total,
      };

      if (this.defaultExpandAllRows) { // 当默认值有值时，才会赋值 必须异步赋值
        this.table.defaultExpandAllRows = this.defaultExpandAllRows
      }
    } finally {
      this.table.loading = false;
    }
  };

  public deleteByIds = async (
    type: Extract<Operation, "delete" | "row-delete">,
    ids: Key[]
  ) => {
    await this.api?.delete({ids});
    notification.success({
      message: t("message.success"),
      description: t("success.delete"),
    });
    if (type === "delete") {
      this.table.selectedRowKeys = [];
    }
    // 用于计算最大页数
    this.table.pages!.total -= ids.length;
    await this.queryAll();
  };

  /**
   * @param type 1 | 2 新增是没有详情的
   * @param id
   */
  public detailById = async (type: Omit<ModalType, 0>, id: Key) => {
    this.modal.loading = true;
    try {
      const {data} = await this.api?.findById(id);
      if (type === 1) {
        Object.assign(this.form.fields, data);
      } else {
        Object.assign(this.detail.fields, data);
      }
    } finally {
      this.modal.loading = false;
    }
  };

  public sortable = async (id: number, targetId: number) => {
    await this.api?.sortable(id, targetId)
    notification.success({
      message: t("message.success"),
      description: t("success.update"),
    });
  }
  // endregion

  public selectChange = (selectedRowKeys: Key[]) => {
    if (typeof this.table.maxSelectedCount === 'number' && this.table.maxSelectedCount >= 0) {
      selectedRowKeys.splice(this.table.maxSelectedCount)
    }
    this.table.selectedRowKeys = selectedRowKeys;
  };

  public pagesChange = async (pages: IPages) => {
    this.table.pages = pages;
    await this.queryAll();
  };

  public openForm = async (type: Omit<ModalType, 2>, id?: Key) => {
    this.form.fields.id = id;
    this.form.modal.beforeOpen?.(type, this.form.fields)
    // 当 rules 的类型为 function 默认认为需要动态修改校验
    if (typeof this.form.rules === "function") {
      this.initFormRefs();
    }
    this.form.modal.open = true;
    if (type === 1 && id) {
      await this.detailById(type, id);
    }
    this.form.modal.afterOpen?.(type, this.form.fields)
  };

  /**
   * 清理form中的缓存数据
   * @param {ModalType} type - 取消表单的类型。
   */
  private clearForm = (type: Omit<ModalType, 0>) => {
    if (type === 1) {
      this.formRefs?.resetFields();
      this.resetFields();
    }
  }

  /**
   * 表单弹窗关闭事件
   * @param {ModalType} type - 取消表单的类型。
   */
  public cancelForm = (type: Omit<ModalType, 0>) => {
    if (type === 1) {
      this.form.modal.beforeClose?.(this.form.fields)
      this.form.modal.open = false;
      this.clearForm(type)
      this.form.modal.afterClose?.()
    } else {
      this.detail.modal.beforeClose?.()
      this.detail.modal.open = false;
      this.detail.modal.afterClose?.()
    }
  };

  public confirmForm = async () => {
    await this.formRefs?.validate();
    const {fields} = this.form;
    const params = this.getParams("confirmForm", fields);
    this.form.modal.beforeClose?.(params)
    this.modal.loading = true;
    try {
      await this.api.upsert(params);
      notification.success({
        message: t("message.success"),
        description: t(fields.id ? "success.update" : "success.create"),
      });
      this.form.modal.open = false
      this.clearForm(1);
      await this.queryAll();
    } finally {
      this.modal.loading = false;
      this.form.modal.afterClose?.()
    }
  };

  /**
   * 打开详情弹窗
   * @param id
   */
  public openDetail = async (id: Key) => {
    this.detail.fields.id = id
    this.detail.modal.beforeOpen?.(id, this.detail.fields)

    this.detail.modal.open = true;
    await this.detailById(2, id);

    this.detail.modal.afterOpen?.(id, this.detail.fields)
  };

  /**
   * 根据缓存数据重置表单
   */
  private resetFields = () => {
    if (!this.cacheFields) return;
    const _cacheFields = cloneDeep(this.cacheFields)
    // 先赋值缓存数据，确保跟缓存数据key保持一致，再删除多余数据
    Object.assign(this.form.fields, _cacheFields)
    // 获取缓存数据的key
    const cacheKeys = Object.keys(_cacheFields)
    Object.keys(this.form.fields)
      .forEach(key => {
        if (!cacheKeys.includes(key)) {
          delete this.form.fields[key]
        }
      })
  }

  /**
   * 转换列表查询参数
   */
  public transformParams = () => {
    const queryParams = this.table.queryForm;
    if (!queryParams) return;
    const params = {} as QueryForm;
    Object.keys(queryParams).forEach((key) => {
      const param = queryParams[key];
      if (isArray(param)) {
        const isDayjs = param.every((item) => item instanceof dayjs);
        if (isDayjs) {
          // range-picker 的数据
          params[key] = formatDateRange(param as DateRangeTuple);
        } else {
          params[key] = param;
        }
      } else {
        params[key] = param;
      }
    });
    return params;
  };

  /**
   * 转换rules校验
   * @param rules 校验规则
   */
  private transformRules = (rules?: Rules | ((fields: Fields) => Rules)) => {
    if (typeof rules === "function") {
      return rules(this.form.fields as Fields);
    }
    return rules;
  };

  private findIndexRow = (data: any[], findIdx: number | undefined, keyIndex: number | any = -1): number | any => {
    for (const key in data) {
      if (typeof keyIndex == 'number') {
        keyIndex++
      }

      if (keyIndex == findIdx) {
        return data[key]
      }

      if (data[key].children) {
        keyIndex = this.findIndexRow(data[key].children!, findIdx, keyIndex)
        if (typeof keyIndex != 'number') {
          return keyIndex
        }
      }
    }
    return keyIndex
  }
  /**
   * 初始化行拖拽
   */
  private initRowDraggable = () => {
    const el = document.querySelector(".ant-table-container .ant-table-content tbody");
    if (!el) return;
    const parentKey = this.table.parentKey
    const sortable = Sortable.create(el as HTMLElement, {
      animation: 200,
      handle: this.table.dragClassname, // 指定只能选中 .drag-row-item
      draggable: '.ant-table-row',
      forceFallback: true,
      // 结束拖拽的事件
      onEnd: async (event: Sortable.SortableEvent) => {
        const {newIndex, oldIndex} = event;
        if (newIndex === oldIndex) return
        const dataSource = cloneDeep(this.table.dataSource) as RecordType[]

        const moveRow = this.findIndexRow(dataSource, oldIndex)
        const replaceRow = this.findIndexRow(dataSource, newIndex)
        // console.log('moveRow --> ', moveRow, replaceRow)
        if (parentKey && moveRow?.[parentKey] !== replaceRow?.[parentKey]) {
          this.table.dataSource = []
          await this.queryAll()
          notification.error({
            message: t("message.fail"),
            description: t("other.The moving position is beyond the movable range!"),
          })
          return
        }
        // console.log('moveRow', moveRow, replaceRow)
        await this.sortable(moveRow.id, replaceRow.id)
        await this.queryAll()
      },
    } as Sortable.SortableOptions);
  };
}
