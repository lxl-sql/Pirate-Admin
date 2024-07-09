/**
 * 管理员日志列表
 */
import { defineStore } from "pinia";
import {
  adminMenuStatus,
  adminMenuUpsert,
  getAdminMenuById,
  getAdminMenuList,
} from "@/api/auth/admin";
import { AdminMenuStoreState } from "@/store/auth/menu/types";

export const useAdminMenuStore = defineStore("adminMenuStore", {
  state(): AdminMenuStoreState {
    return {
      queryForm: {},
      dataSource: [],
      formState: {
        parentId: undefined,
        id: undefined,
        path: undefined,
        description: undefined,
        name: undefined,
        title: undefined,
        component: undefined,
        icon: undefined,
        type: 1,
        status: 1,
        cache: 0,
        frame: 1,
        sort: 0,
      },
      isTableLoading: false,
      isModalLoading: false,
    };
  },
  actions: {
    /**
     * 获取管理员菜单规则列表
     */
    async getAdminMenuListRequest() {
      this.isTableLoading = true;
      try {
        const { data } = await getAdminMenuList(this.queryForm);
        console.log(data, "getAdminMenuList");
        this.dataSource = data.records;
      } finally {
        this.isTableLoading = false;
      }
    },
    /**
     * 获取管理员菜单规则详情
     */
    async getAdminMenuByIdRequest(id?: number) {
      this.isModalLoading = true;
      try {
        const { data } = await getAdminMenuById(id);
        data.parentId = data.parentId || undefined;
        this.formState = data;
      } finally {
        this.isModalLoading = false;
      }
    },
    /**
     * 新增/编辑 管理员菜单规则
     */
    async adminMenuUpsertRequest() {
      this.isModalLoading = true;
      try {
        const { data } = await adminMenuUpsert(this.formState);
        return data;
      } finally {
        this.isModalLoading = false;
      }
    },
    /**
     * 管理员菜单规则 修改菜单状态
     */
    async adminMenuStatusRequest(params) {
      await adminMenuStatus(params);
    },
  },
});
