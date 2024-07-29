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
import {storeToRefs} from "pinia";
import {useAdminStore, useCaptchaStore} from "@/store";

const {t} = useI18n();
const captchaStore = useCaptchaStore();
const adminStore = useAdminStore();
const {svgCaptchaRequest} = captchaStore;
const {getAdminAvatarRequest, adminLoginRequest} = adminStore;
const {svgCaptcha} = storeToRefs(captchaStore);
const {avatar, loginFormState, isLoginFormLoading} = storeToRefs(adminStore);

const rules = reactive({
  username: [{required: true, message: t("error.userName")}],
  password: [{required: true, message: t("error.password")}],
  captcha: [{required: true, message: t("error.captcha")}],
});


onMounted(async () => {
  pageBubble.init();
  await svgCaptchaRequest();
});

onBeforeUnmount(() => {
  pageBubble.removeListeners();
});

// 登录
const handleLogin = async () => {
  try {
    const data = await adminLoginRequest();
    await router.push("/");
    await setTimeoutPromise(500);
    notification.success({
      message: t("success.login"),
      description: data.userInfo.username + " " + t("success.welcome"),
    });
  } catch (error) {
    await svgCaptchaRequest();
  }
};

// 根据用户名搜索头像
const handleUserNameInput = debounce(async () => {
  await getAdminAvatarRequest(loginFormState.value.username);
}, 500);
</script>

<template>
  <div @contextmenu.stop id="bubble" class="bubble">
    <canvas id="bubble-canvas" class="bubble-canvas"></canvas>
  </div>
  <div class="login">
    <div class="login-box">
      <a-spin :spinning="isLoginFormLoading">
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
            :src="avatar || avatar_default"
          />
          <div class="content">
            <a-form
              :model="loginFormState"
              :rules="rules"
              name="basic"
              @finish="handleLogin"
            >
              <a-form-item name="username">
                <a-input
                  v-model:value="loginFormState.username"
                  allow-clear
                  :placeholder="$t('placeholder.username')"
                  @input="handleUserNameInput"
                >
                  <template #prefix>
                    <user-outlined class="site-form-item-icon"/>
                  </template>
                </a-input>
              </a-form-item>
              <a-form-item name="password">
                <a-input-password
                  v-model:value="loginFormState.password"
                  allow-clear
                  autocomplete="new-password"
                  :placeholder="$t('placeholder.password')"
                >
                  <template #prefix>
                    <lock-outlined class="site-form-item-icon"/>
                  </template>
                </a-input-password>
              </a-form-item>
              <a-form-item name="captcha">
                <div class="flex">
                  <a-input
                    v-model:value="loginFormState.captcha"
                    :placeholder="$t('placeholder.captcha')"
                    style="height: 40px"
                  >
                  </a-input>
                  <a-form-item no-style>
                    <div
                      class="svg-captcha"
                      v-html="svgCaptcha"
                      @click="svgCaptchaRequest"
                    ></div>
                  </a-form-item>
                </div>
              </a-form-item>
              <a-form-item name="remember">
                <a-checkbox v-model:checked="loginFormState.remember">
                  {{ $t("login.remember") }}
                </a-checkbox>
              </a-form-item>
              <a-form-item>
                <a-button
                  class="submit"
                  type="primary"
                  html-type="submit"
                  :loading="isLoginFormLoading"
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
