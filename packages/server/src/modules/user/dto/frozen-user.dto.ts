import { IsNotEmpty } from 'class-validator';

export class FrozenUserDto {
  @IsNotEmpty({ message: '用户Id不能为空' })
  userId: number;

  @IsNotEmpty({ message: '是否冻结账号不能为空' })
  status: number; // 1: 是 0: 否
}
