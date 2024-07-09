<!-- a-upload 封装 upload -->
<script setup lang="ts">
import {ref, watch, withDefaults,} from "vue";
import {LoadingOutlined, PlusOutlined} from "@ant-design/icons-vue";
import {notification, UploadChangeParam} from "ant-design-vue";
import {useI18n} from "vue-i18n";
import {upload} from "@/api/routine/files";
import {formatFileSize} from "@/utils/common";

const {t} = useI18n();

interface IPropsModal {
  fileList?: any[]; // 文件列表
  alt?: string; // alt
  title?: string; // title
  placeholder?: string; // upload 占位内容
  listType: 'picture-card',
  length?: number; // 上传文件数量
  accept?: string; // 接受上传的文件类型 详见 https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/file#accept
  size?: number; // 上传文件大小
  beforeUpload?: (file) => boolean; // 上传前的钩子函数
}

const props = withDefaults(defineProps<IPropsModal>(), {
  alt: "upload",
  title: "",
  placeholder: "上传",
  listType: 'picture-card',
  fileList: undefined,
  length: undefined,
  accept: undefined,
  size: undefined,
  beforeUpload: undefined,
});
const emits = defineEmits([
  "update:fileList", // 文件列表
  "change",
  "confirm", // 点击确定回调
  "cancel", // 点击遮罩层或右上角叉或取消按钮的回调
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
const customRequest = async (originObject) => {
  const {file, onSuccess, onError, onProgress} = originObject;
  console.log("file", originObject);
  const formData = new FormData();
  formData.append('files', file);
  formData.append('uid', file.uid);
  onProgress({percent: 50});
  try {
    const {data} = await upload(formData);
    onProgress({percent: 100});
    const [_data] = data || [];
    const response = {
      ..._data,
      ...file,
      status: 'done'
    }
    onSuccess(response, file);
    notification.success({
      message: t('message.success'),
      description: t('success.upload'),
    })
  } catch (err) {
    onError(err)
  }
};

const handleUploadChange = (info: UploadChangeParam) => {
  console.log("info.file", info);
  if (info.file.status === "uploading") {
    isUploadLoading.value = true;
    return
  }
  if (info.file.status === "done") {
    isUploadLoading.value = false;
  } else if (info.file.status === "error") {
    isUploadLoading.value = false;
    notification.error({
      message: t('message.fail'),
      description: t('error.upload'),
    })
  }
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
const generateAcceptRegex = (accept) => {
  // 将 accept 字符串中的通配符 * 替换为正则表达式中的 .*
  const regexString = accept
      .replace(/\./g, '\\.')
      .replace(/,/g, '|') // 将逗号替换为竖线，表示逻辑或
      .replace(/\*/g, '.*'); // 将星号替换为匹配任意字符
  // 构建正则表达式对象
  return new RegExp(`(${regexString})`);
}
// beforeUpload
const beforeUpload = (file) => {
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
  const beforeUpload = props.beforeUpload && props.beforeUpload(file) || true;
  return isAccept && isLtSize && beforeUpload;
};

const onUploadPreview = (file) => {
  // console.log('onUploadPreview', file)
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
const onFileModalCancel = () => {
  isSelectFileModalVisible.value = false;
};
// 确定 - 选择附件
const onFileModalConfirm = () => {
  onFileModalCancel();
};
</script>

<template>
  <div class="i-upload relative inline-block rounded-md transition-all">
    <a-upload
        v-model:file-list="fileList"
        :custom-request="customRequest"
        :list-type="props.listType"
        :accept="props.accept"
        :before-upload="beforeUpload"
        name="files"
        class="uploader"
        multiple
        @change="handleUploadChange"
        @preview="onUploadPreview"
    >
      <template v-if="!props.length || fileList.length < props.length">
        <div class="select-text" @click.stop="openFileModal">选择</div>
        <div class="h-[100%] flex flex-col justify-center items-center">
          <loading-outlined v-if="isUploadLoading" class="i-upload-icon"/>
          <plus-outlined v-else class="i-upload-icon"/>
          <div class="i-upload-text">
            {{ props.placeholder }}
          </div>
        </div>
      </template>
    </a-upload>
  </div>

  <div class="hidden">
    <a-image-preview-group
        :preview="{
          visible:isPreviewImageVisible,
          onVisibleChange: vis => (isPreviewImageVisible = vis),
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
      :open="isSelectFileModalVisible"
      @confirm="onFileModalConfirm"
      @cancel="onFileModalCancel"
  />
</template>

<style lang="less" scoped>
@import "index.less";
</style>
