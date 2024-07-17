import {BaseUserInfoVo} from "@/common/token/vo/user-info.vo";
import {ApiProperty} from "@nestjs/swagger";

export class UserProfileInfoVo extends BaseUserInfoVo {
  @ApiProperty({description: '性别', example: 0})
  gender: number; // 性别 0:保密 1:男 2:女

  @ApiProperty({description: '签名', example: 'Hello World'})
  sign: string;
}
