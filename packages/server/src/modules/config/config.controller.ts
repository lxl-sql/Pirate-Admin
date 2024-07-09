import { Body, Controller, Get, Post } from '@nestjs/common';
import { ConfigService } from './config.service';
import { DatabaseConfigDto } from './dto/database-config.dto';
import { ConfigDto } from './dto/config.dto';
import { ConfigEmailDto } from '@/common/email/dto/config-email.dto';
import { GenerateEmailDto } from '@/common/email/dto/generate-email.dto';

@Controller('config')
export class ConfigController {
  constructor(private readonly configService: ConfigService) {}

  @Get('/index')
  public async index() {
    return await this.configService.index();
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
