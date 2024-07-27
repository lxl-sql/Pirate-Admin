<!-- 详情 -基本信息 -->
<script setup lang="ts">
import { LeftOutlined, RightOutlined } from "@ant-design/icons-vue";


</script>

<template>
  <div class="detail-basic d-flex">
    <a-carousel arrows autoplay>
      <template #prevArrow>
        <div class="custom-slick-arrow">
          <left-outlined />
        </div>
      </template>
      <template #nextArrow>
        <div class="custom-slick-arrow">
          <right-outlined />
        </div>
      </template>
      <div>
        <a-image
          class="basic-img"
          src="data:image/jpeg;base64,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"
        />
      </div>
      <div><h3>2</h3></div>
      <div><h3>3</h3></div>
      <div><h3>4</h3></div>
    </a-carousel>
    <div class="basic-content">
      <strong class="basic-title">数据导入</strong>
      <div class="basic-tags"></div>
      <div class="content-item">
        <label>单价</label>
        <span class="content-item_price">3积分</span>
      </div>
      <div class="content-item">
        <label>最后更新</label>
        <span>2023-05-27 01:12:48</span>
      </div>
      <div class="content-item">
        <label>发布时间</label>
        <span>2023-05-27 01:12:48</span>
      </div>
      <div class="content-item">
        <label>下载次数</label>
        <span>123</span>
      </div>
      <div class="content-item">
        <label>模块分类</label>
        <b>基础设施</b>
      </div>
      <div class="content-item">
        <label>开发者主页</label>
        <span>-</span>
      </div>
      <a-button class="mt_8" type="primary" danger>立即购买</a-button>
    </div>
  </div>
</template>

<style lang="less" scoped>
@import "./index.less";
</style>
