<!-- 用户列表 -->
<script setup lang="ts">
import {UserOutlined} from "@ant-design/icons-vue";
import {provide} from "vue";
import {getUserList} from "@/api/user";
import TableSettings, {tableSettingKey} from "@/utils/tableSettings";
import {useI18n} from "vue-i18n";
import {UserFields} from "@/views/user/user/types";

const {t} = useI18n()

const tableSettings = new TableSettings({
  api: {
    find: getUserList,
  },
  table: {
    operations: ["refresh", "create", "delete", "row-update", "row-delete"],
    columns: [
      {
        title: "#",
        dataIndex: "number",
        align: "center",
        width: 50,
      },
      {
        title: "用户名",
        dataIndex: "username",
        align: "center",
        width: 100,
        form: true,
      },
      {
        title: "昵称",
        dataIndex: "nickname",
        align: "center",
        width: 100,
        form: true,
      },
      {
        title: "角色组",
        dataIndex: "roles",
        align: "center",
        width: 120,
        type: 'tree-select',
        form: true,
        formValueProp: "roleIds",
        // options: roleOptions,
        formFieldConfig: {
          fieldNames: {label: 'name', value: 'id'},
          multiple: true,
          spliceParentTitle: true,
          treeDefaultExpandAll: true
        }
      },
      {
        title: "头像",
        dataIndex: "avatar",
        align: "center",
        width: 100,
        form: true,
        formValueProp: 'fileList',
        type: 'upload',
        formFieldConfig: {
          length: 1,
          accept: "image/*"
        }
      },
      {
        title: "性别",
        dataIndex: "gender",
        align: "center",
        width: 100,
        form: true,
        type: 'radio',
        options: [
          {label: t('enum.gender.0'), value: 0},
          {label: t('enum.gender.1'), value: 1},
          {label: t('enum.gender.2'), value: 2},
        ]
      },
      {
        title: "邮箱",
        dataIndex: "email",
        align: "center",
        width: 150,
        form: true
      },
      {
        title: "手机号",
        dataIndex: "phone",
        align: "center",
        width: 150,
        form: true
      },
      {
        title: "密码",
        dataIndex: "password",
        type: 'input-password',
        hide: true,
        form: true,
        placeholder(fields: UserFields) {
          return t(fields.id
            ? 'user.placeholder.edit_password'
            : 'user.placeholder.password'
          )
        },
        formFieldConfig: {
          autocomplete: "new-password"
        }
      },
      {
        title: "个性签名",
        dataIndex: "sign",
        type: 'textarea',
        hide: true,
        form: true,
      },
      {
        title: "最后登录IP",
        dataIndex: "lastLoginIp",
        align: "center",
        width: 100,
      },
      {
        title: "最后登录时间",
        dataIndex: "lastLoginTime",
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
        title: "状态",
        dataIndex: "status",
        align: "center",
        width: 100,
        form: true,
        type: 'radio',
        options: [
          {label: t("enum.status.0"), value: 0},
          {label: t("enum.status.1"), value: 1},
        ],
      },
      {
        title: "操作",
        dataIndex: "operation",
        align: "center",
        fixed: "right",
        width: 60,
      },
    ],
    i18nPrefix: "user",
    isI18nGlobal: true,
  },
  form: {
    fields: {
      type: 1,
      id: undefined,
      roleIds: [],
      username: undefined,
      nickname: undefined,
      avatar: undefined,
      avatarPath: undefined,
      email: undefined,
      phone: undefined,
      motto: undefined,
      password: undefined,
      checkPassword: undefined,
      sign: undefined,
      gender: 0,
      status: 1,
      fileList: [],
    },
    rules: {
      username: [{required: true, message: t("user.error.username")}],
      nickname: [{required: true, message: t("user.error.nickname")}],
      roleIds: [{required: true, message: t("user.error.roles")}],
    }
  },
  // modal: {
  //   init: onInit
  // },
  customParams: {
    confirmForm(params: any) {
      const [response] = params.fileList || [];
      return {
        ...params,
        fileList: undefined,
        avatar: response?.path,
      };
    },
  },
});

provide(tableSettingKey, tableSettings);
</script>

<template>
  <i-crud>
    <template #roles="{ value }">
      <a-tag v-for="text in value" :key="value" color="processing" class="table-tag">
        {{ text }}
      </a-tag>
    </template>
    <template #gender="{ value }">
      <a-tag color="success" class="table-tag">
        {{ $t(`enum.gender.${value}`) }}
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
        {{ $t(`enum.status.${value}`) }}
      </a-tag>
    </template>
    <template #avatar="{ value }">
      <a-avatar size="large" :src="value">
        <template #icon>
          <user-outlined/>
        </template>
      </a-avatar>
    </template>
  </i-crud>
</template>

<style lang="less" scoped>
@import "./index.less";
</style>
