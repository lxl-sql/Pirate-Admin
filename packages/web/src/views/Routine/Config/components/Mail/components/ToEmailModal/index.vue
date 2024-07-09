<script setup lang="ts">
import {reactive, ref} from "vue";
import {Form, notification} from "ant-design-vue";
import {Rules} from "@/types/form";
import {testEmail} from "@/api/config";
import {merge} from "lodash-es";
import {useI18n} from "vue-i18n";

const {t} = useI18n()

interface FormState {
  // 收件人邮箱地址
  to?: string
}

const rules = reactive<Rules>({
  to: [{required: true, message: 'Please input the to'}],
})
const formState = reactive<FormState>({
  to: ""
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
  console.log('formState', formState)
  await validate()
  const params = {
    ...formState,
    subject: "测试邮件"
  }
  loading.value = true
  try {
    await testEmail(params)
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
  name: 'ToEmailModal'
})
defineExpose({
  init
})
</script>

<template>
  <i-modal
    v-model:open="open"
    title="测试邮件发送"
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
      <a-form-item label="收件人" name="to" v-bind="validateInfos.to">
        <a-input v-model:value="formState.to" placeholder="请输入测试收件人地址"/>
      </a-form-item>
    </a-form>
  </i-modal>
</template>
