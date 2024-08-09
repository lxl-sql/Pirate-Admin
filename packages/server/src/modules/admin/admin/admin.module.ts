import {Module} from '@nestjs/common';
import {TypeOrmModule} from '@nestjs/typeorm';
import {Permission} from '../permission/entities/permission.entity';
import {Role} from '../role/entities/role.entity';
import {Admin} from './entities/admin.entity';
import {RoleRepository} from "../role/role.repository";
import {AdminRepository} from "./admin.repository";
import {AdminController} from './admin.controller';
import {AdminService} from './admin.service';

@Module({
  imports: [TypeOrmModule.forFeature([Admin, Role, Permission])],
  controllers: [AdminController],
  providers: [AdminRepository, AdminService, RoleRepository],
})
export class AdminModule {
}
