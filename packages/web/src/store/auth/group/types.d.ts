import {DefaultTableState, type RecordType} from "@/types/table";

export interface RoleDataSource extends RecordType {
  parentId?: number; // 父级ID
  type?: 1 | 2 | 3;  // 1 菜单目录 2 菜单项 3 页面按钮
  status?: number; // 状态 0 禁用 1 启用
  cache?: number; // 1 是 0 否
  name?: string;
  title?: string;
  component?: string; // 组件路径
  sort?: number; // 排序
  icon?: string; // 图标
}

export interface RoleFormState extends RoleDataSource {
  path?: string; // 路由
  frame?: number; // 1 选项卡 2 外链 3 iframe
  description?: string; // 描述
}

export interface RoleStoreState extends Omit<DefaultTableState<RoleStoreDataSource>, 'pages'> {
  /** 详情数据 */
  formState: RoleFormState;
  /** modal加载 */
  isModalLoading: boolean;
}
