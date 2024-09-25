import {Body, Controller, Get, Param, Post, Query} from '@nestjs/common';
import {LogService} from './log.service';
import {LogCall, RequireLogin} from "@/decorators/custom.decorator";
import {generateParseIntPipe} from "@/utils/tools";
import {IdsDto} from "@/dtos/remove.dto";
import {QueryLogDto} from "./dto/query-log.dto";

@Controller('cron/log')
export class LogController {
  constructor(private readonly logService: LogService) {
  }

  @Get()
  @RequireLogin()
  @LogCall('admin', '定时任务日志列表-查询')
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
  @LogCall('admin', '定时任务日志-详情')
  public async detail(@Param('id') id: number) {
    return await this.logService.detail(id);
  }

  @Post('/remove')
  @RequireLogin()
  @LogCall('admin', '定时任务日志-删除')
  public async remove(@Body() body: IdsDto) {
    return await this.logService.remove(body);
  }
}
