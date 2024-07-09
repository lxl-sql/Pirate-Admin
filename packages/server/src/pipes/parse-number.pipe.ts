import {
  ArgumentMetadata,
  BadRequestException,
  Injectable,
  PipeTransform,
} from '@nestjs/common';

@Injectable()
export class ParseNumberPipe implements PipeTransform {
  transform(value: any, metadata: ArgumentMetadata) {
    if (value === '') {
      throw new BadRequestException('Number cannot be empty');
    }
    const val = Number(value);
    if (isNaN(val)) {
      throw new BadRequestException('Value is not a number');
    }
    return value;
  }
}
