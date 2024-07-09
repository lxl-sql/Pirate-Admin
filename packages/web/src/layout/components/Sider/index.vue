<!-- 菜单 -->
<script setup lang="ts">
import {storeToRefs} from "pinia";
import SiderMenu from './components/SiderMenu/index.vue'
import {useLayoutStore} from "@/store";
import {onBeforeMount} from "vue";

const store = useLayoutStore();
const {isSidebarOpen, isAsideMenu} = storeToRefs(store);

onBeforeMount(() => {
  store.initSiderState()
})

const handleClose = () => {
  isSidebarOpen.value = false;
};

defineOptions({
  name: 'Sider'
})
</script>

<template>
  <div v-if="isAsideMenu">
    <a-drawer
      v-model:open="isSidebarOpen"
      :closable="false"
      root-class-name="i-menu-mobile"
      placement="left"
      width="200"
      @close="handleClose"
    >
      <sider-menu/>
    </a-drawer>
  </div>
  <a-layout-sider
    v-else
    v-model:collapsed="isSidebarOpen"
    class="i-menu"
    collapsedWidth="64"
    collapsible
  >
    <sider-menu/>
  </a-layout-sider>
</template>

<style lang="less">
@import "./index.less";
</style>
