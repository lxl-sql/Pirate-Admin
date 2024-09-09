import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  Query,
  ParseIntPipe,
} from '@nestjs/common';
import { CronService } from './cron.service';
import { UpsertCronDto } from './dto/upsert-cron.dto';
import { RequireLogin } from '@/decorators/custom.decorator';
import { generateParseIntPipe } from '@/utils/tools';
import { QueryCronDto } from './dto/query-cron.dto';
import { IdsDto } from '@/dtos/remove.dto';

@Controller('cron')
export class CronController {
  constructor(private readonly cronService: CronService) {}

  @Post()
  @RequireLogin()
  upsert(@Body() upsertCronDto: UpsertCronDto) {
    return this.cronService.upsert(upsertCronDto);
  }

  @Get()
  @RequireLogin()
  public async list(
    @Query('page', generateParseIntPipe('page', 1))
    page: number,
    @Query('size', generateParseIntPipe('size', 10))
    size: number,
    @Query() query: QueryCronDto,
  ) {
    return await this.cronService.list(page, size, query);
  }

  @Get('start')
  @RequireLogin()
  async start() {
    return await this.cronService.start();
  }

  @Get('start/:id')
  @RequireLogin()
  async startOne(
    @Param('id', ParseIntPipe) id: number,
    @Query('cron') cron?: string,
  ) {
    return await this.cronService.startOne(id, cron);
  }

  @Get(':id')
  @RequireLogin()
  detail(@Param('id', ParseIntPipe) id: number) {
    return this.cronService.detail(id);
  }

  @Post('/remove')
  @RequireLogin()
  public async remove(@Body() body: IdsDto) {
    return await this.cronService.remove(body);
  }
}
