// 配置文件
import request from "@/utils/request";

export const configCreate = (data) => {
  return request.post("/config", data);
};

export const configValueCreate = (data) => {
  return request.post("/config/value", data);
};

// 数据库配置
export const configDatabase = (data) => {
  return request.post("/config/database", data);
};

// 发送测试邮件
export const saveEmail = (data: Record<string, any>) => {
  return request.post("/config/email", data);
};

// 发送测试邮件
export const testEmail = (data: Record<string, any>) => {
  return request.post("/config/test-email", data);
};
