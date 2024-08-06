<!-- 菜单 -->
<script setup lang="ts">
import {onMounted, ref, watch} from "vue";
import {useRoute} from "vue-router";
import {MenuFoldOutlined, MenuUnfoldOutlined, SmileOutlined,} from "@ant-design/icons-vue";
import SiderItem from '../SiderItem/index.vue'
import {useTheme} from "@/store/hooks";
import {Menu} from "@/store/hooks/useTheme/types";
import {mergeArraysUnique, setTimeoutPromise} from "@/utils/common";
import {treeForEach} from "@/utils/tree";
import {cloneDeep} from "lodash-es";

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
const siderMenus = ref<Partial<Menu>[]>([])

onMounted(async () => {
  if (props.mode === 'horizontal') return
  await setTimeoutPromise(100)
  getExpandMenuItem('init');
})

watch(() => props.menus, (newValue) => {
  if (props.mode === 'horizontal' || !newValue) return
  getExpandMenuItem('init');
});

// 防止误操作 开启手风琴模式 默认关闭所有menu
watch(() => theme.menuUniqueOpened, (newValue) => {
  if (props.mode === 'horizontal' || !newValue || !props.menus?.length) return
  openKeys.value = []
  siderMenus.value = []
});

watch(() => route.name, () => {
  getExpandMenuItem();
  if (theme.isDrawerMenu) {
    theme.isSidebarCollapsed = false
  }
});


/**
 * @description 获取当前打开的子菜单
 */
const getExpandMenuItem = (status?: 'init') => {
  selectedKeys.value = [route.name as string];

  if (props.mode === 'horizontal') return

  // 手风琴模式逻辑
  const matched = cloneDeep(route.matched).splice(1, route.matched.length - 2)
  const names = matched.map(route => route.name) as string[]

  if (theme.menuUniqueOpened) {
    openKeys.value = names
    // 初始化时才重新存值
    if (status === 'init' && props.menus) {
      treeForEach(cloneDeep(props.menus), menu => {
        if (names.includes(menu.name)) {
          siderMenus.value.push({
            level: menu.level,
            name: menu.name
          })
        }
      })
      // console.log('siderMenus.value', names, siderMenus.value)
    }
  } else {
    openKeys.value = mergeArraysUnique(names, openKeys.value)
  }
  // console.log('route', names, openKeys.value, matched)
};

// 手风琴模式
const handleSubMenu = (menu: Menu) => {
  if (!theme.menuUniqueOpened) return
  const sameNameIndex = siderMenus.value.findIndex(sider => menu.name === sider.name)
  if (sameNameIndex > -1) {
    // 重复的直接删除
    siderMenus.value.splice(sameNameIndex, 1)
  } else {
    // 缓存的层级大于当前展开层级全部过滤掉(默认是被关闭了)
    siderMenus.value = siderMenus.value.filter(sider => sider.level! < menu.level!)
    siderMenus.value.push({
      level: menu.level,
      name: menu.name
    })
  }
  openKeys.value = siderMenus.value.map(sider => sider.name!)
  // console.log('menu', menu.level, menu.name, JSON.stringify(siderMenus.value))
}

// 非手风琴模式
const onOpenChange = (keys: string[]) => {
  if (theme.menuUniqueOpened) return
  openKeys.value = keys
}

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
      v-model:selected-keys="selectedKeys"
      :open-keys="openKeys"
      :mode="mode"
      @open-change="onOpenChange"
    >
      <sider-item
        :mode="mode"
        :menus="menus"
        @sub-menu-click="handleSubMenu"
      />
    </a-menu>
    <div v-else class="text-center mt-1 overflow-hidden">
      <smile-outlined class="text-xl mb-2"/>
      <p class="mb-0">{{ $t('placeholder.Not Found') }}</p>
    </div>
  </div>
</template>

<style lang="less">
@import "./index.less";
</style>
