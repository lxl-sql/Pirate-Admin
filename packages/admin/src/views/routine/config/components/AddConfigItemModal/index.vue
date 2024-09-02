<script setup lang="ts">
import {computed, inject, reactive, ref} from "vue";
import {Form, notification} from "ant-design-vue";
import {FormTypeEnum, Rules, RuleTypeEnum} from "@/types/form.d";
import {merge} from "lodash-es";
import {useI18n} from "vue-i18n";
import {ConfigItem} from "@/views/routine/config";
import {configCreate} from "@/api/config";
import {enumToOptions} from "@/utils/common";

const {t} = useI18n()

const configGroupList = inject('configGroupList', [])
const emits = defineEmits(['confirm'])

const rules = reactive<Rules>({
  groupId: [{required: true, message: 'Please select the group'}],
  name: [{required: true, message: 'Please input the name'}],
  title: [{required: true, message: 'Please input the title'}],
  type: [{required: true, message: 'Please select the type'}],
})
const formState = reactive<Partial<ConfigItem>>({
  groupId: undefined,
  name: undefined,
  title: undefined,
  type: undefined,
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
  }
  console.log('formState', formState)
  loading.value = true
  try {
    await configCreate(formState)
    emits('confirm')
    notification.success({
      message: t('message.success'),
      description: t('success.create'),
    })
    handleCancel()
  } finally {
    loading.value = false
  }
}

// 变量类型
const typeOptions = computed(() => {
  return enumToOptions(FormTypeEnum, 'key')
})
// 验证规则
const ruleTypeOptions = computed(() => {
  return enumToOptions(RuleTypeEnum, 'key')
})

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
    width="960px"
    :loading="loading"
    :mask-closable="false"
    @cancel="handleCancel"
    @confirm="handleConfirm"
  >
    <a-form
      name="config-item"
      layout="vertical"
    >
      <a-form-item label="变量分组" name="groupId" v-bind="validateInfos.groupId">
        <a-select
          v-model:value="formState.groupId"
          :options="configGroupList"
          :field-names="{label:'title',value:'id'}"
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
      <a-form-item
        v-if="formState.type && ['select','tree-select','cascader','checkbox','radio','radio-button'].includes(formState.type)"
        label="字典数据"
        name="content"
      >
        <a-textarea
          v-model:value="formState.content"
          allow-clear
          rows="3"
          placeholder="一行一个，无需引号，比如：key1=value1"
        />
      </a-form-item>
      <!--      <a-form-item v-if="formState.type" label="默认值" name="value">-->
      <!--        <a-textarea-->
      <!--          v-model:value="formState.value"-->
      <!--          allow-clear-->
      <!--          rows="3"-->
      <!--          placeholder="基本数据类型填写对应值，比如 true&#13对象数据类型请规范格式，比如 [{example: '示例'}]"-->
      <!--        />-->
      <!--      </a-form-item>-->
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
          :options="ruleTypeOptions"
          allow-clear
          mode="multiple"
          placeholder="请选择验证规则"
        />
      </a-form-item>
      <a-form-item label="FormItem 扩展属性" name="extend">
        <a-textarea
          v-model:value="formState.extend"
          allow-clear
          rows="3"
          placeholder="FormItem的扩展属性，一行一个，无需引号，比如：size=large"
        />
      </a-form-item>
      <a-form-item label="Input 扩展属性" name="inputExtend">
        <a-textarea
          v-model:value="formState.inputExtend"
          allow-clear
          rows="3"
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
