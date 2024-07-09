<script setup lang="ts">
import {IColumns} from "@/types";

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

const getOptions = (column: IColumns) => {
  return typeof column.options === 'function' ? column.options() : column.options || [];
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
