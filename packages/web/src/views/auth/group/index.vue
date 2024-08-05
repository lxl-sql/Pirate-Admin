<!-- 角色组管理 -->
<script setup lang="ts">
import {computed, provide, shallowRef} from "vue";
import StatusTag from "@/components/IComponents/IOther/StatusTag/index.vue";
import TableSettings, {tableSettingKey} from "@/utils/tableSettings";
import {adminRoleUpsert, getAdminRoleById, getAdminRoleList, removeAdminRole,} from "@/api/auth/admin";
import {AdminRoleFields, AdminRoleRecordType, AdminRoleTableSettingsType} from "./types";
import {useI18n} from "vue-i18n";
import {useAdminMenuStore} from '@/store'
import {disableTreeByKey, recursive} from "@/utils/common";
import {cloneDeep} from "lodash-es";
import {ModalType} from "@/types/tableSettingsType";
import {getTreeKeys, treeForEach} from "@/utils/tree";
import {Key} from "@/types";

const {t} = useI18n();

const adminMenuSore = useAdminMenuStore()

const parentPermissionIds = shallowRef<Key[]>([])
const permissionTreeExpandedKeys = shallowRef<Key[]>([])
const allPermissionIds = shallowRef<Key[]>([])


const getAdminRoleByIdAsync = async (id: number) => {
  const {data} = await getAdminRoleById(id)
  parentPermissionIds.value = data.permissionIds
}

const formAfterOpen = async (type: ModalType, fields: AdminRoleFields) => {
  if (fields) {
    // console.log(' fields.permissionIds', fields.permissionIds)
    allPermissionIds.value = fields.permissionIds || []
    // 初始化菜单权限数据源
    await adminMenuSore.getAdminMenuListRequest()
    const dataSource = adminMenuSore.dataSource
    // 默认展开
    permissionTreeExpandedKeys.value = getTreeKeys(dataSource)
    const keys: number[] = []
    treeForEach<any>(dataSource, item => {
      if (!item.children?.length && fields.permissionIds?.includes(item.id)) {
        keys.push(item.id)
      }
    })
    // console.log('keys', keys)
    fields.permissionIds = keys

    if (fields.parentId) {
      await getAdminRoleByIdAsync(fields.parentId)
    }
  }
}

const formBeforeClose = (fields) => {
  if (fields) {
    fields.permissionIds = [...allPermissionIds.value]
    allPermissionIds.value = []
  }
}
const formAfterClose = () => {
  parentPermissionIds.value = []
}

/**
 * 链接父级id 只做缓存使用
 * @param checkedKeys
 * @param e
 */
const handleCheck = (checkedKeys, e) => {
  allPermissionIds.value = checkedKeys.concat(e.halfCheckedKeys)
}

const permissions = computed(() => {
  return recursive<AdminRoleRecordType>(cloneDeep(adminMenuSore.dataSource), (permission) => {
    if (permission.id && parentPermissionIds.value.length) {
      permission.disabled = !parentPermissionIds.value.includes(permission.id)
    }
    return permission
  })
})

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
        options: 'status'
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
      afterOpen: formAfterOpen,
      beforeClose: formBeforeClose,
      afterClose: formAfterClose
    }
  },
});

provide(tableSettingKey, tableSettings);
</script>

<template>
  <i-crud>
    <template #status="{ value }">
      <status-tag :value="value"/>
    </template>
    <!--  表单自定义  -->
    <template #form-permissionIds="{record,field,placeholder}">
      <a-tree
        v-model:checked-keys="record[field]"
        v-model:expanded-keys="permissionTreeExpandedKeys"
        allow-clear
        block-node
        checkable
        :field-names="{label: 'title', key: 'id'}"
        :tree-data="permissions"
        :placeholder="placeholder"
        @check="handleCheck"
      />
    </template>
  </i-crud>
</template>
