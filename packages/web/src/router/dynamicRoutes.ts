// 动态路由
import {RouteRecordRaw} from "vue-router";

export const dynamicRouter: Array<RouteRecordRaw> = [
  {
    path: "/home",
    name: "home",
    meta: {
      name: "home",
      title: "首页",
      showNav: true,
    },
    component: () => import("@/views/Home/Index/index.vue"),
  },
  {
    path: "/auth",
    redirect: "/auth/group",
    meta: {
      name: "auth",
      title: "权限管理",
      showNav: true,
    },
    children: [
      {
        path: "group",
        name: "authGroup",
        meta: {
          parentName: "auth",
          title: "角色组管理",
          showNav: true,
        },
        component: () => import("@/views/Auth/Group/index.vue"),
      },
      {
        path: "/auth/admin",
        name: "authAdmin",
        meta: {
          parentName: "auth",
          title: "管理员管理",
          showNav: true,
        },
        component: () => import("@/views/Auth/Admin/index.vue"),
      },
      {
        path: "/auth/menuRules",
        name: "menuRules",
        meta: {
          parentName: "auth",
          title: "菜单规则管理",
          showNav: true,
        },
        component: () => import("@/views/Auth/Menu/index.vue"),
      },
      {
        path: "/auth/adminLog",
        name: "adminLog",
        meta: {
          parentName: "auth",
          title: "管理员日志管理",
          showNav: true,
        },
        component: () => import("@/views/Auth/AdminLog/index.vue"),
      },
    ],
  },
  {
    path: "/user",
    redirect: "/user/index",
    meta: {
      name: "userIndex",
      title: "会员管理",
      showNav: true,
    },
    children: [
      {
        path: "/user/index",
        name: "userIndex",
        meta: {
          name: "user_index",
          parentName: "user",
          title: "会员管理",
          showNav: true,
        },
        component: () => import("@/views/User/Index/index.vue"),
      },
      {
        path: "/user/group",
        name: "userGroup",
        meta: {
          parentName: "user",
          title: "会员分组管理",
          showNav: true,
        },
        component: () => import("@/views/User/Group/index.vue"),
      },
      {
        path: "/user/rule",
        name: "userRule",
        meta: {
          parentName: "user",
          title: "会员规则管理",
          showNav: true,
        },
        component: () => import("@/views/User/UserRule/index.vue"),
      },
      {
        path: "/user/log",
        name: "userLog",
        meta: {
          parentName: "user",
          title: "会员日志管理",
          showNav: true,
        },
        component: () => import("@/views/User/UserLog/index.vue"),
      },
    ],
  },
  {
    path: "/routine",
    redirect: "/routine/config",
    meta: {
      name: "routineConfig",
      title: "常规管理",
      showNav: true,
    },
    children: [
      {
        path: "/routine/config",
        name: "routineConfig",
        meta: {
          parentName: "routine",
          title: "系统配置",
          showNav: true,
        },
        component: () => import("@/views/Routine/Config/index.vue"),
      },
      {
        path: "/routine/annex",
        name: "routineAnnex",
        meta: {
          parentName: "routine",
          title: "附件管理",
          showNav: true,
        },
        component: () => import("@/views/Routine/Annex/index.vue"),
      },
      {
        path: "/routine/info",
        name: "routineInfo",
        meta: {
          parentName: "routine",
          title: "个人资料",
          showNav: true,
        },
        component: () => import("@/views/Routine/Info/index.vue"),
      },
    ],
  },
  {
    path: "/module",
    name: "module",
    meta: {
      title: "模块市场",
      showNav: true,
    },
    component: () => import("@/views/Module/Index/index.vue"),
  },
];
