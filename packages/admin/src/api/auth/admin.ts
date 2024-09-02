import request from "@/utils/request";
import {LoginResult, RefreshResult} from "../types/user";
import {CaptchaParams} from "@/types/request";

// 获取管理员头像
export const avatar = (params) => {
  return request.get("/admin/avatar", params);
};

// 管理员登录
export const login = (data): Promise<LoginResult> => {
  return request.post("/admin/login", data);
};

// 获取管理员列表
export const list = (params) => {
  return request.get("/admin/list", params);
};

// 管理员注册/编辑
export const upsert = (data) => {
  return request.post("/admin/upsert", data);
};

// 删除管理员
export const remove = (data) => {
  return request.post("/admin/remove", data);
};

// 刷新access_token
export const refresh = (refreshToken: string): Promise<RefreshResult> => {
  return request.get("/admin/refresh", {refreshToken});
};

// 获取绑定邮箱/手机号验证码
export const bindCaptcha = (params: CaptchaParams) => {
  return request.get(`/admin/bind-captcha`, params);
};

// 获取绑定邮箱/手机号验证码
export const bindInfo = (data: Required<CaptchaParams>) => {
  return request.post(`/admin/bind-info`, data);
};

// 获取管理员信息
export const findById = (id?: number) => {
  return request.get("/admin/detail/" + id);
};
