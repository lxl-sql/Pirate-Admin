<!-- 自定义表单项 -->
<script setup lang="ts">
import {useI18n} from "vue-i18n";
import {computed, inject, watch} from "vue";
import {TableSettingColumn} from "@/types/tableSettingsType";
import {IOptions} from "@/types";

interface CustomFormItemProps {
  column?: TableSettingColumn;
  options?: any[];
  i18nPrefix?: string;
  i18nPropPrefix?: string; // form | table.column
  typeProp?: string;
}

const {t, te} = useI18n();

const props = withDefaults(defineProps<CustomFormItemProps>(), {
  column: () => ({
    dataIndex: "id",
    modelProp: 'value'
  })
});

// model
const model = inject('model', {});

const column = props.column;

// value 字段
const valueProp = computed(() => {
  return column.formValueProp || column.dataIndex;
});

const getI18nName = (key: string) => {
  return [props.i18nPrefix, props.i18nPropPrefix, key, column.i18nName || valueProp.value]
    .filter(Boolean)
    .join(".");
};

const labelProp = computed(() => {
  const il8nName = getI18nName("label");
  return column.formLabelProp || (te(il8nName) ? t(il8nName) : column.title);
});

const placeholderProp = computed(() => {
  const il8nName = getI18nName("placeholder");
  const custom = typeof column.placeholder === 'function' ? column.placeholder(model) : column.placeholder;
  return custom || (te(il8nName) ? t(il8nName) : column.title);
});

const typeProp = computed(() => (props.typeProp && column[props.typeProp]) || column.type || 'input');

const getFormFieldConfig = computed(() => {
  return typeof column.formFieldConfig === 'function' ? column.formFieldConfig(model) : column.formFieldConfig
})


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

const showOptions = computed(() => {
  return !column.type || !['select', 'radio', 'radio-button', 'tree-select', 'tree', 'cascader'].includes(column.formType || column.type)
})

const getOptions = computed(() => {
  if (showOptions.value) return
  if (!column.options) return defaultOptions.whether;
  if (props.options) {
    return props.options
  } else if (typeof column.options === 'string') {
    if (['status', 'whether'].includes(column.options)) {
      return defaultOptions[column.options]
    }
    throw new TypeError('options is not IOptions')
  } else {
    return column.options
  }
});

watch(() => column.options, (newValue) => {
  console.log('newValue', newValue)
})

defineOptions({
  name: 'CustomFormItem'
})
</script>

<template>
  <a-form-item
    :label="labelProp"
    :name="valueProp"
    v-bind="$attrs"
  >
    <slot
      :column="column"
      :record="model"
      :value="model[valueProp]"
      :field="valueProp"
      :picker="column.picker"
      :options="getOptions"
      v-bind="getFormFieldConfig"
    >
      <custom-input
        v-model:value="model[valueProp]"
        v-model:checkedKeys="model[valueProp]"
        v-model:fileList="model[valueProp]"
        :type="typeProp"
        :placeholder="placeholderProp"
        :picker="column.picker"
        :options="getOptions"
        v-bind="getFormFieldConfig"
      />
    </slot>
  </a-form-item>
</template>
