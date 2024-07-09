<script setup lang="ts">
import {reactive, ref} from "vue";
import {Form, notification} from "ant-design-vue";
import {Rules} from "@/types/form";
import {merge} from "lodash-es";
import {useI18n} from "vue-i18n";

const {t} = useI18n()

interface FormState {
  group?: string
  title?: string
  name?: string
  type?: string
  tip?: string
  rule?: string
  content?: string
  value?: string
  extend?: string
  inputExtend?: string
  weight?: number
}

const typeOptions = reactive([])
const ruleOptions = reactive([
  {label: 'password', value: 'password'}
])
const rules = reactive<Rules>({
  to: [{required: true, message: 'Please input the to'}],
})
const formState = reactive<FormState>({
  weight: 0
})
const open = ref<boolean>(false)
const loading = ref<boolean>(false)

const {resetFields, validate, validateInfos} = Form.useForm(formState, rules)

const init = (options) => {
  open.value = true
  merge(formState, options);
}

const handleCancel = () => {
  open.value = false
  resetFields()
}

const handleConfirm = async () => {
  await validate()
  const params = {
    ...formState,
    subject: "测试邮件"
  }
  loading.value = true
  try {
    notification.success({
      message: t('message.success'),
      description: t('other.Test email sent successfully!'),
    })
    handleCancel()
  } finally {
    loading.value = false
  }
}

defineOptions({
  name: 'AddConfigItemModal'
})
defineExpose({
  init
})
</script>

<template>
  <i-modal
    v-model:open="open"
    title="添加配置项"
    draggable
    :loading="loading"
    :mask-closable="false"
    @cancel="handleCancel"
    @confirm="handleConfirm"
  >
    <a-form
      name="to-email"
      autocomplete="off"
      layout="vertical"
    >
      <a-form-item label="变量分组" name="group" v-bind="validateInfos.group">
        <a-input
          v-model:value="formState.group"
          allow-clear
          placeholder="请选择变量分组"
        />
      </a-form-item>
      <a-form-item label="变量名" name="name" v-bind="validateInfos.name">
        <a-input
          v-model:value="formState.name"
          allow-clear
          placeholder="请输入变量名"
        />
      </a-form-item>
      <a-form-item label="变量标题" name="title" v-bind="validateInfos.title">
        <a-input
          v-model:value="formState.title"
          allow-clear
          placeholder="请输入变量标题"
        />
      </a-form-item>
      <a-form-item label="变量类型" name="type" v-bind="validateInfos.type">
        <a-select
          v-model:value="formState.type"
          :options="typeOptions"
          allow-clear
          placeholder="请选择变量类型"
        />
      </a-form-item>
      <a-form-item label="字典数据" name="content">
        <a-textarea
          v-model:value="formState.content"
          allow-clear
          placeholder="一行一个，无需引号，比如：key1=value1"
        />
      </a-form-item>
      <a-form-item label="提示信息" name="tip">
        <a-input
          v-model:value="formState.tip"
          allow-clear
          placeholder="请输入提示信息"
        />
      </a-form-item>
      <a-form-item label="验证规则" name="rule">
        <a-select
          v-model:value="formState.rule"
          :options="ruleOptions"
          allow-clear
          placeholder="请选择验证规则"
        />
      </a-form-item>
      <a-form-item label="FormItem 扩展属性" name="extend">
        <a-textarea
          v-model:value="formState.extend"
          allow-clear
          placeholder="FormItem的扩展属性，一行一个，无需引号，比如：size=large"
        />
      </a-form-item>
      <a-form-item label="Input 扩展属性" name="inputExtend">
        <a-textarea
          v-model:value="formState.inputExtend"
          allow-clear
          placeholder="Input的扩展属性，一行一个，无需引号，比如：size=large"
        />
      </a-form-item>
      <a-form-item label="权重" name="weight">
        <a-input-number
          v-model:value="formState.weight"
          class="w-[100%]"
          min="0"
          placeholder="请输入字段权重"
        />
      </a-form-item>
    </a-form>
  </i-modal>
</template>
