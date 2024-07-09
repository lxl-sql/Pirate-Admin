<script setup lang="ts">
import {withDefaults} from 'vue'
import {IColumns} from "@/types";

interface CustomInputProps {
  type?: IColumns['type'],
  options?: any[],
  treeData?: any[]
}

withDefaults(defineProps<CustomInputProps>(), {});
</script>

<template>
  <a-input
    v-if="!type || type === 'input'"
    allow-clear
    v-bind="$attrs"
  />
  <a-input
    v-else-if="type === 'input-number'"
    allow-clear
    v-bind="$attrs"
  />
  <a-input-password
    v-else-if="type === 'input-password'"
    allow-clear
    v-bind="$attrs"
  />
  <a-textarea
    v-else-if="type === 'textarea'"
    allow-clear
    v-bind="$attrs"
  />
  <i-tree-select
    v-else-if="type === 'tree-select'"
    allow-clear
    :tree-data="treeData"
    v-bind="$attrs"
  />
  <a-select
    v-else-if="type === 'select'"
    allow-clear
    :options="options"
    v-bind="$attrs"
  />
  <a-cascader
    v-else-if="type === 'cascader'"
    allow-clear
    :options="options"
    v-bind="$attrs"
  />
  <i-upload
    v-else-if="type === 'upload'"
    v-bind="$attrs"
  />
  <a-radio-group
    v-else-if="type === 'radio'"
    :options="options"
    v-bind="$attrs"
  />
  <a-radio-group
    v-else-if="type === 'radio-button'"
    option-type="button"
    :options="options"
    v-bind="$attrs"
  />
  <a-date-picker
    v-else-if="type === 'date-picker'"
    v-bind="$attrs"
  />
  <a-range-picker
    v-else-if="type === 'range-picker'"
    v-bind="$attrs"
  />
  <i-icon
    v-else-if="type === 'icon'"
    v-bind="$attrs"
  />
</template>
