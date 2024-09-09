import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { BackupService } from '@/common/backup/backup.service';
import { Cron } from './entities/cron.entity';
import { CronRepository } from './cron.repository';
import { CronController } from './cron.controller';
import { CronService } from './cron.service';
import { LogService } from '../log/log.service';
import { Log } from '../log/entities/log.entity';

@Module({
  imports: [TypeOrmModule.forFeature([Cron, Log])],
  controllers: [CronController],
  providers: [CronService, CronRepository, BackupService, LogService],
})
export class CronModule {}
