<!-- MenuItem -->
<script setup lang="ts">
import {defineOptions, withDefaults} from "vue";
import {useRouter} from "vue-router";
import SiderItem from './index.vue'
import * as antIcons from "@ant-design/icons-vue";
import {Menu} from "@/store/hooks/useTheme/types";

interface SiderItemProps {
  menus?: Menu[] | null
}

const props = withDefaults(defineProps<SiderItemProps>(), {
  menus: () => [],
});

const router = useRouter();

// 跳转
const toRouter = (menu: Menu) => {
  router.push({
    name: menu.name,
  });
};

defineOptions({
  name: "SiderItem",
});
</script>

<template>
  <template v-for="item in menus" :key="item.name">
    <!-- 当存在子集 -->
    <template v-if="item.children && item.children.length">
      <a-sub-menu :key="item.name" :title="item.title" @click="toRouter(item.children?.[0])">
        <template #icon>
          <component :is="antIcons[item.icon]" class="fontSize-icon"/>
        </template>
        <sider-item :menus="item.children"/>
      </a-sub-menu>
    </template>
    <template v-else>
      <a-menu-item :key="item.name" :title="item.title" @click="toRouter(item)">
        <template #icon>
          <component :is="antIcons[item.icon]" class="fontSize-icon"/>
        </template>
        <span>{{ item.title }}</span>
      </a-menu-item>
    </template>
  </template>
</template>

<style lang="less" scoped>
@import "./index.less";
</style>
