<!-- 切换语言 -->
<script setup lang="ts">
import {shallowRef} from "vue";
import {TranslationOutlined} from "@ant-design/icons-vue";
import {useI18n} from "vue-i18n";
import {$local} from "@/utils/storage";

const {locale} = useI18n();

const open = shallowRef(false); // 语言
const tooltipOpen = shallowRef(false); // 语言

// 设置语言
const handleLanguageChange = (lang: string) => {
  open.value = false;
  locale.value = lang;
  $local.set("lang", lang);
};

const handleOpenChange = (visible: boolean) => {
  tooltipOpen.value = !visible;
};

defineOptions({
  name: "NavLanguage",
});
</script>

<template>
  <a-popover
    v-model:open="open"
    trigger="click"
    overlayClassName="i-popover-menu"
    @click="tooltipOpen = false"
  >
    <template #content>
      <div
        class="i-popover-item"
        :class="{ active: locale === 'zh' }"
        @click="handleLanguageChange('zh')"
      >
        中文简体
      </div>
      <div
        class="i-popover-item"
        :class="{ active: locale === 'en' }"
        @click="handleLanguageChange('en')"
      >
        English
      </div>
    </template>
    <a-tooltip v-model:open="tooltipOpen" :title="$t('layout.header.title.language')">
      <div class="nav-menu-item">
        <translation-outlined/>
      </div>
    </a-tooltip>
  </a-popover>
</template>

<style lang="less" scoped>
@import "./index.less";
</style>
