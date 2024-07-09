import { ref, unref } from "vue";

export default function useArray() {
  const list = ref<any[]>([]);

  // 增
  const addItem = (item: any) => {
    unref(list).push(item);
  };
  // 删
  const removeItem = (idx: number) => {
    unref(list).splice(idx, 1);
  };
  // 改
  const updateItem = (idx: number, item: any) => {
    unref(list).splice(idx, 1, item);
  };

  return {
    list: unref(list),
    addItem,
    removeItem,
    updateItem,
  };
}
