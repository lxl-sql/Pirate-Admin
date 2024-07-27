<!-- 自定义表单 -->
<script setup lang="ts">
import useFormInstance from "@/hooks/useFormInstance";
import {provide} from "vue";
import {TableSettingColumns} from "@/types/tableSettingsType";

interface QueryFormProps {
  columns: TableSettingColumns[][];
  defaultSpan?: number;
  gutter?: number;
  model?: Record<string, any>;
}

const props = withDefaults(defineProps<QueryFormProps>(), {
  columns: () => ([]),
  defaultSpan: 24
})

const [formRef, formInstance] = useFormInstance()

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
    v-bind="$attrs"
  >
    <a-row
      v-for="(_columns, index) in columns"
      :key="index"
      class="w-[100%]"
      :gutter="gutter"
    >
      <a-col
        v-for="(column) in _columns"
        :key="column.dataIndex"
        :span="column.span || defaultSpan"
      >
        <slot name="col" :column="column"/>
      </a-col>
    </a-row>
  </a-form>
</template>
