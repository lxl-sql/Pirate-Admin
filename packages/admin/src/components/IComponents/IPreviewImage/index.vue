<!-- 图片预览 -->
<script setup lang="ts">

interface IPropsPreviewImage {
  src: string; // 图片地址
  open: boolean; // open
}

const props = withDefaults(defineProps<IPropsPreviewImage>(), {
  src: "",
  open: false,
});
const emits = defineEmits(["update:open"]);

const onVisibleChange = (flag: boolean) => {
  emits("update:open", flag);
};

defineOptions({
  name: "IPreviewImage",
})
</script>

<template>
  <a-image
    class="hidden"
    :preview="{
      visible:open,
      onVisibleChange: onVisibleChange,
    }"
    :src="props.src"
  />
</template>

<style lang="less" scoped>
// @import "./index.less";
</style>
