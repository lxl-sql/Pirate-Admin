<!-- 消息 -->
<script setup lang="ts">
import {defineOptions, ref} from "vue";
import {BellOutlined} from "@ant-design/icons-vue";

const open = ref<boolean>(false);

defineOptions({
  name: "NavMsg",
});
</script>

<template>
  <a-popover
    v-model:open="open"
    placement="bottom"
    title="消息提醒"
    trigger="click"
    overlay-class-name="nav-msg-popover"
  >
    <template #content>
      <div class="nav-msg-content">
        <div class="nav-msg-item" v-for="item in 10" :key="item">
          <div class="nav-msg-icon">
            <!-- <warning-outlined />
            <CodeOutlined /> -->
            <source-code-outlined/>
          </div>
          <!-- 路由跳转 -->
          <router-link to="/" class="nav-msg-desc" @click="open = false">
            <p class="title ellipsis_more">
              您的套餐即将到期，请及时到商店续费或购买套餐。
            </p>
            <p class="time">2024-02-21 16:24:31</p>
          </router-link>
        </div>
      </div>
    </template>
    <div class="nav-menu-item" title="消息">
      <bell-outlined class="msg-icon active"/>
    </div>
  </a-popover>
</template>

<style lang="less" scoped>
@import "./index.less";
</style>
