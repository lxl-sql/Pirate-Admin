<!-- 基础配置 -->
<script setup lang="ts">
import {
  LineChartOutlined,
  FileTextFilled,
  TeamOutlined,
  SlidersOutlined,
  ArrowDownOutlined,
  ArrowUpOutlined,
} from "@ant-design/icons-vue";
import { onMounted, ref } from "vue";
import { CountUp } from "countup.js";
interface IPanelList {
  title: string;
  icon: any;
  color: string;
  value: number;
  rate: number;
  status: 1 | 0; // 1 是 0 否
}
const panelList = ref([
  {
    title: "会员注册量",
    icon: LineChartOutlined,
    color: "#8595f4",
    value: 1111,
    status: 1,
    rate: 10,
  },
  {
    title: "附件上传量",
    icon: FileTextFilled,
    color: "#ad85f4",
    value: 222,
    status: 1,
    rate: 10,
  },
  {
    title: "会员总数",
    icon: TeamOutlined,
    color: "#74a8b5",
    value: 222,
    rate: 10,
  },
  {
    title: "已装插件数",
    icon: SlidersOutlined,
    color: "#f48595",
    value: 222,
    rate: 10,
  },
]);
const numRef = ref();
onMounted(() => {
  // console.log(numRef.value, "numRef");
  numRef.value.forEach((item: IPanelList, i: number) => {
    const countUp = new CountUp(
      numRef.value[i], // 目标元素
      panelList.value[i].value // 结束值
    );
    countUp.start();
    // console.log(countUp, "countUpcountUp");
  });
});
</script>

<template>
  <a-row class="small-panel-box" :gutter="16">
    <a-col
      class="mb_16"
      :lg="6"
      :sm="12"
      :xs="24"
      v-for="(item, index) in panelList"
      :key="index"
    >
      <a-skeleton active :loading="!item" :paragraph="{ rows: 1 }">
        <div class="small-panel suspension">
          <div class="small-panel-title">
            {{ item.title }}
          </div>
          <div class="small-panel-content">
            <div class="content-left d-flex-default">
              <component
                :is="item.icon"
                class="content-icon mr_8"
                :style="{ color: `${item.color}` }"
              />
              <div class="number" ref="numRef">
                {{ item.value }}
              </div>
            </div>
            <div
              class="content-right"
              :style="{
                color: `var(${
                  item.status === 1 ? '--error-color' : '--success-color'
                })`,
              }"
            >
              <ArrowUpOutlined
                v-if="item.status === 1"
                style="font-size: 12px"
              />
              <ArrowDownOutlined v-else style="font-size: 12px" />{{
                item.rate
              }}%
            </div>
          </div>
        </div>
      </a-skeleton>
    </a-col>
  </a-row>
</template>

<style lang="less" scoped>
@import "./index.less";
</style>
