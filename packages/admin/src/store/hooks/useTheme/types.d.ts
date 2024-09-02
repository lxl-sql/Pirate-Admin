import {Ref, ShallowRef, UnwrapRef} from "vue";
import {ThemeConfig} from "ant-design-vue/es/config-provider/context";
import {Key} from "@/types";

export type ThemeMode = "dark" | "light"
export type LayoutMode = "default" | "classic" | "single-column" | "double-column"

export interface ColorOption {
  label: string
  value: string
}

export interface StoreConfigLayout {
  color: string
  themeMode: ThemeMode
  layoutMode: LayoutMode
  menuUniqueOpened: boolean
}

export interface Menu {
  id?: Key;
  title: string;
  path: string;
  name: string;
  icon: string;
  children?: Menu[];
  level?: number;
}

export interface ThemeState {
  // theme
  theme: ThemeConfig
  themeColorOptions: ColorOption[];
  storeConfigLayoutKey: string;
  themeColor: ShallowRef<string>
  layoutMode: ShallowRef<LayoutMode>
  isDartTheme: ShallowRef<boolean>
  // layout
  /**
   * 是否收起侧边栏 true 收起 false 展开
   * - 默认: false
   */
  isSidebarCollapsed: ShallowRef<boolean>
  isFullScreen: ShallowRef<boolean>
  /**
   * 当前标签页全屏
   */
  isLayoutFullScreen: ShallowRef<boolean>
  isPageRefreshing: ShallowRef<boolean>
  isDrawerMenu: ShallowRef<boolean>
  /** 打开唯一菜单(手风琴模式) */
  menuUniqueOpened: ShallowRef<boolean>
  cacheMenus: Ref<UnwrapRef<Menu[] | null>>
  siderMenus: Ref<UnwrapRef<Menu[] | null>>
  headerMenus: Ref<UnwrapRef<Menu[] | null>>
}
