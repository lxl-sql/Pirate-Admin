<!-- Home 首页 -->
<script setup lang="ts">
import Banner from "../components/HomeContent/banner.vue";
import Panel from "../components/HomeContent/panel.vue";
import Chart1 from "../components/HomeContent/chart1.vue";
</script>

<template>
  <div class="home">
    <Banner />
    <Panel />
    <Chart1 />
    <!-- <Chart1 /> -->
  </div>
</template>

<style lang="less" scoped>
@import "./index.less";
</style>
