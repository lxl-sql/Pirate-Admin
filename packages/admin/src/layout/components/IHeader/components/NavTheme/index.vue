<!-- 主题模式 -->
<script setup lang="ts">
import {useTheme} from '@/store/hooks'

const theme = useTheme()


defineOptions({
  name: "NavTheme",
});
</script>

<template>
  <a-tooltip :title="$t('layout.header.title.use theme')">
    <div class="nav-menu-item" @click="theme.changeTheme">
      <moon-outlined v-if="theme.isDartTheme"/>
      <sun-outlined v-else/>
    </div>
  </a-tooltip>
</template>

<style lang="less">
@import "./index.less";
</style>
