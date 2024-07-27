<!-- 默认全屏加载界面 -->
<script setup lang="ts">
import {ref} from "vue";

// 是否显示加载界面
const loading = ref<boolean>(false);

const show = () => {
  loading.value = true;
};

const hide = () => {
  loading.value = false;
};

// 全局加载界面
defineExpose({
  show,
  hide,
});
</script>

<template>
  <div v-if="loading" id="loading">
    <div id="loading-center">
      <div id="loading-center-absolute">
        <div class="object" id="object_one"></div>
        <div class="object" id="object_two"></div>
        <div class="object" id="object_three"></div>
        <div class="object" id="object_four"></div>
        <div class="object" id="object_five"></div>
        <div class="object" id="object_six"></div>
        <div class="object" id="object_seven"></div>
        <div class="object" id="object_eight"></div>
        <div class="object" id="object_big"></div>
      </div>
    </div>
  </div>
</template>

<style lang="less" scoped>
@import "./index.less";
</style>
