<script setup lang="ts">
import {CloseOutlined, ExpandOutlined, MinusOutlined, MinusSquareFilled, SyncOutlined} from "@ant-design/icons-vue";
import {OverlayProps, type OverlayType} from './interface'

defineProps<OverlayProps>()

const emits = defineEmits([
  'click',
])

const handleItemClick = (type: OverlayType) => {
  emits('click', type)
}

defineOptions({
  name: 'TagOverlay'
})
</script>

<template>
  <a-menu>
    <a-menu-item
      key="1"
      :disabled="disabled?.('refresh')"
      @click="handleItemClick('refresh')"
    >
      <sync-outlined class="text-xs"/>
      重新加载
    </a-menu-item>
    <a-menu-item
      key="2"
      :disabled="disabled?.('close')"
      @click="handleItemClick('close')"
    >
      <close-outlined class="text-xs"/>
      关闭标签
    </a-menu-item>
    <a-menu-item
      key="3"
      :disabled="disabled?.('fullScreen')"
      @click="handleItemClick('fullScreen')"
    >
      <expand-outlined class="text-xs"/>
      当前标签页全屏
    </a-menu-item>
    <a-menu-item
      key="4"
      :disabled="disabled?.('closeOther')"
      @click="handleItemClick('closeOther')"
    >
      <minus-outlined class="text-xs"/>
      关闭其他标签页
    </a-menu-item>
    <a-menu-item
      key="5"
      :disabled="disabled?.('closeAll')"
      @click="handleItemClick('closeAll')"
    >
      <minus-square-filled class="text-xs"/>
      关闭全部标签页
    </a-menu-item>
  </a-menu>
</template>
