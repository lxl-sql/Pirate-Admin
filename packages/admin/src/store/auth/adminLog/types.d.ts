import { DefaultTableState, type RecordType } from "@/types/table";

export interface AdminLogDataSource extends RecordType {
  userId?: number;
  username?: string;
  title?: string;
  method?: string;
  ip?: string;
  url?: string;
  userAgent?: string;
}

export interface AdminLogDetailInfo extends AdminLogDataSource {
  params?: string;
  result?: string;
  status?: number;
  responseTime?: number;
}

interface QueryForm {
  userId?: number;
}

export interface AdminLogStoreState
  extends DefaultTableState<AdminLogStoreDataSource, QueryForm> {
  /** 详情数据 */
  detailInfo: AdminLogDetailInfo;
  /** modal加载 */
  isModalLoading: boolean;
}
