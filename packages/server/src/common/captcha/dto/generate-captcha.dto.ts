export class GenerateCaptchaDto {
  key: string;

  address: string;

  type: number; // 1: 邮箱验证码 2: 短信验证码

  subject: string;

  html?: (code: string, ttl: number) => string;
}
