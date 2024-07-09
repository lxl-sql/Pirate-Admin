<!-- a-tooltip 的 常用封装 -->
<script setup lang="ts">
import {type CSSProperties, defineOptions} from "vue";
import {ButtonProps} from "ant-design-vue";
import {storeToRefs} from "pinia";
import {useLayoutStore} from "@/store";
import {TButtonType} from "@/types";

const store = useLayoutStore();
const {terminalType} = storeToRefs(store);

interface ITooltipProps {
  title?: string;
  content?: string; // tooltip 内容 使用 content 无需此参数
  type?: TButtonType;
  size?: ButtonProps['size'];
  disabled?: boolean;
  buttonClassName?: StringConstructor
  buttonStyle?: {
    type: import("vue").PropType<CSSProperties>;
    default: CSSProperties;
  }
  buttonProps?: ButtonProps
}

const props = withDefaults(defineProps<ITooltipProps>(), {
  type: 'primary'
})

const emits = defineEmits(['click'])

defineOptions({
  name: "ITooltip",
});
</script>

<template>
  <a-tooltip
    :title="!disabled && terminalType === 'pc' && title"
    v-bind="$attrs"
  >
    <template #title>
      <slot name="title"></slot>
    </template>
    <!-- 自定义内容 -->
    <slot>
      <a-button
        :type="type"
        :size="size"
        :disabled="disabled"
        :class="buttonClassName"
        :style="buttonStyle"
        v-bind="props.buttonProps"
        @click="emits('click',$event)"
      >
        <template #icon>
          <!-- 图标 可自定义 -->
          <slot name="icon"></slot>
        </template>
        <!-- 内容 -->
        {{ content }}
      </a-button>
    </slot>
  </a-tooltip>
</template>

<style lang="less" scoped>
@import "index.less";
</style>
