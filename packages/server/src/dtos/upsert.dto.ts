import { IsInt, IsOptional } from 'class-validator';

export class UpsertDto {
  @IsInt({ message: 'id必须是整数' })
  @IsOptional()
  id?: number;
}
