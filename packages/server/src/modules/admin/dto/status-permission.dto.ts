import {IdsDto} from '@/dtos/remove.dto';
import {IsInt, IsNotEmpty} from 'class-validator';
import {Status} from "@/enums/status.enum";
import {ApiProperty} from "@nestjs/swagger";

export class StatusPermissionDto extends IdsDto {
  @ApiProperty({description: '状态', example: Status.ENABLED, enum: Status})
  @IsInt()
  @IsNotEmpty()
  status: Status;
}
