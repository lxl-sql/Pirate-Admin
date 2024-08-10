<!-- 管理员日志管理 -->
<script setup lang="ts">
import {ClearOutlined, SendOutlined,} from "@ant-design/icons-vue";
import {provide} from "vue";
import TableSettings, {tableSettingKey} from "@/utils/tableSettings";
import {findById, list, remove} from "@/api/auth/log";
import {formatTime} from "@/utils/common";
import CodeSegment from "@/components/CodeSegment/index.vue";
import {Modal} from "ant-design-vue";
import {useI18n} from "vue-i18n";

const {t} = useI18n()

const toUrl = (url: string) => {
  window.open(url);
};

const tableSettings: any = new TableSettings({
  api: {
    find: list,
    findById: findById,
    delete: remove
  },
  table: {
    operations: [
      "refresh",
      "row-detail"
    ],
    columns: [
      {
        title: "管理员ID",
        dataIndex: "userId",
        align: "center",
        width: 100,
        fixed: 'left',
        search: true,
      },
      {
        title: "管理员用户名",
        dataIndex: "username",
        align: "center",
        width: 120,
        fixed: 'left',
        detail: true,
        detailSort: 1,
      },
      {
        title: "标题",
        dataIndex: "title",
        align: "center",
        width: 120,
        detail: true,
        detailSort: 0,
      },
      {
        title: "URL",
        dataIndex: "url",
        align: "center",
        width: 200,
        detail: true,
        detailSort: 7,
        detailSpan: 2,
        detailSlot: false,
      },
      {
        title: "IP",
        dataIndex: "ip",
        align: "center",
        width: 120,
        detail: true,
        detailSort: 4,
      },
      {
        title: "IP属地",
        dataIndex: "ipAddress",
        align: "center",
        width: 120,
        detail: true,
        detailSort: 5,
      },
      {
        title: "请求方式",
        dataIndex: "method",
        align: "center",
        width: 100,
        detail: true,
        detailSort: 2,
      },
      {
        title: "UserAgent",
        dataIndex: "userAgent",
        align: "center",
        width: 200,
        ellipsis: true,
        detail: true,
        detailSort: 8,
        detailSpan: 2,
        customCell() {
          return {
            style: {
              maxWidth: '200px'
            }
          }
        }
      },
      {
        title: "创建时间",
        dataIndex: "createTime",
        align: "center",
        width: 150,
        detail: true,
        detailSort: 9,
        detailSpan: 2,
      },
      {
        title: "状态码",
        dataIndex: "status",
        hide: true,
        detail: true,
        detailSort: 3,
      },
      {
        title: "响应时间",
        dataIndex: "responseTime",
        hide: true,
        detail: true,
        detailSort: 6,
        detailRender: (value: number) => formatTime(value),
      },
      {
        title: "请求数据",
        dataIndex: "params",
        hide: true,
        detail: true,
        detailSort: 10,
        detailSpan: 2,
      },
      {
        title: "操作",
        dataIndex: "operation",
        align: "center",
        fixed: "right",
        width: 40,
      },
    ],
    i18nPrefix: "admin_log",
    isI18nGlobal: true,
    scroll: {x: true},
    displayFormModal: false,
    rowSelection: null
  },
  detail: {
    modal: {
      width: '1080px'
    }
  }
});

/**
 * 清空日志
 */
const handleRemoveAll = () => {
  Modal.confirm({
    type: 'warning',
    title: t("title.Risk Operation"),
    content: t("content['After clearing the logs, past operation records will not be retrievable. Do you want to proceed?']"),
    async onOk() {
      await tableSettings.deleteByIds('delete', [0])
    }
  })
}
</script>

<template>
  <i-crud :setting="tableSettings">
    <template #afterLeftAction>
      <a-button type="primary" danger @click="handleRemoveAll">
        <template #icon>
          <clear-outlined/>
        </template>
        {{ $t('title.clear') }}
      </a-button>
      <div class="flex items-center">
        <span class="mr-2">日志保留天数</span>
        <a-input-number/>
      </div>
    </template>
    <template #url="{ value }">
      <a-input-group compact class="!flex">
        <a-input
          :value="value"
          readonly
          class="!text-left"
        >
        </a-input>
        <a-button @click="toUrl(value)">
          <template #icon>
            <send-outlined/>
          </template>
        </a-button>
      </a-input-group>
    </template>
    <template #ip="{ value }">
      <a-tag color="processing" class="last-of-type:mr-0">{{ value }}</a-tag>
    </template>
    <template #ipAddress="{ value }">
      <a-tag v-if="value" color="processing" class="last-of-type:mr-0">{{ value }}</a-tag>
    </template>
    <template #method="{ value }">
      <method-tag :method="value"/>
    </template>
    <template #detail-params="{ value }">
      <code-segment :text="value"/>
    </template>
    <template #detail-ip="{ value }">
      <a-tag color="processing" class="last-of-type:mr-0">{{ value }}</a-tag>
    </template>
    <template #detail-ipAddress="{ value }">
      <a-tag v-if="value" color="processing" class="last-of-type:mr-0">{{ value }}</a-tag>
    </template>
    <template #detail-method="{ value }">
      <method-tag :method="value"/>
    </template>
  </i-crud>
</template>
