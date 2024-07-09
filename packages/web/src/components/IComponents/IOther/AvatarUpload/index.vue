<!-- a-upload 封装 upload -->
<script setup lang="ts">
import {computed, ref, withDefaults,} from "vue";
import {LoadingOutlined, PlusOutlined} from "@ant-design/icons-vue";
import type {UploadChangeParam} from "ant-design-vue";
import request from '@/utils/request'

interface IPropsModal {
  alt?: string; // alt
  title?: string; // title
  placeholder?: string; // upload 占位内容
  listType: 'avatar' | 'picture-card'
}

const props = withDefaults(defineProps<IPropsModal>(), {
  alt: "upload",
  title: "",
  placeholder: "上传",
  listType: 'picture-card'
});
const emits = defineEmits([
  "confirm", // 点击确定回调
  "cancel", // 点击遮罩层或右上角叉或取消按钮的回调
]);

const fileList = ref([]);
const imgUrl = ref<string>("");
const isUploadLoading = ref<boolean>(false);
const isOpenFileModal = ref<boolean>(false);

const listType = computed(() => {
  if (['avatar', 'picture-card'].includes(props.listType)) {
    return 'picture-card'
  }
})
const handleUploadChange = (info: UploadChangeParam) => {
  console.log("info.file", info);
  if (info.file.status === "uploading") {
    isUploadLoading.value = true;
    return
  }
  if (info.file.status === "done") {
    isUploadLoading.value = false;
    if (props.listType === 'avatar') {
      uploadAvatarSuccess(info)
    }
  } else if (info.file.status === "error") {
    isUploadLoading.value = false;
  }
};

const uploadAvatarSuccess = (info) => {
  const [file] = info.file.response.data
  imgUrl.value = file.url
}

// 打开选择文件弹窗
const openFileModal = () => {
  isOpenFileModal.value = true;
};
// 取消 - 选择附件
const onFileModalCancel = () => {
  isOpenFileModal.value = false;
};
// 确定 - 选择附件
const onFileModalConfirm = () => {
  onFileModalCancel();
};
</script>

<template>
  <div class="i-upload">
    <div class="i-upload-select" @click.stop="openFileModal">选择</div>
    <a-upload
        v-model:file-list="fileList"
        name="files"
        :list-type="listType"
        class="uploader"
        :show-upload-list="false"
        accept="image/png,image/jpeg"
        :action="request.baseUrl+'/common/upload'"
        @change="handleUploadChange"
    >
      <img
          v-if="props.listType==='avatar' && imgUrl"
          :src="imgUrl"
          :alt="props.alt"
          :title="props.title"
      />
      <div v-else class="upload-placeholder">
        <loading-outlined v-if="isUploadLoading" class="upload-icon"/>
        <plus-outlined v-else class="upload-icon"/>
        <div class="ant-upload-text">
          {{ props.placeholder }}
        </div>
      </div>
    </a-upload>
  </div>
  <!-- 选择文件 modal -->
  <select-file-modal
      :open="isOpenFileModal"
      @confirm="onFileModalConfirm"
      @cancel="onFileModalCancel"
  />
</template>
