<!-- 自定义表单 -->
<script setup lang="ts">
import useFormInstance from "@/hooks/useFormInstance";
import {computed, provide} from "vue";
import {FormLayout} from "@/types/form";

export interface CustomFormProps {
  columns?: any[];
  defaultSpan?: number;
  gutter?: number | object | [number, number];
  model?: Record<string, any>;
  /**
   * 自定义span的prop
   */
  spanProp?: string;
  layout?: FormLayout;
}

const props = withDefaults(defineProps<CustomFormProps>(), {
  columns: () => ([]),
  defaultSpan: 24,
  gutter: () => ({sm: 16}),
  spanProp: 'span',
  layout: 'horizontal'
})

const [formRef, formInstance] = useFormInstance()

const layoutProp = computed<FormLayout>(() => {
  if (props.layout === 'multiple-columns') {
    return 'horizontal'
  }
  return props.layout
})

provide('model', props.model)

defineExpose(formInstance)

defineOptions({
  name: 'CustomForm'
})
</script>

<template>
  <a-form
    ref="formRef"
    autocomplete="off"
    :model="model"
    :layout="layoutProp"
    v-bind="$attrs"
  >
    <template v-if="layout === 'multiple-columns'">
      <a-row
        v-for="(_columns, index) in columns"
        :key="index"
        class="w-[100%]"
        :gutter="gutter"
      >
        <a-col
          v-for="(column) in _columns"
          :key="column.dataIndex"
          :span="column[spanProp] || defaultSpan"
          :xs="24"
          :md="12"
          :xl="column[spanProp] || defaultSpan"
        >
          <slot name="col" :column="column"/>
        </a-col>
      </a-row>
    </template>
    <template v-else>
      <template v-for="(column) in columns" :key="column.dataIndex">
        <slot name="col" :column="column"/>
      </template>
    </template>
  </a-form>
</template>
