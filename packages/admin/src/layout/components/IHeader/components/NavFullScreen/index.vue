<!-- 全屏/取消全屏 -->
<script setup lang="ts">
import {CompressOutlined, ExpandOutlined} from "@ant-design/icons-vue";
import {useTheme} from "@/store/hooks";
import {computed} from "vue";

const theme = useTheme()

const title = computed(() => {
  return theme.isFullScreen ? '退出全屏' : '全屏'
})

defineOptions({
  name: "NavFullScreen",
});
</script>

<template>
  <a-tooltip :title="title">
    <div class="nav-menu-item" @click="theme.toggleFullScreen">
      <!-- 全屏 -->
      <compress-outlined v-if="theme.isFullScreen"/>
      <!-- 取消全屏 -->
      <expand-outlined v-else/>
    </div>
  </a-tooltip>
</template>

<style lang="less" scoped>
@import "./index.less";
</style>
