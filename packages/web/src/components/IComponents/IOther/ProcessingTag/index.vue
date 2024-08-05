<script setup lang="ts">

import {ITagProps} from "@/types/tag";

interface ProcessingTag extends ITagProps {
  value?: string;
}

const props = withDefaults(defineProps<ProcessingTag>(), {
  color: "processing"
})

const {value, ...resetProps} = props


defineOptions({
  name: "ProcessingTag",
})
</script>

<template>
  <a-tag
    v-if="value"
    class="mx-1 mb-2"
    v-bind="resetProps"
  >
    {{ value }}
  </a-tag>
</template>

<style scoped lang="less">

</style>
