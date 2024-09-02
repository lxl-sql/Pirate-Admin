<!-- 配置文件 数据库/Redis 配置文件 -->
<script setup lang="ts">
import {ApiOutlined, CloudServerOutlined, DatabaseOutlined, LockOutlined, UserOutlined} from "@ant-design/icons-vue";
import {onBeforeUnmount, onMounted, reactive, ref} from "vue";
import * as pageBubble from "@/utils/pageBubble";
import {useI18n} from "vue-i18n";
import QuestionTooltip from "@/components/IComponents/IOther/QuestionTooltip/index.vue";

const {t} = useI18n();

const configState = reactive({
  host: '',
  port: 3306,
  username: '',
  password: '',
  database: '',
})
const loading = ref<boolean>(false)

onMounted(async () => {
  pageBubble.init();
});

onBeforeUnmount(() => {
  pageBubble.removeListeners();
});

// 提交
const onFinish = async () => {
};
</script>

<template>
  <div @contextmenu.stop id="bubble" class="bubble">
    <canvas id="bubble-canvas" class="bubble-canvas"></canvas>
  </div>
  <div class="config">
    <page-card :loading="loading">
      <template #title>
        <question-tooltip
          content="数据库配置"
          title="本项目使用 Docker 部署，当不填写时，使用默认数据库配置"
          icon-class-name="text-base"
        />
      </template>
      <a-form
        :model="configState"
        layout="vertical"
        @finish="onFinish"
      >
        <a-form-item label="Host" name="host">
          <a-input
            v-model:value="configState.host"
            allow-clear
            :placeholder="$t('placeholder.host')"
          >
            <template #prefix>
              <cloud-server-outlined/>
            </template>
          </a-input>
        </a-form-item>
        <a-form-item label="Port" name="port">
          <a-input-number
            v-model:value="configState.port"
            class="!w-full"
            min="1"
            max="65535"
            allow-clear
            :placeholder="$t('placeholder.port')"
          >
            <template #prefix>
              <api-outlined/>
            </template>
          </a-input-number>
        </a-form-item>
        <a-form-item label="Username" name="username">
          <a-input
            v-model:value="configState.username"
            allow-clear
            :placeholder="$t('placeholder.username')"
          >
            <template #prefix>
              <user-outlined/>
            </template>
          </a-input>
        </a-form-item>
        <a-form-item label="Password" name="password">
          <a-input-password
            v-model:value="configState.password"
            allow-clear
            autocomplete="new-password"
            :placeholder="$t('placeholder.password')"
          >
            <template #prefix>
              <lock-outlined/>
            </template>
          </a-input-password>
        </a-form-item>
        <a-form-item label="Database" name="database">
          <a-input
            v-model:value="configState.database"
            allow-clear
            :placeholder="$t('placeholder.database')"
          >
            <template #prefix>
              <database-outlined/>
            </template>
          </a-input>
        </a-form-item>
        <a-form-item>
          <a-button
            class="w-full !rounded-full !h-[40px]"
            type="primary"
            html-type="submit"
          >
            保存
          </a-button>
        </a-form-item>
      </a-form>
    </page-card>
  </div>
</template>

<style lang="less" scoped>
@import "./index.less";
</style>

