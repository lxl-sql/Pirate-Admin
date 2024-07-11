// src/config/config.service.ts
import {HttpException, HttpStatus, Inject, Injectable} from '@nestjs/common';
import {DatabaseConfigDto} from './dto/database-config.dto';
import {promises as fs} from 'fs';
import * as path from 'path';
import {ConfigDto} from './dto/config.dto';
import {RedisConfigDto} from './dto/redis-config.dto';
import {ConfigEmailDto} from '@/common/email/dto/config-email.dto';
import {EmailService} from '@/common/email/email.service';
import {GenerateEmailDto} from '@/common/email/dto/generate-email.dto';
import {InjectRepository} from '@nestjs/typeorm';
import {Config} from './entities/config.entities';
import {Repository} from 'typeorm';
import {CreateConfigDto} from "@/modules/config/dto/create-config.dto";
import {existsByOnFail, parseTextareaData} from "@/utils/tools";
import {ConfigGroup} from "@/modules/config/entities/config-group.entities";
import {CreateConfigGroupDto} from "@/modules/config/dto/create-config-group.dto";

@Injectable()
export class ConfigService {
  @Inject(EmailService)
  private readonly emailServer: EmailService;

  @InjectRepository(ConfigGroup)
  private readonly configGroupRepository: Repository<ConfigGroup>;

  @InjectRepository(Config)
  private readonly configRepository: Repository<Config>;

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

  private async testDatabaseConnection(config: DatabaseConfigDto) {
  }

  private async testRedisConnection(config: RedisConfigDto) {
  }

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

  /**
   * 新增配置项目
   * @param body
   */
  public async create(body: CreateConfigDto) {
    const group = await this.configGroupRepository.findOneBy({
      id: body.groupId
    })

    if (!group) {
      throw new HttpException('指定分组不存在', HttpStatus.BAD_REQUEST)
    }

    try {
      const new_config = this.configRepository.create({
        ...body,
        group,
        rule: body.rule?.join(',')
      });
      await this.configRepository.save(new_config)
      return '保存成功'
    } catch (error) {
      if (error.code === 'ER_DUP_ENTRY') {
        await existsByOnFail(this.configRepository, 'name', body.name, '$value 字段名已存在');
      }
    }
  }

  public async findAll() {
    const configGroup = await this.findAllGroup()
    const config = await this.configRepository.find({
      order: {
        weight: "DESC"
      },
      relations: {
        group: true
      }
    });
    const groupedData = {}
    config.forEach((conf) => {
      const groupName = conf.group.name

      if (!groupedData[groupName]) {
        groupedData[groupName] = []
      }
      const new_conf = {
        ...conf,
        rule: conf.rule?.split(','),
        inputExtend: parseTextareaData(conf.inputExtend)
      }
      groupedData[groupName].push(new_conf)
    })

    return {
      configGroup,
      config: groupedData,
    };
  }

  /**
   * 新增配置项分组
   */
  public async createGroup(body: CreateConfigGroupDto) {
    try {
      const new_config = this.configGroupRepository.create(body);
      await this.configGroupRepository.save(new_config)
      return '保存成功'
    } catch (error) {
      if (error.code === 'ER_DUP_ENTRY') {
        await existsByOnFail(this.configGroupRepository, 'name', body.name, '$value 字段名已存在');
      }
    }
  }

  /**
   * 查询所有配置项分组
   */
  public async findAllGroup() {
    return await this.configGroupRepository.find()
  }

}
