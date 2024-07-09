import { Global, Module } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { RedisService } from './redis.service';
import { createClient } from 'redis';

@Global()
@Module({
  providers: [
    RedisService,
    {
      provide: 'REDIS_CLIENT',
      async useFactory(configService: ConfigService) {
        const client = await createClient({
          socket: {
            host: configService.get('REDIS_HOST', '127.0.0.1'),
            port: configService.get('REDIS_PORT', 6379),
          },
          database: configService.get('REDIS_DB'),
          password: configService.get('REDIS_PASSWORD'),
        })
          .on('error', (err) =>
            console.log(
              'Redis Client Error',
              configService.get('LOCAL_HOST'),
              err,
            ),
          )
          .connect();
        return client;
      },
      inject: [ConfigService],
    },
  ],
  exports: [RedisService],
})
export class RedisModule {}
