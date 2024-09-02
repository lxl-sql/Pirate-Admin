<!--表格头部 展开收缩按钮-->
<script setup lang="ts">
import {computed} from "vue";
import {MinusSquareOutlined, PlusSquareOutlined} from '@ant-design/icons-vue';
import {useI18n} from "vue-i18n";

const {t} = useI18n();

const props = defineProps({
  expand: {
    type: Boolean,
    default: false,
  },
});
const emit = defineEmits(["update:expand"]);
const title = computed(() => props.expand ? t('title.collapseAll') : t('title.expandAll'));
const content = computed(() => props.expand ? t('title.collapse') : t('title.expand'));
</script>

<template>
  <i-tooltip
    :title="title"
    :content="content"
    :type="expand ? 'primary' : 'warning'"
    :button-props="{danger:expand}"
    @click="(e) => emit('update:expand', !expand)"
    v-bind="$attrs"
  >
    <template #icon>
      <minus-square-outlined v-if="expand"/>
      <plus-square-outlined v-else/>
    </template>
  </i-tooltip>
</template>
