<script setup lang="ts">
import { DeleteOutlined, PlusOutlined } from "@ant-design/icons-vue";
import { toRef } from "vue";

interface KeyValueOption<T = any> {
  key?: string,
  value?: T
}

interface KeyValueProps<T = any> {
  value?: KeyValueOption<T>[]
}


const props = withDefaults(defineProps<KeyValueProps>(), {
  value: () => []
})

const emits = defineEmits(['update:value'])

const list = toRef(props, 'value')

const handleAddItem = () => {
  list.value.push({
    key: undefined,
    value: undefined,
  })
  emits('update:value', list.value)
}

const handleDeleteItem = (index: number) => {
  list.value.splice(index, 1)
  emits('update:value', list.value)
}

defineOptions({
  name: 'KeyValue'
})
</script>

<template>
  <div class="key-value">
    <a-row type="flex" align="middle" :gutter="16">
      <a-col :span="10" class="mb-[8px] text-center">
        键名 - key
      </a-col>
      <a-col :span="10" class="mb-[8px] text-center">
        键值 - value
      </a-col>
    </a-row>
    <template v-for="(item, index) in list" :key="index">
      <a-row type="flex" align="middle" :gutter="16" class="mb-[8px]">
        <a-col :span="10">
          <a-form-item-rest>
            <a-input v-model:value="item.key" />
          </a-form-item-rest>
        </a-col>
        <a-col :span="10">
          <a-form-item-rest>
            <a-input v-model:value="item.value" />
          </a-form-item-rest>
        </a-col>
        <a-col :span="4">
          <a-button type="primary" danger shape="circle" size="small" @click="handleDeleteItem(index)">
            <template #icon>
              <delete-outlined />
            </template>
          </a-button>
        </a-col>
      </a-row>
    </template>

    <a-row type="flex" :gutter="16">
      <a-col :span="10"></a-col>
      <a-col :span="10" class="text-right">
        <a-button @click="handleAddItem">
          <template #icon>
            <plus-outlined />
          </template>
          添加
        </a-button>
      </a-col>
      <a-col :span="4"></a-col>
    </a-row>
  </div>
</template>
