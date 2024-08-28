import {Body, Controller, Get, Param, Post} from '@nestjs/common';
import {ConfigEmailDto} from '@/common/email/dto/config-email.dto';
import {GenerateEmailDto} from '@/common/email/dto/generate-email.dto';
import {ConfigService} from './config.service';
import {DatabaseConfigDto} from './dto/database-config.dto';
import {CreateConfigDto} from "./dto/create-config.dto";
import {ValueConfigDto} from "./dto/value-config.dto";
import {ConfigDto} from './dto/config.dto';
import {RequireLogin} from "@/decorators/custom.decorator";

@Controller('config')
@RequireLogin()
export class ConfigController {
  constructor(private readonly configService: ConfigService) {
  }

  @Get()
  public async findAll() {
    return await this.configService.findAll();
  }

  @Get('/:name')
  public async findOneByName(@Param('name') name: string) {
    return await this.configService.findOneByName(name);
  }

  @Post()
  public async create(@Body() createConfigDto: CreateConfigDto) {
    return await this.configService.create(createConfigDto);
  }

  @Post('/value')
  public async createValue(@Body() valueConfigDto: ValueConfigDto & Record<string, any>) {
    return await this.configService.createValue(valueConfigDto);
  }


  @Post('database')
  public async saveDatabaseConfig(@Body() config: DatabaseConfigDto) {
    await this.configService.saveDatabaseConfig(config);
  }

  @Post('test-connection')
  public async testConnection(@Body() config: ConfigDto) {
    return await this.configService.testConnection(config);
  }

  @Post('email')
  public async saveEmail(@Body() config: ConfigEmailDto) {
    return await this.configService.saveEmail(config);
  }

  @Post('test-email')
  public async testEmail(@Body() config: GenerateEmailDto) {
    return await this.configService.testEmail(config);
  }
}
