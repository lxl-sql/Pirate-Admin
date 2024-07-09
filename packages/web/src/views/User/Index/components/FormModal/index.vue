<!-- 角色组管理 添加/编辑 -->
<script setup lang="ts">
import {reactive, ref, toRaw, withDefaults,} from "vue";
import {Form} from "ant-design-vue";
import {getRoleList} from "@/api/user";

interface IPropsModal {
  visible?: boolean; // 控制 modal 开关
}

interface IFormState {
  pid: number | string | undefined; // 上级分组
  username: string; // 登录用户名
  nickName: string; // 昵称
  avatar: string; // 头像
  email: string; // 邮箱
  phone: string; // 手机号
  gender: 0 | 1 | 2; // 性别
  roleIds: number[]; // 角色
  password: string; // 密码
  sign: string; // 个性签名
  status: number; // 状态
}

const props = withDefaults(defineProps<IPropsModal>(), {
  visible: false,
});
const emits = defineEmits([
  "confirm", // 点击确定回调
  "cancel", // 点击遮罩层或右上角叉或取消按钮的回调
]);

//#region  变量
const roleOptions = ref([]);
const formState = reactive<IFormState>({
  pid: "",
  username: "",
  nickName: "",
  avatar: "",
  email: "",
  phone: "",
  gender: 0,
  roleIds: [],
  password: "",
  sign: "",
  status: 1,
});

const fileList = ref([]);
const isUploadAvatarLoading = ref<boolean>(false); // 上传头像加载
const {resetFields, validate} = Form.useForm(formState);
//#endregion


const init = async () => {
  console.log("init");
  await getRoleListApi();
};

const getRoleListApi = async () => {
  const {data} = await getRoleList({});
  console.log("getRoleList", data);
  roleOptions.value = data;
};

// 确定
const handleConfirm = async (): Promise<void> => {
  console.log(formState);
  resetFields();
  try {
    await validate();
    console.log(toRaw(formState));
    emits("confirm");
  } catch (error) {
    console.log("error", error);
  }
};
// 取消
const handleCancel = (): void => {
  resetFields()
  emits("cancel");
};
</script>

<template>
  <i-modal
      :open="props.visible"
      :title="'添加'"
      width="450px"
      :init="init"
      @confirm="handleConfirm"
      @cancel="handleCancel"
  >
    <a-form
        :model="formState"
        :label-col="{ span: 4 }"
    >
      <a-form-item
          label="用户名"
          :rules="[{ required: true, message: 'Please input your username!' }]"
      >
        <a-input
            v-model:value="formState.username"
            allow-clear
            placeholder="请输入管理员用户名"
        />
      </a-form-item>
      <a-form-item
          label="昵称"
          :rules="[{ required: true, message: 'Please input your username!' }]"
      >
        <a-input
            v-model:value="formState.nickName"
            allow-clear
            placeholder="请输入昵称"
        />
      </a-form-item>
      <a-form-item
          label="角色组"
          :rules="[{ required: true, message: 'Please select roles!' }]"
      >
        <i-tree-select
            v-model:value="formState.roleIds"
            :tree-data="roleOptions"
            :field-names="{ label: 'name', value: 'id' }"
            :placeholder="$t('placeholder.role')"
            multiple
            spliceParentTitle
            tree-default-expand-all
        />
      </a-form-item>
      <a-form-item label="头像" name="avatar">
        <i-upload v-model:file-list="formState.avatar"/>
      </a-form-item>
      <a-form-item label="电子邮箱" name="email">
        <a-input
            v-model:value="formState.email"
            type="email"
            allow-clear
            placeholder="请输入电子邮箱"
        />
      </a-form-item>
      <a-form-item
          label="手机号"
          name="phone"
      >
        <a-input
            v-model:value="formState.phone"
            allow-clear
            placeholder="请输入手机号"
        />
      </a-form-item>
      <a-form-item label="性别" name="sex">
        <a-radio-group v-model:value="formState.gender">
          <a-radio :value="0">{{ $t('user.rows.gender.0') }}</a-radio>
          <a-radio :value="1">{{ $t('user.rows.gender.1') }}</a-radio>
          <a-radio :value="2">{{ $t('user.rows.gender.2') }}</a-radio>
        </a-radio-group>
      </a-form-item>
      <a-form-item
          label="密码"
          :rules="[{ required: true, message: 'Please input your password!' }]"
      >
        <a-input-password
            v-model:value="formState.password"
            allow-clear
            placeholder="请输入密码"
            autocomplete="off"
        />
      </a-form-item>
      <a-form-item label="个性签名" name="sign">
        <a-textarea
            v-model:value="formState.sign"
            allow-clear
            placeholder="请输入个性签名"
        />
      </a-form-item>
      <a-form-item label="状态" name="status">
        <a-radio-group v-model:value="formState.status">
          <a-radio :value="0">禁用</a-radio>
          <a-radio :value="1">启用</a-radio>
        </a-radio-group>
      </a-form-item>
    </a-form>
  </i-modal>
</template>

<style lang="less" scoped></style>
