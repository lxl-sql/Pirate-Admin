import { Response } from "@/types/request";

export interface UserInfo {
  id?: number;
  username?: string;
  nickname?: string;
  avatar?: string;
  email?: string;
  phone?: string;
  roles?: string[];
  permissions?: string[];
}

interface RefreshData {
  accessToken: string;
  refreshToken: string;
}

interface LoginData extends RefreshData {
  userInfo: UserInfo;
}

export type LoginResult = Response<LoginData>;

export type RefreshResult = Response<RefreshData>;
