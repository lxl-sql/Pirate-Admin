import {Global, Module} from '@nestjs/common';
import {TypeOrmModule} from '@nestjs/typeorm';
import {Config} from './entities/config.entity';
import {ConfigRepository} from "./config.repository";
import {ConfigController} from './config.controller';
import {ConfigService} from './config.service';
import {Group} from "../group/entities/group.entity";
import {GroupRepository} from "../group/group.repository";

@Global()
@Module({
  imports: [TypeOrmModule.forFeature([Config, Group])],
  controllers: [ConfigController],
  providers: [ConfigService, ConfigRepository, GroupRepository],
  exports: [ConfigService]
})
export class ConfigModule {
}
