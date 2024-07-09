<!-- 基础配置 -->
<script setup lang="ts">
import { reactive, ref, toRaw } from "vue";
import { Form } from "ant-design-vue";

//#region interface
interface IFormState {
  site_name: string; // 站点名称
  record_no: string; // 备案号
  version: string; // 版本号
  no_access_ip: string; // 禁止访问 ip
}
//#endregion

//#region 变量定义
const useForm = Form.useForm;
// 校验规则
const rules = reactive({
  site_name: [{ required: true, message: "请输入本站站点名称" }],
  version: [{ required: true, message: "请输入系统版本号" }],
});
const formState = reactive<IFormState>({
  site_name: "",
  record_no: "",
  version: "",
  no_access_ip: "",
});
const { resetFields, validate, validateInfos } = useForm(formState, rules);
const isSubmitBtnLoading = ref<boolean>(false);
//#endregion

//#region 函数方法
// 保存
const onSubmit = async () => {
  try {
    await validate();
    isSubmitBtnLoading.value = true;
    console.log("res", toRaw(formState));
  } catch (error) {
    console.log("error", error);
  } finally {
    isSubmitBtnLoading.value = false;
  }
};
//#endregion
</script>

<template>
  <a-form
    ref="formRef"
    :model="formState"
    name="basic"
    :wrapper-col="{ span: 16 }"
    autocomplete="off"
    layout="vertical"
    :rules="rules"
  >
    <a-form-item label="站点名称" v-bind="validateInfos.site_name">
      <a-input v-model:value="formState.site_name" placeholder="本站站点名称" />
    </a-form-item>
    <a-form-item label="备案号">
      <a-input
        v-model:value="formState.record_no"
        placeholder="本站域名备案号"
      />
    </a-form-item>
    <a-form-item label="版本号" v-bind="validateInfos.version">
      <a-input v-model:value="formState.version" placeholder="系统版本号" />
    </a-form-item>
    <a-form-item label="禁止访问IP">
      <a-textarea
        v-model:value="formState.no_access_ip"
        placeholder="禁止访问站点的IP列表，一行一个"
      />
    </a-form-item>
  </a-form>
  <a-button type="primary" @click="onSubmit" :loading="isSubmitBtnLoading">
    保存
  </a-button>
</template>

<style lang="less" scoped>
@import "./index.less";
</style>
