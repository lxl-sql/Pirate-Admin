<!-- 角色组管理 -->
<script setup lang="ts">
import {SearchOutlined, TableOutlined,} from "@ant-design/icons-vue";
import {computed, onMounted, ref, toRaw, watch, withDefaults} from "vue";
import {IColumns, IPagination, RecordType} from "@/types";
import {useI18n} from "vue-i18n";
import {cloneDeep} from "lodash-es";
import {ITableProps} from "@/types/table";
import CloseAlert from "../IOther/CloseAlert/index.vue";
import QueryForm from "./components/QueryForm/index.vue";
import QueryFormItem from "./components/QueryFormItem/index.vue";
import useFormInstance from "@/hooks/useFormInstance";

// 国际化
const {locale, te, t} = useI18n();

//#region interface
// 菜单/搜索
type OperationRadioType = "menu" | "search";

//#endregion

//# region props/emits
const props = withDefaults(defineProps<ITableProps>(), {
  columns: () => [],
  dataSource: () => [],
  pagination: () => ({
    // 可能是这边的问题 要是有分页问题吧
    pageSize: 10,
    current: 1,
    total: 0,
  }),
  pages: () => ({
    size: 10,
    page: 1,
    total: 0,
  }),
  operationKey: "operation", // 默认操作列的 Key名
  size: "small",
  rowKey: "key",
  childrenColumnName: "children", // 默认 'children'
  dragClassname: ".drag-row-item",
  keywordPlaceholder: undefined, // t("placeholder.keyword")
  defaultSpan: 6,
  keywordVisible: true,
  loading: false,
  defaultExpandAllRows: false,
  draggable: false,
});
const emits = defineEmits([
  "pagesChange", // 页码发生变化时
  "searchBlur", // 表格搜索
  "query",
  "reset",
  "dragStart",
  "dragEnd"
]);
//# endregion
const [formRef, formInstance] = useFormInstance()

const columnsCache: any[] = cloneDeep(props.columns).filter(column => !column.hide); // 缓存 columns

const menuChecked = ref<string[]>([]); // 选中显示隐藏表头
const menuCheckList = ref<any[]>([]); // 表头的数据列
const expandedRowKeys = ref<string[]>([]);
const oldKeyword = ref<string>(""); // 旧的 搜索内容 防止重复调用接口
const keyword = ref<string>(""); // 搜索
const operationRadio = ref<OperationRadioType | undefined>();
const isOpenSearch = ref<boolean>(false); // 展开搜索栏区域
const menuCheckAll = ref<boolean>(true); // 全选

onMounted(() => {
  // 修改 columns
  menuCheckList.value = columnsCache.filter(
    (column: any) => ![column.dataIndex, column.key].includes(props.operationKey)
  );
  menuChecked.value = menuCheckList.value.map((column) => column.dataIndex);

  // 默认是否展开
  props.defaultExpandAllRows && expandAllRows();
});

// 监听 展开收起
watch(
  () => props.defaultExpandAllRows,
  () => expandAllRows()
);

// 监听 menuChecked
watch(
  () => menuChecked.value,
  (menuChecked) => {
    menuCheckAll.value = menuChecked.length === menuCheckList.value.length;
  }
);

/**
 * @description: 有值置空 没有赋值
 * @param key
 */
const handleMenuOrSearchRadio = (key: OperationRadioType) => {
  // operationRadio.value = operationRadio.value === key ? undefined : key;
  if (key === "search") {
    isOpenSearch.value = !isOpenSearch.value;
  }
};

const handleMenuCheckAll = () => {
  if (menuCheckAll.value) {
    menuChecked.value = [];
  } else {
    menuChecked.value = menuCheckList.value.map((item) => item.dataIndex);
  }
};

/**
 * @description 获取行的 key
 * @param record
 */
const getRowKey = (record: RecordType) => {
  const rowKey = props.rowKey;
  if (typeof rowKey === "function") return rowKey(record);
  return rowKey || "key";
};

