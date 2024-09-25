<script setup lang="ts">
import {DragOutlined, EditOutlined, ZoomInOutlined} from "@ant-design/icons-vue";
import {inject} from "vue";
import {TableSettingsType} from "@/types/tableSettingsType";
import {tableSettingKey} from "@/utils/tableSettings";
import {Key} from "@/types";

interface OperationProps {
  operations: string[],
  score: Record<string, any>,
  rowKey: Key
}

const props = withDefaults(defineProps<OperationProps>(), {
  operations: [],
  score: () => ({}),
  rowKey: 'id'
})

const setting = inject<TableSettingsType>(tableSettingKey, {} as any);

defineOptions({
  name: "Operation"
})
</script>

<template>
  <a-space>
    <!-- 排序 -->
    <i-tooltip
      v-if="operations.includes('row-sortable')"
      title="拖动以排序"
      size="small"
      type="info"
      class="drag-row-item"
    >
      <template #icon>
        <drag-outlined/>
      </template>
    </i-tooltip>
    <!-- 详情 -->
    <i-tooltip
      v-if="operations.includes('row-detail')"
      :title="$t('title.detail')"
      size="small"
      @click="setting.openDetail(score.record[rowKey])"
    >
      <template #icon>
        <zoom-in-outlined/>
      </template>
    </i-tooltip>
    <!-- 编辑 -->
    <i-tooltip
      v-if="operations.includes('row-update')"
      :title="$t('title.update')"
      size="small"
      @click="setting.openForm(1, score.record[rowKey])"
    >
      <template #icon>
        <edit-outlined/>
      </template>
    </i-tooltip>
    <!-- 删除 -->
    <i-tooltip
      v-if="operations.includes('row-delete')"
      :title="$t('title.delete')"
    >
      <delete-popconfirm
        size="small"
        placement="leftTop"
        @confirm="setting.deleteByIds('row-delete', [score.record.id])"
      />
    </i-tooltip>
  </a-space>
</template>

<style scoped lang="less">

</style>
