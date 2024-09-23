import { IsEnum, IsOptional } from 'class-validator';
import { CronType } from '@/enums';

export class QueryCronDto {
  @IsOptional()
  name: string;

  @IsEnum(CronType, { message: '请选择有效的定时任务类型' })
  @IsOptional()
  type: CronType;
}
