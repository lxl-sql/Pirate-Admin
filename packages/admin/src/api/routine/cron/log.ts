import request from "@/utils/request";

// 分页获取定时任务日志列表
export const list = (params) => {
  return request.get("/cron/log", params);
};

// 获取定时任务日志详情
export const findById = (id?: number) => {
  return request.get("/cron/log/" + id);
}

// 删除定时任务日志
export const remove = (data) => {
  return request.post("/cron/log/remove", data);
}
