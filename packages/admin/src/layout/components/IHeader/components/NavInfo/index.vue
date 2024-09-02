<!-- 个人信息 -->
<script setup lang="ts">
import {ref} from "vue";
import {UserOutlined} from "@ant-design/icons-vue";
import {useAdminStore} from '@/store/auth'
import InfoPopoverContent from "./components/InfoPopoverContent/index.vue";

const adminStore = useAdminStore()

const open = ref(false); // 个人资料

defineOptions({
  name: "NavInfo",
});
</script>

<template>
  <a-popover
    v-model:open="open"
    placement="bottomRight"
    trigger="click"
    :z-index="1"
    arrow-point-at-center
  >
    <template #content>
      <info-popover-content @close="open = false"/>
    </template>
    <div
      class="admin-info flex items-center h-full px-4 cursor-pointer transition duration-300"
      :title="adminStore.rawUserInfo.nickname"
    >
      <!-- 账号信息 -->
      <a-avatar :size="32" :src="adminStore.rawUserInfo.avatarFull">
        <template #icon v-if="!adminStore.rawUserInfo.avatarFull">
          <user-outlined class="text-[32px]"/>
        </template>
      </a-avatar>
      <div class="ml-1.5 max-w-28 ellipsis">
        {{ adminStore.rawUserInfo.nickname }}
      </div>
    </div>
  </a-popover>
</template>

<style lang="less" scoped>
@import "./index.less";
</style>
