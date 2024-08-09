import {ApiBody, ApiConsumes, ApiOperation, ApiProduces, ApiQuery, ApiResponse, ApiTags} from "@nestjs/swagger";
import {Body, Controller, Get, HttpStatus, Param, Post, Query,} from '@nestjs/common';
import {generateParseIntPipe} from '@/utils/tools';
import {CaptchaTypeEnum} from "@/types/enum";
import {LogCall, ProtocolHost, RealIp, RequireLogin, UserInfo} from '@/decorators/custom.decorator';
import {ApiVoResponse} from "@/decorators/api-vo-response.decorator";
import {VerifyCaptchaDto} from "@/common/captcha/dto/verify-captcha.dto";
import {IdsDto} from '@/dtos/remove.dto';
import {BaseTokenVo} from "@/common/token/vo/base-token.vo";
import {AdminService} from './admin.service';
import {UpsertAdminDto} from './dto/upsert-admin.dto';
import {LoginAdminDto} from './dto/login-admin.dto';
import {QueryAdminDto} from './dto/query-admin.dto';
import {AdminProfileInfoVo} from "./vo/profile-info-admin.vo";
import {AdminLoginInfoVo} from "./vo/login-admin.vo";

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
  public async remove(@Body() body: IdsDto) {
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
}
