import {TableSettingsType} from "@/types/tableSettingsType";

export interface AdminRoleRecordType {
  parentId?: number
  id?: number
  path?: string
  status?: number
  cache?: number
  component?: string
  disabled?: boolean
}

interface AdminRoleQueryForm extends AdminRoleRecordType {
}

export interface AdminRoleFields extends AdminRoleRecordType {
  description?: string,
  name?: string,
  title?: string,
  icon?: string,
  /** 1 选项卡 2 链接(站外) 3 iframe */
  type?: 1 | 2 | 3,
  frame?: number,
  sort?: number,
  permissionIds?: number[]
}

export type AdminRoleTableSettingsType = TableSettingsType<AdminRoleRecordType, AdminRoleQueryForm, AdminRoleFields>;
