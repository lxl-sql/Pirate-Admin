<!-- 权限按钮 -->
<script setup lang="ts">
import {defineOptions, withDefaults} from "vue";
import {TButtonType} from "@/types";

/**
 * @param type 按钮类型
 */
interface IProps {
  type: TButtonType;
}

//#endregion
withDefaults(defineProps<IProps>(), {
  type: "default",
});

defineOptions({
  name: "IButton",
});
</script>

<template>
  <a-button :type="type" v-bind="$attrs">
    <template v-for="(slot, name) in $slots" v-slot:[name]>
      <slot :name="name" :slot="slot"></slot>
    </template>
  </a-button>
</template>

<style lang="less" scoped>
@import "index.less";
</style>
