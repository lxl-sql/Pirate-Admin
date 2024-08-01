<!-- 菜单 -->
<script setup lang="ts">
import {onMounted, ref, watch} from "vue";
import {useRoute} from "vue-router";
import {MenuFoldOutlined, MenuUnfoldOutlined, SmileOutlined,} from "@ant-design/icons-vue";
import SiderItem from '../SiderItem/index.vue'
import {useTheme} from "@/store/hooks";
import {Menu} from "@/store/hooks/useTheme/types";

const route = useRoute();
const theme = useTheme();

interface SiderMenuProps {
  menus?: Menu[] | null
  mode?: 'inline' | 'horizontal'
  showLogo?: boolean
}

const props = withDefaults(defineProps<SiderMenuProps>(), {
  menus: () => [],
  mode: 'inline',
  showLogo: true,
})

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
  getExpandMenuItem();
};

/**
 * @description 获取当前打开的子菜单
 */
const getExpandMenuItem = () => {
  if (!theme.isSidebarCollapsed && !(theme.isDrawerMenu || theme.menuMode === 'horizontal') && route.meta.parentName) {
    openKeys.value = (route.meta.parentName as string).split(",");
  }
  selectedKeys.value = [route.name as string];
  // isSidebarOpen.value = false
};

defineOptions({
  name: 'SiderMenu'
})
</script>

<template>
  <!-- 仅在单栏模式显示 -->
  <div v-if="showLogo" class="i-menu-logo flex items-center justify-center">
    <!-- 菜单栏展开 | 小屏 | horizontal 时显示logo -->
    <template v-if="!theme.isSidebarCollapsed || theme.isDrawerMenu || theme.layoutMode === 'single-column'">
      <div class="logo-name ellipsis flex items-center" title="Pirate Admin">
        <img class="logo-img" src="@/assets/images/logo_piece.png" alt="Pirate Admin"/>
        <div class="website-name">Pirate Admin</div>
      </div>
    </template>
    <!-- 点击展开收起菜单 -->
    <div
      class="fold flex-1 flex items-center justify-center cursor-pointer text-[18px]"
      @click="theme.toggleMenuState"
    >
      <!-- 展开 -->
      <menu-unfold-outlined v-show="theme.isSidebarCollapsed" v-if="!theme.isDrawerMenu"/>
      <!-- 收起 -->
      <menu-fold-outlined v-show="!theme.isSidebarCollapsed || theme.isDrawerMenu"/>
    </div>
  </div>
  <div class="i-menu-content">
    <a-menu
      v-if="menus?.length"
      :mode="mode"
      :open-keys="openKeys"
      :selected-keys="selectedKeys"
    >
      <sider-item :menus="menus"/>
    </a-menu>
    <div v-else class="text-center mt-1">
      <smile-outlined class="text-xl mb-2"/>
      <p class="mb-0">{{ $t('placeholder.Not Found') }}</p>
    </div>
  </div>
</template>

<style lang="less">
@import "./index.less";
</style>
