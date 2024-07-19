import {HttpException, HttpStatus, Inject, Injectable} from '@nestjs/common';
import * as svgCaptcha from 'svg-captcha-fixed';
import {RedisService} from '../redis/redis.service';
import {EmailService} from '../email/email.service';
import {randomString} from '@/utils/tools';
import {SmsService} from '../sms/sms.service';
import {GenerateCaptchaDto} from './dto/generate-captcha.dto';
import {VerifyCaptchaDto} from './dto/verify-captcha.dto';
import {CaptchaTypeEnum} from "@/types/enum";

@Injectable()
export class CaptchaService {
  @Inject(RedisService)
  private readonly redisService: RedisService;

  @Inject(EmailService)
  private readonly emailService: EmailService;

  @Inject(SmsService)
  private readonly smsService: SmsService;

  /**
   * @description 获取随机运算符
   * @returns
   */
  private getRandomOperator() {
    const operators = ['+', '-', '*'];
    const randomIndex = Math.floor(Math.random() * operators.length);
    return operators[randomIndex];
  }

  /**
   * @description 获取 svg 验证码
   * @param session session 对象
   * @returns
   */
  public async svgCaptcha(session: Record<string, any>) {
    // create 字母和数字随机验证码
    // createMathExpr 数字算数随机验证码
    const {data, text} = svgCaptcha.createMathExpr({
      size: 4,
      //   ignoreChars: '0o1iIl',
      noise: 3,
      color: true,
      // background: '#fff',
      fontSize: 60,
      width: 100,
      height: 38,
      mathMin: 1,
      mathMax: 20,
      mathOperator: this.getRandomOperator(),
    });
    session.captcha = text;
    return data;
  }

  /**
   * @description 验证验证码
   * @param key 验证码 key
   * @param options 验证码选项
   * @returns
   */
  public async verifyCaptcha(key: string, options: VerifyCaptchaDto) {
    const {type, address, captcha} = options;

    const redis_key = `${key}_${address}`;

    const _captcha = await this.redisService.get(redis_key);

    if (!_captcha) {
      throw new HttpException('验证码已失效', HttpStatus.BAD_REQUEST);
    }
    if (captcha !== _captcha) {
      throw new HttpException('验证码错误', HttpStatus.BAD_REQUEST);
    }
    return redis_key;
  }

  /**
   * @description 生成验证码
   * @param options 验证码选项
   * @returns
   */
  public async generateCaptcha(options: GenerateCaptchaDto) {
    const {key, address, type, subject, html} = options;
    if (type === CaptchaTypeEnum.EMAIL) {
      await this.emailService.validationParameters()
    } else if (type === CaptchaTypeEnum.PHONE) {
      await this.smsService.validationParameters('aliyun')
    }
    const captcha = await this.redisService.get(key);
    if (captcha) {
      throw new HttpException(
        '验证码已发送，请稍后再试',
        HttpStatus.BAD_REQUEST,
      );
    }

    const code = randomString(6);
    const ttl = 1 * 60;

    try {
      if (type === CaptchaTypeEnum.EMAIL) {
        await this.emailService.sendMail({
          to: address,
          subject: subject,
          html: html
            ? html(code, ttl / 60)
            : `<p>你的${subject}是 ${code}，有效期为${ttl / 60}分钟</p>`,
        });
      } else if (type === CaptchaTypeEnum.PHONE) {
        await this.smsService.sendSMS({
          phone: address,
          type: 'aliyun', // 1：阿里云 2：腾讯云
          code,
          ttl,
        });
      }
      // 5分钟过期
      await this.redisService.set(key, code, ttl);
      return '发送成功';
    } catch (error) {
      throw new HttpException(error.message, HttpStatus.BAD_REQUEST);
    }
  }
}
