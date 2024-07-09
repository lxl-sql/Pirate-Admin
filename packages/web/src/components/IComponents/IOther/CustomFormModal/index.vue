<!-- 自定义表单弹窗 -->
<script setup lang="ts">
import {computed, inject} from "vue";
import {tableSettingKey} from "@/utils/tableSettings";
import {TableSettingColumns, TableSettingsType} from "@/types/tableSettingsType";
import CustomForm from "@/components/IComponents/IOther/CustomForm/index.vue";
import CustomFormItem from "@/components/IComponents/IOther/CustomFormItem/index.vue";

const tableSettings = inject<TableSettingsType>(tableSettingKey, {} as any);

const form = computed(() => tableSettings?.form)
const modal = computed(() => tableSettings?.modal)

// 获取排序字段
const getSort = (column: TableSettingColumns) => {
  return column.formSort || column.sort || 0;
};

// 获取列的 span
const getSpan = (column: TableSettingColumns) => {
  return Number(column.formSpan || form.value?.defaultSpan || 24);
};

// 24 / span
const formColumns = computed(() => {
  if (!tableSettings?.table.columns) return [];
  const rowColumns: TableSettingColumns[][] = [[]];
  let count = 0;
  let idx: number = 0;
  tableSettings?.table.columns
    .filter((column: TableSettingColumns) => column.form && (typeof column.form === 'function' ? column.form(form.value!.fields) : column.form))
    .sort((a, b) => getSort(a) - getSort(b))
    .forEach((column: TableSettingColumns, index: number) => {
      // const _span: number = getSpan(column);
      // if (index % (24 / _span) === 0) {
      //   rowColumns[count] = [];
      //   count++;
      // }
      // rowColumns[count - 1].push(column);
      const _span = getSpan(column);
      count += _span;
      if (24 % count !== 0 && count > 24) {
        rowColumns.push([]);
        idx++;
        count = _span;
      }
      rowColumns[idx].push(column);
    })
  return rowColumns
});

const valueProp = (column: TableSettingColumns) => {
  return column.formValueProp || column.dataIndex;
};

const defaultOptions = [
  {label: '否', value: 0},
  {label: '是', value: 1},
]

const getOptions = (column: TableSettingColumns) => {
  if (typeof column.options === 'function') {
    const dataSource = tableSettings?.table.dataSource || []
    const fields = form.value?.fields
    return column.options(dataSource, fields)
  } else {
    return column.options || defaultOptions
  }
};


const formItemAttrs = (column: TableSettingColumns) => ({
  ...tableSettings?.formRefs?.validateInfos[valueProp(column)],
  ...column.formItemConfig,
});

const modalProps = computed(() => ({
  ...modal.value, // 公共弹窗配置
  ...form.value?.modal, // form 表单弹窗配置
}))

defineOptions({
  name: 'CustomFormModal'
})
</script>

<template>
  <i-modal
    v-if="form"
    :title="$t(form.fields.id ? 'title.update' : 'title.create')"
    @cancel="tableSettings?.cancelForm(1)"
    @confirm="tableSettings?.confirmForm"
    v-bind="modalProps"
  >
    <slot>
      <custom-form
        :name="form.name"
        :columns="formColumns"
        :label-col="{ span: 4 }"
        :default-span="form.defaultSpan"
        :model="form.fields"
        v-bind="form.formConfig"
      >
        <template #col="{column}">
          <custom-form-item
            :column="column"
            :options="getOptions(column)"
            :i18n-prefix="tableSettings.table.i18nPrefix"
            :i18n-prop-prefix="form.i18nPrefixProp"
            type-prop="formType"
            v-bind="formItemAttrs(column)"
          >
            <template #default="scope">
              <slot name="field" v-bind="scope"></slot>
            </template>
          </custom-form-item>
        </template>
      </custom-form>
    </slot>
  </i-modal>
</template>
