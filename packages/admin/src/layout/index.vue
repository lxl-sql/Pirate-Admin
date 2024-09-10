<!-- layout 主体 -->
<script setup lang="ts">
import ISider from "./components/ISider/index.vue";
import IHeader from "./components/IHeader/index.vue";
import { computed, onBeforeMount, onBeforeUnmount, onMounted } from "vue";
import { useTheme } from "@/store/hooks";
import { onBeforeRouteUpdate } from "vue-router";
import { useAdminStore } from "@/store";
import { customError } from "@/api/common";

const adminStore = useAdminStore();
const theme = useTheme();

onBeforeMount(async () => {
  theme.initSiderState();

  const userInfo = adminStore.userInfo || {};
  await adminStore.getAdminByIdRequest(userInfo.id);
});

onMounted(async () => {
  theme.listenerChange(true);
  await theme.initMenus();
});

onBeforeUnmount(() => {
  theme.listenerChange(false);
});

onBeforeRouteUpdate((route) => {
  if (theme.layoutMode !== "double-column") return;
  theme.changeMenus(route);
});

/**
 * 测试错误 连续报错
 */
const customErrorTest = () => {
  customError(404);
  customError(400);
  customError(500);
  customError(502);
};

/**
 * 测试错误 单次报错
 */
const customErrorTest2 = () => {
  customError(404);
};

/**
 * 测试错误 间隔报错
 */
const customErrorTest3 = () => {
  setTimeout(() => {
    customError(404);
  }, 0);
  setTimeout(() => {
    customError(400);
  }, 1000);
  setTimeout(() => {
    customError(500);
  }, 2000);
  setTimeout(() => {
    customError(502);
  }, 3000);
};

const containerClass = computed(() => {
  if (theme.isDrawerMenu) {
    return "container-mobile";
  }
  const data = {
    classic: "container-classic",
    "single-column": "container-single-column",
    "double-column": "container-double-column",
  };
  return data[theme.layoutMode];
});
</script>

<template>
  <a-layout class="pirate-container" :class="containerClass">
    <!-- 标签页全面只需要 v-show，修改整体布局使用 v-if -->
    <i-sider
      v-if="theme.layoutMode !== 'single-column' || theme.isDrawerMenu"
      v-show="!theme.isLayoutFullScreen"
    />

    <a-layout class="layout">
      <i-header />
      <a-layout-content class="overflow-y-auto overflow-x-hidden">
        <!-- 测试错误 -->
        <!-- <a-button @click="customErrorTest">customErrorTest</a-button>
        <a-button @click="customErrorTest2">customErrorTest2</a-button>
        <a-button @click="customErrorTest3">customErrorTest3</a-button> -->
        <router-view
          class="layout-view"
          :class="{ fullScreen: theme.isLayoutFullScreen }"
          v-slot="{ Component, route }"
        >
          <transition name="slide-right" mode="out-in">
            <component
              v-if="!theme.isPageRefreshing"
              :is="Component"
              :key="route.fullPath"
            />
          </transition>
        </router-view>
      </a-layout-content>
    </a-layout>
  </a-layout>
</template>

<style lang="less">
@import "./index.less";
</style>
