import { UserInfoVo } from './user-info.vo';

type UserInfo<T> = UserInfoVo & {
  [K in keyof T]?: T[K];
};

export class LoginUserVo<T> {
  userInfo: UserInfo<T>;

  accessToken: string;

  refreshToken: string;
}
