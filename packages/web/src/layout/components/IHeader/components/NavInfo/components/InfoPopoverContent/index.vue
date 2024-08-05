<script setup lang="ts">
import {PoweroffOutlined, UserOutlined} from "@ant-design/icons-vue";
import {useRouter} from "vue-router";
import {useAdminStore} from "@/store";
import {$local} from "@/utils/storage";

const adminStore = useAdminStore()

const router = useRouter();

const emits = defineEmits(['close'])

// 注销
const handleLogout = () => {
  emits('close')
  const lang = $local.get("lang") || "zh";
  $local.clear();
  $local.set("lang", lang);
  router.push("/admin/login");
  console.log("handleLogout");
};

defineOptions({
  name: "InfoPopoverContent"
})
</script>

<template>
  <div class="w-72 text-center">
    <a-avatar :size="70" :src="adminStore.rawUserInfo.avatarFull" class="avatar-turn mb-1">
      <template #icon>
        <user-outlined class="text-[60px] translate-y-3"/>
      </template>
    </a-avatar>
    <div class="mb-4">
      <div class="text-xl mb-1">{{ adminStore.rawUserInfo.nickname }}</div>
      <div>{{ adminStore.rawUserInfo.lastLoginTime }}</div>
    </div>
  </div>
  <div class="flex justify-between">
    <a-button class="mr-1.5" type="primary" ghost @click="emits('close')">
      <router-link to="/routine/info">个人资料</router-link>
    </a-button>
    <a-button class="ml-1.5" type="primary" danger ghost @click="handleLogout">
      <template #icon>
        <poweroff-outlined/>
      </template>
      注销
    </a-button>
  </div>
</template>

<style scoped lang="less">
@import "./index.less";
</style>
