// src/config/config.service.ts
import { Inject, Injectable } from '@nestjs/common';
import { DatabaseConfigDto } from './dto/database-config.dto';
import { promises as fs } from 'fs';
import * as path from 'path';
import { ConfigDto } from './dto/config.dto';
import { RedisConfigDto } from './dto/redis-config.dto';
import { ConfigEmailDto } from '@/common/email/dto/config-email.dto';
import { EmailService } from '@/common/email/email.service';
import { GenerateEmailDto } from '@/common/email/dto/generate-email.dto';
import { InjectRepository } from '@nestjs/typeorm';
import { Setting } from './entities/settings.entities';
import { Repository } from 'typeorm';

@Injectable()
export class ConfigService {
  @Inject(EmailService)
  private readonly emailServer: EmailService;

  @InjectRepository(Setting)
  private readonly setting: Repository<Setting>;

  private readonly envFilePath = path.resolve(__dirname, '../.env');
  private readonly envProdFilePath = path.resolve(
    __dirname,
    '../.env.production',
  );

  private async readEnvFile(filePath: string): Promise<string> {
    try {
      return await fs.readFile(filePath, 'utf-8');
    } catch (err) {
      if (err.code === 'ENOENT') {
        // .env file does not exist, return empty string
        return '';
      }
      throw err;
    }
  }

  private async writeEnvFile(filePath: string, content: string): Promise<void> {
    await fs.writeFile(filePath, content, 'utf-8');
  }

  private updateEnvContent(
    content: string,
    updates: Record<string, string | number>,
  ): string {
    const lines = content.split('\n');
    const keys = Object.keys(updates);

    const updatedLines = lines.map((line) => {
      const [key, value] = line.split('=');
      if (keys.includes(key)) {
        return `${key}=${updates[key]}`;
      }
      return line;
    });

    keys.forEach((key) => {
      if (!content.includes(`${key}=`)) {
        updatedLines.push(`${key}=${updates[key]}`);
      }
    });

    return updatedLines.join('\n');
  }

  async saveConfig(filePath: string, updates: Record<string, string | number>) {
    const envContent = await this.readEnvFile(filePath);
    const updatedContent = this.updateEnvContent(envContent, updates);
    await this.writeEnvFile(filePath, updatedContent);
  }

  async saveDatabaseConfig(config: DatabaseConfigDto): Promise<void> {
    const updates = {
      MYSQL_PORT: config.port?.toString() || '3306',
      MYSQL_USERNAME: config.username || 'root',
      MYSQL_PASSWORD: config.password || 'root@123456',
      MYSQL_DB: config.database || 'pirate_admin_system',
    };
    const updateProds = {
      MYSQL_HOST: config.host || 'mysql-container',
    };
    await this.saveConfig(this.envFilePath, updates);
    await this.saveConfig(this.envProdFilePath, updateProds);
  }

  public async testConnection(config: ConfigDto) {
    switch (config.type) {
      case 'database':
        return await this.testDatabaseConnection(config.database);
      case 'redis':
        return this.testRedisConnection(config.redis);
      default:
        return `Unsupported configuration type: ${config.type}`;
    }
  }

  private async testDatabaseConnection(config: DatabaseConfigDto) {}

  private async testRedisConnection(config: RedisConfigDto) {}

  /**
   * 保存邮件信息
   * @param config
   * @returns
   */
  public async saveEmail(config: ConfigEmailDto) {
    await this.emailServer.connectEmail(config);
    const updates = {
      NODEMAILER_HOST: config.host || 'smtp.qq.com',
      NODEMAILER_PORT: config.port || 465,
      NODEMAILER_AUTH_USER: config.user,
      NODEMAILER_AUTH_PASS: config.pass,
    };
    await this.saveConfig(this.envFilePath, updates);
    return '保存成功';
  }

  public async testEmail(config: GenerateEmailDto) {
    return await this.emailServer.testEmail(config);
  }

  public async index() {
    const settings = await this.setting.find();
    return settings;
  }
}
