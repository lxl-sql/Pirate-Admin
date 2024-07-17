import {ApiProperty} from "@nestjs/swagger";
import {BaseTokenVo} from "@/common/token/vo/base-token.vo";
import {UserProfileInfoVo} from "@/modules/user/vo/profile-info-user.vo";

export class UserLoginInfoVo extends BaseTokenVo {
  @ApiProperty({
    description: '用户资料信息',
    type: () => UserProfileInfoVo,
    example: () => UserProfileInfoVo
  })
  userInfo: UserProfileInfoVo
}
