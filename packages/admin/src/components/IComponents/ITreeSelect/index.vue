<script setup lang="ts">
import {computed, h, shallowRef, watchEffect} from "vue";
import {treeForEach} from "@/utils/tree";
import {TreeSelect} from "ant-design-vue";
import {ITreeSelectProps} from "@/types/treeSelect";
import {cloneDeep} from "lodash-es";

const props = withDefaults(defineProps<ITreeSelectProps>(), {
  multiple: false,
  treeNodeFilterProp: "label",
  showSearch: true,
  allowClear: true,
  treePathAll: false,
  spliceParentTitle: false,
  treeDefaultExpandAll: false,
  maxTagCount: 1,
  showCheckedStrategy: TreeSelect.SHOW_ALL,
  dropdownStyle: () => ({maxHeight: "400px", overflow: "auto"}),
  fieldNames: () => ({label: "label", value: "value", children: "children"}),
});

const emits = defineEmits(["update:value", 'change']);

const tooltipTitle = shallowRef<string[]>([]);

const handleChange = (value: ITreeSelectProps['value'], label?: string[], extra?: any) => {
  // console.log('value', value, label, extra)
  emits("update:value", value);
  emits("change", value, label, extra);
  calculateTitle(value, label)
};

const calculateTitle = (value: ITreeSelectProps['value'], label?: string[]) => {
  // 浅层监听即可
  if (
    props.multiple
    && Array.isArray(value) && value.length
    && Array.isArray(props.treeData) && props.treeData.length
  ) {
    // 拼接父级标题 | 没有 label 传入（change事件才有传入）
    if (props.spliceParentTitle || !label) {
      // 是否需要拼接父级标题
      const labelKey = props.fieldNames.label!
      const valueKey = props.fieldNames.value!
      const labels: string[] = []
      treeForEach<any>(cloneDeep(props.treeData), (item, _index, _arr, parent) => {
        if ((value as any[]).includes(item[valueKey])) {
          if (props.spliceParentTitle) {
            item.spliceTitle = [parent?.spliceTitle, item[labelKey]].filter(Boolean).join('-');
            labels.push(item.spliceTitle);
          } else {
            labels.push(item[labelKey])
          }
        }
      })
      tooltipTitle.value = labels;
    } else {
      tooltipTitle.value = label || [];
    }
  } else {
    if (tooltipTitle.value.length) {
      tooltipTitle.value = []
    }
  }
}

watchEffect(() => {
  /**
   * 多选时，初始化 tooltipTitle
   */
  calculateTitle(props.value)
})

const title = computed(() => {
  if (!props.multiple) return
  if (props.spliceParentTitle && tooltipTitle.value.length) {
    return tooltipTitle.value.map(str => {
      const newStr = str.split('-')
      const left = (newStr.length - 1) * 2
      return h('p', {
        class: 'mb-0',
        style: {
          marginLeft: `${left}rem`
        }
      }, '|- ' + newStr.splice(-1))
    })
  } else {
    return tooltipTitle.value.join("，");
  }
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
      :spliceParentTitle="undefined"
      @change="handleChange"
    />
  </a-tooltip>
</template>

<style lang="less">
.i-treeSelect-tooltip {
  .ant-tooltip-inner {
    color: #000;
    min-width: 300px;
    max-height: 300px;
    overflow: auto;
  }
}
</style>
