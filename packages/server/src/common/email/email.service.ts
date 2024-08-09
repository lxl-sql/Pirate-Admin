import {forwardRef, HttpException, HttpStatus, Inject, Injectable} from '@nestjs/common';
import {createTransport, Transporter} from 'nodemailer';
import {ConfigService} from "@/modules/config/config.service";
import {GenerateEmailDto} from './dto/generate-email.dto';
import {ConfigEmailDto} from './dto/config-email.dto';

@Injectable()
export class EmailService {
  private transporter: Transporter;

  @Inject(forwardRef(() => ConfigService))
  private readonly configService: ConfigService;

  constructor() {
    ;(async () => {
      const {host, port, user, pass} = await this.getFieldsValue()
      const params = this.getParameters({host, port, user, pass})
      this.transporter = createTransport(params);
    })()
  }

  public async getFieldsValue() {
    return await this.configService?.findFieldsValue(['host', 'port', 'user', 'pass']) || {};
  }

  /**
   * 获取默认参数
   * @private
   */
  private getParameters({host, port, user, pass}) {
    return {
      host,
      port,
      secure: false, // true 是 465 端口，false 是其他端口
      auth: {
        user,
        pass,
      },
    }
  }

  /**
   * 检查邮箱配置参数是否存在
   * @throws HttpException - 如果任何必需的配置参数缺失
   */
  public async validationParameters() {
    const {host, port, user, pass} = await this.getFieldsValue()
    if (!host || !port || !user || !pass) {
      throw new HttpException(
        '邮箱配置参数缺失',
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
    return {host, port, user, pass}
  }

  public async sendMail({to, subject, html}) {
    const {host, port, user, pass} = await this.getFieldsValue()
    if (!this.transporter) {
      this.connectEmail({host, port, user, pass})
    }
    this.transporter.sendMail({
      from: {
        name: 'Pirate Admin',
        address: user,
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
    const {address, to, subject, html, host, port, user, pass} = config;
    if (address !== user) {
      throw new HttpException(
        '邮件发件人必须与授权用户相同！',
        HttpStatus.NOT_IMPLEMENTED,
      );
    }
    const params = this.getParameters({host, port, user, pass})
    const transporter = createTransport(params);
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
