import {Global, Module} from '@nestjs/common';
import {ConfigService} from './config.service';
import {ConfigController} from './config.controller';
import {TypeOrmModule} from '@nestjs/typeorm';
import {Config} from './entities/config.entities';
import {ConfigGroup} from "./entities/config-group.entities";

@Global()
@Module({
  imports: [TypeOrmModule.forFeature([Config, ConfigGroup])],
  controllers: [ConfigController],
  providers: [ConfigService],
  exports: [ConfigService]
})
export class ConfigModule {
}
