import {ApiProperty} from "@nestjs/swagger";

export class NotPaginationVo<T = any> {
  @ApiProperty({
    description: '记录列表',
    isArray: true,
    type: [Object],
  })
  records: T[];

  @ApiProperty({description: '备注信息', example: '备注信息'})
  remark?: string;
}

export class PaginationVo<T = any> extends NotPaginationVo<T> {
  @ApiProperty({description: '当前页码', example: 1})
  page: number;

  @ApiProperty({description: '每页条数', example: 10})
  size: number;

  @ApiProperty({description: '总记录数', example: 100})
  total: number;
}

export class ResponseData<T> extends PaginationVo<T> {
  @ApiProperty({type: () => Object})
  object: T;
}

export class ResponseVo<T = any> {
  @ApiProperty({description: '状态码', default: 200})
  code: number;

  @ApiProperty({description: '状态信息', default: '请求成功'})
  message: string;

  @ApiProperty({type: () => Object})
  data: ResponseData<T>;
}
