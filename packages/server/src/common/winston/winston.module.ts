import {DynamicModule, Global, Module} from '@nestjs/common';
import {LoggerOptions} from "winston";
import {WINSTON_LOGGER_TOKEN} from "@/const/winston.const";
import {AppLogger} from '@/common/logger/app-logger.service'

@Global()
@Module({})
export class WinstonModule {
  public static forRoot(options: LoggerOptions): DynamicModule {
    return {
      module: WinstonModule,
      providers: [
        {
          provide: WINSTON_LOGGER_TOKEN,
          useValue: new AppLogger(options)
        }
      ],
      exports: [
        WINSTON_LOGGER_TOKEN
      ]
    }
  }
}
