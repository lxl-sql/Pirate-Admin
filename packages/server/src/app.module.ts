import { MiddlewareConsumer, Module, NestModule } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import {
  ConfigModule as NestConfigModule,
  ConfigService,
} from '@nestjs/config';
import { JwtModule } from '@nestjs/jwt';
import { APP_GUARD, APP_INTERCEPTOR } from '@nestjs/core';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { UserModule } from '@/modules/user/user.module';
import { User } from '@/modules/user/entities/user.entity';
import { UserRole } from '@/modules/user/entities/role-user.entity';
import { UserPermission } from '@/modules/user/entities/permission-user.entity';
import { RedisModule } from '@/common/redis/redis.module';
import { EmailModule } from '@/common/email/email.module';
import { SmsModule } from '@/common/sms/sms.module';
import { CaptchaModule } from './common/captcha/captcha.module';
import { LoginGuard } from '@/guards/login.guard';
import { PermissionGuard } from '@/guards/permission.guard';
import { AdminModule } from './modules/admin/admin.module';
import { AdminRole } from './modules/admin/entities/role-admin.entity';
import { AdminPermission } from './modules/admin/entities/permission-admin.entity';
import { Admin } from './modules/admin/entities/admin.entity';
import { CommonModule } from './modules/common/common.module';
import { TokenModule } from './common/token/token.module';
import { FilesModule } from './modules/files/files.module';
import { File } from './modules/files/entities/files.entity';
import { AdminLogModule } from './modules/admin-log/admin-log.module';
import { CustomLoggerInterceptor } from './interceptors/custom-logger.interceptor';
import { AdminLog } from './modules/admin-log/entities/admin.log.entity';
import { join } from 'path';
import { ConfigModule } from './modules/config/config.module';
import { Setting } from './modules/config/entities/settings.entities';

const IS_DEV = process.env.NODE_ENV !== 'production';
// 本地环境需要join 线上不需要
const envFilePath = IS_DEV
  ? ['.env.development', '.env.production', '.env']
  : [
      join(__dirname, '../.env.development'),
      join(__dirname, '../.env.production'),
      join(__dirname, '../.env'),
    ];
@Module({
  imports: [
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
        entities: [
          User,
          UserRole,
          UserPermission,
          Admin,
          AdminRole,
          AdminPermission,
          File,
          AdminLog,
          Setting,
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
    CaptchaModule,
    CommonModule,
    TokenModule,
    FilesModule,
    AdminLogModule,
    ConfigModule,
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
export class AppModule {}
