import {onBeforeUnmount, onMounted, ref, shallowRef} from 'vue';
import {upload} from "@/api/routine/files";

/**
 * 配置项类型定义
 * @interface UseDragAndDropUploadOptions
 * @property {Function} [customRequest] - 自定义上传函数
 * @property {Function} [onSuccess] - 上传成功回调函数
 * @property {Function} [onError] - 上传失败回调函数
 * @property {Function} [onProgress] - 上传进度回调函数
 */
interface UseDragAndDropUploadOptions {
  customRequest?: (files: FileList) => Promise<void>;
  onSuccess?: (response: any) => void;
  onError?: (error: any) => void;
  onProgress?: (progressEvent: ProgressEvent) => void;
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
export function useDragAndDropUpload(options: UseDragAndDropUploadOptions) {
  const dropZoneRef = ref<HTMLElement | null>(null);
  const isDragging = shallowRef<boolean>(false);
  const uploadLoading = shallowRef<boolean>(false);

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
        await onUpload(event.dataTransfer.files);
      } finally {
        event.dataTransfer.clearData();
      }
    }
  };

  const onUpload = async (files: FileList) => {
    if (options.customRequest) {
      await options.customRequest(files);
    } else {
      const formData = new FormData();
      Array.from(files).forEach((file) => {
        formData.append('files', file);
      });
      uploadLoading.value = true;
      if (options.onProgress) options.onProgress({percent: 0});
      try {
        const {data} = await upload(formData, {
          onUploadProgress: (progressEvent) => {
            progressEvent.percent = Math.floor((progressEvent.loaded * 100) / progressEvent.total);
            if (options.onProgress) options.onProgress(progressEvent);
          },
        });
        if (options.onProgress) options.onProgress({percent: 100});
        if (options.onSuccess) options.onSuccess(data);
      } catch (error) {
        if (options.onError) options.onError(error);
      } finally {
        uploadLoading.value = false;
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
    uploadLoading,
  };
}
