import { LoginUserVo as LoginInfoVo } from '@/common/token/vo/login-user.vo';

interface UserInfo {
  gender: number; // 性别
  sign: string;
}

export class LoginUserVo extends LoginInfoVo<UserInfo> {}
