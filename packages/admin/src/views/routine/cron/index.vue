<script setup lang="ts">
import { list, findById } from "@/api/routine/cron";
import TableSettings from "@/utils/tableSettings";

const tableSettings = new TableSettings({
  api: {
    find: list,
    findById: findById,
    // delete: remove,
    // upsert: upsert,
  },
  table: {
    operations: ["refresh", "create", "delete", "row-delete", "row-delete"],
    columns: [
      {
        title: "#",
        dataIndex: "number",
        align: "center",
        width: 80,
      },
      {
        title: "任务名称",
        dataIndex: "name",
      },
      {
        title: "任务类型",
        dataIndex: "type",
      },
      {
        title: "执行周期",
        dataIndex: "cycleName",
      },
      {
        title: "状态",
        dataIndex: "status",
      },
      {
        title: "上次执行时间",
        dataIndex: "lastExecutionTime",
      },
      {
        title: "操作",
        dataIndex: "operation",
        align: "center",
        fixed: "right",
        width: 60,
      },
    ],
  },
});

defineOptions({
  name: "Cron",
});
</script>

<template>
  <i-crud :setting="tableSettings">
    <template #status="{ value }">
      <status-tag :value="value" />
    </template>
  </i-crud>
</template>

<style scoped lang="less"></style>
