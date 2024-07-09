<!-- 语言 -->
<script setup lang="ts">
import { defineOptions } from "vue";
import { DesktopOutlined } from "@ant-design/icons-vue";

defineOptions({
  name: "NavHome",
});
</script>

<template>
  <div class="nav-menu-item" title="会员首页">
    <desktop-outlined />
  </div>
</template>

<style lang="less" scoped>
@import "./index.less";
</style>
