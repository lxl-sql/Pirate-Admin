<!-- 全屏/取消全屏 -->
<script setup lang="ts">
import {CompressOutlined, ExpandOutlined} from "@ant-design/icons-vue";
import {useTheme} from "@/store/hooks";
import {computed} from "vue";
import {useI18n} from "vue-i18n";

const {t} = useI18n()
const theme = useTheme()

const title = computed(() => {
  return theme.isFullScreen ? t('layout.header.title.full screen') : t('layout.header.title.exit full screen')
})

defineOptions({
  name: "NavFullScreen",
});
</script>

<template>
  <a-tooltip :title="title">
    <div class="nav-menu-item" @click="theme.toggleFullScreen">
      <!-- 全屏 -->
      <compress-outlined v-if="theme.isFullScreen"/>
      <!-- 取消全屏 -->
      <expand-outlined v-else/>
    </div>
  </a-tooltip>
</template>

<style lang="less" scoped>
@import "./index.less";
</style>
