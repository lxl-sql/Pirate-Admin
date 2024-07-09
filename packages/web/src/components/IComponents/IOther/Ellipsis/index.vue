<script setup lang="ts">
import {formatUnit} from '@/utils/common'

interface EllipsisProps {
  value?: string;
  width?: number | string;
  tooltip?: boolean;
}

const props = defineProps<EllipsisProps>()

defineOptions({
  name: "ellipsis",
})
</script>

<template>
  <a-tooltip placement="topLeft">
    <template #title v-if="props.tooltip">
      <slot>
        {{ props.value }}
      </slot>
    </template>
    <span class="ellipsis" :style="{width: formatUnit(width)}">
      <slot>
        {{ props.value }}
      </slot>
    </span>
  </a-tooltip>
</template>
