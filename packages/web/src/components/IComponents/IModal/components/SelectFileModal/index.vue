<!-- 选择文件 modal -->
<script setup lang="ts">
import {computed, provide, withDefaults,} from "vue";
import TableSettings, {tableSettingKey} from "@/utils/tableSettings";
import {getFileList} from "@/api/routine/files";
import {formatFileSize} from "@/utils/common";
import {notification} from "ant-design-vue";
import {useI18n} from "vue-i18n";

const {t} = useI18n()

interface SelectFileModalProps {
  title?: string; // modal 标题
  open?: boolean; // 控制 modal 开关
  maxCount?: number; // 选择文件数 默认 只能选择一个
}

const props = withDefaults(defineProps<SelectFileModalProps>(), {
  open: false,
  title: '选择附件'
  // maxCount: 1,
});

const emits = defineEmits([
  "cancel", // 点击遮罩层或右上角叉或取消按钮的回调
  "confirm"
]);

const tableSettings = new TableSettings({
  api: {
    find: getFileList,
  },
  table: {
    operations: ["refresh"],
    columns: [
      {
        title: "#",
        dataIndex: "number",
        align: "center",
        width: 50,
        fixed: 'left'
      },
      {
        title: "附件名称",
        dataIndex: "name",
        align: "center",
        width: 150,
        ellipsis: true,
        search: true
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
        search: true
      },
      {
        title: "最后上传时间",
        dataIndex: "updateTime",
        align: "center",
        width: 100,
        search: true,
        type: 'range-picker',
        searchValueProp: 'updateRange'
      },
    ],
    i18nPrefix: "file",
    // isI18nGlobal: true,
    showRemark: false,
    keywordPlaceholder: "请输入原始名称模糊搜索",
    maxSelectedCount: props.maxCount,
    rowSelection: {
      type: props.maxCount === 1 ? 'radio' : ' checkbox',
      getCheckboxProps: (record) => {
        if (!props.maxCount) return;
        const selectedRowKeys = tableSettings.table.selectedRowKeys || []
        const rowKey = tableSettings.table.rowKey || 'id'
        return {
          disabled: props.maxCount > 1 && selectedRowKeys.length === props.maxCount && !selectedRowKeys.includes(record[rowKey])
        }
      }
    }
  },
});

provide(tableSettingKey, tableSettings);

const handleCancel = () => {
  emits('cancel')
}

const handleConfirm = () => {
  const selectedRowKeys = tableSettings.table.selectedRowKeys || [];
  if (!selectedRowKeys.length) {
    return notification.error({
      message: t('message.notification'),
      description: t('description.Please select at least one attachment!')
    })
  }
  const rowKey = tableSettings.table.rowKey || 'id'
  const fileList = tableSettings.table.dataSource?.filter(item => selectedRowKeys.includes(item[rowKey]))
  tableSettings.selectChange([])
  emits('confirm', fileList)
}

const resetCount = computed(() => {
  if (!props.maxCount) return;
  const selectedRowKeys = tableSettings.table.selectedRowKeys || []
  return props.maxCount - selectedRowKeys.length
})

defineOptions({
  name: "SelectFileModal"
})
</script>

<template>
  <i-modal
    :open="open"
    :title="title"
    width="60%"
    @cancel="handleCancel"
    @confirm="handleConfirm"
  >
    <i-crud class="select-file-table">
      <template #afterLeftAction v-if="maxCount">
        还可以选择 <span class="reset-count">{{ resetCount }}</span> 项
      </template>
      <template #url="{value,record}">
        <preview-file file-type="thumbnail" :name="record.name" :url="value"/>
      </template>
      <template #uploadCountSearch="{value,record}">
        <a-input-group compact>
          <a-form-item-rest>
            <a-input-number
              min="0"
            />
            <a-input
              class="input-middleware"
              placeholder="至"
              disabled
            />
            <a-input-number
              min="0"
            />
          </a-form-item-rest>
        </a-input-group>
      </template>
    </i-crud>
  </i-modal>
</template>

<style lang="less" scoped>
@import "index.less";
</style>
