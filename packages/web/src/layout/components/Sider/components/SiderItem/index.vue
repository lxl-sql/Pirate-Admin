<!-- MenuItem -->
<script setup lang="ts">
import {defineOptions, withDefaults} from "vue";
import {useRouter} from "vue-router";
import {storeToRefs} from 'pinia';
import {useLayoutStore} from "@/store";
import SiderItem from './index.vue'
import data from "../../data.json";
import * as antIcons from "@ant-design/icons-vue";

const store = useLayoutStore();
const {isSidebarOpen} = storeToRefs(store);

interface IPropsMenuItem {
  menu: typeof data.data;
}

const props = withDefaults(defineProps<IPropsMenuItem>(), {
  menu: () => [],
});

const router = useRouter();

// 跳转
const toRouter = (item: Record<string, any>) => {
  // console.log(item, "item");
  router.push({
    name: item.name,
  });
};

defineOptions({
  name: "SideItem",
});
</script>

<template>
  <template v-for="item in props.menu" :key="item.name">
    <!-- 当存在子集 -->
    <template v-if="item.children && item.children.length">
      <a-sub-menu :key="item.name" :title="item.title">
        <template #icon>
          <component :is="antIcons[item.icon]" class="fontSize-icon"/>
        </template>
        <sider-item :menu="item.children"/>
      </a-sub-menu>
    </template>
    <template v-else>
      <a-menu-item :key="item.name" @click="toRouter(item)" :title="item.title">
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
