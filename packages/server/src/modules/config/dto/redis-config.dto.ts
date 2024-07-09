import { IsNumber, IsString } from 'class-validator';

export class RedisConfigDto {
  @IsString()
  host: string;

  @IsNumber()
  port: number;

  @IsString()
  password?: string;

  @IsNumber()
  database?: number;
}
