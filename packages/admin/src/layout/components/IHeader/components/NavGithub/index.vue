<!-- Github -->
<script setup lang="ts">
import {GithubOutlined} from "@ant-design/icons-vue";
import {openWindow} from "@/utils/dom";

const url = import.meta.env.VITE_GITHUB_URL;

defineOptions({
  name: "NavGithub",
});
</script>

<template>
  <a-tooltip :title="$t('layout.header.title.github')">
    <div class="nav-menu-item" @click="openWindow(url)">
      <github-outlined/>
    </div>
  </a-tooltip>
</template>

<style lang="less" scoped>
@import "./index.less";
</style>
