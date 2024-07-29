/**
 * @name 'useTheme'
 */
import {defineStore} from "pinia";
import {nextTick, reactive, shallowRef} from "vue";
import {MappingAlgorithm, ThemeConfig} from "ant-design-vue/es/config-provider/context";
import {theme as defaultTheme} from 'ant-design-vue';
import {$local} from "@/utils/storage";

type ThemeMode = "dark" | "light"
type LayoutMode = "default" | "classic" | "single-column" | "double-column"

interface ColorOption {
  label: string
  value: string
}

interface StoreConfigLayout {
  color: string
  themeMode: ThemeMode
  layoutMode: LayoutMode
}

const {useToken} = defaultTheme
export const useTheme = defineStore(
  'theme',
  () => {
    const {token} = useToken()

    const theme = reactive<ThemeConfig>({
      algorithm: defaultTheme.defaultAlgorithm,
    })
    const themeColor = shallowRef<string>('#1677ff')
    const layoutMode = shallowRef<LayoutMode>('default')
    // 是否暗黑主题 黑/白 默认白 false; 黑 true
    const isDartTheme = shallowRef<boolean>(false);

    const themeColorOptions: ColorOption[] = [
      {label: "常规蓝", value: "#1677ff"},
      {label: "草原绿", value: "#00b96b"},
      {label: "玫瑰红", value: "#f5222d"},
      {label: "日落橙", value: "#fa8c16"},
      {label: "薰衣紫", value: "#722ed1"},
      {label: "墨玉黑", value: "#001529"}
    ]
    const storeConfigLayoutKey = "store-config-layout"

    /**
     * 初始化默认主题配置
     */
    const initLocal = () => {
      const storeConfigLayout = $local.get<StoreConfigLayout>(storeConfigLayoutKey);
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
      const algorithm: keyof typeof defaultTheme = isDartTheme.value ? 'darkAlgorithm' : 'defaultAlgorithm'
      theme.algorithm = defaultTheme[algorithm] as MappingAlgorithm | MappingAlgorithm[];
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
      $local.updateKey<LayoutMode>(storeConfigLayoutKey, 'layoutMode', mode);
      await setStyleAttribute()
    }

    // 设置全局主题 attribute
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

    return {
      theme,
      isDartTheme,
      themeColor,
      themeColorOptions,
      layoutMode,
      initTheme,
      setAlgorithm,
      useToken,
      changeTheme,
      changeThemeColor,
      changeLayoutMode
    }
  }
);
