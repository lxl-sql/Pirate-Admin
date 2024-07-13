<!-- 配置项 -->
<script setup lang="ts">
import {reactive, ref} from "vue";
import {ConfigItem} from "../../index.d";
import {getRules} from "@/utils/common";
import useFormInstance from "@/hooks/useFormInstance";
import {configValueCreate} from "@/api/config";
import {notification} from "ant-design-vue";
import {useI18n} from "vue-i18n";
import ToEmailModal from "../ToEmailModal/index.vue";

const {t} = useI18n()

//# region interface
interface ConfigItemProps {
  items: ConfigItem[]
}

interface FormState extends Record<string, any> {
  group?: string;
}

//# endregion

//# region 变量定义
const props = defineProps<ConfigItemProps>()

const emits = defineEmits(['confirm'])
// 校验规则
const [formRef, formInstance] = useFormInstance()
const toEmailModalRef = ref()
const formState = reactive<FormState>({});

const loading = ref<boolean>(false);
//# endregion

//# region 函数方法
const init = () => {
  formState.group = props.items?.[0].group
  props.items.forEach(item => {
    if (item.value) {
      formState[item.name] = item.value
    }
  })
}
// 保存
const handleSubmit = async () => {
  await formInstance.validate();
  loading.value = true;
  try {
    const {data} = await configValueCreate(formState)
    emits('confirm', data)
    notification.success({
      message: t('message.success'),
      description: t('success.saved successfully'),
    })
  } finally {
    loading.value = false;
  }
};
// 测试发送邮件地址
const handleSendEmail = async () => {
  await formInstance.validate();
  const params = {
    ...formState,
    address: formState.user,
  }
  toEmailModalRef.value.init(params)
};

//# endregion

defineOptions({
  name: "ConfigItem"
})
defineExpose({
  init
})
</script>

<template>
  <a-form
    ref="formRef"
    :model="formState"
    :wrapper-col="{ span: 16 }"
    layout="vertical"
    class="config-item"
  >
    <a-form-item
      v-for="item in items"
      :key="item.name"
      :name="item.name"
      :rules="getRules(item.rule, item.title)"
      :style="{'--config-name': `'$${item.name}'`}"
      v-bind="item.extend"
    >
      <template #label>
        {{ item.title }}
        <question-tooltip v-if="item.tip" :title="item.tip"/>
      </template>
      <custom-input
        v-model:value="formState[item.name]"
        :type="item.type"
        :placeholder="item.title"
        v-bind="item.inputExtend"
      />
    </a-form-item>
  </a-form>
  <a-space direction="vertical">
    <a-button
      v-if="formState.group === 'email'"
      class="!text-xs"
      size="small"
      @click="handleSendEmail"
    >
      测试发送地址
    </a-button>
    <a-button type="primary" :loading="loading" @click="handleSubmit">
      保存
    </a-button>
  </a-space>

  <to-email-modal ref="toEmailModalRef"/>
</template>

<style lang="less" scoped>
@import "./index";
</style>
