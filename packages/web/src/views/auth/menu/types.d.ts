import {DefaultModalProps} from "@/types/modal";

interface DefaultInterface {
  id?: number; // ID
  type: 1 | 2 | 3;  // 1 菜单目录 2 菜单项 3 页面按钮
  status?: number; // 状态 0 禁用 1 启用
  cache?: number; // 1 是 0 否
  name: string;
  title: string;
  component: string; // 组件路径
  sort?: number; // 排序
  icon?: string; // 图标
}

export interface IDataSource extends DefaultInterface {
  key: string;
  updateTime?: string; // 修改时间
  children?: IDataSource[]; // 设置 children 务必设置 width 否则可能出现宽度浮动
}

export interface IFormModalProps<Options = any> extends DefaultModalProps<Options> {

}

export interface IFormState extends DefaultInterface {
  parentId?: number; // 父级ID
  path?: string; // 路由
  frame: number; // 1 选项卡 2 外链 3 iframe
  description?: string; // 描述
  component: string
}
