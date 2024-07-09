import request from "@/utils/request";
import {LoginResult, RefreshResult} from "./types/user";

// 获取用户头像
export const getAvatar = (params) => {
  return request.get("/user/avatar", params);
};


// 用户登录
export const login = (data): Promise<LoginResult> => {
  return request.post("/user/login", data);
};

// 用户注册
export const register = (data) => {
  return request.post("/user/register", data);
};

// 获取用户列表
export const getUserList = (params) => {
  return request.get("/user/list", params);
};

// 刷新access_token
export const refresh = (params): Promise<RefreshResult> => {
  return request.get("/user/refresh", params);
}

// 分页获取角色列表
export const getRoleList = (params) => {
  return request.get("/user/roles", params);
};

