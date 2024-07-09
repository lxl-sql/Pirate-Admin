<!-- i-table 表格头部的 alert 提示 -->
<script setup lang="ts">
import {InfoCircleFilled} from "@ant-design/icons-vue"
import {AlertProps} from "ant-design-vue"
import {useTheme} from '@/store/hooks'
const theme = useTheme();

defineProps<AlertProps>()

defineOptions({
  name: "CloseAlert",
})
</script>

<template>
  <a-alert
    v-if="message"
    :message="message"
    type="default"
    show-icon
    closable
    v-bind="$attrs"
  >
    <template #icon>
      <slot name="icon">
        <info-circle-filled style="color: #909399"/>
      </slot>
    </template>
  </a-alert>
</template>

<style lang="less">
@opacity: v-bind("theme.isDartTheme ? 0.1 : 1");

.ant-alert-default {
  @apply border border-solid;
  background-color: rgba(230,232,235, @opacity);
  border-color: rgba(223,223,223, @opacity);
  .ant-alert-message {
    @apply text-[@info-color];
  }
}
</style>
