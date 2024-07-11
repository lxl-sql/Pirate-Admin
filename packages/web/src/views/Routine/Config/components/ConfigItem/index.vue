<!-- 配置项 -->
<script setup lang="ts">
import {reactive, ref} from "vue";
import {ConfigItem} from "../../index.d";
import {RuleObject} from "ant-design-vue/es/form";
import {RuleType, RuleTypeEnum} from "@/types/form.d";

interface ConfigItemProps {
  items: ConfigItem[]
}

const props = defineProps<ConfigItemProps>()

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
const formRef = ref()
const formState = reactive<FormState>({});

const loading = ref<boolean>(false);
//#endregion

//#region 函数方法
const getRules = (types?: RuleType[]) => {
  if (!types) return []

  const rules: RuleObject[] = [];

  types.forEach((type) => {
    switch (type) {
      case 'required':
        rules.push({required: true});
        break;
      case 'phone':
        rules.push({pattern: /^1[3-9]\d{9}$/, message: '请输入有效的手机号'});
        break;
      case 'idCard':
        rules.push({pattern: /^\d{15}|\d{18}$/, message: '请输入有效的身份证号'});
        break;
      case 'username':
        rules.push({pattern: /^[a-zA-Z0-9_]{3,16}$/, message: '请输入有效的用户名'});
        break;
      case 'password':
        rules.push({pattern: /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{6,20}$/, message: '请输入有效的密码'});
        break;
      default:
        rules.push({type, message: `请输入有效的${RuleTypeEnum[type]}`});
        break;
    }
  });

  return rules
}
// 保存
const handleSubmit = async () => {
  await formRef.value.validate();
  try {
    loading.value = true;
    console.log("res", formState);
    formRef.value.resetFields()
  } finally {
    loading.value = false;
  }
};
//#endregion

defineOptions({
  name: "ConfigItem"
})
</script>

<template>
  <a-form
    ref="formRef"
    name="config"
    :model="formState"
    :wrapper-col="{ span: 16 }"
    layout="vertical"
  >
    <a-form-item
      v-for="item in items"
      :key="item.name"
      :label="item.title"
      :name="item.name"
      :rules="getRules(item.rule)"
      v-bind="item.extend"
    >
      <custom-input
        v-model:value="formState[item.name]"
        :type="item.type"
        :placeholder="item.title"
        v-bind="item.inputExtend"
      />
    </a-form-item>
  </a-form>
  <a-button type="primary" :loading="loading" @click="handleSubmit">
    保存
  </a-button>
</template>
