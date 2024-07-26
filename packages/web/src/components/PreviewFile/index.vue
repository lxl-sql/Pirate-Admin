<!-- 预览文件项 -->
<script setup lang="ts">
import {computed, ref, shallowRef, StyleValue, useAttrs} from "vue";
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
  PauseCircleOutlined,
  PlayCircleOutlined
} from '@ant-design/icons-vue'
import {Modal} from "ant-design-vue";
import {downloadFile, isSuffixMatch} from "@/utils/common";
import {ShowUploadListInterface} from "ant-design-vue/es/upload/interface";
import FileViewModal from "@/components/IComponents/IModal/components/FileViewModal/index.vue";
import {useMediaPlay} from '@/hooks/useMediaPlay'
import {openWindow} from "@/utils/dom";
import FileMusicOutlined from "@/components/IComponents/IIcon/FileMusicOutlined/index.vue";
import {useUpload} from "@/hooks/useUpload";
import {Key} from "ant-design-vue/lib/table/interface";

interface PreviewFileItemProps {
  name?: string;
  url?: string;
  rowKey?: string;
  count?: string | number;
  /**
   * normal 正常模式
   * thumbnail 缩略图模式
   */
  fileType?: 'thumbnail' | 'normal'
  /**
   * 是否展示 uploadList, 可设为一个对象，用于单独设定 showPreviewIcon, showRemoveIcon 和 showDownloadIcon
   */
  showUploadList?: boolean | ShowUploadListInterface;
  /**
   * 是否自定义下载事件
   */
  customDownload?: boolean;
  uploadSuccess?: (key: Key, data: any) => void
  uploadError?: (key: Key, data: any) => void
}

const attrs = useAttrs()
const props = withDefaults(defineProps<PreviewFileItemProps>(), {
  showUploadList: () => ({
    showPreviewIcon: true,
  }),
  fileType: 'normal'
})
const emits = defineEmits(['download', 'deleteOk', 'deleteCancel', 'click'])

const {mediaRef, isPlaying, toggleMediaStatus} = useMediaPlay();

const fileViewModalRef = ref()
// 预览图片
const imageVisible = shallowRef<boolean>(false);

//# region Methods
const {loading, percent, isUploadError, onUpload} = useUpload({
  onSuccess: (data) => props.uploadSuccess?.(attrs[props.rowKey!] as Key, data),
  onError: (error) => props.uploadError?.(attrs[props.rowKey!] as Key, error)
})

const upload = (file: File, options) => {
  onUpload([file] as any)
}

// 是否是有数据
const validate = () => {
  return !!(props.name && props.url)
}

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
  if (isSuffixMatch(_suffix, regData, ['image', 'jpg'])) {
    imageVisible.value = true
  } else if (isSuffixMatch(_suffix, regData, ['doc', 'ppt', 'md', 'pdf', 'xls', 'yml', 'zip', 'txt', 'otherAudio', 'xmind'])) {
    fileViewModalRef.value.init(props.url)
  } else {
    openWindow(props.url!)
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
    centered: true,
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
  forestGreen: '#107C41',
  softPurple: '#826aec',
  tomatoRed: '#DE4A23'
}
const regData = {
  jpg: /(p?jpe?g?|jfif)$/i,
  image: /(a?png|webp|gif|bmp|svg|avif|ico|cur)$/i,
  doc: /(docx?)$/i,
  zip: /(rar|zip|gz)$/i,
  pdf: /(pdf)$/i,
  ppt: /(pptx?)$/i,
  yml: /(ya?ml)$/i,
  xls: /(xlsx?)$/i,
  md: /(md|markdown)$/i,
  txt: /(te?xt)$/i,
  audio: /(mp3)$/i,
  video: /(mp4)$/i,
  otherAudio: /(wav|flv)$/i,
  xmind: /(xmind)$/i,
}
// 颜色对应
const suffixToBgColorMap = {
  jpg: bgData.freshGreen,
  image: bgData.freshGreen,
  doc: bgData.skyBlue,
  zip: bgData.sunsetOrange,
  pdf: bgData.deepRed,
  ppt: bgData.alertRed,
  yml: bgData.lavenderPurple,
  xls: bgData.forestGreen,
  audio: bgData.softPurple,
  video: bgData.softPurple,
  xmind: bgData.tomatoRed
};

const suffix = computed<string>(() => {
  return props.name?.split('.').at(-1) || ''
})
const name = computed<string>(() => {
  return props.name?.replace(/(.*\/)*([^.]+).*/ig, "$2") || '';
})
const tagBg = computed(() => {
  const _suffix = suffix.value;
  for (const [key, color] of Object.entries(suffixToBgColorMap)) {
    if (regData[key].test(_suffix)) {
      return color;
    }
  }
  return bgData.neutralGray;
})

/**
 * 特定模式下才显示 加载进度条
 * - normal
 */
const progressLoading = computed(() => {
  return props.fileType === 'normal' && loading.value
})

const progressStatusClass = computed(() => {
  return isUploadError.value ? 'exception' : undefined
})

