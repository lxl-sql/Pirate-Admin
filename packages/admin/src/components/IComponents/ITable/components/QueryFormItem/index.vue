<script setup lang="ts">
import {IColumns, IOptions} from "@/types";
import {useI18n} from "vue-i18n";

const {t} = useI18n()

interface QueryFormItemProps {
  column: IColumns;
  model: Record<string, any>;
}

withDefaults(defineProps<QueryFormItemProps>(), {
  column: () => ({
    dataIndex: "default",
  }),
  model: () => ({}),
});

const defaultOptions: Record<string, IOptions[]> = {
  // 默认 1 是; 0 否
  whether: [
    {label: t('enum.whether.1'), value: 1},
    {label: t('enum.whether.0'), value: 0},
  ],
  // 默认 1 启用 0 禁用
  status: [
    {label: t('enum.status.1'), value: 1},
    {label: t('enum.status.0'), value: 0},
  ]
}

const getOptions = (column: IColumns): IOptions[] => {
  if (typeof column.options === 'function') {
    return column.options()
  } else if (typeof column.options === 'string') {
    if (['status', 'whether'].includes(column.options)) {
      return defaultOptions[column.options]
    }
    throw new TypeError('options is not IOptions')
  } else {
    return column.options || defaultOptions.whether
  }
};

const typeProp = (column: IColumns) => {
  return column.searchType || column.type;
};

const valueProp = (column: IColumns) => {
  return column.searchValueProp || column.dataIndex;
};

defineOptions({
  name: 'QueryFormItem'
})
</script>

<template>
  <a-form-item
    :label="column.searchLabelProp || column.title"
    :name="valueProp(column)"
    class="i-form-item"
    v-bind="$attrs"
  >
    <slot :name="`${column.dataIndex}Search`">
      <!-- input 输入框 -->
      <a-input
        v-if="!typeProp(column) || typeProp(column) === 'input'"
        v-model:value="model[valueProp(column)]"
        allow-clear
        :placeholder="column.title || column.placeholder"
        v-bind="column.queryFieldConfig"
      />
      <!-- select 下拉框 -->
      <a-select
        v-else-if="typeProp(column) === 'select'"
        v-model:value="model[valueProp(column)]"
        allow-clear
        :placeholder="column.title || column.placeholder"
        v-bind="column.queryFieldConfig"
      >
        <a-select-option
          v-for="option in getOptions(column)"
          :key="option.value"
          :value="option.value"
        >
          {{ option.label }}
        </a-select-option>
      </a-select>
      <a-cascader
        v-else-if="typeProp(column) === 'cascader'"
        v-model:value="model[valueProp(column)]"
        :options="column.options"
        :placeholder="column.title || column.placeholder"
        allow-clear
        v-bind="column.queryFieldConfig"
      />
      <!-- radio 单选框 -->
      <a-radio-group
        v-else-if="typeProp(column) === 'radio'"
        v-model:value="model[valueProp(column)]"
        v-bind="column.queryFieldConfig"
      >
        <a-radio
          v-for="option in getOptions(column)"
          :key="option.value"
          :value="option.value"
        >
          {{ option.label }}
        </a-radio>
      </a-radio-group>
      <!-- date-picker 日期选择框 -->
      <a-date-picker
        v-else-if="typeProp(column) === 'date-picker'"
        v-model:value="model[valueProp(column)]"
        :picker="column.picker"
        v-bind="column.queryFieldConfig"
      />
      <a-range-picker
        v-else-if="typeProp(column) === 'range-picker'"
        v-model:value="model[valueProp(column)]"
        :picker="column.picker"
        v-bind="column.queryFieldConfig"
      />
    </slot>
  </a-form-item>
</template>
