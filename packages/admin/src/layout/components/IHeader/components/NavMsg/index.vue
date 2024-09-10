<!-- 消息提醒 -->
<script setup lang="ts">
import {shallowRef} from "vue";
import {BellOutlined} from "@ant-design/icons-vue";

const open = shallowRef<boolean>(false);
const tooltipOpen = shallowRef<boolean>(false);

const handleOpenChange = (visible: boolean) => {
  tooltipOpen.value = !visible;
};

defineOptions({
  name: "NavMsg",
});
</script>

<template>
  <a-popover
    v-model:open="open"
    :title="$t('layout.header.title.message')"
    placement="bottom"
    trigger="click"
    overlay-class-name="nav-msg-popover"
    @click="tooltipOpen = false"
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
    <a-tooltip v-model:open="tooltipOpen" :title="$t('layout.header.title.message')">
      <div class="nav-menu-item">
        <bell-outlined class="msg-icon active"/>
      </div>
    </a-tooltip>
  </a-popover>
</template>

<style lang="less" scoped>
@import "./index.less";
</style>
