<!-- layout 主体 -->
<script setup lang="ts">
import ISider from './components/ISider/index.vue'
import IHeader from './components/IHeader/index.vue'
import {computed, onBeforeMount, onBeforeUnmount, onMounted} from "vue";
import {useTheme} from "@/store/hooks";
import {onBeforeRouteUpdate} from "vue-router";
import {useAdminStore} from "@/store";

const adminStore = useAdminStore();
const theme = useTheme()

onBeforeMount(async () => {
  theme.initSiderState()

  if (adminStore.userInfo.id) {
    await adminStore.getAdminByIdRequest(adminStore.userInfo.id)
  }
})

onMounted(async () => {
  theme.listenerChange(true);
  await theme.initMenus()
});

onBeforeUnmount(() => {
  theme.listenerChange(false);
});

onBeforeRouteUpdate((route) => {
  if (theme.layoutMode !== 'double-column') return;
  theme.changeMenus(route)
})
const containerClass = computed(() => {
  if (theme.isDrawerMenu) {
    return 'container-mobile'
  }
  const data = {
    classic: 'container-classic',
    'single-column': 'container-single-column',
    'double-column': 'container-double-column'
  }
  return data[theme.layoutMode]
})
</script>

<template>
  <a-layout class="pirate-container" :class="containerClass">
    <!-- 标签页全面只需要 v-show，修改整体布局使用 v-if -->
    <i-sider
      v-if="theme.layoutMode !== 'single-column' || theme.isDrawerMenu"
      v-show="!theme.isLayoutFullScreen"
    />

    <a-layout class="layout">
      <i-header/>
      <a-layout-content class="overflow-y-auto overflow-x-hidden">
        <router-view
          class="layout-view"
          :class="{fullScreen: theme.isLayoutFullScreen}"
          v-slot="{ Component, route }"
        >
          <transition name="slide-right" mode="out-in">
            <component v-if="!theme.isPageRefreshing" :is="Component" :key="route.fullPath"/>
          </transition>
        </router-view>
      </a-layout-content>
    </a-layout>
  </a-layout>
</template>

<style lang="less">
@import "./index.less";
</style>
