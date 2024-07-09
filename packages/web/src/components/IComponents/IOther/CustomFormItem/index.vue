<!-- 自定义表单项 -->
<script setup lang="ts">
import {useI18n} from "vue-i18n";
import {computed, inject} from "vue";
import {TableSettingColumns} from "@/types/tableSettingsType";

interface CustomFormItemProps {
  column?: TableSettingColumns;
  options?: any[];
  i18nPrefix?: string;
  i18nPropPrefix?: string; // form | table.column
  typeProp?: string;
}

const {t, te} = useI18n();

const props = withDefaults(defineProps<CustomFormItemProps>(), {
  column: () => ({
    dataIndex: "id",
  }),
  options: () => [],
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
  return (typeof column.placeholder === 'function' ? column.placeholder(model) : column.placeholder)
    || (te(il8nName) ? t(il8nName) : undefined);
});

const typeProp = computed(() => (props.typeProp && column[props.typeProp]) || column.type || 'input');

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
      :placeholder="placeholderProp"
    >
      <custom-input
        v-model:value="model[valueProp]"
        :type="typeProp"
        :placeholder="placeholderProp"
        :tree-data="options"
        :options="options"
        :picker="column.picker"
        v-bind="column.formFieldConfig"
      />
    </slot>
  </a-form-item>
</template>
