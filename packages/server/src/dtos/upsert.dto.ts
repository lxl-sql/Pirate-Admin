import { IsInt, IsOptional } from 'class-validator';

export class UpsertDto {
  @IsInt()
  @IsOptional()
  id: number;
}
