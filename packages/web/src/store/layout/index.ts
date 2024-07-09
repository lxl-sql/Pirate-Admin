// store/index.ts
import {getTerminal} from "@/utils/common";
import {defineStore} from "pinia";
import type {HeaderInterface} from "./types";
import {$local} from "@/utils/storage";
import {exitFullScreen, fullScreen} from "@/utils/dom";

export const useLayoutStore = defineStore("layoutStore", {
  state: (): HeaderInterface => {
    return {
      isSidebarOpen: false,
      isFullScreen: false,
      isLayoutFullScreen: false,
      isPageRefreshing: false,
      isAsideMenu: false,
      menus: null,
    };
  },
  getters: {
    // 获取菜单列表，用于渲染左侧菜单栏，以及 tags，header，侧边栏抽屉，面包屑，路由，权限，动态路由，动态权限，动态菜单
    getMenus: (state) => {
      const menus = $local.get('BREADCRUMBKEYFORPM')
      return state.menus || menus || [];
    },
    // 获取终端类型 mobile pc
    terminalType: () => getTerminal(),
  },
  actions: {
    // 展开/收起菜单
    toggleMenuState() {
      this.isSidebarOpen = !this.isSidebarOpen
      $local.set('sider-expand', this.isSidebarOpen)
    },
    // 切换全屏
    toggleFullScreen() {
      this.isFullScreen = !this.isFullScreen;
      if (this.isFullScreen) {
        fullScreen();
      } else {
        exitFullScreen();
      }
    },
    initSiderState() {
      const _innerWidth = window.innerWidth;
      this.isAsideMenu = _innerWidth <= 1200;
      this.isSidebarOpen = !this.isAsideMenu && $local.get('sider-expand') || false
    },
    // 视口改变事件
    onResize(event: UIEvent) {
      this.isFullScreen = document.fullscreenElement !== null; // 当前是否全屏
      if (!document.fullscreenElement) {
        this.isLayoutFullScreen = false;
      }
      // 当视图宽度小于1200时 收起菜单栏
      this.initSiderState()
    },
    // 键盘按下事件
    onKeyDown(event: KeyboardEvent) {
      if (event.keyCode === 122) {
        event.preventDefault(); // 取消默认事件
        this.toggleFullScreen();
      }
    },
    // 监听全局事件
    listenerChange(flag: boolean) {
      if (flag) {
        // 监听页面事件
        window.addEventListener("resize", this.onResize);
        // 监听键盘事件
        window.addEventListener("keydown", this.onKeyDown);
      } else {
        // 取消监听页面事件
        window.removeEventListener("resize", this.onResize);
        // 取消监听键盘事件
        window.removeEventListener("keydown", this.onKeyDown);
      }
    },
  },
});
