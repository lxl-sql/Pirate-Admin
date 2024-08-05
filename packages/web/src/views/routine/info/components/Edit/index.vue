<!-- 个人资料 - 修改信息 -->
<script setup lang="ts">
import {reactive, ref} from "vue";
import {EditOutlined, UserOutlined,} from "@ant-design/icons-vue";
import {Form, FormInstance, notification} from "ant-design-vue";
import {useAdminStore} from "@/store";
import {storeToRefs} from "pinia";
import {Rules} from "@/types/form";
import {adminUpsert} from "@/api/auth/admin";
import {useI18n} from "vue-i18n";
import BindInfoModal from "./components/BindInfoModal/index.vue";
import {CaptchaType} from "@/types/request";
import {setTimeoutPromise} from "@/utils/common";

const {t} = useI18n()

const store = useAdminStore();
const {formState} = storeToRefs(store);

const formRef = ref<FormInstance>();
const bindInfoModalRef = ref()

// 校验规则
const rules = reactive<Rules>({
  nickname: [{required: true, message: "请输入用户昵称"}],
});
const {validate, validateInfos} = Form.useForm(formState, rules);
const isSubmitLoading = ref<boolean>(false)

const refreshInfo = async () => {
  await setTimeoutPromise(100)
  await store.getAdminByIdRequest(store.userInfo.id)
}

const handleSubmit = async () => {
  await validate();
  const params = {
    ...formState.value,
    type: 2,
  }
  isSubmitLoading.value = true
  try {
    await adminUpsert(params)
    notification.success({
      message: t('message.success'),
      description: t('success.saved successfully'),
    })
    await refreshInfo()
  } finally {
    isSubmitLoading.value = false
  }
  console.log("handleSubmit -->", formState.value);
};

const handleUploadSuccess = (file) => {
  console.log(file)
  formState.value.avatar = file.path;
  formState.value.avatarFull = file.url
}

const openBindInfoModal = (type: CaptchaType) => {
  bindInfoModalRef.value.init(type)
}
</script>

<template>
  <div class="edit-info is-always-shadow">
    <div class="edit-head mb-4">
      <i-upload
        accept="image/*"
        :show-upload-list="false"
        @success="handleUploadSuccess"
      >
        <div class="relative">
          <img
            v-if="formState.avatarFull"
            :src="formState.avatarFull"
            alt="头像加载失败"
            class="min-w-32 min-h-32 w-32 h-32 rounded-full leading-10"
          />
          <a-avatar :size="120" v-else>
            <template #icon>
              <user-outlined class="text-[86px] translate-y-6"/>
            </template>
          </a-avatar>
        </div>
      </i-upload>
      <div class="nickname">{{ formState.nickname }}</div>
      <div>
        上次登录于
        {{ formState.lastLoginTime }}
      </div>
    </div>
    <div class="edit-main mb_16">
      <a-form
        ref="formRef"
        :model="formState"
        name="basic"
        autocomplete="off"
        layout="vertical"
      >
        <a-form-item label="用户名">
          <a-input
            v-model:value="formState.username"
            placeholder="用户名"
            disabled
          />
        </a-form-item>
        <a-form-item label="用户昵称" v-bind="validateInfos.nickname">
          <a-input
            v-model:value="formState.nickname"
            placeholder="请输入用户昵称"
          />
        </a-form-item>
        <a-form-item label="邮箱地址" name="email">
          <a-input-search
            v-model:value="formState.email"
            placeholder="邮箱地址"
            disabled
          >
            <template #enterButton>
              <a-button @click="openBindInfoModal('email')">
                <edit-outlined/>
              </a-button>
            </template>
          </a-input-search>
        </a-form-item>
        <a-form-item label="手机号码" name="phone">
          <a-input-search
            v-model:value="formState.phone"
            placeholder="手机号码"
            disabled
          >
            <template #enterButton>
              <a-button @click="openBindInfoModal('phone')">
                <edit-outlined/>
              </a-button>
            </template>
          </a-input-search>
        </a-form-item>
        <a-form-item label="签名" name="motto">
          <a-textarea
            v-model:value="formState.motto"
            placeholder="这家伙很懒，什么都没有留下"
          />
        </a-form-item>
        <a-form-item label="新密码" v-bind="validateInfos.password">
          <a-input
            v-model:value="formState.password"
            placeholder="不修改请留空"
          />
        </a-form-item>
      </a-form>
    </div>
    <div class="edit-foot">
      <a-button
        type="primary"
        :loading="isSubmitLoading"
        @click="handleSubmit"
      >
        保存
      </a-button>
    </div>
  </div>

  <bind-info-modal
    ref="bindInfoModalRef"
    @confirm="refreshInfo"
  />
</template>

<style lang="less" scoped>
@import "./index.less";
</style>
