<!-- 详情 -->
<script lang="ts">
import {  ref } from "vue";
</script>
<script setup lang="ts">
import BasicInfo from "./components/BasicInfo/index.vue";
import AuthorInfo from "./components/AuthorInfo/index.vue";

const isDetailModal = ref<boolean>(false);

const init = () => {
  isDetailModal.value = true;
};

const handleCancel = () => {
  isDetailModal.value = false;
};

defineExpose({
  init,
});
</script>

<template>
  <i-modal
    title="详细信息"
    width="900px"
    :open="isDetailModal"
    maskClosable
    :footer="null"
    @cancel="handleCancel"
  >
    <div class="detail-main d-flex">
      <div class="main-left">
        <basic-info />
      </div>
      <div class="main-right">
        <author-info />
      </div>
    </div>
  </i-modal>
</template>

<style lang="less" scoped>
@import "./index.less";
</style>
