import request from "@/utils/request";

// 分页获取管理员日志列表
export const getAdminLogList = (params) => {
  return request.get("/admin-log", params);
};

// 获取管理员日志详情
export const getAdminLogById = (id?: number) => {
  return request.get("/admin-log/" + id);
}

