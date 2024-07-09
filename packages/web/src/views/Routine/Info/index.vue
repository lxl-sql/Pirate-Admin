<!-- 个人资料 -->
<script setup lang="ts">
import Edit from "./components/Edit/index.vue";
import Log from "./components/Log/index.vue";
</script>

<template>
  <a-row class="default-main" :gutter="[16, 16]">
    <a-col :lg="12" :xs="24" class="default-main-col">
      <edit class="is-always-shadow" />
    </a-col>
    <a-col :lg="12" :xs="24" class="default-main-col">
      <a-card
        title="操作日志"
        :bordered="false"
        class="is-always-shadow operate-log"
      >
        <log />
      </a-card>
    </a-col>
  </a-row>
</template>

<style lang="less" scoped>
@import "./index.less";
</style>
