<!-- 个人信息 -->
<script setup lang="ts">
import {defineOptions, ref} from "vue";
import {PoweroffOutlined, UserOutlined} from "@ant-design/icons-vue";
import {useRouter} from "vue-router";
import {useAdminStore} from '@/store/auth'

const adminStore = useAdminStore()

const router = useRouter();
const open = ref(false); // 个人资料

// 注销
const onLogout = () => {
  open.value = false;
  const lang = localStorage.getItem("lang") || "zh";
  localStorage.clear();
  localStorage.setItem("lang", lang);
  router.push("/admin/login");
  console.log("onLogout");
};

defineOptions({
  name: "NavInfo",
});
</script>

<template>
  <a-popover
    v-model:open="open"
    placement="bottomRight"
    trigger="click"
  >
    <template #content>
      <div class="admin-info-base">
        <a-avatar :size="70" :src="adminStore.rawUserInfo.avatar" class="mb-4 avatar-turn">
          <template #icon v-if="!adminStore.rawUserInfo.avatar">
            <user-outlined style="font-size: 70px"/>
          </template>
        </a-avatar>
        <div class="mb-4  admin-info-other">
          <div class="mb-2 admin-info-name">{{ adminStore.rawUserInfo.nickname }}</div>
          <div class="admin-info-lastTime">{{ adminStore.rawUserInfo.lastLoginTime }}</div>
        </div>
      </div>
      <div class="flex justify-between">
        <a-button class="mr-1.5" type="primary" ghost @click="open = false">
          <router-link to="/routine/info">个人资料</router-link>
        </a-button>
        <a-button class="ml-1.5" type="primary" danger ghost @click="onLogout">
          <template #icon>
            <poweroff-outlined/>
          </template>
          注销
        </a-button>
      </div>
    </template>
    <div class="admin-info flex items-center px-4 cursor-pointer" :title="adminStore.rawUserInfo.nickname">
      <!-- 账号信息 -->
      <a-avatar :size="26" :src="adminStore.rawUserInfo.avatar">
        <template #icon v-if="!adminStore.rawUserInfo.avatar">
          <user-outlined class="text-[26px]"/>
        </template>
      </a-avatar>
      <div class="ml-1.5 admin-name ellipsis">{{ adminStore.rawUserInfo.nickname }}</div>
    </div>
  </a-popover>
</template>

<style lang="less" scoped>
@import "./index.less";
</style>
