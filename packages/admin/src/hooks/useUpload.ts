import {shallowRef} from 'vue';
import {upload} from "@/api/routine/files";
import {AxiosProgressEvent} from "axios";
import {setTimeoutPromise} from "@/utils/common";

/**
 * 配置项类型定义
 * @interface UseUploadOptions
 * @property {Function} [onSuccess] - 上传成功回调函数
 * @property {Function} [onError] - 上传失败回调函数
 * @property {Function} [onProgress] - 上传进度回调函数
 */
interface UseUploadOptions {
  onSuccess?: (data: any) => void;
  onError?: (error: any) => void;
  onProgress?: (progressEvent: Partial<AxiosProgressEvent> & { percent: number }) => void;
}

/**
 * 自定义 Hook：useDragAndDropUpload
 * 用于实现拖拽上传附件功能，允许绑定任意 div 元素。
 *
 * @param {useUpload} options - 处理文件上传的回调函数，接受一个 FileList 类型的参数。
 * @returns {Object} 包含 loading、percent 两个属性。
 * - onUpload: {FileList} 上传附件列表
 * - loading: 一个布尔值，表示当前是否处于上传状态。
 * - isUploadError: 一个布尔值，表示附件是否上传失败。
 * - percent: 一个布尔值，表示当前的上传进度。
 */
export function useUpload(options: UseUploadOptions) {
  const loading = shallowRef<boolean>(false);
  const isUploadError = shallowRef<boolean>(false)
  const percent = shallowRef<number>(0)

  /**
   * 已知上传不会在同一个组件内同时进行
   * 设置上传进度条
   * @param progressEvent
   */
  const setProgress = (progressEvent: Partial<AxiosProgressEvent> & { percent: number }) => {
    percent.value = progressEvent.percent
    if (options.onProgress) options.onProgress(progressEvent);
  }

  const onUpload = async (files: FileList) => {
    const formData = new FormData();
    Array.from(files).forEach((file) => {
      formData.append('files', file);
    });
    loading.value = true;
    setProgress({percent: 0})
    try {
      const {data} = await upload(formData, {
        onUploadProgress: (progressEvent: AxiosProgressEvent) => {
          const percent = Math.floor((progressEvent.loaded * 100) / (progressEvent.total || 0))
          const newProgressEvent = {
            ...progressEvent,
            percent
          }
          setProgress(newProgressEvent)
        },
      });
      setProgress({percent: 100})
      if (options.onSuccess) options.onSuccess(data);
    } catch (error) {
      isUploadError.value = true
      if (options.onError) options.onError(error);
    } finally {
      if (isUploadError.value) {
        // 防止误报
        await setTimeoutPromise(500)
        loading.value = false;
      } else {
        loading.value = false;
      }
    }
  };

  return {
    onUpload,
    loading,
    percent,
    isUploadError,
  };
}
