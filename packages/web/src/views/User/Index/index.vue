<!-- 用户列表 -->
<script setup lang="ts">
import {DeleteOutlined, EditOutlined, PlusOutlined, UserOutlined} from "@ant-design/icons-vue";
import {computed, onMounted, ref} from "vue";
import {IColumns, IPages} from "@/types";
import {IDataSource} from "./types";
import {getUserList} from "@/api/user";
import FormModal from "./components/FormModal/index.vue";
import {sortNumber} from "@/utils/common";

const columns = ref<IColumns[]>([
  {
    title: "序号",
    dataIndex: "number",
    isI18n: true,
    align: "center",
    minWidth: 80,
    customRender: ({index}) => sortNumber(index, pages.value),
  },
  {
    title: "用户名",
    dataIndex: "username",
    isI18n: true,
    align: "center",
    minWidth: 100,
  },
  {
    title: "昵称",
    dataIndex: "nickname",
    isI18n: true,
    align: "center",
    minWidth: 100,
  },
  {
    title: "角色",
    dataIndex: "roles",
    isI18n: true,
    align: "center",
    minWidth: 100,
  },
  {
    title: "头像",
    dataIndex: "avatar",
    isI18n: true,
    align: "center",
    minWidth: 100,
  },
  {
    title: "性别",
    dataIndex: "gender",
    isI18n: true,
    align: "center",
    minWidth: 100,
  },
  {
    title: "邮箱",
    dataIndex: "email",
    isI18n: true,
    align: "center",
    minWidth: 100,
  },
  {
    title: "手机号",
    dataIndex: "phone",
    isI18n: true,
    align: "center",
    minWidth: 100,
  },
  {
    title: "最后登录IP",
    dataIndex: "lastLoginIp",
    isI18n: true,
    align: "center",
    minWidth: 140,
  },
  {
    title: "最后登录时间",
    dataIndex: "lastLoginTime",
    isI18n: true,
    align: "center",
    minWidth: 180,
  },
  {
    title: "状态",
    dataIndex: "status",
    isI18n: true,
    align: "center",
    minWidth: 100,
  },
  {
    title: "创建时间",
    dataIndex: "createTime",
    isI18n: true,
    align: "center",
    minWidth: 180,
  },
  {
    title: "操作",
    dataIndex: "operation",
    isI18n: true,
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
const isEdit = ref<boolean>(false); // 是否编辑
const isTableLoading = ref<boolean>(false); // 表格加载状态
const isAddOrEditModalVisible = ref<boolean>(false);

onMounted(async () => {
  await getList();
});

const getList = async () => {
  const params = {
    page: pages.value.page,
    size: pages.value.size,
  };
  isTableLoading.value = true;
  try {
    const {data} = await getUserList(params);
    console.log(data, "data");
    dataSource.value = data.records

    pages.value = {
      size: data.size,
      page: data.page,
      total: data.total,
    };
  } finally {
    isTableLoading.value = false;
  }
};

// 添加
const handleAddEdit = (type: number) => {
  isEdit.value = type === 1;
  isAddOrEditModalVisible.value = true;
};
// 添加/编辑 - cancel
const onAddEditCancel = () => {
  isAddOrEditModalVisible.value = false;
};
// 添加/编辑 - confirm
const onAddEditConfirm = () => {
  onAddEditCancel();
};

// 删除-确定
const onDeleteAllConfirm = async () => {
};

// 删除-取消
const onDeleteAllCancel = () => {
};
// 删除当前行-确定
const handleDeleteRecordConfirm = (record: IDataSource) => {
  console.log(record, "record");
  record.isDeleteVisible = false;
};

// 分页
const onPagesChange = (value: IPages) => {
  pages.value = value;
};

// 多选
const onSelectChange = (rowKeys: string[]) => {
  selectedRowKeys.value = rowKeys;
  console.log(rowKeys, "rowKeys");
};

const rowSelection = computed(() => {
  return {
    selectedRowKeys: selectedRowKeys.value, // 指定选中项的 key 数组，需要和 onChange 进行配合
    onChange: onSelectChange, // 选中项发生变化时的回调
    hideDefaultSelections: true, // 去掉『全选』『反选』两个默认选项
    fixed: true, // 把选择框列固定在左边
  };
});

</script>

<template>
  <div class="default-main">
    <i-table
        row-key="id"
        i18n-prefix="user"
        :columns="columns"
        :data-source="dataSource"
        :pages="pages"
        :loading="isTableLoading"
        :row-selection="rowSelection"
        @reload="getList"
        @pagesChange="onPagesChange"
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
                placement="right"
                cancel-text="取消"
                ok-text="删除"
                :ok-button-props="{danger:true,loading: false}"
                @cancel="onDeleteAllCancel"
                @confirm="onDeleteAllConfirm"
            >
              <a-button type="primary" danger :disabled="!selectedRowKeys.length">
                <template #icon>
                  <delete-outlined/>
                </template>
                删除
              </a-button>
            </a-popconfirm>
          </template>
        </i-tooltip>
      </template>
      <template #roles="{ value }">
        <a-tag v-for="text in value" :key="value" color="processing" class="table-tag">
          {{ text }}
        </a-tag>
      </template>
      <template #gender="{ value }">
        <a-tag color="success" class="table-tag">
          {{ $t(`user.table.enum.gender.${value}`) }}
        </a-tag>
      </template>
      <template #lastLoginIp="{value}">
        <a-tag v-if="value" color="processing" class="table-tag">
          {{ value }}
        </a-tag>
      </template>
      <template #status="{ value }">
        <a-tag
            :color="value === 1 ? 'success' : 'error'"
            class="table-tag"
        >
          {{ $t(`user.table.enum.status.${value}`) }}
        </a-tag>
      </template>
      <template #avatar="{ value }">
        <a-avatar size="large" :src="value">
          <template #icon>
            <user-outlined/>
          </template>
        </a-avatar>
      </template>
      <template #menuname="{ value }">
        <span v-if="value">{{ value }}</span>
        <a-input v-else placeholder="请输入名称"/>
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
                  @confirm="handleDeleteRecordConfirm(record)"
              >
                <a-button type="primary" danger size="small">
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

    <form-modal
        v-model:open="isAddOrEditModalVisible"
        :title="isEdit ? '编辑' : '添加'"
        @cancel="onAddEditCancel"
        @confirm="onAddEditConfirm"
    />
  </div>
</template>

<style lang="less" scoped>
@import "./index.less";
</style>
