<script lang="ts" setup>
import {QuestionCircleOutlined} from '@ant-design/icons-vue';

interface QuestionTooltipProps {
  title?: string,
  content?: string,
  iconClassName?: string | Record<string, boolean> | string[]
}

defineProps<QuestionTooltipProps>()

defineOptions({
  name: 'QuestionTooltip'
})
</script>

<template>
  <span class="flex items-center">
    {{ content }}
    <a-tooltip placement="rightTop" v-bind="$attrs">
      <template #title>
        <slot name="title">
          {{ title }}
        </slot>
      </template>
      <slot>
        <question-circle-outlined class="cursor-pointer ml-2" :class="iconClassName"/>
      </slot>
    </a-tooltip>
  </span>
</template>

<style lang="less" scoped>

</style>
