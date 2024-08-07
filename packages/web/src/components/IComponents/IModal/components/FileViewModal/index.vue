<script setup lang="ts">
import {shallowRef} from "vue";
import {GlobalOutlined} from "@ant-design/icons-vue";
import {openWindow} from "@/utils/dom";
import {base64Encode} from "@/utils/common";

const fileViewUrl = import.meta.env.VITE_FILE_VIEW_URL
const open = shallowRef<boolean>(false)
const url = shallowRef<string>('')

const init = (fileUrl: string, options?: any) => {
  open.value = true
  url.value = getUrl(fileUrl)
}

const getUrl = (url?: string) => {
  if (!url) {
    throw new Error('URL is required');
  }
  return `${fileViewUrl}/onlinePreview?url=${encodeURIComponent(base64Encode(url))}`
}

const handleCancel = () => {
  open.value = false
}

defineExpose({
  init
})

defineOptions({
  name: 'FileViewModal'
})
</script>

<template>
  <i-modal
    v-model:open="open"
    :title="$t('title.preview')"
    width="1200px"
    :footer="null"
    class="file-view-modal"
    destroy-on-close
    @cancel="handleCancel"
  >
    <template #headerIcon>
      <a-tooltip :title="$t('other.Open in new tab')">
        <button class="ant-modal-close ant-modal-global" @click="openWindow(url)">
          <global-outlined/>
        </button>
      </a-tooltip>
    </template>
    <iframe
      :src="url"
      width="100%"
      frameborder="0"
    >
    </iframe>
  </i-modal>
</template>

<style lang="less">
@import "./index.less";
</style>
