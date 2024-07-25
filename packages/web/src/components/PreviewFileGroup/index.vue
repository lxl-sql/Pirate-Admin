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

interface PreviewFileProps {
  rowKey?: string
  dataSource?: any[],
  pagination?: IPagination
}

const props = withDefaults(defineProps<PreviewFileProps>(), {
  rowKey: 'id',
  dataSource: () => [],
})
const emits = defineEmits(['pagesChange', 'deleteOk', 'deleteCancel'])

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

defineOptions({
  name: 'PreviewFileGroup'
})
</script>

<template>
  <div class="preview-file-group">
    <template v-if="dataSource.length !== 0">
      <div class="flex flex-wrap">
        <preview-file
          v-for="item in dataSource"
          :key="item[rowKey]"
          v-bind="item"
          :show-upload-list="true"
          @delete-ok="() => emits('deleteOk',item)"
          @delete-cancel="() => emits('deleteCancel',item)"
        />
      </div>
      <a-pagination
        size="small"
        class="text-center mt-4"
        v-bind="pagination"
        @change="handlePageSizeChange"
      />
    </template>
    <!--    <a-upload-dragger-->
    <!--      v-else-->
    <!--      v-model:fileList="fileList"-->
    <!--      name="file"-->
    <!--      :multiple="true"-->
    <!--      action="https://www.mocky.io/v2/5cc8019d300000980a055e76"-->
    <!--      @change="handleChange"-->
    <!--      @drop="handleDrop"-->
    <!--    >-->
    <!--      <p class="ant-upload-drag-icon">-->
    <!--        <cloud-upload-outlined/>-->
    <!--      </p>-->
    <!--      <p class="ant-upload-text">{{ $t('other.Click or drag file to this area to upload') }}</p>-->
    <!--    </a-upload-dragger>-->
  </div>
</template>

<style scoped lang="less">
@import "./index.less";
</style>
