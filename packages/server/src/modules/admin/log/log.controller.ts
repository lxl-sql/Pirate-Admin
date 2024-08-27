import { Body, Controller, Get, Inject, Param, Post, Query } from '@nestjs/common';
import { ApiTags } from "@nestjs/swagger";
import { generateParseIntPipe } from '@/utils/tools';
import { RequireLogin } from '@/decorators/custom.decorator';
import { IdsDto } from "@/dtos/remove.dto";
import { LogService } from './log.service';
import { QueryLogDto } from './dto/query-log.dto';

@ApiTags('Admin Log')
@Controller('admin/log')
export class LogController {
  @Inject(LogService)
  private readonly logService: LogService;

  @Get()
  @RequireLogin()
  public async list(
    @Query('page', generateParseIntPipe('page', 1))
    page: number,
    @Query('size', generateParseIntPipe('size', 10))
    size: number,
    @Query() query: QueryLogDto,
  ) {
    return await this.logService.list(page, size, query);
  }

  @Get('/:id')
  @RequireLogin()
  // @LogCall('admin', '管理员操作日志-详情')
  public async detail(@Param('id') id: number) {
    return await this.logService.detail(id);
  }

  @Post('/remove')
  @RequireLogin()
  public async remove(@Body() body: IdsDto) {
    return await this.logService.remove(body)
  }

  @Get('/clear/:day')
  @RequireLogin()
  public async clear(@Param('day') day: string) {
    return await this.logService.clear(day)
  }
}
