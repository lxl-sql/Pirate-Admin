<!-- 登录 -->
<script setup lang="ts">
import {LockOutlined, UserOutlined} from "@ant-design/icons-vue";
import {onBeforeUnmount, onMounted, reactive} from "vue";
import * as pageBubble from "@/utils/pageBubble";
import {setTimeoutPromise} from "@/utils/common";
import avatar_default from "@/assets/images/avatar.png";
import {useI18n} from "vue-i18n";
import {debounce} from "lodash-es";
import {notification} from "ant-design-vue";
import router from "@/router";
import {useAdminStore, useCaptchaStore} from "@/store";
import {useForm} from "ant-design-vue/es/form";

const {t} = useI18n();
const captchaStore = useCaptchaStore();
const adminStore = useAdminStore();

const rules = reactive({
  username: [{required: true, message: t("error.userName")}],
  password: [{required: true, message: t("error.password")}],
  captcha: [{required: true, message: t("error.captcha")}],
});

const {resetFields, validate, validateInfos} = useForm(adminStore.loginFormState, rules);

onMounted(async () => {
  pageBubble.init();
  await captchaStore.svgCaptchaRequest();
});

onBeforeUnmount(() => {
  pageBubble.removeListeners();
});

// 登录
const handleLogin = async () => {
  await validate()
  try {
    const data = await adminStore.adminLoginRequest(captchaStore.uuid);
    await router.push("/");
    await setTimeoutPromise(500);
    notification.success({
      message: t("success.login"),
      description: data.userInfo.username + " " + t("success.welcome"),
    });
    resetFields()
  } catch (error) {
    await captchaStore.svgCaptchaRequest();
  }
};

// 根据用户名搜索头像
const handleUserNameInput = debounce(async () => {
  await adminStore.getAdminAvatarRequest(adminStore.loginFormState.username);
}, 500);

</script>

<template>
  <div @contextmenu.stop id="bubble" class="bubble">
    <canvas id="bubble-canvas" class="bubble-canvas"></canvas>
  </div>
  <div class="login">
    <div class="login-box">
      <a-spin :spinning="adminStore.isLoginFormLoading">
        <div
          class="head img-placeholder"
          style="--img-placeholder-rate: 35.11%"
        >
          <div class="h-[150px] bg-cover bg-no-repeat bg-[url(@/assets/images/login-header.png)]"></div>
        </div>
        <div class="form">
          <a-avatar
            :size="100"
            class="profile-avatar"
            :src="adminStore.avatar || avatar_default"
          />
          <div class="content">
            <a-form
              name="basic"
              :model="adminStore.loginFormState"
              :rules="rules"
              @finish="handleLogin"
            >
              <a-form-item v-bind="validateInfos.username">
                <a-input
                  v-model:value="adminStore.loginFormState.username"
                  allow-clear
                  :placeholder="$t('placeholder.username')"
                  @input="handleUserNameInput"
                >
                  <template #prefix>
                    <user-outlined class="site-form-item-icon"/>
                  </template>
                </a-input>
              </a-form-item>
              <a-form-item v-bind="validateInfos.password">
                <a-input-password
                  v-model:value="adminStore.loginFormState.password"
                  allow-clear
                  autocomplete="new-password"
                  :placeholder="$t('placeholder.password')"
                >
                  <template #prefix>
                    <lock-outlined class="site-form-item-icon"/>
                  </template>
                </a-input-password>
              </a-form-item>
              <a-form-item v-bind="validateInfos.captcha">
                <div class="flex">
                  <a-input
                    v-model:value="adminStore.loginFormState.captcha"
                    :placeholder="$t('placeholder.captcha')"
                    style="height: 40px"
                  >
                  </a-input>
                  <a-form-item no-style>
                    <div
                      class="svg-captcha"
                      v-html="captchaStore.svgCaptcha"
                      @click="captchaStore.svgCaptchaRequest"
                    ></div>
                  </a-form-item>
                </div>
              </a-form-item>
              <a-form-item v-bind="validateInfos.remember">
                <a-checkbox v-model:checked="adminStore.loginFormState.remember">
                  {{ $t("login.remember") }}
                </a-checkbox>
              </a-form-item>
              <a-form-item>
                <a-button
                  class="submit"
                  type="primary"
                  html-type="submit"
                  :loading="adminStore.isLoginFormLoading"
                >
                  {{ $t("login.login") }}
                </a-button>
              </a-form-item>
            </a-form>
          </div>
        </div>
      </a-spin>
    </div>
  </div>
</template>

<style lang="less" scoped>
@import "./index.less";
</style>
