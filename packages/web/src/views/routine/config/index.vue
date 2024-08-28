<!-- 系统配置 -->
<script setup lang="ts">
import {nextTick, onMounted, provide, Ref, ref} from "vue";
import AddConfigItemModal from "./components/AddConfigItemModal/index.vue";
import ConfigItem from "./components/ConfigItem/index.vue";
import {getConfig} from "@/api/routine/config";

interface Group {
  // 字段名
  name: string
  // 字段标题
  title: string
}

interface Entrance {
  // 字段名
  key: string
  // 字段标题
  value: string
}

const configItemRef = ref()
const addConfigItemModalRef = ref()
const configGroupList = ref<Group[]>([])
const quickEntrance = ref<Entrance[]>([])
const config = ref({})
const activeKey = ref<string>("0");

provide<Ref<Group[]>>('configGroupList', configGroupList)

onMounted(async () => {
  await init()
})

const init = async () => {
  const {data} = await getConfig()
  await onConfirm(data)
}

const handleTabClick = (key: string) => {
  const _key = activeKey.value;
  if (key === '-1') {
    addConfigItemModalRef.value.init()
    nextTick(() => {
      activeKey.value = _key
    })
  } else {
    activeKey.value = key
    nextTick(() => {
      const _ref = configItemRef.value[key]
      _ref?.init()
    })
  }
}

const onConfirm = async (data) => {
  configGroupList.value = data.configGroup
  config.value = data.config
  quickEntrance.value = data.quickEntrance
  await nextTick(() => {
    const _ref = configItemRef.value[+activeKey.value]
    _ref?.init()
  })
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
          :key="`${index}`"
          :tab="group.title"
          force-render
        >
          <div class="card-main is-always-shadow">
            <config-item
              v-if="config[group.name]?.length"
              ref="configItemRef"
              :items="config[group.name]"
              @confirm="onConfirm"
            />
            <a-empty v-else/>
          </div>
        </a-tab-pane>
        <a-tab-pane key="-1" tab="新增配置项" />
      </a-tabs>
      <a-empty
        v-if="!configGroupList?.length"
        class="pt-4"
        description="暂无配置项"
      />
      <add-config-item-modal
        ref="addConfigItemModalRef"
        @confirm="init"
      />
    </a-col>
    <a-col :lg="8" :xs="24">
      <div class="main-card is-always-shadow">
        <div class="card-head">快捷配置入口</div>
        <div class="card-main">
          <template v-if="quickEntrance.length">
            <a-button
              v-for="item in quickEntrance"
              :key="item.key"
              size="small"
              @click="$router.push(item.value)"
            >
              {{ item.key }}
            </a-button>
          </template>
          <a-empty v-else/>
        </div>
      </div>
    </a-col>
  </a-row>
</template>

<style lang="less" scoped>
@import "./index.less";
</style>
