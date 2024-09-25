import {Module} from '@nestjs/common';
import {TypeOrmModule} from '@nestjs/typeorm';
import {BackupService} from '@/common/backup/backup.service';
import {ShellTaskService} from '@/common/shell-task/shell-task.service';
import {Cron} from './entities/cron.entity';
import {CronRepository} from './cron.repository';
import {CronService} from './cron.service';
import {LogModule} from "@/modules/cron/log/log.module";
import {CronController} from "@/modules/cron/cron/cron.controller";
import {LogController} from "@/modules/cron/log/log.controller";

@Module({
  imports: [TypeOrmModule.forFeature([Cron]), LogModule],
  controllers: [LogController, CronController],
  providers: [
    CronService,
    CronRepository,
    BackupService,
    ShellTaskService,
  ],
})
export class CronModule {
}
