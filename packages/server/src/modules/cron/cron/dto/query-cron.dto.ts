import { IsInt, IsOptional } from 'class-validator';

export class QueryCronDto {
  @IsOptional()
  @IsInt()
  userId: number;
}
