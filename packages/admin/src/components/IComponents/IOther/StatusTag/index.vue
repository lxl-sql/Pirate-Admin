<!-- 状态tag 0 否 1 是 -->
<script setup lang="ts">

import {DefaultStatus} from "@/types/table";
import {isNumber} from "lodash-es";
import {ITagProps} from "@/types/tag";

interface ProcessingTag extends ITagProps {
  value?: DefaultStatus;
}

const props = defineProps<ProcessingTag>()

const {value, color, ...resetProps} = props

defineOptions({
  name: "StatusTag",
})
</script>

<template>
  <a-tag
    v-if="isNumber(value) && value >= 0"
    :color="color || (value === 1 ? 'success' : 'error')"
    class="last-of-type:mr-0"
    v-bind="resetProps"
  >
    {{ $t(`enum.status.${value}`) }}
  </a-tag>
</template>

<style scoped lang="less">

</style>
