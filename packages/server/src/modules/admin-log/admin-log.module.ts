import { Global, Module } from '@nestjs/common';
import { AdminLogService } from './admin-log.service';
import { AdminLogController } from './admin-log.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Admin } from '../admin/entities/admin.entity';
import { AdminLog } from './entities/admin.log.entity';

@Global()
@Module({
  imports: [TypeOrmModule.forFeature([Admin, AdminLog])],
  controllers: [AdminLogController],
  providers: [AdminLogService],
  exports: [AdminLogService],
})
export class AdminLogModule {}
