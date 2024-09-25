import {Status} from "@/enums";
import {IsEnum, IsInt, IsOptional} from "class-validator";

export class QueryLogDto {
  id: number;

  @IsInt({message: '定时任务ID必须是一个整数'})
  @IsOptional()
  cronId?: number;

  @IsEnum(Status, {message: '状态值无效'})
  @IsOptional()
  status?: Status;
}
