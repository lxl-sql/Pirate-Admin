import { Controller, Get, Post, Body, Patch, Param, Delete, Query } from '@nestjs/common';
import { CronService } from './cron.service';
import { CreateCronDto } from './dto/create-cron.dto';
import { UpdateCronDto } from './dto/update-cron.dto';
import { RequireLogin } from '@/decorators/custom.decorator';
import { generateParseIntPipe } from '@/utils/tools';
import { QueryCronDto } from './dto/query-cron.dto';

@Controller('cron')
export class CronController {
  constructor(private readonly cronService: CronService) { }

  @Post()
  @RequireLogin()
  create(@Body() createCronDto: CreateCronDto) {
    return this.cronService.create(createCronDto);
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

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.cronService.findOne(+id);
  }

  @Patch(':id')
  update(@Param('id') id: string, @Body() updateCronDto: UpdateCronDto) {
    return this.cronService.update(+id, updateCronDto);
  }

  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.cronService.remove(+id);
  }
  
  @Get('start')
  @RequireLogin()
  async start() {
    console.log('start ------->');
    
    return await this.cronService.start()
  }
}
