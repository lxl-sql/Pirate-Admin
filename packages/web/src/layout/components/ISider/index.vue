<!-- 菜单 -->
<script setup lang="ts">
import SiderMenu from './components/SiderMenu/index.vue'
import {useTheme} from "@/store/hooks";

const theme = useTheme()

const handleClose = () => {
  theme.isSidebarCollapsed = false;
};

defineOptions({
  name: 'ISider'
})
</script>

<template>
  <a-drawer
    v-if="theme.isDrawerMenu"
    v-model:open="theme.isSidebarCollapsed"
    :closable="false"
    root-class-name="i-sider-mobile"
    placement="left"
    width="200"
    @close="handleClose"
  >
    <sider-menu :menus="theme.siderMenus"/>
  </a-drawer>
  <a-layout-sider
    v-else
    v-model:collapsed="theme.isSidebarCollapsed"
    class="i-sider"
    theme="light"
  >
    <sider-menu :menus="theme.siderMenus"/>
  </a-layout-sider>
</template>

<style lang="less">
@import "./index.less";
</style>
