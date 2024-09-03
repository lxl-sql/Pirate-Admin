<!-- 语言 -->
<script setup lang="ts">
import {DesktopOutlined} from "@ant-design/icons-vue";

defineOptions({
  name: "NavHome",
});
</script>

<template>
  <!-- 你的前台首页/小程序/app -->
  <a-tooltip title="会员首页">
    <div class="nav-menu-item">
      <desktop-outlined/>
    </div>
  </a-tooltip>
</template>

<style lang="less" scoped>
@import "./index.less";
</style>
