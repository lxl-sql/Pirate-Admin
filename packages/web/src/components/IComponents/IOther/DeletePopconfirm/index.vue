<!-- 删除_气泡确认框 -->
<script setup lang="ts">
import {defineOptions} from "vue";
import {DeleteOutlined} from "@ant-design/icons-vue";

defineOptions({
  name: "DeletePopconfirm",
});
</script>

<template>
  <i-popconfirm
    title="确定删除选中记录？"
    ok-type="primary"
    :ok-button-props="{danger: true}"
    type="primary"
    :button-props="{danger: true}"
    v-bind="$attrs"
  >
    <template #icon>
      <delete-outlined/>
    </template>
  </i-popconfirm>
</template>
