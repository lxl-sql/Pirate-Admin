<script setup lang="ts">
import {withDefaults} from 'vue'
import {IColumns} from "@/types";
import {DatePickerProps, TimePicker as ATimePicker} from 'ant-design-vue';

interface CustomInputProps {
  type?: IColumns['type'],
  options?: any[],
  picker?: DatePickerProps['picker']
  checkedKeys?: any
  fileList?: any
  value?: any
}

withDefaults(defineProps<CustomInputProps>(), {});
</script>

<template>
  <a-input
    v-if="!type || type === 'input'"
    allow-clear
    :value="value"
    v-bind="$attrs"
  />
  <a-input-number
    v-else-if="type === 'input-number'"
    allow-clear
    :value="value"
    v-bind="$attrs"
  />
  <a-input-password
    v-else-if="type === 'input-password'"
    allow-clear
    :value="value"
    v-bind="$attrs"
  />
  <a-textarea
    v-else-if="type === 'textarea'"
    allow-clear
    :rows="3"
    :value="value"
    v-bind="$attrs"
  />
  <i-tree-select
    v-else-if="type === 'tree-select'"
    allow-clear
    :tree-data="options"
    :value="value"
    v-bind="$attrs"
  />
  <a-tree
    v-else-if="type === 'tree'"
    :tree-data="options"
    :checked-keys="checkedKeys"
    v-bind="$attrs"
  />
  <a-select
    v-else-if="type === 'select'"
    allow-clear
    :options="options"
    :value="value"
    v-bind="$attrs"
  />
  <a-cascader
    v-else-if="type === 'cascader'"
    allow-clear
    :options="options"
    :value="value"
    v-bind="$attrs"
  />
  <i-upload
    v-else-if="type === 'upload'"
    :file-list="fileList"
    v-bind="$attrs"
  />
  <a-checkbox-group
    v-else-if="type === 'checkbox'"
    :value="value"
    v-bind="$attrs"
  />
  <a-radio-group
    v-else-if="type === 'radio'"
    :options="options"
    :value="value"
    v-bind="$attrs"
  />
  <a-radio-group
    v-else-if="type === 'radio-button'"
    option-type="button"
    :options="options"
    :value="value"
    v-bind="$attrs"
  />
  <a-date-picker
    v-else-if="type === 'date-picker'"
    :picker="picker"
    :value="value"
    v-bind="$attrs"
  />
  <a-range-picker
    v-else-if="type === 'range-picker'"
    :picker="picker"
    :value="value"
    v-bind="$attrs"
  />
  <a-time-picker
    v-else-if="type === 'time-picker'"
    :picker="picker"
    :value="value"
    value-format="HH:mm:ss"
  />
  <a-switch
    v-else-if="type === 'switch'"
    :value="value"
    v-bind="$attrs"
  />
  <i-icon
    v-else-if="type === 'icon'"
    :value="value"
    v-bind="$attrs"
  />
  <a-input
    v-if="type === 'color'"
    type="color"
    allow-clear
    :value="value"
    v-bind="$attrs"
  />
  <key-value
    v-if="type === 'key-value'"
    :value="value"
    v-bind="$attrs"
  />
</template>
