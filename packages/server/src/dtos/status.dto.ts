import { ApiProperty } from '@nestjs/swagger';
import { IsEnum, IsNotEmpty } from 'class-validator';
import { Status } from '@/enums';
import { IdsDto } from '@/dtos/remove.dto';

export class StatusDto extends IdsDto {
  @ApiProperty({ description: '状态', example: Status.ENABLED, enum: Status })
  @IsEnum(Status, { message: '请选择有效的状态' })
  @IsNotEmpty({ message: '状态不能为空' })
  status: Status;
}
