import { IsInt, IsOptional } from 'class-validator';

export class QueryAdminLogDto {
  @IsOptional()
  @IsInt()
  userId: number;
}
