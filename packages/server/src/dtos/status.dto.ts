import {ApiProperty} from "@nestjs/swagger";
import {IsInt, IsNotEmpty} from 'class-validator';
import {Status} from "@/enums/status.enum";
import {IdsDto} from '@/dtos/remove.dto';

export class StatusDto extends IdsDto {
  @ApiProperty({description: '状态', example: Status.ENABLED, enum: Status})
  @IsInt()
  @IsNotEmpty()
  status: Status;
}
