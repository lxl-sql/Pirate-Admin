<!-- 详情 - 作者信息 -->
<script lang="ts">
import {ref} from "vue";
import {Empty} from "ant-design-vue";
</script>
<script setup lang="ts">
const simpleImage = ref(Empty.PRESENTED_IMAGE_SIMPLE);
</script>

<template>
  <div class="detail-author">
    <strong class="detail-title">作者信息</strong>
    <div class="author-info mb_16">
      <img src="@/assets/svg/logo.svg" alt="" class="author-img mr_8"/>
      <div>
        <strong>张三</strong>
        <p>模块开发者</p>
      </div>
    </div>
    <div class="mb_16">
      <div class="author-title">联系开发者</div>
      <p class="author-contact">QQ：123123123</p>
    </div>
    <div>
      <div class="author-title">TA的其他作品</div>
      <div class="other_works">
        <div v-for="item in 10" :key="item" class="other_work-item d-flex">
          <img src="@/assets/svg/logo.svg" alt="" class="work-item_img mr_8"/>
          <div class="work-item_name ellipsis_more">
            WebNuxt(SSR)WebNuxt(SSR)WebNuxt(SSR)
          </div>
        </div>
      </div>
      <a-empty :image="simpleImage" description="哎呀，没有其他作品啦"/>
    </div>
  </div>
</template>

<style lang="less" scoped>
@import "./index.less";
</style>
