import {Module} from "@nestjs/common";
import {TypeOrmModule} from "@nestjs/typeorm";
import {Permission} from "../permission/entities/permission.entity";
import {Role} from "./entities/role.entity";
import {PermissionRepository} from "../permission/permission.repository";
import {RoleRepository} from "./role.repository";
import {RoleController} from "./role.controller";
import {RoleService} from "./role.service";

@Module({
  imports: [TypeOrmModule.forFeature([Permission, Role])],
  controllers: [RoleController],
  providers: [RoleRepository, RoleService, PermissionRepository],
  exports: [RoleRepository]
})
export class RoleModule {
}
