import {TableSettingsType} from "@/types/tableSettingsType";

interface AdminRoleDataSource {
  parentId?: number,
  id?: number,
  path?: string,
  status?: number,
  cache?: number,
  component?: string,
}

interface AdminRoleQueryForm extends AdminRoleDataSource {
}

export interface AdminRoleFields extends AdminRoleDataSource {
  description?: string,
  name?: string,
  title?: string,
  icon?: string,
  /** 1 选项卡 2 链接(站外) 3 iframe */
  type?: 1 | 2 | 3,
  frame?: number,
  sort?: number,
}

export type AdminRoleTableSettingsType = TableSettingsType<AdminRoleDataSource, AdminRoleQueryForm, AdminRoleFields>;
