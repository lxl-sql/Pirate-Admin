<script setup lang="ts">
import {ref} from "vue";
import {list} from "@/api/routine/cron/log";
import {sortNumber} from "@/utils/common";

const queryState = ref({});
const pages = ref({})
const dataSource = ref([]);
const columns = [
  {
    dataIndex: 'number',
    title: '#',
    width: 80,
    align: 'center',
    customRender: ({index}) => sortNumber(index, pages.value),
  },
  {
    dataIndex: 'result',
    title: '执行结果',
    width: 300,
    ellipsis: true,
    align: "center",
    customCell() {
      return {
        style: {
          maxWidth: '268px'
        }
      }
    }
  },
  {
    dataIndex: 'status',
    title: '状态',
    width: 80,
    align: 'center',
  },
  {
    dataIndex: 'backupFilePath',
    title: '备份路径',
    customRender: ({text}) => text,
  },
]

const onOpenAfter = async (id: number) => {
  console.log(11111, id)
  queryState.value = {
    cronId: id
  }
  await getList()
}

const onCloseAfter = () => {
  dataSource.value = [];
}

const getList = async () => {
  const params = {
    ...queryState.value,
    size: pages.value.size,
    page: pages.value.page,
  }
  const {data} = await list(params);
  dataSource.value = data.records;
  pages.value = {
    size: data.size,
    page: data.page,
    total: data.total
  };
}

const handlePagesChange = async (_pages) => {
  pages.value = _pages
  await getList()
}

defineExpose({
  onOpenAfter,
  onCloseAfter
})

defineOptions({
  name: "CronDetail"
})
</script>

<template>
  <i-table
    class="mt-4"
    :columns="columns"
    :data-source="dataSource"
    :pages="pages"
    @pages-change="handlePagesChange"
  >
    <template #status="{value}">
      <status-tag :value="value" class="cursor-pointer"/>
    </template>
  </i-table>
</template>

<style scoped lang="less">

</style>
