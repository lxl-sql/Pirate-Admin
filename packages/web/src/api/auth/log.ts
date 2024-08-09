import request from "@/utils/request";

// 分页获取管理员日志列表
export const list = (params) => {
  return request.get("/admin/log", params);
};

// 获取管理员日志详情
export const findById = (id?: number) => {
  return request.get("/admin/log/" + id);
}

// 删除管理员日志
export const remove = (data) => {
  return request.post("/admin/log/remove", data);
}
