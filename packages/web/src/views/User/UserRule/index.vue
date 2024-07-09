<!-- 会员规则管理 -->
<script setup lang="ts">
import * as antIcons from "@ant-design/icons-vue";
import {DeleteOutlined, DragOutlined, EditOutlined, PlusOutlined} from "@ant-design/icons-vue";
import {defineAsyncComponent, onMounted, ref, unref,} from "vue";
import type {IColumns, IPages} from "@/types";

const AddEditModal = defineAsyncComponent(
    () => import("./components/AddEditModal/index.vue")
);

interface IDataSource {
  key: string;
  menuname?: string;
  name?: string;
  age?: number;
  address?: string;
  ruleType?: string | number; // 1 菜单目录 2 菜单项 3 页面按钮
  status?: string | number; // 状态 0 禁用 1 启用
  updatetime?: string; // 修改时间
  createTime?: string; // 创建时间
  isDeleteVisible?: boolean; // 是否显示删除气泡
  children?: IDataSource[]; // 设置 children 务必设置 width 否则可能出现宽度浮动
}

//#region 变量
const columns = ref<IColumns[]>([
  {
    title: "规则标题",
    dataIndex: "title",
    align: "center",
    minWidth: 200,
  },
  {
    title: "规则图标",
    dataIndex: "icon",
    align: "center",
    minWidth: 100,
  },
  {
    title: "规则名称",
    dataIndex: "menuname",
    align: "center",
    minWidth: 100,
  },
  {
    title: "规则类型",
    dataIndex: "ruletype",
    align: "center",
    minWidth: 100,
  },
  {
    title: "状态",
    dataIndex: "status",
    align: "center",
    minWidth: 100,
  },
  {
    title: "修改时间",
    dataIndex: "updatetime",
    align: "center",
    minWidth: 180,
  },
  {
    title: "创建时间",
    dataIndex: "updatetime",
    align: "center",
    minWidth: 100,
  },
  {
    title: "操作",
    dataIndex: "operate",
    align: "center",
    fixed: "right",
    minWidth: 100,
  },
]);
const dataSource = ref<IDataSource[]>([
  {
    key: "1",
    menuname: "胡彦斌",
    age: 32,
    address: "西湖区湖底公园1号",
    ruleType: 1,
    children: [
      {
        key: "1-1",
        menuname: "胡彦祖1",
        age: 22,
        address: "西湖区湖底公园1号",
        children: [
          {
            key: "1-1-1",
            name: "胡彦祖1",
            age: 22,
            address: "西湖区湖底公园1号",
            children: [
              {
                key: "12",
                name: "胡彦祖1",
                age: 22,
                address: "西湖区湖底公园1号",
                children: [
                  {
                    key: "1-1-2",
                    name: "胡彦祖1",
                    age: 22,
                    address: "西湖区湖底公园1号",
                  },
                ],
              },
            ],
          },
        ],
      },
    ],
  },
]);
const selectedRowKeys = ref<IDataSource["key"][]>([]);
const pages = ref<IPages>({
  size: 10,
  page: 1,
  total: 0,
});
const isEdit = ref<boolean>(false); // 是否编辑
const isDeleteAllVisible = ref<boolean>(false);
const isExpandAllRows = ref<boolean>(false);
const isTableLoading = ref<boolean>(false); // 表格加载状态
const isAddEditModal = ref<boolean>(false);
//#endregion

onMounted(() => {
  init();
});

const init = () => {
  dataSource.value = unref(dataSource).map((item) => {
    item.isDeleteVisible = false;
    return item;
  });
};

// 添加
const handleAddEdit = (type: number) => {
  isEdit.value = type === 1;
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
  record.isDeleteVisible = false;
};

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
const onSelectChange = (rowKeys: IDataSource["key"][]) => {
  selectedRowKeys.value = rowKeys;
  console.log(rowKeys, "rowKeys");
};

// 规则类型
const ruleTypeStatus = (type: IDataSource["ruleType"]) => {
  const maps = new Map();
  maps.set(1, {
    color: "success",
    name: "菜单目录",
  });
  maps.set(2, {
    color: "error",
    name: "菜单项",
  });
  maps.set(3, {
    color: "processing",
    name: "页面按钮",
  });
  if (maps.has(type)) {
    return maps.get(type);
  } else {
    return {
      color: "error",
      name: "暂无数据",
    };
  }
};
</script>

<template>
  <div class="default-main">
    <i-table
        :columns="columns"
        :dataSource="dataSource"
        :pages="pages"
        isSelectedRowKeys
        :isExpandAllRows="isExpandAllRows"
        :loading="isTableLoading"
        @pagesChange="onPagesChange"
        @selectChange="onSelectChange"
    >
      <template #leftBtn>
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
                    type="danger"
                    size="small"
                    @click="onDeleteAllConfirm"
                >
                  删除
                </a-button>
              </template>
              <a-button type="danger" :disabled="!selectedRowKeys.length">
                <template #icon>
                  <delete-outlined/>
                </template>
                删除
              </a-button>
            </a-popconfirm>
          </template>
        </i-tooltip>
        <i-tooltip
            :title="isExpandAllRows ? '收缩所有子菜单' : '展开所有子菜单'"
            :content="isExpandAllRows ? '收缩所有' : '展开所有'"
            :type="isExpandAllRows ? 'danger' : 'warning'"
            @click="isExpandAllRows = !isExpandAllRows"
        >
        </i-tooltip>
      </template>

      <template #icon="{ record }">
        <component :is="antIcons[record.icon]" style="font-size: 18px"/>
      </template>
      <template #ruletype="{ record }">
        <a-tag :color="ruleTypeStatus(record.ruleType).color">
          {{ ruleTypeStatus(record.ruleType).name }}
        </a-tag>
      </template>
      <template #status="{ record }">
        <a-switch
            v-model:checked="record.status"
            :checkedValue="1"
            :unCheckedValue="0"
        />
      </template>
      <template #operate="{ record }">
        <a-space>
          <i-tooltip title="移动" size="small" type="move">
            <template #icon>
              <drag-outlined/>
            </template>
          </i-tooltip>
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
                  cancel-text="取消"
                  placement="left"
                  v-model:open="record.isDeleteVisible"
              >
                <template #okButton>
                  <a-button
                      type="danger"
                      size="small"
                      @click="onDeleteCurrentConfirm(record)"
                  >
                    删除
                  </a-button>
                </template>
                <a-button type="danger" size="small">
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
        :open="isAddEditModal"
        :title="isEdit ? '编辑' : '添加'"
        @cancel="onAddEditCancel"
        @confirm="onAddEditConfirm"
    />
  </div>
</template>

<style lang="less" scoped>
@import "./index.less";
</style>
