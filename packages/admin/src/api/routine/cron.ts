import request from "@/utils/request";

// 分页获取定时任务列表
export const list = (params) => {
  return request.get("/cron", params);
};

// 获取定时任务详情
export const findById = (id?: number) => {
  return request.get("/cron/" + id);
}

// 删除定时任务
export const remove = (data) => {
  return request.post("/cron/remove", data);
}