// 展开收起 - 内置 务必添加 key
const expandAllRows = () => {
  const childrenColumnName = props.childrenColumnName;
  let keys: string[] = [];
  if (props.defaultExpandAllRows) {
    // 递归 children key值
    void (function childrenFn(list: RecordType[]) {
      list.forEach((item) => {
        const rowKey = getRowKey(item);
        // 是否存在 key
        if (!item[rowKey]) throw new Error("no key in" + JSON.stringify(item));
        keys.push(item[rowKey]);
        //若子数组存在 children 继续递归
        if (item[childrenColumnName]) childrenFn(item[childrenColumnName]);
      });
    })(props.dataSource);
  } else {
    keys = [];
  }
  expandedRowKeys.value = keys;
};

/** 分页
 * @param {IPagination} pagination 当前分页的所有配置参数
 */
const handlePageSizeChange = (pagination: IPagination) => {
  if (!pagination) throw new Error("pagination is undefined");
  const {current = 1, pageSize = 10, total = 0} = pagination;
  const pages = {
    size: pageSize,
    page: current,
    total: total,
  };
  emits("pagesChange", pages);
};

// 表格可伸缩
const handleResizeColumn = (w: number, col: any) => {
  col.width = w;
};

/**
 * @description 表格上方搜索框失焦 搜索 input blur 事件
 */
const handleSearchBlur = () => {
  // 当新数据 = 旧数据 不传输事件
  if (keyword.value === oldKeyword.value) return;
  oldKeyword.value = keyword.value;
  emits("searchBlur", keyword.value);
};

const pagination = computed(() => {
  return props.pagination === false
    ? false
    : {
      showQuickJumper: true,
      showSizeChanger: true,
      showTotal: showTotal,
      total: props.pages.total,
      pageSize: props.pages.size,
      current: props.pages.page,
    };
});

// 获取排序字段
const getSort = (column: IColumns) => {
  return column.querySort || column.sort || 0;
};

// 获取列的 span
const getSpan = (column: IColumns) => {
  return Number(column.span || props.defaultSpan || 6);
};
/**
 * @description 表单搜索配置项 使用缓存的 columns
 */
const formColumns = computed(() => {
  const rowColumns: IColumns[][] = [];
  let count = 0;
  columnsCache
    .filter((column: IColumns) => column.search)
    .sort((a, b) => getSort(a) - getSort(b))
    .forEach((column: IColumns, index: number) => {
      const _span: number = getSpan(column);
      if (index % (24 / _span) === 0) {
        rowColumns[count] = [];
        count++;
      }
      rowColumns[count - 1].push(column);
    });
  return rowColumns;
});

/**
 * @description 表格列配置项
 */
const columnsComputed = computed(() => {
  return cloneDeep(columnsCache)
    .filter((column: any) =>
      [...menuChecked.value, props.operationKey].includes(
        column.key || column.dataIndex
      )
    );
});

/**
 * @description 搜索查询
 */
const onQuery = () => {
  emits("query", toRaw(props.model));
};

const onReset = () => {
  formRef.value?.resetFields();
  emits("reset");
};

/**
 * 获取表格头部名称
 * @param column
 */
const getHeaderCellName = (column: IColumns) => {
  // 是否开启国际化 默认全局开启 优先级 isI18n > isI18nGlobal
  const startI18n = typeof column.isI18n !== 'boolean' ? props.isI18nGlobal : column.isI18n
  if (!startI18n) return column.title;
  const il8nName = (column.i18nName || column.dataIndex) as string;
  const title = [props.i18nPrefix, "table.columns", il8nName].filter(Boolean).join(".")
  return te(title) ? t(title) : title;
};

/**
 * @description 显示总条数
 * @param total 总条数
 */
const showTotal = (total: number) => {
  if (locale.value === "en") return `Total ${total} items`;
  return `共 ${total} 条`;
};


defineExpose(formInstance);
defineOptions({
  name: 'ITable'
})
</script>

