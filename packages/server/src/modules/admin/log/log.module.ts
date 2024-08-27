import { Global, Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ConfigRepository } from '../../config/config/config.repository';
import { LogRepository } from "./log.repository";
import { Log } from './entities/log.entity';
import { LogController } from './log.controller';
import { LogService } from './log.service';

@Global()
@Module({
  imports: [TypeOrmModule.forFeature([Log])],
  controllers: [LogController],
  providers: [LogService, LogRepository, ConfigRepository],
  exports: [LogService],
})
export class LogModule {
}
