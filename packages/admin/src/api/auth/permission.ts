import request from "@/utils/request";

// 获取管理员菜单列表
export const list = (params) => {
  return request.get("/admin/permission", params);
};

// 新增/修改菜单
export const upsert = (data) => {
  return request.post("/admin/permission/upsert", data);
};

// 删除菜单
export const remove = (data) => {
  return request.post("/admin/permission/remove", data);
};

// 根据 Id 获取菜单详情
export const findById = (id?: number) => {
  return request.get("/admin/permission/" + id);
};

// 修改菜单状态
export const status = (data) => {
  return request.post("/admin/permission/status", data);
};

// 修改菜单排序
export const sortable = (id: number, targetId: number) => {
  return request.get(`/admin/permission/sortable/${id}/${targetId}`);
};
