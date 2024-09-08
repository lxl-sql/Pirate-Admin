import {Injectable, LoggerService} from '@nestjs/common';
import {createLogger, Logger, LoggerOptions} from "winston";
import * as dayjs from "dayjs";

@Injectable()
export class AppLogger implements LoggerService {
  private readonly logger: Logger;

  constructor(options: LoggerOptions) {
    this.logger = createLogger(options)
  }

  public log(message: string, context?: string) {
    const time = dayjs(Date.now()).format('YYYY-MM-DD HH:mm:ss');

    this.logger.log('info', message, {context, time})
  }

  public error(message: string, context?: string) {
    const time = dayjs(Date.now()).format('YYYY-MM-DD HH:mm:ss');

    this.logger.log('info', message, {context, time})
  }

  public warn(message: string, context?: string) {
    const time = dayjs(Date.now()).format('YYYY-MM-DD HH:mm:ss');

    this.logger.log('info', message, {context, time})
  }
}
