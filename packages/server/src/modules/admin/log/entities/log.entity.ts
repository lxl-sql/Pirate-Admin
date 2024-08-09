import {Column, Entity} from 'typeorm';
import {DefaultEntity} from '@/entities/default.entity';

@Entity({
  name: 'admin_logs',
  comment: '管理员日志',
})
export class Log extends DefaultEntity {
  @Column({
    name: 'user_id',
    comment: '管理员id',
  })
  userId: number;

  @Column({
    name: 'username',
    comment: '管理员名称',
  })
  username: string;

  @Column({
    comment: '标题', // Title of the log
    default: '未知',
  })
  title: string;

  @Column({
    comment: 'ip',
  })
  ip: string;

  @Column({
    name: 'ip_address',
    comment: 'ip地址',
    nullable: true
  })
  ipAddress: string;

  @Column({
    comment: 'URL地址', // Path of the request URL that triggered the log
  })
  url: string;

  @Column({
    comment: '方法', // HTTP method of the request URL that triggered the log (GET, POST, PUT, DELETE, etc.)
    default: 'GET',
  })
  method: string;

  @Column({
    comment: '参数', // Request parameters
    nullable: true,
    type: 'text',
  })
  params: string;

  @Column({
    comment: '结果', // Response data
    nullable: true,
    type: 'text', // JSON string of the response data object or string
  })
  result: string;

  @Column({
    comment: '状态', // Status code
    default: 200,
  })
  status: number;

  @Column({
    name: 'response_time',
    comment: '响应时间', // Response time in milliseconds
    default: 0,
  })
  responseTime: number;

  @Column({
    name: 'user_agent',
    comment: '用户代理', // User agent
    nullable: true,
  })
  userAgent: string;
}