<template>
  <div class="default-main">
    <div class="container-table">
      <close-alert :message="remark"/>
      <!-- queryForm -->
      <transition name="rotate-in">
        <!-- z-0 层级低于 i-table-header -->
        <div
          v-if="isOpenSearch && formColumns.length"
          class="i-table-form relative z-0 pb-0 origin-bottom overflow-hidden"
        >
          <slot name="queryForm">
            <query-form
              ref="formRef"
              :model="model"
              :columns="formColumns"
              :default-span="defaultSpan"
              @keyup.enter.native="onQuery"
              @query="onQuery"
              @reset="onReset"
              v-bind="queryConfig"
            >
              <template #default="scope">
                <slot v-bind="scope">
                  <query-form-item :column="scope.column" :model="model"/>
                </slot>
              </template>
            </query-form>
          </slot>
        </div>
      </transition>
      <div class="i-table-header">
        <!-- 左侧按钮 可自定义左侧按钮内容 -->
        <a-space>
          <slot name="leftActions"></slot>
        </a-space>
        <!-- 右侧功能区域 -->
        <a-space>
          <a-input
            v-if="keywordVisible"
            v-model:value="keyword"
            :placeholder="keywordPlaceholder || $t('placeholder.keyword')"
            allow-clear
            class="i-table-header_search"
            @blur="handleSearchBlur"
          />
          <a-radio-group class="flex">
            <a-popover
              trigger="click"
              placement="bottomRight"
              overlay-class-name="i-popover-menu"
            >
              <template #content>
                <!--  全选  -->
                <label class="i-popover-item block !text-left">
                  <a-checkbox
                    v-model:checked="menuCheckAll"
                    class="whitespace-nowrap"
                    @click="handleMenuCheckAll"
                  >
                    全选
                  </a-checkbox>
                </label>
                <!--  这是两部分  -->
                <a-checkbox-group v-model:value="menuChecked" class="w-[100%]">
                  <label
                    v-for="item in menuCheckList as any"
                    :key="item.key || item.dataIndex"
                    class="i-popover-item block !text-left"
                  >
                    <a-checkbox
                      :value="item.key || item.dataIndex"
                      class="whitespace-nowrap"
                    >
                      {{ item.title }}
                    </a-checkbox>
                  </label>
                </a-checkbox-group>
              </template>
              <a-radio-button
                value="menu"
                :title="$t('title.filter')"
                @click="handleMenuOrSearchRadio('menu')"
              >
                <table-outlined/>
              </a-radio-button>
            </a-popover>
            <a-tooltip v-if="formColumns.length" placement="bottomRight">
              <template #title v-if="!isOpenSearch">
                {{ $t("title.expandUniversalSearch") }}
              </template>
              <a-radio-button
                value="search"
                @click="handleMenuOrSearchRadio('search')"
              >
                <search-outlined/>
              </a-radio-button>
            </a-tooltip>
          </a-radio-group>
        </a-space>
      </div>
      <div class="i-table-main">
        <slot
          name="table"
          :columns="columnsComputed"
          :loading="{ spinning: loading, tip: $t('title.loading') }"
          :data-source="dataSource"
          :row-key="rowKey"
          :pagination="pagination"
          v-bind="$attrs"
        >
          <a-table
            v-model:expanded-row-keys="expandedRowKeys"
            :row-key="rowKey"
            :row-selection="rowSelection"
            :data-source="dataSource"
            :loading="{ spinning: loading, tip: $t('title.loading') }"
            :columns="columnsComputed"
            :children-column-name="childrenColumnName"
            :size="size"
            :pagination="pagination"
            bordered
            @resize-column="handleResizeColumn"
            @change="handlePageSizeChange"
            v-bind="$attrs"
          >
            <template #headerCell="{ column,...resetScope }">
              <slot name="headerCell" :column="column" v-bind="resetScope">
                {{ getHeaderCellName(column) }}
              </slot>
            </template>
            <template #bodyCell="score">
              <slot name="bodyCell" v-bind="score"/>
            </template>
          </a-table>
        </slot>
      </div>
    </div>
  </div>
</template>

<style lang="less" scoped>
@import "index.less";
</style>
