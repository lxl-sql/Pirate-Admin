<script setup lang="ts">
interface PageCardProps {
  title?: string;
  loading?: boolean
}

defineProps<PageCardProps>()

defineOptions({
  name: 'PageCard',
})
</script>

<template>
  <a-spin :spinning="loading">
    <div class="page-card duration-300 overflow-hidden w-[340px] md:w-[430px] p-0 rounded-[10px] ">
      <div
        class="img-placeholder bg-[#ccccff] relative"
        style="--img-placeholder-rate: 35.11%"
        v-cloak
      >
        <a-typography-title
          class="absolute left-1/2 top-1/2 transform-gpu -translate-x-1/2 -translate-y-1/2 text-white z-10 user-select-none"
          :level="2"
        >
          <slot name="title">
            {{ title }}
          </slot>
        </a-typography-title>
        <img
          class="block w-[430px] m-auto user-select-none"
          src="@/assets/images/login-header.png"
          alt="card-bg"
        />
      </div>
      <div class="p-5">
        <slot></slot>
      </div>
    </div>
  </a-spin>
</template>

<style lang="less" scoped>
.page-card {
  transition-timing-function: cubic-bezier(0.075, 0.82, 0.165, 1);
  background: var(--ba-bg-color-overlay);
}
</style>
