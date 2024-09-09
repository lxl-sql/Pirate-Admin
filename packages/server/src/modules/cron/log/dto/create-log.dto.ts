import {
  IsNumber,
  IsString,
  IsOptional,
  IsInt,
  IsEnum,
  IsNotEmpty,
  MaxLength,
} from 'class-validator';
import { Status } from '@/enums/status.enum';

export class CreateLogDto {
  @IsInt({ message: '定时任务ID必须是一个整数' })
  @IsNotEmpty({ message: '定时任务ID不能为空' })
  cronId: number;

  @IsString({ message: '执行结果必须是文本' })
  @IsNotEmpty({ message: '执行结果不能为空' })
  @MaxLength(1000, { message: '执行结果不能超过1000个字符' })
  result: string;

  @IsEnum(Status, { message: '状态值无效' })
  status: Status;

  @MaxLength(255, { message: '备份文件路径不能超过255个字符' })
  @IsString({ message: '备份文件路径必须是文本' })
  @IsOptional()
  backupFilePath?: string;
}
