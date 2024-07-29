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
  <div class="nav-menu-item" title="设置" @click="openSettingDrawer">
    <setting-outlined/>
  </div>
  <setting-drawer ref="settingDrawerRef"/>
</template>

<style scoped lang="less">

</style>
