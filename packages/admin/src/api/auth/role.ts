import request from "@/utils/request";
// 分页获取角色列表
import {Response, ResponseList} from "@/types/request";

export const list = (params): Promise<Response<ResponseList>> => {
  return request.get("/admin/role", params);
};

// 角色详情
export const findById = (id?: number) => {
  return request.get("/admin/role/" + id);
};

// 新增/修改角色
export const upsert = (data) => {
  return request.post("/admin/role/upsert", data);
};

// 删除角色
export const remove = (data) => {
  return request.post("/admin/role/remove", data);
};

// 删除角色
export const status = (data) => {
  return request.post("/admin/role/status", data);
};
