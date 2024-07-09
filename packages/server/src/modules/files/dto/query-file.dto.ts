import { filterFalsyValues } from '@/utils/tools';
import { Transform, TransformFnParams } from 'class-transformer';
import { IsArray, IsNumber, IsOptional, IsString } from 'class-validator';

export class QueryFileDto {
  @IsString()
  name: string;

  @IsString()
  username: string;

  @IsNumber()
  @Transform(({ value }: TransformFnParams) =>
    filterFalsyValues(value, (value) => value > 0),
  )
  usertype?: number;

  @IsString()
  mimetype: string;

  @IsArray()
  createRange?: [Date, Date];

  @IsArray()
  updateRange?: [Date, Date];
}
