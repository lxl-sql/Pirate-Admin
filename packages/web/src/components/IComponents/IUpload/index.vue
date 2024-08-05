<!-- a-upload 封装 upload -->
<script setup lang="ts">
import {ref, watch, withDefaults,} from "vue";
import {LoadingOutlined, PlusOutlined} from "@ant-design/icons-vue";
import {notification, UploadChangeParam, UploadFile} from "ant-design-vue";
import {useI18n} from "vue-i18n";
import {upload} from "@/api/routine/files";
import {formatFileSize} from "@/utils/common";
import {FileType} from "ant-design-vue/es/upload/interface";
import type {UploadRequestOption as RcCustomRequestOptions} from "ant-design-vue/es/vc-upload/interface";
import {IUploadProps} from "@/types/upload";

const {t} = useI18n();

const props = withDefaults(defineProps<IUploadProps>(), {
  placeholder: "上传",
  name: "files",
  listType: 'picture-card',
  multiple: true,
  showUploadList: true,
  openFileDialogOnClick: true
});
const emits = defineEmits([
  "update:fileList", // 文件列表
  "change",
  "confirm", // 点击确定回调
  "cancel", // 点击遮罩层或右上角叉或取消按钮的回调
  "success"
]);

const fileList = ref<any[]>([]);
const previewCurrent = ref<number>(0);
const isUploadLoading = ref<boolean>(false);
const isPreviewImageVisible = ref<boolean>(false); // 是否显示预览图片
const isSelectFileModalVisible = ref<boolean>(false); // 是否显示选择文件 modal


watch(() => props.fileList, (val) => {
  fileList.value = val || [];
});
/**
 * 自定义上传请求接口
 * @param originObject
 */
const customRequest = async (originObject: any) => {
  if (props.customRequest) {
    return props.customRequest(originObject as RcCustomRequestOptions)
  }
  const {file, onSuccess, onError, onProgress} = originObject;
  const formData = new FormData();
  formData.append('files', file);
  formData.append('uid', file.uid);
  onProgress?.({percent: 0});
  isUploadLoading.value = true;
  try {
    const {data} = await upload(formData, {
      onUploadProgress: (progressEvent) => {
        const percent = Math.floor((progressEvent.loaded * 100) / (progressEvent.total || 0));
        onProgress?.({percent: percent});
      },
    });
    onProgress?.({percent: 100});
    const [_data] = data || [];
    const response = {
      ..._data,
      ...file,
      status: 'done'
    }
    onSuccess?.(response, file);
    emits('success', response, file)
    notification.success({
      message: t('message.success'),
      description: t('success.upload'),
    })
  } catch (error) {
    onError?.(error)
  } finally {
    isUploadLoading.value = false;
  }
};

const handleUploadChange = (info: UploadChangeParam) => {
  if (info.file.status === "uploading") {
    return
  }
  if (info.file.status === "error") {
    notification.error({
      message: t('message.fail'),
      description: t('error.upload'),
    })
  }
  console.log("info.file", info);
  const _fileList = info.fileList
    .filter(file => file.status !== 'error' && file.status)
    .map(file => {
      if (file.response) {
        return {
          ...file,
          ...file.response,
        }
      }
      return file
    });
  fileList.value = _fileList;
  emits("update:fileList", _fileList);
  emits("change", info.file, _fileList);
};
const generateAcceptRegex = (accept: string) => {
  // 将 accept 字符串中的通配符 * 替换为正则表达式中的 .*
  const regexString = accept
    .replace(/\./g, '\\.')
    .replace(/,/g, '|') // 将逗号替换为竖线，表示逻辑或
    .replace(/\*/g, '.*'); // 将星号替换为匹配任意字符
  // 构建正则表达式对象
  return new RegExp(`(${regexString})`);
}
// beforeUpload
const beforeUpload = (file: FileType, fileList: FileType[]) => {
  let isAccept = true;
  let isLtSize = true;
  if (props.accept) {
    isAccept = generateAcceptRegex(props.accept).test(file.type);
    if (!isAccept) {
      notification.error({
        message: t('message.fail'),
        description: t('error.uploadType'),
      })
    }
  }
  if (props.size) {
    const MB = Math.pow(1024, 2);
    isLtSize = file.size / MB > props.size;
    if (!isLtSize) {
      notification.error({
        message: t('message.fail'),
        description: t('error.uploadSize') + formatFileSize(props.size * MB, 0),
      })
    }
  }
  const beforeUpload = props.beforeUpload ? props.beforeUpload(file, fileList) : true;
  return isAccept && isLtSize && beforeUpload;
};

const handleUploadPreview = (file: UploadFile) => {
  isPreviewImageVisible.value = true;
  // 获取预览图片的索引
  const current = fileList.value.findIndex(f => f.uid === file.uid)
  previewCurrent.value = current || 0
}

// 打开选择文件弹窗
const openFileModal = () => {
  isSelectFileModalVisible.value = true;
};
// 取消 - 选择附件
const handleSelectFileModalCancel = () => {
  isSelectFileModalVisible.value = false;
};
// 确定 - 选择附件
const handleSelectFileModalConfirm = (files) => {
  fileList.value = files
  emits('update:fileList', files)
  emits('success', files)
  handleSelectFileModalCancel();
};
</script>

<template>
  <div class="i-upload relative inline-block rounded-md transition-all">
    <a-upload
      v-bind="props"
      v-model:file-list="fileList"
      :custom-request="customRequest"
      :before-upload="beforeUpload"
      @change="handleUploadChange"
      @preview="handleUploadPreview"
    >
      <slot>
        <template v-if="listType==='picture-card' && (!maxCount || fileList.length < maxCount)">
          <div class="select-text" @click.stop="openFileModal">选择</div>
          <div class="h-[100%] flex flex-col justify-center items-center">
            <loading-outlined v-if="isUploadLoading" class="i-upload-icon"/>
            <plus-outlined v-else class="i-upload-icon"/>
            <div class="i-upload-text">
              {{ placeholder }}
            </div>
          </div>
        </template>
        <a-button
          v-else-if="listType==='text'"
          type="primary"
          :loading="isUploadLoading"
        >
          {{ placeholder }}
        </a-button>
      </slot>
    </a-upload>
  </div>

  <div class="hidden">
    <a-image-preview-group
      :preview="{
          visible:isPreviewImageVisible,
          onVisibleChange: (vis:boolean) => (isPreviewImageVisible = vis),
          maskClassName: 'i-upload-preview-mask',
          current: previewCurrent
        }"
    >
      <a-image
        v-for="item in fileList"
        :key="item.uid"
        :src="item.url || item.thumbUrl"
      />
    </a-image-preview-group>
  </div>

  <!-- 选择文件 modal -->
  <select-file-modal
    v-if="listType==='picture-card'"
    :open="isSelectFileModalVisible"
    :max-count="maxCount"
    @confirm="handleSelectFileModalConfirm"
    @cancel="handleSelectFileModalCancel"
  />
</template>

<style lang="less" scoped>
@import "index.less";
</style>
