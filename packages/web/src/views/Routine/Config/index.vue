<!-- 系统配置 -->
<script setup lang="ts">
import {nextTick, ref} from "vue";
import Basic from "./components/Basic/index.vue";
import Mail from "./components/Mail/index.vue";
import QuickAccess from "./components/QuickAccess/index.vue";
import AddConfigItemModal from "@/views/Routine/Config/components/AddConfigItemModal/index.vue";

const addConfigItemModalRef = ref()
const activeKey = ref<string>("1");

const handleTabClick = (key: string) => {
  const _key = activeKey.value;
  if (key === '4') {
    addConfigItemModalRef.value.init()
    nextTick(() => {
      activeKey.value = _key
    })
  } else {
    activeKey.value = key
  }
}
</script>

<template>
  <a-row class="default-main" :gutter="[16, 16]">
    <a-col :lg="16" :xs="24">
      <a-tabs
        v-model:activeKey="activeKey"
        type="card"
        class="main-card no-card"
        @tab-click="handleTabClick"
      >
        <a-tab-pane key="1" tab="基础配置">
          <div class="card-main is-always-shadow">
            <Basic/>
          </div>
        </a-tab-pane>
        <a-tab-pane key="2" tab="邮件配置">
          <div class="card-main is-always-shadow">
            <Mail/>
          </div>
        </a-tab-pane>
        <a-tab-pane key="3" tab="快捷配置入口">
          <div class="card-main is-always-shadow">
            <QuickAccess/>
          </div>
        </a-tab-pane>
        <a-tab-pane key="4" tab="新增配置项"/>
      </a-tabs>
      <add-config-item-modal ref="addConfigItemModalRef"/>
    </a-col>
    <a-col :lg="8" :xs="24">
      <div class="main-card is-always-shadow">
        <div class="card-head">快捷配置入口</div>
        <div class="card-main">
          <a-button size="small">快捷配置入口</a-button>
        </div>
      </div>
    </a-col>
  </a-row>
</template>

<style lang="less" scoped>
@import "./index.less";
</style>
