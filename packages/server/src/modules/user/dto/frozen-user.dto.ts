import {IsEnum, IsNotEmpty} from 'class-validator';
import {Status} from '@/enums';

export class FrozenUserDto {
  @IsNotEmpty({message: '用户Id不能为空'})
  userId: number;

  @IsEnum(Status, {message: '状态值必须是有效的枚举值'})
  @IsNotEmpty({message: '是否冻结账号不能为空'})
  status: Status
}
