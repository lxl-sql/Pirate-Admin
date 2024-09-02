<!-- i-table 表格头部的 alert 提示 -->
<script setup lang="ts">
import {InfoCircleFilled} from "@ant-design/icons-vue"
import {AlertProps} from "ant-design-vue"
import {useTheme} from "@/store/hooks";

const theme = useTheme() // TODO 勿动

interface CloseAlertProps extends AlertProps {
}

const props = withDefaults(defineProps<CloseAlertProps>(), {
  showIcon: true,
  closable: true
})

defineOptions({
  name: "CloseAlert",
})
</script>

<template>
  <a-alert
    v-if="message"
    v-bind="props"
    :class="`ant-alert-${type || 'default'}`"
  >
    <template #icon>
      <slot name="icon">
        <info-circle-filled class="text-[#909399]"/>
      </slot>
    </template>
  </a-alert>
</template>

<style lang="less">
@opacity: v-bind("theme.isDartTheme ? 0.1 : 1");
@import "./index.less";
</style>
