<!-- a-modal 封装 modal -->
<script setup lang="ts">
import {computed, CSSProperties, ref, unref, watch, watchEffect, withDefaults,} from "vue";
import {useDraggable} from "@vueuse/core";
import {ExpandOutlined, LineOutlined} from '@ant-design/icons-vue';
import type {IDragRect, IModalProps} from "./types";

const props = withDefaults(defineProps<IModalProps>(), {
  closable: true,
  keyboard: true,
  mask: true,
  maskClosable: true,
  draggable: true,
  getContainer: () => document.body
});

const emits = defineEmits([
  // 点击确定回调
  "confirm",
  // 点击遮罩层或右上角叉或取消按钮的回调
  "cancel",
]);

//# region Custom draggable
const modalTitleRef = ref<HTMLElement | null>(null);
const {x, y, isDragging} = useDraggable(modalTitleRef);

const startX = ref<number>(0);
const startY = ref<number>(0);
const startedDrag = ref<boolean>(false);
const transformX = ref<number>(0);
const transformY = ref<number>(0);
const preTransformX = ref<number>(0);
const preTransformY = ref<number>(0);
const dragRect = ref<IDragRect>({left: 0, right: 0, top: 0, bottom: 0});

watch(() => props.open, (open) => {
  if (open) {
    if (props.draggable) {
      initDrag();
    }
    props.init?.();
  }
});

const handleToggleFullScreen = () => {
  initDrag()
  fullScreen.value = !fullScreen.value
}

const initDrag = () => {
  transformX.value = 0;
  transformY.value = 0;
  preTransformX.value = 0;
  preTransformY.value = 0;
  startedDrag.value = false;
};

watch([x, y], () => {
  if (!unref(startedDrag)) {
    startX.value = unref(x);
    startY.value = unref(y);
    const bodyRect = document.body.getBoundingClientRect();
    const titleRect = unref(modalTitleRef)!.getBoundingClientRect();
    dragRect.value.right = bodyRect.width - titleRect.width;
    dragRect.value.bottom = bodyRect.height - titleRect.height;
    preTransformX.value = unref(transformX);
    preTransformY.value = unref(transformY);
  }
  startedDrag.value = true;
});

watch(isDragging, () => {
  if (!isDragging) {
    startedDrag.value = false;
  }
});

watchEffect(() => {
  if (startedDrag.value) {
    transformX.value =
      preTransformX.value +
      Math.min(Math.max(dragRect.value.left, x.value), dragRect.value.right) -
      startX.value;
    transformY.value =
      preTransformY.value +
      Math.min(Math.max(dragRect.value.top, y.value), dragRect.value.bottom) -
      startY.value;
  }
});

const transformStyle = computed<CSSProperties>(() => {
  return {
    transform: `translate(${unref(transformX)}px, ${unref(transformY)}px)`,
  };
});
//#endregion

//# region Built-in methods
const fullScreen = ref<boolean>(false)
// 全屏 Modal
const warpClassName = computed(() => {
  return fullScreen.value ? 'full-modal' : props.wrapClassName
})
//# endregion
</script>

<template>
  <a-modal
    class="i-modal"
    v-bind="props"
    :title="undefined"
    :wrap-class-name="warpClassName"
  >
    <template #title>
      <div
        ref="modalTitleRef"
        class="w-[100%] px-[24px] py-[16px] border-0 border-b-[1px] border-solid border-[var(--colorBorder)]"
        :style="{ cursor: draggable ? 'move' : 'auto' }"
      >
        {{ title }}
        <slot name="headerIcon"></slot>
        <button class="ant-modal-close ant-modal-expand" @click="handleToggleFullScreen">
          <line-outlined v-if="fullScreen"/>
          <expand-outlined v-else/>
        </button>
      </div>
    </template>
    <template v-if="draggable" #modalRender="{ originVNode }">
      <div :style="transformStyle">
        <component :is="originVNode"/>
      </div>
    </template>
    <a-spin :spinning="loading">
      <slot></slot>
    </a-spin>
    <template #footer>
      <slot name="footer">
        <a-button key="back" :loading="cancelLoading && loading" @click="emits('cancel')">
          {{ $t('button.cancel') }}
        </a-button>
        <a-button type="primary" :loading="loading" @click="emits('confirm')">
          {{ $t('button.confirm') }}
        </a-button>
      </slot>
    </template>
  </a-modal>
</template>

<style lang="less">
@import "index.less";
</style>
