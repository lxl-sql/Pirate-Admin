export class SMSDTO {
  type: 'aliyun' | 'tencent'; // aliyun：阿里云 tencent：腾讯云
  phone: string;
  code: string;
  ttl: number; // 过期时间
}
