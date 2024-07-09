/**
 * @name 'useTheme'
 */
import {defineStore} from "pinia";
import {nextTick, reactive, ref} from "vue";
import {MappingAlgorithm, ThemeConfig} from "ant-design-vue/es/config-provider/context";
import {theme as defaultTheme} from 'ant-design-vue';
import {$local} from "@/utils/storage";

type ThemeMode = "dark" | "light"

const {useToken} = defaultTheme
export const useTheme = defineStore(
  'theme',
  () => {
    const {token} = useToken()

    const theme = reactive<ThemeConfig>({
      algorithm: defaultTheme.defaultAlgorithm,
    })

    // 是否暗黑主题 黑/白 默认白 false; 黑 true
    const isDartTheme = ref<boolean>(false);

    const setAlgorithm = (algorithm: keyof typeof defaultTheme) => {
      theme.algorithm = defaultTheme[algorithm] as MappingAlgorithm | MappingAlgorithm[];
      theme.token = {
        colorPrimary: '#00b96b',
      }
    }

    const initTheme = async () => {
      const themeMode = $local.get<ThemeMode>("themeMode");
      isDartTheme.value = themeMode === "dark";
      setAlgorithm(isDartTheme.value ? 'darkAlgorithm' : 'defaultAlgorithm')
      // 设置主题
      window.document.documentElement.setAttribute("data-theme", themeMode || "light");
      await setStyleAttribute(themeMode)
    }

    /**
     * 切换主题
     */
    const changeTheme = async () => {
      isDartTheme.value = !isDartTheme.value;
      setAlgorithm(isDartTheme.value ? 'darkAlgorithm' : 'defaultAlgorithm')
      const themeMode: ThemeMode = isDartTheme.value ? "dark" : "light";
      // 缓存主题
      $local.set<ThemeMode>("themeMode", themeMode);
      window.document.documentElement.setAttribute("data-theme", themeMode);
      await setStyleAttribute(themeMode)
    };

    // 设置全局主题 attribute
    const setStyleAttribute = async (themeMode: ThemeMode) => {
      await nextTick()
      const _t = token.value
      const isDartTheme = themeMode === 'dark'
      const customToken = {
        ..._t,
        colorBgLayoutContainer: isDartTheme ? _t.colorBgContainer : '#f0f2f5'
      }
      const keys: string[] = [
        'colorBgLayoutContainer',
        'colorBgContainer',
        'colorBgTextHover',
        'colorPrimary',
        'colorText',
        'colorBorderSecondary',
        'motionUnit',
        'boxShadow',
        'boxShadowSecondary'
      ]
      const style = Object.keys(customToken).filter(key => keys.includes(key)).map((key) => `--${key}:${customToken[key]}`).join(';');
      window.document.documentElement.setAttribute("style", style);

    }

    return {
      theme,
      isDartTheme,
      initTheme,
      setAlgorithm,
      useToken,
      changeTheme,
    }
  }
);
