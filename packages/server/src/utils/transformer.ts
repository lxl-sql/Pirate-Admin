import { ValueTransformer } from 'typeorm';
import * as dayjs from 'dayjs';

export class DateFormatTransformer implements ValueTransformer {
  private format: string;
  constructor(format = 'YYYY-MM-DD HH:mm:ss') {
    this.format = format;
  }

  to(value: Date) {
    return value;
  }

  from(value: string) {
    return value ? dayjs(value).format(this.format) : value;
  }
}
