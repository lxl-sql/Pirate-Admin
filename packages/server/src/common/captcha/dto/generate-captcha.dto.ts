import {CaptchaType} from "@/types/enum";

export class GenerateCaptchaDto {
  key: string;

  address: string;

  type: CaptchaType; // email: 邮箱验证码 phone: 短信验证码

  subject: string;

  html?: (code: string, ttl: number) => string;
}
