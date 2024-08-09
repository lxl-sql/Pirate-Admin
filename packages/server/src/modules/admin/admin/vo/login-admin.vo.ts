import {ApiProperty} from "@nestjs/swagger";
import {BaseTokenVo} from '@/common/token/vo/base-token.vo';
import {AdminProfileInfoVo} from "./profile-info-admin.vo";

export class AdminLoginInfoVo extends BaseTokenVo {
  @ApiProperty({
    description: '管理员资料信息',
    type: AdminProfileInfoVo,
    example: () => AdminProfileInfoVo
  })
  userInfo?: AdminProfileInfoVo
}
