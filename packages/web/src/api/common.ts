import request from "@/utils/request";

// 获取图形验证码
export const getSvgCaptcha = () => {
  return request.get("/common/svg-captcha");
};
