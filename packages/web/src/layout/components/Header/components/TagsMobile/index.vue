<!-- Tags 标签 -->
<script setup lang="ts">
import {MenuUnfoldOutlined} from "@ant-design/icons-vue";
import {computed, defineOptions} from "vue";
import {useLayoutStore} from "@/store";
import {useRoute} from "vue-router";
import Ellipsis from "@/components/IComponents/IOther/Ellipsis/index.vue";
import {recursive} from "@/utils/common";
import {cloneDeep} from "lodash-es";

const router = useRoute();
const store = useLayoutStore();

// 面包屑
const routes = computed(() => {
  const matched = cloneDeep(router.matched) as any[]
  const routers = recursive(matched, (route => {
    return {
      path: route.path,
      name: route.name || route.meta.name,
      breadcrumbName: route.meta.title,
      children: route.children
    };
  })) as any[]
  // 移除首页, 首页不需要重复显示
  if (routers[1]?.name === "home") {
    routers.splice(1, 1);
  }
  return routers;
});

defineOptions({
  name: "TagsMobile",
});
</script>

<template>
  <div class="menu-mobile flex items-center">
    <!-- 点击展开收起菜单 -->
    <div
      class="menu-icon flex items-center cursor-pointer mr-4"
      @click="store.toggleMenuState"
    >
      <!-- 展开 -->
      <menu-unfold-outlined class="text-xl"/>
    </div>
    <a-breadcrumb v-if="store.terminalType === 'pc'" :routes="routes">
      <template #itemRender="{ route, params, routes, paths }">
        <span v-if="routes.indexOf(route) === routes.length - 1">
          {{ route.breadcrumbName }}
        </span>
        <router-link v-else :to="route.path">
          {{ route.breadcrumbName }}
        </router-link>
      </template>
    </a-breadcrumb>
    <ellipsis v-else>
      {{ $route.meta.title }}
    </ellipsis>
  </div>
</template>

<style lang="less" scoped>
@import "./index.less";
</style>
