/**
 * 管理员列表
 */
import {defineStore} from "pinia";
import {adminLogin, getAdminAvatar, getAdminById,} from "@/api/auth/admin";
import {AdminState} from "./types";
import {$local} from "@/utils/storage";
import {UserInfo} from "@/api/types/user";

export const useAdminStore = defineStore("adminStore", {
  state: (): AdminState => {
    return {
      pages: {
        page: 1,
        size: 10,
        total: 0,
      },
      dataSource: [],
      queryForm: {},
      formState: {
        id: undefined,
        roleIds: [],
        username: undefined,
        nickname: undefined,
        avatar: undefined,
        avatarPath: undefined,
        email: undefined,
        phone: undefined,
        motto: undefined,
        password: undefined,
        checkPassword: undefined,
        status: 1,
        fileList: [],
      },
      loginFormState: {
        username: undefined,
        password: undefined,
        captcha: undefined,
        remember: false,
      },
      rawUserInfo: {},
      remark: "",
      avatar: undefined,
      isTableLoading: false,
      isModalLoading: false,
      isLoginFormLoading: false,
    };
  },
  getters: {
    userInfo(): UserInfo {
      return Object.keys(this.rawUserInfo).length === 0 ? $local.get("userInfo") : this.rawUserInfo
    },
  },
  actions: {
    /**
     * 获取管理员信息
     */
    async getAdminByIdRequest(id?: number) {
      this.isModalLoading = true;
      try {
        const {data} = await getAdminById(id);
        const file = {
          // 按照要求乱填即可
          url: data.avatar,
          path: data.avatarPath,
          status: "done",
          uid: "1",
        };
        data.fileList = data.avatar ? [file] : [];
        data.roleIds = data.roles.map((item: any) => item.id);
        this.formState = data;
      } finally {
        this.isModalLoading = false;
      }
    },
    /**
     * 根据用户名获取管理员头像
     * @param username
     */
    async getAdminAvatarRequest(username?: string) {
      try {
        const {data} = await getAdminAvatar({username: username});
        this.avatar = data;
      } catch (error) {
        this.avatar = undefined;
      }
    },
    /**
     * 登录
     */
    async adminLoginRequest() {
      const params = {
        ...this.loginFormState,
        remember: this.loginFormState.remember ? 1 : 0,
      };
      this.isLoginFormLoading = true;
      try {
        const {data} = await adminLogin(params);
        this.rawUserInfo = data.userInfo;
        $local.set("accessToken", data.accessToken);
        $local.set("refreshToken", data.refreshToken);
        $local.set("userInfo", data.userInfo);
        return data;
      } finally {
        this.isLoginFormLoading = false;
      }
    },
  },
});
