<!-- Gitee -->
<script setup lang="ts">
import GiteeOutlined from "@/components/IComponents/IIcon/GiteeOutlined/index.vue";
import {openWindow} from "@/utils/dom";

const url = import.meta.env.VITE_GITEE_URL;

defineOptions({
  name: "NavGitee",
});
</script>

<template>
  <a-tooltip title="Gitee">
    <div class="nav-menu-item" @click="openWindow(url)">
      <gitee-outlined/>
    </div>
  </a-tooltip>
</template>

<style lang="less" scoped>
@import "./index.less";
</style>
