<!-- 自定义详情弹窗 -->
<script setup lang="ts">
import {computed, inject} from "vue";
import {TableSettingColumns, TableSettingsType} from "@/types/tableSettingsType";
import {tableSettingKey} from "@/utils/tableSettings";
import {useI18n} from "vue-i18n";

type Columns = TableSettingColumns

const {t, te} = useI18n();

const tableSettings = inject<TableSettingsType>(tableSettingKey, {} as any);

const detail = computed(() => tableSettings?.detail)
const modal = computed(() => tableSettings?.modal)

const modalProps = computed(() => ({
  ...modal.value, // 公共弹窗配置
  ...detail.value?.modal, // form 表单弹窗配置
}))

// 获取排序字段
const getSort = (column: Columns) => {
  return column.detailSort || column.sort || 0;
};

const detailColumns = computed(() => {
  if (!tableSettings?.table.columns) return [];
  return tableSettings.table.columns
    .filter((column: Columns) => typeof column.detail === 'function' ? column.detail(detail.value!.fields) : column.detail)
    .sort((a, b) => getSort(a) - getSort(b))
})

const getValueName = (column: Columns) => {
  return column.detailValueProp || column.dataIndex;
};

const getI18nName = (column: Columns, key: string) => {
  return [tableSettings.table.i18nPrefix, detail.value.i18nPrefixProp, key, column.i18nName || getValueName(column)]
    .filter(Boolean)
    .join(".");
};

const getLabelName = (column: Columns) => {
  const il8nName = getI18nName(column, "label");
  // console.log('il8nName', il8nName)
  return column.detailLabelProp || (te(il8nName) ? t(il8nName) : column.title);
}

const getValue = (column: Columns) => {
  const value = detail.value?.fields[getValueName(column)]
  return column.detailRender ? column.detailRender(value, detail.value?.fields) : value
}

const getSpan = (column: Columns) => {
  return column.detailSpan || column.span || 1
}

defineOptions({
  name: 'CustomInfoModal'
})
</script>

<template>
  <i-modal
    v-if="detail"
    :title="$t('title.detail')"
    @cancel="tableSettings?.cancelForm"
    v-bind="modalProps"
  >
    <a-descriptions
      bordered
      size="middle"
      :label-style="{width: '150px'}"
      :column="detail.column"
    >
      <a-descriptions-item
        v-for="column in detailColumns"
        :key="column.dataIndex"
        :label="getLabelName(column)"
        :span="getSpan(column)"
      >
        <slot name="field" :column="column" :value="getValue(column)">
          {{ getValue(column) }}
        </slot>
      </a-descriptions-item>
    </a-descriptions>
  </i-modal>
</template>

<style scoped lang="less">

</style>
