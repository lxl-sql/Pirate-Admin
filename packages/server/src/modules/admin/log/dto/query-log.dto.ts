import { IsInt, IsOptional } from 'class-validator';

export class QueryLogDto {
  @IsOptional()
  @IsInt()
  userId: number;
}
