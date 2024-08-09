import {Module} from '@nestjs/common';
import {TypeOrmModule} from '@nestjs/typeorm';
import {UserPermission} from './entities/permission-user.entity';
import {UserRole} from './entities/role-user.entity';
import {User} from './entities/user.entity';
import {UserController} from './user.controller';
import {UserService} from './user.service';

@Module({
  imports: [TypeOrmModule.forFeature([User, UserRole, UserPermission])],
  controllers: [UserController],
  providers: [UserService],
})
export class UserModule {
}
