interface Menu {
  id?: string;
  title: string;
  path: string;
  name: string;
  icon: string;
  children?: Menu[];
}

export interface HeaderInterface {
  // 是否展开左侧菜单栏 默认收起
  isSidebarOpen: boolean;
  // 是否全屏 默认 false
  isFullScreen: boolean;
  // 当前标签页全屏 引入地址 header 以及 tags
  isLayoutFullScreen: boolean;
  // 重新刷新当前页 默认不重新刷新
  isPageRefreshing: boolean;
  // 是否显示侧边栏抽屉 当 <= 1200 时 默认不显示
  isAsideMenu: boolean;
  // 菜单列表
  menus: Menu[] | null;
}
