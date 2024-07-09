import { HttpException, HttpStatus, Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { Transporter, createTransport } from 'nodemailer';
import { GenerateEmailDto } from './dto/generate-email.dto';
import { ConfigEmailDto } from './dto/config-email.dto';

@Injectable()
export class EmailService {
  private transporter: Transporter;

  constructor(private configService: ConfigService) {
    this.transporter = createTransport({
      host: this.configService.get('NODEMAILER_HOST'),
      port: this.configService.get('NODEMAILER_PORT'),
      secure: false, // true 是 465 端口，false 是其他端口
      auth: {
        user: this.configService.get('NODEMAILER_AUTH_USER'),
        pass: this.configService.get('NODEMAILER_AUTH_PASS'),
      },
    });
  }

  public async sendMail({ to, subject, html }) {
    await this.transporter.sendMail({
      from: {
        name: 'Pirate Admin',
        address: this.configService.get('NODEMAILER_AUTH_USER'),
      },
      to,
      subject,
      html,
    });
  }

  /**
   * 保存数据后重新链接一次
   * @param config
   */
  public async connectEmail(config: ConfigEmailDto) {
    this.transporter = createTransport({
      host: config.host,
      port: config.port,
      secure: false, // true 是 465 端口，false 是其他端口
      auth: {
        user: config.user,
        pass: config.pass,
      },
    });
  }

  public async testEmail(config: GenerateEmailDto) {
    const { address, to, subject, html, host, port, user, pass } = config;
    if (address !== to) {
      throw new HttpException(
        '邮件发件人必须与授权用户相同！',
        HttpStatus.NOT_IMPLEMENTED,
      );
    }
    const transporter = createTransport({
      host,
      port,
      secure: false,
      auth: {
        user,
        pass,
      },
    });
    await transporter.sendMail({
      from: {
        name: 'Pirate Admin',
        address,
      },
      to,
      subject,
      html,
    });
    return '测试邮件发送成功';
  }
}
