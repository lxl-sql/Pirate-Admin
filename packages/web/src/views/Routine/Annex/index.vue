<!-- 附件管理 -->
<script setup lang="ts">
import {provide, ref} from "vue";
import TableSettings, {tableSettingKey} from "@/utils/tableSettings";
import {getFileList, removeFile} from "@/api/routine/files";
import {formatFileSize, setTimeoutPromise} from "@/utils/common";
import {AppstoreOutlined, BarsOutlined} from '@ant-design/icons-vue'

const tableSettings = new TableSettings({
  api: {
    find: getFileList,
    delete: removeFile
  },
  table: {
    operations: ['refresh', 'delete', 'row-delete'],
    columns: [
      {
        title: "序号",
        dataIndex: "number",
        align: "center",
        width: 80,
      },
      {
        title: "附件名称",
        dataIndex: "name",
        align: "center",
        ellipsis: true,
        width: 100,
        search: true,
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
      },
      {
        title: "文件类型",
        dataIndex: "mimetype",
        align: "center",
        width: 100,
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

provide(tableSettingKey, tableSettings)

const layout = ref('default')

const onUploadSuccess = async () => {
  await setTimeoutPromise(100)
  await tableSettings.queryAll()
}

</script>

<template>
  <custom-table>
    <template #afterActionRefresh>
      <i-upload
        :show-upload-list="false"
        list-type="text"
        placeholder="点击上传"
        @success="onUploadSuccess"
      />
    </template>
    <template #afterLeftAction>
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
          v-bind="score"
          @pages-change="tableSettings?.pagesChange"
          @delete-ok="item => tableSettings?.deleteByIds('row-delete',[item[score.rowKey]])"
        />
      </div>
    </template>
    <template #usertype="{value}">
      <processing-tag :value="value === 1 ? '管理员' : '普通用户'"/>
    </template>
    <template #size="{value}">
      {{ formatFileSize(value) }}
    </template>
    <template #url="{value}">
      <a-image :src="value" class="max-h-[60px]"/>
    </template>
  </custom-table>
</template>

