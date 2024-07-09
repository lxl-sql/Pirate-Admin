<!-- header 头部 -->
<script setup lang="ts">
import {defineOptions} from "vue"
import {storeToRefs} from "pinia"
import TagsPc from './components/TagsPc/index.vue'
import TagsMobile from './components/TagsMobile/index.vue'
import NavInfo from './components/NavInfo/index.vue'
import NavFullScreen from './components/NavFullScreen/index.vue'
import NavLanguage from './components/NavLanguage/index.vue'
import NavHome from './components/NavHome/index.vue'
import NavCache from './components/NavCache/index.vue'
import NavMsg from './components/NavMsg/index.vue'
import NavTheme from './components/NavTheme/index.vue'
import {useLayoutStore} from "@/store"

const store = useLayoutStore();
const {isSidebarOpen, isAsideMenu, isLayoutFullScreen} = storeToRefs(store);


defineOptions({
  name: "Header",
});
</script>

<template>
  <header
    v-if="!isLayoutFullScreen"
    class="flex justify-between nav-bar"
    :style="{ left: `${isSidebarOpen ? 96 : 232}px` }"
  >
    <tags-mobile v-if="isAsideMenu"/>
    <tags-pc v-else/>

    <div class="flex items-center justify-center nav-menus">
      <!-- 首页 -->
      <nav-home/>
      <!-- 切换主题 -->
      <nav-theme/>
      <!-- 语言 -->
      <nav-language/>
      <!-- 全屏/取消全屏 -->
      <nav-full-screen/>
      <!-- 消息 -->
      <nav-msg/>
      <!-- 清楚缓存 -->
      <nav-cache/>
      <!-- 个人信息 -->
      <nav-info/>
    </div>
  </header>
  <tags-pc v-if="isAsideMenu"/>
</template>

<style lang="less">
@import "./index.less";
</style>
