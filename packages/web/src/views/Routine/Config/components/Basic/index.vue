<!-- 基础配置 -->
<script setup lang="ts">
import {reactive, ref} from "vue";
import {Form} from "ant-design-vue";

//#region interface
interface FormState {
  // 站点名称
  siteName?: string;
  // 备案号
  recordNo?: string;
  // 版本号
  version?: string;
  // 禁止访问 ip
  noAccessIp?: string;
  // 时区
  timeZone?: string;
}

//#endregion

//#region 变量定义
// 校验规则
const rules = reactive({
  siteName: [{required: true, message: "请输入本站站点名称"}],
  version: [{required: true, message: "请输入系统版本号"}],
  timeZone: [{required: true, message: "请输入时区"}],
});
const formState = reactive<FormState>({});

const {resetFields, validate, validateInfos} = Form.useForm(formState, rules);

const loading = ref<boolean>(false);
//#endregion

//#region 函数方法
// 保存
const handleSubmit = async () => {
  await validate();
  try {
    loading.value = true;
    console.log("res", formState);
  } finally {
    loading.value = false;
  }
};
//#endregion
</script>

<template>
  <a-form
    name="basic"
    :wrapper-col="{ span: 16 }"
    layout="vertical"
  >
    <a-form-item label="站点名称" v-bind="validateInfos.siteName">
      <a-input
        v-model:value="formState.siteName"
        placeholder="本站站点名称"
      />
    </a-form-item>
    <a-form-item label="备案号">
      <a-input
        v-model:value="formState.recordNo"
        placeholder="本站域名备案号"
      />
    </a-form-item>
    <a-form-item label="版本号" v-bind="validateInfos.version">
      <a-input
        v-model:value="formState.version"
        placeholder="系统版本号"
      />
    </a-form-item>
    <a-form-item label="时区" v-bind="validateInfos.timeZone">
      <a-input
        v-model:value="formState.timeZone"
        placeholder="系统时区"
      />
    </a-form-item>
    <a-form-item label="禁止访问IP">
      <a-textarea
        v-model:value="formState.noAccessIp"
        rows="4"
        placeholder="禁止访问站点的IP列表，一行一个"
      />
    </a-form-item>
  </a-form>
  <a-button type="primary" :loading="loading" @click="handleSubmit">
    保存
  </a-button>
</template>

<style lang="less" scoped>
@import "./index.less";
</style>
