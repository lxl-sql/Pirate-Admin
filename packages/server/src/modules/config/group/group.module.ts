import {Module} from "@nestjs/common";
import {TypeOrmModule} from "@nestjs/typeorm";
import {Group} from "./entities/group.entity";
import {GroupController} from "./group.controller";
import {GroupService} from "@/modules/config/group/group.service";
import {GroupRepository} from "@/modules/config/group/group.repository";

@Module({
  imports: [TypeOrmModule.forFeature([Group])],
  controllers: [GroupController],
  providers: [GroupService, GroupRepository],
  exports: [GroupService]
})
export class GroupModule {
}
