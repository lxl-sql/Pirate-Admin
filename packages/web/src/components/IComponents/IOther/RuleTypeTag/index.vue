<!-- 规则类型 -->
<script setup lang="ts">
import {useI18n} from "vue-i18n";
import {ITagProps} from "@/types/tag";
import {computed} from "vue";

const {t} = useI18n()


interface RuleTypeTagProps extends ITagProps {
  value?: 1 | 2 | 3
}

const typeObj = {
  1: {
    color: "success",
    name: t('admin_permission.enum.type.1'),
  },
  2: {
    color: "processing",
    name: t('admin_permission.enum.type.2'),
  },
  3: {
    color: "warning",
    name: t('admin_permission.enum.type.3'),
  },
}

const {
  value,
  ...restProps
} = defineProps<RuleTypeTagProps>()

const color = computed(() => {
  return value ? typeObj[value]?.color : 'error'
})
const name = computed(() => {
  return value ? typeObj[value]?.name : '暂无数据'
})

defineOptions({
  name: 'RuleTypeTag'
})
</script>

<template>
  <a-tag class="mr-0" v-bind="restProps" :color="color">
    {{ name }}
  </a-tag>
</template>
