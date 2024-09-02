export interface UserInfo {
  /**
   * 用户id
   */
  id: number;
  /**
   * 用户名
   */
  username: string;
  /**
   * 昵称
   */
  nickname: string;
  /**
   * 邮箱
   */
  email: string;
  /**
   * 手机号
   */
  phone: string;
  /**
   * 头像
   */
  avatar: string;
  /**
   * 用户账号状态 0 禁用 1 启用
   */
  status: number;
  /**
   * 最后登录Ip
   */
  lastLoginIp: string;
  /**
   * 最后登录时间
   */
  lastLoginTime: string;
  /**
   * 编辑时间
   */
  updateTime: string;
  /**
   * 创建时间
   */
  createTime: string;
}
