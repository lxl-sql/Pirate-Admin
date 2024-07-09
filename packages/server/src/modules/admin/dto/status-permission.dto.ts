import { IdsDto } from '@/common/dtos/remove.dto';
import { IsInt, IsNotEmpty } from 'class-validator';

export class StatusPermissionDto extends IdsDto {
  @IsInt({ message: 'status必须为数字' })
  @IsNotEmpty({ message: 'status不能为空' })
  status: number;
}
