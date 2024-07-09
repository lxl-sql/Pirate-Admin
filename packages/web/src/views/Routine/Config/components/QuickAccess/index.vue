<!-- 快捷配置入口 -->
<script setup lang="ts">
import { ref } from "vue";
import { DeleteOutlined, PlusOutlined } from "@ant-design/icons-vue";
import useArray from "@/hooks/useArray";

//#region 变量定义
const { list, addItem, removeItem } = useArray();
const isSubmitBtnLoading = ref<boolean>(false);
//#endregion

//#region 函数方法
// 增
const addQuickItem = (): void => {
  const params = {
    quick_name: "",
    quick_value: "",
  };
  addItem(params);
};
// 保存
const onSubmit = async (): Promise<void> => {
  if (!list.length) return;
  try {
    isSubmitBtnLoading.value = true;
    console.log("res", list);
  } catch (error) {
    console.log("error", error);
  } finally {
    isSubmitBtnLoading.value = false;
  }
};
//#endregion
</script>

<template>
  <a-form
    name="basic"
    :wrapper-col="{ span: 16 }"
    autocomplete="off"
    layout="vertical"
  >
    <a-form-item label="快捷配置入口" name="site_name">
      <a-row type="flex" align="middle" :gutter="16">
        <a-col :span="10" class="mb_8" style="text-align: center">
          键名 - name
        </a-col>
        <a-col :span="10" class="mb_8" style="text-align: center">
          键值 - path
        </a-col>
      </a-row>

      <template v-for="(item, index) in list" :key="index">
        <a-row type="flex" align="middle" :gutter="16" class="mb_8">
          <a-col :span="10">
            <a-input v-model:value="item.quick_name" />
          </a-col>
          <a-col :span="10">
            <a-input v-model:value="item.quick_value" />
          </a-col>
          <a-col :span="4">
            <a-button
              type="primary"
              danger
              shape="circle"
              size="small"
              @click="removeItem(index)"
            >
              <template #icon>
                <DeleteOutlined />
              </template>
            </a-button>
          </a-col>
        </a-row>
      </template>

      <a-row type="flex" :gutter="16">
        <a-col :span="10"> </a-col>
        <a-col :span="10" style="text-align: right">
          <a-button @click="addQuickItem">
            <template #icon>
              <PlusOutlined />
            </template>
            添加
          </a-button>
        </a-col>
        <a-col :span="4"> </a-col>
      </a-row>
    </a-form-item>
  </a-form>
  <a-space direction="vertical">
    <a-button type="primary" @click="onSubmit" :loading="isSubmitBtnLoading">
      保存
    </a-button>
  </a-space>
</template>

<style lang="less" scoped>
@import "./index.less";
</style>
