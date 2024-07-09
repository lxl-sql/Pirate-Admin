import { IsOptional } from 'class-validator';

export class ConfigEmailDto {
  @IsOptional()
  host: string;

  @IsOptional()
  port: number;

  @IsOptional()
  user: string;

  @IsOptional()
  pass: string;
}
