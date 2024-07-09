<!-- 基础配置 -->
<script setup lang="ts">
import { ref } from "vue";
import { getTimeState } from "@/utils/common";
const isWorkRest = ref<boolean>(true); // 默认上班

// 点击休息片刻
const onWordRest = () => {
  isWorkRest.value = !isWorkRest.value;
};
</script>

<template>
  <a-row class="banner" :gutter="16">
    <a-col :lg="18" :xs="24" class="mb_16">
      <div class="welcome suspension">
        <img
          class="welcome-img"
          src="@/assets/svg/header-1.svg"
          alt="欢迎回来"
        />
        <div class="welcome-text">
          <div class="welcome-title">
            Admin，{{ getTimeState() }}！欢迎回来！
          </div>
          <div class="welcome-note">
            开源等于互助；开源需要大家一起来支持，支持的方式有很多种，比如使用、推荐、写教程、保护生态、贡献代码、回答问题、分享经验、打赏赞助等；欢迎您加入我们！
          </div>
        </div>
      </div>
    </a-col>
    <a-col :lg="6" :xs="0" class="mb_16">
      <div class="working">
        <img
          class="working-coffee"
          src="@/assets/svg/coffee.svg"
          alt="休息片刻"
        />
        <div class="working-text">您今天已工作了0小时0分0秒</div>
        <div class="working-opt" @click="onWordRest">
          {{ isWorkRest ? "休息片刻" : "继续上班" }}
        </div>
      </div>
    </a-col>
  </a-row>
</template>

<style lang="less" scoped>
@import "./index.less";
</style>
