<!-- 菜单规则管理 -->
<script setup lang="ts">
import * as antIcons from "@ant-design/icons-vue";
import {provide, watch} from "vue";
import {treeForEach} from "@/utils/tree";
import {notification} from "ant-design-vue";
import {useI18n} from "vue-i18n";
import type {AdminMenuDataSource} from "@/store/auth/menu/types";
import TableSettings, {tableSettingKey} from "@/utils/tableSettings";
import {AdminRoleFields, AdminRoleTableSettingsType} from "@/views/auth/group/types";

import {findById, list, remove, sortable, status, upsert} from '@/api/auth/permission'

const {t} = useI18n()

const tableSettings: AdminRoleTableSettingsType = new TableSettings({
  api: {
    find: list,
    findById: findById,
    delete: remove,
    upsert: upsert,
    sortable: sortable
  },
  table: {
    operations: [
      "refresh",
      "create",
      "delete",
      "expand",
      'row-sortable',
      "row-update",
      "row-delete",
    ],
    columns: [
      {
        title: '上级菜单',
        dataIndex: 'parentId',
        sort: 0,
        hide: true,
        form: true,
        type: 'tree-select',
        formFieldConfig: {
          fieldNames: {
            label: 'title',
            value: 'id'
          },
          treeDefaultExpandAll: true,
          treeNodeFilterProp: "title"
        },
        options: (dataSource: AdminRoleTableSettingsType['table']['dataSource']) => dataSource
      },
      {
        title: "标题",
        dataIndex: "title",
        width: 200,
        sort: 2,
        form: true,
      },
      {
        title: "图标",
        dataIndex: "icon",
        align: "center",
        width: 100,
        form: (fields: AdminRoleFields) => fields.type !== 3,
        sort: 5,
        type: 'icon',
        formFieldConfig: {
          nullOnUnmounted: true
        }
      },
      {
        title: "名称",
        dataIndex: "name",
        width: 150,
        sort: 3,
        form: true,
      },
      {
        title: "路由路径",
        dataIndex: "path",
        sort: 4,
        hide: true,
        form: (fields: AdminRoleFields) => fields.type !== 3,
      },
      {
        title: "菜单项类型",
        dataIndex: "frame",
        sort: 6,
        hide: true,
        form: (fields: AdminRoleFields) => fields.type === 2,
        type: 'radio-button',
        options: [
          {label: '选项卡', value: 1},
          {label: '链接（站外）', value: 2},
          {label: 'iframe', value: 3}
        ],
        formFieldConfig: {
          buttonStyle: "solid"
        }
      },
      {
        title: "组件路径",
        dataIndex: "component",
        width: 200,
        sort: 7,
        form: (fields: AdminRoleFields) => fields.type === 2,
      },
      {
        title: "规则描述",
        dataIndex: "description",
        sort: 8,
        hide: true,
        form: true,
        type: 'textarea'
      },
      {
        title: "排序",
        dataIndex: "sort",
        sort: 9,
        hide: true,
        form: true,
        type: 'input-number'
      },
      {
        title: "类型",
        dataIndex: "type",
        align: "center",
        width: 100,
        sort: 1,
        form: true,
        type: 'radio-button',
        options: [
          {label: '菜单目录', value: 1},
          {label: '菜单项', value: 2},
          {label: '页面按钮', value: 3}
        ],
        formFieldConfig: {
          buttonStyle: "solid"
        }
      },
      {
        title: "缓存",
        dataIndex: "cache",
        align: "center",
        width: 100,
        sort: 10,
        form: true,
        type: 'radio'
      },
      {
        title: "状态",
        dataIndex: "status",
        align: "center",
        width: 100,
        sort: 11,
        form: true,
        type: 'radio'
      },
      {
        title: "修改时间",
        dataIndex: "updateTime",
        align: "center",
        width: 150,
      },
      {
        title: "操作",
        dataIndex: "operation",
        align: "center",
        fixed: "right",
        width: 80,
      },
    ],
    i18nPrefix: "admin_permission",
    // isI18nGlobal: true,
    draggable: true,
    pagination: false,
    defaultExpandAllRows: true,
  },
  form: {
    fields: {
      parentId: undefined,
      id: undefined,
      path: undefined,
      description: undefined,
      name: undefined,
      title: undefined,
      component: undefined,
      icon: undefined,
      type: 2,
      status: 1,
      cache: 0,
      frame: 1,
      sort: 0,
    },
    rules: {
      title: [{required: true, message: t('admin_permission.error.title')}],
      name: [{required: true, message: t('admin_permission.error.name')}],
      path: [{required: true, message: t('admin_permission.error.path')}],
    }
  },
  modal: {
    width: '600px'
  }
});

provide(tableSettingKey, tableSettings);

watch(
  () => tableSettings.form.fields?.type,
  (type) => {
    tableSettings.form.rules!.path = [{required: type !== 3, message: t('admin_permission.error.path')}]
  }
)

// 修改状态
const handleStatusChange = async (record: AdminMenuDataSource) => {
  const ids: (number | undefined)[] = [];
  treeForEach([record], (item: AdminMenuDataSource) => {
    ids.push(item.id);
    item.status = record.status
  })
  const params = {
    status: record.status,
    ids: ids
  }
  console.log('handleStatusChange', ids, params);
  await status(params);
  notification.success({
    message: t("message.success"),
    description: t("success.update"),
  })
}
</script>

<template>
  <i-crud>
    <template #icon="{value}">
      <component v-if="value" :is="antIcons[value]" class="text-[18px]"/>
    </template>
    <template #type="{ value }">
      <rule-type-tag :value="value"/>
    </template>
    <template #cache="{ record }">
      <a-switch
        v-model:checked="record.cache"
        :checkedValue="1"
        :unCheckedValue="0"
      />
    </template>
    <template #status="{record}">
      <a-switch
        v-model:checked="record.status"
        :checkedValue="1"
        :unCheckedValue="0"
        @click="handleStatusChange(record)"
      />
    </template>
  </i-crud>
</template>

