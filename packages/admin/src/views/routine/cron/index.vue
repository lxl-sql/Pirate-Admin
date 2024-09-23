<script setup lang="ts">
import {findById, list, remove, status, upsert} from "@/api/routine/cron";
import TableSettings from "@/utils/tableSettings";
import {CronType, CronTypeName} from "@pirate/shared";
import {computed} from "vue";
import {mapEnumToOptions} from "@/utils/common";
import {message, Modal} from "ant-design-vue";
import {useI18n} from "vue-i18n";

const {t} = useI18n()

const typeOptions = computed(() => mapEnumToOptions(CronType, CronTypeName))

const tableSettings = new TableSettings({
  api: {
    find: list,
    findById: findById,
    delete: remove,
    upsert: upsert,
  },
  table: {
    operations: ["refresh", "create", "delete", "row-delete", "row-delete"],
    columns: [
      {
        title: "#",
        dataIndex: "number",
        align: "center",
        width: 60,
      },
      {
        title: "任务类型",
        dataIndex: "type",
        align: 'center',
        width: 100,
        customRender: ({text}) => {
          return CronTypeName[text];
        },
        search: true,
        form: true,
        type: 'select',
        options: typeOptions,
        formSpan: 12,
      },
      {
        title: "任务名称",
        dataIndex: "name",
        minWidth: 200,
        search: true,
        form: true,
        formSpan: 12,
      },
      {
        title: "执行周期",
        dataIndex: "cycleName",
        minWidth: 200,
      },
      {
        title: "状态",
        dataIndex: "status",
        align: 'center',
        width: 60,
      },
      {
        title: "上次执行时间",
        dataIndex: "lastExecutionTime",
        align: 'center',
        width: 150,
      },
      {
        title: "操作",
        dataIndex: "operation",
        align: "center",
        fixed: "right",
        width: 60,
      },
    ],
    i18nPrefix: "routine.cron",
    isI18nGlobal: true,
  },
  form: {
    modal: {
      width: 960
    }
  }
});

const handleStatusChange = (record) => {
  Modal.confirm({
    type: 'warning',
    title: t("routine.cron.title['Once the scheduled task is paused, it will not continue running. Are you sure you want to disable this scheduled task?']"),
    async onOk() {
      console.log('record', record)
      const params = {
        ids: [record.id],
        status: record.status === 0 ? 1 : 0
      }
      await status(params);
      message.success('操作成功');
      await tableSettings.queryAll();
    },
  })
}

defineOptions({
  name: "Cron",
});
</script>

<template>
  <i-crud :setting="tableSettings">
    <template #status="{text,record}">
      <status-tag :value="text" class="cursor-pointer" @click="handleStatusChange(record)"/>
    </template>
  </i-crud>
</template>

<style scoped lang="less"></style>
