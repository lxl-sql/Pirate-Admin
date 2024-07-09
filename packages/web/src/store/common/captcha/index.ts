/**
 * 公共接口 -> 验证码
 */
import { defineStore } from "pinia";
import { CaptchaStoreState } from "./types";
import { getSvgCaptcha } from "@/api/common";

export const useCaptchaStore = defineStore("captchaStore", {
  state(): CaptchaStoreState {
    return {
      svgCaptcha: "",
    };
  },
  actions: {
    /**
     * 获取登录图像验证码
     */
    async svgCaptchaRequest() {
      const { data } = await getSvgCaptcha();
      this.svgCaptcha = data;
    },
  },
});
