<script setup lang="ts">
import {computed, provide} from "vue";
import {sortNumber} from "@/utils/common";
import {TableSettingsType} from "@/types/tableSettingsType";
import {tableSettingKey} from "@/utils/tableSettings";
import Operation from "./components/Operation/index.vue";
import LeftAction from "./components/LeftAction/index.vue";

interface ICrudProps {
  setting: TableSettingsType
}

const props = withDefaults(defineProps<ICrudProps>(), {
  setting: {}
})

const tableSettings = props.setting

const table = computed(() => props.setting.table || {})

/** @param operations {Operation[]} 展示的操作按钮 */
const operations = computed(() => table.value.operations || []);


const rowSelection = computed(() => {
  if (!table.value.rowSelection) return null
  return {
    selectedRowKeys: table.value.selectedRowKeys,
    onChange: props.setting.selectChange,
    ...table.value.rowSelection,
  }
});

provide(tableSettingKey, props.setting);

defineOptions({
  name: "ICrud",
});
</script>

<template>
  <div>
    <i-table
      v-bind="table"
      :model="table.queryForm"
      :row-selection="rowSelection"
      :default-span="table.defaultSpan"
      @refresh="setting.queryAll"
      @query="setting.queryAll"
      @reset="setting.queryAll"
      @pages-change="setting.pagesChange"
    >
      <template #leftActions>
        <left-action :operations="operations">
          <template
            v-for="name in ['leftActionBefore','refreshActionAfter','leftActionAfter']"
            :key="name"
            v-slot:[name]="scope"
          >
            <slot :name="name" v-bind="scope"></slot>
          </template>
        </left-action>
      </template>
      <template #bodyCell="score">
        <slot v-if="score.column.dataIndex === 'number'" name="number" v-bind="score">
          {{ sortNumber(score.index, table.pages) }}
        </slot>
        <slot v-else-if="score.column.dataIndex === 'operation'" name="operation" v-bind="score">
          <operation :operations="operations" :score="score" :row-key="table.rowKey"/>
        </slot>
        <slot v-else :name="score.column.dataIndex" v-bind="score"></slot>
      </template>
      <template #table="scope">
        <slot name="table" v-bind="scope"></slot>
      </template>
    </i-table>

    <!--  表单自定义 需要带上 form 前缀  -->
    <i-crud-form-modal v-if="table.displayFormModal">
      <template #field="score">
        <slot
          v-if="score.column.formSlot !== false"
          :name="`form-${score.column.dataIndex}`"
          v-bind="score"
        />
      </template>
      <template
        v-for="name in ['formAfter']"
        :key="name"
        v-slot:[name]="scope"
      >
        <slot :name="name" v-bind="scope"></slot>
      </template>
    </i-crud-form-modal>

    <!--  详情自定义 需要带上 detail 前缀  -->
    <i-crud-detail-modal v-if="table.displayDetailModal">
      <template #field="score">
        <slot
          v-if="score.column.detailSlot !== false"
          :name="`detail-${score.column.dataIndex}`"
          v-bind="score"
        />
      </template>
      <template
        v-for="name in ['detailAfter']"
        :key="name"
        v-slot:[name]="scope"
      >
        <slot :name="name" v-bind="scope"></slot>
      </template>
    </i-crud-detail-modal>

    <slot></slot>
  </div>
</template>
