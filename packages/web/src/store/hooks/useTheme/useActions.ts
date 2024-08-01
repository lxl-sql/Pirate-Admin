import {$local} from "@/utils/storage";
import {theme as defaultTheme} from "ant-design-vue";
import {MappingAlgorithm} from "ant-design-vue/es/config-provider/context";
import {nextTick} from "vue";
import {LayoutMode, StoreConfigLayout, ThemeMode, ThemeState} from "./types";
import {exitFullScreen, fullScreen} from "@/utils/dom";
import menuData from './data.json'
import {cloneDeep} from "lodash-es";
import {RouteLocationNormalized, useRoute} from "vue-router";
import {treeForEach} from "@/utils/common";

const {useToken} = defaultTheme
export const useActions = (state: ThemeState) => {
  const {
    theme,
    storeConfigLayoutKey,
    isDartTheme,
    themeColor,
    layoutMode,
    cacheMenus,
    siderMenus,
    headerMenus,
    isSidebarCollapsed,
    isFullScreen,
    isDrawerMenu,
    isLayoutFullScreen,
  } = state

  const {token} = useToken()
  const route = useRoute()

  //# region theme event
  /**
   * 初始化默认主题配置
   */
  const initLocal = () => {
    const storeConfigLayout = $local.get<StoreConfigLayout>(storeConfigLayoutKey) || {};
    const data: StoreConfigLayout = {
      color: storeConfigLayout.color || '#1677ff',
      themeMode: storeConfigLayout.themeMode || 'light',
      layoutMode: storeConfigLayout.layoutMode || 'default'
    }
    $local.set<StoreConfigLayout>(storeConfigLayoutKey, data)
    return data
  }

  /**
   * 初始化默认主题
   */
  const initTheme = async () => {
    const storeConfigLayout = initLocal()
    // 设置主题
    isDartTheme.value = storeConfigLayout.themeMode === "dark";
    setAlgorithm()
    window.document.documentElement.setAttribute("data-theme", storeConfigLayout.themeMode);

    // 设置主题颜色
    setToken(storeConfigLayout.color)
    // 设置布局配置
    setLayoutMode(storeConfigLayout.layoutMode)

    await setStyleAttribute()
  }

  const setAlgorithm = () => {
    const algorithm: keyof typeof defaultTheme = state.isDartTheme.value ? 'darkAlgorithm' : 'defaultAlgorithm'
    state.theme.algorithm = defaultTheme[algorithm] as MappingAlgorithm | MappingAlgorithm[];
  }

  const setToken = (color: string) => {
    themeColor.value = color
    theme.token = {
      colorPrimary: color,
    }
  }

  const setLayoutMode = (mode: LayoutMode) => {
    layoutMode.value = mode
  }

  /**
   * 切换主题
   */
  const changeTheme = async () => {
    isDartTheme.value = !isDartTheme.value;
    setAlgorithm()
    const themeMode: ThemeMode = isDartTheme.value ? "dark" : "light";
    $local.updateKey<ThemeMode>(storeConfigLayoutKey, 'themeMode', themeMode);

    window.document.documentElement.setAttribute("data-theme", themeMode);
    await setStyleAttribute()
  };

  /**
   * 切换主题色
   */
  const changeThemeColor = async (color: string) => {
    setToken(color)
    $local.updateKey<string>(storeConfigLayoutKey, 'color', color)

    await setStyleAttribute()
  };

  const changeLayoutMode = async (mode: LayoutMode) => {
    setLayoutMode(mode)
    changeMenus()
    $local.updateKey<LayoutMode>(storeConfigLayoutKey, 'layoutMode', mode);
    await setStyleAttribute()
  }

  /**
   * 设置全局主题 attribute
   */
  const setStyleAttribute = async () => {
    await nextTick()
    const _t = token.value
    const isDart = isDartTheme.value
    const customToken = {
      ..._t,
      colorBgLayoutContainer: isDart ? _t.colorBgContainer : '#f0f2f5',
      colorBgLayoutNav: isDart ? '#4C4D4F' : '#dcdfe6',
      colorBgLayoutSider: isDart ? '#363637' : '#ebeef5',
      colorBgLayoutView: isDart ? '#2B2B2C' : '#f2f6fc',
    }
    const keys: string[] = [
      'colorBgLayoutContainer',
      'colorBgLayoutNav',
      'colorBgLayoutSider',
      'colorBgLayoutView',
      'colorBgContainer',
      'colorBgTextHover',
      'colorPrimary',
      'colorText',
      'colorBorder',
      'colorBorderSecondary',
      'motionUnit',
      'boxShadow',
      'boxShadowSecondary'
    ]
    const styleContent = Object.keys(customToken)
      .filter(key => keys.includes(key))
      .map((key) => `--${key}:${customToken[key]}`)
      .join(';');

    let styleElement = document.querySelector('style[data-id="theme-variable"]');

    if (!styleElement) {
      styleElement = document.createElement('style');
      styleElement.setAttribute('data-id', 'theme-variable');
      document.head.appendChild(styleElement);
    }

    styleElement.innerHTML = `:root { ${styleContent} }`;
  }
  //# endregion

  //# region sider event
  // 展开/收起菜单
  const toggleMenuState = () => {
    isSidebarCollapsed.value = !isSidebarCollapsed.value
    if (isDrawerMenu.value) return
    $local.set('sider-expand', isSidebarCollapsed.value)
  }
  // 切换全屏
  const toggleFullScreen = () => {
    isFullScreen.value = !isFullScreen.value;
    if (isFullScreen.value) {
      fullScreen();
    } else {
      exitFullScreen();
    }
  }

  const initSiderState = () => {
    const _innerWidth = window.innerWidth;
    const lessThan = _innerWidth <= 1200;
    if (lessThan !== isDrawerMenu.value) {
      isDrawerMenu.value = lessThan
      changeMenus()
    }
    isSidebarCollapsed.value = !isDrawerMenu.value && $local.get('sider-expand') || false
  }

  const initMenus = async () => {
    await getSiderMenus()
    changeMenus()
  }

  const getSiderMenus = async () => {
    cacheMenus.value = menuData.data
  }

  /**
   * 根据主题切换menus值
   */
  const changeMenus = (value?: RouteLocationNormalized) => {
    if (!cacheMenus.value?.length) return
    const mode: LayoutMode = layoutMode.value
    const _route = value || route
    const _cacheMenus = cloneDeep(cacheMenus.value)
    if (['single-column', 'double-column'].includes(mode)) {
      headerMenus.value = _cacheMenus
      if (isDrawerMenu.value) {
        siderMenus.value = _cacheMenus
        return
      }
      if (mode === 'single-column') {
        siderMenus.value = []
      } else {
        const key = _route.name
        let newSiderMenus: any | null = {}
        treeForEach(_cacheMenus, (menu, _index, _arr, parent) => {
          if (menu.name === key) {
            newSiderMenus = parent ? parent : menu
          }
        })
        // console.log('route', key, newSiderMenus)
        if (!newSiderMenus) return
        if (newSiderMenus.children?.length) {
          siderMenus.value = newSiderMenus.children
        } else {
          siderMenus.value = [newSiderMenus]
        }
        newSiderMenus = null
      }
    } else {
      siderMenus.value = _cacheMenus
    }
  }

  // 视口改变事件
  const onResize = (event: UIEvent) => {
    isFullScreen.value = document.fullscreenElement !== null; // 当前是否全屏
    if (!document.fullscreenElement) {
      isLayoutFullScreen.value = false;
    }
    // 当视图宽度小于1200时 收起菜单栏
    initSiderState()
  }
  // 键盘按下事件
  const onKeyDown = (event: KeyboardEvent) => {
    if (event.keyCode === 122) {
      event.preventDefault(); // 取消默认事件
      toggleFullScreen();
    }
  }

  // 监听全局事件
  const listenerChange = (flag: boolean) => {
    if (flag) {
      // 监听页面事件
      window.addEventListener("resize", onResize);
      // 监听键盘事件
      window.addEventListener("keydown", onKeyDown);
    } else {
      // 取消监听页面事件
      window.removeEventListener("resize", onResize);
      // 取消监听键盘事件
      window.removeEventListener("keydown", onKeyDown);
    }
  }
  //# endregion

  return {
    // theme
    initTheme,
    setAlgorithm,
    changeTheme,
    changeThemeColor,
    changeLayoutMode,
    useToken,
    // layout
    initMenus,
    initSiderState,
    toggleMenuState,
    toggleFullScreen,
    listenerChange,
    changeMenus,
  }
}
