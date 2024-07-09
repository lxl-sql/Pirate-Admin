<script setup lang="ts">

import {TagProps} from "ant-design-vue/es/tag";
import {toRefs} from "vue";

interface ProcessingTag extends /* @vue-ignore */ TagProps {
  value?: string;
}

const props = defineProps<ProcessingTag>()

const {
  value,
  color = 'processing',
  ...resetProps
} = toRefs(props)

defineOptions({
  name: "ProcessingTag",
})
</script>

<template>
  <a-tag v-if="value" color="processing" class="table-tag" v-bind="resetProps">
    {{ value }}
  </a-tag>
</template>

<style scoped lang="less">

</style>
