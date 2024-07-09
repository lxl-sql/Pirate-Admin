<!-- 黑/白 -->
<script setup lang="ts">
import {defineOptions} from "vue";
import {useTheme} from '@/store/hooks'

const theme = useTheme()


defineOptions({
  name: "NavTheme",
});
</script>

<template>
  <div class="nav-menu-item" title="切换主题" @click="theme.changeTheme">
    <moon-outlined v-if="theme.isDartTheme"/>
    <sun-outlined v-else/>
  </div>
</template>

<style lang="less">
@import "./index.less";
</style>
