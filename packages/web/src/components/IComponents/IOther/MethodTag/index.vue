<!-- 请求接口展示颜色 -->
<script setup lang="ts">

import {methodTagColor} from "@/utils/common";

interface MethodTagProps {
  method: string
}

const props = withDefaults(defineProps<MethodTagProps>(), {})

defineOptions({
  name: "methodTag",
})
</script>

<template>
  <a-tag :color="methodTagColor(props.method)">
    {{ props.method }}
  </a-tag>
</template>

<style scoped lang="less">

</style>
