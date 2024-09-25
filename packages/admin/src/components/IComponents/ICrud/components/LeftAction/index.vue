<script setup lang="ts">
import {PlusOutlined, ReloadOutlined} from "@ant-design/icons-vue";
import {computed, inject} from "vue";
import {TableSettingsType} from "@/types/tableSettingsType";
import {tableSettingKey} from "@/utils/tableSettings";

interface LeftActionsProps {
  operations: string[]
}

const props = withDefaults(defineProps<LeftActionsProps>(), {
  operations: []
})

const setting = inject<TableSettingsType>(tableSettingKey, {} as any);

const table = computed(() => setting.table);

const selectedRowKeys = computed(
  () => table.value?.selectedRowKeys || []
);

/** @param hasTableChild {boolean} 列表数据是否有 children */
const hasTableChild = computed(() => {
  return props.operations.includes('expand') && table.value.dataSource?.some(item => item.children?.length)
})

/** @param expandAllRowsDisabled {boolean} 是否禁用 展开/收起 按钮 */
const expandAllRowsDisabled = computed(() => {
  return props.operations.includes('expand') && table.value.dataSource?.length && hasTableChild.value
})

defineOptions({
  name: "LeftAction"
})
</script>

<template>
  <a-space>
    <slot name="leftActionBefore"></slot>
    <i-tooltip
      v-if="operations.includes('refresh')"
      :title="$t('title.refresh')"
      type="refresh"
      @click="setting.queryAll"
    >
      <template #icon>
        <reload-outlined :spin="setting.table.loading"/>
      </template>
    </i-tooltip>
    <slot name="refreshActionAfter"></slot>
    <i-tooltip
      v-if="operations.includes('create')"
      :title="$t('title.create')"
      :content="$t('title.create')"
      @click="setting.openForm(0)"
    >
      <template #icon>
        <plus-outlined/>
      </template>
    </i-tooltip>
    <i-tooltip
      v-if="operations.includes('delete')"
      :title="$t('title.remove_selected_row')"
    >
      <delete-popconfirm
        placement="rightTop"
        size="middle"
        :button-text="$t('title.delete')"
        :disabled="!selectedRowKeys.length"
        @confirm="setting.deleteByIds('delete', selectedRowKeys)"
      />
    </i-tooltip>
    <expand-all-rows-tooltip
      v-if="operations.includes('expand')"
      v-model:expand="table.defaultExpandAllRows"
      :disabled="!expandAllRowsDisabled"
    />
    <slot name="leftActionAfter"></slot>
  </a-space>
</template>
