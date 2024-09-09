import {
  IsEnum,
  IsInt,
  IsNotEmpty,
  IsOptional,
  IsString,
  MaxLength,
  Min,
  ValidateIf,
} from 'class-validator';
import { Status } from '@/enums/status.enum';
import { CronTypeEnum } from '@/enums/cron-type.enum';
import { CronCycleTypeEnum } from '@/enums/cron-cycle-type.enum';
import { UpsertDto } from '@/dtos/upsert.dto';

export class UpsertCronDto extends UpsertDto {
  @MaxLength(255, { message: '名称不能超过255个字符' })
  @IsString({ message: '名称必须是文本' })
  @IsNotEmpty({ message: '名称不能为空' })
  name: string;

  @IsEnum(CronTypeEnum, { message: '请选择有效的定时任务类型' })
  type: CronTypeEnum;

  @MaxLength(255, { message: '描述不能超过255个字符' })
  @IsString({ message: '描述必须是文本' })
  @IsOptional()
  description?: string;

  @MaxLength(20, { message: 'cron表达式不能超过20个字符' })
  @IsString({ message: 'cron表达式格式不正确' })
  @IsOptional()
  cron?: string;

  @IsString({ message: 'shell脚本格式不正确' })
  @IsOptional()
  content?: string;

  @IsEnum(CronCycleTypeEnum, { message: '请选择有效的执行周期类型' })
  @IsOptional()
  cycleType?: CronCycleTypeEnum;

  @MaxLength(255, { message: '执行周期不能超过255个字符' })
  @IsString({ message: '执行周期格式不正确' })
  @IsOptional()
  cycle?: string;

  @Min(0, { message: '保存次数不能小于0' })
  @IsInt({ message: '保存次数必须是整数' })
  @IsOptional()
  save?: number;

  @Min(0, { message: '排序值不能小于0' })
  @IsInt({ message: '排序值必须是整数' })
  @IsOptional()
  sort?: number;

  @IsEnum(Status, { message: '请选择有效的通知状态' })
  @IsOptional()
  notice?: Status;

  @MaxLength(255, { message: '通知渠道不能超过255个字符' })
  @IsString({ message: '通知渠道格式不正确' })
  @ValidateIf((dto) => dto.notice === Status.ENABLED)
  noticeChannel?: string;

  @IsEnum(Status, { message: '请选择有效的状态' })
  @IsOptional()
  status?: Status;
}
