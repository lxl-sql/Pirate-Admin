<!-- 404 -->
<template>
  <div class="page">
    <div class="container">
      <div class="font-h1">:(</div>
      <div class="tip">
        你的网页遇到了一些问题，系统正在优化和上报故障信息，我们在未来将改善和减少正在情况发生.
      </div>
      <div class="complete">
        完成
        <span class="percentage">{{ complete }} </span>%
      </div>
      <div class="details">
        <div class="qr-image">
          <img src="@/assets/images/qr.png" alt="QR Code"/>
        </div>
        <div class="stopCode">
          <div class="stopCode-text">我们将在完成后自动返回到上一页</div>
          <div class="stopCode-text">
            <router-link class="stopCode-a" to="">
              <span @click="$router.back()">返回上一页</span>
            </router-link>
            <router-link class="stopCode-a" to="/">返回首页</router-link>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import {onBeforeUnmount, onMounted, ref} from "vue";
import {useRouter} from "vue-router";

const router = useRouter();
const complete = ref(0);
let timer: number | null;

function process() {
  complete.value += Math.floor(Math.random() * 50);
  if (complete.value >= 100) {
    complete.value = 100;
    if (window.history.length <= 1) {
      // 当没有历史记录时 返回首页
      router.replace('/');
    } else {
      router.back();
    }
  } else {
    processInterval();
  }
}

function processInterval() {
  timer = setTimeout(process, Math.random() * (1000 - 500) + 500);
}

onMounted(() => {
  processInterval();
});
onBeforeUnmount(() => {
  timer && clearTimeout(timer);
  timer = null
});
</script>

<style lang="less" scoped>
@import "./index.less";
</style>
