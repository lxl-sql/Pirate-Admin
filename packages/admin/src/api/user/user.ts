import request from "@/utils/request";


// 获取管理员列表
export const getUserList = (params) => {
  return request.get("/user/list", params);
};

// 管理员注册/编辑
export const userUpsert = (data) => {
  return request.post("/user/upsert", data);
};
