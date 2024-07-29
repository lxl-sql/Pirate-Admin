<script setup lang="ts">

import {ITagProps} from "@/types/tag";

interface ProcessingTag extends ITagProps {
  value?: string;
}

const {
  value,
  ...resetProps
} = withDefaults(defineProps<ProcessingTag>(), {
  color: "processing"
})


defineOptions({
  name: "ProcessingTag",
})
</script>

<template>
  <a-tag
    class="last-of-type:mr-0"
    v-bind="resetProps"
  >
    {{ value }}
  </a-tag>
</template>

<style scoped lang="less">

</style>
