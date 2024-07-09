<!-- 管理员日志管理 -->
<script setup lang="ts">
import {SendOutlined, ZoomInOutlined,} from "@ant-design/icons-vue";
import {onMounted, ref} from "vue";
import data from "./data.json";
import {IColumns, IPages} from "@/types";

interface IDataSource {
  key?: string | number;
  isDelVisible?: boolean;
  username?: string;
  nickname?: string;
  groups?: string;
  avatar?: string;
  email?: string;
  phone?: string;
  lastlogintime?: string;
  createTime?: string;
  status?: boolean;
}

const columns = ref<IColumns[]>([
  {
    title: "ID",
    dataIndex: "id",
    align: "center",
  },
  {
    title: "管理员ID",
    dataIndex: "adminId",
    align: "center",
    search: true,
  },
  {
    title: "管理员用户名",
    dataIndex: "adminname",
    align: "center",
  },
  {
    title: "标题",
    dataIndex: "title",
    align: "center",
  },
  {
    title: "URL",
    dataIndex: "url",
    align: "center",
    width: 280,
  },
  {
    title: "IP",
    dataIndex: "ip",
    align: "center",
  },
  {
    title: "创建时间",
    dataIndex: "createTime",
    align: "center",
    width: 180,
    minWidth: 180,
  },
  {
    title: "操作",
    dataIndex: "operate",
    align: "center",
    fixed: "right",
    width: 100,
  },
]);
const dataSource = ref<IDataSource[]>(data);
const selectedRowKeys = ref<IDataSource["key"][]>([]);
const pages = ref<IPages>({
  size: 10,
  page: 1,
  total: 0,
});

const avatarPreviewSrc = ref("");
const isEdit = ref<boolean>(false); // 是否编辑
const isDeleteAllVisible = ref<boolean>(false);
const isTableLoading = ref<boolean>(false); // 表格加载状态
const isAvatarPreviewSrc = ref<boolean>(false);

onMounted(() => {
  dataSource.value = dataSource.value.map((item) => {
    item.isDelVisible = false;
    return item;
  });
});

// 分页
const onPagesChange = (records: IPages) => {
  // console.log(records, "records");
  pages.value = records;
};

// 显示与隐藏表头
const onColumnChange = (newColumns: IColumns[]) => {
  columns.value = newColumns;
};
// 多选
const onSelectChange = (rowKeys: string[]) => {
  selectedRowKeys.value = rowKeys;
  console.log(rowKeys, "rowKeys");
};

// 显示预览图片
const openAvatarPreviewImage = (src: string) => {
  isAvatarPreviewSrc.value = true;
  avatarPreviewSrc.value = src;
};

const toUrl = (url: string) => {
  window.open("#" + url);
};
</script>

<template>
  <div class="default-main">
    <i-table
        :columns="columns"
        :data-source="dataSource"
        :pages="pages"
        is-selected-row-keys
        :loading="isTableLoading"
        :scroll="{ x: true }"
        @pages-change="onPagesChange"
        @select-change="onSelectChange"
    >
      <template #url="{ record }">
        <a-input-group compact>
          <a-input
              v-model:value="record.url"
              readonly
              style="width: 200px; text-align: left"
          >
          </a-input>
          <a-button @click="toUrl(record.url)">
            <template #icon>
              <send-outlined/>
            </template>
          </a-button>
        </a-input-group>
      </template>
      <template #ip="{ record }">
        <a-tag color="processing">
          {{ record.ip }}
        </a-tag>
      </template>
      <template #operate="{ record }">
        <a-space>
          <i-tooltip title="查看详情" size="small">
            <template #icon>
              <zoom-in-outlined/>
            </template>
          </i-tooltip>
        </a-space>
      </template>
    </i-table>
    <i-preview-image
        :src="avatarPreviewSrc"
        v-model:open="isAvatarPreviewSrc"
    />
  </div>
</template>

<style lang="less" scoped>
@import "./index.less";
</style>
