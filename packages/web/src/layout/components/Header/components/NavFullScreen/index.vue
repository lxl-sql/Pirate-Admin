<!-- 全屏/取消全屏 -->
<script setup lang="ts">
import {defineOptions, onBeforeUnmount, onMounted,} from "vue";
import {CompressOutlined, ExpandOutlined} from "@ant-design/icons-vue";
import {useLayoutStore} from "@/store";

const store = useLayoutStore();

defineOptions({
  name: "NavFullScreen",
});
</script>

<template>
  <div
    class="nav-menu-item"
    @click="store.toggleFullScreen"
    :title="store.isFullScreen ? '取消全屏' : '全屏'"
  >
    <div class="d-flex-center c-pointer user-select">
      <!-- 全屏 -->
      <compress-outlined v-show="store.isFullScreen"/>
      <!-- 取消全屏 -->
      <expand-outlined v-show="!store.isFullScreen"/>
    </div>
  </div>
</template>

<style lang="less" scoped>
@import "./index.less";
</style>
