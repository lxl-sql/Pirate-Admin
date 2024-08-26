import {MiddlewareConsumer, Module, NestModule, RequestMethod} from '@nestjs/common';
import {ConfigModule as NestConfigModule, ConfigService,} from '@nestjs/config';
import {APP_GUARD, APP_INTERCEPTOR} from '@nestjs/core';
import {ScheduleModule} from "@nestjs/schedule";
import {TypeOrmModule} from '@nestjs/typeorm';
import {JwtModule} from '@nestjs/jwt';
import {join} from 'path';
import {Permission as AdminPermission} from '@/modules/admin/permission/entities/permission.entity';
import {UserPermission} from '@/modules/user/entities/permission-user.entity';
import {Role as AdminRole} from '@/modules/admin/role/entities/role.entity';
import {ConfigGroup} from "@/modules/config/entities/config-group.entity";
import {Log as AdminLog} from '@/modules/admin/log/entities/log.entity';
import {Admin} from '@/modules/admin/admin/entities/admin.entity';
import {UserRole} from '@/modules/user/entities/role-user.entity';
import {Config} from '@/modules/config/entities/config.entity';
import {File} from '@/modules/files/entities/files.entity';
import {User} from '@/modules/user/entities/user.entity';
import {CustomLoggerInterceptor} from '@/interceptors/custom-logger.interceptor';
import {RealIpMiddleware} from "@/middlewares/real-ip.middleware";
import {PermissionGuard} from '@/guards/permission.guard';
import {LoginGuard} from '@/guards/login.guard';
import {AppController} from '@/app.controller';
import {AppService} from '@/app.service';
import {PermissionModule as AdminPermissionModule} from '@/modules/admin/permission/permission.module';
import {RoleModule as AdminRoleModule} from '@/modules/admin/role/role.module';
import {LogModule as AdminLogModule} from '@/modules/admin/log/log.module';
import {AdminModule} from '@/modules/admin/admin/admin.module';
import {CaptchaModule} from '@/common/captcha/captcha.module';
import {CommonModule} from '@/modules/common/common.module';
import {ConfigModule} from '@/modules/config/config.module';
import {FilesModule} from '@/modules/files/files.module';
import {RedisModule} from '@/common/redis/redis.module';
import {EmailModule} from '@/common/email/email.module';
import {TokenModule} from '@/common/token/token.module';
import {UserModule} from '@/modules/user/user.module';
import {SmsModule} from '@/common/sms/sms.module';
import {CronModule} from './modules/cron/cron/cron.module';
import {LogModule as CronLogModule} from './modules/cron/log/log.module';

const IS_DEV = process.env.NODE_ENV !== 'production';
// 本地环境需要join 线上不需要
const envFilePath = IS_DEV
  ? ['.env', '.env.development']
  : [
    join(__dirname, '.env'),
    join(__dirname, '.env.production'),
  ];

@Module({
  imports: [
    ScheduleModule.forRoot(),
    NestConfigModule.forRoot({
      isGlobal: true,
      cache: true,
      envFilePath: envFilePath, // 配置文件路径
    }),
    TypeOrmModule.forRootAsync({
      useFactory: (configService: ConfigService) => ({
        type: 'mysql',
        host: configService.get('MYSQL_HOST', 'mysql-container'),
        port: configService.get('MYSQL_PORT', 3306),
        username: configService.get('MYSQL_USERNAME'),
        password: configService.get('MYSQL_PASSWORD'),
        database: configService.get('MYSQL_DB'),
        synchronize: true,
        logging: true,
        timezone: "Z",
        entities: [
          User,
          UserRole,
          UserPermission,
          Admin,
          AdminRole,
          AdminPermission,
          File,
          AdminLog,
          Config,
          ConfigGroup
        ],
        poolSize: 10,
        connectorPackage: 'mysql2',
        extra: {
          authPlugin: 'sha256_password',
        },
      }),
      inject: [ConfigService],
    }),
    JwtModule.registerAsync({
      global: true,
      useFactory(configService: ConfigService) {
        return {
          secret: configService.get('JWT_SECRET'),
          signOptions: {
            expiresIn: '30m', // 默认30分钟
          },
        };
      },
      inject: [ConfigService],
    }),
    UserModule,
    RedisModule,
    EmailModule,
    SmsModule,
    AdminModule,
    AdminLogModule,
    AdminPermissionModule,
    AdminRoleModule,
    CaptchaModule,
    CommonModule,
    TokenModule,
    FilesModule,
    ConfigModule,
    CronModule,
    CronLogModule,
  ],
  controllers: [AppController],
  providers: [
    AppService,
    {
      provide: APP_GUARD,
      useClass: LoginGuard,
    },
    {
      provide: APP_GUARD,
      useClass: PermissionGuard,
    },
    {
      provide: APP_INTERCEPTOR,
      useClass: CustomLoggerInterceptor,
    },
  ],
})
export class AppModule implements NestModule {
  configure(consumer: MiddlewareConsumer) {
    consumer
      .apply(RealIpMiddleware)
      .forRoutes({path: '*', method: RequestMethod.ALL});
  }
}
