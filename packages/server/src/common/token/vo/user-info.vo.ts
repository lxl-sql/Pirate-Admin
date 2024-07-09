export class UserInfoVo {
  id: number;

  username: string;

  nickname: string;

  email: string;

  phone: string;

  avatar: string;

  status: number;

  lastLoginIp: string;

  lastLoginTime: Date;

  updateTime: Date;

  createTime: Date;

  roles?: string[];

  permissions?: string[];
}
