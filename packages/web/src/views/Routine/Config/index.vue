<!-- 系统配置 -->
<script setup lang="ts">
import {nextTick, onMounted, provide, Ref, ref} from "vue";
import AddConfigItemModal from "./components/AddConfigItemModal/index.vue";
import ConfigItem from "./components/ConfigItem/index.vue";
import {getConfig} from "@/api/routine/config";

interface GroupList {
  // 字段名
  name: string
  // 字段标题
  title: string
}

const addConfigItemModalRef = ref()
const configGroupList = ref<GroupList[]>([])
const config = ref({})
const activeKey = ref<string>("1");

provide<Ref<GroupList[]>>('configGroupList', configGroupList)

onMounted(async () => {
  await init()
})

const init = async () => {
  const {data} = await getConfig()
  configGroupList.value = data.configGroup
  config.value = data.config
}

const handleTabClick = (key: string) => {
  const _key = activeKey.value;
  if (key === '0') {
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
        <a-tab-pane
          v-for="(group,index) in configGroupList"
          :key="`${index + 1}`"
          :tab="group.title"
        >
          <div class="card-main is-always-shadow">
            <ConfigItem :items="config[group.name]"/>
          </div>
        </a-tab-pane>
        <a-tab-pane key="0" tab="新增配置项"/>
      </a-tabs>
      <add-config-item-modal
        ref="addConfigItemModalRef"
        @confirm="init"
      />
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
