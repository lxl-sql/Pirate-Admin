<!-- 基础配置 -->
<script setup lang="ts">
import { onMounted, ref, getCurrentInstance, reactive, onUnmounted } from "vue";
import { UserOutlined, RightOutlined } from "@ant-design/icons-vue";
const { proxy } = getCurrentInstance() as any;
const inits = reactive({
  userChart: null as any,
});
const charts = ref<any>([]);
const userChartRef = ref();
const fileChartRef = ref();
onMounted(() => {
  // console.log(proxy.$echarts);
  initUserChart();
  initFileChart();

  window.addEventListener("resize", resize);
});
onUnmounted(() => {
  window.removeEventListener("resize", resize);
});

const resize = () => {
  charts.value.forEach((item: any) => {
    item.resize();
  });
};
// 会员增长情况注册
const initUserChart = () => {
  const userGrowthChart = proxy.$echarts.init(userChartRef.value);

  const option = {
    xAxis: {
      type: "category",
      boundaryGap: false,
      data: ["周一", "周二", "周三", "周四", "周五", "周六", "周日"],
    },
    yAxis: {
      type: "value",
    },
    tooltip: {
      trigger: "axis",
      axisPointer: {
        type: "cross",
        label: {
          backgroundColor: "#6a7985",
        },
      },
    },
    grid: {
      top: "3%",
      left: "3%",
      right: "3%",
      bottom: "0%",
      containLabel: true,
    },
    toolbox: {
      feature: {
        saveAsImage: {
          title: "保存",
        },
      },
    },
    legend: {
      data: ["访问量", "注册量"],
    },
    series: [
      {
        name: "访问量",
        data: [820, 932, 90, 656, 326, 22, 123],
        type: "line",
        areaStyle: {
          color: "#F9C2CA",
        }, // 背景色
        smooth: true, // 平滑
        emphasis: {
          focus: "series",
        },
      },
      {
        name: "注册量",
        data: [221, 322, 901, 934, 1290, 1330, 1320],
        type: "line",
        areaStyle: {
          color: "#A9B5F7",
        }, // 背景色
        smooth: true, // 平滑
        emphasis: {
          focus: "series",
        },
      },
    ],
  };
  userGrowthChart.setOption(option);

  charts.value.push(userGrowthChart);
};
const initFileChart = () => {
  const fileGrowthChart = proxy.$echarts.init(fileChartRef.value);
  const option = {
    grid: {
      top: 30,
      right: 0,
      bottom: 20,
      left: 0,
    },
    tooltip: {
      trigger: "item",
    },
    legend: {
      type: "scroll",
      bottom: 15,
      data: (function () {
        var list: any = [];
        for (var i = 1; i <= 12; i++) {
          list.push(i + "月");
        }
        return list;
      })(),
      textStyle: {
        color: "#73767a",
      },
    },
    visualMap: {
      top: "middle",
      right: 10,
      color: ["red", "yellow"],
      calculable: true,
    },
    radar: {
      indicator: [
        { name: "图片" },
        { name: "文档" },
        { name: "表格" },
        { name: "压缩包" },
      ],
    },
    series: (function () {
      var series: any = [];
      for (var i = 1; i <= 12; i++) {
        const serie = {
          type: "radar",
          symbol: "none",
          lineStyle: {
            width: 1,
          },
          emphasis: {
            areaStyle: {
              color: "rgba(0,250,0,0.3)",
            },
          },
          data: [
            {
              value: [(40 - i) * 10, (38 - i) * 4 + 60, i * 5 + 10, i * 20],
              name: i + "月",
            },
          ],
        };
        series.push(serie);
      }
      return series;
    })(),
  };
  fileGrowthChart.setOption(option);

  charts.value.push(fileGrowthChart);
};
//
</script>

<template>
  <a-row class="chart1" :gutter="16">
    <a-col :lg="18" :xs="24" class="mb_16">
      <a-card hoverable title="会员增长情况">
        <div ref="userChartRef" class="user-growth-chart"></div>
      </a-card>
    </a-col>

    <a-col :lg="6" :xs="24" class="is1200 mb_16">
      <a-card hoverable title="刚刚加入会员" class="new-user-card">
        <template #actions>
          <div class="new-users-growth">
            <div class="new-user-item">
              <a-avatar :size="48">
                <template #icon>
                  <UserOutlined style="font-size: 48px" />
                </template>
              </a-avatar>
              <div class="new-user-base ellipsis">
                <div class="new-user-name ellipsis">Admin</div>
                <div class="new-user-time ellipsis">12分钟前加入了我们</div>
              </div>
              <RightOutlined
                style="margin-left: auto; color: var(--primary-color)"
              />
            </div>
            <div class="new-user-item">
              <a-avatar :size="48">
                <template #icon>
                  <UserOutlined style="font-size: 48px" />
                </template>
              </a-avatar>
              <div class="new-user-base ellipsis">
                <div class="new-user-name ellipsis">Admin</div>
                <div class="new-user-time ellipsis">12分钟前加入了我们</div>
              </div>
              <RightOutlined
                style="margin-left: auto; color: var(--primary-color)"
              />
            </div>
            <div class="new-user-item">
              <a-avatar :size="48">
                <template #icon>
                  <UserOutlined style="font-size: 48px" />
                </template>
              </a-avatar>
              <div class="new-user-base ellipsis">
                <div class="new-user-name ellipsis">Admin</div>
                <div class="new-user-time ellipsis">12分钟前加入了我们</div>
              </div>
              <RightOutlined
                style="margin-left: auto; color: var(--primary-color)"
              />
            </div>
            <div class="new-user-item">
              <a-avatar :size="48">
                <template #icon>
                  <UserOutlined style="font-size: 48px" />
                </template>
              </a-avatar>
              <div class="new-user-base ellipsis">
                <div class="new-user-name ellipsis">Admin</div>
                <div class="new-user-time ellipsis">12分钟前加入了我们</div>
              </div>
              <RightOutlined
                style="margin-left: auto; color: var(--primary-color)"
              />
            </div>
            <div class="new-user-item">
              <a-avatar :size="48">
                <template #icon>
                  <UserOutlined style="font-size: 48px" />
                </template>
              </a-avatar>
              <div class="new-user-base ellipsis">
                <div class="new-user-name ellipsis">Admin</div>
                <div class="new-user-time ellipsis">12分钟前加入了我们</div>
              </div>
              <RightOutlined
                style="margin-left: auto; color: var(--primary-color)"
              />
            </div>
          </div>
        </template>
      </a-card>
    </a-col>

    <a-col :lg="24" :xs="24">
      <a-card hoverable title="附件增长情况">
        <div ref="fileChartRef" class="file-growth-chart"></div>
      </a-card>
    </a-col>
  </a-row>
</template>

<style lang="less" scoped>
@import "./index.less";
</style>
