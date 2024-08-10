import {Global, Module} from '@nestjs/common';
import {TypeOrmModule} from '@nestjs/typeorm';
import {ConfigGroup} from "./entities/config-group.entity";
import {Config} from './entities/config.entity';
import {ConfigRepository} from "./config.repository";
import {ConfigController} from './config.controller';
import {ConfigService} from './config.service';

@Global()
@Module({
  imports: [TypeOrmModule.forFeature([Config, ConfigGroup])],
  controllers: [ConfigController],
  providers: [ConfigService, ConfigRepository],
  exports: [ConfigService]
})
export class ConfigModule {
}
