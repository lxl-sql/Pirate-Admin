import { HttpException, HttpStatus, Inject, Injectable } from '@nestjs/common';
import * as AliSMSClient from '@alicloud/sms-sdk';
import * as TencentSMSClient from 'tencentcloud-sdk-nodejs';
import { SMSDTO } from './dto/sms.dto';
import { ConfigService } from '@nestjs/config';

@Injectable()
export class SmsService {
  @Inject(ConfigService)
  private configService: ConfigService;

  /**
   * @description 发送短信
   * @param sms
   */
  public async sendSMS(sms: SMSDTO) {
    const ttl = `${sms.ttl / 60}`;

    switch (sms.type) {
      case 'aliyun':
        await this.sendAliSMS(sms.phone, sms.code, ttl);
        break;
      case 'tencent':
        await this.sendTencentSMS(sms.phone, sms.code, ttl);
        break;
      default:
        throw new HttpException('Unsupported SMS Type', HttpStatus.BAD_REQUEST);
    }
  }

  /**
   * @description 发送阿里云短信
   * @param phone
   * @param code
   * @param ttl 过期时间/分钟
   * @returns
   */
  private async sendAliSMS(phone: string, code: string, ttl?: string) {
    const smsClient = new AliSMSClient({
      accessKeyId: this.configService.get('Ali_SMS_ACCESS_KEY_ID'),
      secretAccessKey: this.configService.get('Ali_SMS_SECRT_ACCESS_KEY'),
    });

    const params = {
      PhoneNumbers: phone,
      SignName: this.configService.get('Ali_SMS_SIGN_NAME'),
      TemplateCode: this.configService.get('Ali_SMS_TEMPLATE_CODE'),
      TemplateParam: `{"code":'${code}',"ttl":${ttl}}`,
    };

    try {
      const res = await smsClient.sendSMS(params);
      if (res.Code !== 'OK') {
        throw new HttpException('发送失败', HttpStatus.BAD_REQUEST);
      }
    } catch (error) {
      throw new HttpException('发送失败', HttpStatus.BAD_REQUEST);
    }
  }

  /**
   * @description 腾讯云短信发送 文档地址：https://cloud.tencent.com/document/product/382/43197
   * @param phone
   * @param code
   * @param ttl 过期时间/分钟
   */
  private async sendTencentSMS(phone: string, code: string, ttl?: string) {
    const smsClient = TencentSMSClient.sms.v20210111.Client;

    const client = new smsClient({
      credential: {
        secretId: this.configService.get('Tencent_SMS_SECRET_ID'),
        secretKey: this.configService.get('Tencent_SMS_SECRET_KEY'),
      },
      region: this.configService.get('Tencent_SMS_REGION'),
      profile: {
        httpProfile: {
          endpoint: 'sms.tencentcloudapi.com',
        },
      },
    });

    const params = {
      PhoneNumberSet: [`+86${phone}`],
      SmsSdkAppId: this.configService.get('Tencent_SMS_SDK_APP_ID'),
      TemplateId: this.configService.get('Tencent_SMS_TEMPLATE_ID'),
      SignName: this.configService.get('Tencent_SMS_SIGN_NAME'),
      TemplateParamSet: [code, ttl],
    };

    try {
      const res = await client.SendSms(params);

      if (res.SendStatusSet[0].Code !== 'Ok') {
        // 这边传递的是腾讯云返回的错误信息
        throw new HttpException(
          res.SendStatusSet[0].Message,
          HttpStatus.BAD_REQUEST,
        );
      }
    } catch (error) {
      throw new HttpException(error, HttpStatus.BAD_REQUEST);
    }
  }
}
