<!-- 自定义详情弹窗 -->
<script setup lang="ts">
import {computed, inject} from "vue";
import {TableSettingColumn, TableSettingsType} from "@/types/tableSettingsType";
import {tableSettingKey} from "@/utils/tableSettings";
import {useI18n} from "vue-i18n";
import {IModalProps} from "@/components/IComponents/IModal/types";

type Columns = TableSettingColumn

const {t, te} = useI18n();

const setting = inject<TableSettingsType>(tableSettingKey, {} as any);

const detail = computed(() => setting.detail || {})
const modal = computed(() => setting.modal || {})

const modalProps = computed<IModalProps>(() => ({
  ...modal.value, // 公共弹窗配置
  ...detail.value.modal, // form 表单弹窗配置
}))

// 获取排序字段
const getSort = (column: Columns) => {
  return column.detailSort || column.sort || 0;
};

const detailColumns = computed(() => {
  if (!setting.table.columns) return [];
  return setting.table.columns
    .filter((column: Columns) => typeof column.detail === 'function' ? column.detail(detail.value.fields) : column.detail)
    .sort((a, b) => getSort(a) - getSort(b))
})

const getValueProp = (column: Columns) => {
  return column.detailValueProp || column.dataIndex;
};

const getI18nName = (column: Columns, key: string) => {
  return [setting.table.i18nPrefix, detail.value.i18nPrefixProp, key, column.i18nName || getValueProp(column)]
    .filter(Boolean)
    .join(".");
};

const getLabelName = (column: Columns) => {
  const il8nName = getI18nName(column, "label");
  // console.log('il8nName', il8nName)
  return column.detailLabelProp || (te(il8nName) ? t(il8nName) : column.title);
}

const getValue = (column: Columns, index: number) => {
  const value = detail.value.fields?.[getValueProp(column)]
  return column.detailRender ? column.detailRender(value, detail.value.fields, index) : value
}

const getSpan = (column: Columns) => {
  return column.detailSpan || column.span || 1
}
defineOptions({
  name: 'ICrudDetailModal'
})
</script>

<template>
  <i-modal
    v-if="detail"
    :title="$t('title.detail')"
    @cancel="() => setting.cancelForm(2)"
    v-bind="modalProps"
  >
    <a-descriptions
      v-if="detailColumns.length"
      bordered
      size="small"
      :label-style="{width: '150px'}"
      :column="detail.column"
      v-bind="detail.descriptionsConfig"
    >
      <a-descriptions-item
        v-for="(column,index) in detailColumns"
        :key="column.dataIndex"
        :label="getLabelName(column)"
        :span="getSpan(column)"
      >
        <slot name="field" :column="column" :value="getValue(column, index)">
          {{ getValue(column, index) }}
        </slot>
      </a-descriptions-item>
    </a-descriptions>
    <slot name="detailAfter" :fields="detail.fields"/>
  </i-modal>
</template>
