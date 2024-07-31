<!-- header 头部 -->
<script setup lang="ts">
import {computed, defineOptions} from "vue"
import TagsPc from './components/TagsPc/index.vue'
import TagsMobile from './components/TagsMobile/index.vue'
import NavInfo from './components/NavInfo/index.vue'
import NavFullScreen from './components/NavFullScreen/index.vue'
import NavLanguage from './components/NavLanguage/index.vue'
import NavHome from './components/NavHome/index.vue'
import NavMsg from './components/NavMsg/index.vue'
import NavTheme from './components/NavTheme/index.vue'
import NavSetting from "./components/NavSetting/index.vue";
import {useTheme} from "@/store/hooks";
import SiderMenu from "../ISider/components/SiderMenu/index.vue";

const theme = useTheme()

const headerStyle = computed(() => {
  return {
    left: theme.isSidebarCollapsed ? 96 : 232 + 'px',
    display: theme.isLayoutFullScreen ? 'none' : undefined
  }
})

defineOptions({
  name: "IHeader",
});
</script>

<template>
  <header
    class="flex justify-between i-header"
    :style="headerStyle"
  >
    <tags-mobile v-if="theme.isDrawerMenu"/>
    <tags-pc v-else-if="theme.menuMode === 'inline'"/>
    <sider-menu
      v-else-if="!theme.isDrawerMenu"
      mode="horizontal"
      :show-logo="theme.layoutMode === 'single-column'"
      :menus="theme.headerMenus"
    />

    <div class="i-header-menus flex items-center justify-center">
      <!-- home -->
      <nav-home/>
      <!-- use-theme -->
      <nav-theme/>
      <!-- language -->
      <nav-language/>
      <!-- full-screen -->
      <nav-full-screen/>
      <!-- message -->
      <nav-msg/>
      <!-- clear-cache -->
      <!--      <nav-cache/>-->
      <!--setting -->
      <nav-setting/>
      <!-- user-info -->
      <nav-info/>
    </div>
  </header>
  <tags-pc v-if="theme.isDrawerMenu"/>
</template>

<style lang="less">
@import "./index.less";
</style>
