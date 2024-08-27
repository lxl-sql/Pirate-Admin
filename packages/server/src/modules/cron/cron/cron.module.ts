import {Module} from '@nestjs/common';
import {TypeOrmModule} from "@nestjs/typeorm";
import {CronService} from './cron.service';
import {CronController} from './cron.controller';
import {Cron} from "./entities/cron.entity";

@Module({
  imports: [TypeOrmModule.forFeature([Cron])],
  controllers: [CronController],
  providers: [CronService],
})
export class CronModule {
}
