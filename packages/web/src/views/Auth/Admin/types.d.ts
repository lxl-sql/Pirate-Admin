import {UserInfo} from "@/api/types/user";
import {DefaultStatus, DefaultTableState, type RecordType} from "@/types/table";
import {TableSettingsType} from "@/types/tableSettingsType";

export interface AdminDataSource extends RecordType {
  /** 登录用户名 */
  username?: string;
  /** 昵称 */
  nickname?: string;
  /** 头像 */
  avatar?: string;
  /** 头像路径 */
  avatarPath?: string;
  /** 邮箱 */
  email?: string;
  /** 手机号 */
  phone?: string;
  /** 状态 0 禁用 1 启用 */
  status?: DefaultStatus;
  /** 角色组 */
  roles?: string;
  /** 最后一次登录id */
  lastLoginIp?: string;
  /** 最后一次登录时间 */
  lastLoginTime?: string;
}

/** 详情数据 */
export interface AdminFields extends AdminDataSource {
  /** 角色组 */
  roleIds?: [];
  /** 签名/座右铭 */
  motto?: string;
  /** 密码 */
  password?: string;
  /** 确认密码 */
  checkPassword?: string;
  /** 角色组 */
  fileList?: any[];
}

export interface AdminQueryForm {

}

export interface LoginFormState {
  username?: string;
  password?: string;
  captcha?: string;
  remember: boolean;
}

export type AdminTableSettingsType = TableSettingsType<AdminDataSource, AdminQueryForm, AdminFields>;

export interface AdminState extends DefaultTableState<AdminDataSource> {
  /** 详情数据 */
  // formState: AdminDetailInfo;
  /** 登录数据状态 */
  loginFormState: LoginFormState;
  /** 头像 */
  avatar?: string;
  /** 用户信息 */
  rawUserInfo?: UserInfo;
  /** modal加载 */
  isModalLoading: boolean;
  /** login form表单加载 */
  isLoginFormLoading: boolean;
}
