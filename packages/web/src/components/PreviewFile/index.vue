<!-- 预览文件项 -->
<script setup lang="ts">
import {computed, ref} from "vue";
import {
  DeleteOutlined,
  DownloadOutlined,
  EyeOutlined,
  FileExcelOutlined,
  FileExclamationOutlined,
  FileGifOutlined,
  FileImageOutlined,
  FileJpgOutlined,
  FileMarkdownOutlined,
  FilePdfOutlined,
  FilePptOutlined,
  FileTextOutlined,
  FileUnknownOutlined,
  FileWordOutlined,
  FileZipOutlined,
} from '@ant-design/icons-vue'
import {Modal} from "ant-design-vue";
import {downloadFile} from "@/utils/common";
import {ShowUploadListInterface} from "ant-design-vue/es/upload/interface";

interface PreviewFileItemProps {
  name?: string;
  url?: string;
  rowKey?: string;
  /**
   * 是否展示 uploadList, 可设为一个对象，用于单独设定 showPreviewIcon, showRemoveIcon 和 showDownloadIcon
   */
  showUploadList?: boolean | ShowUploadListInterface;
  /**
   * 是否自定义下载事件
   */
  customDownload?: boolean;
}

const props = withDefaults(defineProps<PreviewFileItemProps>(), {
  showUploadList: true
})
const emits = defineEmits(['download', 'deleteOk', 'deleteCancel'])

// 预览图片
const imageVisible = ref<boolean>(false);

//# region Methods
/**
 * 判断 showUploadList 是 `boolean` 还是 `ShowUploadList`
 * @param name
 */
const typeOfUploadList = (name: keyof ShowUploadListInterface): boolean => {
  const showUploadList = props.showUploadList
  return typeof showUploadList === 'boolean' ? showUploadList : !!showUploadList[name]
}

const handlePreview = () => {
  const _suffix = suffix.value
  if (regData.image.test(_suffix)) {
    imageVisible.value = true
  }
}

const setImageVisibleChange = (value: boolean) => {
  imageVisible.value = value;
}

const handleDownload = () => {
  if (props.customDownload) {
    emits('download')
  } else {
    downloadFile(props.url, props.name)
  }
}
const handleDelete = () => {
  Modal.confirm({
    title: "提示",
    content: "此操作将删除文件，是否继续？",
    async onOk() {
      emits('deleteOk')
    },
    async onCancel() {
      emits('deleteCancel')
    }
  })
}
//# endregion

//# region Components
const bgData = {
  neutralGray: '#909399',
  skyBlue: '#53b7f4',
  sunsetOrange: '#ffc757',
  freshGreen: '#67c23a',
  deepRed: '#8f3500',
  alertRed: '#f56c6c',
  lavenderPurple: '#9068B0',
  forestGreen: '#107C41'
}

const regData = {
  image: /(p?jpe?g?|jfif|a?png|webp|gif|bmp|svg|avif|ico|cur)$/i,
  doc: /(docx?)$/i,
  zip: /(rar|zip|gz)$/i,
  pdf: /(pdf)$/i,
  ppt: /(pptx?)$/i,
  yml: /(ya?ml)$/i,
  xls: /(xlsx?)$/i
}

const suffix = computed<string>(() => {
  return props.name?.split('.').at(-1) || ''
})
const name = computed<string>(() => {
  return props.name?.replace(/(.*\/)*([^.]+).*/ig, "$2") || '';
})

const tagBg = computed(() => {
  const _suffix = suffix.value
  if (regData.image.test(_suffix)) {
    return bgData.freshGreen
  }
  if (regData.doc.test(_suffix)) {
    return bgData.skyBlue
  }
  if (regData.zip.test(_suffix)) {
    return bgData.sunsetOrange
  }
  if (regData.pdf.test(_suffix)) {
    return bgData.deepRed
  }
  if (regData.ppt.test(_suffix)) {
    return bgData.alertRed
  }
  if (regData.yml.test(_suffix)) {
    return bgData.lavenderPurple
  }
  if (regData.xls.test(_suffix)) {
    return bgData.forestGreen
  }
  return bgData.neutralGray
})

//# endregion

defineOptions({
  name: 'PreviewFile'
})
</script>

<template>
  <div class="group preview-file-item relative">
    <!--    group-hover:opacity-100 opacity-0-->
    <div class="group-hover:opacity-100 opacity-0 mark-full transition-opacity duration-200 cursor-pointer text-white">
      <div v-if="showUploadList" class="absolute-center text-xl w-4/5 text-center">
        <eye-outlined
          v-if="typeOfUploadList('showPreviewIcon')"
          class="hover-icon"
          @click="handlePreview"
        />
        <download-outlined
          v-if="typeOfUploadList('showDownloadIcon')"
          class="hover-icon"
          @click="handleDownload"
        />
        <delete-outlined
          v-if="typeOfUploadList('showRemoveIcon')"
          class="hover-icon"
          @click="handleDelete"
        />
      </div>
    </div>
    <span
      class="preview-file-item__tag absolute top-1.5 left-1.5 px-1 py-0.5 rounded-[2px]"
    >
      {{ suffix }}
    </span>
    <img
      v-if="regData.image.test(suffix)"
      :src="url"
      :alt="name"
      class="text-xs w-full h-full select-none"
    />
    <template v-else>
      <div class="absolute top-0 right-0 pt-2 pb-3 px-2 rounded-bl-[8px] text-6xl text-white bg-black/5">
        <file-word-outlined v-if="regData.doc.test(suffix)"/>
        <file-pdf-outlined v-else-if="regData.pdf.test(suffix)"/>
        <file-ppt-outlined v-else-if="regData.ppt.test(suffix)"/>
        <file-zip-outlined v-else-if="regData.zip.test(suffix)"/>
        <file-exclamation-outlined v-else-if="regData.yml.test(suffix)"/>
        <file-excel-outlined v-else-if="regData.xls.test(suffix)"/>
        <file-jpg-outlined v-else-if="/jpe?g/i.test(suffix)"/>
        <file-image-outlined v-else-if="/png|webp/i.test(suffix)"/>
        <file-gif-outlined v-else-if="/gif/i.test(suffix)"/>
        <file-markdown-outlined v-else-if="/md|markdown/i.test(suffix)"/>
        <file-text-outlined v-else-if="/te?xt/i.test(suffix)"/>
        <file-exclamation-outlined v-else-if="/json/i.test(suffix)"/>
        <file-unknown-outlined v-else/>
      </div>
      <div class="text-xs leading-[16px] px-2 h-10 mt-auto">
        <div class="ellipsis_more">
          {{ name }}
        </div>
      </div>
    </template>

    <a-image
      v-if="regData.image.test(suffix)"
      class="hidden"
      :preview="{
        visible: imageVisible,
        onVisibleChange: setImageVisibleChange,
      }"
      :src="url"
    />
  </div>
</template>

<style scoped lang="less">
@tagBg: v-bind(tagBg);
@import "./index.less";
</style>
