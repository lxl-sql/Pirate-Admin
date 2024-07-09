import { Module } from '@nestjs/common';
import { UserService } from './user.service';
import { UserController } from './user.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { User } from './entities/user.entity';
import { UserRole } from './entities/role-user.entity';
import { UserPermission } from './entities/permission-user.entity';

@Module({
  imports: [TypeOrmModule.forFeature([User, UserRole, UserPermission])],
  controllers: [UserController],
  providers: [UserService],
})
export class UserModule {}
