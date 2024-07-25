import request from "@/utils/request";
import {DeleteParams} from "@/types/request";
import {AxiosRequestConfig} from "axios";

// 上传附件
export const upload = (data: any, options?: AxiosRequestConfig) => {
  return request.post("/files/upload", data, options);
};

// 分页获取附件列表
export const getFileList = (data: any) => {
  return request.get("/files/list", data);
};

// 删除附件
export const removeFile = (data: DeleteParams) => {
  return request.post("/files/remove", data);
}
