<!-- 管理员日志管理 -->
<script setup lang="ts">
import {SendOutlined,} from "@ant-design/icons-vue";
import {provide, ref} from "vue";
import TableSettings, {tableSettingKey} from "@/utils/tableSettings";
import {getAdminLogById, getAdminLogList} from "@/api/auth/adminLog";
import {formatTime} from "@/utils/common";
import CodeSegment from "@/components/CodeSegment/index.vue";

const avatarPreviewSrc = ref("");
const isAvatarPreviewSrc = ref<boolean>(false);

const toUrl = (url: string) => {
  window.open(url);
};


const tableSettings: any = new TableSettings({
  api: {
    find: getAdminLogList,
    findById: getAdminLogById,
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
        detailSort: 6,
        detailSpan: 2,
        detailSlot: false,
      },
      {
        title: "IP",
        dataIndex: "ip",
        align: "center",
        width: 120,
        detail: true,
        detailSort: 3,
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
        detailSort: 7,
        detailSpan: 2,
      },
      {
        title: "创建时间",
        dataIndex: "createTime",
        align: "center",
        width: 150,
        detail: true,
        detailSort: 8,
        detailSpan: 2,
      },
      {
        title: "状态码",
        dataIndex: "status",
        hide: true,
        detail: true,
        detailSort: 4,
      },
      {
        title: "响应时间",
        dataIndex: "responseTime",
        hide: true,
        detail: true,
        detailSort: 5,
        detailRender: (value: number) => formatTime(value),
      },
      {
        title: "请求数据",
        dataIndex: "params",
        hide: true,
        detail: true,
        detailSort: 9,
        detailSpan: 2,
      },
      {
        title: "操作",
        dataIndex: "operation",
        align: "center",
        fixed: "right",
        width: 80,
      },
    ],
    i18nPrefix: "admin_log",
    isI18nGlobal: true,
    scroll: {x: true},
    displayFormModal: false,
  },
  detail: {
    modal: {
      width: '1080px'
    }
  }
});

provide(tableSettingKey, tableSettings);
</script>

<template>
  <custom-table>
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
      <a-tag color="processing">{{ value }}</a-tag>
    </template>
    <template #method="{ value }">
      <method-tag :method="value"/>
    </template>
    <template #detail-params="{ value }">
      <code-segment :text="value"/>
    </template>
    <template #detail-ip="{ value }">
      <a-tag color="processing">{{ value }}</a-tag>
    </template>
    <template #detail-method="{ value }">
      <method-tag :method="value"/>
    </template>

    <i-preview-image
      :src="avatarPreviewSrc"
      v-model:open="isAvatarPreviewSrc"
    />
  </custom-table>
</template>
