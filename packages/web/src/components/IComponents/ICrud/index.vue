<!-- CRUD -->
<script setup lang="ts">
import {computed, inject} from "vue";
import {DragOutlined, EditOutlined, PlusOutlined, ReloadOutlined, ZoomInOutlined} from "@ant-design/icons-vue";
import {sortNumber} from "@/utils/common";
import {TableSettingsType} from "@/types/tableSettingsType";
import {tableSettingKey} from "@/utils/tableSettings";
import ITooltip from "@/components/IComponents/ITooltip/index.vue";
import ICrudFormModal from "./components/ICrudFormModal/index.vue";
import ICrudDetailModal from "./components/ICrudDetailModal/index.vue";

const tableSettings = inject<TableSettingsType>(tableSettingKey, {} as any);

const table = computed(() => tableSettings?.table)

/** @param operations {Operation[]} 展示的操作按钮 */
const operations = computed(() => table.value?.operations || []);

const selectedRowKeys = computed(
  () => table.value?.selectedRowKeys || []
);

const rowSelection = computed(() => ({
  selectedRowKeys: table.value?.selectedRowKeys,
  onChange: tableSettings?.selectChange,
  ...table.value?.rowSelection,
}));

/** @param hasTableChild {boolean} 列表数据是否有 children */
const hasTableChild = computed(() => operations.value.includes('expand') && table.value?.dataSource?.some(item => item.children?.length))

/** @param expandAllRowsDisabled {boolean} 是否禁用 展开/收起 按钮 */
const expandAllRowsDisabled = computed(() => operations.value.includes('expand') && table.value?.dataSource?.length && hasTableChild.value)

defineOptions({
  name: "ICrud",
});
</script>

<template>
  <div>
    <i-table
      v-bind="table"
      :model="table?.queryForm"
      :row-selection="rowSelection"
      :default-span="table?.defaultSpan"
      @refresh="tableSettings?.queryAll"
      @query="tableSettings?.queryAll"
      @reset="tableSettings?.queryAll"
      @pages-change="tableSettings?.pagesChange"
    >
      <template #leftActions>
        <slot name="beforeLeftAction"></slot>
        <i-tooltip
          v-if="operations.includes('refresh')"
          :title="$t('title.refresh')"
          type="refresh"
          @click="tableSettings?.queryAll"
        >
          <template #icon>
            <reload-outlined :spin="tableSettings.table.loading"/>
          </template>
        </i-tooltip>
        <slot name="afterActionRefresh"></slot>
        <i-tooltip
          v-if="operations.includes('create')"
          :title="$t('title.create')"
          :content="$t('title.create')"
          @click="tableSettings?.openForm(0)"
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
            @confirm="tableSettings?.deleteByIds('delete', selectedRowKeys)"
          />
        </i-tooltip>
        <expand-all-rows-tooltip
          v-if="operations.includes('expand')"
          v-model:expand="table.defaultExpandAllRows"
          :disabled="!expandAllRowsDisabled"
        />
        <slot name="afterLeftAction"></slot>
      </template>
      <template #bodyCell="score">
        <slot v-if="score.column.dataIndex === 'number'" name="number" v-bind="score">
          {{ sortNumber(score.index, table.pages) }}
        </slot>
        <slot v-else-if="score.column.dataIndex === 'operation'" name="operation" v-bind="score">
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
              @click="tableSettings?.openDetail(score.record[table.rowKey!])"
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
              @click="tableSettings?.openForm(1, score.record.id)"
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
                @confirm="tableSettings?.deleteByIds('row-delete', [score.record.id])"
              />
            </i-tooltip>
          </a-space>
        </slot>
        <slot v-else :name="score.column.dataIndex" v-bind="score"></slot>
      </template>
      <template #table="scope">
        <slot name="table" v-bind="scope"></slot>
      </template>
    </i-table>

    <!--  表单自定义 需要带上 form 前缀  -->
    <i-crud-form-modal v-if="table?.displayFormModal">
      <template #field="score">
        <template v-if="score.column.formSlot !== false">
          <slot :name="`form-${score.column.dataIndex}`" v-bind="score"/>
        </template>
      </template>
    </i-crud-form-modal>

    <!--  详情自定义 需要带上 detail 前缀  -->
    <i-crud-detail-modal v-if="table?.displayDetailModal">
      <template #field="score">
        <template v-if="score.column.detailSlot !== false">
          <slot :name="`detail-${score.column.dataIndex}`" v-bind="score"/>
        </template>
      </template>
    </i-crud-detail-modal>
  </div>
</template>
