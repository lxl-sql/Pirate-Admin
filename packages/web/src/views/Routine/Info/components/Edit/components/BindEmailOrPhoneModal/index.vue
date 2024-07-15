<!-- 绑定邮箱 -->
<script setup lang="ts">
import {reactive, ref} from "vue";
import {getRules} from "@/utils/common";
import {Form, notification} from "ant-design-vue";
import {CaptchaType} from "@/types/request";
import {bindCaptcha} from "@/api/auth/admin";
import {useI18n} from "vue-i18n";

const {t} = useI18n()

const rules = reactive({
  email: getRules(['email'], '邮箱'),
  sms: getRules(['required'], '验证码'),
})
const formState = reactive({
  email: '',
  sms: ''
})
const type = ref<CaptchaType>(1)
const open = ref<boolean>(false)
const isCaptchaLoading = ref<boolean>(false)

const {validate, resetFields, validateInfos} = Form.useForm(formState, rules)

const init = (t: CaptchaType) => {
  open.value = true
  type.value = t
}

const handleSendCaptcha = async () => {
  await validate(['email'])
  const params = {
    type: type.value,
    address: formState.email
  }
  isCaptchaLoading.value = true
  try {
    await bindCaptcha(params)
    notification.success({
      message: t('message.success'),
      description: t('success.sent successfully')
    })
  } finally {
    isCaptchaLoading.value = false
  }
}

const handleCancel = () => {
  open.value = false
}
const handleConfirm = async () => {
  await validate()
}

defineOptions({
  name: 'BindEmailOrPhoneModal'
})
defineExpose({
  init
})
</script>

<template>
  <i-modal
    v-model:open="open"
    title="绑定邮箱"
    draggable
    @confirm="handleConfirm"
    @cancel="handleCancel"
  >
    <a-form
      layout="vertical"
    >
      <a-form-item label="邮箱" name="email" v-bind="validateInfos.email">
        <a-input
          v-model:value="formState.email"
          type="email"
          placeholder="请输入邮箱"
        />
      </a-form-item>
      <a-form-item label="验证码" name="sms" v-bind="validateInfos.sms">
        <a-input-search
          v-model:value="formState.sms"
          placeholder="请输入邮箱验证码"
        >
          <template #enterButton>
            <a-button :loading="isCaptchaLoading" @click="handleSendCaptcha">
              获取验证码
            </a-button>
          </template>
        </a-input-search>
      </a-form-item>
    </a-form>
  </i-modal>
</template>

<style scoped lang="less">

</style>
