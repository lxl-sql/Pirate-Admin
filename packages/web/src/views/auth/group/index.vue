<!-- 角色组管理 -->
<script setup lang="ts">
import {computed, provide, shallowRef} from "vue";
import StatusTag from "@/components/IComponents/IOther/StatusTag/index.vue";
import TableSettings, {tableSettingKey} from "@/utils/tableSettings";
import {adminRoleUpsert, getAdminRoleById, getAdminRoleList, removeAdminRole,} from "@/api/auth/admin";
import {AdminRoleRecordType, AdminRoleTableSettingsType} from "./types";
import {useI18n} from "vue-i18n";
import {useAdminMenuStore} from '@/store'
import {disableTreeByKey, recursive} from "@/utils/common";
import {cloneDeep} from "lodash-es";
import {ModalType} from "@/types/tableSettingsType";

const {t} = useI18n();

const adminMenuSore = useAdminMenuStore()

const parentPermissionIds = shallowRef<number[]>([])

// 初始化菜单权限数据源
const onInit = async () => {
  await adminMenuSore.getAdminMenuListRequest()
}

const formAfterOpen = async (type: ModalType, fields) => {
  // console.log('formBeforeOpen --> fields', fields.parentId)
  if (fields?.parentId) {
    await getAdminRoleByIdAsync(fields.parentId)
  }
}

const getAdminRoleByIdAsync = async (id: number) => {
  const {data} = await getAdminRoleById(id)
  parentPermissionIds.value = data.permissionIds
}

const tableSettings: AdminRoleTableSettingsType = new TableSettings({
  api: {
    find: getAdminRoleList,
    findById: getAdminRoleById,
    delete: removeAdminRole,
    upsert: adminRoleUpsert,
  },
  table: {
    operations: [
      "refresh",
      "create",
      "delete",
      "expand",
      "row-update",
      "row-delete",
    ],
    columns: [
      {
        title: "上级分组",
        dataIndex: "parentId",
        type: "tree-select",
        form: true,
        hide: true,
        options: (dataSource: AdminRoleRecordType[], fields) => {
          const _dataSource = cloneDeep(dataSource)
          disableTreeByKey(_dataSource, fields.id)
          return _dataSource
        },
        formFieldConfig: {
          fieldNames: {
            label: 'name',
            value: 'id'
          },
          treeDefaultExpandAll: true,
          onChange: getAdminRoleByIdAsync
        }
      },
      {
        title: "组别名称",
        dataIndex: "name",
        width: 200,
        form: true,
      },
      {
        title: "角色标识",
        dataIndex: "slug",
        align: "center",
        width: 200,
        form: true,
      },
      {
        title: "权限",
        dataIndex: "permissionIds",
        align: "center",
        form: true,
        hide: true,
      },
      {
        title: "描述",
        dataIndex: "description",
        type: "textarea",
        form: true,
        hide: true,
      },
      {
        title: "排序",
        dataIndex: "sort",
        type: "input-number",
        form: true,
        hide: true,
      },
      {
        title: "状态",
        dataIndex: "status",
        align: "center",
        width: 100,
        search: true,
        form: true,
        type: 'select',
        formType: 'radio',
        options: [
          {
            label: t("enum.status.1"),
            value: 1,
          },
          {
            label: t("enum.status.0"),
            value: 0,
          },
        ],
      },
      {
        title: "修改时间",
        dataIndex: "updateTime",
        align: "center",
        width: 160,
      },
      {
        title: "创建时间",
        dataIndex: "createTime",
        align: "center",
        width: 160,
      },
      {
        title: "操作",
        dataIndex: "operation",
        align: "center",
        fixed: "right",
        width: 60,
      },
    ],
    i18nPrefix: "admin_role",
    isI18nGlobal: true,
    pagination: false,
    defaultExpandAllRows: true,
  },
  form: {
    fields: {
      parentId: undefined,
      id: undefined,
      name: undefined,
      permissionIds: [],
      slug: undefined,
      updateTime: undefined,
      createTime: undefined,
      status: 1,
    },
    rules: {
      name: [{required: true, message: t("admin_role.error.name")}],
      slug: [{required: true, message: t("admin_role.error.slug")}],
      permissionIds: [{required: true, message: t("admin_role.error.permissionIds")}],
    },
    modal: {
      afterOpen: formAfterOpen
    }
  },
  modal: {
    init: onInit,
  },
});

provide(tableSettingKey, tableSettings);

const permissions = computed(() => {
  return recursive<AdminRoleRecordType>(cloneDeep(adminMenuSore.dataSource), (permission) => {
    if (permission.id && parentPermissionIds.value.length) {
      permission.disabled = !parentPermissionIds.value.includes(permission.id)
    }
    return permission
  })
})
</script>

<template>
  <i-crud>
    <template #status="{ value }">
      <status-tag :value="value"/>
    </template>
    <!--  表单自定义  -->
    <template #form-permissionIds="{record,field,placeholder}">
      <i-tree-select
        v-model:value="record[field]"
        tree-checkable
        allow-clear
        multiple
        tree-default-expand-all
        :field-names="{label: 'title', value: 'id'}"
        :tree-data="permissions"
        :placeholder="placeholder"
      />
    </template>
  </i-crud>
</template>
