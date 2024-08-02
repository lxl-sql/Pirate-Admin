<script setup lang="ts">
import {computed, ref, toRaw, watch} from "vue";
import {treeForEach} from "@/utils/common";
import {TreeSelect} from "ant-design-vue";
import {ITreeSelectProps} from "@/types/treeSelect";

const props = withDefaults(defineProps<ITreeSelectProps>(), {
  multiple: false,
  treeNodeFilterProp: "label",
  showSearch: true,
  allowClear: true,
  spliceParentTitle: false,
  treeDefaultExpandAll: false,
  maxTagCount: 1,
  showCheckedStrategy: TreeSelect.SHOW_ALL,
  dropdownStyle: () => ({maxHeight: "400px", overflow: "auto"}),
  fieldNames: () => ({label: "label", value: "value", children: "children"}),
});
// console.log('props', props)

const emits = defineEmits(["update:value", 'change']);

const {spliceParentTitle, ...restProps} = toRaw(props);

const tooltipTitle = ref<undefined | number[] | string[]>(undefined);

watch(
  () => props.value,
  (value: any) => {
    if (props.multiple && Array.isArray(value)) {
      const labelKey = restProps.fieldNames.label!
      const valueKey = restProps.fieldNames.value!
      const labels: string[] = []
      treeForEach(props.treeData, (item: any) => {
        if (value.includes(item[valueKey])) {
          labels.push(item[labelKey])
        }
      })
      calculateTitle(props.value, labels)
    }
  }
);

const handleChange = (value: ITreeSelectProps['value'], label?: string[], extra?: any) => {
  emits("update:value", value);
  emits("change", value, label, extra);

  calculateTitle(value, label)
};

const calculateTitle = (value: ITreeSelectProps['value'], label?: string[]) => {
  if (props.multiple && value) {
    if (!spliceParentTitle) {
      tooltipTitle.value = label;
    } else {
      // 是否需要拼接父级标题
      const labelKey = restProps.fieldNames.label!
      const valueKey = restProps.fieldNames.value!
      const labels: string[] = []
      treeForEach(props.treeData, (item: any, _index, _arr, parent) => {
        if ((value as (string | number)[])?.includes(item[valueKey])) {
          item.spliceTitle = [parent?.spliceTitle, item[labelKey]].filter(Boolean).join('-');
          labels.push(item.spliceTitle);
        }
      })
      tooltipTitle.value = labels;
    }
  }
}

const title = computed(() => {
  return props.multiple && tooltipTitle.value?.join("，");
});

defineOptions({
  name: 'ITreeSelect'
})
</script>

<template>
  <a-tooltip
    placement="topLeft"
    color='#fff'
    :title="title"
    overlayClassName="i-treeSelect-tooltip"
  >
    <a-tree-select
      v-bind="props"
      @change="handleChange"
    />
  </a-tooltip>
</template>

<style lang="less">
.i-treeSelect-tooltip {
  .ant-tooltip-inner {
    color: #000;
    width: 300px;
  }
}
</style>
