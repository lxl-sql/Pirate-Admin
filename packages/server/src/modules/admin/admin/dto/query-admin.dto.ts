import {ApiProperty} from "@nestjs/swagger";

export class QueryAdminDto {
  @ApiProperty({description: '昵称', example: '管理员', required: false})
  nickname?: string;
}
