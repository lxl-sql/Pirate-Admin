<script setup lang="ts">
import {formatUnit} from '@/utils/common'
import {computed} from "vue";

interface EllipsisProps {
  value?: string;
  width?: number | string;
  tooltip?: boolean;
}

const props = defineProps<EllipsisProps>()

const customStyle = computed(() => {
  return {
    width: formatUnit(props.width)
  }
})

defineOptions({
  name: "ellipsis",
})
</script>

<template>
  <a-tooltip placement="topLeft" v-bind="$attrs">
    <template #title v-if="props.tooltip">
      <slot>
        {{ props.value }}
      </slot>
    </template>
    <span class="ellipsis" :style="customStyle">
      <slot>
        {{ props.value }}
      </slot>
    </span>
  </a-tooltip>
</template>
