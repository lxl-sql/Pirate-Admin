import {NestFactory} from '@nestjs/core';
import {AppModule} from '@/app.module';
import {ValidationPipe} from '@nestjs/common';
import {ConfigService} from '@nestjs/config';
import {FormatResponseInterceptor} from '@/interceptors/format-response.interceptor';
import {InvokeRecordInterceptor} from '@/interceptors/invoke-record.interceptor';
import {UnloginFilter} from '@/filters/unlogin.filter';
import {CustomExceptionFilter} from '@/filters/custom-exception.filter';
import * as session from 'express-session';
import {NestExpressApplication} from '@nestjs/platform-express';
import {UndefinedToNullInterceptor} from '@/interceptors/undefined-to-null.interceptor';
import {DocumentBuilder, SwaggerModule} from "@nestjs/swagger";

async function bootstrap() {
  const app = await NestFactory.create<NestExpressApplication>(AppModule);

  const config = new DocumentBuilder()
    .setTitle('Pirate API')
    .setDescription('The API description')
    .setVersion('1.0')
    .build()
  const document = SwaggerModule.createDocument(app, config)
  SwaggerModule.setup('doc', app, document)

  app.useGlobalPipes(
    new ValidationPipe({
      skipUndefinedProperties: false, // 是否跳过未定义的属性
      transform: true, // 是否自动转换类型
      whitelist: true, // 是否自动删除未定义的属性
      // forbidNonWhitelisted: true, // 如果未定义属性则抛出异常
      transformOptions: {
        enableImplicitConversion: true, // 启用转换 例如将字符串转换为数字
      },
    }),
  );
  app.useGlobalInterceptors(new UndefinedToNullInterceptor());
  app.useGlobalInterceptors(new FormatResponseInterceptor());
  app.useGlobalInterceptors(new InvokeRecordInterceptor());
  app.useGlobalFilters(new UnloginFilter());
  app.useGlobalFilters(new CustomExceptionFilter());

  app.use(
    session({
      secret: 'SM5j3^qwwRDQ',
      name: 'session', // cookie名称，默认为connect.sid
      resave: false, // 是否每次都重新保存会话，建议false
      saveUninitialized: false, // 是否自动保存未初始化的会话，建议false
      // rolling: true, // 强制在每个response上设置会话标识符cookie
      cookie: {maxAge: 1000 * 60 * 5},
    }),
  );

  app.enableCors();

  app.useStaticAssets('uploads', {
    prefix: '/uploads',
  });

  // app.setGlobalPrefix('api');

  const configService = app.get(ConfigService);
  await app.listen(configService.get('NEST_PORT'));
}

bootstrap();
