<!-- 会员分组管理 -->
<script setup lang="ts">
import {DeleteOutlined, EditOutlined, PlusOutlined,} from "@ant-design/icons-vue";
import {onMounted, ref, unref} from "vue";
import AddEditModal from "./components/AddEditModal/index.vue";
import {IColumns, IPages} from "@/types";
import {getRoleList} from "@/api/user";
import ITooltip from "@/components/IComponents/ITooltip/index.vue";

interface IDataSource {
  key: string;
  name: string;
  age: number;
  address: string;
  status?: string | number; // 状态 0 禁用 1 启用
  updateTime?: string; // 修改时间
  createTime?: string; // 创建时间
  children?: IDataSource[]; // 设置 children 务必设置 width 否则可能出现宽度浮动
}

const columns = ref<IColumns[]>([
  {
    title: "角色名称",
    dataIndex: "name",
    minWidth: 200,
  },
  {
    title: "角色标识",
    dataIndex: "slug",
    align: "center",
    minWidth: 100,
  },
  {
    title: "描述",
    dataIndex: "description",
    minWidth: 300,
  },
  {
    title: "状态",
    dataIndex: "status",
    align: "center",
    minWidth: 80,
  },
  {
    title: "修改时间",
    dataIndex: "updateTime",
    align: "center",
    minWidth: 150,
  },
  {
    title: "创建时间",
    dataIndex: "createTime",
    align: "center",
    minWidth: 150,
  },
  {
    title: "排序",
    dataIndex: "sort",
    minWidth: 100,
  },
  {
    title: "操作",
    dataIndex: "operation",
    align: "center",
    fixed: "right",
    minWidth: 100,
  },
]);

const dataSource = ref<IDataSource[]>([]);
const selectedRowKeys = ref<IDataSource["key"][]>([]);
const pages = ref<IPages>({
  size: 10,
  page: 1,
  total: 0,
});
const isDeleteAllVisible = ref<boolean>(false);
const defaultExpandAllRows = ref<boolean>(false);
const isTableLoading = ref<boolean>(false); // 表格加载状态
const isAddEditModal = ref<boolean>(false);

onMounted(async () => {
  await getList()
});

const getList = async () => {
  const params = {}
  isTableLoading.value = true;
  try {
    const {data} = await getRoleList(params)
    dataSource.value = data
    defaultExpandAllRows.value = true
  } finally {
    isTableLoading.value = false;
  }
}

// 添加
const handleAddEdit = (type: number) => {
  isAddEditModal.value = true;
};
// 添加/编辑 - cancel
const onAddEditCancel = () => {
  isAddEditModal.value = false;
};
// 添加/编辑 - confirm
const onAddEditConfirm = () => {
  onAddEditCancel();
};

// 删除-确定
const onDeleteAllConfirm = () => {
  isDeleteAllVisible.value = false;
};

// 删除-取消
const onDeleteAllCancel = () => {
  isDeleteAllVisible.value = false;
};

// 删除-显示隐藏的回调
const onDeleteVisibleChange = () => {
  // selectedRowKeys没有选中时 默认禁用 删除按钮
  if (!unref(selectedRowKeys).length) {
    isDeleteAllVisible.value = false;
  }
};
// 删除当前行-确定
const onDeleteCurrentConfirm = (record: IDataSource) => {
  console.log(record, "record");
};

// 多选
const onSelectChange = (rowKeys: string[]) => {
  selectedRowKeys.value = rowKeys;
  console.log(rowKeys, "rowKeys");
};
</script>

<template>
  <div class="default-main">
    <i-table
        row-key="id"
        :columns="columns"
        :data-source="dataSource"
        :loading="isTableLoading"
        :pagination="false"
        :default-expand-all-rows="defaultExpandAllRows"
        @reload="getList"
        @selectChange="onSelectChange"
    >
      <template #leftActions>
        <i-tooltip title="添加" content="添加" @click="handleAddEdit(0)">
          <template #icon>
            <plus-outlined/>
          </template>
        </i-tooltip>
        <i-tooltip title="删除选中行">
          <template #content>
            <a-popconfirm
                title="确定删除选中记录？"
                ok-text="删除"
                cancel-text="取消"
                @cancel="onDeleteAllCancel"
                @visibleChange="onDeleteVisibleChange"
                v-model:open="isDeleteAllVisible"
            >
              <template #okButton>
                <a-button
                    type="primary"
                    danger
                    size="small"
                    @click="onDeleteAllConfirm"
                >
                  删除
                </a-button>
              </template>
              <a-button
                  type="primary"
                  danger
                  :disabled="!selectedRowKeys.length"
              >
                <template #icon>
                  <delete-outlined/>
                </template>
                删除
              </a-button>
            </a-popconfirm>
          </template>
        </i-tooltip>
        <expand-all-rows-tooltip v-model:expand="defaultExpandAllRows"/>
      </template>
      <template #status="{ record }">
        <a-tag v-if="record.status >= 0" :color="record.status === 1 ? 'success' : 'error'">
          {{ record.status === 1 ? "启用" : "禁用" }}
        </a-tag>
      </template>
      <template #operation="{ record }">
        <a-space>
          <i-tooltip title="编辑" size="small" @click="handleAddEdit(1)">
            <template #icon>
              <edit-outlined/>
            </template>
          </i-tooltip>
          <i-tooltip title="删除">
            <template #content>
              <a-popconfirm
                  title="确定删除选中记录？"
                  ok-text="删除"
                  ok-type="primary"
                  :ok-button-props="{danger:true}"
                  cancel-text="取消"
                  placement="left"
                  @confirm="onDeleteCurrentConfirm(record)"
              >
                <a-button
                    type="primary"
                    danger
                    size="small"
                >
                  <template #icon>
                    <delete-outlined/>
                  </template>
                </a-button>
              </a-popconfirm>
            </template>
          </i-tooltip>
        </a-space>
      </template>
    </i-table>
    <add-edit-modal
        v-model:open="isAddEditModal"
        @cancel="onAddEditCancel"
        @confirm="onAddEditConfirm"
    />
  </div>
</template>

<style lang="less" scoped>
@import "./index.less";
</style>
