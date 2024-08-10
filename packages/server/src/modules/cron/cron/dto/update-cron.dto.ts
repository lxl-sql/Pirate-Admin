import { PartialType } from '@nestjs/swagger';
import { CreateCronDto } from './create-cron.dto';

export class UpdateCronDto extends PartialType(CreateCronDto) {}
