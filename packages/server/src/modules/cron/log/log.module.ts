import {Module} from '@nestjs/common';
import {LogService} from './log.service';
import {LogController} from './log.controller';
import {TypeOrmModule} from "@nestjs/typeorm";
import {Log} from "./entities/log.entity";
import {LogRepository} from "./log.repository";

@Module({
  imports: [TypeOrmModule.forFeature([Log])],
  controllers: [LogController],
  providers: [LogRepository, LogService],
  exports: [LogRepository, LogService]
})
export class LogModule {
}
