<!-- 管理员管理 -->
<script setup lang="ts">
import {ref} from "vue";
import {findById, list, remove, upsert} from "@/api/auth/admin";
import ProcessingTag from "@/components/IComponents/IOther/ProcessingTag/index.vue";
import StatusTag from "@/components/IComponents/IOther/StatusTag/index.vue";
import TableSettings from "@/utils/tableSettings";
import {useI18n} from "vue-i18n";
import {AdminFields, AdminTableSettingsType} from "./types";
import {useRoleStore} from "@/store";
import {UserOutlined} from "@ant-design/icons-vue";
import {ModalType} from "@/types/tableSettingsType";

const {t} = useI18n();

const roleStore = useRoleStore()

const avatarPreviewSrc = ref("");
const isAvatarPreviewSrcOpen = ref<boolean>(false);

const onInit = async () => {
  await roleStore.getRoleListRequest();
  console.log('onInit roleStore.dataSource', roleStore.dataSource)
};
// 显示预览图片
const openAvatarPreviewImage = (src: string) => {
  console.log('src', src)
  if (!src) return;
  isAvatarPreviewSrcOpen.value = true;
  avatarPreviewSrc.value = src;
};

const tableSettings: AdminTableSettingsType = new TableSettings({
  api: {
    find: list,
    findById: findById,
    delete: remove,
    upsert: upsert,
  },
  table: {
    operations: ["refresh", "create", "delete", "row-update", "row-delete"],
    columns: [
      {
        title: "#",
        dataIndex: "number",
        align: "center",
        width: 50,
        fixed: 'left'
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
        width: 180,
        type: 'tree-select',
        form: true,
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
          maxCount: 1,
          accept: "image/*",
          multiple: false,
        }
      },
      {
        title: "邮箱",
        dataIndex: "email",
        align: "center",
        width: 150,
        form: true,
        formFieldConfig(fields: AdminFields) {
          return {
            readonly: !!fields?.id
          }
        }
      },
      {
        title: "手机号",
        dataIndex: "phone",
        align: "center",
        width: 150,
        form: true,
        formFieldConfig(fields: AdminFields) {
          return {
            readonly: !!fields?.id
          }
        }
      },
      {
        title: "密码",
        dataIndex: "password",
        type: 'input-password',
        hide: true,
        form: true,
        placeholder(fields: AdminFields) {
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
        options: 'status'
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
      avatarFull: undefined,
      email: undefined,
      phone: undefined,
      motto: undefined,
      password: undefined,
      checkPassword: undefined,
      status: 1,
      fileList: [],
    },
    rules: {
      username: [{required: true, message: t("user.error.username")}],
      nickname: [{required: true, message: t("user.error.nickname")}],
      roleIds: [{required: true, message: t("user.error.roles")}],
    },
    modal: {
      beforeOpen(type: ModalType) {
        if (tableSettings.form.rules) {
          tableSettings.form.rules.password = [{required: type === 0, message: t("user.error.password")}]
        }
      },
      afterOpen(type: ModalType, fields: AdminFields) {
        if (type !== 1) return;
        const file = {
          // 按照要求乱填即可
          url: fields.avatarFull,
          path: fields.avatar,
          status: "done",
          uid: "1",
        };
        fields.fileList = fields.avatar ? [file] : undefined
      }
    }
  },
  modal: {
    init: onInit
  },
  customParams: {
    confirmForm(params: any) {
      const [file] = params.fileList || [];
      return {
        ...params,
        fileList: undefined,
        avatar: file?.path,
      };
    },
  },
});

// watch(
//   () => tableSettings.form.fields?.id,
//   (id) => {
//     tableSettings.form.rules!.password = [{required: !id, message: t("user.error.password")}]
//   }
// )
</script>

<template>
  <i-crud :setting="tableSettings">
    <i-preview-image
      v-model:open="isAvatarPreviewSrcOpen"
      :src="avatarPreviewSrc"
    />
    <template #roles="{ value }">
      <processing-tag v-for="text in value" :key="text" :value="text"/>
    </template>
    <template #avatar="{ value }">
      <a-avatar
        size="large"
        :src="value"
        @click="openAvatarPreviewImage(value)"
      >
        <template #icon>
          <user-outlined/>
        </template>
      </a-avatar>
    </template>
    <template #lastLoginIp="{ value }">
      <processing-tag :value="value"/>
    </template>
    <template #status="{ value }">
      <status-tag :value="value"/>
    </template>

    <template #form-roles="{record,placeholder}">
      <i-tree-select
        v-model:value="record.roleIds"
        :tree-data="roleStore.dataSource"
        :field-names="{label:'name',value:'id'}"
        :placeholder="placeholder"
        multiple
        tree-default-expand-all
      />
    </template>
  </i-crud>
</template>
