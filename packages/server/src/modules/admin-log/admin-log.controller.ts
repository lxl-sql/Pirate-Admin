import { Controller, Get, Param, Query } from '@nestjs/common';
import { AdminLogService } from './admin-log.service';
import { LogCall, RequireLogin } from '@/decorators/custom.decorator';
import { generateParseIntPipe } from '@/utils/tools';
import { QueryAdminLogDto } from './dtos/query-admin-log.dto';

@Controller('admin-log')
export class AdminLogController {
  constructor(private readonly adminLogService: AdminLogService) {}

  @Get()
  @RequireLogin()
  public async list(
    @Query('page', generateParseIntPipe('page', 1))
    page: number,
    @Query('size', generateParseIntPipe('size', 10))
    size: number,
    @Query() query: QueryAdminLogDto,
  ) {
    return await this.adminLogService.list(page, size, query);
  }

  @Get('/:id')
  @RequireLogin()
  // @LogCall('admin', '管理员操作日志-详情')
  public async detail(@Param('id') id: number) {
    return await this.adminLogService.detail(id);
  }
}
