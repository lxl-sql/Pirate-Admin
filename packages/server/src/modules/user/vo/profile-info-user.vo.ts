import {ApiProperty} from "@nestjs/swagger";
import {Gender} from '@/enums';
import {BaseUserInfoVo} from "@/common/token/vo/user-info.vo";

export class UserProfileInfoVo extends BaseUserInfoVo {
  @ApiProperty({description: '性别', enum: Gender, example: Gender.UNKNOWN})
  gender: Gender; // 性别 0:保密 1:男 2:女

  @ApiProperty({description: '签名', example: 'Hello World'})
  sign: string;
}
