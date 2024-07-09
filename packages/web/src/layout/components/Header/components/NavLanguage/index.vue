<!-- 首页 -->
<script setup lang="ts">
import {defineOptions, ref} from "vue";
import {TranslationOutlined} from "@ant-design/icons-vue";
import {useI18n} from "vue-i18n";

const {locale} = useI18n();

const open = ref(false); // 语言

// 设置语言
const putLanguage = (lang: string) => {
  open.value = false;
  locale.value = lang;
  localStorage.setItem("lang", lang);
};

defineOptions({
  name: "NavLanguage",
});
</script>

<template>
  <a-popover
    v-model:open="open"
    :trigger="['click']"
    overlayClassName="i-popover-menu"
  >
    <template #content>
      <div
        class="i-popover-item"
        :class="{ active: locale === 'zh' }"
        @click="putLanguage('zh')"
      >
        中文简体
      </div>
      <div
        class="i-popover-item"
        :class="{ active: locale === 'en' }"
        @click="putLanguage('en')"
      >
        English
      </div>
    </template>
    <div class="nav-menu-item" title="切换语言">
      <translation-outlined/>
    </div>
  </a-popover>
</template>

<style lang="less" scoped>
@import "./index.less";
</style>
