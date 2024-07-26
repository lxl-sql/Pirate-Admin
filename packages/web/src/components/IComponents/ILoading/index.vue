<!-- 进度条加载 ILoading -->
<script setup lang="ts">
import {defineProps, onBeforeUnmount, onMounted, ref} from 'vue';

defineOptions({
  name: 'ILoading'
});

interface LoadingProps {
  loading: boolean;
  fullscreen?: boolean;
  progress?: number; // 新增进度条
  indicator?: any;
}

const props = defineProps<LoadingProps>();

const isFullscreen = ref(props.fullscreen ?? false);
const loading = ref(props.loading);
const progress = ref(props.progress ?? 0);

onMounted(() => {
  loading.value = props.loading;
});

onBeforeUnmount(() => {
  loading.value = false;
});
</script>

<template>
  <!--  <a-spin :spinning="loading" :indicator="props.indicator || defaultIndicator">-->
  <!--    <div v-if="!isFullscreen" class="loading-container">-->
  <!--      <slot></slot>-->
  <!--      <a-progress v-if="progress > 0" :percent="progress"/>-->
  <!--    </div>-->
  <!--  </a-spin>-->
  <!--  <div v-if="isFullscreen" class="loading-fullscreen">-->
  <!--    <a-spin :spinning="loading" :indicator="props.indicator || defaultIndicator">-->
  <!--      <a-progress v-if="progress > 0" :percent="progress"/>-->
  <!--    </a-spin>-->
  <!--  </div>-->
</template>

<style scoped lang="less">

.loading-fullscreen {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: rgba(255, 255, 255, 0.8);
  z-index: 9999;
}
</style>
