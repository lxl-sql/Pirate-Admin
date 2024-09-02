<script setup lang="ts">
import {CloseOutlined} from "@ant-design/icons-vue";
import {shallowRef} from "vue";
import {useTheme} from "@/store/hooks";

const open = shallowRef<boolean>(false)

const theme = useTheme()

const init = () => {
  open.value = true
}

const handleClose = () => {
  open.value = false
}

defineOptions({
  name: "SettingDrawer"
})
defineExpose({
  init
})
</script>

<template>
  <a-drawer
    v-model:open="open"
    title="布局配置"
    placement="right"
    :closable="false"
  >
    <template #extra>
      <close-outlined class="ant-drawer-close !me-0" @click="handleClose"/>
    </template>
    <!-- 仅限PC端 -->
    <div class="mb-2">布局方式</div>
    <div class="mb-4">
      <a-row :gutter="[16,16]">
        <a-col :span="12">
          <div
            class="layout-method-item py-1 px-2 flex after:!content-['默认']"
            :class="{'layout-active': theme.layoutMode === 'default'}"
            @click="theme.changeLayoutMode('default')"
          >
            <div class="layout-method-item__sider mr-2"></div>
            <div class="flex-1 flex flex-col">
              <div class="layout-method-item__nav mb-2"></div>
              <div class="layout-method-item__view flex-1"></div>
            </div>
          </div>
        </a-col>
        <a-col :span="12">
          <div
            class="layout-method-item flex after:!content-['经典']"
            :class="{'layout-active': theme.layoutMode === 'classic'}"
            @click="theme.changeLayoutMode('classic')"
          >
            <div class="layout-method-item__sider"></div>
            <div class="flex-1 flex flex-col">
              <div class="layout-method-item__nav"></div>
              <div class="layout-method-item__view"></div>
            </div>
          </div>
        </a-col>
        <a-col :span="12">
          <div
            class="layout-method-item after:!content-['单栏']"
            :class="{'layout-active': theme.layoutMode === 'single-column'}"
            @click="theme.changeLayoutMode('single-column')"
          >
            <div class="layout-method-item__nav"></div>
            <div class="layout-method-item__view"></div>
          </div>
        </a-col>
        <a-col :span="12">
          <div
            class="layout-method-item flex after:!content-['双栏']"
            :class="{'layout-active': theme.layoutMode === 'double-column'}"
            @click="theme.changeLayoutMode('double-column')"
          >
            <div class="layout-method-item__sider !bg-[var(--colorBgLayoutNav)]"></div>
            <div class="flex-1 flex flex-col">
              <div class="layout-method-item__nav"></div>
              <div class="layout-method-item__view"></div>
            </div>
          </div>
        </a-col>
      </a-row>
    </div>
    <div class="mb-2">推荐主题色</div>
    <div class="flex flex-wrap mb-4">
      <div
        v-for="option in theme.themeColorOptions"
        :key="option.value"
        class="flex items-center text-xs cursor-pointer transition duration-300 hover:opacity-70 m-1.5"
        :class="{checked: theme.themeColor === option.value}"
        @click="theme.changeThemeColor(option.value)"
      >
          <span
            class="checked-inner box-border flex items-center justify-center w-[16px] h-[16px] rounded mr-1"
            :style="{backgroundColor:option.value}"
          >
          </span>
        {{ option.label }}
      </div>
    </div>
    <div class="mb-2">自定义主题色</div>
    <div class="flex items-center mb-4">
      <input
        type="color"
        :value="theme.themeColor"
        class="mr-2"
        @change="theme.changeThemeColor(($event.target as any)?.value)"
      >
      {{ theme.themeColor }}
    </div>
    <div class="mb-2">侧边菜单手风琴</div>
    <div class="flex items-center mb-4">
      <a-switch
        v-model:checked="theme.menuUniqueOpened"
        @change="(value:boolean) => theme.changeStoreConfigLayout<boolean>('menuUniqueOpened',value)"
      />
    </div>
  </a-drawer>
</template>

<style scoped lang="less">
@import "./index.less";
</style>
