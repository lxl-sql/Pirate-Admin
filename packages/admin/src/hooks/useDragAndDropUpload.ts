import {onBeforeUnmount, onMounted, ref, shallowRef} from 'vue';

/**
 * 配置项类型定义
 * @interface UseDragAndDropUploadOptions
 * @property {Function} [onUpload] - 自定义上传函数
 */
interface UseDragAndDropUploadOptions {
  onUpload?: (files: FileList) => Promise<void> | void;
}

/**
 * 自定义 Hook：useDragAndDropUpload
 * 用于实现拖拽上传附件功能，允许绑定任意 div 元素。
 *
 * @param {UseDragAndDropUploadOptions} options - 处理文件上传的回调函数，接受一个 FileList 类型的参数。
 * @returns {Object} 包含 dropZoneRef、isDragging 和 uploadLoading 三个属性。
 * - dropZoneRef: 绑定到要实现拖拽上传的 div 元素的引用。
 * - isDragging: 一个布尔值，表示当前是否处于拖拽状态。
 * - uploadLoading: 一个布尔值，表示当前是否处于上传状态。
 */
export function useDragAndDropUpload(options?: UseDragAndDropUploadOptions) {
  const dropZoneRef = ref<HTMLElement | null>(null);
  const isDragging = shallowRef<boolean>(false);

  const handleDragEnter = (event: DragEvent) => {
    event.preventDefault();
    isDragging.value = true;
  };

  const handleDragLeave = (event: DragEvent) => {
    event.preventDefault();
    isDragging.value = false;
  };

  const handleDragOver = (event: DragEvent) => {
    event.preventDefault();
  };

  const handleDrop = async (event: DragEvent) => {
    event.preventDefault();
    isDragging.value = false;

    if (event.dataTransfer?.files && event.dataTransfer.files.length > 0) {
      try {
        await options?.onUpload?.(event.dataTransfer.files);
      } finally {
        event.dataTransfer.clearData();
      }
    }
  };

  onMounted(() => {
    if (dropZoneRef.value) {
      dropZoneRef.value.addEventListener('dragenter', handleDragEnter);
      dropZoneRef.value.addEventListener('dragleave', handleDragLeave);
      dropZoneRef.value.addEventListener('dragover', handleDragOver);
      dropZoneRef.value.addEventListener('drop', handleDrop);
    }
  });

  onBeforeUnmount(() => {
    if (dropZoneRef.value) {
      dropZoneRef.value.removeEventListener('dragenter', handleDragEnter);
      dropZoneRef.value.removeEventListener('dragleave', handleDragLeave);
      dropZoneRef.value.removeEventListener('dragover', handleDragOver);
      dropZoneRef.value.removeEventListener('drop', handleDrop);
    }
  });

  return {
    dropZoneRef,
    isDragging,
  };
}
