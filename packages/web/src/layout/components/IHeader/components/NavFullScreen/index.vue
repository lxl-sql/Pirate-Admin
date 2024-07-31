<!-- 全屏/取消全屏 -->
<script setup lang="ts">
import {defineOptions,} from "vue";
import {CompressOutlined, ExpandOutlined} from "@ant-design/icons-vue";
import {useTheme} from "@/store/hooks";

const theme = useTheme()

defineOptions({
  name: "NavFullScreen",
});
</script>

<template>
  <div
    class="nav-menu-item"
    @click="theme.toggleFullScreen"
    :title="theme.isFullScreen ? '取消全屏' : '全屏'"
  >
    <div class="d-flex-center c-pointer user-select">
      <!-- 全屏 -->
      <compress-outlined v-show="theme.isFullScreen"/>
      <!-- 取消全屏 -->
      <expand-outlined v-show="!theme.isFullScreen"/>
    </div>
  </div>
</template>

<style lang="less" scoped>
@import "./index.less";
</style>