const progressMarkOpacityClass = computed(() => {
  return progressLoading.value ? 'opacity-100' : 'opacity-0'
})

const countScale = {
  1: 100,
  2: 85,
  3: 75
}
const countClass = computed(() => {
  // 勿动表达式
  const length = props.count ? String(props.count).length : undefined
  if (!length) return 'scale-100'
  return `scale-${countScale[length]}`
})
//# endregion

defineOptions({
  name: 'PreviewFile'
})
defineExpose({
  [props.rowKey!]: attrs[props.rowKey!],
  upload,
  validate,
})
</script>

<template>
  <div
    class="group preview-file relative z-1"
    :class="[`preview-file-${fileType}`, $attrs.class]"
    :style="$attrs.style as StyleValue"
    @click="emits('click',$event)"
  >
    <div
      v-if="fileType==='normal' && count"
      class="mark-full-opacity opacity-100"
    >
      <span
        class="absolute top-2 right-2 rounded-full w-5 h-5 leading-5 text-center text-xs bg-[var(--colorPrimary)] overflow-hidden"
      >
        <span class="block scale-75" :class="countClass">{{ count }}</span>
      </span>
    </div>
    <div
      class="mark-full-opacity"
      :class="progressMarkOpacityClass"
    >
      <a-progress
        type="circle"
        :percent="percent"
        :status="progressStatusClass"
        class="absolute-center"
      />
    </div>
    <div
      v-if="!progressLoading"
      class="group-hover:opacity-100 mark-full-opacity"
    >
      <div v-if="showUploadList" class="show-outlined absolute-center w-4/5 text-center">
        <template v-if="/mp3|mp4/i.test(suffix)">
          <pause-circle-outlined
            v-if="isPlaying"
            class="hover-icon"
            @click="toggleMediaStatus ('pause')"
          />
          <play-circle-outlined
            v-else
            class="hover-icon"
            @click="toggleMediaStatus ('play')"
          />
        </template>
        <eye-outlined
          v-if="typeOfUploadList('showPreviewIcon') && !/mp3|mp4/i.test(suffix)"
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
      class="preview-file__tag ellipsis absolute z-1 top-1.5 left-1.5 px-1 py-0.5 rounded-[2px]"
    >
      {{ suffix }}
    </span>
    <img
      v-if="!progressLoading && isSuffixMatch(suffix, regData, ['image', 'jpg'])"
      :src="url"
      :alt="name"
      class="text-xs select-none image-auto-center"
    />
    <video
      v-else-if="!progressLoading && regData.video.test(suffix)"
      ref="mediaRef"
      :src="url"
      class="text-xs select-none image-auto-center"
    >
      {{ $t('other.Your browser does not support playing this video!') }}
    </video>
    <template v-else>
      <div
        class="absolute -z-1 top-0 right-0 pt-2 pb-3 px-2 rounded-bl-[8px] text-6xl text-white bg-black/5 preview-file-other"
      >
        <file-word-outlined v-if="regData.doc.test(suffix)"/>
        <file-pdf-outlined v-else-if="regData.pdf.test(suffix)"/>
        <file-ppt-outlined v-else-if="regData.ppt.test(suffix)"/>
        <file-zip-outlined v-else-if="regData.zip.test(suffix)"/>
        <file-exclamation-outlined v-else-if="regData.yml.test(suffix)"/>
        <file-excel-outlined v-else-if="regData.xls.test(suffix)"/>
        <file-music-outlined v-else-if="regData.audio.test(suffix)"/>
        <file-video-outlined v-else-if="regData.video.test(suffix)"/>
        <file-xmind-outlined v-else-if="regData.xmind.test(suffix)"/>
        <file-jpg-outlined v-else-if="regData.jpg.test(suffix)"/>
        <file-gif-outlined v-else-if="/gif/i.test(suffix)"/>
        <file-image-outlined v-else-if="regData.image.test(suffix)"/>
        <file-markdown-outlined v-else-if="/md|markdown/i.test(suffix)"/>
        <file-text-outlined v-else-if="/te?xt/i.test(suffix)"/>
        <file-exclamation-outlined v-else-if="/json/i.test(suffix)"/>
        <file-unknown-outlined v-else/>
      </div>
      <div
        v-if="['normal'].includes(fileType)"
        class="text-xs leading-[16px] px-2 h-10 mt-auto"
      >
        <div class="ellipsis_more">
          {{ name }}
        </div>
      </div>
    </template>
    <audio
      v-if="regData.audio.test(suffix)"
      ref="mediaRef"
      :src="url"
      class="text-xs select-none image-auto-center"
    >
      {{ $t('other.Your browser does not support playing this audio!') }}
    </audio>

    <a-image
      v-if="isSuffixMatch(suffix, regData, ['image', 'jpg'])"
      class="hidden"
      :preview="{
        visible: imageVisible,
        onVisibleChange: setImageVisibleChange,
      }"
      :src="url"
    />

    <file-view-modal ref="fileViewModalRef"/>
  </div>
</template>

<style scoped lang="less">
@tagBg: v-bind(tagBg);
@import "./index.less";
</style>
