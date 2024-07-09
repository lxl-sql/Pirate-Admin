<!-- 状态tag 0 否 1 是 -->
<script setup lang="ts">

import {TagProps} from "ant-design-vue/es/tag";
import {toRefs} from "vue";
import {DefaultStatus} from "@/types/table";
import {isNumber} from "lodash-es";

interface ProcessingTag extends /* @vue-ignore */ TagProps {
  value?: DefaultStatus;
}

const props = defineProps<ProcessingTag>()

const {
  value,
  color,
  ...resetProps
} = toRefs(props)

defineOptions({
  name: "StatusTag",
})
</script>

<template>
  <a-tag
    v-if="isNumber(value) && value >= 0"
    :color="color || (value === 1 ? 'success' : 'error')"
    class="table-tag"
    v-bind="resetProps"
  >
    {{ $t(`enum.status.${value}`) }}
  </a-tag>
</template>

<style scoped lang="less">

</style>
