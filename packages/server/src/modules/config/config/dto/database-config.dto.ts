import { IsIn, IsNumber, IsString } from 'class-validator';

export class DatabaseConfigDto {
  @IsIn(['mysql', 'postgres'])
  dbType: 'mysql' | 'postgres';

  @IsString()
  host: string;

  @IsNumber()
  port: number;

  @IsString()
  username: string;

  @IsString()
  password: string;

  @IsString()
  database: string;
}
