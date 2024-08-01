import request from "@/utils/request";

// 获取图形验证码
export const getSvgCaptcha = (uuid?: string) => {
  return request.get("/common/svg-captcha", {uuid});
};
