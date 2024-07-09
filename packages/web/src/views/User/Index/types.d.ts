interface IDataSource {
  key: string;
  gender: 0 | 1 | 2; // 性别 0 保密 1 男 2 女
  status: 0 | 1; // 1 正常, 0 禁用
  lastLoginIp: string;
  lastLoginTime: string; // 最后登录时间
  isDeleteVisible: boolean; // 是否删除
  updateTime?: string; // 修改时间
  createTime?: string; // 创建时间
}

interface ISortTableEnd {
  newIndex: number;
  oldIndex: number;
}

export {IDataSource, ISortTableEnd};
