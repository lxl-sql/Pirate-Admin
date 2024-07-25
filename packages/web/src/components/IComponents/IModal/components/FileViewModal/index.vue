<script setup lang="ts">
import {shallowRef} from "vue";
import {GlobalOutlined} from "@ant-design/icons-vue";
import {openWindow} from "@/utils/dom";

const open = shallowRef<boolean>(false)
const url = shallowRef<string>('')

const init = (fileUrl: string, options?: any) => {
  open.value = true
  url.value = getUrl(fileUrl)
  // url.value = 'http://localhost:8012/onlinePreview?url=aHR0cDovL2x4bC1wcml2YXRlLm9zcy1jbi13dWhhbi1sci5hbGl5dW5jcy5jb20vdGVzdC9QaXJhdGUlMjBBZG1pbi54bWluZA%3D%3D'
  // url.value = 'http://localhost:8012/onlinePreview?url=aHR0cDovL2xvY2FsaG9zdDo4MDEyL2RlbW8vb2NlYW5zLm1wNA%3D%3D'
  // url.value = 'http://localhost:8012/onlinePreview?url=aHR0cDovL2x4bC1wcml2YXRlLm9zcy1jbi13dWhhbi1sci5hbGl5dW5jcy5jb20vdGVzdC8lRTglQjQlQTIlRTUlOEElQTElRTglQUUlQjAlRTglQjQlQTYlRTclQjMlQkIlRTclQkIlOUZleGNlbCVFOCVBMSVBOCVFNiVBMCVCQy54bHN4'
  // url.value = 'http://localhost:8012/onlinePreview?url=aHR0cHM6Ly9seGwtcHJpdmF0ZS5vc3MtY24td3VoYW4tbHIuYWxpeXVuY3MuY29tL2ltYWdlcy%2FmtYvor5VNYXJrZG93bi5tZA%3D%3D'
  // url.value = 'http://localhost:8012/onlinePreview?url=aHR0cDovL2x4bC1wcml2YXRlLm9zcy1jbi13dWhhbi1sci5hbGl5dW5jcy5jb20vdGVzdC8lRTUlOEMlOTclRTQlQkElQUMlRTUlQTQlQTclRTUlQUQlQTYlRTUlOUIlQkUlRTQlQjklQTYlRTklQTYlODYlRTklQTYlODYlRTglOTclOEYlRTUlOTYlODQlRTYlOUMlQUMlRTUlOEMlQkIlRTQlQjklQTYlMjAxJTIwJUU2JUI1JThFJUU0JUI4JTk2JUU4JTg5JUFGJUU2JTk2JUI5JTIwJUU1JTg1JUFEJUU1JThEJUI3JTIwJUU5JUE2JTk2JUU0JUI4JTgwJUU1JThEJUI3JUU4JUExJUE1JUU5JTgxJTk3JUU1JTlCJTlCJUU1JThEJUI3LnBkZg%3D%3D'
}
const base64Encode = (str: string): string => {
  return btoa(unescape(encodeURIComponent(str)));
}

const getUrl = (url?: string) => {
  if (!url) {
    throw new Error('URL is required');
  }
  return `http://localhost:8012/onlinePreview?url=${encodeURIComponent(base64Encode(url))}`
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
