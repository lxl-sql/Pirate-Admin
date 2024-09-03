<script setup lang="ts">
import {SettingOutlined} from "@ant-design/icons-vue";
import SettingDrawer from "./components/SettingDrawer/index.vue";
import {ref} from "vue";

const settingDrawerRef = ref()

const openSettingDrawer = () => {
  settingDrawerRef.value.init()
}

defineOptions({
  name: "NavSetting"
})
</script>

<template>
  <a-tooltip title="主题设置">
    <div class="nav-menu-item" @click="openSettingDrawer">
      <setting-outlined/>
    </div>
  </a-tooltip>
  <setting-drawer ref="settingDrawerRef"/>
</template>

<style scoped lang="less">

</style>
