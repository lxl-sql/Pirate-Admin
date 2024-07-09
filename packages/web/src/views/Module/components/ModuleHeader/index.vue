<!-- 模块下载 -->
<script setup lang="ts">
import {defineOptions} from "vue";
import {HomeOutlined, InfoCircleFilled, SyncOutlined, UploadOutlined, UserOutlined,} from "@ant-design/icons-vue";
import RocketSvgIcon from "@components/SvgIcon/rocket.vue";
import UploadCloudSvgIcon from "@components/SvgIcon/uploadCloud.vue";

const remark =
    "您可以在此页下载喜欢的系统模块，积分需要做任务来参与生态建设后获得，建议在开发环境（默认端口1818）安装模块";

const onReload = () => {
};

defineOptions({
  name: "ModuleHeader",
});
</script>

<template>
  <div class="module-header mb_16">
    <a-alert :message="remark" type="gray" show-icon closable>
      <template #icon>
        <info-circle-filled style="color: #909399"/>
      </template>
    </a-alert>
    <div class="header-menu-btn">
      <i-tooltip title="刷新" type="refresh" class="mr_8 mtb_4">
        <template #icon>
          <sync-outlined
              @click="onReload"
              style="color: #fff; font-size: 14px"
          />
        </template>
      </i-tooltip>
      <div class="ant-btn-group mr_8 mtb_4">
        <a-button type="primary" class="lock-active">
          <template #icon>
            <upload-outlined/>
          </template>
          上传安装
        </a-button>
        <a-button type="primary">
          <template #icon>
            <home-outlined/>
          </template>
          本地模块
        </a-button>
      </div>
      <div class="ant-btn-group mr_8 mtb_4">
        <i-button type="success">
          <template #icon>
            <upload-cloud-svg-icon/>
          </template>
          发布模块
        </i-button>
        <a-button type="success">
          <template #icon>
            <rocket-svg-icon/>
          </template>
          获得积分
        </a-button>
      </div>
      <a-button type="success" class="mtb_4">
        <template #icon>
          <user-outlined/>
        </template>
        会员信息
      </a-button>
    </div>
  </div>
</template>

<style lang="less" scoped>
@import "./index.less";
</style>
