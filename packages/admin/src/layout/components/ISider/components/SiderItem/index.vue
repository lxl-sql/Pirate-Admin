<!-- SiderItem -->
<script setup lang="ts">
import {useRouter} from "vue-router";
import SiderItem from './index.vue'
import * as antIcons from "@ant-design/icons-vue";
import {Menu} from "@/store/hooks/useTheme/types";

const router = useRouter();

interface SiderItemProps {
  menus?: Menu[] | null
  mode?: 'inline' | 'horizontal'
}

const props = withDefaults(defineProps<SiderItemProps>(), {
  menus: () => [],
  mode: 'inline'
});

const emits = defineEmits(['subMenuClick', 'menuClick'])

// 跳转
const toRouter = (type: 'sub-menu' | 'menu-item', menu?: Menu) => {
  // 单栏/双栏 小屏模式 点击无效
  if (!menu || (type === 'sub-menu' && props.mode === 'inline')) return
  router.push({
    name: menu.name,
  });
};

const handleSubMenu = (menu: Menu) => {
  emits('subMenuClick', menu)
  toRouter('sub-menu', menu.children?.[0])
}

const handleMenu = (menu: Menu) => {
  emits('menuClick', menu)
  toRouter('menu-item', menu)
}

defineOptions({
  name: "SiderItem",
});
</script>

<template>
  <template v-for="item in menus">
    <!-- 当存在子集 -->
    <a-sub-menu
      v-if="item.children && item.children.length"
      :key="item.name"
      :title="item.title"
      @click.stop="handleSubMenu(item)"
    >
      <template #icon>
        <component :is="antIcons[item.icon]" class="fontSize-icon"/>
      </template>
      <sider-item
        :menus="item.children"
        @menu-click="handleMenu($event)"
        @sub-menu-click="handleSubMenu($event)"
      />
    </a-sub-menu>
    <a-menu-item v-else :key="item.name" :title="item.title" @click.stop="handleMenu(item)">
      <template #icon>
        <component :is="antIcons[item.icon]" class="fontSize-icon"/>
      </template>
      <span>{{ item.title }}</span>
    </a-menu-item>
  </template>
</template>

<style lang="less" scoped>
@import "./index.less";
</style>
