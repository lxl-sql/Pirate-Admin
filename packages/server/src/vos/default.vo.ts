import {ApiProperty} from "@nestjs/swagger";

export class DefaultVo {
  @ApiProperty({description: '主键 ID', example: 1})
  id?: number;

  @ApiProperty({description: '更新时间', example: '2024-07-10 12:00:00'})
  createTime?: Date | string;

  @ApiProperty({description: '更新时间', example: '2024-07-10 12:00:00'})
  updateTime?: Date | string;
}
