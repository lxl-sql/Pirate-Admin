import { Module } from '@nestjs/common';
import { AdminService } from './admin.service';
import { AdminController } from './admin.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Admin } from './entities/admin.entity';
import { AdminRole } from './entities/role-admin.entity';
import { AdminPermission } from './entities/permission-admin.entity';

@Module({
  imports: [TypeOrmModule.forFeature([Admin, AdminRole, AdminPermission])],
  controllers: [AdminController],
  providers: [AdminService],
})
export class AdminModule {}
