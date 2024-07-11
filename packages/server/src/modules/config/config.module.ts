import {Module} from '@nestjs/common';
import {ConfigService} from './config.service';
import {ConfigController} from './config.controller';
import {TypeOrmModule} from '@nestjs/typeorm';
import {Config} from './entities/config.entities';
import {ConfigGroup} from "./entities/config-group.entities";

@Module({
  imports: [TypeOrmModule.forFeature([Config, ConfigGroup])],
  controllers: [ConfigController],
  providers: [ConfigService],
})
export class ConfigModule {
}
