<script setup lang="ts">
import {computed, useAttrs, withDefaults} from 'vue'
import {FormType} from "@/types";
import {
  Cascader,
  CheckboxGroup,
  DatePicker,
  DatePickerProps,
  Input,
  InputNumber,
  InputPassword,
  RadioGroup,
  RangePicker,
  Select,
  Switch,
  Textarea,
  TimePicker,
  Tree
} from 'ant-design-vue';
import ITreeSelect from "@/components/IComponents/ITreeSelect/index.vue";
import KeyValue from "@/components/IComponents/IInput/components/KeyValue/index.vue";
import IIcon from "@/components/IComponents/IIcon/index.vue";
import IUpload from '@/components/IComponents/IUpload/index.vue'

interface CustomInputProps {
  type?: FormType,
  options?: any[],
  picker?: DatePickerProps['picker']
  checkedKeys?: any
  fileList?: any
  value?: any
}

const props = withDefaults(defineProps<CustomInputProps>(), {});
const $attrs = useAttrs();

const componentType = computed(() => {
  const componentMap: Record<FormType, any> = {
    input: Input,
    'input-password': InputPassword,
    'input-number': InputNumber,
    textarea: Textarea,
    select: Select,
    tree: Tree,
    'tree-select': ITreeSelect,
    cascader: Cascader,
    checkbox: CheckboxGroup,
    radio: RadioGroup,
    'radio-button': RadioGroup,
    'date-picker': DatePicker,
    'range-picker': RangePicker,
    'time-picker': TimePicker,
    upload: IUpload,
    'key-value': KeyValue,
    switch: Switch,
    editor: Input,
    city: Input,
    color: Input,
    icon: IIcon,
  };
  return componentMap[props.type || 'input'];
});

const dynamicProps = computed(() => {
  let baseProps: object | undefined;

  switch (props.type) {
    case 'input':
    case 'input-password':
    case 'input-number':
    case 'textarea':
    case 'color':
      baseProps = {value: props.value, allowClear: true};
      break;

    case 'select':
    case 'tree-select':
    case 'cascader':
    case 'radio':
    case 'radio-button':
      baseProps = {value: props.value, options: props.options, allowClear: true};
      break;

    case 'tree':
      baseProps = {treeData: props.options, checkedKeys: props.checkedKeys};
      break;

    case 'upload':
      baseProps = {fileList: props.fileList};
      break;

    case 'checkbox':
      baseProps = {value: props.value};
      break;

    case 'date-picker':
    case 'range-picker':
    case 'time-picker':
      baseProps = {value: props.value, picker: props.picker};
      break;

    case 'switch':
    case 'icon':
    case 'key-value':
      baseProps = {value: props.value};
      break;

    default:
      baseProps = {}; // 确保至少返回一个空对象
      break;
  }

  return {...baseProps, ...$attrs};
});

</script>

<template>
  <component
    :is="componentType"
    v-bind="dynamicProps"
  >
    <slot></slot>
  </component>
</template>
