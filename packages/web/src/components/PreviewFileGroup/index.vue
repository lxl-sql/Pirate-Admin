<!--
预览文件列表
1. 预览
2. 自定义icon
3. 选中指定项
4. 默认为 txt 文件
-->
<script setup lang="ts">
import PreviewFile from "../PreviewFile/index.vue";
import {IPagination} from "@/types/table";
import {nextTick, ref} from "vue";
import {Key} from "ant-design-vue/lib/table/interface";

interface PreviewFileProps {
  rowKey?: string
  dataSource?: any[],
  pagination?: IPagination,
  selectedRowKeys?: Key[],
}

const props = withDefaults(defineProps<PreviewFileProps>(), {
  rowKey: 'id',
  dataSource: () => [],
})
const emits = defineEmits([
  'update:dataSource',
  'pagesChange',
  'deleteOk',
  'deleteCancel',
  'uploadSuccess',
  'selectChange'
])

const previewFileRef = ref()

const setDataSource = (list) => {
  console.log('setDataSource -->', list)
  emits('update:dataSource', [...list])
}

const upload = (files: FileList) => {
  const rowKey = props.rowKey
  let maxKey: number = Math.max(...props.dataSource.map(item => item[rowKey])) || 0

  const newFiles = Array.from(files)
  const _files: any[] = []
  newFiles.forEach((file) => {
    maxKey++
    _files.push({
      [rowKey]: `${maxKey}.${Date.now()}`, // 需要唯一的不能跟 id 重复的key
      name: file.name,
    })
  });
  setDataSource([..._files, ...props.dataSource])
  const maxKeys = _files.map(f => f[rowKey])
  nextTick(() => {
    let index = 0
    previewFileRef.value.forEach(ref => {
      if (maxKeys.includes(ref[rowKey])) {
        const file = newFiles[index]
        ref.upload(file)
        index++
      }
    })
  })
}

const onUploadSuccess = (key: Key, data) => {
  const rowKey = props.rowKey
  const dataSource = props.dataSource
  nextTick(() => {
    const [file] = data
    // 1. hash 相同 斩中增头
    const sameHashIndex = dataSource.findIndex(item => item.hash === file.hash)
    const sameKeyIndex = dataSource.findIndex(item => item[rowKey] === key)
    // console.log('sameHash', sameHashIndex, sameKeyIndex)
    if (sameHashIndex > -1) {
      dataSource[sameHashIndex].uploadCount++
      // 先替换 后全部删除
      Object.assign(dataSource[sameKeyIndex], dataSource[sameHashIndex])
      // dataSource.splice(sameKeyIndex, 1, dataSource[sameHashIndex])
      dataSource.splice(sameHashIndex, 1)
      setDataSource(dataSource)
    }
    // 2. hash 不同 替换 + 斩尾
    else {
      Object.assign(dataSource[sameKeyIndex], file)
      dataSource.splice(-1)
      setDataSource(dataSource)
    }
    emits('uploadSuccess', file)
  })
}

const onUploadError = (key: Key) => {
  const rowKey = props.rowKey
  const dataSource = props.dataSource
  nextTick(() => {
    const sameKeyIndex = dataSource.findIndex(item => item[rowKey] === key)
    dataSource.splice(sameKeyIndex, 1)
    setDataSource(dataSource)
  })
}

/**
 * 分页
 * @param page
 * @param pageSize
 */
const handlePageSizeChange = (page: number, pageSize: number) => {
  const pages = {
    size: pageSize,
    page: page,
    total: props.pagination?.total || 0
  };
  emits("pagesChange", pages);
};

const handlePreviewFileClick = (item) => {
  const rowKey = props.rowKey
  const selectedRowKeys = props.selectedRowKeys
  if (selectedRowKeys) {
    const index = selectedRowKeys.findIndex(key => key === item[rowKey])
    if (index > -1) {
      selectedRowKeys.splice(index, 1)
    } else {
      selectedRowKeys.push(item[rowKey])
    }
    emits('selectChange', selectedRowKeys)
  }
}

/**
 * 获取当前的下标值
 * @param key
 */
const getCount = (key: Key) => {
  const index = props.selectedRowKeys?.findIndex(k => k === key)
  if (index !== undefined && index > -1) {
    const count = index + 1
    if (count > 99) return '99+'
    return count
  }
  return undefined
}

defineOptions({
  name: 'PreviewFileGroup'
})
defineExpose({
  upload
})
</script>

<template>
  <div class="preview-file-group">
    <template v-if="dataSource.length !== 0">
      <div class="flex flex-wrap">
        <preview-file
          v-for="item in dataSource"
          :key="item[rowKey]"
          ref="previewFileRef"
          v-bind="item"
          :row-key="rowKey"
          :show-upload-list="true"
          :upload-success="onUploadSuccess"
          :upload-error="onUploadError"
          :count="getCount(item[rowKey])"
          @delete-ok="() => emits('deleteOk',item)"
          @delete-cancel="() => emits('deleteCancel',item)"
          @click="handlePreviewFileClick(item)"
        />
      </div>
      <a-pagination
        size="small"
        class="text-center mt-4"
        v-bind="pagination"
        @change="handlePageSizeChange"
      />
    </template>
  </div>
</template>

<style scoped lang="less">
@import "./index.less";
</style>
