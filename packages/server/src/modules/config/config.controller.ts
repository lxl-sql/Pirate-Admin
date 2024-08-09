import {Body, Controller, Get, Post} from '@nestjs/common';
import {ConfigEmailDto} from '@/common/email/dto/config-email.dto';
import {GenerateEmailDto} from '@/common/email/dto/generate-email.dto';
import {ConfigService} from './config.service';
import {CreateConfigGroupDto} from "./dto/create-config-group.dto";
import {DatabaseConfigDto} from './dto/database-config.dto';
import {CreateConfigDto} from "./dto/create-config.dto";
import {ValueConfigDto} from "./dto/value-config.dto";
import {ConfigDto} from './dto/config.dto';

@Controller('config')
export class ConfigController {
  constructor(private readonly configService: ConfigService) {
  }

  @Post()
  public async create(@Body() createConfigDto: CreateConfigDto) {
    return await this.configService.create(createConfigDto);
  }

  @Post('/value')
  public async createValue(@Body() valueConfigDto: ValueConfigDto & Record<string, any>) {
    return await this.configService.createValue(valueConfigDto);
  }

  @Get()
  public async findAll() {
    return await this.configService.findAll();
  }

  @Post('/group')
  public async createGroup(@Body() createConfigGroupDto: CreateConfigGroupDto) {
    return await this.configService.createGroup(createConfigGroupDto);
  }

  @Get('/group')
  public async findAllGroup() {
    return await this.configService.findAllGroup();
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
