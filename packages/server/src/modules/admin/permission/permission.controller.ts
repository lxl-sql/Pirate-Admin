import {Body, Controller, Get, Inject, Param, Post} from "@nestjs/common";
import {PermissionService} from "./permission.service";
import {ApiOperation, ApiTags} from "@nestjs/swagger";
import {ApiVoResponse} from "@/decorators/api-vo-response.decorator";
import {LogCall, RequireLogin} from "@/decorators/custom.decorator";
import {IdsDto} from "@/dtos/remove.dto";
import {StatusPermissionDto} from './dto/status-permission.dto'
import {UpsertPermissionDto} from './dto/upsert-permission.dto'
import {PermissionVo} from './vo/permission.vo'

@ApiTags('Admin Permission')
@Controller('admin/permission')
export class PermissionController {
  @Inject(PermissionService)
  private readonly permissionService: PermissionService

  @ApiOperation({summary: '获取管理员菜单规则列表数据'})
  @ApiVoResponse(PermissionVo, 3)
  @Get()
  @RequireLogin()
  @LogCall('admin', '菜单规则管理')
  public async list() {
    return await this.permissionService.list();
  }

  @ApiOperation({summary: '新增/编辑管理员菜单规则'})
  @Post('upsert')
  @RequireLogin()
  @LogCall('admin', '菜单规则管理-新增/编辑')
  public async upsert(@Body() body: UpsertPermissionDto) {
    return await this.permissionService.upsert(body);
  }

  @ApiOperation({summary: '根据id删除管理员菜单规则'})
  @Post('remove')
  @RequireLogin()
  @LogCall('admin', '菜单规则管理-删除')
  public async remove(@Body() body: IdsDto) {
    return await this.permissionService.remove(body);
  }

  @ApiOperation({summary: '根据id获取管理员菜单规则详情'})
  @ApiVoResponse(PermissionVo)
  @Get('/:id')
  @RequireLogin()
  @LogCall('admin', '菜单规则管理-详情')
  public async detail(@Param('id') id: number) {
    return await this.permissionService.detail(id);
  }

  @ApiOperation({summary: '根据id修改管理员菜单规则状态'})
  @Post('status')
  @RequireLogin()
  @LogCall('admin', '菜单规则管理-修改状态')
  public async status(@Body() body: StatusPermissionDto) {
    return await this.permissionService.status(body);
  }


  @ApiOperation({summary: '根据id和源id修改管理员菜单规则排序'})
  @Get('sortable/:id/:targetId')
  @RequireLogin()
  @LogCall('admin', '菜单规则管理-排序')
  public async sortable(
    @Param('id') id: number,
    @Param('targetId') targetId: number,
  ) {
    return await this.permissionService.sortable(id, targetId);
  }
}
