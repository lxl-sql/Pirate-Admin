<!-- 语言 -->
<script setup lang="ts">
import {defineOptions} from "vue";
import {DesktopOutlined} from "@ant-design/icons-vue";

defineOptions({
  name: "NavHome",
});
</script>

<template>
  <!-- 你的前台首页/小程序/app -->
  <div class="nav-menu-item" title="会员首页">
    <desktop-outlined/>
  </div>
</template>

<style lang="less" scoped>
@import "./index.less";
</style>
