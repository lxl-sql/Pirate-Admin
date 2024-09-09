import { WINSTON_LOGGER_TOKEN } from '@/const/winston.const';
import { Inject, Injectable } from '@nestjs/common';
import { exec } from 'child_process';
import { AppLogger } from '../logger/app-logger.service';
import { platform } from 'os';
import * as iconv from 'iconv-lite';

export interface CommandResult {
  success: boolean;
  logs: string[];
}

@Injectable()
export class ShellTaskService {
  // 判断是否是windows系统
  private readonly isWindowsOS: boolean;

  constructor(
    @Inject(WINSTON_LOGGER_TOKEN)
    private readonly logger: AppLogger,
  ) {
    this.logger.setContext(ShellTaskService.name);
    this.isWindowsOS = platform() === 'win32';
  }

  private decodeOutput(data: Buffer | string): string {
    if (this.isWindowsOS) {
      return iconv.decode(data as Buffer, 'cp936');
    }
    return data as string;
  }

  /**
   * 执行shell命令
   * @param command shell命令
   * @returns 执行结果
   */
  async executeCommand(command: string): Promise<CommandResult> {
    const logs: string[] = [];
    return new Promise((resolve) => {
      logs.push(`执行命令: ${command}`);
      exec(command, (error, stdout, stderr) => {
        if (error) {
          logs.push(`执行命令失败: ${error.message}`);
          if (stderr) logs.push(`错误输出: ${this.decodeOutput(stderr)}`);
          resolve({
            success: false,
            logs,
          });
        } else {
          logs.push(`执行命令成功`);
          if (stdout) logs.push(`标准输出: ${this.decodeOutput(stdout)}`);
          resolve({
            success: true,
            logs,
          });
        }
      });
    });
  }
}
