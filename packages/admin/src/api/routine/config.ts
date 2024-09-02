import request from "@/utils/request";

// 获取系统配置
export const getConfig = () => {
  return request.get("/config");
};
