<script setup lang="ts">
import {IColumns} from "@/types";
import useFormInstance from "@/hooks/useFormInstance";
import CustomForm from "@/components/IComponents/IOther/CustomForm/index.vue";

interface QueryFormProps {
  columns: IColumns[][];
  defaultSpan?: number;
}

withDefaults(defineProps<QueryFormProps>(), {
  columns: () => ([]),
  defaultSpan: 6
})

const emits = defineEmits(['query', 'reset'])

const [formRef, formInstance] = useFormInstance()
defineExpose(formInstance)

defineOptions({
  name: 'QueryForm'
})
</script>

<template>
  <div class="flex justify-between p-3 border border-solid query-form">
    <custom-form
      ref="formRef"
      layout="inline"
      class="flex-1"
      :columns="columns"
      :default-span="defaultSpan"
      v-bind="$attrs"
    >
      <template #col="{column}">
        <slot :column="column"/>
      </template>
    </custom-form>
    <a-space class="ml-4 self-end">
      <a-button type="primary" @click="emits('query')">查询</a-button>
      <a-button @click="emits('reset')">重置</a-button>
    </a-space>
  </div>
</template>

<style lang="less" scoped>
@import "./index.less";
</style>
