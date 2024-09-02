// 动态路由
import {RouteLocationGeneric, RouteRecordRaw} from "vue-router";

export function redirect(to: RouteLocationGeneric): string {
  const route = to.matched?.[to.matched.length - 1]
  console.log('redirect to', to, route, route.path + '/' + route.children[0].path)
  return route.path + '/' + route.children[0].path
}

export const dynamicAdminRouter: RouteRecordRaw[] = [
  {
    path: "dashboard",
    name: "dashboard",
    meta: {
      title: "控制台",
      showNav: true,
    },
    component: () => import("@/views/dashboard/index.vue"),
  },
  {
    path: "test",
    name: "test",
    meta: {
      title: "test",
      showNav: true,
    },
    redirect: redirect,
    children: [
      {
        path: "test1",
        name: "test1",
        meta: {
          title: "test1",
          showNav: true,
        },
        redirect: redirect,
        children: [
          {
            path: "test1-1",
            name: "test1-1",
            meta: {
              title: "test1-1",
              showNav: true,
            },
            component: () => import("@/views/dashboard/index.vue"),
          },
          {
            path: "test1-2",
            name: "test1-2",
            meta: {
              title: "test1-2",
              showNav: true,
            },
            component: () => import("@/views/dashboard/index.vue"),
          },
        ]
      },
      {
        path: "test2",
        name: "test2",
        meta: {
          title: "test2",
          showNav: true,
        },
        component: () => import("@/views/dashboard/index.vue"),
      },
      {
        path: "test3",
        name: "test3",
        meta: {
          title: "test3",
          showNav: true,
        },
        redirect: redirect,
        children: [
          {
            path: "test3-1",
            name: "test3-1",
            meta: {
              title: "test3-1",
              showNav: true,
            },
            component: () => import("@/views/dashboard/index.vue"),
          },
          {
            path: "test3-2",
            name: "test3-2",
            meta: {
              title: "test3-2",
              showNav: true,
            },
            component: () => import("@/views/dashboard/index.vue"),
          },
        ]
      },
    ]
  },
  {
    path: "auth",
    name: "auth",
    redirect: redirect,
    meta: {
      title: "权限管理",
      showNav: true,
    },
    children: [
      {
        path: "group",
        name: "authGroup",
        meta: {
          title: "角色组管理",
          showNav: true,
        },
        component: () => import("@/views/auth/group/index.vue"),
      },
      {
        path: "admin",
        name: "authAdmin",
        meta: {
          title: "管理员管理",
          showNav: true,
        },
        component: () => import("@/views/auth/admin/index.vue"),
      },
      {
        path: "rule",
        name: "authRule",
        meta: {
          title: "菜单规则管理",
          showNav: true,
        },
        component: () => import("@/views/auth/menu/index.vue"),
      },
      {
        path: "log",
        name: "authLog",
        meta: {
          title: "管理员日志管理",
          showNav: true,
        },
        component: () => import("@/views/auth/adminLog/index.vue"),
      },
    ],
  },
  {
    path: "user",
    name: "user",
    meta: {
      title: "会员管理",
      showNav: true,
    },
    redirect: redirect,
    children: [
      {
        path: "user",
        name: "userUser",
        meta: {
          title: "会员管理",
          showNav: true,
        },
        component: () => import("@/views/user/user/index.vue"),
      },
      {
        path: "group",
        name: "userGroup",
        meta: {
          title: "会员分组管理",
          showNav: true,
        },
        component: () => import("@/views/user/group/index.vue"),
      },
      {
        path: "rule",
        name: "userRule",
        meta: {
          parentName: "user",
          title: "会员规则管理",
          showNav: true,
        },
        component: () => import("@/views/user/userRule/index.vue"),
      },
      {
        path: "log",
        name: "userLog",
        meta: {
          parentName: "user",
          title: "会员日志管理",
          showNav: true,
        },
        component: () => import("@/views/user/userLog/index.vue"),
      },
    ],
  },
  {
    path: "routine",
    name: "routine",
    meta: {
      title: "常规管理",
      showNav: true,
    },
    redirect: redirect,
    children: [
      {
        path: "config",
        name: "routineConfig",
        meta: {
          parentName: "routine",
          title: "系统配置",
          showNav: true,
        },
        component: () => import("@/views/routine/config/index.vue"),
      },
      {
        path: "annex",
        name: "routineAnnex",
        meta: {
          parentName: "routine",
          title: "附件管理",
          showNav: true,
        },
        component: () => import("@/views/routine/annex/index.vue"),
      },
      {
        path: "cron",
        name: "routineCron",
        meta: {
          parentName: "routine",
          title: "定时任务",
          showNav: true,
        },
        component: () => import("@/views/routine/cron/index.vue"),
      },
      {
        path: "info",
        name: "routineInfo",
        meta: {
          parentName: "routine",
          title: "个人资料",
          showNav: true,
        },
        component: () => import("@/views/routine/info/index.vue"),
      },
    ],
  },
  {
    path: "module",
    name: "module",
    meta: {
      title: "模块市场",
      showNav: true,
    },
    component: () => import("@/views/module/index.vue"),
  },
];
