export enum LogCallTypeEnum {
  ADMIN = 'admin',
  USER = 'user',
}

export enum CaptchaTypeEnum {
  EMAIL = 'email',
  PHONE = 'phone'
}

export type LogCallType = 'admin' | 'user';

export type CaptchaType = 'email' | 'phone'
