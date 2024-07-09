import {type RecordType} from "@/types/table";

export interface AdminLogDataSource extends RecordType {
  userId?: number;
  username?: string;
  title?: string;
  method?: string
  ip?: string
  url?: string
  userAgent?: string
}

export interface AdminLogDetailInfo extends AdminLogDataSource {
  params?: string;
  result?: string;
  status?: number;
  responseTime?: number
}
