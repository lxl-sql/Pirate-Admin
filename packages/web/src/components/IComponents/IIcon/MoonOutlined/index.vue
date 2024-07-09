<!-- MoonOutlined -->
<script setup lang="ts">
import Icon from "@ant-design/icons-vue";
import { defineOptions } from "vue";

defineOptions({
  name: "MoonOutlined",
});
</script>

<template>
  <icon>
    <template #component="svgProps">
      <svg
        viewBox="0 0 1024 1024"
        width="1em"
        height="1em"
        fill="currentColor"
        v-bind="svgProps"
      >
        <path
          d="M512 0l12.9 0.3c8.1 0.4 14.4 7.3 14 15.4-0.1 2.8-1.1 5.5-2.7 7.8-27.2 38.3-43.8 64.5-49.9 78.7-70.9 169.6 9.2 364.5 178.8 435.4 76.9 32.1 163.1 34.2 241.5 5.9l14.1-5.4c18.8-7.8 42.4-22 70.8-42.6 9.1-6.6 21.9-4.6 28.5 4.6 2.5 3.5 3.9 7.7 3.9 12 0 11.5-0.4 23-1.1 34.3l-1.4 16.9-1 9.2-2 15.5C981.8 834.7 769 1024 512 1024 229.2 1024 0 794.8 0 512 0 259.7 182.5 50.1 422.6 7.8l17.3-2.7L452 3.5l8.8-1C477.6 0.9 494.7 0 512 0zM370.7 127.4l-8.6 3.2c-210.5 83-313.9 321-230.9 531.5C192.9 818.6 343.9 921.4 512 921.6c171.8 0 325.3-107.1 384.6-268.3-233.6 56.9-469-86.3-525.9-319.8a435.25 435.25 0 0 1 0-206.1z"
          p-id="1123"
        ></path>
      </svg>
    </template>
  </icon>
</template>
