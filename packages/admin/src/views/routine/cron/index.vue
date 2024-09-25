<script setup lang="ts">
import {findById, list, remove, status, upsert} from "@/api/routine/cron/cron";
import TableSettings from "@/utils/tableSettings";
import {CronCycleType, CronCycleTypeName, CronType, CronTypeName, Week, WeekCycleName} from "@pirate/shared";
import {computed, ref} from "vue";
import {mapEnumToOptions} from "@/utils/common";
import {message, Modal} from "ant-design-vue";
import {useI18n} from "vue-i18n";
import CronDetail from "./components/detail.vue";

const {t} = useI18n()

const detailRef = ref(null);

const typeOptions = computed(() => mapEnumToOptions(CronType, CronTypeName))
const cycleOptions = computed(() => mapEnumToOptions(CronCycleType, CronCycleTypeName))
const weekOptions = computed(() => mapEnumToOptions(Week, WeekCycleName))

const tableSettings = new TableSettings({
  api: {
    find: list,
    findById: findById,
    delete: remove,
    upsert: upsert,
  },
  table: {
    operations: ["refresh", "create", "delete", "row-detail", "row-delete"],
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
        customRender: ({text}) => CronTypeName[text],
        search: true,
        form: true,
        type: 'select',
        options: typeOptions,
        formSpan: 12,
        formItemConfig: {
          wrapperCol: {span: 8}
        },
        detail: true,
        detailRender: (text) => CronTypeName[text]
      },
      {
        title: "任务名称",
        dataIndex: "name",
        minWidth: 200,
        search: true,
        form: true,
        formSpan: 12,
        formItemConfig: {
          wrapperCol: {span: 8}
        },
        detail: true,
      },
      {
        title: "执行周期",
        dataIndex: "cycleName",
        minWidth: 200,
        form: true,
        detail: true,
      },
      {
        title: "状态",
        dataIndex: "status",
        align: 'center',
        width: 60,
        detail: true,
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
    },
    fields: {
      cycleType: 'day'
    }
  },
  detail: {
    modal: {
      width: 960,
      onOpenAfter: (id: number) => {
        detailRef.value?.onOpenAfter(id)
      },
      onCloseAfter: () => {
        detailRef.value?.onCloseAfter()
      }
    },
    descriptionsConfig: {}
  }
});

const handleStatusChange = (record) => {
  Modal.confirm({
    type: 'warning',
    title: t(record.status === 1
      ? "routine.cron.title['Once the scheduled task is paused, it will not continue running. Are you sure you want to disable this scheduled task?']"
      : "routine.cron.title['This scheduled task is disabled. Do you want to enable this scheduled task?']"
    ),
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
    <template #detail-status="{value}">
      <status-tag :value="value" class="cursor-pointer"/>
    </template>

    <template #form-cycleName="{fields}">
      <a-space>
        <a-form-item-rest>
          <a-select
            v-model:value="fields.cycleType"
            placeholder="执行周期"
            class="min-w-[100px]"
            :options="cycleOptions"
          />
        </a-form-item-rest>
        <a-form-item-rest v-if="fields.cycleType === 'week'">
          <a-select
            v-model:value="fields.week"
            placeholder="周"
            class="min-w-[80px]"
            :options="weekOptions"
          />
        </a-form-item-rest>
        <a-form-item-rest v-if="['day-n','month'].includes(fields.cycleType)">
          <a-input-number
            v-model:value="fields.day"
            placeholder="天"
            class="w-[110px]"
            :min="0"
            :max="31"
            :precision="0"
          >
            <template #addonAfter>天</template>
          </a-input-number>
        </a-form-item-rest>
        <a-form-item-rest v-if="['day','day-n','hour-n','week','month'].includes(fields.cycleType)">
          <a-input-number
            v-model:value="fields.hour"
            placeholder="小时"
            class="w-[110px]"
            :min="0"
            :max="24"
            :precision="0"
          >
            <template #addonAfter>小时</template>
          </a-input-number>
        </a-form-item-rest>
        <a-form-item-rest>
          <a-input-number
            v-model:value="fields.minute"
            placeholder="分钟"
            class="w-[110px]"
            :min="0"
            :max="60"
            :precision="0"
          >
            <template #addonAfter>分钟</template>
          </a-input-number>
        </a-form-item-rest>
      </a-space>
    </template>

    <template #detailAfter="{fields}">
      <cron-detail ref="detailRef" :fields="fields"/>
    </template>
  </i-crud>
</template>
