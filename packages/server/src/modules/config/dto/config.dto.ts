import {IsIn, ValidateNested} from 'class-validator';
import {DatabaseConfigDto} from './database-config.dto';
import {Type} from 'class-transformer';
import {RedisConfigDto} from './redis-config.dto';

export class ConfigDto {
  @IsIn(['database', 'sms', 'redis'], {message: '配置类型必须为指定类型'})
  type: 'database' | 'sms' | 'redis';

  @ValidateNested()
  @Type(() => DatabaseConfigDto)
  database?: DatabaseConfigDto;

  @ValidateNested()
  @Type(() => RedisConfigDto)
  redis?: RedisConfigDto;
}
