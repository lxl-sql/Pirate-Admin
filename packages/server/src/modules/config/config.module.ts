import { Module } from '@nestjs/common';
import { ConfigService } from './config.service';
import { ConfigController } from './config.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Setting } from './entities/settings.entities';

@Module({
  imports: [TypeOrmModule.forFeature([Setting])],
  controllers: [ConfigController],
  providers: [ConfigService],
})
export class ConfigModule {}
