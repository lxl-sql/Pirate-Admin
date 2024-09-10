<!-- 自定义表单弹窗 -->
<script setup lang="ts">
import {computed, inject} from "vue";
import {tableSettingKey} from "@/utils/tableSettings";
import {TableSettingColumn, TableSettingColumns, TableSettingsType} from "@/types/tableSettingsType";
import {IModalProps} from "@/components/IComponents/IModal/types";
import {useI18n} from "vue-i18n";
import CustomForm from "@/components/IComponents/IOther/CustomForm/index.vue";

type Column = TableSettingColumn

const {t} = useI18n()

const tableSettings = inject<TableSettingsType>(tableSettingKey, {} as any);

const form = computed(() => tableSettings?.form)
const modal = computed(() => tableSettings?.modal)

// 获取排序字段
const getSort = (column: Column) => {
  return column.formSort || column.sort || 0;
};

// 获取列的 span
const getSpan = (column: Column) => {
  return Number(column.formSpan || form.value?.defaultSpan || 24);
};

// 24 / span
const formColumns = computed(() => {
  if (!tableSettings?.table.columns) return [];
  const columns = tableSettings.table.columns;
  const layout = form.value.layout;
  const newColumns = columns
    .filter((column: Column) => {
      return column.form && (typeof column.form === 'function' ? column.form(form.value.fields) : column.form)
    })
    .sort((a, b) => getSort(a) - getSort(b));
  if (layout === 'multiple-columns') {
    // 一行多列
    const rowColumns: TableSettingColumns<'multiple-columns'> = [[]];
    let count = 0;
    let idx: number = 0;
    newColumns.forEach((column: Column, index: number) => {
      const span = getSpan(column);
      count += span;
      if (24 % count !== 0 && count > 24) {
        rowColumns.push([]);
        idx++;
        count = span;
      }
      rowColumns[idx].push(column);
    })
    return rowColumns
  }
  return newColumns
});

const valueProp = (column: Column) => {
  return column.formValueProp || column.dataIndex;
};

const getOptions = (column: Column) => {
  if (typeof column.options === 'function') {
    const dataSource = tableSettings?.table.dataSource || []
    const fields = form.value?.fields
    return column.options(dataSource, fields)
  }
};


const formItemAttrs = (column: Column) => ({
  ...tableSettings?.formRefs?.validateInfos[valueProp(column)],
  ...column.formItemConfig,
});

const modalProps = computed<IModalProps>(() => ({
  ...modal.value, // 公共弹窗配置
  ...form.value?.modal, // form 表单弹窗配置
}))

defineOptions({
  name: 'ICrudFormModal'
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
        span-prop="formSpan"
        :name="form.name"
        :columns="formColumns"
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
