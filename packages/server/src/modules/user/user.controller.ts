import {Body, Controller, Get, ParseIntPipe, Post, Query, Session,} from '@nestjs/common';
import {ApiConsumes, ApiProduces, ApiTags} from "@nestjs/swagger";
import {generateParseIntPipe} from '@/utils/tools';
import {CaptchaTypeEnum} from "@/types/enum";
import {RealIp, RequireLogin, UserInfo} from '@/decorators/custom.decorator';
import {UserService} from './user.service';
import {UpdatePasswordUserDto} from './dto/update-password-user.dto';
import {RegisterUserDto} from './dto/register-user.dto';
import {UpdateUserDto} from './dto/update-user.dto';
import {FrozenUserDto} from './dto/frozen-user.dto';
import {LoginUserDto} from './dto/login-user.dto';
import {QueryUserDto} from './dto/query-user.dto';

@ApiTags('User') // 将此 API 放在 'Admin' 分类下
// @ApiBearerAuth() // 如果需要认证
@ApiConsumes('application/json') // 指定接收的数据类型
@ApiProduces('application/json') // 指定响应的数据类型
@Controller('user')
export class UserController {
  constructor(private readonly userService: UserService) {
  }

  @Post('register')
  public async register(@Body() registerUser: RegisterUserDto) {
    return await this.userService.register(registerUser);
  }

  @Get('register-captcha')
  public async captcha(
    @Query('type') type: CaptchaTypeEnum, // email: 邮箱注册 phone: 手机注册
    @Query('address') address: string, // 邮箱或手机号
  ) {
    return await this.userService.captcha(type, address);
  }

  @Post('login')
  public async login(
    @Body() loginUser: LoginUserDto,
    @Session() session: Record<string, any>,
    @RealIp() ip: string,
  ) {
    return await this.userService.login(loginUser, session, ip);
  }

  @Get('svg-captcha')
  public async svgCaptcha(@Session() session: Record<string, any>) {
    return await this.userService.svgCaptcha(session);
  }

  @Get('refresh')
  // @RequireLogin()
  public async refreshToken(@Query('refreshToken') refreshToken: string) {
    return await this.userService.refreshToken(refreshToken);
  }

  @Get('info')
  @RequireLogin()
  public async info(@Query('userId', ParseIntPipe) userId: number) {
    return await this.userService.info(userId);
  }

  @Get('avatar')
  public async avatar(@Query('username') username: string) {
    return await this.userService.avatar(username);
  }

  @Post('update-password')
  @RequireLogin()
  public async updatePassword(
    @UserInfo('userId', ParseIntPipe) userId: number,
    @Body() passwordDto: UpdatePasswordUserDto,
  ) {
    return await this.userService.updatePassword(userId, passwordDto);
  }

  @Get('update-password-captcha')
  public async updatePasswordCaptcha(
    @Query('type') type: CaptchaTypeEnum, // email: 邮箱注册 phone: 手机注册
    @Query('address') address: string, // 邮箱或手机号
  ) {
    return await this.userService.updatePasswordCaptcha(type, address);
  }

  @Post('update')
  @RequireLogin()
  public async update(
    @UserInfo('userId', ParseIntPipe) userId: number,
    @Body() updateUserDto: UpdateUserDto,
  ) {
    return await this.userService.update(userId, updateUserDto);
  }

  @Get('update-captcha')
  @RequireLogin()
  public async updateCaptcha(
    @Query('type') type: CaptchaTypeEnum, // email: 邮箱注册 phone: 手机注册
    @Query('address') address: string, // 邮箱或手机号
  ) {
    return await this.userService.updateCaptcha(type, address);
  }

  @Post('frozen')
  @RequireLogin()
  public async frozen(@Body() frozenUser: FrozenUserDto) {
    return await this.userService.frozen(frozenUser);
  }

  @Get('list')
  @RequireLogin()
  public async list(
    @Query('page', generateParseIntPipe('page', 1))
      page: number,
    @Query('size', generateParseIntPipe('size', 10))
      size: number,
    @Query()
      query: QueryUserDto,
  ) {
    return await this.userService.list(page, size, query);
  }

  @Get('roles')
  @RequireLogin()
  public async roles() {
    return await this.userService.roles();
  }
}
