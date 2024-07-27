import {type RecordType} from "@/types/table";
import {TableSettingsType} from "@/types/tableSettingsType";
import {Usertype} from "@/enums/usertype.enus";

export interface AnnexDataSource extends RecordType {
  /** 附件名称 */
  name?: string;
  /** 用户名 */
  username?: string;
  /** 用户类型 */
  usertype?: Usertype;
  /** 大小 */
  size?: number;
  /** 文件类型 */
  mimetype?: string;
  /** 预览地址 */
  url?: string;
  /** 上传次数 */
  uploadCount?: number;
}

export interface AnnexQueryForm {

}

export type AnnexTableSettingsType = TableSettingsType<AnnexDataSource, AnnexQueryForm>;
