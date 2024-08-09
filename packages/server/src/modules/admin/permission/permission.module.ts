import {Module} from "@nestjs/common";
import {TypeOrmModule} from "@nestjs/typeorm";
import {Permission} from "./entities/permission.entity";
import {PermissionRepository} from "./permission.repository";
import {PermissionController} from "./permission.controller";
import {PermissionService} from "./permission.service";

@Module({
  imports: [TypeOrmModule.forFeature([Permission])],
  controllers: [PermissionController],
  providers: [PermissionRepository, PermissionService],
  exports: [PermissionRepository]
})
export class PermissionModule {
}
