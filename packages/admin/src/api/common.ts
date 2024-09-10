import request from "@/utils/request";

// 获取图形验证码
export const getSvgCaptcha = (uuid?: string) => {
  return request.get("/common/svg-captcha", { uuid });
};

// 自定义错误
export const customError = (status: number) => {
  return request.get(`/error/${status}`);
};
