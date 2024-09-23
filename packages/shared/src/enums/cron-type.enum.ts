export enum CronType {
  SERVICE = 'service',
  LOG_BACKUP = 'log_backup',
  LOG_CUT = 'log_cut',
  SQL_BACKUP = 'sql_backup',
  SHELL_SCRIPT = 'shell_script',
}

export const enum CronTypeName {
  service = '服务',
  log_backup = '日志备份',
  log_cut = '日志切割',
  sql_backup = '数据库备份',
  shell_script = 'Shell脚本',
}
