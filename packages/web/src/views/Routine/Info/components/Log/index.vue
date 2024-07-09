<!-- 个人资料 - 操作日志 -->
<script setup lang="ts">
import {onMounted} from "vue";
import {useAdminLogStore, useAdminStore} from "@/store";
import {storeToRefs} from "pinia";

const adminLogStore = useAdminLogStore();
const adminStore = useAdminStore();
const {getAdminLogListRequest} = adminLogStore;
const {userInfo} = adminStore;
const {queryForm, dataSource, pages, isTableLoading} = storeToRefs(adminLogStore);

onMounted(async () => {
  queryForm.value.userId = userInfo.id;
  await getAdminLogListRequest();
});

const handlePageChange = async (page: number, pageSize: number) => {
  pages.value.page = page;
  pages.value.size = pageSize;
  await getAdminLogListRequest();
};
</script>

<template>
  <a-spin :spinning="isTableLoading">
    <a-timeline>
      <a-timeline-item v-for="item in dataSource" :key="item.id" color="gray">
        <p>{{ item.title }}</p>
        <p>{{ item.createTime }}</p>
      </a-timeline-item>
    </a-timeline>
    <a-pagination
      v-model:current="pages.page"
      :show-size-changer="false"
      show-quick-jumper
      :total="pages.total"
      @change="handlePageChange"
    />
  </a-spin>
</template>

<style lang="less" scoped>
@import "./index.less";
</style>
