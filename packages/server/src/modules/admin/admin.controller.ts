import {Body, Controller, Get, HttpStatus, Param, Post, Query,} from '@nestjs/common';
import {AdminService} from './admin.service';
import {UpsertAdminDto} from './dto/upsert-admin.dto';
import {LogCall, ProtocolHost, RealIp, RequireLogin, UserInfo,} from '@/decorators/custom.decorator';
import {LoginAdminDto} from './dto/login-admin.dto';
import {generateParseIntPipe} from '@/utils/tools';
import {QueryAdminDto} from './dto/query-admin.dto';
import {RemoveAdminDto} from './dto/remove-admin.dto';
import {UpsertPermissionDto} from './dto/upsert-permission.dto';
import {IdsDto} from '@/dtos/remove.dto';
import {StatusPermissionDto} from './dto/status-permission.dto';
import {UpsertRoleDto} from './dto/upsert-role.dto';
import {QueryRoleDto} from './dto/query-role.dto';
import {VerifyCaptchaDto} from "@/common/captcha/dto/verify-captcha.dto";
import {CaptchaTypeEnum} from "@/types/enum";
import {ApiBody, ApiConsumes, ApiOperation, ApiProduces, ApiQuery, ApiResponse, ApiTags} from "@nestjs/swagger";
import {AdminLoginInfoVo} from "@/modules/admin/vo/login-admin.vo";
import {BaseTokenVo} from "@/common/token/vo/base-token.vo";
import {ApiVoResponse} from "@/decorators/api-vo-response.decorator";
import {AdminProfileInfoVo} from "@/modules/admin/vo/profile-info-admin.vo";
import {AdminRoleVo} from "@/modules/admin/vo/role-admin.vo";
import {AdminPermissionVo} from "@/modules/admin/vo/permission-admin.vo";

@ApiTags('Admin') // 将此 API 放在 'Admin' 分类下
// @ApiBearerAuth() // 如果需要认证
@ApiConsumes('application/json') // 指定接收的数据类型
@ApiProduces('application/json') // 指定响应的数据类型
@Controller('admin')
export class AdminController {
  constructor(private readonly adminService: AdminService) {
  }

  @ApiOperation({
    summary: '根据用户名获取管理员头像',
    description: '管理员使用用户名和密码进行登录',
  })
  @Get('avatar')
  public async avatar(
    @Query('username') username: string,
    @ProtocolHost() protocolHost: string
  ) {
    return await this.adminService.avatar(username, protocolHost);
  }

  @ApiOperation({
    summary: '管理员登录',
    description: '管理员使用用户名和密码进行登录',
  })
  @ApiResponse({
    status: HttpStatus.CREATED,
    description: '成功登录',
    type: AdminLoginInfoVo
  })
  @ApiResponse({
    status: HttpStatus.UNAUTHORIZED,
    description: '认证失败',
  })
  @ApiBody({
    description: '管理员登录信息',
    type: LoginAdminDto
  })
  @Post('login')
  @LogCall('admin', '登录')
  public async login(
    @Body() loginUser: LoginAdminDto,
    @RealIp() ip: string,
    @ProtocolHost() protocolHost: string,
  ) {
    return await this.adminService.login(loginUser, ip, protocolHost);
  }

  @ApiOperation({summary: '刷新Token'})
  @ApiResponse({status: 200, description: '成功返回新的token', type: BaseTokenVo})
  @ApiQuery({name: 'refreshToken', description: '刷新Token'})
  @Get('refresh')
  @LogCall('admin', 'refresh刷新token')
  public async refreshToken(
    @Query('refreshToken') refreshToken: string,
    @ProtocolHost() protocolHost: string,
  ) {
    return await this.adminService.refreshToken(refreshToken, protocolHost);
  }

  @ApiOperation({summary: '获取管理员列表'})
  @ApiVoResponse(AdminProfileInfoVo, 2)
  @Get('list')
  @RequireLogin()
  // @LogCall('admin', '管理员管理')
  public async list(
    @Query('page', generateParseIntPipe('page', 1)) page: number,
    @Query('size', generateParseIntPipe('size', 10)) size: number,
    @Query() queryAdminDto: QueryAdminDto,
    @ProtocolHost() protocolHost: string,
    @UserInfo('userId') userId: number,
  ) {
    return await this.adminService.list(
      page,
      size,
      queryAdminDto,
      protocolHost,
      userId,
    );
  }

  @ApiOperation({summary: '新增或编辑管理员'})
  @Post('upsert')
  @RequireLogin()
  @LogCall('admin', '管理员管理-新增/编辑')
  public async upsert(@Body() upsertAdminDto: UpsertAdminDto) {
    return await this.adminService.upsert(upsertAdminDto);
  }

