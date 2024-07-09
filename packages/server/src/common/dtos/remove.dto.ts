import { ArrayNotEmpty } from 'class-validator';

export class IdsDto {
  @ArrayNotEmpty({ message: 'id不能为空' })
  ids: number[];
}
