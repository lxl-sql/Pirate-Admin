import { Injectable, LoggerService } from '@nestjs/common';
import { createLogger, Logger, LoggerOptions } from "winston";
import * as dayjs from "dayjs";

@Injectable()
export class AppLogger implements LoggerService {
  private readonly logger: Logger;
  private context: string;

  constructor(options: LoggerOptions) {
    this.logger = createLogger(options)
  }

  public setContext(context: string) {
    this.context = context;
  }

  public log(message: string, context?: string) {
    const time = dayjs(Date.now()).format('YYYY-MM-DD HH:mm:ss');
    const _context = context || this.context;
    this.logger.log('info', message, { context: _context, time })
  }

  public error(message: string, context?: string) {
    const time = dayjs(Date.now()).format('YYYY-MM-DD HH:mm:ss');
    const _context = context || this.context;
    this.logger.log('error', message, { context: _context, time })
  }

  public warn(message: string, context?: string) {
    const time = dayjs(Date.now()).format('YYYY-MM-DD HH:mm:ss');
    const _context = context || this.context;
    this.logger.log('warn', message, { context: _context, time })
  }
}
