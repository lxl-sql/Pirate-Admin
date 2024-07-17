import {ApiProperty} from "@nestjs/swagger";

export class BaseTokenVo {
  @ApiProperty({description: '访问令牌', example: 'access-token'})
  accessToken: string;

  @ApiProperty({description: '刷新令牌', example: 'refresh-token'})
  refreshToken: string;
}
