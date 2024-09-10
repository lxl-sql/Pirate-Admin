<!-- 状态tag 0 否 1 是 -->
<script setup lang="ts">

import {DefaultStatus} from "@/types/table";
import {isNumber} from "lodash-es";
import {ITagProps} from "@/types/tag";
import {computed, toRefs} from "vue";

interface ProcessingTag extends ITagProps {
  value?: DefaultStatus;
}

const props = defineProps<ProcessingTag>()

const {value, color, ...resetProps} = toRefs(props)

const resetBind = computed(() => {
  return Object.keys(resetProps).reduce((prev, key) => {
    prev[key] = resetProps[key].value;
    return prev
  }, {})
})

defineOptions({
  name: "StatusTag",
})
</script>

<template>
  <a-tag
    v-if="isNumber(value) && value >= 0"
    :color="color || (value === 1 ? 'success' : 'error')"
    class="last-of-type:mr-0"
    v-bind="resetBind"
  >
    {{ $t(`enum.status.${value}`) }}
  </a-tag>
</template>

<style scoped lang="less">

</style>
