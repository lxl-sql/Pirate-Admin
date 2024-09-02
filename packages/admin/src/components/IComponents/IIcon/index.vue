<!-- 图标配置 -->
<script setup lang="ts">
import {computed, nextTick, onMounted, onUnmounted, ref, unref, watch} from "vue";
import * as antIcons from "@ant-design/icons-vue";
import {SyncOutlined} from "@ant-design/icons-vue";
import {notification} from "ant-design-vue";
import {cloneDeep, debounce} from 'lodash-es'
import type {IconProps} from "@/types/icon";

const props = withDefaults(defineProps<IconProps>(), {
  open: false,
  defaultValue: 'LineOutlined'
})

const emits = defineEmits(["update:open", "update:value"]);

defineOptions({
  name: 'IIcon'
})

//#region 变量
const outlinedList = ref<string[]>([]);
const filledList = ref<string[]>([]);
const twoToneList = ref<string[]>([]);
const icons = ref<string[]>([]);
const iconTabs = ref<string[]>(["line", "fill", "twoTone", 'custom']);

const currentTab = ref<string>("");
const currentIcon = ref<string>(props.value || props.defaultValue); // 默认图标

const open = ref<boolean>(false);
//#endregion

onMounted(() => {
  emits('update:value', currentIcon.value);
  initIcon();
});

onUnmounted(() => {
  if (props.nullOnUnmounted) {
    emits('update:value', null);
  }
  currentIcon.value = props.defaultValue;
});

watch(
  () => props.value,
  (value) => {
    if (value) {
      currentIcon.value = value;
    }
  }
)

// 初始化icon
const initIcon = () => {
  // console.time("initIcon");
  const _antIcons = Object.keys(antIcons);
  const _outlinedList: string[] = [];
  const _filledList: string[] = [];
  const _twoToneList: string[] = [];

  for (let i = 0; i < _antIcons.length; i++) {
    const key = _antIcons[i];
    if (key.slice(-8) === "Outlined") {
      _outlinedList.push(key);
    } else if (key.slice(-6) === "Filled") {
      _filledList.push(key);
    } else if (key.slice(-7) === "TwoTone") {
      _twoToneList.push(key);
    }
  }
  outlinedList.value = _outlinedList;
  filledList.value = _filledList;
  twoToneList.value = _twoToneList;

  icons.value = _outlinedList;
  [currentTab.value] = unref(iconTabs); // 默认展示第一条
  console.timeEnd("initIcon");
};
// 刷新所有图标
const onLoad = () => {
  currentIcon.value = props.defaultValue;
  emits('update:value', props.defaultValue);
};
// 切换图标 tab
const checkIconTab = (type: string) => {
  const maps = new Map();
  maps.set("line", outlinedList.value);
  maps.set("fill", filledList.value);
  maps.set("twoTone", twoToneList.value);
  if (maps.has(type)) {
    currentTab.value = type;
    icons.value = maps.get(type);
  } else {
    notification.error({
      message: "没有此图标分类",
    });
  }
};

// 选择图标 icon
const checkIcon = (key: string) => {
  open.value = false;
  nextTick(() => {
    currentIcon.value = key;
    emits('update:value', key);
  });
};

const handleSearchInput = debounce((e: KeyboardEvent) => {
  const {value} = e.target as HTMLInputElement;
  const currentTabValue = currentTab.value;

  // 一定要 克隆一份，不然会出现数据污染
  const listEnum = {
    line: cloneDeep(outlinedList.value),
    fill: cloneDeep(filledList.value),
    twoTone: cloneDeep(twoToneList.value),
  }
  if (listEnum[currentTabValue] && value) {
    icons.value = listEnum[currentTabValue].filter((item: string) => item.toLocaleLowerCase().includes(value.toLocaleLowerCase()));
  } else {
    icons.value = listEnum[currentTabValue];
  }
  console.log("handleSearchInput", value);
}, 300);

const antIconComputed = computed(() => antIcons[currentIcon.value]);
</script>

<template>
  <a-popover
    v-model:open="open"
    placement="bottom"
    trigger="click"
    class="icon"
  >
    <template #title>
      <div class="icons-title">
        请选择图标
        <div class="icons-tab">
          <span
            v-for="item in iconTabs"
            :key="item"
            class="tab-item"
            :class="{ active: item === currentTab }"
            @click="checkIconTab(item)"
          >
            {{ item }}
          </span>
        </div>
      </div>
    </template>
    <template #content>
      <div class="icons-content">
        <div
          class="icons-item"
          :class="{active:currentIcon === icon}"
          v-for="icon in icons"
          :key="icon"
          @click="checkIcon(icon)"
        >
          <component :is="antIcons[icon]" style="font-size: 20px"/>
        </div>
      </div>
    </template>
    <a-input placeholder="搜索图标" @input="handleSearchInput">
      <template #addonBefore>
        <component :is="antIconComputed"/>
        {{ currentIcon }}
      </template>
      <template #addonAfter>
        <sync-outlined @click="onLoad"/>
      </template>
    </a-input>
  </a-popover>
</template>

<style lang="less" scoped>
@import "./index.less";
</style>
