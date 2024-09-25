<!-- 附件管理 -->
<script setup lang="ts">
import {ref, shallowRef} from "vue";
import TableSettings from "@/utils/tableSettings";
import {getFileList, removeFile} from "@/api/routine/files";
import {formatFileSize} from "@/utils/common";
import {AppstoreOutlined, BarsOutlined} from '@ant-design/icons-vue'
import {useDragAndDropUpload} from '@/hooks/useDragAndDropUpload'
import {useUpload} from "@/hooks/useUpload";
import {AnnexTableSettingsType} from "./types";

type LayoutType = 'default' | 'thumbnailGrid'

const previewFileGroupRef = ref()
const layout = shallowRef<LayoutType>('default')

const tableSettings: AnnexTableSettingsType = new TableSettings({
  api: {
    find: getFileList,
    delete: removeFile
  },
  table: {
    operations: ['refresh', 'delete', 'row-delete'],
    columns: [
      {
        title: "#",
        dataIndex: "number",
        align: "center",
        width: 80,
      },
      {
        title: "附件名称",
        dataIndex: "name",
        align: "center",
        ellipsis: true,
        width: 120,
        search: true,
        customCell() {
          return {
            style: {
              maxWidth: '120px'
            }
          }
        }
      },
      {
        title: "用户名",
        dataIndex: "username",
        align: "center",
        width: 100,
        search: true,
      },
      {
        title: "用户类型",
        dataIndex: "usertype",
        align: "center",
        width: 100,
        search: true,
        type: "select",
        options: [
          {
            label: "管理员",
            value: 1,
          },
          {
            label: "普通用户",
            value: 2,
          },
        ],
      },
      {
        title: "大小",
        dataIndex: "size",
        align: "center",
        width: 100,
        customRender: ({text}) => formatFileSize(text)
      },
      {
        title: "文件类型",
        dataIndex: "mimetype",
        align: "center",
        width: 120,
        search: true
      },
      {
        title: "预览",
        dataIndex: "url",
        align: "center",
        width: 100,
      },
      {
        title: "上传次数",
        dataIndex: "uploadCount",
        align: "center",
        width: 100,
      },
      {
        title: "最后上传时间",
        dataIndex: "updateTime",
        align: "center",
        width: 180,
        search: true,
        type: 'range-picker',
        searchValueProp: 'updateRange'
      },
      {
        title: "首次上传时间",
        dataIndex: "createTime",
        align: "center",
        width: 180,
        search: true,
        type: 'range-picker',
        searchValueProp: 'createRange'
      },
      {
        title: "操作",
        dataIndex: "operation",
        align: "center",
        fixed: "right",
        width: 60,
      },
    ],
  }
})

const onPreviewFileGroupUploadSuccess = async () => {
  if (layout.value === 'thumbnailGrid') {
    if (tableSettings.table.pages) {
      // 只获取 page 即可
      await tableSettings.queryAll({
        showDataSource: false
      })
      // 处理上传成功后的分页
      // tableSettings.table.pages.total++
    }
  } else {
    await onUploadSuccess()
  }
}

const onUploadSuccess = async () => {
  await tableSettings.queryAll()
}

const onUploadChange = async (files: FileList) => {
  if (layout.value === 'thumbnailGrid') {
    previewFileGroupRef.value.upload(files)
  } else {
    await onUpload(files)
  }
}

const {loading, onUpload} = useUpload({
  onSuccess: onUploadSuccess,
})


const {dropZoneRef} = useDragAndDropUpload({
  onUpload: onUploadChange
});


</script>

<template>
  <div
    ref="dropZoneRef"
    v-loading="{ visible: loading, text: $t('tip.uploading'), global: true }"
    class="min-h-full !p-0"
  >
    <i-crud :setting="tableSettings">
      <template #refreshActionAfter>
        <i-upload
          :show-upload-list="false"
          list-type="text"
          :placeholder="$t('title.Click Upload')"
          @success="onUploadSuccess"
        />
      </template>
      <template #leftActionAfter>
        <a-radio-group v-model:value="layout">
          <a-radio-button value="default">
            <bars-outlined/>
          </a-radio-button>
          <a-radio-button value="thumbnailGrid">
            <appstore-outlined/>
          </a-radio-button>
        </a-radio-group>
      </template>

      <template #table="score">
        <div v-if="layout === 'thumbnailGrid'">
          <preview-file-group
            ref="previewFileGroupRef"
            v-bind="score"
            v-model:data-source="tableSettings.table.dataSource"
            @pages-change="tableSettings?.pagesChange"
            @delete-ok="item => tableSettings?.deleteByIds('row-delete',[item[score.rowKey]])"
            @upload-success="onPreviewFileGroupUploadSuccess"
            @select-change="tableSettings?.selectChange"
          />
        </div>
      </template>
      <template #usertype="{value}">
        <processing-tag :value="$t(`enum.usertype.${value}`)"/>
      </template>
      <template #url="{value,record}">
        <preview-file file-type="thumbnail" :name="record.name" :url="value"/>
      </template>
    </i-crud>
  </div>
</template>
