import {ApiProperty} from "@nestjs/swagger";
import {ArrayNotEmpty} from 'class-validator';

export class IdsDto {
  @ApiProperty({
    description: '主键ID',
    type: [Number],
    example: [1, 2, 3]
  })
  @ArrayNotEmpty({message: 'id不能为空'})
  ids: number[];
}
