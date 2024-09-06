import {IsEnum, IsInt, IsNotEmpty, IsOptional, IsString, MaxLength, Min} from 'class-validator';
import {Status} from "@/enums/status.enum";
import {CronTypeEnum} from "@/enums/cron-type.enum";
import {CronCycleTypeEnum} from "@/enums/cron-cycle-type.enum";

export class CreateCronDto {
  @IsNotEmpty()
  @IsString()
  @MaxLength(255)
  name: string;

  @IsEnum(CronTypeEnum)
  type: CronTypeEnum;

  @IsOptional()
  @IsString()
  @MaxLength(255)
  description?: string;

  @IsOptional()
  @IsString()
  @MaxLength(20)
  cron?: string;

  @IsOptional()
  @IsEnum(CronCycleTypeEnum)
  cycleType?: CronCycleTypeEnum;

  @IsOptional()
  @IsString()
  @MaxLength(255)
  cycle?: string;

  @IsOptional()
  @IsInt()
  @Min(0)
  save?: number;

  @IsOptional()
  @IsInt()
  @Min(0)
  sort?: number;

  @IsEnum(Status)
  notice: Status;

  @IsOptional()
  @IsString()
  @MaxLength(255)
  noticeChannel?: string;

  @IsEnum(Status)
  status: Status;
}
