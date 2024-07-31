import {$local} from "@/utils/storage";
import {computed} from "vue";
import {ThemeState} from "./types";
import {getTerminal} from "@/utils/common";

export const useGetters = (state: ThemeState) => {
  // 获取菜单列表，用于渲染左侧菜单栏，以及 tags，header，侧边栏抽屉，面包屑，路由，权限，动态路由，动态权限，动态菜单
  const getMenus = computed(() => {
    const menus = $local.get('BREADCRUMBKEYFORPM')
    return state.cacheMenus || menus || [];
  });
  // 获取终端类型 mobile pc
  const terminalType = computed(() => getTerminal());

  const menuMode = computed(() => {
    return (!["single-column", "double-column"].includes(state.layoutMode.value) || state.isDrawerMenu.value) ? 'inline' : 'horizontal'
  })

  return {
    getMenus,
    terminalType,
    menuMode
  }
}
