// src/config/config.service.ts
import {forwardRef, HttpException, HttpStatus, Inject, Injectable} from '@nestjs/common';
import {ConfigService as NestConfigService} from '@nestjs/config'
import {InjectRepository} from '@nestjs/typeorm';
import {In, Repository} from 'typeorm';
import {promises as fs} from 'fs';
import * as path from 'path';
import {existsByOnFail, parseTextareaData} from "@/utils/tools";
import {EmailService} from '@/common/email/email.service';
import {ConfigGroup} from "./entities/config-group.entity";
import {Config} from './entities/config.entity';
import {GenerateEmailDto} from '@/common/email/dto/generate-email.dto';
import {ConfigEmailDto} from '@/common/email/dto/config-email.dto';
import {CreateConfigGroupDto} from "./dto/create-config-group.dto";
import {DatabaseConfigDto} from './dto/database-config.dto';
import {CreateConfigDto} from "./dto/create-config.dto";
import {RedisConfigDto} from './dto/redis-config.dto';
import {ValueConfigDto} from "./dto/value-config.dto";
import {ConfigDto} from './dto/config.dto';

@Injectable()
export class ConfigService {
  @Inject(NestConfigService)
  private readonly nestConfigService: NestConfigService;

  @Inject(forwardRef(() => EmailService))
  private readonly emailServer: EmailService;

  @InjectRepository(ConfigGroup)
  private readonly configGroupRepository: Repository<ConfigGroup>;

  @InjectRepository(Config)
  private readonly configRepository: Repository<Config>;

  private readonly envFilePath = path.resolve(__dirname, '.env');
  private readonly envProdFilePath = path.resolve(__dirname, '.env.production');

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
      NODEMAILER_HOST: config.host || '1211',
      NODEMAILER_PORT: config.port,
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

  /**
   * 保存配置项的value值
   * @param valueConfigDto
   */
  public async createValue(valueConfigDto: ValueConfigDto & Record<string, any>) {
    const {group: groupName, ...resetValue} = valueConfigDto

    if (groupName === this.nestConfigService.get<string>('CONFIG_ALIAS_EMAIL')) {
      await this.saveEmail(resetValue as ConfigEmailDto);
    }

    if (!groupName) {
      throw new HttpException('变量分组不能为空！', HttpStatus.BAD_REQUEST)
    }
    const group = await this.configGroupRepository.find({
      where: {
        name: groupName
      }
    })
    const configNames = Object.keys(resetValue)
    const config = await this.configRepository.find({
      where: {
        group,
        name: In(configNames)
      },
      relations: {
        group: true
      }
    })
    for (const conf of config) {
      await this.configRepository.update(conf.id, {
        value: JSON.stringify(resetValue[conf.name])
      })
      if (conf.name === 'configGroup' && resetValue[conf.name]) {
        const dtos = resetValue[conf.name].map((dto: any) => {
          return {
            name: dto.key,
            title: dto.value
          }
        })
        await this.createOrUpdateConfigGroups(dtos)
      }
    }
    return await this.findAll()
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

    let quickEntrance = []
    config.forEach((conf) => {
      const groupName = conf.group.name

      if (!groupedData[groupName]) {
        groupedData[groupName] = []
      }
      const new_conf = {
        ...conf,
        group: groupName,
        rule: conf.rule?.split(','),
        extend: parseTextareaData(conf.extend),
        inputExtend: parseTextareaData(conf.inputExtend),
        value: conf.value && JSON.parse(conf.value),
      }
      groupedData[groupName].push(new_conf)

      if (new_conf.name === this.nestConfigService.get<string>('CONFIG_ALIAS_QUICK_ENTRANCE')) {
        quickEntrance = new_conf.value || []
      }
    })

    return {
      configGroup,
      config: groupedData,
      quickEntrance
    };
  }

  /**
   * 查找指定配置项的值
   * @param names - 配置项名称数组
   * @returns 包含配置项名称和对应值的对象
   */
  public async findFieldsValue(names: string[]): Promise<{ [key: string]: any }> {
    // 查询指定名称的配置项
    const config = await this.configRepository.find({
      select: ['name', 'value'],
      where: {
        name: In(names),
      },
    });

    // 将查询结果转换为键值对对象
    return config.reduce((acc, conf) => {
      acc[conf.name] = conf.value && JSON.parse(conf.value);
      return acc;
    }, {} as { [key: string]: any });
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

  async createOrUpdateConfigGroups(createConfigGroupDtos: CreateConfigGroupDto[]) {
    const keys = createConfigGroupDtos.map(dto => dto.name);

    await this.configGroupRepository.manager.transaction(async (entityManager) => {
      // 批量查询现有的 ConfigGroups
      const existingGroups = await entityManager.find(ConfigGroup);

      // 获取现有组的名称到实体的映射
      const existingGroupMap = new Map(existingGroups.map(group => [group.name, group]));

      // 找到需要删除的组
      const groupsToDelete = existingGroups.filter(group => !keys.includes(group.name));

      const groupsToSave = [];

      for (const dto of createConfigGroupDtos) {
        const existingGroup = existingGroupMap.get(dto.name);
        if (existingGroup) {
          // 如果存在且标题不同，则更新
          if (existingGroup.title !== dto.title) {
            existingGroup.title = dto.title;
            groupsToSave.push(existingGroup);
          }
        } else {
          // 如果不存在，则创建新的
          groupsToSave.push(
            entityManager.create(ConfigGroup, dto),
          );
        }
      }

      // 批量插入或更新组
      if (groupsToSave.length > 0) {
        await entityManager.save(groupsToSave);
      }

      // 批量删除组
      if (groupsToDelete.length > 0) {
        await entityManager.remove(groupsToDelete);
      }
    });
  }

  /**
   * 查询所有配置项分组
   */
  public async findAllGroup() {
    return await this.configGroupRepository.find()
  }
}
