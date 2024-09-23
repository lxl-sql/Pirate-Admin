<!-- 绑定邮箱 -->
<script setup lang="ts">
import {computed, reactive, ref} from "vue";
import {getRules} from "@/utils/common";
import {Form, notification} from "ant-design-vue";
import {CaptchaType} from "@/types/request";
import {bindCaptcha, bindInfo} from "@/api/auth/admin";
import {useI18n} from "vue-i18n";
import useCountdown from "@/hooks/useCountdown";
import {CaptchaTypeName} from "@pirate/shared";

const {t} = useI18n()
const {timeLeft, isRunning, start, reset} = useCountdown();

const emits = defineEmits(['confirm'])

const rules = reactive({
  email: getRules(['email'], '邮箱'),
  phone: getRules(['phone'], '手机号'),
  captcha: getRules(['required'], '验证码'),
})
const formState = reactive({
  email: '',
  phone: '',
  captcha: '',
})
const type = ref<CaptchaType>('email') // email: 邮箱; phone: 手机号
const open = ref<boolean>(false)
const loading = ref<boolean>(false)
const isCaptchaLoading = ref<boolean>(false)

const {validate, resetFields, validateInfos} = Form.useForm(formState, rules)

const init = (t: CaptchaType) => {
  open.value = true
  type.value = t
}

const handleSendCaptcha = async () => {
  await validate([type.value])
  const params = {
    type: type.value,
    address: formState[type.value]
  }
  isCaptchaLoading.value = true
  try {
    await bindCaptcha(params)
    notification.success({
      message: t('message.success'),
      description: t('success.sent successfully')
    })
    start(60)
  } finally {
    isCaptchaLoading.value = false
  }
}

const handleCancel = () => {
  open.value = false
  reset()
  resetFields()
}
const handleConfirm = async () => {
  await validate([type.value, 'captcha'])
  const params = {
    type: type.value,
    address: formState[type.value],
    captcha: formState.captcha
  }
  loading.value = true
  try {
    await bindInfo(params)
    emits('confirm')
    handleCancel()
    notification.success({
      message: t('message.success'),
      description: t('success.binding successful')
    })
  } finally {
    loading.value = false
  }
}

const title = computed(() => {
  const name = CaptchaTypeName[type.value]
  if (name) {
    return `绑定${name}`
  }
  return '绑定xxx'
})

defineOptions({
  name: 'BindInfoModal'
})
defineExpose({
  init
})
</script>

<template>
  <i-modal
    v-model:open="open"
    :title="title"
    :loading="loading"
    @confirm="handleConfirm"
    @cancel="handleCancel"
  >
    <a-form
      layout="vertical"
    >
      <a-form-item v-if="type === 'email'" label="邮箱" name="email" v-bind="validateInfos.email">
        <a-input
          v-model:value="formState.email"
          type="email"
          placeholder="请输入邮箱"
          allow-clear
        />
      </a-form-item>
      <a-form-item v-else-if="type === 'phone'" label="手机号" name="phone" v-bind="validateInfos.phone">
        <a-input
          v-model:value="formState.phone"
          type="phone"
          placeholder="请输入手机号"
          allow-clear
        />
      </a-form-item>
      <a-form-item label="验证码" name="captcha" v-bind="validateInfos.captcha">
        <a-input-search
          v-model:value="formState.captcha"
          placeholder="请输入验证码"
          allow-clear
        >
          <template #enterButton>
            <a-button :loading="isCaptchaLoading" :disabled="isRunning" @click="handleSendCaptcha">
              {{ isRunning ? `已发送${timeLeft}秒` : '获取验证码' }}
            </a-button>
          </template>
        </a-input-search>
      </a-form-item>
    </a-form>
  </i-modal>
</template>
