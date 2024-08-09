import {ApiProperty} from "@nestjs/swagger";
import {UserProfileInfoVo} from "@/modules/user/vo/profile-info-user.vo";
import {BaseTokenVo} from "@/common/token/vo/base-token.vo";

export class UserLoginInfoVo extends BaseTokenVo {
  @ApiProperty({
    description: '用户资料信息',
    type: () => UserProfileInfoVo,
    example: () => UserProfileInfoVo
  })
  userInfo: UserProfileInfoVo
}
