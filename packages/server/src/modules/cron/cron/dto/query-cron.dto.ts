import { IsEnum, IsOptional } from 'class-validator';
import { CronTypeEnum } from '@/enums/cron-type.enum';

export class QueryCronDto {
  @IsOptional()
  name: string;

  @IsEnum(CronTypeEnum, { message: '请选择有效的定时任务类型' })
  @IsOptional()
  type: CronTypeEnum;
}
