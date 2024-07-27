import {createApp, DirectiveBinding, h} from 'vue';
import {Spin} from 'ant-design-vue';

interface LoadingBinding extends DirectiveBinding {
  value: boolean | {
    /**
     * 加载状态
     */
    visible: boolean;
    /**
     * 是否全局loading
     */
    global?: boolean;
    /**
     * 加载中的值
     */
    text?: string;
    /**
     * 加载自定义图标
     */
    icon?: any;
  };
}

// 创建全局 spin 层
const createSpinWrapper = (binding: LoadingBinding) => {
  const {visible, global = false} = typeof binding.value === 'boolean' ? {visible: binding.value} : binding.value || {}
  const spinWrapper = document.createElement('div');
  spinWrapper.classList.add('loading-spin-wrapper');
  spinWrapper.style.position = 'fixed';
  spinWrapper.style.position = global ? 'fixed' : 'absolute';
  spinWrapper.style.top = '0';
  spinWrapper.style.left = '0';
  spinWrapper.style.right = '0';
  spinWrapper.style.bottom = '0';
  spinWrapper.style.display = visible ? 'flex' : 'none';
  spinWrapper.style.alignItems = 'center';
  spinWrapper.style.justifyContent = 'center';
  spinWrapper.style.backgroundColor = 'rgba(255, 255, 255, 0.7)';
  spinWrapper.style.zIndex = '1000';
  spinWrapper.style.pointerEvents = 'none';
  return spinWrapper;
};

// 创建加载动画的 Vue 应用
const createLoadingApp = (visible: boolean, restProps: Omit<LoadingBinding['value'], 'visible'>) => {
  const {text, icon} = restProps || {}
  return createApp({
    render() {
      return h(
        Spin,
        {
          spinning: true,
          tip: text,
          indicator: icon ? h(icon) : undefined,
        },
        null
      );
    },
  });
};

const vLoading = {
  mounted(el: HTMLElement, binding: LoadingBinding) {
    const spinWrapper = createSpinWrapper(binding);
    el.style.position = 'relative';

    // 通过解构赋值来获取相关参数
    const {visible, ...restProps} = typeof binding.value === 'boolean'
      ? {visible: binding.value}
      : binding.value || {}

    const app = createLoadingApp(binding.value?.visible, restProps);

    app.mount(spinWrapper);
    el.appendChild(spinWrapper);

    el._loadingInstance = app;
    el._loadingWrapper = spinWrapper;
  },
  updated(el: HTMLElement, binding: LoadingBinding) {
    const spinWrapper = el._loadingWrapper;
    const {visible, ...resetProps} = typeof binding.value === 'boolean'
      ? {visible: binding.value}
      : binding.value || {}

    // 更新显示状态
    spinWrapper.style.display = visible ? 'flex' : 'none';

    // TODO International configuration cannot be updated in real time
    // Update props directly without destroying and rebuilding instances
    // const spinInstance = el._loadingInstance._instance;
    // if (spinInstance) {
    //   spinInstance.props.spinning = visible;
    //   spinInstance.props.tip = text || i18n.global.t('tip.loading');
    //   spinInstance.props.indicator = customIcon ? h(customIcon) : undefined;
    // }
    // TODO International configuration is required, although it consumes a lot of performance
    // Destroy the previous Vue instance and create a new one with updated text
    el._loadingInstance.unmount();
    const newApp = createLoadingApp(visible, resetProps);
    newApp.mount(spinWrapper);
    el._loadingInstance = newApp;
  },
  unmounted(el: HTMLElement) {
    if (el._loadingInstance && el._loadingWrapper) {
      el._loadingInstance.unmount();
      el.removeChild(el._loadingWrapper);
      el._loadingInstance = null;
      el._loadingWrapper = null;
    }
  },
};

export default vLoading;
