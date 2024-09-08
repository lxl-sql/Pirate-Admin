// routes.ts
import { RouteRecordRaw } from "vue-router";
import { dynamicAdminRouter, redirect } from './dynamicAdminRouter'
import { $local } from "@/utils/storage";

export const routes: Array<RouteRecordRaw> = [
  {
    path: "",
    redirect: () => {
      // 存在userInfo 跳转首页
      const userInfo = $local.get('userInfo')
      if (!userInfo) {
        // 默认跳转登录页面
        return "/admin/login"
      }
      // 如果有值调用 refresh 接口刷新状态
      return '/admin'
    },
  },
  {
    path: "/admin/login",
    meta: {
      name: "login",
      title: "登录页",
    },
    component: () => import("@/views/login/index.vue"),
  },
  {
    path: "/admin/config",
    meta: {
      name: "config",
      title: "数据库配置",
    },
    component: () => import("@/views/config/index.vue"),
  },
  {
    path: "/admin",
    name: "admin",
    redirect: redirect,
    meta: {
      title: "页面布局",
      showNav: true,
    },
    component: () => import("@/layout/index.vue"),
    children: dynamicAdminRouter,
  },
  {
    path: "/404",
    name: "notFound",
    component: () => import("@/views/common/error/404/404.vue"),
    meta: {
      title: "404 Not Found", // 页面不存在
    },
  },
  {
    // 404 其他不存在的页面都重定向到404
    path: "/:pathMatch(.*)",
    redirect: "/404",
  },
];
