import {ref, unref} from "vue";

interface UseArrayResult<T> {
  list: T[]
  addItem: (item: T) => void
  removeItem: (index: number) => void
  updateItem: (index: number, item: T) => void
  init: (defaultList: T[]) => void
}

export default function useArray<T>(defaultList: T[] = []): UseArrayResult<T> {
  const list = ref<T[]>(defaultList);

  // 增
  const addItem = (item: T) => {
    (list.value as T[]).push(item);
  };
  // 删
  const removeItem = (idx: number) => {
    (list.value as T[]).splice(idx, 1);
  };
  // 改
  const updateItem = (idx: number, item: T) => {
    (list.value as T[]).splice(idx, 1, item);
  };
  // 覆盖
  const init = (defaultList: T[] = []) => {
    (list.value as T[]) = defaultList
  }

  return {
    list: unref(list) as T[],
    addItem,
    removeItem,
    updateItem,
    init,
  };
}
