import request from "@/utils/request";
import {LoginResult, RefreshResult} from "../types/user";
import {Response, ResponseList} from "@/types/request";

// 获取管理员头像
export const getAdminAvatar = (params) => {
  return request.get("/admin/avatar", params);
};

// 管理员登录
export const adminLogin = (data): Promise<LoginResult> => {
  return request.post("/admin/login", data);
};

// 获取管理员列表
export const getAdminList = (params) => {
  return request.get("/admin/list", params);
};

// 管理员注册/编辑
export const adminUpsert = (data) => {
  return request.post("/admin/upsert", data);
};

// 删除管理员
export const removeAdmin = (data) => {
  return request.post("/admin/remove", data);
};

// 刷新access_token
export const refresh = (refreshToken: string): Promise<RefreshResult> => {
  return request.get("/admin/refresh", {refreshToken});
};

// 分页获取角色列表
export const getAdminRoleList = (params): Promise<Response<ResponseList>> => {
  return request.get("/admin/role", params);
};

// 角色详情
export const getAdminRoleById = (id?: number) => {
  return request.get("/admin/role/" + id);
};

// 新增/修改角色
export const adminRoleUpsert = (data) => {
  return request.post("/admin/role/upsert", data);
};

// 删除角色
export const removeAdminRole = (data) => {
  return request.post("/admin/role/remove", data);
};


// 获取管理员信息
export const getAdminById = (id?: number) => {
  return request.get("/admin/detail/" + id);
};

// 获取管理员菜单列表
export const getAdminMenuList = (params) => {
  return request.get("/admin/menus", params);
};

// 新增/修改菜单
export const adminMenuUpsert = (data) => {
  return request.post("/admin/menu/upsert", data);
};

// 删除菜单
export const removeAdminMenu = (data) => {
  return request.post("/admin/menu/remove", data);
};
// 根据 Id 获取菜单详情
export const getAdminMenuById = (id?: number) => {
  return request.get("/admin/menu/" + id);
};

// 修改菜单状态
export const adminMenuStatus = (data) => {
  return request.post("/admin/menu/status", data);
};

// 修改菜单排序
export const adminMenuSortable = (id: number, targetId: number) => {
  return request.get(`/admin/menu/sortable/${id}/${targetId}`);
};
