import { WINSTON_LOGGER_TOKEN } from '@/const/winston.const';
import { Inject, Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { join } from 'path';
import {
  existsSync,
  mkdirSync,
  readFileSync,
  statSync,
  writeFileSync,
} from 'fs';
import mysqldump from 'mysqldump';

import { AppLogger } from '../logger/app-logger.service';

export interface SqlBackupResult {
  success: boolean;
  filePath?: string;
  backupDir: string;
  logs: string[];
  error?: string;
}

@Injectable()
export class BackupService {
  @Inject(ConfigService)
  private readonly configService: ConfigService;

  constructor(
    @Inject(WINSTON_LOGGER_TOKEN) private readonly logger: AppLogger,
  ) {
    this.logger.setContext(BackupService.name);
  }

  /**
   * 创建数据库备份
   * @returns 备份文件的路径
   */
  async createSqlBackup(): Promise<SqlBackupResult> {
    const startTime = new Date();
    const logs: string[] = [];
    let success = false;
    let error: string | undefined;

    logs.push(`开始数据库备份过程 - ${startTime.toISOString()}`);

    const dbConfig: mysqldump.ConnectionOptions = {
      host: this.configService.get<string>('MYSQL_HOST'),
      user: this.configService.get<string>('MYSQL_USERNAME'),
      password: this.configService.get<string>('MYSQL_PASSWORD'),
      database: this.configService.get<string>('MYSQL_DB'),
    };

    logs.push(
      `数据库配置: ${JSON.stringify({ ...dbConfig, password: '***' })}`,
    );

    const backupDir = join(__dirname, '..', 'backups');
    if (!existsSync(backupDir)) {
      mkdirSync(backupDir);
      logs.push(`创建备份目录: ${backupDir}`);
    }

    const fileName = `backup-${startTime
      .toISOString()
      .replace(/:/g, '-')
      .replace(/\./g, '-')}.sql`;
    const filePath = join(backupDir, fileName);
    // 相对路径
    const relativePath = join('backups', fileName);

    try {
      logs.push(`开始执行 mysqldump`);
      await mysqldump({
        connection: dbConfig,
        dumpToFile: filePath,
        compressFile: true, // 启用压缩
        // compressFile: false, // 暂时禁用压缩
      });

      if (!existsSync(filePath)) {
        throw new Error(`备份文件未创建: ${filePath}`);
      }

      const endTime = new Date();
      const duration = endTime.getTime() - startTime.getTime();
      const fileSize = statSync(filePath).size;

      logs.push(`数据库备份成功完成`);
      logs.push(`备份文件路径: ${filePath}`);
      logs.push(`备份文件相对路径: ${relativePath}`);
      logs.push(`备份文件名: ${fileName}`);
      logs.push(`文件大小: ${this.formatBytes(fileSize)}`);
      logs.push(`备份用时: ${duration / 1000} 秒`);
      logs.push(`备份结束时间: ${endTime.toISOString()}`);

      // 记录备份历史
      this.logBackupHistory(fileName, fileSize, startTime, endTime);
      success = true;
    } catch (err) {
      error = err.stack;
      logs.push(`数据库备份失败: ${error}`);
    }

    // 打印所有日志
    logs.forEach((log) => this.logger.log(log));

    return {
      success,
      filePath: success ? relativePath : undefined,
      backupDir,
      logs,
      error,
    };
  }

  private formatBytes(bytes: number): string {
    if (bytes === 0) return '0 Bytes';
    const k = 1024;
    const sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB'];
    const i = Math.floor(Math.log(bytes) / Math.log(k));
    return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
  }

  private logBackupHistory(
    fileName: string,
    fileSize: number,
    startTime: Date,
    endTime: Date,
  ) {
    const logEntry = {
      fileName,
      fileSize: this.formatBytes(fileSize),
      startTime: startTime.toISOString(),
      endTime: endTime.toISOString(),
      duration: `${(endTime.getTime() - startTime.getTime()) / 1000} 秒`,
    };

    const historyFilePath = join(
      __dirname,
      '..',
      'backups',
      'backup_history.json',
    );
    let history = [];

    if (existsSync(historyFilePath)) {
      const historyData = readFileSync(historyFilePath, 'utf8');
      history = JSON.parse(historyData);
    }

    history.push(logEntry);

    writeFileSync(historyFilePath, JSON.stringify(history, null, 2));
    this.logger.log(`备份历史已更新`);
  }
}
