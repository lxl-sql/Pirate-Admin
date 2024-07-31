import {theme as defaultTheme} from 'ant-design-vue';
import {ColorOption, LayoutMode, Menu, ThemeState} from "./types";
import {reactive, ref, shallowRef} from "vue";
import {ThemeConfig} from "ant-design-vue/es/config-provider/context";


const themeColorOptions: ColorOption[] = [
  {label: "常规蓝", value: "#1677ff"},
  {label: "草原绿", value: "#00b96b"},
  {label: "玫瑰红", value: "#f5222d"},
  {label: "日落橙", value: "#fa8c16"},
  {label: "薰衣紫", value: "#722ed1"},
  {label: "墨玉黑", value: "#001529"}
]
const storeConfigLayoutKey = "store-config-layout"

export const useState = (): ThemeState => {
  const theme = reactive<ThemeConfig>({
    algorithm: defaultTheme.defaultAlgorithm,
  })
  const themeColor = shallowRef<string>('#1677ff')
  const layoutMode = shallowRef<LayoutMode>('default')
  // 是否暗黑主题 黑/白 默认白 false; 黑 true
  const isDartTheme = shallowRef<boolean>(false);

  const isSidebarCollapsed = shallowRef<boolean>(false);
  const isFullScreen = shallowRef<boolean>(false);
  const isLayoutFullScreen = shallowRef<boolean>(false);
  const isPageRefreshing = shallowRef<boolean>(false);
  const isDrawerMenu = shallowRef<boolean>(false);

  const cacheMenus = ref<Menu[] | null>(null);
  const siderMenus = ref<Menu[] | null>(null);
  const headerMenus = ref<Menu[] | null>(null);

  return {
    // theme
    theme,
    themeColor,
    layoutMode,
    isDartTheme,
    themeColorOptions,
    storeConfigLayoutKey,
    // layout
    isSidebarCollapsed,
    isFullScreen,
    isLayoutFullScreen,
    isPageRefreshing,
    isDrawerMenu,
    cacheMenus,
    siderMenus,
    headerMenus
  }
}
