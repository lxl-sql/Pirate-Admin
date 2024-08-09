import {Body, Controller, Get, Inject, Param, Post, Query} from "@nestjs/common";
import {ApiOperation, ApiTags} from "@nestjs/swagger";
import {ApiVoResponse} from "@/decorators/api-vo-response.decorator";
import {LogCall, RequireLogin} from "@/decorators/custom.decorator";
import {IdsDto} from "@/dtos/remove.dto";
import {RoleService} from "./role.service";
import {UpsertRoleDto} from "./dto/upsert-role.dto";
import {QueryRoleDto} from "./dto/query-role.dto";
import {RoleVo} from "./vo/role.vo";

@ApiTags('Admin Role')
@Controller('admin/role')
export class RoleController {
  @Inject(RoleService)
  private readonly roleService: RoleService;

  @ApiOperation({summary: '获取管理员角色列表数据'})
  @ApiVoResponse(RoleVo, 3)
  @Get('')
  @RequireLogin()
  @LogCall('admin', '角色组管理')
  public async list(@Query() query: QueryRoleDto) {
    return await this.roleService.list(query);
  }

  @ApiOperation({summary: '新增/编辑管理员角色'})
  @Post('upsert')
  @RequireLogin()
  @LogCall('admin', '角色组管理-新增/编辑')
  public async upsert(@Body() body: UpsertRoleDto) {
    return await this.roleService.upsert(body);
  }

  @ApiOperation({summary: '根据id删除管理员角色'})
  @Post('remove')
  @RequireLogin()
  @LogCall('admin', '角色组管理-删除')
  public async remove(@Body() body: IdsDto) {
    return await this.roleService.remove(body);
  }

  @ApiOperation({summary: '根据id获取角色详情'})
  @ApiVoResponse(RoleVo)
  @Get('/:id')
  @RequireLogin()
  @LogCall('admin', '角色组管理-详情')
  public async detail(@Param('id') id: number) {
    return await this.roleService.detail(id);
  }
}