  @ApiOperation({summary: '根据id删除管理员'})
  @Post('remove')
  @RequireLogin()
  @LogCall('admin', '管理员管理-删除')
  public async remove(@Body() body: RemoveAdminDto) {
    return await this.adminService.remove(body);
  }

  @ApiOperation({summary: '根据id查看管理员详情'})
  @Get('detail/:id')
  @RequireLogin()
  @LogCall('admin', '管理员管理-详情')
  public async detail(
    @Param('id') id: number,
    @ProtocolHost() protocolHost: string,
  ) {
    return await this.adminService.detail(id, protocolHost);
  }

  @ApiOperation({summary: '获取绑定邮箱/手机号验证码'})
  @ApiQuery({name: 'type', description: 'email: 邮箱注册 phone: 手机注册'})
  @ApiQuery({name: 'address', description: '邮箱或手机号'})
  @Get('bind-captcha')
  @RequireLogin()
  @LogCall('admin', '获取绑定邮箱/手机号验证码')
  public async bindCaptcha(
    @Query('type') type: CaptchaTypeEnum,
    @Query('address') address: string,
  ) {
    return this.adminService.bindCaptcha(type, address)
  }

  @ApiOperation({summary: '绑定管理员数据'})
  @Post('bind-info')
  @RequireLogin()
  @LogCall('admin', '绑定管理员数据')
  public async bindInfo(
    @UserInfo('userId') id: number,
    @Body() bindInfo: VerifyCaptchaDto
  ) {
    return this.adminService.bindInfo(id, bindInfo)
  }

  @ApiOperation({summary: '获取管理员角色列表数据'})
  @ApiVoResponse(AdminRoleVo, 3)
  @Get('role')
  @RequireLogin()
  @LogCall('admin', '角色组管理')
  public async role(@Query() query: QueryRoleDto) {
    return await this.adminService.role(query);
  }

  @ApiOperation({summary: '新增/编辑管理员角色'})
  @Post('role/upsert')
  @RequireLogin()
  @LogCall('admin', '角色组管理-新增/编辑')
  public async roleUpsert(@Body() body: UpsertRoleDto) {
    return await this.adminService.roleUpsert(body);
  }

  @ApiOperation({summary: '根据id删除管理员角色'})
  @Post('role/remove')
  @RequireLogin()
  @LogCall('admin', '角色组管理-删除')
  public async roleRemove(@Body() body: IdsDto) {
    return await this.adminService.roleRemove(body);
  }

  @ApiOperation({summary: '根据id获取角色详情'})
  @ApiVoResponse(AdminRoleVo)
  @Get('role/:id')
  @RequireLogin()
  @LogCall('admin', '角色组管理-详情')
  public async roleDetail(@Param('id') id: number) {
    return await this.adminService.roleDetail(id);
  }

  @ApiOperation({summary: '获取管理员角色列表数据'})
  @ApiVoResponse(AdminPermissionVo, 3)
  @Get('menus')
  @RequireLogin()
  // @LogCall('admin', '菜单规则管理')
  public async menus() {
    return await this.adminService.menus();
  }

  @ApiOperation({summary: '新增/编辑管理员菜单规则管'})
  @Post('menu/upsert')
  @RequireLogin()
  @LogCall('admin', '菜单规则管理-新增/编辑')
  public async menuUpsert(@Body() body: UpsertPermissionDto) {
    return await this.adminService.menuUpsert(body);
  }

  @ApiOperation({summary: '根据id删除管理员角色'})
  @Post('menu/remove')
  @RequireLogin()
  @LogCall('admin', '菜单规则管理-删除')
  public async menuRemove(@Body() body: IdsDto) {
    return await this.adminService.menuRemove(body);
  }

  @ApiOperation({summary: '根据id获取管理员角色详情'})
  @ApiVoResponse(AdminPermissionVo)
  @Get('menu/:id')
  @RequireLogin()
  @LogCall('admin', '菜单规则管理-详情')
  public async menuDetail(@Param('id') id: number) {
    return await this.adminService.menuDetail(id);
  }

  @ApiOperation({summary: '根据id修改管理员角色状态'})
  @Post('menu/status')
  @RequireLogin()
  @LogCall('admin', '菜单规则管理-修改状态')
  public async menuStatus(@Body() body: StatusPermissionDto) {
    return await this.adminService.menuStatus(body);
  }

  @ApiOperation({summary: '根据id和源id修改管理员角色排序'})
  @Get('menu/sortable/:id/:targetId')
  @RequireLogin()
  @LogCall('admin', '菜单规则管理-排序')
  public async menuSortable(
    @Param('id') id: number,
    @Param('targetId') targetId: number,
  ) {
    return await this.adminService.menuSortable(id, targetId);
  }
}
