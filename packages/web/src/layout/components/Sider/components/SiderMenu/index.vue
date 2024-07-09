<!-- 菜单 -->
<script setup lang="ts">
import {onMounted, ref, watch} from "vue";
import {useRoute} from "vue-router";
import {storeToRefs} from "pinia";
import {MenuFoldOutlined, MenuUnfoldOutlined,} from "@ant-design/icons-vue";
import SiderItem from '../SiderItem/index.vue'
import {useLayoutStore} from "@/store";

import data from "../../data.json";

const route = useRoute();
const store = useLayoutStore();
const {isSidebarOpen, isAsideMenu, menus} = storeToRefs(store);

const openKeys = ref<string[]>([]);
const selectedKeys = ref<string[]>([]);

onMounted(() => {
  getMenus();
});

watch(
  () => route.path,
  () => {
    getExpandMenuItem();
  }
);

const getMenus = () => {
  menus.value = data.data;
  getExpandMenuItem();
};

/**
 * @description 获取当前打开的子菜单
 */
const getExpandMenuItem = () => {
  if (!isSidebarOpen.value && !isAsideMenu.value && route.meta.parentName) {
    openKeys.value = (route.meta.parentName as string).split(",");
  }
  selectedKeys.value = [route.name as string];
};

defineOptions({
  name: 'SiderMenu'
})
</script>

<template>
  <div class="menu-logo flex items-center justify-center">
    <template v-if="!isSidebarOpen || isAsideMenu">
      <div class="logo-name flex items-center">
        <img class="logo-img" src="@/assets/images/logo_piece.png" alt="Pirate Admin"/>
        <div class="website-name">Pirate Admin</div>
      </div>
    </template>
    <!-- 点击展开收起菜单 -->
    <div
      class="flex items-center cursor-pointer text-[18px] "
      @click="store.toggleMenuState"
    >
      <!-- 展开 -->
      <menu-unfold-outlined v-show="!isSidebarOpen" v-if="!isAsideMenu"/>
      <!-- 收起 -->
      <menu-fold-outlined v-show="isSidebarOpen"/>
    </div>
  </div>
  <div class="i-menu-content">
    <a-menu mode="inline" :open-keys="openKeys" :selected-keys="selectedKeys">
      <sider-item :menu="data.data"/>
    </a-menu>
  </div>
</template>

<style lang="less" scoped>
@import "./index.less";
</style>
