<!-- header 头部 -->
<script setup lang="ts">
import {computed} from "vue"
import TagsPc from './components/TagsPc/index.vue'
import TagsMobile from './components/TagsMobile/index.vue'
import NavInfo from './components/NavInfo/index.vue'
import NavFullScreen from './components/NavFullScreen/index.vue'
import NavLanguage from './components/NavLanguage/index.vue'
import NavHome from './components/NavHome/index.vue'
import NavMsg from './components/NavMsg/index.vue'
import NavTheme from './components/NavTheme/index.vue'
import NavSetting from "./components/NavSetting/index.vue";
import NavGithub from "./components/NavGithub/index.vue";
import {useTheme} from "@/store/hooks";
import SiderMenu from "../ISider/components/SiderMenu/index.vue";
import NavGitee from "@/layout/components/IHeader/components/NavGitee/index.vue";

const theme = useTheme()

const headerStyle = computed(() => {
  return {
    left: theme.isSidebarCollapsed ? 96 : 232 + 'px',
    display: theme.isLayoutFullScreen ? 'none' : undefined
  }
})

const isDrawerMenu = computed(() => {
  return theme.isDrawerMenu
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
    <tags-mobile v-if="isDrawerMenu"/>
    <tags-pc v-else-if="theme.menuMode === 'inline'"/>
    <sider-menu
      v-else-if="!isDrawerMenu"
      mode="horizontal"
      :show-logo="theme.layoutMode === 'single-column'"
      :menus="theme.headerMenus"
    />

    <div class="i-header-menus flex items-center justify-center">
      <!-- gitee -->
      <nav-gitee v-if="!isDrawerMenu"/>
      <!-- github -->
      <nav-github v-if="!isDrawerMenu"/>
      <!-- home -->
      <nav-home/>
      <!-- use-theme -->
      <nav-theme/>
      <!-- language -->
      <nav-language/>
      <!-- full-screen -->
      <nav-full-screen v-if="!isDrawerMenu"/>
      <!-- message -->
      <nav-msg/>
      <!-- clear-cache -->
      <!--      <nav-cache/>-->
      <!--setting -->
      <nav-setting v-if="!isDrawerMenu"/>
      <!-- user-info -->
      <nav-info/>
    </div>
  </header>
  <tags-pc v-if="theme.isDrawerMenu"/>
</template>

<style lang="less">
@import "./index.less";
</style>
