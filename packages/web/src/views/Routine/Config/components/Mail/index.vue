<!-- 邮件配置 -->
<script setup lang="ts">
import {reactive, ref} from "vue";
import {Form, notification} from "ant-design-vue";
import ToEmailModal from "@/views/Routine/Config/components/Mail/components/ToEmailModal/index.vue";
import {Rules} from "@/types/form";
import {saveEmail} from "@/api/config";
import {useI18n} from "vue-i18n";

const {t} = useI18n()

//#region interface
interface FormState {
  host: string; // 站点名称
  port: number; // 备案号
  user: string; // 版本号
  pass: string; // 禁止访问 ip
}

//#endregion

//#region 变量定义
const toEmailModalRef = ref()

const rules = reactive<Rules>({
  host: [{required: true, message: 'Please input the host'}],
  port: [{required: true, message: 'Please input the port'}],
  user: [{required: true, message: 'Please input the user'}],
  pass: [{required: true, message: 'Please input the pass'}],
})
const formState = reactive<FormState>({
  host: "smtp.qq.com",
  port: 465,
  user: "",
  pass: "",
});
const loading = ref<boolean>(false);

const {resetFields, validate, validateInfos} = Form.useForm(formState, rules)
//#endregion

//#region 函数方法
// 测试发送地址
const handleSendEmail = async () => {
  await validate()
  const params = {
    ...formState,
    address: formState.user,
  }
  toEmailModalRef.value.init(params)
};

// 保存
const handleSubmit = async () => {
  await validate()
  loading.value = true;
  try {
    await saveEmail(formState)
    notification.success({
      message: t('message.success'),
      description: t('success.saved successfully'),
    })
  } finally {
    loading.value = false;
  }
};
//#endregion
</script>

<template>
  <a-form
    :wrapper-col="{ span: 16 }"
    name="email"
    layout="vertical"
  >
    <a-form-item label="SMTP 服务器" name="host" v-bind="validateInfos.host">
      <a-input v-model:value="formState.host"/>
    </a-form-item>
    <a-form-item label="SMTP 端口" name="port" v-bind="validateInfos.port">
      <a-input-number
        v-model:value="formState.port"
        class="w-[100%]"
        min="0"
        max="65535"
      />
    </a-form-item>
    <a-form-item label="SMTP 用户名" name="user" v-bind="validateInfos.user">
      <a-input v-model:value="formState.user"/>
    </a-form-item>
    <a-form-item label="SMTP 密码" name="pass" v-bind="validateInfos.pass">
      <a-input v-model:value="formState.pass"/>
    </a-form-item>
    <a-form-item label="SMTP 发件人邮箱">
      <a-input :value="formState.user" disabled/>
    </a-form-item>
  </a-form>
  <a-space direction="vertical">
    <a-button class="!text-xs" size="small" @click="handleSendEmail">
      测试发送地址
    </a-button>
    <a-button type="primary" :loading="loading" @click="handleSubmit">
      保存
    </a-button>
  </a-space>

  <to-email-modal ref="toEmailModalRef"/>
</template>

<style lang="less" scoped>
@import "./index.less";
</style>
