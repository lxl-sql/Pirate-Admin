import {Body, Controller, Get, Post, Query, Req, UploadedFiles, UseInterceptors,} from '@nestjs/common';
import {AnyFilesInterceptor} from '@nestjs/platform-express';
import {Request} from 'express';
import {generateParseIntPipe} from '@/utils/tools';
import {storage} from '@/utils/multer';
import {LogCall, ProtocolHost, RequireLogin,} from '@/decorators/custom.decorator';
import {IdsDto} from '@/dtos/remove.dto';
import {FilesService} from './files.service';
import {QueryFileDto} from './dto/query-file.dto';

@Controller('files')
export class FilesController {
  constructor(private readonly filesService: FilesService) {
  }

  @Post('upload')
  @RequireLogin()
  @UseInterceptors(
    AnyFilesInterceptor({
      storage: storage,
    }),
  )
  public async upload(
    @UploadedFiles() files: Array<Express.Multer.File>,
    @Req() request: Request,
  ) {
    return await this.filesService.upload(files, request);
  }

  @Get('list')
  @RequireLogin()
  @LogCall('admin', '附件管理')
  async list(
    @Query('page', generateParseIntPipe('page', 1))
      page: number,
    @Query('size', generateParseIntPipe('size', 10))
      size: number,
    @Query()
      query: Partial<QueryFileDto>,
    @ProtocolHost() protocolHost: string,
  ) {
    console.log('query', query);
    return await this.filesService.list(page, size, query, protocolHost);
  }

  @Post('remove')
  @RequireLogin()
  @LogCall('admin', '附件管理-删除')
  async remove(@Body() body: IdsDto) {
    return await this.filesService.remove(body);
  }
}
