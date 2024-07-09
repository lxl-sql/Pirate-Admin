import { Inject, Injectable } from '@nestjs/common';
import { RedisClientType } from 'redis';

@Injectable()
export class RedisService {
  @Inject('REDIS_CLIENT')
  private redisClient: RedisClientType;

  /**
   * @description 获取 redis 缓存
   * @param key
   * @returns
   */
  public async get(key: string) {
    return await this.redisClient.get(key);
  }

  /**
   * @description 设置 redis 缓存
   * @param key
   * @param value
   * @param ttl
   */
  public async set(key: string, value: string | number, ttl?: number) {
    await this.redisClient.set(key, value);

    if (ttl) {
      this.redisClient.expire(key, ttl);
    }
  }

  public async del(key: string) {
    await this.redisClient.del(key);
  }
}
