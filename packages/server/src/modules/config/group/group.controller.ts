import {Body, Controller, Get, Inject, Post} from "@nestjs/common";
import {GroupService} from "./group.service";
import {CreateGroupDto} from "./dto/create-group.dto";

@Controller('config/group')
export class GroupController {
  @Inject(GroupService)
  private readonly groupService: GroupService;

  @Get()
  public async findAll() {
    return await this.groupService.findAll();
  }

  @Post()
  public async create(@Body() createGroupDto: CreateGroupDto) {
    return await this.groupService.create(createGroupDto);
  }
}
