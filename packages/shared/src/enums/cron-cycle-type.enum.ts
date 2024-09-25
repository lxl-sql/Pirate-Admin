export enum CronCycleType {
  /**
   * 每天
   * 小时 + 分钟
   * 每天，xx点xx分 执行
   */
  DAY = 'day',
  /**
   * N天
   * 天 + 小时 + 分钟
   * 每隔xx天，xx点xx分 执行
   */
  DAY_N = 'day-n',
  /**
   * 每小时
   * 分钟
   * 每小时，第xx分钟 执行
   */
  HOUR = 'hour',
  /**
   * N小时
   * 小时 + 分钟
   * 每隔xx小时，第xx分钟 执行
   */
  HOUR_N = 'hour-n',
  /**
   * N分钟
   * 分钟
   * 每隔xx分钟 执行
   */
  MINUTE_N = 'minute-n',
  /**
   * 每周
   * 周一至周日 + 小时 + 分钟
   * 每周一，xx点xx分 执行
   */
  WEEK = 'week',
  /**
   * 每月
   * 天 + 小时 + 分钟
   * 每月，xx日 xx点xx分 执行
   */
  MONTH = 'month',
}

export const enum CronCycleTypeName {
  'day' = '每天',
  'day-n' = '每N天',
  'hour' = '每小时',
  'hour-n' = '每N小时',
  'minute-n' = '每N分钟',
  'week' = '每周',
  'month' = '每月',
}
