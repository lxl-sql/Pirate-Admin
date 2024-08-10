import { Controller, Get, Post, Body, Patch, Param, Delete } from '@nestjs/common';
import { CronService } from './cron.service';
import { CreateCronDto } from './dto/create-cron.dto';
import { UpdateCronDto } from './dto/update-cron.dto';

@Controller('cron')
export class CronController {
  constructor(private readonly cronService: CronService) {}

  @Post()
  create(@Body() createCronDto: CreateCronDto) {
    return this.cronService.create(createCronDto);
  }

  @Get()
  findAll() {
    return this.cronService.findAll();
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
}
