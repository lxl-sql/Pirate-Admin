/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: admin_logs
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `admin_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `update_time` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  `create_time` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `user_id` int(11) NOT NULL COMMENT '管理员id',
  `username` varchar(255) NOT NULL COMMENT '管理员名称',
  `title` varchar(255) NOT NULL DEFAULT '未知' COMMENT '标题',
  `ip` varchar(255) NOT NULL COMMENT 'ip',
  `ip_address` varchar(255) DEFAULT NULL COMMENT 'ip地址',
  `url` varchar(255) NOT NULL COMMENT 'URL地址',
  `method` varchar(255) NOT NULL DEFAULT 'GET' COMMENT '方法',
  `params` text COMMENT '参数',
  `result` text COMMENT '结果',
  `status` int(11) NOT NULL DEFAULT '200' COMMENT '状态',
  `response_time` int(11) NOT NULL DEFAULT '0' COMMENT '响应时间',
  `user_agent` varchar(255) DEFAULT NULL COMMENT '用户代理',
  PRIMARY KEY (`id`)
) ENGINE = InnoDB AUTO_INCREMENT = 809 DEFAULT CHARSET = utf8mb4 COMMENT = '管理员日志';

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: admin_permissions
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `admin_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `update_time` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  `create_time` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `title` varchar(50) NOT NULL COMMENT '标题',
  `icon` varchar(50) DEFAULT NULL COMMENT '图标',
  `name` varchar(50) NOT NULL COMMENT '名称',
  `path` varchar(50) DEFAULT NULL COMMENT '路径',
  `component` varchar(50) DEFAULT NULL COMMENT '组件',
  `parentId` int(11) DEFAULT NULL COMMENT '父级ID',
  `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
  `type` int(11) NOT NULL COMMENT '类型',
  `code` varchar(50) DEFAULT NULL COMMENT '权限标识',
  `description` varchar(255) DEFAULT NULL COMMENT '描述',
  `frame` tinyint(4) NOT NULL DEFAULT '1' COMMENT '选项卡状态',
  `cache` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否缓存',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态',
  PRIMARY KEY (`id`),
  UNIQUE KEY `IDX_0662ac4d9fb0d45eef738f4975` (`name`)
) ENGINE = InnoDB AUTO_INCREMENT = 25 DEFAULT CHARSET = utf8mb4;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: admin_role_permissions_relation
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `admin_role_permissions_relation` (
  `role_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`role_id`, `permission_id`),
  KEY `IDX_1468c6d691c4898465473bbfef` (`role_id`),
  KEY `IDX_08af4b87c01a6bcce86750820a` (`permission_id`),
  CONSTRAINT `FK_08af4b87c01a6bcce86750820a2` FOREIGN KEY (`permission_id`) REFERENCES `admin_permissions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_1468c6d691c4898465473bbfefb` FOREIGN KEY (`role_id`) REFERENCES `admin_roles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: admin_roles
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `admin_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `update_time` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  `create_time` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `name` varchar(50) NOT NULL COMMENT '角色名',
  `slug` varchar(50) NOT NULL COMMENT '角色标识',
  `description` varchar(255) DEFAULT NULL COMMENT '描述',
  `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态',
  `parent_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `IDX_6e9e938900168e4a0786bb6588` (`name`),
  UNIQUE KEY `IDX_f5e394f493b5d8593abbb9dcb9` (`slug`),
  KEY `FK_c054435c1ef27e4c920d0534f85` (`parent_id`),
  CONSTRAINT `FK_c054435c1ef27e4c920d0534f85` FOREIGN KEY (`parent_id`) REFERENCES `admin_roles` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE = InnoDB AUTO_INCREMENT = 13 DEFAULT CHARSET = utf8mb4;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: admin_roles_closure
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `admin_roles_closure` (
  `id_ancestor` int(11) NOT NULL,
  `id_descendant` int(11) NOT NULL,
  PRIMARY KEY (`id_ancestor`, `id_descendant`),
  KEY `IDX_94085ec8d87f614a04dc1af3bd` (`id_ancestor`),
  KEY `IDX_799f254fe004d65a223a4b2af3` (`id_descendant`),
  CONSTRAINT `FK_799f254fe004d65a223a4b2af38` FOREIGN KEY (`id_descendant`) REFERENCES `admin_roles` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `FK_94085ec8d87f614a04dc1af3bdf` FOREIGN KEY (`id_ancestor`) REFERENCES `admin_roles` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: admin_roles_relation
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `admin_roles_relation` (
  `admin_id` int(11) NOT NULL,
  `role_id` int(11) NOT NULL,
  PRIMARY KEY (`admin_id`, `role_id`),
  KEY `IDX_565aa3adf84cde85112724be8b` (`admin_id`),
  KEY `IDX_d4227b9b2473b94e2ec9410e4f` (`role_id`),
  CONSTRAINT `FK_565aa3adf84cde85112724be8b7` FOREIGN KEY (`admin_id`) REFERENCES `admins` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_d4227b9b2473b94e2ec9410e4fe` FOREIGN KEY (`role_id`) REFERENCES `admin_roles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: admins
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `admins` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `update_time` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  `create_time` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `username` varchar(50) NOT NULL COMMENT '用户名',
  `password` varchar(50) NOT NULL COMMENT '密码',
  `nickname` varchar(50) NOT NULL COMMENT '昵称',
  `avatar` varchar(100) DEFAULT NULL COMMENT '头像',
  `email` varchar(50) DEFAULT NULL COMMENT '邮箱',
  `phone` varchar(50) DEFAULT NULL COMMENT '手机号',
  `motto` varchar(250) DEFAULT NULL COMMENT '座右铭',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态 0 禁用 1 启用',
  `last_login_ip` varchar(50) DEFAULT NULL COMMENT '最后登录ip',
  `last_login_time` datetime DEFAULT NULL COMMENT '最后登录时间',
  PRIMARY KEY (`id`)
) ENGINE = InnoDB AUTO_INCREMENT = 9 DEFAULT CHARSET = utf8mb4;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: config
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `config` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `update_time` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  `create_time` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `title` varchar(100) NOT NULL COMMENT '字段标题',
  `name` varchar(100) NOT NULL COMMENT '字段名',
  `type` varchar(100) NOT NULL DEFAULT 'input' COMMENT '字段类型',
  `tip` varchar(300) DEFAULT NULL COMMENT '提示信息',
  `rule` varchar(300) DEFAULT NULL COMMENT '校验规则',
  `content` varchar(300) DEFAULT NULL COMMENT '字典数据',
  `value` varchar(300) DEFAULT NULL COMMENT '默认value值',
  `extend` varchar(300) DEFAULT NULL COMMENT 'FormItem 扩展属性',
  `input_extend` varchar(300) DEFAULT NULL COMMENT 'input 扩展属性',
  `weight` int(11) NOT NULL DEFAULT '0' COMMENT '权重',
  `group_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `IDX_e0b2bbfeeba6650e0f356e2abd` (`name`),
  KEY `FK_ce1b247251d4942d8cd0c3dc2b1` (`group_id`),
  CONSTRAINT `FK_ce1b247251d4942d8cd0c3dc2b1` FOREIGN KEY (`group_id`) REFERENCES `config_group` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB AUTO_INCREMENT = 18 DEFAULT CHARSET = utf8mb4;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: config_group
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `config_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL COMMENT '分组字段',
  `title` varchar(100) NOT NULL COMMENT '分组标题',
  PRIMARY KEY (`id`),
  UNIQUE KEY `IDX_b41d06a3854a685b0d1cadd871` (`name`)
) ENGINE = InnoDB AUTO_INCREMENT = 4 DEFAULT CHARSET = utf8mb4;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: cron
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `cron` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `update_time` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  `create_time` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `name` varchar(255) NOT NULL COMMENT '任务名称',
  `type` varchar(255) NOT NULL DEFAULT 'service' COMMENT '任务类型',
  `description` varchar(255) DEFAULT NULL COMMENT '任务描述',
  `cycle` varchar(255) DEFAULT NULL COMMENT '执行周期拼接',
  `cycle_type` varchar(255) DEFAULT NULL COMMENT '执行周期类型',
  `save` int(11) DEFAULT NULL COMMENT '已保存数量 保存到本地',
  `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
  `notice` tinyint(4) DEFAULT '0' COMMENT '是否启用通知',
  `notice_channel` varchar(255) DEFAULT NULL COMMENT '通知渠道',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态 0 禁用 1 启用',
  `cron` char(20) DEFAULT NULL COMMENT 'Cron 表达式',
  PRIMARY KEY (`id`),
  UNIQUE KEY `IDX_2976b00bc88fe08b9487fbc995` (`name`)
) ENGINE = InnoDB AUTO_INCREMENT = 2 DEFAULT CHARSET = utf8mb4;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: cron-log
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `cron-log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `create_time` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `result` text NOT NULL COMMENT '执行结果描述，例如成功或失败原因',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态 0 失败 1 成功',
  `cronId` int(11) DEFAULT NULL,
  `backupFilePath` varchar(255) DEFAULT NULL COMMENT '备份文件路径',
  PRIMARY KEY (`id`),
  KEY `FK_2621d2269ccc5d8bde9202cf59e` (`cronId`),
  CONSTRAINT `FK_2621d2269ccc5d8bde9202cf59e` FOREIGN KEY (`cronId`) REFERENCES `cron` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE = InnoDB AUTO_INCREMENT = 3 DEFAULT CHARSET = utf8mb4;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: files
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `files` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `update_time` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  `create_time` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `name` varchar(255) NOT NULL COMMENT '附件名',
  `hash` varchar(255) NOT NULL COMMENT '附件 hash',
  `path` varchar(255) NOT NULL COMMENT '附件路径',
  `mimetype` varchar(100) NOT NULL COMMENT '附件类型',
  `size` int(11) NOT NULL COMMENT '附件大小',
  `upload_count` int(11) NOT NULL DEFAULT '1' COMMENT '上传次数',
  `username` varchar(50) NOT NULL COMMENT '用户名称',
  `usertype` tinyint(4) DEFAULT NULL COMMENT '用户类型 1: 管理员 2: 普通用户',
  PRIMARY KEY (`id`)
) ENGINE = InnoDB AUTO_INCREMENT = 171 DEFAULT CHARSET = utf8mb4 COMMENT = '附件表';

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: user_permissions
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `user_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `update_time` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  `create_time` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `code` varchar(50) NOT NULL COMMENT '权限码',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态',
  `description` varchar(300) NOT NULL COMMENT '权限描述',
  PRIMARY KEY (`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: user_role_permissions_relation
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `user_role_permissions_relation` (
  `role_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`role_id`, `permission_id`),
  KEY `IDX_47a3ae0008e00a0867307014c7` (`role_id`),
  KEY `IDX_a8bcf3b47f1ff0d5a99b66f6b4` (`permission_id`),
  CONSTRAINT `FK_47a3ae0008e00a0867307014c79` FOREIGN KEY (`role_id`) REFERENCES `user_roles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_a8bcf3b47f1ff0d5a99b66f6b41` FOREIGN KEY (`permission_id`) REFERENCES `user_permissions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: user_roles
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `user_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `update_time` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  `create_time` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `name` varchar(50) NOT NULL COMMENT '角色名',
  `slug` varchar(50) NOT NULL COMMENT '角色标识',
  `description` varchar(255) NOT NULL COMMENT '描述',
  `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态',
  `parent_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_0a2f05baa71fa3db220da2ec10a` (`parent_id`),
  CONSTRAINT `FK_0a2f05baa71fa3db220da2ec10a` FOREIGN KEY (`parent_id`) REFERENCES `user_roles` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: user_roles_closure
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `user_roles_closure` (
  `id_ancestor` int(11) NOT NULL,
  `id_descendant` int(11) NOT NULL,
  PRIMARY KEY (`id_ancestor`, `id_descendant`),
  KEY `IDX_184f428399b401f72b607e14f3` (`id_ancestor`),
  KEY `IDX_351e6a2306039722d8a0869d4d` (`id_descendant`),
  CONSTRAINT `FK_184f428399b401f72b607e14f33` FOREIGN KEY (`id_ancestor`) REFERENCES `user_roles` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `FK_351e6a2306039722d8a0869d4db` FOREIGN KEY (`id_descendant`) REFERENCES `user_roles` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: user_roles_relation
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `user_roles_relation` (
  `user_id` int(11) NOT NULL,
  `role_id` int(11) NOT NULL,
  PRIMARY KEY (`user_id`, `role_id`),
  KEY `IDX_6feb0c6f9a34d7b38196a9b969` (`user_id`),
  KEY `IDX_16f8615c7cb8a511949fb919a1` (`role_id`),
  CONSTRAINT `FK_16f8615c7cb8a511949fb919a16` FOREIGN KEY (`role_id`) REFERENCES `user_roles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_6feb0c6f9a34d7b38196a9b969c` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: users
# ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `update_time` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '更新时间',
  `create_time` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `username` varchar(50) NOT NULL COMMENT '用户名',
  `password` varchar(50) NOT NULL COMMENT '密码',
  `nickname` varchar(50) NOT NULL COMMENT '昵称',
  `avatar` varchar(100) DEFAULT NULL COMMENT '头像',
  `gender` tinyint(4) DEFAULT '0' COMMENT '性别 0:保密 1:男 2:女',
  `email` varchar(20) DEFAULT NULL COMMENT '邮箱',
  `phone` varchar(20) DEFAULT NULL COMMENT '手机号',
  `sign` varchar(300) DEFAULT NULL COMMENT '签名',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态 0:禁用 1:启用',
  `last_login_ip` varchar(50) DEFAULT NULL COMMENT '最后登录ip',
  `last_login_time` datetime DEFAULT NULL COMMENT '最后登录时间',
  PRIMARY KEY (`id`)
) ENGINE = InnoDB AUTO_INCREMENT = 2 DEFAULT CHARSET = utf8mb4;

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: admin_logs
# ------------------------------------------------------------

INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    502,
    '2024-08-27 22:31:42.047031',
    '2024-08-27 22:31:42.047031',
    4,
    'admin',
    '登录',
    '::1',
    '',
    '/admin/login',
    'POST',
    '{\"username\":\"admin\",\"password\":\"123456\",\"captcha\":\"0\",\"remember\":1,\"uuid\":\"69f8d246-c283-4bfb-8878-6d669f72b9e4\"}',
    '{\"code\":201,\"message\":\"请求成功\",\"data\":{\"userInfo\":{\"id\":4,\"username\":\"admin\",\"nickname\":\"admin\",\"avatar\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 22:31:41\",\"createTime\":\"2024-08-27 10:19:49\",\"updateTime\":\"2024-08-27 18:49:19\",\"roles\":[\"超级管理员\"],\"permissions\":[\"user_group\",\"auth\",\"auth_group\",\"auth_log\",\"user\",\"auth_menu\",\"auth_admin\",\"user_index\",\"user_rule\",\"user_log\",\"routine\",\"routine_config\",\"routine_annex\",\"routine_info\",\"module\",\"auth_group_create\",\"auth_group_update\",\"auth_group_info\",\"auth_group_delete\",\"auth_admin_create\",\"auth_admin_update\",\"auth_admin_info\",\"auth_admin_delete\",\"home\"]},\"accessToken\":\"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJyb2xlcyI6WyLotoXnuqfnrqHnkIblkZgiXSwicGVybWlzc2lvbnMiOlsidXNlcl9ncm91cCIsImF1dGgiLCJhdXRoX2dyb3VwIiwiYXV0aF9sb2ciLCJ1c2VyIiwiYXV0aF9tZW51IiwiYXV0aF9hZG1pbiIsInVzZXJfaW5kZXgiLCJ1c2VyX3J1bGUiLCJ1c2VyX2xvZyIsInJvdXRpbmUiLCJyb3V0aW5lX2NvbmZpZyIsInJvdXRpbmVfYW5uZXgiLCJyb3V0aW5lX2luZm8iLCJtb2R1bGUiLCJhdXRoX2dyb3VwX2NyZWF0ZSIsImF1dGhfZ3JvdXBfdXBkYXRlIiwiYXV0aF9ncm91cF9pbmZvIiwiYXV0aF9ncm91cF9kZWxldGUiLCJhdXRoX2FkbWluX2NyZWF0ZSIsImF1dGhfYWRtaW5fdXBkYXRlIiwiYXV0aF9hZG1pbl9pbmZvIiwiYXV0aF9hZG1pbl9kZWxldGUiLCJob21lIl0sImFjY2Vzc1Rva2VuIjp0cnVlLCJpYXQiOjE3MjQ3NjkxMDEsImV4cCI6MTcyNDc3MDkwMX0.NMR6YWHNWri7HKKWfCDQLZSlCd9oEU9J74vHvwlT0eQ\",\"refreshToken\":\"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJpYXQiOjE3MjQ3NjkxMDEsImV4cCI6MTcyNTM3MzkwMX0.3n3Uj74eYEVVzCQlxmc6NpaIhLO_CxJ_Ikz5Sl1tMsM\"}}',
    201,
    225,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    503,
    '2024-08-27 22:31:42.394833',
    '2024-08-27 22:31:42.394833',
    4,
    'admin',
    '管理员管理-详情',
    '::1',
    '',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-28 06:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 22:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    88,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    504,
    '2024-08-27 22:31:51.072960',
    '2024-08-27 22:31:51.072960',
    4,
    'admin',
    '角色组管理',
    '::1',
    '',
    '/admin/role',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":1,\"updateTime\":\"2024-08-27 10:19:49\",\"createTime\":\"2024-08-27 10:19:49\",\"name\":\"超级管理员\",\"slug\":\"super_admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":0,\"children\":[{\"id\":9,\"updateTime\":\"2024-08-27 10:19:49\",\"createTime\":\"2024-08-27 10:19:49\",\"name\":\"普通管理员\",\"slug\":\"admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":1,\"children\":[{\"id\":10,\"updateTime\":\"2024-08-27 10:19:49\",\"createTime\":\"2024-08-27 10:19:49\",\"name\":\"超级会员\",\"slug\":\"super_member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":9,\"children\":[{\"id\":11,\"updateTime\":\"2024-08-27 10:19:49\",\"createTime\":\"2024-08-27 10:19:49\",\"name\":\"普通会员\",\"slug\":\"member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":10,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 10:19:49\",\"createTime\":\"2024-08-27 10:19:49\",\"name\":\"普通用户\",\"slug\":\"user\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":11,\"children\":null}]}]}]}]}],\"remark\":null}}',
    200,
    87,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    505,
    '2024-08-27 22:33:08.155073',
    '2024-08-27 22:33:08.155073',
    4,
    'admin',
    '管理员管理-详情',
    '::1',
    '',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-28 06:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 22:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    122,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    506,
    '2024-08-27 22:33:08.146916',
    '2024-08-27 22:33:08.146916',
    4,
    'admin',
    '角色组管理',
    '::1',
    '',
    '/admin/role',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":1,\"updateTime\":\"2024-08-27 10:19:49\",\"createTime\":\"2024-08-27 10:19:49\",\"name\":\"超级管理员\",\"slug\":\"super_admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":0,\"children\":[{\"id\":9,\"updateTime\":\"2024-08-27 10:19:49\",\"createTime\":\"2024-08-27 10:19:49\",\"name\":\"普通管理员\",\"slug\":\"admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":1,\"children\":[{\"id\":10,\"updateTime\":\"2024-08-27 10:19:49\",\"createTime\":\"2024-08-27 10:19:49\",\"name\":\"超级会员\",\"slug\":\"super_member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":9,\"children\":[{\"id\":11,\"updateTime\":\"2024-08-27 10:19:49\",\"createTime\":\"2024-08-27 10:19:49\",\"name\":\"普通会员\",\"slug\":\"member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":10,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 10:19:49\",\"createTime\":\"2024-08-27 10:19:49\",\"name\":\"普通用户\",\"slug\":\"user\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":11,\"children\":null}]}]}]}]}],\"remark\":null}}',
    200,
    107,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    507,
    '2024-08-27 22:36:08.148086',
    '2024-08-27 22:36:08.148086',
    4,
    'admin',
    '管理员管理-详情',
    '::1',
    '',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-28 06:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 22:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    85,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    508,
    '2024-08-27 22:36:10.148161',
    '2024-08-27 22:36:10.148161',
    4,
    'admin',
    '角色组管理',
    '::1',
    '',
    '/admin/role',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":1,\"updateTime\":\"2024-08-27 10:19:49\",\"createTime\":\"2024-08-27 10:19:49\",\"name\":\"超级管理员\",\"slug\":\"super_admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":0,\"children\":[{\"id\":9,\"updateTime\":\"2024-08-27 10:19:49\",\"createTime\":\"2024-08-27 10:19:49\",\"name\":\"普通管理员\",\"slug\":\"admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":1,\"children\":[{\"id\":10,\"updateTime\":\"2024-08-27 10:19:49\",\"createTime\":\"2024-08-27 10:19:49\",\"name\":\"超级会员\",\"slug\":\"super_member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":9,\"children\":[{\"id\":11,\"updateTime\":\"2024-08-27 10:19:49\",\"createTime\":\"2024-08-27 10:19:49\",\"name\":\"普通会员\",\"slug\":\"member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":10,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 10:19:49\",\"createTime\":\"2024-08-27 10:19:49\",\"name\":\"普通用户\",\"slug\":\"user\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":11,\"children\":null}]}]}]}]}],\"remark\":null}}',
    200,
    74,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    509,
    '2024-08-27 22:36:14.134352',
    '2024-08-27 22:36:14.134352',
    4,
    'admin',
    '菜单规则管理',
    '::1',
    '',
    '/admin/permission',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":24,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"首页\",\"icon\":null,\"name\":\"home\",\"component\":null,\"parentId\":null,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":2,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"权限管理\",\"icon\":\"LineOutlined\",\"name\":\"auth\",\"component\":null,\"parentId\":null,\"sort\":98,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":3,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"角色组管理\",\"icon\":\"AimOutlined\",\"name\":\"auth_group\",\"component\":null,\"parentId\":2,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":16,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_group_create\",\"component\":null,\"parentId\":3,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":17,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_group_update\",\"component\":null,\"parentId\":3,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":18,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_group_info\",\"component\":null,\"parentId\":3,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":19,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_group_delete\",\"component\":null,\"parentId\":3,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":7,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"管理员管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_admin\",\"component\":null,\"parentId\":2,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":20,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_admin_create\",\"component\":null,\"parentId\":7,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":21,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_admin_update\",\"component\":null,\"parentId\":7,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":22,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_admin_info\",\"component\":null,\"parentId\":7,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":23,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_admin_delete\",\"component\":null,\"parentId\":7,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":6,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"菜单规则管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_menu\",\"component\":null,\"parentId\":2,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":4,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"管理员日志管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"auth_log\",\"component\":null,\"parentId\":2,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":5,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"会员管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"user\",\"component\":null,\"parentId\":null,\"sort\":97,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":8,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"会员管理\",\"icon\":\"LineOutlined\",\"name\":\"user_index\",\"component\":null,\"parentId\":5,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":1,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"会员分组管理\",\"icon\":null,\"name\":\"user_group\",\"component\":null,\"parentId\":5,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":9,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"会员规则管理\",\"icon\":\"AimOutlined\",\"name\":\"user_rule\",\"component\":null,\"parentId\":5,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":10,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"会员日志管理\",\"icon\":\"LineOutlined\",\"name\":\"user_log\",\"component\":null,\"parentId\":5,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":11,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"常规管理\",\"icon\":\"LineOutlined\",\"name\":\"routine\",\"component\":null,\"parentId\":null,\"sort\":96,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"系统配置\",\"icon\":\"LineOutlined\",\"name\":\"routine_config\",\"component\":\"/Routine/Config\",\"parentId\":11,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":14,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"个人资料\",\"icon\":\"LineOutlined\",\"name\":\"routine_info\",\"component\":\"/Routine/Info\",\"parentId\":11,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":13,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"附件管理\",\"icon\":null,\"name\":\"routine_annex\",\"component\":\"/Routine/Annex\",\"parentId\":11,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":15,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"模块市场\",\"icon\":null,\"name\":\"module\",\"component\":\"/Module\",\"parentId\":null,\"sort\":95,\"type\":2,\"code\":null,\"cache\":0,\"status\":0}],\"remark\":null}}',
    200,
    42,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    510,
    '2024-08-27 22:40:49.708603',
    '2024-08-27 22:40:49.708603',
    4,
    'admin',
    '管理员管理-详情',
    '::1',
    '',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"query\":\"SELECT DISTINCT `distinctAlias`.`Admin_id` AS `ids_Admin_id` FROM (SELECT `Admin`.`id` AS `Admin_id`, `Admin`.`update_time` AS `Admin_update_time`, `Admin`.`username` AS `Admin_username`, `Admin`.`password` AS `Admin_password`, `Admin`.`nickname` AS `Admin_nickname`, `Admin`.`avatar` AS `Admin_avatar`, `Admin`.`email` AS `Admin_email`, `Admin`.`phone` AS `Admin_phone`, `Admin`.`motto` AS `Admin_motto`, `Admin`.`status` AS `Admin_status`, `Admin`.`last_login_ip` AS `Admin_last_login_ip`, `Admin`.`last_login_time` AS `Admin_last_login_time`, `Admin__Admin_roles`.`id` AS `Admin__Admin_roles_id`, `Admin__Admin_roles`.`update_time` AS `Admin__Admin_roles_update_time`, `Admin__Admin_roles`.`create_time` AS `Admin__Admin_roles_create_time`, `Admin__Admin_roles`.`name` AS `Admin__Admin_roles_name`, `Admin__Admin_roles`.`slug` AS `Admin__Admin_roles_slug`, `Admin__Admin_roles`.`description` AS `Admin__Admin_roles_description`, `Admin__Admin_roles`.`sort` AS `Admin__Admin_roles_sort`, `Admin__Admin_roles`.`status` AS `Admin__Admin_roles_status`, `Admin__Admin_roles`.`parent_id` AS `Admin__Admin_roles_parent_id` FROM `admins` `Admin` LEFT JOIN `admin_roles_relation` `Admin_Admin__Admin_roles` ON `Admin_Admin__Admin_roles`.`admin_id`=`Admin`.`id` LEFT JOIN `admin_roles` `Admin__Admin_roles` ON `Admin__Admin_roles`.`id`=`Admin_Admin__Admin_roles`.`role_id` WHERE ((`Admin`.`id` = ?))) `distinctAlias` ORDER BY `Admin_id` ASC LIMIT 1\",\"parameters\":[4],\"driverError\":{\"errno\":-4077,\"code\":\"ECONNRESET\",\"syscall\":\"read\",\"fatal\":true},\"errno\":-4077,\"code\":\"ECONNRESET\",\"syscall\":\"read\",\"fatal\":true}',
    200,
    19232,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    511,
    '2024-08-27 22:40:49.717701',
    '2024-08-27 22:40:49.717701',
    4,
    'admin',
    '菜单规则管理',
    '::1',
    '',
    '/admin/permission',
    'GET',
    '{}',
    '{\"query\":\"SELECT `Permission`.`id` AS `Permission_id`, `Permission`.`update_time` AS `Permission_update_time`, `Permission`.`create_time` AS `Permission_create_time`, `Permission`.`title` AS `Permission_title`, `Permission`.`icon` AS `Permission_icon`, `Permission`.`name` AS `Permission_name`, `Permission`.`component` AS `Permission_component`, `Permission`.`parentId` AS `Permission_parentId`, `Permission`.`sort` AS `Permission_sort`, `Permission`.`type` AS `Permission_type`, `Permission`.`code` AS `Permission_code`, `Permission`.`cache` AS `Permission_cache`, `Permission`.`status` AS `Permission_status` FROM `admin_permissions` `Permission` ORDER BY `Permission_sort` DESC\",\"parameters\":[],\"driverError\":{\"errno\":-4077,\"code\":\"ECONNRESET\",\"syscall\":\"read\",\"fatal\":true},\"errno\":-4077,\"code\":\"ECONNRESET\",\"syscall\":\"read\",\"fatal\":true}',
    200,
    19255,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    512,
    '2024-08-27 22:41:30.512239',
    '2024-08-27 22:41:30.512239',
    4,
    'admin',
    '菜单规则管理',
    '::1',
    '',
    '/admin/permission',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":24,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"首页\",\"icon\":null,\"name\":\"home\",\"component\":null,\"parentId\":null,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":2,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"权限管理\",\"icon\":\"LineOutlined\",\"name\":\"auth\",\"component\":null,\"parentId\":null,\"sort\":98,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":3,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"角色组管理\",\"icon\":\"AimOutlined\",\"name\":\"auth_group\",\"component\":null,\"parentId\":2,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":16,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_group_create\",\"component\":null,\"parentId\":3,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":17,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_group_update\",\"component\":null,\"parentId\":3,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":18,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_group_info\",\"component\":null,\"parentId\":3,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":19,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_group_delete\",\"component\":null,\"parentId\":3,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":7,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"管理员管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_admin\",\"component\":null,\"parentId\":2,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":20,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_admin_create\",\"component\":null,\"parentId\":7,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":21,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_admin_update\",\"component\":null,\"parentId\":7,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":22,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_admin_info\",\"component\":null,\"parentId\":7,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":23,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_admin_delete\",\"component\":null,\"parentId\":7,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":6,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"菜单规则管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_menu\",\"component\":null,\"parentId\":2,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":4,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"管理员日志管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"auth_log\",\"component\":null,\"parentId\":2,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":5,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"会员管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"user\",\"component\":null,\"parentId\":null,\"sort\":97,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":8,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"会员管理\",\"icon\":\"LineOutlined\",\"name\":\"user_index\",\"component\":null,\"parentId\":5,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":1,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"会员分组管理\",\"icon\":null,\"name\":\"user_group\",\"component\":null,\"parentId\":5,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":9,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"会员规则管理\",\"icon\":\"AimOutlined\",\"name\":\"user_rule\",\"component\":null,\"parentId\":5,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":10,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"会员日志管理\",\"icon\":\"LineOutlined\",\"name\":\"user_log\",\"component\":null,\"parentId\":5,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":11,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"常规管理\",\"icon\":\"LineOutlined\",\"name\":\"routine\",\"component\":null,\"parentId\":null,\"sort\":96,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"系统配置\",\"icon\":\"LineOutlined\",\"name\":\"routine_config\",\"component\":\"/Routine/Config\",\"parentId\":11,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":14,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"个人资料\",\"icon\":\"LineOutlined\",\"name\":\"routine_info\",\"component\":\"/Routine/Info\",\"parentId\":11,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":13,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"附件管理\",\"icon\":null,\"name\":\"routine_annex\",\"component\":\"/Routine/Annex\",\"parentId\":11,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":15,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"模块市场\",\"icon\":null,\"name\":\"module\",\"component\":\"/Module\",\"parentId\":null,\"sort\":95,\"type\":2,\"code\":null,\"cache\":0,\"status\":0}],\"remark\":null}}',
    200,
    62,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    513,
    '2024-08-27 22:41:30.565512',
    '2024-08-27 22:41:30.565512',
    4,
    'admin',
    '管理员管理-详情',
    '::1',
    '',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-28 06:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 22:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    119,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    514,
    '2024-08-27 22:42:08.366314',
    '2024-08-27 22:42:08.366314',
    4,
    'admin',
    '角色组管理',
    '::1',
    '',
    '/admin/role',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":1,\"updateTime\":\"2024-08-27 10:19:49\",\"createTime\":\"2024-08-27 10:19:49\",\"name\":\"超级管理员\",\"slug\":\"super_admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":0,\"children\":[{\"id\":9,\"updateTime\":\"2024-08-27 10:19:49\",\"createTime\":\"2024-08-27 10:19:49\",\"name\":\"普通管理员\",\"slug\":\"admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":1,\"children\":[{\"id\":10,\"updateTime\":\"2024-08-27 10:19:49\",\"createTime\":\"2024-08-27 10:19:49\",\"name\":\"超级会员\",\"slug\":\"super_member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":9,\"children\":[{\"id\":11,\"updateTime\":\"2024-08-27 10:19:49\",\"createTime\":\"2024-08-27 10:19:49\",\"name\":\"普通会员\",\"slug\":\"member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":10,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 10:19:49\",\"createTime\":\"2024-08-27 10:19:49\",\"name\":\"普通用户\",\"slug\":\"user\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":11,\"children\":null}]}]}]}]}],\"remark\":null}}',
    200,
    82,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    515,
    '2024-08-27 22:44:27.415960',
    '2024-08-27 22:44:27.415960',
    4,
    'admin',
    '管理员管理-详情',
    '::1',
    '',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-28 06:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 22:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    160,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    516,
    '2024-08-27 22:44:58.852958',
    '2024-08-27 22:44:58.852958',
    4,
    'admin',
    '菜单规则管理',
    '::1',
    '',
    '/admin/permission',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":24,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"首页\",\"icon\":null,\"name\":\"home\",\"component\":null,\"parentId\":null,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":2,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"权限管理\",\"icon\":\"LineOutlined\",\"name\":\"auth\",\"component\":null,\"parentId\":null,\"sort\":98,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":3,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"角色组管理\",\"icon\":\"AimOutlined\",\"name\":\"auth_group\",\"component\":null,\"parentId\":2,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":16,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_group_create\",\"component\":null,\"parentId\":3,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":17,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_group_update\",\"component\":null,\"parentId\":3,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":18,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_group_info\",\"component\":null,\"parentId\":3,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":19,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_group_delete\",\"component\":null,\"parentId\":3,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":7,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"管理员管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_admin\",\"component\":null,\"parentId\":2,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":20,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_admin_create\",\"component\":null,\"parentId\":7,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":21,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_admin_update\",\"component\":null,\"parentId\":7,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":22,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_admin_info\",\"component\":null,\"parentId\":7,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":23,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_admin_delete\",\"component\":null,\"parentId\":7,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":6,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"菜单规则管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_menu\",\"component\":null,\"parentId\":2,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":4,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"管理员日志管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"auth_log\",\"component\":null,\"parentId\":2,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":5,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"会员管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"user\",\"component\":null,\"parentId\":null,\"sort\":97,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":8,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"会员管理\",\"icon\":\"LineOutlined\",\"name\":\"user_index\",\"component\":null,\"parentId\":5,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":1,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"会员分组管理\",\"icon\":null,\"name\":\"user_group\",\"component\":null,\"parentId\":5,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":9,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"会员规则管理\",\"icon\":\"AimOutlined\",\"name\":\"user_rule\",\"component\":null,\"parentId\":5,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":10,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"会员日志管理\",\"icon\":\"LineOutlined\",\"name\":\"user_log\",\"component\":null,\"parentId\":5,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":11,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"常规管理\",\"icon\":\"LineOutlined\",\"name\":\"routine\",\"component\":null,\"parentId\":null,\"sort\":96,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"系统配置\",\"icon\":\"LineOutlined\",\"name\":\"routine_config\",\"component\":\"/Routine/Config\",\"parentId\":11,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":14,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"个人资料\",\"icon\":\"LineOutlined\",\"name\":\"routine_info\",\"component\":\"/Routine/Info\",\"parentId\":11,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":13,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"附件管理\",\"icon\":null,\"name\":\"routine_annex\",\"component\":\"/Routine/Annex\",\"parentId\":11,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":15,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"模块市场\",\"icon\":null,\"name\":\"module\",\"component\":\"/Module\",\"parentId\":null,\"sort\":95,\"type\":2,\"code\":null,\"cache\":0,\"status\":0}],\"remark\":null}}',
    200,
    52,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    517,
    '2024-08-27 22:45:08.740767',
    '2024-08-27 22:45:08.740767',
    4,
    'admin',
    '菜单规则管理-修改状态',
    '::1',
    '',
    '/admin/permission/status',
    'POST',
    '{\"status\":0,\"ids\":[24]}',
    '{\"code\":201,\"message\":\"请求成功\",\"data\":\"修改成功\"}',
    201,
    65,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    518,
    '2024-08-27 22:45:09.837587',
    '2024-08-27 22:45:09.837587',
    4,
    'admin',
    '菜单规则管理-修改状态',
    '::1',
    '',
    '/admin/permission/status',
    'POST',
    '{\"status\":1,\"ids\":[24]}',
    '{\"code\":201,\"message\":\"请求成功\",\"data\":\"修改成功\"}',
    201,
    45,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    519,
    '2024-08-27 22:45:10.472585',
    '2024-08-27 22:45:10.472585',
    4,
    'admin',
    '菜单规则管理-修改状态',
    '::1',
    '',
    '/admin/permission/status',
    'POST',
    '{\"status\":0,\"ids\":[2,3,16,17,18,19,7,20,21,22,23,6,4]}',
    '{\"code\":201,\"message\":\"请求成功\",\"data\":\"修改成功\"}',
    201,
    47,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    520,
    '2024-08-27 22:45:11.300674',
    '2024-08-27 22:45:11.300674',
    4,
    'admin',
    '菜单规则管理-修改状态',
    '::1',
    '',
    '/admin/permission/status',
    'POST',
    '{\"status\":1,\"ids\":[2,3,16,17,18,19,7,20,21,22,23,6,4]}',
    '{\"code\":201,\"message\":\"请求成功\",\"data\":\"修改成功\"}',
    201,
    46,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    521,
    '2024-08-27 22:45:14.918868',
    '2024-08-27 22:45:14.918868',
    4,
    'admin',
    '菜单规则管理',
    '::1',
    '',
    '/admin/permission',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":24,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"首页\",\"icon\":null,\"name\":\"home\",\"component\":null,\"parentId\":null,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":2,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"权限管理\",\"icon\":\"LineOutlined\",\"name\":\"auth\",\"component\":null,\"parentId\":null,\"sort\":98,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":3,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"角色组管理\",\"icon\":\"AimOutlined\",\"name\":\"auth_group\",\"component\":null,\"parentId\":2,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":16,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_group_create\",\"component\":null,\"parentId\":3,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":17,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_group_update\",\"component\":null,\"parentId\":3,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":18,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_group_info\",\"component\":null,\"parentId\":3,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":19,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_group_delete\",\"component\":null,\"parentId\":3,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":7,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"管理员管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_admin\",\"component\":null,\"parentId\":2,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":20,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_admin_create\",\"component\":null,\"parentId\":7,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":21,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_admin_update\",\"component\":null,\"parentId\":7,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":22,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_admin_info\",\"component\":null,\"parentId\":7,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":23,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_admin_delete\",\"component\":null,\"parentId\":7,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":6,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"菜单规则管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_menu\",\"component\":null,\"parentId\":2,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":4,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"管理员日志管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"auth_log\",\"component\":null,\"parentId\":2,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":5,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"会员管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"user\",\"component\":null,\"parentId\":null,\"sort\":97,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":8,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"会员管理\",\"icon\":\"LineOutlined\",\"name\":\"user_index\",\"component\":null,\"parentId\":5,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":1,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"会员分组管理\",\"icon\":null,\"name\":\"user_group\",\"component\":null,\"parentId\":5,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":9,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"会员规则管理\",\"icon\":\"AimOutlined\",\"name\":\"user_rule\",\"component\":null,\"parentId\":5,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":10,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"会员日志管理\",\"icon\":\"LineOutlined\",\"name\":\"user_log\",\"component\":null,\"parentId\":5,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":11,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"常规管理\",\"icon\":\"LineOutlined\",\"name\":\"routine\",\"component\":null,\"parentId\":null,\"sort\":96,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"系统配置\",\"icon\":\"LineOutlined\",\"name\":\"routine_config\",\"component\":\"/Routine/Config\",\"parentId\":11,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":14,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"个人资料\",\"icon\":\"LineOutlined\",\"name\":\"routine_info\",\"component\":\"/Routine/Info\",\"parentId\":11,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":13,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"附件管理\",\"icon\":null,\"name\":\"routine_annex\",\"component\":\"/Routine/Annex\",\"parentId\":11,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":15,\"updateTime\":\"2024-08-27 10:19:48\",\"createTime\":\"2024-08-27 10:19:48\",\"title\":\"模块市场\",\"icon\":null,\"name\":\"module\",\"component\":\"/Module\",\"parentId\":null,\"sort\":95,\"type\":2,\"code\":null,\"cache\":0,\"status\":0}],\"remark\":null}}',
    200,
    44,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    522,
    '2024-08-27 22:45:14.954404',
    '2024-08-27 22:45:14.954404',
    4,
    'admin',
    '管理员管理-详情',
    '::1',
    '',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-28 06:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 22:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    85,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    523,
    '2024-08-27 23:02:52.204856',
    '2024-08-27 23:02:52.204856',
    4,
    'admin',
    'refresh刷新token',
    '::1',
    '',
    '/admin/refresh?refreshToken=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJpYXQiOjE3MjQ3NjkxMDEsImV4cCI6MTcyNTM3MzkwMX0.3n3Uj74eYEVVzCQlxmc6NpaIhLO_CxJ_Ikz5Sl1tMsM',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"accessToken\":\"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJyb2xlcyI6WyLotoXnuqfnrqHnkIblkZgiXSwicGVybWlzc2lvbnMiOlsidXNlcl9ncm91cCIsImF1dGgiLCJhdXRoX2dyb3VwIiwiYXV0aF9sb2ciLCJ1c2VyIiwiYXV0aF9tZW51IiwiYXV0aF9hZG1pbiIsInVzZXJfaW5kZXgiLCJ1c2VyX3J1bGUiLCJ1c2VyX2xvZyIsInJvdXRpbmUiLCJyb3V0aW5lX2NvbmZpZyIsInJvdXRpbmVfYW5uZXgiLCJyb3V0aW5lX2luZm8iLCJtb2R1bGUiLCJhdXRoX2dyb3VwX2NyZWF0ZSIsImF1dGhfZ3JvdXBfdXBkYXRlIiwiYXV0aF9ncm91cF9pbmZvIiwiYXV0aF9ncm91cF9kZWxldGUiLCJhdXRoX2FkbWluX2NyZWF0ZSIsImF1dGhfYWRtaW5fdXBkYXRlIiwiYXV0aF9hZG1pbl9pbmZvIiwiYXV0aF9hZG1pbl9kZWxldGUiLCJob21lIl0sImFjY2Vzc1Rva2VuIjp0cnVlLCJpYXQiOjE3MjQ3NzA5NzIsImV4cCI6MTcyNDc3Mjc3Mn0.aN_5ahY1iT_F1J9LsyTKmLqbxoss9CAVZqO_LAkj77w\",\"refreshToken\":\"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJpYXQiOjE3MjQ3NzA5NzIsImV4cCI6MTcyNTM3NTc3Mn0.ipEwcpQcU7ZQhCr7l0-4BT8LvNGgucUlrrUbWnQPAUE\"}}',
    200,
    149,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    524,
    '2024-08-28 09:05:06.566981',
    '2024-08-28 09:05:06.566981',
    4,
    'admin',
    'refresh刷新token',
    '127.0.0.1',
    '内网IP',
    '/admin/refresh?refreshToken=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJpYXQiOjE3MjQ3MjcwMDYsImV4cCI6MTcyNTMzMTgwNn0.ZdqWyjSjtuR82YaWhiNu3zY_EpiHNvchZPoTaWX1XW8',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"accessToken\":\"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJyb2xlcyI6WyLotoXnuqfnrqHnkIblkZgiXSwicGVybWlzc2lvbnMiOlsidXNlcl9ncm91cCIsImF1dGgiLCJhdXRoX2dyb3VwIiwiYXV0aF9sb2ciLCJ1c2VyIiwiYXV0aF9tZW51IiwiYXV0aF9hZG1pbiIsInVzZXJfaW5kZXgiLCJ1c2VyX3J1bGUiLCJ1c2VyX2xvZyIsInJvdXRpbmUiLCJyb3V0aW5lX2NvbmZpZyIsInJvdXRpbmVfYW5uZXgiLCJyb3V0aW5lX2luZm8iLCJtb2R1bGUiLCJhdXRoX2dyb3VwX2NyZWF0ZSIsImF1dGhfZ3JvdXBfdXBkYXRlIiwiYXV0aF9ncm91cF9pbmZvIiwiYXV0aF9ncm91cF9kZWxldGUiLCJhdXRoX2FkbWluX2NyZWF0ZSIsImF1dGhfYWRtaW5fdXBkYXRlIiwiYXV0aF9hZG1pbl9pbmZvIiwiYXV0aF9hZG1pbl9kZWxldGUiLCJob21lIl0sImFjY2Vzc1Rva2VuIjp0cnVlLCJpYXQiOjE3MjQ4MDcxNTIsImV4cCI6MTcyNDgwODk1Mn0.2-4xFRLPE3rbdWPsQ8AXQgdWeuZN0EdZCZRVPvbvE8k\",\"refreshToken\":\"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJpYXQiOjE3MjQ4MDcxNTIsImV4cCI6MTcyNTQxMTk1Mn0.YiI3iHms-H6z3If8y2dDwxV-08dEn5lNIYWUnH2yyLM\"}}',
    200,
    209,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    525,
    '2024-08-28 09:05:06.765476',
    '2024-08-28 09:05:06.765476',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-28 06:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 22:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    165,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    526,
    '2024-08-28 09:31:10.703165',
    '2024-08-28 09:31:10.703165',
    4,
    'admin',
    '附件管理',
    '127.0.0.1',
    '内网IP',
    '/files/list?page=1&size=10',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"page\":1,\"size\":10,\"total\":15,\"records\":[{\"id\":151,\"updateTime\":\"2024-08-27 10:19:50\",\"createTime\":\"2024-08-27 10:19:50\",\"name\":\"oceans.mp4\",\"hash\":\"9f8f979374969429263495ffcaac832cd603b1efe4c66a05fafd6729dffef9af\",\"path\":\"/uploads/2024/08/07/oceans.mp4\",\"mimetype\":\"video/mp4\",\"size\":23014356,\"uploadCount\":15,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/oceans.mp4\"},{\"id\":152,\"updateTime\":\"2024-08-27 10:19:50\",\"createTime\":\"2024-08-27 10:19:50\",\"name\":\"财务记账系统excel表格.xlsx\",\"hash\":\"b55ab38ff825b0360bea155510d9fee9c41812fabfe7e9fdb0aa36714195e266\",\"path\":\"/uploads/2024/08/07/财务记账系统excel表格.xlsx\",\"mimetype\":\"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet\",\"size\":97475,\"uploadCount\":4,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/财务记账系统excel表格.xlsx\"},{\"id\":153,\"updateTime\":\"2024-08-27 10:19:50\",\"createTime\":\"2024-08-27 10:19:50\",\"name\":\"测试Markdown.md\",\"hash\":\"9bab5812e9c7319230796121a872f2f10d47878d985c83fe88abd9e0119f73b0\",\"path\":\"/uploads/2024/08/07/测试Markdown.md\",\"mimetype\":\"application/octet-stream\",\"size\":11364,\"uploadCount\":2,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/测试Markdown.md\"},{\"id\":154,\"updateTime\":\"2024-08-27 10:19:50\",\"createTime\":\"2024-08-27 10:19:50\",\"name\":\"image.jpeg\",\"hash\":\"a737ff09ec2ce204c6a1e0edfe5af0b0c3a81c07af5d31f900b1ff55b39a2201\",\"path\":\"/uploads/2024/08/07/image.jpeg\",\"mimetype\":\"image/jpeg\",\"size\":106111,\"uploadCount\":11,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/image.jpeg\"},{\"id\":155,\"updateTime\":\"2024-08-27 10:19:50\",\"createTime\":\"2024-08-27 10:19:50\",\"name\":\"changtu1.jpg\",\"hash\":\"0d83b5b689384e4e08721f873a1c981cdcddd3de0f7493b23c21cc28efa4efee\",\"path\":\"/uploads/2024/08/07/changtu1.jpg\",\"mimetype\":\"image/jpeg\",\"size\":48593,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/changtu1.jpg\"},{\"id\":156,\"updateTime\":\"2024-08-27 10:19:50\",\"createTime\":\"2024-08-27 10:19:50\",\"name\":\"目录文件.doc\",\"hash\":\"b7dcfae78826ae565dfdd434145d3b74aca506738c0c31952370dd6b610b549d\",\"path\":\"/uploads/2024/08/07/目录文件.doc\",\"mimetype\":\"application/msword\",\"size\":1055816,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.doc\"},{\"id\":157,\"updateTime\":\"2024-08-27 10:19:50\",\"createTime\":\"2024-08-27 10:19:50\",\"name\":\"目录文件.htm\",\"hash\":\"c8cc7106cc4a16fedf0bafe622e8ede5905ff4f9b3064f03ecab7980dcb72671\",\"path\":\"/uploads/2024/08/07/目录文件.htm\",\"mimetype\":\"text/html\",\"size\":349870,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.htm\"},{\"id\":158,\"updateTime\":\"2024-08-27 10:19:50\",\"createTime\":\"2024-08-27 10:19:50\",\"name\":\"目录文件.txt\",\"hash\":\"4fb5c4132a38bf42068b9cd58fa8419e792e786a4a4160faf8fabf33d623371f\",\"path\":\"/uploads/2024/08/07/目录文件.txt\",\"mimetype\":\"text/plain\",\"size\":413766,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.txt\"},{\"id\":159,\"updateTime\":\"2024-08-27 10:19:50\",\"createTime\":\"2024-08-27 10:19:50\",\"name\":\"时间线规则.xmind\",\"hash\":\"9e21393ff90f96b9570e6dc5d8f1b4ca148d520f738fea61d0e8633d86865cac\",\"path\":\"/uploads/2024/08/07/时间线规则.xmind\",\"mimetype\":\"application/octet-stream\",\"size\":47082,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/时间线规则.xmind\"},{\"id\":165,\"updateTime\":\"2024-08-27 10:19:50\",\"createTime\":\"2024-08-27 10:19:50\",\"name\":\"新建 PPT 演示文稿.ppt\",\"hash\":\"310b06ff0a793076844f8be83a752745b3915cd23e35427b88047b801be76424\",\"path\":\"/uploads/2024/08/07/新建 PPT 演示文稿.ppt\",\"mimetype\":\"application/vnd.ms-powerpoint\",\"size\":20992,\"uploadCount\":7,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/新建 PPT 演示文稿.ppt\"}],\"remark\":\"同一文件被多次上传时，只会保存一份至磁盘和增加一条附件记录；删除附件记录，将自动删除对应文件！\"}}',
    200,
    92,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    527,
    '2024-08-28 10:13:44.302880',
    '2024-08-28 10:13:44.302880',
    4,
    'admin',
    'refresh刷新token',
    '127.0.0.1',
    '内网IP',
    '/admin/refresh?refreshToken=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJpYXQiOjE3MjQ4MDcxNTIsImV4cCI6MTcyNTQxMTk1Mn0.YiI3iHms-H6z3If8y2dDwxV-08dEn5lNIYWUnH2yyLM',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"accessToken\":\"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJyb2xlcyI6WyLotoXnuqfnrqHnkIblkZgiXSwicGVybWlzc2lvbnMiOlsidXNlcl9ncm91cCIsImF1dGgiLCJhdXRoX2dyb3VwIiwiYXV0aF9sb2ciLCJ1c2VyIiwiYXV0aF9tZW51IiwiYXV0aF9hZG1pbiIsInVzZXJfaW5kZXgiLCJ1c2VyX3J1bGUiLCJ1c2VyX2xvZyIsInJvdXRpbmUiLCJyb3V0aW5lX2NvbmZpZyIsInJvdXRpbmVfYW5uZXgiLCJyb3V0aW5lX2luZm8iLCJtb2R1bGUiLCJhdXRoX2dyb3VwX2NyZWF0ZSIsImF1dGhfZ3JvdXBfdXBkYXRlIiwiYXV0aF9ncm91cF9pbmZvIiwiYXV0aF9ncm91cF9kZWxldGUiLCJhdXRoX2FkbWluX2NyZWF0ZSIsImF1dGhfYWRtaW5fdXBkYXRlIiwiYXV0aF9hZG1pbl9pbmZvIiwiYXV0aF9hZG1pbl9kZWxldGUiLCJob21lIl0sImFjY2Vzc1Rva2VuIjp0cnVlLCJpYXQiOjE3MjQ4MTEyNzAsImV4cCI6MTcyNDgxMzA3MH0.PeuDU3avAquCfS_udwqTQS-pTWzw0vxibeJeCDEarhc\",\"refreshToken\":\"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJpYXQiOjE3MjQ4MTEyNzAsImV4cCI6MTcyNTQxNjA3MH0.40EuB3sZ0OlCHic4OkwQy4VxzJKn4bZp58ORmfKaHYE\"}}',
    200,
    86,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    528,
    '2024-08-28 10:13:44.498421',
    '2024-08-28 10:13:44.498421',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-28 06:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 22:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    187,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    529,
    '2024-08-28 10:13:51.414836',
    '2024-08-28 10:13:51.414836',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-28 06:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 22:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    77,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    530,
    '2024-08-28 10:13:58.617772',
    '2024-08-28 10:13:58.617772',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-28 06:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 22:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    65,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    531,
    '2024-08-28 10:15:30.697719',
    '2024-08-28 10:15:30.697719',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-28 06:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 22:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    82,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    532,
    '2024-08-28 10:16:22.630558',
    '2024-08-28 10:16:22.630558',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-28 06:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 22:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    153,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    533,
    '2024-08-28 11:31:22.006186',
    '2024-08-28 11:31:22.006186',
    4,
    'admin',
    'refresh刷新token',
    '127.0.0.1',
    '内网IP',
    '/admin/refresh?refreshToken=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJpYXQiOjE3MjQ4MTEyNzAsImV4cCI6MTcyNTQxNjA3MH0.40EuB3sZ0OlCHic4OkwQy4VxzJKn4bZp58ORmfKaHYE',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"accessToken\":\"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJyb2xlcyI6WyLotoXnuqfnrqHnkIblkZgiXSwicGVybWlzc2lvbnMiOlsidXNlcl9ncm91cCIsImF1dGgiLCJhdXRoX2dyb3VwIiwiYXV0aF9sb2ciLCJ1c2VyIiwiYXV0aF9tZW51IiwiYXV0aF9hZG1pbiIsInVzZXJfaW5kZXgiLCJ1c2VyX3J1bGUiLCJ1c2VyX2xvZyIsInJvdXRpbmUiLCJyb3V0aW5lX2NvbmZpZyIsInJvdXRpbmVfYW5uZXgiLCJyb3V0aW5lX2luZm8iLCJtb2R1bGUiLCJhdXRoX2dyb3VwX2NyZWF0ZSIsImF1dGhfZ3JvdXBfdXBkYXRlIiwiYXV0aF9ncm91cF9pbmZvIiwiYXV0aF9ncm91cF9kZWxldGUiLCJhdXRoX2FkbWluX2NyZWF0ZSIsImF1dGhfYWRtaW5fdXBkYXRlIiwiYXV0aF9hZG1pbl9pbmZvIiwiYXV0aF9hZG1pbl9kZWxldGUiLCJob21lIl0sImFjY2Vzc1Rva2VuIjp0cnVlLCJpYXQiOjE3MjQ4MTU5MjcsImV4cCI6MTcyNDgxNzcyN30.clXBfoEx4pieLiHvWaT7S9MrlpzaiC2m83CYpPIWMLM\",\"refreshToken\":\"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJpYXQiOjE3MjQ4MTU5MjcsImV4cCI6MTcyNTQyMDcyN30.2Gl5ZpNd0TAuGHSEZaPk9qj-BaEog0fSZdiXA7YNRKY\"}}',
    200,
    127,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    534,
    '2024-08-28 11:31:25.160595',
    '2024-08-28 11:31:25.160595',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-28 06:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 22:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    82,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    535,
    '2024-08-28 11:31:48.539769',
    '2024-08-28 11:31:48.539769',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-28 06:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 22:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    83,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    536,
    '2024-08-28 11:37:03.215451',
    '2024-08-28 11:37:03.215451',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-28 06:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 22:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    106,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    537,
    '2024-08-28 11:42:38.295596',
    '2024-08-28 11:42:38.295596',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-28 06:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 22:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    91,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    538,
    '2024-08-28 11:55:27.324613',
    '2024-08-28 11:55:27.324613',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-28 06:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 22:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    148,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    539,
    '2024-08-28 11:56:11.451123',
    '2024-08-28 11:56:11.451123',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-28 06:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 22:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    84,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    540,
    '2024-08-28 12:23:52.556060',
    '2024-08-28 12:23:52.556060',
    4,
    'admin',
    'refresh刷新token',
    '127.0.0.1',
    '内网IP',
    '/admin/refresh?refreshToken=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJpYXQiOjE3MjQ4MTU5MjcsImV4cCI6MTcyNTQyMDcyN30.2Gl5ZpNd0TAuGHSEZaPk9qj-BaEog0fSZdiXA7YNRKY',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"accessToken\":\"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJyb2xlcyI6WyLotoXnuqfnrqHnkIblkZgiXSwicGVybWlzc2lvbnMiOlsidXNlcl9ncm91cCIsImF1dGgiLCJhdXRoX2dyb3VwIiwiYXV0aF9sb2ciLCJ1c2VyIiwiYXV0aF9tZW51IiwiYXV0aF9hZG1pbiIsInVzZXJfaW5kZXgiLCJ1c2VyX3J1bGUiLCJ1c2VyX2xvZyIsInJvdXRpbmUiLCJyb3V0aW5lX2NvbmZpZyIsInJvdXRpbmVfYW5uZXgiLCJyb3V0aW5lX2luZm8iLCJtb2R1bGUiLCJhdXRoX2dyb3VwX2NyZWF0ZSIsImF1dGhfZ3JvdXBfdXBkYXRlIiwiYXV0aF9ncm91cF9pbmZvIiwiYXV0aF9ncm91cF9kZWxldGUiLCJhdXRoX2FkbWluX2NyZWF0ZSIsImF1dGhfYWRtaW5fdXBkYXRlIiwiYXV0aF9hZG1pbl9pbmZvIiwiYXV0aF9hZG1pbl9kZWxldGUiLCJob21lIl0sImFjY2Vzc1Rva2VuIjp0cnVlLCJpYXQiOjE3MjQ4MTkwNzgsImV4cCI6MTcyNDgyMDg3OH0.smH5uL_hvKn-5SH3yc9Qcq6lEPEl5xj3sE29zSd41fU\",\"refreshToken\":\"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJpYXQiOjE3MjQ4MTkwNzgsImV4cCI6MTcyNTQyMzg3OH0.2YSkLowxx_nLOTzL6f0MvblEGNEvPfV0XnbCJsOsXdk\"}}',
    200,
    154,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    541,
    '2024-08-28 12:24:01.576286',
    '2024-08-28 12:24:01.576286',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-28 06:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 22:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    91,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    542,
    '2024-08-28 12:24:38.436448',
    '2024-08-28 12:24:38.436448',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-28 06:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 22:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    83,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    543,
    '2024-08-28 12:26:28.682458',
    '2024-08-28 12:26:28.682458',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-28 06:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 22:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    69,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    544,
    '2024-08-28 12:43:41.078135',
    '2024-08-28 12:43:41.078135',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-28 06:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 22:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    73,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    545,
    '2024-08-28 12:46:52.880542',
    '2024-08-28 12:46:52.880542',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-28 06:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 22:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    74,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    546,
    '2024-08-28 12:48:09.159504',
    '2024-08-28 12:48:09.159504',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-28 06:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 22:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    70,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    547,
    '2024-08-28 12:48:38.567723',
    '2024-08-28 12:48:38.567723',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-28 06:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 22:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    65,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    548,
    '2024-08-28 12:49:35.049869',
    '2024-08-28 12:49:35.049869',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-28 06:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 22:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    71,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    549,
    '2024-08-28 14:14:08.299592',
    '2024-08-28 14:14:08.299592',
    4,
    'admin',
    'refresh刷新token',
    '127.0.0.1',
    '内网IP',
    '/admin/refresh?refreshToken=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJpYXQiOjE3MjQ4MTkwNzgsImV4cCI6MTcyNTQyMzg3OH0.2YSkLowxx_nLOTzL6f0MvblEGNEvPfV0XnbCJsOsXdk',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"accessToken\":\"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJyb2xlcyI6WyLotoXnuqfnrqHnkIblkZgiXSwicGVybWlzc2lvbnMiOlsidXNlcl9ncm91cCIsImF1dGgiLCJhdXRoX2dyb3VwIiwiYXV0aF9sb2ciLCJ1c2VyIiwiYXV0aF9tZW51IiwiYXV0aF9hZG1pbiIsInVzZXJfaW5kZXgiLCJ1c2VyX3J1bGUiLCJ1c2VyX2xvZyIsInJvdXRpbmUiLCJyb3V0aW5lX2NvbmZpZyIsInJvdXRpbmVfYW5uZXgiLCJyb3V0aW5lX2luZm8iLCJtb2R1bGUiLCJhdXRoX2dyb3VwX2NyZWF0ZSIsImF1dGhfZ3JvdXBfdXBkYXRlIiwiYXV0aF9ncm91cF9pbmZvIiwiYXV0aF9ncm91cF9kZWxldGUiLCJhdXRoX2FkbWluX2NyZWF0ZSIsImF1dGhfYWRtaW5fdXBkYXRlIiwiYXV0aF9hZG1pbl9pbmZvIiwiYXV0aF9hZG1pbl9kZWxldGUiLCJob21lIl0sImFjY2Vzc1Rva2VuIjp0cnVlLCJpYXQiOjE3MjQ4MjU2OTQsImV4cCI6MTcyNDgyNzQ5NH0.NR14ODMEYwUN2F9L8WjvwE6kdls6oAoqCVpOIzQ8t9A\",\"refreshToken\":\"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJpYXQiOjE3MjQ4MjU2OTQsImV4cCI6MTcyNTQzMDQ5NH0.wpsb2YxSBhQs__sANB2OhMnTq6x8vt56AK3Sm5JQDAE\"}}',
    200,
    167,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    550,
    '2024-08-28 14:14:20.766142',
    '2024-08-28 14:14:20.766142',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-28 06:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 22:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    67,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    551,
    '2024-08-28 14:14:56.661929',
    '2024-08-28 14:14:56.661929',
    4,
    'admin',
    '角色组管理',
    '127.0.0.1',
    '内网IP',
    '/admin/role',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":1,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"超级管理员\",\"slug\":\"super_admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":0,\"children\":[{\"id\":9,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通管理员\",\"slug\":\"admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":1,\"children\":[{\"id\":10,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"超级会员\",\"slug\":\"super_member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":9,\"children\":[{\"id\":11,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通会员\",\"slug\":\"member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":10,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通用户\",\"slug\":\"user\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":11,\"children\":null}]}]}]}]}],\"remark\":null}}',
    200,
    72,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    552,
    '2024-08-28 14:48:25.410785',
    '2024-08-28 14:48:25.410785',
    4,
    'admin',
    'refresh刷新token',
    '127.0.0.1',
    '内网IP',
    '/admin/refresh?refreshToken=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJpYXQiOjE3MjQ4MjU2OTQsImV4cCI6MTcyNTQzMDQ5NH0.wpsb2YxSBhQs__sANB2OhMnTq6x8vt56AK3Sm5JQDAE',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"accessToken\":\"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJyb2xlcyI6WyLotoXnuqfnrqHnkIblkZgiXSwicGVybWlzc2lvbnMiOlsidXNlcl9ncm91cCIsImF1dGgiLCJhdXRoX2dyb3VwIiwiYXV0aF9sb2ciLCJ1c2VyIiwiYXV0aF9tZW51IiwiYXV0aF9hZG1pbiIsInVzZXJfaW5kZXgiLCJ1c2VyX3J1bGUiLCJ1c2VyX2xvZyIsInJvdXRpbmUiLCJyb3V0aW5lX2NvbmZpZyIsInJvdXRpbmVfYW5uZXgiLCJyb3V0aW5lX2luZm8iLCJtb2R1bGUiLCJhdXRoX2dyb3VwX2NyZWF0ZSIsImF1dGhfZ3JvdXBfdXBkYXRlIiwiYXV0aF9ncm91cF9pbmZvIiwiYXV0aF9ncm91cF9kZWxldGUiLCJhdXRoX2FkbWluX2NyZWF0ZSIsImF1dGhfYWRtaW5fdXBkYXRlIiwiYXV0aF9hZG1pbl9pbmZvIiwiYXV0aF9hZG1pbl9kZWxldGUiLCJob21lIl0sImFjY2Vzc1Rva2VuIjp0cnVlLCJpYXQiOjE3MjQ4Mjc3NTEsImV4cCI6MTcyNDgyOTU1MX0.yx9Uvb0WJGpy8xqfRhXgCTgofxz1H-L2KpCeklh4HQM\",\"refreshToken\":\"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJpYXQiOjE3MjQ4Mjc3NTEsImV4cCI6MTcyNTQzMjU1MX0.lWJrYVDS6_2Mnc0wPOwvMnGf2Nz86mevGYABQ24en7I\"}}',
    200,
    347,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    553,
    '2024-08-28 14:48:50.761016',
    '2024-08-28 14:48:50.761016',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    62,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    554,
    '2024-08-28 17:25:10.553912',
    '2024-08-28 17:25:10.553912',
    4,
    'admin',
    'refresh刷新token',
    '127.0.0.1',
    '内网IP',
    '/admin/refresh?refreshToken=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJpYXQiOjE3MjQ4Mjc3NTEsImV4cCI6MTcyNTQzMjU1MX0.lWJrYVDS6_2Mnc0wPOwvMnGf2Nz86mevGYABQ24en7I',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"accessToken\":\"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJyb2xlcyI6WyLotoXnuqfnrqHnkIblkZgiXSwicGVybWlzc2lvbnMiOlsidXNlcl9ncm91cCIsImF1dGgiLCJhdXRoX2dyb3VwIiwiYXV0aF9sb2ciLCJ1c2VyIiwiYXV0aF9tZW51IiwiYXV0aF9hZG1pbiIsInVzZXJfaW5kZXgiLCJ1c2VyX3J1bGUiLCJ1c2VyX2xvZyIsInJvdXRpbmUiLCJyb3V0aW5lX2NvbmZpZyIsInJvdXRpbmVfYW5uZXgiLCJyb3V0aW5lX2luZm8iLCJtb2R1bGUiLCJhdXRoX2dyb3VwX2NyZWF0ZSIsImF1dGhfZ3JvdXBfdXBkYXRlIiwiYXV0aF9ncm91cF9pbmZvIiwiYXV0aF9ncm91cF9kZWxldGUiLCJhdXRoX2FkbWluX2NyZWF0ZSIsImF1dGhfYWRtaW5fdXBkYXRlIiwiYXV0aF9hZG1pbl9pbmZvIiwiYXV0aF9hZG1pbl9kZWxldGUiLCJob21lIl0sImFjY2Vzc1Rva2VuIjp0cnVlLCJpYXQiOjE3MjQ4MzcxNTYsImV4cCI6MTcyNDgzODk1Nn0.StgI4WskammrVg6TsNh4e_TpNGjpsrwvowcNHp6BdCE\",\"refreshToken\":\"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJpYXQiOjE3MjQ4MzcxNTYsImV4cCI6MTcyNTQ0MTk1Nn0.-I1EfKO_3TsEF4r175gPhrv-fFDwhuQeBoTUxn6J20E\"}}',
    200,
    124,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    555,
    '2024-08-28 17:25:10.703717',
    '2024-08-28 17:25:10.703717',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    133,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    556,
    '2024-08-28 17:38:54.049577',
    '2024-08-28 17:38:54.049577',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    100,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    557,
    '2024-08-28 17:39:37.625905',
    '2024-08-28 17:39:37.625905',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    113,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    558,
    '2024-08-28 17:39:39.519416',
    '2024-08-28 17:39:39.519416',
    4,
    'admin',
    '角色组管理',
    '127.0.0.1',
    '内网IP',
    '/admin/role',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":1,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"超级管理员\",\"slug\":\"super_admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":0,\"children\":[{\"id\":9,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通管理员\",\"slug\":\"admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":1,\"children\":[{\"id\":10,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"超级会员\",\"slug\":\"super_member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":9,\"children\":[{\"id\":11,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通会员\",\"slug\":\"member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":10,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通用户\",\"slug\":\"user\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":11,\"children\":null}]}]}]}]}],\"remark\":null}}',
    200,
    76,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    559,
    '2024-08-28 17:39:40.099690',
    '2024-08-28 17:39:40.099690',
    4,
    'admin',
    '菜单规则管理',
    '127.0.0.1',
    '内网IP',
    '/admin/permission',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":24,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"首页\",\"icon\":null,\"name\":\"home\",\"component\":null,\"parentId\":null,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":2,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"权限管理\",\"icon\":\"LineOutlined\",\"name\":\"auth\",\"component\":null,\"parentId\":null,\"sort\":98,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":3,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"角色组管理\",\"icon\":\"AimOutlined\",\"name\":\"auth_group\",\"component\":null,\"parentId\":2,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":16,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_group_create\",\"component\":null,\"parentId\":3,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":17,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_group_update\",\"component\":null,\"parentId\":3,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":18,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_group_info\",\"component\":null,\"parentId\":3,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":19,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_group_delete\",\"component\":null,\"parentId\":3,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":7,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"管理员管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_admin\",\"component\":null,\"parentId\":2,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":20,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_admin_create\",\"component\":null,\"parentId\":7,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":21,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_admin_update\",\"component\":null,\"parentId\":7,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":22,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_admin_info\",\"component\":null,\"parentId\":7,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":23,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_admin_delete\",\"component\":null,\"parentId\":7,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":6,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"菜单规则管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_menu\",\"component\":null,\"parentId\":2,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":4,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"管理员日志管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"auth_log\",\"component\":null,\"parentId\":2,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":5,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"user\",\"component\":null,\"parentId\":null,\"sort\":97,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":8,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员管理\",\"icon\":\"LineOutlined\",\"name\":\"user_index\",\"component\":null,\"parentId\":5,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":1,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员分组管理\",\"icon\":null,\"name\":\"user_group\",\"component\":null,\"parentId\":5,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":9,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员规则管理\",\"icon\":\"AimOutlined\",\"name\":\"user_rule\",\"component\":null,\"parentId\":5,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":10,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员日志管理\",\"icon\":\"LineOutlined\",\"name\":\"user_log\",\"component\":null,\"parentId\":5,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":11,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"常规管理\",\"icon\":\"LineOutlined\",\"name\":\"routine\",\"component\":null,\"parentId\":null,\"sort\":96,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"系统配置\",\"icon\":\"LineOutlined\",\"name\":\"routine_config\",\"component\":\"/Routine/Config\",\"parentId\":11,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":14,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"个人资料\",\"icon\":\"LineOutlined\",\"name\":\"routine_info\",\"component\":\"/Routine/Info\",\"parentId\":11,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":13,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"附件管理\",\"icon\":null,\"name\":\"routine_annex\",\"component\":\"/Routine/Annex\",\"parentId\":11,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":15,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"模块市场\",\"icon\":null,\"name\":\"module\",\"component\":\"/Module\",\"parentId\":null,\"sort\":95,\"type\":2,\"code\":null,\"cache\":0,\"status\":0}],\"remark\":null}}',
    200,
    40,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    560,
    '2024-08-28 17:40:11.729137',
    '2024-08-28 17:40:11.729137',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    60,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    561,
    '2024-08-28 17:40:11.734900',
    '2024-08-28 17:40:11.734900',
    4,
    'admin',
    '角色组管理',
    '127.0.0.1',
    '内网IP',
    '/admin/role',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":1,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"超级管理员\",\"slug\":\"super_admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":0,\"children\":[{\"id\":9,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通管理员\",\"slug\":\"admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":1,\"children\":[{\"id\":10,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"超级会员\",\"slug\":\"super_member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":9,\"children\":[{\"id\":11,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通会员\",\"slug\":\"member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":10,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通用户\",\"slug\":\"user\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":11,\"children\":null}]}]}]}]}],\"remark\":null}}',
    200,
    63,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    562,
    '2024-08-28 17:40:12.749027',
    '2024-08-28 17:40:12.749027',
    4,
    'admin',
    '菜单规则管理',
    '127.0.0.1',
    '内网IP',
    '/admin/permission',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":24,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"首页\",\"icon\":null,\"name\":\"home\",\"component\":null,\"parentId\":null,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":2,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"权限管理\",\"icon\":\"LineOutlined\",\"name\":\"auth\",\"component\":null,\"parentId\":null,\"sort\":98,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":3,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"角色组管理\",\"icon\":\"AimOutlined\",\"name\":\"auth_group\",\"component\":null,\"parentId\":2,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":16,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_group_create\",\"component\":null,\"parentId\":3,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":17,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_group_update\",\"component\":null,\"parentId\":3,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":18,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_group_info\",\"component\":null,\"parentId\":3,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":19,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_group_delete\",\"component\":null,\"parentId\":3,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":7,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"管理员管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_admin\",\"component\":null,\"parentId\":2,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":20,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_admin_create\",\"component\":null,\"parentId\":7,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":21,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_admin_update\",\"component\":null,\"parentId\":7,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":22,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_admin_info\",\"component\":null,\"parentId\":7,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":23,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_admin_delete\",\"component\":null,\"parentId\":7,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":6,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"菜单规则管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_menu\",\"component\":null,\"parentId\":2,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":4,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"管理员日志管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"auth_log\",\"component\":null,\"parentId\":2,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":5,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"user\",\"component\":null,\"parentId\":null,\"sort\":97,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":8,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员管理\",\"icon\":\"LineOutlined\",\"name\":\"user_index\",\"component\":null,\"parentId\":5,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":1,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员分组管理\",\"icon\":null,\"name\":\"user_group\",\"component\":null,\"parentId\":5,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":9,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员规则管理\",\"icon\":\"AimOutlined\",\"name\":\"user_rule\",\"component\":null,\"parentId\":5,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":10,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员日志管理\",\"icon\":\"LineOutlined\",\"name\":\"user_log\",\"component\":null,\"parentId\":5,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":11,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"常规管理\",\"icon\":\"LineOutlined\",\"name\":\"routine\",\"component\":null,\"parentId\":null,\"sort\":96,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"系统配置\",\"icon\":\"LineOutlined\",\"name\":\"routine_config\",\"component\":\"/Routine/Config\",\"parentId\":11,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":14,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"个人资料\",\"icon\":\"LineOutlined\",\"name\":\"routine_info\",\"component\":\"/Routine/Info\",\"parentId\":11,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":13,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"附件管理\",\"icon\":null,\"name\":\"routine_annex\",\"component\":\"/Routine/Annex\",\"parentId\":11,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":15,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"模块市场\",\"icon\":null,\"name\":\"module\",\"component\":\"/Module\",\"parentId\":null,\"sort\":95,\"type\":2,\"code\":null,\"cache\":0,\"status\":0}],\"remark\":null}}',
    200,
    33,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    563,
    '2024-08-28 17:42:46.948163',
    '2024-08-28 17:42:46.948163',
    4,
    'admin',
    '角色组管理',
    '127.0.0.1',
    '内网IP',
    '/admin/role',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":1,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"超级管理员\",\"slug\":\"super_admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":0,\"children\":[{\"id\":9,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通管理员\",\"slug\":\"admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":1,\"children\":[{\"id\":10,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"超级会员\",\"slug\":\"super_member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":9,\"children\":[{\"id\":11,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通会员\",\"slug\":\"member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":10,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通用户\",\"slug\":\"user\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":11,\"children\":null}]}]}]}]}],\"remark\":null}}',
    200,
    107,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    564,
    '2024-08-28 17:42:46.954850',
    '2024-08-28 17:42:46.954850',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    115,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    565,
    '2024-08-28 17:42:48.146752',
    '2024-08-28 17:42:48.146752',
    4,
    'admin',
    '菜单规则管理',
    '127.0.0.1',
    '内网IP',
    '/admin/permission',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":24,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"首页\",\"icon\":null,\"name\":\"home\",\"component\":null,\"parentId\":null,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":2,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"权限管理\",\"icon\":\"LineOutlined\",\"name\":\"auth\",\"component\":null,\"parentId\":null,\"sort\":98,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":3,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"角色组管理\",\"icon\":\"AimOutlined\",\"name\":\"auth_group\",\"component\":null,\"parentId\":2,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":16,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_group_create\",\"component\":null,\"parentId\":3,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":17,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_group_update\",\"component\":null,\"parentId\":3,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":18,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_group_info\",\"component\":null,\"parentId\":3,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":19,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_group_delete\",\"component\":null,\"parentId\":3,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":7,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"管理员管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_admin\",\"component\":null,\"parentId\":2,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":20,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_admin_create\",\"component\":null,\"parentId\":7,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":21,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_admin_update\",\"component\":null,\"parentId\":7,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":22,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_admin_info\",\"component\":null,\"parentId\":7,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":23,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_admin_delete\",\"component\":null,\"parentId\":7,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":6,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"菜单规则管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_menu\",\"component\":null,\"parentId\":2,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":4,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"管理员日志管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"auth_log\",\"component\":null,\"parentId\":2,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":5,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"user\",\"component\":null,\"parentId\":null,\"sort\":97,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":8,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员管理\",\"icon\":\"LineOutlined\",\"name\":\"user_index\",\"component\":null,\"parentId\":5,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":1,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员分组管理\",\"icon\":null,\"name\":\"user_group\",\"component\":null,\"parentId\":5,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":9,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员规则管理\",\"icon\":\"AimOutlined\",\"name\":\"user_rule\",\"component\":null,\"parentId\":5,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":10,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员日志管理\",\"icon\":\"LineOutlined\",\"name\":\"user_log\",\"component\":null,\"parentId\":5,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":11,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"常规管理\",\"icon\":\"LineOutlined\",\"name\":\"routine\",\"component\":null,\"parentId\":null,\"sort\":96,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"系统配置\",\"icon\":\"LineOutlined\",\"name\":\"routine_config\",\"component\":\"/Routine/Config\",\"parentId\":11,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":14,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"个人资料\",\"icon\":\"LineOutlined\",\"name\":\"routine_info\",\"component\":\"/Routine/Info\",\"parentId\":11,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":13,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"附件管理\",\"icon\":null,\"name\":\"routine_annex\",\"component\":\"/Routine/Annex\",\"parentId\":11,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":15,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"模块市场\",\"icon\":null,\"name\":\"module\",\"component\":\"/Module\",\"parentId\":null,\"sort\":95,\"type\":2,\"code\":null,\"cache\":0,\"status\":0}],\"remark\":null}}',
    200,
    45,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    566,
    '2024-08-28 17:43:06.762060',
    '2024-08-28 17:43:06.762060',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    66,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    567,
    '2024-08-28 17:43:08.019343',
    '2024-08-28 17:43:08.019343',
    4,
    'admin',
    '角色组管理',
    '127.0.0.1',
    '内网IP',
    '/admin/role',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":1,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"超级管理员\",\"slug\":\"super_admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":0,\"children\":[{\"id\":9,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通管理员\",\"slug\":\"admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":1,\"children\":[{\"id\":10,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"超级会员\",\"slug\":\"super_member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":9,\"children\":[{\"id\":11,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通会员\",\"slug\":\"member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":10,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通用户\",\"slug\":\"user\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":11,\"children\":null}]}]}]}]}],\"remark\":null}}',
    200,
    59,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    568,
    '2024-08-28 17:43:21.844992',
    '2024-08-28 17:43:21.844992',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    63,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    569,
    '2024-08-28 17:43:24.835722',
    '2024-08-28 17:43:24.835722',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    83,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    570,
    '2024-08-28 17:44:31.825484',
    '2024-08-28 17:44:31.825484',
    4,
    'admin',
    '角色组管理',
    '127.0.0.1',
    '内网IP',
    '/admin/role',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":1,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"超级管理员\",\"slug\":\"super_admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":0,\"children\":[{\"id\":9,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通管理员\",\"slug\":\"admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":1,\"children\":[{\"id\":10,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"超级会员\",\"slug\":\"super_member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":9,\"children\":[{\"id\":11,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通会员\",\"slug\":\"member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":10,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通用户\",\"slug\":\"user\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":11,\"children\":null}]}]}]}]}],\"remark\":null}}',
    200,
    97,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    571,
    '2024-08-28 17:44:55.800622',
    '2024-08-28 17:44:55.800622',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    70,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    572,
    '2024-08-28 17:45:06.552831',
    '2024-08-28 17:45:06.552831',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    61,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    573,
    '2024-08-28 17:45:07.417326',
    '2024-08-28 17:45:07.417326',
    4,
    'admin',
    '角色组管理',
    '127.0.0.1',
    '内网IP',
    '/admin/role',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":1,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"超级管理员\",\"slug\":\"super_admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":0,\"children\":[{\"id\":9,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通管理员\",\"slug\":\"admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":1,\"children\":[{\"id\":10,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"超级会员\",\"slug\":\"super_member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":9,\"children\":[{\"id\":11,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通会员\",\"slug\":\"member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":10,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通用户\",\"slug\":\"user\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":11,\"children\":null}]}]}]}]}],\"remark\":null}}',
    200,
    59,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    574,
    '2024-08-28 17:45:32.232209',
    '2024-08-28 17:45:32.232209',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    63,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    575,
    '2024-08-28 17:45:33.365742',
    '2024-08-28 17:45:33.365742',
    4,
    'admin',
    '角色组管理',
    '127.0.0.1',
    '内网IP',
    '/admin/role',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":1,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"超级管理员\",\"slug\":\"super_admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":0,\"children\":[{\"id\":9,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通管理员\",\"slug\":\"admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":1,\"children\":[{\"id\":10,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"超级会员\",\"slug\":\"super_member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":9,\"children\":[{\"id\":11,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通会员\",\"slug\":\"member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":10,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通用户\",\"slug\":\"user\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":11,\"children\":null}]}]}]}]}],\"remark\":null}}',
    200,
    58,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    576,
    '2024-08-28 17:48:31.820054',
    '2024-08-28 17:48:31.820054',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    118,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    577,
    '2024-08-28 17:48:34.935513',
    '2024-08-28 17:48:34.935513',
    4,
    'admin',
    '角色组管理',
    '127.0.0.1',
    '内网IP',
    '/admin/role',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":1,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"超级管理员\",\"slug\":\"super_admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":0,\"children\":[{\"id\":9,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通管理员\",\"slug\":\"admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":1,\"children\":[{\"id\":10,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"超级会员\",\"slug\":\"super_member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":9,\"children\":[{\"id\":11,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通会员\",\"slug\":\"member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":10,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通用户\",\"slug\":\"user\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":11,\"children\":null}]}]}]}]}],\"remark\":null}}',
    200,
    55,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    578,
    '2024-08-28 17:56:13.198152',
    '2024-08-28 17:56:13.198152',
    4,
    'admin',
    'refresh刷新token',
    '127.0.0.1',
    '内网IP',
    '/admin/refresh?refreshToken=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJpYXQiOjE3MjQ4MzcxNTYsImV4cCI6MTcyNTQ0MTk1Nn0.-I1EfKO_3TsEF4r175gPhrv-fFDwhuQeBoTUxn6J20E',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"accessToken\":\"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJyb2xlcyI6WyLotoXnuqfnrqHnkIblkZgiXSwicGVybWlzc2lvbnMiOlsidXNlcl9ncm91cCIsImF1dGgiLCJhdXRoX2dyb3VwIiwiYXV0aF9sb2ciLCJ1c2VyIiwiYXV0aF9tZW51IiwiYXV0aF9hZG1pbiIsInVzZXJfaW5kZXgiLCJ1c2VyX3J1bGUiLCJ1c2VyX2xvZyIsInJvdXRpbmUiLCJyb3V0aW5lX2NvbmZpZyIsInJvdXRpbmVfYW5uZXgiLCJyb3V0aW5lX2luZm8iLCJtb2R1bGUiLCJhdXRoX2dyb3VwX2NyZWF0ZSIsImF1dGhfZ3JvdXBfdXBkYXRlIiwiYXV0aF9ncm91cF9pbmZvIiwiYXV0aF9ncm91cF9kZWxldGUiLCJhdXRoX2FkbWluX2NyZWF0ZSIsImF1dGhfYWRtaW5fdXBkYXRlIiwiYXV0aF9hZG1pbl9pbmZvIiwiYXV0aF9hZG1pbl9kZWxldGUiLCJob21lIl0sImFjY2Vzc1Rva2VuIjp0cnVlLCJpYXQiOjE3MjQ4MzkwMTgsImV4cCI6MTcyNDg0MDgxOH0.OBS2goxhhi_Jp2lHRjClaFlxmKNlEAy0bSlCiQAkMWU\",\"refreshToken\":\"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJpYXQiOjE3MjQ4MzkwMTgsImV4cCI6MTcyNTQ0MzgxOH0.KqK_sgMN3I1RUE2J09grhI8usNp2F9dG1BQL3m3iAKA\"}}',
    200,
    115,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    579,
    '2024-08-28 17:56:13.263954',
    '2024-08-28 17:56:13.263954',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    57,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    580,
    '2024-08-28 17:56:14.202186',
    '2024-08-28 17:56:14.202186',
    4,
    'admin',
    '角色组管理',
    '127.0.0.1',
    '内网IP',
    '/admin/role',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":1,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"超级管理员\",\"slug\":\"super_admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":0,\"children\":[{\"id\":9,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通管理员\",\"slug\":\"admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":1,\"children\":[{\"id\":10,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"超级会员\",\"slug\":\"super_member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":9,\"children\":[{\"id\":11,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通会员\",\"slug\":\"member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":10,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通用户\",\"slug\":\"user\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":11,\"children\":null}]}]}]}]}],\"remark\":null}}',
    200,
    53,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    581,
    '2024-08-28 17:56:18.129655',
    '2024-08-28 17:56:18.129655',
    4,
    'admin',
    '角色组管理',
    '127.0.0.1',
    '内网IP',
    '/admin/role',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":1,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"超级管理员\",\"slug\":\"super_admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":0,\"children\":[{\"id\":9,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通管理员\",\"slug\":\"admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":1,\"children\":[{\"id\":10,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"超级会员\",\"slug\":\"super_member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":9,\"children\":[{\"id\":11,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通会员\",\"slug\":\"member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":10,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通用户\",\"slug\":\"user\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":11,\"children\":null}]}]}]}]}],\"remark\":null}}',
    200,
    60,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    582,
    '2024-08-28 17:56:18.789196',
    '2024-08-28 17:56:18.789196',
    4,
    'admin',
    '菜单规则管理',
    '127.0.0.1',
    '内网IP',
    '/admin/permission',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":24,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"首页\",\"icon\":null,\"name\":\"home\",\"component\":null,\"parentId\":null,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":2,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"权限管理\",\"icon\":\"LineOutlined\",\"name\":\"auth\",\"component\":null,\"parentId\":null,\"sort\":98,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":3,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"角色组管理\",\"icon\":\"AimOutlined\",\"name\":\"auth_group\",\"component\":null,\"parentId\":2,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":16,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_group_create\",\"component\":null,\"parentId\":3,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":17,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_group_update\",\"component\":null,\"parentId\":3,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":18,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_group_info\",\"component\":null,\"parentId\":3,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":19,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_group_delete\",\"component\":null,\"parentId\":3,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":7,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"管理员管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_admin\",\"component\":null,\"parentId\":2,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":20,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_admin_create\",\"component\":null,\"parentId\":7,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":21,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_admin_update\",\"component\":null,\"parentId\":7,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":22,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_admin_info\",\"component\":null,\"parentId\":7,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":23,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_admin_delete\",\"component\":null,\"parentId\":7,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":6,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"菜单规则管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_menu\",\"component\":null,\"parentId\":2,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":4,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"管理员日志管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"auth_log\",\"component\":null,\"parentId\":2,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":5,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"user\",\"component\":null,\"parentId\":null,\"sort\":97,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":8,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员管理\",\"icon\":\"LineOutlined\",\"name\":\"user_index\",\"component\":null,\"parentId\":5,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":1,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员分组管理\",\"icon\":null,\"name\":\"user_group\",\"component\":null,\"parentId\":5,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":9,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员规则管理\",\"icon\":\"AimOutlined\",\"name\":\"user_rule\",\"component\":null,\"parentId\":5,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":10,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员日志管理\",\"icon\":\"LineOutlined\",\"name\":\"user_log\",\"component\":null,\"parentId\":5,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":11,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"常规管理\",\"icon\":\"LineOutlined\",\"name\":\"routine\",\"component\":null,\"parentId\":null,\"sort\":96,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"系统配置\",\"icon\":\"LineOutlined\",\"name\":\"routine_config\",\"component\":\"/Routine/Config\",\"parentId\":11,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":14,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"个人资料\",\"icon\":\"LineOutlined\",\"name\":\"routine_info\",\"component\":\"/Routine/Info\",\"parentId\":11,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":13,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"附件管理\",\"icon\":null,\"name\":\"routine_annex\",\"component\":\"/Routine/Annex\",\"parentId\":11,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":15,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"模块市场\",\"icon\":null,\"name\":\"module\",\"component\":\"/Module\",\"parentId\":null,\"sort\":95,\"type\":2,\"code\":null,\"cache\":0,\"status\":0}],\"remark\":null}}',
    200,
    29,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    583,
    '2024-08-28 17:58:30.365485',
    '2024-08-28 17:58:30.365485',
    4,
    'admin',
    '角色组管理',
    '127.0.0.1',
    '内网IP',
    '/admin/role',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":1,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"超级管理员\",\"slug\":\"super_admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":0,\"children\":[{\"id\":9,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通管理员\",\"slug\":\"admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":1,\"children\":[{\"id\":10,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"超级会员\",\"slug\":\"super_member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":9,\"children\":[{\"id\":11,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通会员\",\"slug\":\"member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":10,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通用户\",\"slug\":\"user\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":11,\"children\":null}]}]}]}]}],\"remark\":null}}',
    200,
    130,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    584,
    '2024-08-28 17:58:30.366024',
    '2024-08-28 17:58:30.366024',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    131,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    585,
    '2024-08-28 17:58:30.916056',
    '2024-08-28 17:58:30.916056',
    4,
    'admin',
    '菜单规则管理',
    '127.0.0.1',
    '内网IP',
    '/admin/permission',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":24,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"首页\",\"icon\":null,\"name\":\"home\",\"component\":null,\"parentId\":null,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":2,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"权限管理\",\"icon\":\"LineOutlined\",\"name\":\"auth\",\"component\":null,\"parentId\":null,\"sort\":98,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":3,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"角色组管理\",\"icon\":\"AimOutlined\",\"name\":\"auth_group\",\"component\":null,\"parentId\":2,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":16,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_group_create\",\"component\":null,\"parentId\":3,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":17,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_group_update\",\"component\":null,\"parentId\":3,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":18,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_group_info\",\"component\":null,\"parentId\":3,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":19,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_group_delete\",\"component\":null,\"parentId\":3,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":7,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"管理员管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_admin\",\"component\":null,\"parentId\":2,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":20,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_admin_create\",\"component\":null,\"parentId\":7,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":21,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_admin_update\",\"component\":null,\"parentId\":7,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":22,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_admin_info\",\"component\":null,\"parentId\":7,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":23,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_admin_delete\",\"component\":null,\"parentId\":7,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":6,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"菜单规则管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_menu\",\"component\":null,\"parentId\":2,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":4,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"管理员日志管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"auth_log\",\"component\":null,\"parentId\":2,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":5,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"user\",\"component\":null,\"parentId\":null,\"sort\":97,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":8,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员管理\",\"icon\":\"LineOutlined\",\"name\":\"user_index\",\"component\":null,\"parentId\":5,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":1,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员分组管理\",\"icon\":null,\"name\":\"user_group\",\"component\":null,\"parentId\":5,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":9,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员规则管理\",\"icon\":\"AimOutlined\",\"name\":\"user_rule\",\"component\":null,\"parentId\":5,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":10,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员日志管理\",\"icon\":\"LineOutlined\",\"name\":\"user_log\",\"component\":null,\"parentId\":5,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":11,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"常规管理\",\"icon\":\"LineOutlined\",\"name\":\"routine\",\"component\":null,\"parentId\":null,\"sort\":96,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"系统配置\",\"icon\":\"LineOutlined\",\"name\":\"routine_config\",\"component\":\"/Routine/Config\",\"parentId\":11,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":14,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"个人资料\",\"icon\":\"LineOutlined\",\"name\":\"routine_info\",\"component\":\"/Routine/Info\",\"parentId\":11,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":13,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"附件管理\",\"icon\":null,\"name\":\"routine_annex\",\"component\":\"/Routine/Annex\",\"parentId\":11,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":15,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"模块市场\",\"icon\":null,\"name\":\"module\",\"component\":\"/Module\",\"parentId\":null,\"sort\":95,\"type\":2,\"code\":null,\"cache\":0,\"status\":0}],\"remark\":null}}',
    200,
    34,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    586,
    '2024-08-28 18:04:33.060551',
    '2024-08-28 18:04:33.060551',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    145,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    587,
    '2024-08-28 18:07:16.168872',
    '2024-08-28 18:07:16.168872',
    4,
    'admin',
    '角色组管理',
    '127.0.0.1',
    '内网IP',
    '/admin/role',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":1,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"超级管理员\",\"slug\":\"super_admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":0,\"children\":[{\"id\":9,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通管理员\",\"slug\":\"admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":1,\"children\":[{\"id\":10,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"超级会员\",\"slug\":\"super_member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":9,\"children\":[{\"id\":11,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通会员\",\"slug\":\"member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":10,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通用户\",\"slug\":\"user\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":11,\"children\":null}]}]}]}]}],\"remark\":null}}',
    200,
    122,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    588,
    '2024-08-28 18:07:16.173589',
    '2024-08-28 18:07:16.173589',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    132,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    589,
    '2024-08-28 18:07:17.166195',
    '2024-08-28 18:07:17.166195',
    4,
    'admin',
    '菜单规则管理',
    '127.0.0.1',
    '内网IP',
    '/admin/permission',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":24,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"首页\",\"icon\":null,\"name\":\"home\",\"component\":null,\"parentId\":null,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":2,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"权限管理\",\"icon\":\"LineOutlined\",\"name\":\"auth\",\"component\":null,\"parentId\":null,\"sort\":98,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":3,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"角色组管理\",\"icon\":\"AimOutlined\",\"name\":\"auth_group\",\"component\":null,\"parentId\":2,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":16,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_group_create\",\"component\":null,\"parentId\":3,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":17,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_group_update\",\"component\":null,\"parentId\":3,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":18,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_group_info\",\"component\":null,\"parentId\":3,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":19,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_group_delete\",\"component\":null,\"parentId\":3,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":7,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"管理员管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_admin\",\"component\":null,\"parentId\":2,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":20,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_admin_create\",\"component\":null,\"parentId\":7,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":21,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_admin_update\",\"component\":null,\"parentId\":7,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":22,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_admin_info\",\"component\":null,\"parentId\":7,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":23,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_admin_delete\",\"component\":null,\"parentId\":7,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":6,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"菜单规则管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_menu\",\"component\":null,\"parentId\":2,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":4,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"管理员日志管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"auth_log\",\"component\":null,\"parentId\":2,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":5,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"user\",\"component\":null,\"parentId\":null,\"sort\":97,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":8,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员管理\",\"icon\":\"LineOutlined\",\"name\":\"user_index\",\"component\":null,\"parentId\":5,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":1,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员分组管理\",\"icon\":null,\"name\":\"user_group\",\"component\":null,\"parentId\":5,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":9,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员规则管理\",\"icon\":\"AimOutlined\",\"name\":\"user_rule\",\"component\":null,\"parentId\":5,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":10,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员日志管理\",\"icon\":\"LineOutlined\",\"name\":\"user_log\",\"component\":null,\"parentId\":5,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":11,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"常规管理\",\"icon\":\"LineOutlined\",\"name\":\"routine\",\"component\":null,\"parentId\":null,\"sort\":96,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"系统配置\",\"icon\":\"LineOutlined\",\"name\":\"routine_config\",\"component\":\"/Routine/Config\",\"parentId\":11,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":14,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"个人资料\",\"icon\":\"LineOutlined\",\"name\":\"routine_info\",\"component\":\"/Routine/Info\",\"parentId\":11,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":13,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"附件管理\",\"icon\":null,\"name\":\"routine_annex\",\"component\":\"/Routine/Annex\",\"parentId\":11,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":15,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"模块市场\",\"icon\":null,\"name\":\"module\",\"component\":\"/Module\",\"parentId\":null,\"sort\":95,\"type\":2,\"code\":null,\"cache\":0,\"status\":0}],\"remark\":null}}',
    200,
    29,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    590,
    '2024-08-28 18:09:10.670931',
    '2024-08-28 18:09:10.670931',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    155,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    591,
    '2024-08-28 18:09:10.672329',
    '2024-08-28 18:09:10.672329',
    4,
    'admin',
    '角色组管理',
    '127.0.0.1',
    '内网IP',
    '/admin/role',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":1,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"超级管理员\",\"slug\":\"super_admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":0,\"children\":[{\"id\":9,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通管理员\",\"slug\":\"admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":1,\"children\":[{\"id\":10,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"超级会员\",\"slug\":\"super_member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":9,\"children\":[{\"id\":11,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通会员\",\"slug\":\"member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":10,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通用户\",\"slug\":\"user\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":11,\"children\":null}]}]}]}]}],\"remark\":null}}',
    200,
    159,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    592,
    '2024-08-28 21:24:51.729323',
    '2024-08-28 21:24:51.729323',
    4,
    'admin',
    'refresh刷新token',
    '::1',
    '',
    '/admin/refresh?refreshToken=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJpYXQiOjE3MjQ3NzA5NzIsImV4cCI6MTcyNTM3NTc3Mn0.ipEwcpQcU7ZQhCr7l0-4BT8LvNGgucUlrrUbWnQPAUE',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"accessToken\":\"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJyb2xlcyI6WyLotoXnuqfnrqHnkIblkZgiXSwicGVybWlzc2lvbnMiOlsidXNlcl9ncm91cCIsImF1dGgiLCJhdXRoX2dyb3VwIiwiYXV0aF9sb2ciLCJ1c2VyIiwiYXV0aF9tZW51IiwiYXV0aF9hZG1pbiIsInVzZXJfaW5kZXgiLCJ1c2VyX3J1bGUiLCJ1c2VyX2xvZyIsInJvdXRpbmUiLCJyb3V0aW5lX2NvbmZpZyIsInJvdXRpbmVfYW5uZXgiLCJyb3V0aW5lX2luZm8iLCJtb2R1bGUiLCJhdXRoX2dyb3VwX2NyZWF0ZSIsImF1dGhfZ3JvdXBfdXBkYXRlIiwiYXV0aF9ncm91cF9pbmZvIiwiYXV0aF9ncm91cF9kZWxldGUiLCJhdXRoX2FkbWluX2NyZWF0ZSIsImF1dGhfYWRtaW5fdXBkYXRlIiwiYXV0aF9hZG1pbl9pbmZvIiwiYXV0aF9hZG1pbl9kZWxldGUiLCJob21lIl0sImFjY2Vzc1Rva2VuIjp0cnVlLCJpYXQiOjE3MjQ4NTE0OTAsImV4cCI6MTcyNDg1MzI5MH0.hTpz5vR0unYIZVXT4wAOHbXLUrGvy6wBGh6rYe4UYcE\",\"refreshToken\":\"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJpYXQiOjE3MjQ4NTE0OTAsImV4cCI6MTcyNTQ1NjI5MH0.UKNg2G4I8oTpUH8Fzttp88pTRH5NUM4i-cB75G8CjGU\"}}',
    200,
    103,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    593,
    '2024-08-28 21:24:53.733958',
    '2024-08-28 21:24:53.733958',
    4,
    'admin',
    '菜单规则管理',
    '::1',
    '',
    '/admin/permission',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":24,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"首页\",\"icon\":null,\"name\":\"home\",\"component\":null,\"parentId\":null,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":2,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"权限管理\",\"icon\":\"LineOutlined\",\"name\":\"auth\",\"component\":null,\"parentId\":null,\"sort\":98,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":3,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"角色组管理\",\"icon\":\"AimOutlined\",\"name\":\"auth_group\",\"component\":null,\"parentId\":2,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":16,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_group_create\",\"component\":null,\"parentId\":3,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":17,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_group_update\",\"component\":null,\"parentId\":3,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":18,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_group_info\",\"component\":null,\"parentId\":3,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":19,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_group_delete\",\"component\":null,\"parentId\":3,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":7,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"管理员管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_admin\",\"component\":null,\"parentId\":2,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":20,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_admin_create\",\"component\":null,\"parentId\":7,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":21,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_admin_update\",\"component\":null,\"parentId\":7,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":22,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_admin_info\",\"component\":null,\"parentId\":7,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":23,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_admin_delete\",\"component\":null,\"parentId\":7,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":6,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"菜单规则管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_menu\",\"component\":null,\"parentId\":2,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":4,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"管理员日志管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"auth_log\",\"component\":null,\"parentId\":2,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":5,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"user\",\"component\":null,\"parentId\":null,\"sort\":97,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":8,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员管理\",\"icon\":\"LineOutlined\",\"name\":\"user_index\",\"component\":null,\"parentId\":5,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":1,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员分组管理\",\"icon\":null,\"name\":\"user_group\",\"component\":null,\"parentId\":5,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":9,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员规则管理\",\"icon\":\"AimOutlined\",\"name\":\"user_rule\",\"component\":null,\"parentId\":5,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":10,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员日志管理\",\"icon\":\"LineOutlined\",\"name\":\"user_log\",\"component\":null,\"parentId\":5,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":11,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"常规管理\",\"icon\":\"LineOutlined\",\"name\":\"routine\",\"component\":null,\"parentId\":null,\"sort\":96,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"系统配置\",\"icon\":\"LineOutlined\",\"name\":\"routine_config\",\"component\":\"/Routine/Config\",\"parentId\":11,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":14,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"个人资料\",\"icon\":\"LineOutlined\",\"name\":\"routine_info\",\"component\":\"/Routine/Info\",\"parentId\":11,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":13,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"附件管理\",\"icon\":null,\"name\":\"routine_annex\",\"component\":\"/Routine/Annex\",\"parentId\":11,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":15,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"模块市场\",\"icon\":null,\"name\":\"module\",\"component\":\"/Module\",\"parentId\":null,\"sort\":95,\"type\":2,\"code\":null,\"cache\":0,\"status\":0}],\"remark\":null}}',
    200,
    48,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    594,
    '2024-08-28 21:24:56.366723',
    '2024-08-28 21:24:56.366723',
    4,
    'admin',
    '角色组管理',
    '::1',
    '',
    '/admin/role',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":1,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"超级管理员\",\"slug\":\"super_admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":0,\"children\":[{\"id\":9,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通管理员\",\"slug\":\"admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":1,\"children\":[{\"id\":10,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"超级会员\",\"slug\":\"super_member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":9,\"children\":[{\"id\":11,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通会员\",\"slug\":\"member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":10,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通用户\",\"slug\":\"user\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":11,\"children\":null}]}]}]}]}],\"remark\":null}}',
    200,
    91,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    595,
    '2024-08-28 21:25:33.367410',
    '2024-08-28 21:25:33.367410',
    4,
    'admin',
    '管理员管理-详情',
    '::1',
    '',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    177,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    596,
    '2024-08-28 21:25:33.455794',
    '2024-08-28 21:25:33.455794',
    4,
    'admin',
    '管理员管理-详情',
    '::1',
    '',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    86,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    597,
    '2024-08-28 21:28:15.399664',
    '2024-08-28 21:28:15.399664',
    4,
    'admin',
    '管理员管理-详情',
    '::1',
    '',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    132,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    598,
    '2024-08-28 21:28:15.710021',
    '2024-08-28 21:28:15.710021',
    4,
    'admin',
    '管理员管理-详情',
    '::1',
    '',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    83,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    599,
    '2024-08-28 21:28:19.496794',
    '2024-08-28 21:28:19.496794',
    4,
    'admin',
    '角色组管理',
    '::1',
    '',
    '/admin/role',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":1,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"超级管理员\",\"slug\":\"super_admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":0,\"children\":[{\"id\":9,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通管理员\",\"slug\":\"admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":1,\"children\":[{\"id\":10,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"超级会员\",\"slug\":\"super_member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":9,\"children\":[{\"id\":11,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通会员\",\"slug\":\"member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":10,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通用户\",\"slug\":\"user\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":11,\"children\":null}]}]}]}]}],\"remark\":null}}',
    200,
    81,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    600,
    '2024-08-28 21:28:20.511787',
    '2024-08-28 21:28:20.511787',
    4,
    'admin',
    '菜单规则管理',
    '::1',
    '',
    '/admin/permission',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":24,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"首页\",\"icon\":null,\"name\":\"home\",\"component\":null,\"parentId\":null,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":2,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"权限管理\",\"icon\":\"LineOutlined\",\"name\":\"auth\",\"component\":null,\"parentId\":null,\"sort\":98,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":3,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"角色组管理\",\"icon\":\"AimOutlined\",\"name\":\"auth_group\",\"component\":null,\"parentId\":2,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":16,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_group_create\",\"component\":null,\"parentId\":3,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":17,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_group_update\",\"component\":null,\"parentId\":3,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":18,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_group_info\",\"component\":null,\"parentId\":3,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":19,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_group_delete\",\"component\":null,\"parentId\":3,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":7,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"管理员管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_admin\",\"component\":null,\"parentId\":2,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":20,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_admin_create\",\"component\":null,\"parentId\":7,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":21,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_admin_update\",\"component\":null,\"parentId\":7,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":22,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_admin_info\",\"component\":null,\"parentId\":7,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":23,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_admin_delete\",\"component\":null,\"parentId\":7,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":6,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"菜单规则管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_menu\",\"component\":null,\"parentId\":2,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":4,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"管理员日志管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"auth_log\",\"component\":null,\"parentId\":2,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":5,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"user\",\"component\":null,\"parentId\":null,\"sort\":97,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":8,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员管理\",\"icon\":\"LineOutlined\",\"name\":\"user_index\",\"component\":null,\"parentId\":5,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":1,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员分组管理\",\"icon\":null,\"name\":\"user_group\",\"component\":null,\"parentId\":5,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":9,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员规则管理\",\"icon\":\"AimOutlined\",\"name\":\"user_rule\",\"component\":null,\"parentId\":5,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":10,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员日志管理\",\"icon\":\"LineOutlined\",\"name\":\"user_log\",\"component\":null,\"parentId\":5,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":11,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"常规管理\",\"icon\":\"LineOutlined\",\"name\":\"routine\",\"component\":null,\"parentId\":null,\"sort\":96,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"系统配置\",\"icon\":\"LineOutlined\",\"name\":\"routine_config\",\"component\":\"/Routine/Config\",\"parentId\":11,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":14,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"个人资料\",\"icon\":\"LineOutlined\",\"name\":\"routine_info\",\"component\":\"/Routine/Info\",\"parentId\":11,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":13,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"附件管理\",\"icon\":null,\"name\":\"routine_annex\",\"component\":\"/Routine/Annex\",\"parentId\":11,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":15,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"模块市场\",\"icon\":null,\"name\":\"module\",\"component\":\"/Module\",\"parentId\":null,\"sort\":95,\"type\":2,\"code\":null,\"cache\":0,\"status\":0}],\"remark\":null}}',
    200,
    44,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    601,
    '2024-08-28 21:28:22.793285',
    '2024-08-28 21:28:22.793285',
    4,
    'admin',
    '菜单规则管理',
    '::1',
    '',
    '/admin/permission',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":24,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"首页\",\"icon\":null,\"name\":\"home\",\"component\":null,\"parentId\":null,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":2,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"权限管理\",\"icon\":\"LineOutlined\",\"name\":\"auth\",\"component\":null,\"parentId\":null,\"sort\":98,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":3,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"角色组管理\",\"icon\":\"AimOutlined\",\"name\":\"auth_group\",\"component\":null,\"parentId\":2,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":16,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_group_create\",\"component\":null,\"parentId\":3,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":17,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_group_update\",\"component\":null,\"parentId\":3,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":18,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_group_info\",\"component\":null,\"parentId\":3,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":19,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_group_delete\",\"component\":null,\"parentId\":3,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":7,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"管理员管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_admin\",\"component\":null,\"parentId\":2,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":20,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_admin_create\",\"component\":null,\"parentId\":7,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":21,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_admin_update\",\"component\":null,\"parentId\":7,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":22,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_admin_info\",\"component\":null,\"parentId\":7,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":23,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_admin_delete\",\"component\":null,\"parentId\":7,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":6,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"菜单规则管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_menu\",\"component\":null,\"parentId\":2,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":4,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"管理员日志管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"auth_log\",\"component\":null,\"parentId\":2,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":5,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"user\",\"component\":null,\"parentId\":null,\"sort\":97,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":8,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员管理\",\"icon\":\"LineOutlined\",\"name\":\"user_index\",\"component\":null,\"parentId\":5,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":1,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员分组管理\",\"icon\":null,\"name\":\"user_group\",\"component\":null,\"parentId\":5,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":9,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员规则管理\",\"icon\":\"AimOutlined\",\"name\":\"user_rule\",\"component\":null,\"parentId\":5,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":10,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员日志管理\",\"icon\":\"LineOutlined\",\"name\":\"user_log\",\"component\":null,\"parentId\":5,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":11,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"常规管理\",\"icon\":\"LineOutlined\",\"name\":\"routine\",\"component\":null,\"parentId\":null,\"sort\":96,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"系统配置\",\"icon\":\"LineOutlined\",\"name\":\"routine_config\",\"component\":\"/Routine/Config\",\"parentId\":11,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":14,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"个人资料\",\"icon\":\"LineOutlined\",\"name\":\"routine_info\",\"component\":\"/Routine/Info\",\"parentId\":11,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":13,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"附件管理\",\"icon\":null,\"name\":\"routine_annex\",\"component\":\"/Routine/Annex\",\"parentId\":11,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":15,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"模块市场\",\"icon\":null,\"name\":\"module\",\"component\":\"/Module\",\"parentId\":null,\"sort\":95,\"type\":2,\"code\":null,\"cache\":0,\"status\":0}],\"remark\":null}}',
    200,
    46,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    602,
    '2024-08-28 21:28:24.962290',
    '2024-08-28 21:28:24.962290',
    4,
    'admin',
    '角色组管理',
    '::1',
    '',
    '/admin/role',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":1,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"超级管理员\",\"slug\":\"super_admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":0,\"children\":[{\"id\":9,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通管理员\",\"slug\":\"admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":1,\"children\":[{\"id\":10,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"超级会员\",\"slug\":\"super_member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":9,\"children\":[{\"id\":11,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通会员\",\"slug\":\"member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":10,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通用户\",\"slug\":\"user\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":11,\"children\":null}]}]}]}]}],\"remark\":null}}',
    200,
    78,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    603,
    '2024-08-28 21:28:37.280419',
    '2024-08-28 21:28:37.280419',
    4,
    'admin',
    '管理员管理-详情',
    '::1',
    '',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    79,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    604,
    '2024-08-28 21:28:37.651448',
    '2024-08-28 21:28:37.651448',
    4,
    'admin',
    '管理员管理-详情',
    '::1',
    '',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    80,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    605,
    '2024-08-28 21:28:51.002081',
    '2024-08-28 21:28:51.002081',
    4,
    'admin',
    '菜单规则管理',
    '::1',
    '',
    '/admin/permission',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":24,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"首页\",\"icon\":null,\"name\":\"home\",\"component\":null,\"parentId\":null,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":2,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"权限管理\",\"icon\":\"LineOutlined\",\"name\":\"auth\",\"component\":null,\"parentId\":null,\"sort\":98,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":3,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"角色组管理\",\"icon\":\"AimOutlined\",\"name\":\"auth_group\",\"component\":null,\"parentId\":2,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":16,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_group_create\",\"component\":null,\"parentId\":3,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":17,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_group_update\",\"component\":null,\"parentId\":3,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":18,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_group_info\",\"component\":null,\"parentId\":3,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":19,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_group_delete\",\"component\":null,\"parentId\":3,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":7,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"管理员管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_admin\",\"component\":null,\"parentId\":2,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":20,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_admin_create\",\"component\":null,\"parentId\":7,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":21,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_admin_update\",\"component\":null,\"parentId\":7,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":22,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_admin_info\",\"component\":null,\"parentId\":7,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":23,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_admin_delete\",\"component\":null,\"parentId\":7,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":6,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"菜单规则管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_menu\",\"component\":null,\"parentId\":2,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":4,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"管理员日志管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"auth_log\",\"component\":null,\"parentId\":2,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":5,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"user\",\"component\":null,\"parentId\":null,\"sort\":97,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":8,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员管理\",\"icon\":\"LineOutlined\",\"name\":\"user_index\",\"component\":null,\"parentId\":5,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":1,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员分组管理\",\"icon\":null,\"name\":\"user_group\",\"component\":null,\"parentId\":5,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":9,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员规则管理\",\"icon\":\"AimOutlined\",\"name\":\"user_rule\",\"component\":null,\"parentId\":5,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":10,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员日志管理\",\"icon\":\"LineOutlined\",\"name\":\"user_log\",\"component\":null,\"parentId\":5,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":11,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"常规管理\",\"icon\":\"LineOutlined\",\"name\":\"routine\",\"component\":null,\"parentId\":null,\"sort\":96,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"系统配置\",\"icon\":\"LineOutlined\",\"name\":\"routine_config\",\"component\":\"/Routine/Config\",\"parentId\":11,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":14,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"个人资料\",\"icon\":\"LineOutlined\",\"name\":\"routine_info\",\"component\":\"/Routine/Info\",\"parentId\":11,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":13,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"附件管理\",\"icon\":null,\"name\":\"routine_annex\",\"component\":\"/Routine/Annex\",\"parentId\":11,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":15,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"模块市场\",\"icon\":null,\"name\":\"module\",\"component\":\"/Module\",\"parentId\":null,\"sort\":95,\"type\":2,\"code\":null,\"cache\":0,\"status\":0}],\"remark\":null}}',
    200,
    43,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    606,
    '2024-08-28 21:28:53.037008',
    '2024-08-28 21:28:53.037008',
    4,
    'admin',
    '菜单规则管理',
    '::1',
    '',
    '/admin/permission',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":24,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"首页\",\"icon\":null,\"name\":\"home\",\"component\":null,\"parentId\":null,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":2,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"权限管理\",\"icon\":\"LineOutlined\",\"name\":\"auth\",\"component\":null,\"parentId\":null,\"sort\":98,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":3,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"角色组管理\",\"icon\":\"AimOutlined\",\"name\":\"auth_group\",\"component\":null,\"parentId\":2,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":16,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_group_create\",\"component\":null,\"parentId\":3,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":17,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_group_update\",\"component\":null,\"parentId\":3,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":18,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_group_info\",\"component\":null,\"parentId\":3,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":19,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_group_delete\",\"component\":null,\"parentId\":3,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":7,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"管理员管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_admin\",\"component\":null,\"parentId\":2,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":20,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_admin_create\",\"component\":null,\"parentId\":7,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":21,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_admin_update\",\"component\":null,\"parentId\":7,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":22,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_admin_info\",\"component\":null,\"parentId\":7,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":23,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_admin_delete\",\"component\":null,\"parentId\":7,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":6,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"菜单规则管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_menu\",\"component\":null,\"parentId\":2,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":4,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"管理员日志管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"auth_log\",\"component\":null,\"parentId\":2,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":5,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"user\",\"component\":null,\"parentId\":null,\"sort\":97,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":8,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员管理\",\"icon\":\"LineOutlined\",\"name\":\"user_index\",\"component\":null,\"parentId\":5,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":1,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员分组管理\",\"icon\":null,\"name\":\"user_group\",\"component\":null,\"parentId\":5,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":9,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员规则管理\",\"icon\":\"AimOutlined\",\"name\":\"user_rule\",\"component\":null,\"parentId\":5,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":10,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员日志管理\",\"icon\":\"LineOutlined\",\"name\":\"user_log\",\"component\":null,\"parentId\":5,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":11,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"常规管理\",\"icon\":\"LineOutlined\",\"name\":\"routine\",\"component\":null,\"parentId\":null,\"sort\":96,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"系统配置\",\"icon\":\"LineOutlined\",\"name\":\"routine_config\",\"component\":\"/Routine/Config\",\"parentId\":11,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":14,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"个人资料\",\"icon\":\"LineOutlined\",\"name\":\"routine_info\",\"component\":\"/Routine/Info\",\"parentId\":11,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":13,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"附件管理\",\"icon\":null,\"name\":\"routine_annex\",\"component\":\"/Routine/Annex\",\"parentId\":11,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":15,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"模块市场\",\"icon\":null,\"name\":\"module\",\"component\":\"/Module\",\"parentId\":null,\"sort\":95,\"type\":2,\"code\":null,\"cache\":0,\"status\":0}],\"remark\":null}}',
    200,
    46,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    607,
    '2024-08-28 21:28:56.046901',
    '2024-08-28 21:28:56.046901',
    4,
    'admin',
    '菜单规则管理',
    '::1',
    '',
    '/admin/permission',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":24,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"首页\",\"icon\":null,\"name\":\"home\",\"component\":null,\"parentId\":null,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":2,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"权限管理\",\"icon\":\"LineOutlined\",\"name\":\"auth\",\"component\":null,\"parentId\":null,\"sort\":98,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":3,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"角色组管理\",\"icon\":\"AimOutlined\",\"name\":\"auth_group\",\"component\":null,\"parentId\":2,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":16,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_group_create\",\"component\":null,\"parentId\":3,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":17,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_group_update\",\"component\":null,\"parentId\":3,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":18,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_group_info\",\"component\":null,\"parentId\":3,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":19,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_group_delete\",\"component\":null,\"parentId\":3,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":7,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"管理员管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_admin\",\"component\":null,\"parentId\":2,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":20,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_admin_create\",\"component\":null,\"parentId\":7,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":21,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_admin_update\",\"component\":null,\"parentId\":7,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":22,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_admin_info\",\"component\":null,\"parentId\":7,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":23,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_admin_delete\",\"component\":null,\"parentId\":7,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":6,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"菜单规则管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_menu\",\"component\":null,\"parentId\":2,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":4,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"管理员日志管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"auth_log\",\"component\":null,\"parentId\":2,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":5,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"user\",\"component\":null,\"parentId\":null,\"sort\":97,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":8,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员管理\",\"icon\":\"LineOutlined\",\"name\":\"user_index\",\"component\":null,\"parentId\":5,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":1,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员分组管理\",\"icon\":null,\"name\":\"user_group\",\"component\":null,\"parentId\":5,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":9,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员规则管理\",\"icon\":\"AimOutlined\",\"name\":\"user_rule\",\"component\":null,\"parentId\":5,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":10,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员日志管理\",\"icon\":\"LineOutlined\",\"name\":\"user_log\",\"component\":null,\"parentId\":5,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":11,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"常规管理\",\"icon\":\"LineOutlined\",\"name\":\"routine\",\"component\":null,\"parentId\":null,\"sort\":96,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"系统配置\",\"icon\":\"LineOutlined\",\"name\":\"routine_config\",\"component\":\"/Routine/Config\",\"parentId\":11,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":14,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"个人资料\",\"icon\":\"LineOutlined\",\"name\":\"routine_info\",\"component\":\"/Routine/Info\",\"parentId\":11,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":13,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"附件管理\",\"icon\":null,\"name\":\"routine_annex\",\"component\":\"/Routine/Annex\",\"parentId\":11,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":15,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"模块市场\",\"icon\":null,\"name\":\"module\",\"component\":\"/Module\",\"parentId\":null,\"sort\":95,\"type\":2,\"code\":null,\"cache\":0,\"status\":0}],\"remark\":null}}',
    200,
    44,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    608,
    '2024-08-28 21:29:14.176506',
    '2024-08-28 21:29:14.176506',
    4,
    'admin',
    '角色组管理',
    '::1',
    '',
    '/admin/role',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":1,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"超级管理员\",\"slug\":\"super_admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":0,\"children\":[{\"id\":9,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通管理员\",\"slug\":\"admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":1,\"children\":[{\"id\":10,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"超级会员\",\"slug\":\"super_member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":9,\"children\":[{\"id\":11,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通会员\",\"slug\":\"member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":10,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通用户\",\"slug\":\"user\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":11,\"children\":null}]}]}]}]}],\"remark\":null}}',
    200,
    87,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    609,
    '2024-08-28 21:29:16.456804',
    '2024-08-28 21:29:16.456804',
    4,
    'admin',
    '角色组管理',
    '::1',
    '',
    '/admin/role',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":1,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"超级管理员\",\"slug\":\"super_admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":0,\"children\":[{\"id\":9,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通管理员\",\"slug\":\"admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":1,\"children\":[{\"id\":10,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"超级会员\",\"slug\":\"super_member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":9,\"children\":[{\"id\":11,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通会员\",\"slug\":\"member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":10,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通用户\",\"slug\":\"user\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":11,\"children\":null}]}]}]}]}],\"remark\":null}}',
    200,
    79,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    610,
    '2024-08-28 21:29:18.296418',
    '2024-08-28 21:29:18.296418',
    4,
    'admin',
    '角色组管理',
    '::1',
    '',
    '/admin/role',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":1,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"超级管理员\",\"slug\":\"super_admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":0,\"children\":[{\"id\":9,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通管理员\",\"slug\":\"admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":1,\"children\":[{\"id\":10,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"超级会员\",\"slug\":\"super_member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":9,\"children\":[{\"id\":11,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通会员\",\"slug\":\"member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":10,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通用户\",\"slug\":\"user\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":11,\"children\":null}]}]}]}]}],\"remark\":null}}',
    200,
    81,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    611,
    '2024-08-28 21:29:19.546887',
    '2024-08-28 21:29:19.546887',
    4,
    'admin',
    '角色组管理',
    '::1',
    '',
    '/admin/role',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":1,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"超级管理员\",\"slug\":\"super_admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":0,\"children\":[{\"id\":9,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通管理员\",\"slug\":\"admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":1,\"children\":[{\"id\":10,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"超级会员\",\"slug\":\"super_member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":9,\"children\":[{\"id\":11,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通会员\",\"slug\":\"member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":10,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通用户\",\"slug\":\"user\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":11,\"children\":null}]}]}]}]}],\"remark\":null}}',
    200,
    83,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    612,
    '2024-08-28 21:29:20.877835',
    '2024-08-28 21:29:20.877835',
    4,
    'admin',
    '角色组管理',
    '::1',
    '',
    '/admin/role',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":1,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"超级管理员\",\"slug\":\"super_admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":0,\"children\":[{\"id\":9,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通管理员\",\"slug\":\"admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":1,\"children\":[{\"id\":10,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"超级会员\",\"slug\":\"super_member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":9,\"children\":[{\"id\":11,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通会员\",\"slug\":\"member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":10,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通用户\",\"slug\":\"user\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":11,\"children\":null}]}]}]}]}],\"remark\":null}}',
    200,
    81,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    613,
    '2024-08-28 21:29:22.625396',
    '2024-08-28 21:29:22.625396',
    4,
    'admin',
    '角色组管理',
    '::1',
    '',
    '/admin/role',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":1,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"超级管理员\",\"slug\":\"super_admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":0,\"children\":[{\"id\":9,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通管理员\",\"slug\":\"admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":1,\"children\":[{\"id\":10,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"超级会员\",\"slug\":\"super_member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":9,\"children\":[{\"id\":11,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通会员\",\"slug\":\"member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":10,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通用户\",\"slug\":\"user\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":11,\"children\":null}]}]}]}]}],\"remark\":null}}',
    200,
    79,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    614,
    '2024-08-28 21:34:00.940501',
    '2024-08-28 21:34:00.940501',
    4,
    'admin',
    '菜单规则管理',
    '::1',
    '',
    '/admin/permission',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":24,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"首页\",\"icon\":null,\"name\":\"home\",\"component\":null,\"parentId\":null,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":2,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"权限管理\",\"icon\":\"LineOutlined\",\"name\":\"auth\",\"component\":null,\"parentId\":null,\"sort\":98,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":3,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"角色组管理\",\"icon\":\"AimOutlined\",\"name\":\"auth_group\",\"component\":null,\"parentId\":2,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":16,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_group_create\",\"component\":null,\"parentId\":3,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":17,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_group_update\",\"component\":null,\"parentId\":3,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":18,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_group_info\",\"component\":null,\"parentId\":3,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":19,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_group_delete\",\"component\":null,\"parentId\":3,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":7,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"管理员管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_admin\",\"component\":null,\"parentId\":2,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":20,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_admin_create\",\"component\":null,\"parentId\":7,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":21,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_admin_update\",\"component\":null,\"parentId\":7,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":22,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_admin_info\",\"component\":null,\"parentId\":7,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":23,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_admin_delete\",\"component\":null,\"parentId\":7,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":6,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"菜单规则管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_menu\",\"component\":null,\"parentId\":2,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":4,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"管理员日志管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"auth_log\",\"component\":null,\"parentId\":2,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":5,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"user\",\"component\":null,\"parentId\":null,\"sort\":97,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":8,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员管理\",\"icon\":\"LineOutlined\",\"name\":\"user_index\",\"component\":null,\"parentId\":5,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":1,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员分组管理\",\"icon\":null,\"name\":\"user_group\",\"component\":null,\"parentId\":5,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":9,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员规则管理\",\"icon\":\"AimOutlined\",\"name\":\"user_rule\",\"component\":null,\"parentId\":5,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":10,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员日志管理\",\"icon\":\"LineOutlined\",\"name\":\"user_log\",\"component\":null,\"parentId\":5,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":11,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"常规管理\",\"icon\":\"LineOutlined\",\"name\":\"routine\",\"component\":null,\"parentId\":null,\"sort\":96,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"系统配置\",\"icon\":\"LineOutlined\",\"name\":\"routine_config\",\"component\":\"/Routine/Config\",\"parentId\":11,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":14,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"个人资料\",\"icon\":\"LineOutlined\",\"name\":\"routine_info\",\"component\":\"/Routine/Info\",\"parentId\":11,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":13,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"附件管理\",\"icon\":null,\"name\":\"routine_annex\",\"component\":\"/Routine/Annex\",\"parentId\":11,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":15,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"模块市场\",\"icon\":null,\"name\":\"module\",\"component\":\"/Module\",\"parentId\":null,\"sort\":95,\"type\":2,\"code\":null,\"cache\":0,\"status\":0}],\"remark\":null}}',
    200,
    88,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    615,
    '2024-08-28 21:34:30.807310',
    '2024-08-28 21:34:30.807310',
    4,
    'admin',
    '菜单规则管理',
    '::1',
    '',
    '/admin/permission',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":24,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"首页\",\"icon\":null,\"name\":\"home\",\"component\":null,\"parentId\":null,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":2,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"权限管理\",\"icon\":\"LineOutlined\",\"name\":\"auth\",\"component\":null,\"parentId\":null,\"sort\":98,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":3,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"角色组管理\",\"icon\":\"AimOutlined\",\"name\":\"auth_group\",\"component\":null,\"parentId\":2,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":16,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_group_create\",\"component\":null,\"parentId\":3,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":17,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_group_update\",\"component\":null,\"parentId\":3,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":18,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_group_info\",\"component\":null,\"parentId\":3,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":19,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_group_delete\",\"component\":null,\"parentId\":3,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":7,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"管理员管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_admin\",\"component\":null,\"parentId\":2,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":20,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_admin_create\",\"component\":null,\"parentId\":7,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":21,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_admin_update\",\"component\":null,\"parentId\":7,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":22,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_admin_info\",\"component\":null,\"parentId\":7,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":23,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_admin_delete\",\"component\":null,\"parentId\":7,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":6,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"菜单规则管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_menu\",\"component\":null,\"parentId\":2,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":4,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"管理员日志管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"auth_log\",\"component\":null,\"parentId\":2,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":5,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"user\",\"component\":null,\"parentId\":null,\"sort\":97,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":8,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员管理\",\"icon\":\"LineOutlined\",\"name\":\"user_index\",\"component\":null,\"parentId\":5,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":1,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员分组管理\",\"icon\":null,\"name\":\"user_group\",\"component\":null,\"parentId\":5,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":9,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员规则管理\",\"icon\":\"AimOutlined\",\"name\":\"user_rule\",\"component\":null,\"parentId\":5,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":10,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员日志管理\",\"icon\":\"LineOutlined\",\"name\":\"user_log\",\"component\":null,\"parentId\":5,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":11,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"常规管理\",\"icon\":\"LineOutlined\",\"name\":\"routine\",\"component\":null,\"parentId\":null,\"sort\":96,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"系统配置\",\"icon\":\"LineOutlined\",\"name\":\"routine_config\",\"component\":\"/Routine/Config\",\"parentId\":11,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":14,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"个人资料\",\"icon\":\"LineOutlined\",\"name\":\"routine_info\",\"component\":\"/Routine/Info\",\"parentId\":11,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":13,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"附件管理\",\"icon\":null,\"name\":\"routine_annex\",\"component\":\"/Routine/Annex\",\"parentId\":11,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":15,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"模块市场\",\"icon\":null,\"name\":\"module\",\"component\":\"/Module\",\"parentId\":null,\"sort\":95,\"type\":2,\"code\":null,\"cache\":0,\"status\":0}],\"remark\":null}}',
    200,
    39,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    616,
    '2024-08-28 21:34:34.519463',
    '2024-08-28 21:34:34.519463',
    4,
    'admin',
    '菜单规则管理',
    '::1',
    '',
    '/admin/permission',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":24,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"首页\",\"icon\":null,\"name\":\"home\",\"component\":null,\"parentId\":null,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":2,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"权限管理\",\"icon\":\"LineOutlined\",\"name\":\"auth\",\"component\":null,\"parentId\":null,\"sort\":98,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":3,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"角色组管理\",\"icon\":\"AimOutlined\",\"name\":\"auth_group\",\"component\":null,\"parentId\":2,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":16,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_group_create\",\"component\":null,\"parentId\":3,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":17,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_group_update\",\"component\":null,\"parentId\":3,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":18,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_group_info\",\"component\":null,\"parentId\":3,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":19,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_group_delete\",\"component\":null,\"parentId\":3,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":7,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"管理员管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_admin\",\"component\":null,\"parentId\":2,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":20,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_admin_create\",\"component\":null,\"parentId\":7,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":21,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_admin_update\",\"component\":null,\"parentId\":7,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":22,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_admin_info\",\"component\":null,\"parentId\":7,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":23,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_admin_delete\",\"component\":null,\"parentId\":7,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":6,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"菜单规则管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_menu\",\"component\":null,\"parentId\":2,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":4,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"管理员日志管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"auth_log\",\"component\":null,\"parentId\":2,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":5,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"user\",\"component\":null,\"parentId\":null,\"sort\":97,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":8,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员管理\",\"icon\":\"LineOutlined\",\"name\":\"user_index\",\"component\":null,\"parentId\":5,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":1,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员分组管理\",\"icon\":null,\"name\":\"user_group\",\"component\":null,\"parentId\":5,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":9,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员规则管理\",\"icon\":\"AimOutlined\",\"name\":\"user_rule\",\"component\":null,\"parentId\":5,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":10,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员日志管理\",\"icon\":\"LineOutlined\",\"name\":\"user_log\",\"component\":null,\"parentId\":5,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":11,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"常规管理\",\"icon\":\"LineOutlined\",\"name\":\"routine\",\"component\":null,\"parentId\":null,\"sort\":96,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"系统配置\",\"icon\":\"LineOutlined\",\"name\":\"routine_config\",\"component\":\"/Routine/Config\",\"parentId\":11,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":14,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"个人资料\",\"icon\":\"LineOutlined\",\"name\":\"routine_info\",\"component\":\"/Routine/Info\",\"parentId\":11,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":13,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"附件管理\",\"icon\":null,\"name\":\"routine_annex\",\"component\":\"/Routine/Annex\",\"parentId\":11,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":15,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"模块市场\",\"icon\":null,\"name\":\"module\",\"component\":\"/Module\",\"parentId\":null,\"sort\":95,\"type\":2,\"code\":null,\"cache\":0,\"status\":0}],\"remark\":null}}',
    200,
    48,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    617,
    '2024-08-28 21:34:40.407312',
    '2024-08-28 21:34:40.407312',
    4,
    'admin',
    '管理员管理-详情',
    '::1',
    '',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    74,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    618,
    '2024-08-28 21:34:42.618079',
    '2024-08-28 21:34:42.618079',
    4,
    'admin',
    '菜单规则管理',
    '::1',
    '',
    '/admin/permission',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":24,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"首页\",\"icon\":null,\"name\":\"home\",\"component\":null,\"parentId\":null,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":2,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"权限管理\",\"icon\":\"LineOutlined\",\"name\":\"auth\",\"component\":null,\"parentId\":null,\"sort\":98,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":3,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"角色组管理\",\"icon\":\"AimOutlined\",\"name\":\"auth_group\",\"component\":null,\"parentId\":2,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":16,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_group_create\",\"component\":null,\"parentId\":3,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":17,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_group_update\",\"component\":null,\"parentId\":3,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":18,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_group_info\",\"component\":null,\"parentId\":3,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":19,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_group_delete\",\"component\":null,\"parentId\":3,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":7,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"管理员管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_admin\",\"component\":null,\"parentId\":2,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":20,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_admin_create\",\"component\":null,\"parentId\":7,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":21,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_admin_update\",\"component\":null,\"parentId\":7,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":22,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_admin_info\",\"component\":null,\"parentId\":7,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":23,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_admin_delete\",\"component\":null,\"parentId\":7,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":6,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"菜单规则管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_menu\",\"component\":null,\"parentId\":2,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":4,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"管理员日志管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"auth_log\",\"component\":null,\"parentId\":2,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":5,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"user\",\"component\":null,\"parentId\":null,\"sort\":97,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":8,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员管理\",\"icon\":\"LineOutlined\",\"name\":\"user_index\",\"component\":null,\"parentId\":5,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":1,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员分组管理\",\"icon\":null,\"name\":\"user_group\",\"component\":null,\"parentId\":5,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":9,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员规则管理\",\"icon\":\"AimOutlined\",\"name\":\"user_rule\",\"component\":null,\"parentId\":5,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":10,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员日志管理\",\"icon\":\"LineOutlined\",\"name\":\"user_log\",\"component\":null,\"parentId\":5,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":11,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"常规管理\",\"icon\":\"LineOutlined\",\"name\":\"routine\",\"component\":null,\"parentId\":null,\"sort\":96,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"系统配置\",\"icon\":\"LineOutlined\",\"name\":\"routine_config\",\"component\":\"/Routine/Config\",\"parentId\":11,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":14,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"个人资料\",\"icon\":\"LineOutlined\",\"name\":\"routine_info\",\"component\":\"/Routine/Info\",\"parentId\":11,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":13,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"附件管理\",\"icon\":null,\"name\":\"routine_annex\",\"component\":\"/Routine/Annex\",\"parentId\":11,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":15,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"模块市场\",\"icon\":null,\"name\":\"module\",\"component\":\"/Module\",\"parentId\":null,\"sort\":95,\"type\":2,\"code\":null,\"cache\":0,\"status\":0}],\"remark\":null}}',
    200,
    38,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    619,
    '2024-08-28 21:34:46.338051',
    '2024-08-28 21:34:46.338051',
    4,
    'admin',
    '菜单规则管理',
    '::1',
    '',
    '/admin/permission',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":24,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"首页\",\"icon\":null,\"name\":\"home\",\"component\":null,\"parentId\":null,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":2,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"权限管理\",\"icon\":\"LineOutlined\",\"name\":\"auth\",\"component\":null,\"parentId\":null,\"sort\":98,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":3,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"角色组管理\",\"icon\":\"AimOutlined\",\"name\":\"auth_group\",\"component\":null,\"parentId\":2,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":16,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_group_create\",\"component\":null,\"parentId\":3,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":17,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_group_update\",\"component\":null,\"parentId\":3,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":18,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_group_info\",\"component\":null,\"parentId\":3,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":19,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_group_delete\",\"component\":null,\"parentId\":3,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":7,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"管理员管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_admin\",\"component\":null,\"parentId\":2,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":20,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_admin_create\",\"component\":null,\"parentId\":7,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":21,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_admin_update\",\"component\":null,\"parentId\":7,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":22,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_admin_info\",\"component\":null,\"parentId\":7,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":23,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_admin_delete\",\"component\":null,\"parentId\":7,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":6,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"菜单规则管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_menu\",\"component\":null,\"parentId\":2,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":4,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"管理员日志管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"auth_log\",\"component\":null,\"parentId\":2,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":5,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"user\",\"component\":null,\"parentId\":null,\"sort\":97,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":8,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员管理\",\"icon\":\"LineOutlined\",\"name\":\"user_index\",\"component\":null,\"parentId\":5,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":1,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员分组管理\",\"icon\":null,\"name\":\"user_group\",\"component\":null,\"parentId\":5,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":9,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员规则管理\",\"icon\":\"AimOutlined\",\"name\":\"user_rule\",\"component\":null,\"parentId\":5,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":10,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员日志管理\",\"icon\":\"LineOutlined\",\"name\":\"user_log\",\"component\":null,\"parentId\":5,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":11,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"常规管理\",\"icon\":\"LineOutlined\",\"name\":\"routine\",\"component\":null,\"parentId\":null,\"sort\":96,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"系统配置\",\"icon\":\"LineOutlined\",\"name\":\"routine_config\",\"component\":\"/Routine/Config\",\"parentId\":11,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":14,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"个人资料\",\"icon\":\"LineOutlined\",\"name\":\"routine_info\",\"component\":\"/Routine/Info\",\"parentId\":11,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":13,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"附件管理\",\"icon\":null,\"name\":\"routine_annex\",\"component\":\"/Routine/Annex\",\"parentId\":11,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":15,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"模块市场\",\"icon\":null,\"name\":\"module\",\"component\":\"/Module\",\"parentId\":null,\"sort\":95,\"type\":2,\"code\":null,\"cache\":0,\"status\":0}],\"remark\":null}}',
    200,
    44,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    620,
    '2024-08-28 21:38:48.515976',
    '2024-08-28 21:38:48.515976',
    4,
    'admin',
    '管理员管理-详情',
    '::1',
    '',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    87,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    621,
    '2024-08-28 21:39:16.563925',
    '2024-08-28 21:39:16.563925',
    4,
    'admin',
    '管理员管理-详情',
    '::1',
    '',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    86,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    622,
    '2024-08-28 21:39:30.968637',
    '2024-08-28 21:39:30.968637',
    4,
    'admin',
    '管理员管理-详情',
    '::1',
    '',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    126,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    623,
    '2024-08-28 21:39:32.304612',
    '2024-08-28 21:39:32.304612',
    4,
    'admin',
    '管理员管理-详情',
    '::1',
    '',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    87,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    624,
    '2024-08-28 21:39:32.307731',
    '2024-08-28 21:39:32.307731',
    4,
    'admin',
    '角色组管理',
    '::1',
    '',
    '/admin/role',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":1,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"超级管理员\",\"slug\":\"super_admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":0,\"children\":[{\"id\":9,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通管理员\",\"slug\":\"admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":1,\"children\":[{\"id\":10,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"超级会员\",\"slug\":\"super_member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":9,\"children\":[{\"id\":11,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通会员\",\"slug\":\"member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":10,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通用户\",\"slug\":\"user\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":11,\"children\":null}]}]}]}]}],\"remark\":null}}',
    200,
    83,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    625,
    '2024-08-28 21:39:32.634126',
    '2024-08-28 21:39:32.634126',
    4,
    'admin',
    '附件管理',
    '::1',
    '',
    '/files/list?page=1&size=10',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"page\":1,\"size\":10,\"total\":15,\"records\":[{\"id\":151,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"oceans.mp4\",\"hash\":\"9f8f979374969429263495ffcaac832cd603b1efe4c66a05fafd6729dffef9af\",\"path\":\"/uploads/2024/08/07/oceans.mp4\",\"mimetype\":\"video/mp4\",\"size\":23014356,\"uploadCount\":15,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/oceans.mp4\"},{\"id\":152,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"财务记账系统excel表格.xlsx\",\"hash\":\"b55ab38ff825b0360bea155510d9fee9c41812fabfe7e9fdb0aa36714195e266\",\"path\":\"/uploads/2024/08/07/财务记账系统excel表格.xlsx\",\"mimetype\":\"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet\",\"size\":97475,\"uploadCount\":4,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/财务记账系统excel表格.xlsx\"},{\"id\":153,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"测试Markdown.md\",\"hash\":\"9bab5812e9c7319230796121a872f2f10d47878d985c83fe88abd9e0119f73b0\",\"path\":\"/uploads/2024/08/07/测试Markdown.md\",\"mimetype\":\"application/octet-stream\",\"size\":11364,\"uploadCount\":2,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/测试Markdown.md\"},{\"id\":154,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"image.jpeg\",\"hash\":\"a737ff09ec2ce204c6a1e0edfe5af0b0c3a81c07af5d31f900b1ff55b39a2201\",\"path\":\"/uploads/2024/08/07/image.jpeg\",\"mimetype\":\"image/jpeg\",\"size\":106111,\"uploadCount\":11,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/image.jpeg\"},{\"id\":155,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"changtu1.jpg\",\"hash\":\"0d83b5b689384e4e08721f873a1c981cdcddd3de0f7493b23c21cc28efa4efee\",\"path\":\"/uploads/2024/08/07/changtu1.jpg\",\"mimetype\":\"image/jpeg\",\"size\":48593,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/changtu1.jpg\"},{\"id\":156,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.doc\",\"hash\":\"b7dcfae78826ae565dfdd434145d3b74aca506738c0c31952370dd6b610b549d\",\"path\":\"/uploads/2024/08/07/目录文件.doc\",\"mimetype\":\"application/msword\",\"size\":1055816,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.doc\"},{\"id\":157,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.htm\",\"hash\":\"c8cc7106cc4a16fedf0bafe622e8ede5905ff4f9b3064f03ecab7980dcb72671\",\"path\":\"/uploads/2024/08/07/目录文件.htm\",\"mimetype\":\"text/html\",\"size\":349870,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.htm\"},{\"id\":158,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.txt\",\"hash\":\"4fb5c4132a38bf42068b9cd58fa8419e792e786a4a4160faf8fabf33d623371f\",\"path\":\"/uploads/2024/08/07/目录文件.txt\",\"mimetype\":\"text/plain\",\"size\":413766,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.txt\"},{\"id\":159,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"时间线规则.xmind\",\"hash\":\"9e21393ff90f96b9570e6dc5d8f1b4ca148d520f738fea61d0e8633d86865cac\",\"path\":\"/uploads/2024/08/07/时间线规则.xmind\",\"mimetype\":\"application/octet-stream\",\"size\":47082,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/时间线规则.xmind\"},{\"id\":165,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"新建 PPT 演示文稿.ppt\",\"hash\":\"310b06ff0a793076844f8be83a752745b3915cd23e35427b88047b801be76424\",\"path\":\"/uploads/2024/08/07/新建 PPT 演示文稿.ppt\",\"mimetype\":\"application/vnd.ms-powerpoint\",\"size\":20992,\"uploadCount\":7,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/新建 PPT 演示文稿.ppt\"}],\"remark\":\"同一文件被多次上传时，只会保存一份至磁盘和增加一条附件记录；删除附件记录，将自动删除对应文件！\"}}',
    200,
    81,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    626,
    '2024-08-28 21:39:34.801528',
    '2024-08-28 21:39:34.801528',
    4,
    'admin',
    '附件管理',
    '::1',
    '',
    '/files/list?page=1&size=10',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"page\":1,\"size\":10,\"total\":15,\"records\":[{\"id\":151,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"oceans.mp4\",\"hash\":\"9f8f979374969429263495ffcaac832cd603b1efe4c66a05fafd6729dffef9af\",\"path\":\"/uploads/2024/08/07/oceans.mp4\",\"mimetype\":\"video/mp4\",\"size\":23014356,\"uploadCount\":15,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/oceans.mp4\"},{\"id\":152,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"财务记账系统excel表格.xlsx\",\"hash\":\"b55ab38ff825b0360bea155510d9fee9c41812fabfe7e9fdb0aa36714195e266\",\"path\":\"/uploads/2024/08/07/财务记账系统excel表格.xlsx\",\"mimetype\":\"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet\",\"size\":97475,\"uploadCount\":4,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/财务记账系统excel表格.xlsx\"},{\"id\":153,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"测试Markdown.md\",\"hash\":\"9bab5812e9c7319230796121a872f2f10d47878d985c83fe88abd9e0119f73b0\",\"path\":\"/uploads/2024/08/07/测试Markdown.md\",\"mimetype\":\"application/octet-stream\",\"size\":11364,\"uploadCount\":2,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/测试Markdown.md\"},{\"id\":154,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"image.jpeg\",\"hash\":\"a737ff09ec2ce204c6a1e0edfe5af0b0c3a81c07af5d31f900b1ff55b39a2201\",\"path\":\"/uploads/2024/08/07/image.jpeg\",\"mimetype\":\"image/jpeg\",\"size\":106111,\"uploadCount\":11,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/image.jpeg\"},{\"id\":155,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"changtu1.jpg\",\"hash\":\"0d83b5b689384e4e08721f873a1c981cdcddd3de0f7493b23c21cc28efa4efee\",\"path\":\"/uploads/2024/08/07/changtu1.jpg\",\"mimetype\":\"image/jpeg\",\"size\":48593,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/changtu1.jpg\"},{\"id\":156,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.doc\",\"hash\":\"b7dcfae78826ae565dfdd434145d3b74aca506738c0c31952370dd6b610b549d\",\"path\":\"/uploads/2024/08/07/目录文件.doc\",\"mimetype\":\"application/msword\",\"size\":1055816,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.doc\"},{\"id\":157,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.htm\",\"hash\":\"c8cc7106cc4a16fedf0bafe622e8ede5905ff4f9b3064f03ecab7980dcb72671\",\"path\":\"/uploads/2024/08/07/目录文件.htm\",\"mimetype\":\"text/html\",\"size\":349870,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.htm\"},{\"id\":158,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.txt\",\"hash\":\"4fb5c4132a38bf42068b9cd58fa8419e792e786a4a4160faf8fabf33d623371f\",\"path\":\"/uploads/2024/08/07/目录文件.txt\",\"mimetype\":\"text/plain\",\"size\":413766,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.txt\"},{\"id\":159,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"时间线规则.xmind\",\"hash\":\"9e21393ff90f96b9570e6dc5d8f1b4ca148d520f738fea61d0e8633d86865cac\",\"path\":\"/uploads/2024/08/07/时间线规则.xmind\",\"mimetype\":\"application/octet-stream\",\"size\":47082,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/时间线规则.xmind\"},{\"id\":165,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"新建 PPT 演示文稿.ppt\",\"hash\":\"310b06ff0a793076844f8be83a752745b3915cd23e35427b88047b801be76424\",\"path\":\"/uploads/2024/08/07/新建 PPT 演示文稿.ppt\",\"mimetype\":\"application/vnd.ms-powerpoint\",\"size\":20992,\"uploadCount\":7,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/新建 PPT 演示文稿.ppt\"}],\"remark\":\"同一文件被多次上传时，只会保存一份至磁盘和增加一条附件记录；删除附件记录，将自动删除对应文件！\"}}',
    200,
    80,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    627,
    '2024-08-28 21:39:43.362797',
    '2024-08-28 21:39:43.362797',
    4,
    'admin',
    '管理员管理-详情',
    '::1',
    '',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    71,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    628,
    '2024-08-28 21:39:43.386476',
    '2024-08-28 21:39:43.386476',
    4,
    'admin',
    '附件管理',
    '::1',
    '',
    '/files/list?page=1&size=10',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"page\":1,\"size\":10,\"total\":15,\"records\":[{\"id\":151,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"oceans.mp4\",\"hash\":\"9f8f979374969429263495ffcaac832cd603b1efe4c66a05fafd6729dffef9af\",\"path\":\"/uploads/2024/08/07/oceans.mp4\",\"mimetype\":\"video/mp4\",\"size\":23014356,\"uploadCount\":15,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/oceans.mp4\"},{\"id\":152,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"财务记账系统excel表格.xlsx\",\"hash\":\"b55ab38ff825b0360bea155510d9fee9c41812fabfe7e9fdb0aa36714195e266\",\"path\":\"/uploads/2024/08/07/财务记账系统excel表格.xlsx\",\"mimetype\":\"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet\",\"size\":97475,\"uploadCount\":4,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/财务记账系统excel表格.xlsx\"},{\"id\":153,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"测试Markdown.md\",\"hash\":\"9bab5812e9c7319230796121a872f2f10d47878d985c83fe88abd9e0119f73b0\",\"path\":\"/uploads/2024/08/07/测试Markdown.md\",\"mimetype\":\"application/octet-stream\",\"size\":11364,\"uploadCount\":2,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/测试Markdown.md\"},{\"id\":154,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"image.jpeg\",\"hash\":\"a737ff09ec2ce204c6a1e0edfe5af0b0c3a81c07af5d31f900b1ff55b39a2201\",\"path\":\"/uploads/2024/08/07/image.jpeg\",\"mimetype\":\"image/jpeg\",\"size\":106111,\"uploadCount\":11,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/image.jpeg\"},{\"id\":155,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"changtu1.jpg\",\"hash\":\"0d83b5b689384e4e08721f873a1c981cdcddd3de0f7493b23c21cc28efa4efee\",\"path\":\"/uploads/2024/08/07/changtu1.jpg\",\"mimetype\":\"image/jpeg\",\"size\":48593,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/changtu1.jpg\"},{\"id\":156,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.doc\",\"hash\":\"b7dcfae78826ae565dfdd434145d3b74aca506738c0c31952370dd6b610b549d\",\"path\":\"/uploads/2024/08/07/目录文件.doc\",\"mimetype\":\"application/msword\",\"size\":1055816,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.doc\"},{\"id\":157,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.htm\",\"hash\":\"c8cc7106cc4a16fedf0bafe622e8ede5905ff4f9b3064f03ecab7980dcb72671\",\"path\":\"/uploads/2024/08/07/目录文件.htm\",\"mimetype\":\"text/html\",\"size\":349870,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.htm\"},{\"id\":158,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.txt\",\"hash\":\"4fb5c4132a38bf42068b9cd58fa8419e792e786a4a4160faf8fabf33d623371f\",\"path\":\"/uploads/2024/08/07/目录文件.txt\",\"mimetype\":\"text/plain\",\"size\":413766,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.txt\"},{\"id\":159,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"时间线规则.xmind\",\"hash\":\"9e21393ff90f96b9570e6dc5d8f1b4ca148d520f738fea61d0e8633d86865cac\",\"path\":\"/uploads/2024/08/07/时间线规则.xmind\",\"mimetype\":\"application/octet-stream\",\"size\":47082,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/时间线规则.xmind\"},{\"id\":165,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"新建 PPT 演示文稿.ppt\",\"hash\":\"310b06ff0a793076844f8be83a752745b3915cd23e35427b88047b801be76424\",\"path\":\"/uploads/2024/08/07/新建 PPT 演示文稿.ppt\",\"mimetype\":\"application/vnd.ms-powerpoint\",\"size\":20992,\"uploadCount\":7,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/新建 PPT 演示文稿.ppt\"}],\"remark\":\"同一文件被多次上传时，只会保存一份至磁盘和增加一条附件记录；删除附件记录，将自动删除对应文件！\"}}',
    200,
    79,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    629,
    '2024-08-28 21:41:03.322784',
    '2024-08-28 21:41:03.322784',
    4,
    'admin',
    '附件管理',
    '::1',
    '',
    '/files/list?page=1&size=10',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"page\":1,\"size\":10,\"total\":15,\"records\":[{\"id\":151,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"oceans.mp4\",\"hash\":\"9f8f979374969429263495ffcaac832cd603b1efe4c66a05fafd6729dffef9af\",\"path\":\"/uploads/2024/08/07/oceans.mp4\",\"mimetype\":\"video/mp4\",\"size\":23014356,\"uploadCount\":15,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/oceans.mp4\"},{\"id\":152,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"财务记账系统excel表格.xlsx\",\"hash\":\"b55ab38ff825b0360bea155510d9fee9c41812fabfe7e9fdb0aa36714195e266\",\"path\":\"/uploads/2024/08/07/财务记账系统excel表格.xlsx\",\"mimetype\":\"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet\",\"size\":97475,\"uploadCount\":4,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/财务记账系统excel表格.xlsx\"},{\"id\":153,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"测试Markdown.md\",\"hash\":\"9bab5812e9c7319230796121a872f2f10d47878d985c83fe88abd9e0119f73b0\",\"path\":\"/uploads/2024/08/07/测试Markdown.md\",\"mimetype\":\"application/octet-stream\",\"size\":11364,\"uploadCount\":2,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/测试Markdown.md\"},{\"id\":154,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"image.jpeg\",\"hash\":\"a737ff09ec2ce204c6a1e0edfe5af0b0c3a81c07af5d31f900b1ff55b39a2201\",\"path\":\"/uploads/2024/08/07/image.jpeg\",\"mimetype\":\"image/jpeg\",\"size\":106111,\"uploadCount\":11,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/image.jpeg\"},{\"id\":155,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"changtu1.jpg\",\"hash\":\"0d83b5b689384e4e08721f873a1c981cdcddd3de0f7493b23c21cc28efa4efee\",\"path\":\"/uploads/2024/08/07/changtu1.jpg\",\"mimetype\":\"image/jpeg\",\"size\":48593,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/changtu1.jpg\"},{\"id\":156,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.doc\",\"hash\":\"b7dcfae78826ae565dfdd434145d3b74aca506738c0c31952370dd6b610b549d\",\"path\":\"/uploads/2024/08/07/目录文件.doc\",\"mimetype\":\"application/msword\",\"size\":1055816,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.doc\"},{\"id\":157,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.htm\",\"hash\":\"c8cc7106cc4a16fedf0bafe622e8ede5905ff4f9b3064f03ecab7980dcb72671\",\"path\":\"/uploads/2024/08/07/目录文件.htm\",\"mimetype\":\"text/html\",\"size\":349870,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.htm\"},{\"id\":158,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.txt\",\"hash\":\"4fb5c4132a38bf42068b9cd58fa8419e792e786a4a4160faf8fabf33d623371f\",\"path\":\"/uploads/2024/08/07/目录文件.txt\",\"mimetype\":\"text/plain\",\"size\":413766,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.txt\"},{\"id\":159,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"时间线规则.xmind\",\"hash\":\"9e21393ff90f96b9570e6dc5d8f1b4ca148d520f738fea61d0e8633d86865cac\",\"path\":\"/uploads/2024/08/07/时间线规则.xmind\",\"mimetype\":\"application/octet-stream\",\"size\":47082,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/时间线规则.xmind\"},{\"id\":165,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"新建 PPT 演示文稿.ppt\",\"hash\":\"310b06ff0a793076844f8be83a752745b3915cd23e35427b88047b801be76424\",\"path\":\"/uploads/2024/08/07/新建 PPT 演示文稿.ppt\",\"mimetype\":\"application/vnd.ms-powerpoint\",\"size\":20992,\"uploadCount\":7,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/新建 PPT 演示文稿.ppt\"}],\"remark\":\"同一文件被多次上传时，只会保存一份至磁盘和增加一条附件记录；删除附件记录，将自动删除对应文件！\"}}',
    200,
    145,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    630,
    '2024-08-28 21:41:08.166994',
    '2024-08-28 21:41:08.166994',
    4,
    'admin',
    '附件管理',
    '::1',
    '',
    '/files/list?page=1&size=10',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"page\":1,\"size\":10,\"total\":15,\"records\":[{\"id\":151,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"oceans.mp4\",\"hash\":\"9f8f979374969429263495ffcaac832cd603b1efe4c66a05fafd6729dffef9af\",\"path\":\"/uploads/2024/08/07/oceans.mp4\",\"mimetype\":\"video/mp4\",\"size\":23014356,\"uploadCount\":15,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/oceans.mp4\"},{\"id\":152,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"财务记账系统excel表格.xlsx\",\"hash\":\"b55ab38ff825b0360bea155510d9fee9c41812fabfe7e9fdb0aa36714195e266\",\"path\":\"/uploads/2024/08/07/财务记账系统excel表格.xlsx\",\"mimetype\":\"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet\",\"size\":97475,\"uploadCount\":4,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/财务记账系统excel表格.xlsx\"},{\"id\":153,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"测试Markdown.md\",\"hash\":\"9bab5812e9c7319230796121a872f2f10d47878d985c83fe88abd9e0119f73b0\",\"path\":\"/uploads/2024/08/07/测试Markdown.md\",\"mimetype\":\"application/octet-stream\",\"size\":11364,\"uploadCount\":2,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/测试Markdown.md\"},{\"id\":154,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"image.jpeg\",\"hash\":\"a737ff09ec2ce204c6a1e0edfe5af0b0c3a81c07af5d31f900b1ff55b39a2201\",\"path\":\"/uploads/2024/08/07/image.jpeg\",\"mimetype\":\"image/jpeg\",\"size\":106111,\"uploadCount\":11,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/image.jpeg\"},{\"id\":155,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"changtu1.jpg\",\"hash\":\"0d83b5b689384e4e08721f873a1c981cdcddd3de0f7493b23c21cc28efa4efee\",\"path\":\"/uploads/2024/08/07/changtu1.jpg\",\"mimetype\":\"image/jpeg\",\"size\":48593,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/changtu1.jpg\"},{\"id\":156,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.doc\",\"hash\":\"b7dcfae78826ae565dfdd434145d3b74aca506738c0c31952370dd6b610b549d\",\"path\":\"/uploads/2024/08/07/目录文件.doc\",\"mimetype\":\"application/msword\",\"size\":1055816,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.doc\"},{\"id\":157,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.htm\",\"hash\":\"c8cc7106cc4a16fedf0bafe622e8ede5905ff4f9b3064f03ecab7980dcb72671\",\"path\":\"/uploads/2024/08/07/目录文件.htm\",\"mimetype\":\"text/html\",\"size\":349870,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.htm\"},{\"id\":158,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.txt\",\"hash\":\"4fb5c4132a38bf42068b9cd58fa8419e792e786a4a4160faf8fabf33d623371f\",\"path\":\"/uploads/2024/08/07/目录文件.txt\",\"mimetype\":\"text/plain\",\"size\":413766,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.txt\"},{\"id\":159,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"时间线规则.xmind\",\"hash\":\"9e21393ff90f96b9570e6dc5d8f1b4ca148d520f738fea61d0e8633d86865cac\",\"path\":\"/uploads/2024/08/07/时间线规则.xmind\",\"mimetype\":\"application/octet-stream\",\"size\":47082,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/时间线规则.xmind\"},{\"id\":165,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"新建 PPT 演示文稿.ppt\",\"hash\":\"310b06ff0a793076844f8be83a752745b3915cd23e35427b88047b801be76424\",\"path\":\"/uploads/2024/08/07/新建 PPT 演示文稿.ppt\",\"mimetype\":\"application/vnd.ms-powerpoint\",\"size\":20992,\"uploadCount\":7,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/新建 PPT 演示文稿.ppt\"}],\"remark\":\"同一文件被多次上传时，只会保存一份至磁盘和增加一条附件记录；删除附件记录，将自动删除对应文件！\"}}',
    200,
    73,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    631,
    '2024-08-28 21:41:08.169688',
    '2024-08-28 21:41:08.169688',
    4,
    'admin',
    '管理员管理-详情',
    '::1',
    '',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    86,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    632,
    '2024-08-28 21:42:22.284340',
    '2024-08-28 21:42:22.284340',
    4,
    'admin',
    '管理员管理-详情',
    '::1',
    '',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    124,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    633,
    '2024-08-28 21:43:29.337235',
    '2024-08-28 21:43:29.337235',
    4,
    'admin',
    '管理员管理-详情',
    '::1',
    '',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    138,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    634,
    '2024-08-28 21:44:10.859936',
    '2024-08-28 21:44:10.859936',
    4,
    'admin',
    '管理员管理-详情',
    '::1',
    '',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    139,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    635,
    '2024-08-28 21:44:57.393931',
    '2024-08-28 21:44:57.393931',
    4,
    'admin',
    '管理员管理-详情',
    '::1',
    '',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    164,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    636,
    '2024-08-28 21:45:13.409131',
    '2024-08-28 21:45:13.409131',
    4,
    'admin',
    '管理员管理-详情',
    '::1',
    '',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    91,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    637,
    '2024-08-28 21:45:28.318407',
    '2024-08-28 21:45:28.318407',
    4,
    'admin',
    '管理员管理-详情',
    '::1',
    '',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    87,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    638,
    '2024-08-28 21:45:32.032672',
    '2024-08-28 21:45:32.032672',
    4,
    'admin',
    '管理员管理-详情',
    '::1',
    '',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    85,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    639,
    '2024-08-28 21:45:39.012942',
    '2024-08-28 21:45:39.012942',
    4,
    'admin',
    '附件管理',
    '::1',
    '',
    '/files/list?page=1&size=10',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"page\":1,\"size\":10,\"total\":15,\"records\":[{\"id\":151,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"oceans.mp4\",\"hash\":\"9f8f979374969429263495ffcaac832cd603b1efe4c66a05fafd6729dffef9af\",\"path\":\"/uploads/2024/08/07/oceans.mp4\",\"mimetype\":\"video/mp4\",\"size\":23014356,\"uploadCount\":15,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/oceans.mp4\"},{\"id\":152,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"财务记账系统excel表格.xlsx\",\"hash\":\"b55ab38ff825b0360bea155510d9fee9c41812fabfe7e9fdb0aa36714195e266\",\"path\":\"/uploads/2024/08/07/财务记账系统excel表格.xlsx\",\"mimetype\":\"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet\",\"size\":97475,\"uploadCount\":4,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/财务记账系统excel表格.xlsx\"},{\"id\":153,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"测试Markdown.md\",\"hash\":\"9bab5812e9c7319230796121a872f2f10d47878d985c83fe88abd9e0119f73b0\",\"path\":\"/uploads/2024/08/07/测试Markdown.md\",\"mimetype\":\"application/octet-stream\",\"size\":11364,\"uploadCount\":2,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/测试Markdown.md\"},{\"id\":154,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"image.jpeg\",\"hash\":\"a737ff09ec2ce204c6a1e0edfe5af0b0c3a81c07af5d31f900b1ff55b39a2201\",\"path\":\"/uploads/2024/08/07/image.jpeg\",\"mimetype\":\"image/jpeg\",\"size\":106111,\"uploadCount\":11,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/image.jpeg\"},{\"id\":155,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"changtu1.jpg\",\"hash\":\"0d83b5b689384e4e08721f873a1c981cdcddd3de0f7493b23c21cc28efa4efee\",\"path\":\"/uploads/2024/08/07/changtu1.jpg\",\"mimetype\":\"image/jpeg\",\"size\":48593,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/changtu1.jpg\"},{\"id\":156,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.doc\",\"hash\":\"b7dcfae78826ae565dfdd434145d3b74aca506738c0c31952370dd6b610b549d\",\"path\":\"/uploads/2024/08/07/目录文件.doc\",\"mimetype\":\"application/msword\",\"size\":1055816,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.doc\"},{\"id\":157,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.htm\",\"hash\":\"c8cc7106cc4a16fedf0bafe622e8ede5905ff4f9b3064f03ecab7980dcb72671\",\"path\":\"/uploads/2024/08/07/目录文件.htm\",\"mimetype\":\"text/html\",\"size\":349870,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.htm\"},{\"id\":158,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.txt\",\"hash\":\"4fb5c4132a38bf42068b9cd58fa8419e792e786a4a4160faf8fabf33d623371f\",\"path\":\"/uploads/2024/08/07/目录文件.txt\",\"mimetype\":\"text/plain\",\"size\":413766,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.txt\"},{\"id\":159,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"时间线规则.xmind\",\"hash\":\"9e21393ff90f96b9570e6dc5d8f1b4ca148d520f738fea61d0e8633d86865cac\",\"path\":\"/uploads/2024/08/07/时间线规则.xmind\",\"mimetype\":\"application/octet-stream\",\"size\":47082,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/时间线规则.xmind\"},{\"id\":165,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"新建 PPT 演示文稿.ppt\",\"hash\":\"310b06ff0a793076844f8be83a752745b3915cd23e35427b88047b801be76424\",\"path\":\"/uploads/2024/08/07/新建 PPT 演示文稿.ppt\",\"mimetype\":\"application/vnd.ms-powerpoint\",\"size\":20992,\"uploadCount\":7,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/新建 PPT 演示文稿.ppt\"}],\"remark\":\"同一文件被多次上传时，只会保存一份至磁盘和增加一条附件记录；删除附件记录，将自动删除对应文件！\"}}',
    200,
    99,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    640,
    '2024-08-28 21:45:42.397688',
    '2024-08-28 21:45:42.397688',
    4,
    'admin',
    '附件管理',
    '::1',
    '',
    '/files/list?page=2&size=10',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"page\":2,\"size\":10,\"total\":15,\"records\":[{\"id\":166,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"新建 Microsoft Excel 工作表.xlsx\",\"hash\":\"caeb42858652a3240842f39c5777e7163d93ec47b88f0ce06bff6c09cee21271\",\"path\":\"/uploads/2024/08/07/新建 Microsoft Excel 工作表.xlsx\",\"mimetype\":\"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet\",\"size\":6602,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/新建 Microsoft Excel 工作表.xlsx\"},{\"id\":167,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"新建 WinRAR ZIP 压缩文件.ZIP\",\"hash\":\"8739c76e681f900923b900c9df0ef75cf421d39cabb54650c4b9ad19b6a76d85\",\"path\":\"/uploads/2024/08/07/新建 WinRAR ZIP 压缩文件.ZIP\",\"mimetype\":\"application/x-zip-compressed\",\"size\":22,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/新建 WinRAR ZIP 压缩文件.ZIP\"},{\"id\":168,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"新建 XLS 工作表.rar\",\"hash\":\"6215c79a7d791b99d0d351c1692a92575811dd847e2f67b7b24dd85f66b32358\",\"path\":\"/uploads/2024/08/07/新建 XLS 工作表.rar\",\"mimetype\":\"application/x-compressed\",\"size\":5541,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/新建 XLS 工作表.rar\"},{\"id\":169,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"640 (19).jpg\",\"hash\":\"d0fba6d55183191f96c39671f087acad70386a3593da89978aafaf9a8da8bd7e\",\"path\":\"/uploads/2024/08/10/640 (19).jpg\",\"mimetype\":\"image/jpeg\",\"size\":58686,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/10/640 (19).jpg\"},{\"id\":170,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"超宽图片.jpg\",\"hash\":\"9993abaae64732b2715121704a9b0973043688dd1ba11165046832ef20c53ffc\",\"path\":\"/uploads/2024/08/17/超宽图片.jpg\",\"mimetype\":\"image/jpeg\",\"size\":6064,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/17/超宽图片.jpg\"}],\"remark\":\"同一文件被多次上传时，只会保存一份至磁盘和增加一条附件记录；删除附件记录，将自动删除对应文件！\"}}',
    200,
    125,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    641,
    '2024-08-28 21:45:44.964413',
    '2024-08-28 21:45:44.964413',
    4,
    'admin',
    '附件管理',
    '::1',
    '',
    '/files/list?page=1&size=10',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"page\":1,\"size\":10,\"total\":15,\"records\":[{\"id\":151,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"oceans.mp4\",\"hash\":\"9f8f979374969429263495ffcaac832cd603b1efe4c66a05fafd6729dffef9af\",\"path\":\"/uploads/2024/08/07/oceans.mp4\",\"mimetype\":\"video/mp4\",\"size\":23014356,\"uploadCount\":15,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/oceans.mp4\"},{\"id\":152,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"财务记账系统excel表格.xlsx\",\"hash\":\"b55ab38ff825b0360bea155510d9fee9c41812fabfe7e9fdb0aa36714195e266\",\"path\":\"/uploads/2024/08/07/财务记账系统excel表格.xlsx\",\"mimetype\":\"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet\",\"size\":97475,\"uploadCount\":4,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/财务记账系统excel表格.xlsx\"},{\"id\":153,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"测试Markdown.md\",\"hash\":\"9bab5812e9c7319230796121a872f2f10d47878d985c83fe88abd9e0119f73b0\",\"path\":\"/uploads/2024/08/07/测试Markdown.md\",\"mimetype\":\"application/octet-stream\",\"size\":11364,\"uploadCount\":2,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/测试Markdown.md\"},{\"id\":154,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"image.jpeg\",\"hash\":\"a737ff09ec2ce204c6a1e0edfe5af0b0c3a81c07af5d31f900b1ff55b39a2201\",\"path\":\"/uploads/2024/08/07/image.jpeg\",\"mimetype\":\"image/jpeg\",\"size\":106111,\"uploadCount\":11,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/image.jpeg\"},{\"id\":155,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"changtu1.jpg\",\"hash\":\"0d83b5b689384e4e08721f873a1c981cdcddd3de0f7493b23c21cc28efa4efee\",\"path\":\"/uploads/2024/08/07/changtu1.jpg\",\"mimetype\":\"image/jpeg\",\"size\":48593,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/changtu1.jpg\"},{\"id\":156,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.doc\",\"hash\":\"b7dcfae78826ae565dfdd434145d3b74aca506738c0c31952370dd6b610b549d\",\"path\":\"/uploads/2024/08/07/目录文件.doc\",\"mimetype\":\"application/msword\",\"size\":1055816,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.doc\"},{\"id\":157,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.htm\",\"hash\":\"c8cc7106cc4a16fedf0bafe622e8ede5905ff4f9b3064f03ecab7980dcb72671\",\"path\":\"/uploads/2024/08/07/目录文件.htm\",\"mimetype\":\"text/html\",\"size\":349870,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.htm\"},{\"id\":158,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.txt\",\"hash\":\"4fb5c4132a38bf42068b9cd58fa8419e792e786a4a4160faf8fabf33d623371f\",\"path\":\"/uploads/2024/08/07/目录文件.txt\",\"mimetype\":\"text/plain\",\"size\":413766,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.txt\"},{\"id\":159,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"时间线规则.xmind\",\"hash\":\"9e21393ff90f96b9570e6dc5d8f1b4ca148d520f738fea61d0e8633d86865cac\",\"path\":\"/uploads/2024/08/07/时间线规则.xmind\",\"mimetype\":\"application/octet-stream\",\"size\":47082,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/时间线规则.xmind\"},{\"id\":165,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"新建 PPT 演示文稿.ppt\",\"hash\":\"310b06ff0a793076844f8be83a752745b3915cd23e35427b88047b801be76424\",\"path\":\"/uploads/2024/08/07/新建 PPT 演示文稿.ppt\",\"mimetype\":\"application/vnd.ms-powerpoint\",\"size\":20992,\"uploadCount\":7,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/新建 PPT 演示文稿.ppt\"}],\"remark\":\"同一文件被多次上传时，只会保存一份至磁盘和增加一条附件记录；删除附件记录，将自动删除对应文件！\"}}',
    200,
    83,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    642,
    '2024-08-28 21:45:50.132621',
    '2024-08-28 21:45:50.132621',
    4,
    'admin',
    '附件管理',
    '::1',
    '',
    '/files/list?page=1&size=10',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"page\":1,\"size\":10,\"total\":15,\"records\":[{\"id\":151,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"oceans.mp4\",\"hash\":\"9f8f979374969429263495ffcaac832cd603b1efe4c66a05fafd6729dffef9af\",\"path\":\"/uploads/2024/08/07/oceans.mp4\",\"mimetype\":\"video/mp4\",\"size\":23014356,\"uploadCount\":15,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/oceans.mp4\"},{\"id\":152,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"财务记账系统excel表格.xlsx\",\"hash\":\"b55ab38ff825b0360bea155510d9fee9c41812fabfe7e9fdb0aa36714195e266\",\"path\":\"/uploads/2024/08/07/财务记账系统excel表格.xlsx\",\"mimetype\":\"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet\",\"size\":97475,\"uploadCount\":4,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/财务记账系统excel表格.xlsx\"},{\"id\":153,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"测试Markdown.md\",\"hash\":\"9bab5812e9c7319230796121a872f2f10d47878d985c83fe88abd9e0119f73b0\",\"path\":\"/uploads/2024/08/07/测试Markdown.md\",\"mimetype\":\"application/octet-stream\",\"size\":11364,\"uploadCount\":2,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/测试Markdown.md\"},{\"id\":154,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"image.jpeg\",\"hash\":\"a737ff09ec2ce204c6a1e0edfe5af0b0c3a81c07af5d31f900b1ff55b39a2201\",\"path\":\"/uploads/2024/08/07/image.jpeg\",\"mimetype\":\"image/jpeg\",\"size\":106111,\"uploadCount\":11,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/image.jpeg\"},{\"id\":155,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"changtu1.jpg\",\"hash\":\"0d83b5b689384e4e08721f873a1c981cdcddd3de0f7493b23c21cc28efa4efee\",\"path\":\"/uploads/2024/08/07/changtu1.jpg\",\"mimetype\":\"image/jpeg\",\"size\":48593,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/changtu1.jpg\"},{\"id\":156,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.doc\",\"hash\":\"b7dcfae78826ae565dfdd434145d3b74aca506738c0c31952370dd6b610b549d\",\"path\":\"/uploads/2024/08/07/目录文件.doc\",\"mimetype\":\"application/msword\",\"size\":1055816,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.doc\"},{\"id\":157,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.htm\",\"hash\":\"c8cc7106cc4a16fedf0bafe622e8ede5905ff4f9b3064f03ecab7980dcb72671\",\"path\":\"/uploads/2024/08/07/目录文件.htm\",\"mimetype\":\"text/html\",\"size\":349870,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.htm\"},{\"id\":158,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.txt\",\"hash\":\"4fb5c4132a38bf42068b9cd58fa8419e792e786a4a4160faf8fabf33d623371f\",\"path\":\"/uploads/2024/08/07/目录文件.txt\",\"mimetype\":\"text/plain\",\"size\":413766,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.txt\"},{\"id\":159,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"时间线规则.xmind\",\"hash\":\"9e21393ff90f96b9570e6dc5d8f1b4ca148d520f738fea61d0e8633d86865cac\",\"path\":\"/uploads/2024/08/07/时间线规则.xmind\",\"mimetype\":\"application/octet-stream\",\"size\":47082,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/时间线规则.xmind\"},{\"id\":165,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"新建 PPT 演示文稿.ppt\",\"hash\":\"310b06ff0a793076844f8be83a752745b3915cd23e35427b88047b801be76424\",\"path\":\"/uploads/2024/08/07/新建 PPT 演示文稿.ppt\",\"mimetype\":\"application/vnd.ms-powerpoint\",\"size\":20992,\"uploadCount\":7,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/新建 PPT 演示文稿.ppt\"}],\"remark\":\"同一文件被多次上传时，只会保存一份至磁盘和增加一条附件记录；删除附件记录，将自动删除对应文件！\"}}',
    200,
    84,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    643,
    '2024-08-28 21:45:51.785977',
    '2024-08-28 21:45:51.785977',
    4,
    'admin',
    '附件管理',
    '::1',
    '',
    '/files/list?page=1&size=10',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"page\":1,\"size\":10,\"total\":15,\"records\":[{\"id\":151,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"oceans.mp4\",\"hash\":\"9f8f979374969429263495ffcaac832cd603b1efe4c66a05fafd6729dffef9af\",\"path\":\"/uploads/2024/08/07/oceans.mp4\",\"mimetype\":\"video/mp4\",\"size\":23014356,\"uploadCount\":15,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/oceans.mp4\"},{\"id\":152,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"财务记账系统excel表格.xlsx\",\"hash\":\"b55ab38ff825b0360bea155510d9fee9c41812fabfe7e9fdb0aa36714195e266\",\"path\":\"/uploads/2024/08/07/财务记账系统excel表格.xlsx\",\"mimetype\":\"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet\",\"size\":97475,\"uploadCount\":4,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/财务记账系统excel表格.xlsx\"},{\"id\":153,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"测试Markdown.md\",\"hash\":\"9bab5812e9c7319230796121a872f2f10d47878d985c83fe88abd9e0119f73b0\",\"path\":\"/uploads/2024/08/07/测试Markdown.md\",\"mimetype\":\"application/octet-stream\",\"size\":11364,\"uploadCount\":2,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/测试Markdown.md\"},{\"id\":154,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"image.jpeg\",\"hash\":\"a737ff09ec2ce204c6a1e0edfe5af0b0c3a81c07af5d31f900b1ff55b39a2201\",\"path\":\"/uploads/2024/08/07/image.jpeg\",\"mimetype\":\"image/jpeg\",\"size\":106111,\"uploadCount\":11,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/image.jpeg\"},{\"id\":155,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"changtu1.jpg\",\"hash\":\"0d83b5b689384e4e08721f873a1c981cdcddd3de0f7493b23c21cc28efa4efee\",\"path\":\"/uploads/2024/08/07/changtu1.jpg\",\"mimetype\":\"image/jpeg\",\"size\":48593,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/changtu1.jpg\"},{\"id\":156,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.doc\",\"hash\":\"b7dcfae78826ae565dfdd434145d3b74aca506738c0c31952370dd6b610b549d\",\"path\":\"/uploads/2024/08/07/目录文件.doc\",\"mimetype\":\"application/msword\",\"size\":1055816,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.doc\"},{\"id\":157,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.htm\",\"hash\":\"c8cc7106cc4a16fedf0bafe622e8ede5905ff4f9b3064f03ecab7980dcb72671\",\"path\":\"/uploads/2024/08/07/目录文件.htm\",\"mimetype\":\"text/html\",\"size\":349870,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.htm\"},{\"id\":158,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.txt\",\"hash\":\"4fb5c4132a38bf42068b9cd58fa8419e792e786a4a4160faf8fabf33d623371f\",\"path\":\"/uploads/2024/08/07/目录文件.txt\",\"mimetype\":\"text/plain\",\"size\":413766,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.txt\"},{\"id\":159,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"时间线规则.xmind\",\"hash\":\"9e21393ff90f96b9570e6dc5d8f1b4ca148d520f738fea61d0e8633d86865cac\",\"path\":\"/uploads/2024/08/07/时间线规则.xmind\",\"mimetype\":\"application/octet-stream\",\"size\":47082,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/时间线规则.xmind\"},{\"id\":165,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"新建 PPT 演示文稿.ppt\",\"hash\":\"310b06ff0a793076844f8be83a752745b3915cd23e35427b88047b801be76424\",\"path\":\"/uploads/2024/08/07/新建 PPT 演示文稿.ppt\",\"mimetype\":\"application/vnd.ms-powerpoint\",\"size\":20992,\"uploadCount\":7,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/新建 PPT 演示文稿.ppt\"}],\"remark\":\"同一文件被多次上传时，只会保存一份至磁盘和增加一条附件记录；删除附件记录，将自动删除对应文件！\"}}',
    200,
    81,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    644,
    '2024-08-28 21:45:56.481627',
    '2024-08-28 21:45:56.481627',
    4,
    'admin',
    '附件管理',
    '::1',
    '',
    '/files/list?page=1&size=10',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"page\":1,\"size\":10,\"total\":15,\"records\":[{\"id\":151,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"oceans.mp4\",\"hash\":\"9f8f979374969429263495ffcaac832cd603b1efe4c66a05fafd6729dffef9af\",\"path\":\"/uploads/2024/08/07/oceans.mp4\",\"mimetype\":\"video/mp4\",\"size\":23014356,\"uploadCount\":15,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/oceans.mp4\"},{\"id\":152,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"财务记账系统excel表格.xlsx\",\"hash\":\"b55ab38ff825b0360bea155510d9fee9c41812fabfe7e9fdb0aa36714195e266\",\"path\":\"/uploads/2024/08/07/财务记账系统excel表格.xlsx\",\"mimetype\":\"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet\",\"size\":97475,\"uploadCount\":4,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/财务记账系统excel表格.xlsx\"},{\"id\":153,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"测试Markdown.md\",\"hash\":\"9bab5812e9c7319230796121a872f2f10d47878d985c83fe88abd9e0119f73b0\",\"path\":\"/uploads/2024/08/07/测试Markdown.md\",\"mimetype\":\"application/octet-stream\",\"size\":11364,\"uploadCount\":2,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/测试Markdown.md\"},{\"id\":154,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"image.jpeg\",\"hash\":\"a737ff09ec2ce204c6a1e0edfe5af0b0c3a81c07af5d31f900b1ff55b39a2201\",\"path\":\"/uploads/2024/08/07/image.jpeg\",\"mimetype\":\"image/jpeg\",\"size\":106111,\"uploadCount\":11,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/image.jpeg\"},{\"id\":155,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"changtu1.jpg\",\"hash\":\"0d83b5b689384e4e08721f873a1c981cdcddd3de0f7493b23c21cc28efa4efee\",\"path\":\"/uploads/2024/08/07/changtu1.jpg\",\"mimetype\":\"image/jpeg\",\"size\":48593,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/changtu1.jpg\"},{\"id\":156,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.doc\",\"hash\":\"b7dcfae78826ae565dfdd434145d3b74aca506738c0c31952370dd6b610b549d\",\"path\":\"/uploads/2024/08/07/目录文件.doc\",\"mimetype\":\"application/msword\",\"size\":1055816,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.doc\"},{\"id\":157,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.htm\",\"hash\":\"c8cc7106cc4a16fedf0bafe622e8ede5905ff4f9b3064f03ecab7980dcb72671\",\"path\":\"/uploads/2024/08/07/目录文件.htm\",\"mimetype\":\"text/html\",\"size\":349870,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.htm\"},{\"id\":158,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.txt\",\"hash\":\"4fb5c4132a38bf42068b9cd58fa8419e792e786a4a4160faf8fabf33d623371f\",\"path\":\"/uploads/2024/08/07/目录文件.txt\",\"mimetype\":\"text/plain\",\"size\":413766,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.txt\"},{\"id\":159,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"时间线规则.xmind\",\"hash\":\"9e21393ff90f96b9570e6dc5d8f1b4ca148d520f738fea61d0e8633d86865cac\",\"path\":\"/uploads/2024/08/07/时间线规则.xmind\",\"mimetype\":\"application/octet-stream\",\"size\":47082,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/时间线规则.xmind\"},{\"id\":165,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"新建 PPT 演示文稿.ppt\",\"hash\":\"310b06ff0a793076844f8be83a752745b3915cd23e35427b88047b801be76424\",\"path\":\"/uploads/2024/08/07/新建 PPT 演示文稿.ppt\",\"mimetype\":\"application/vnd.ms-powerpoint\",\"size\":20992,\"uploadCount\":7,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/新建 PPT 演示文稿.ppt\"}],\"remark\":\"同一文件被多次上传时，只会保存一份至磁盘和增加一条附件记录；删除附件记录，将自动删除对应文件！\"}}',
    200,
    80,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    645,
    '2024-08-28 21:46:06.891201',
    '2024-08-28 21:46:06.891201',
    4,
    'admin',
    '附件管理',
    '::1',
    '',
    '/files/list?page=1&size=10',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"page\":1,\"size\":10,\"total\":15,\"records\":[{\"id\":151,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"oceans.mp4\",\"hash\":\"9f8f979374969429263495ffcaac832cd603b1efe4c66a05fafd6729dffef9af\",\"path\":\"/uploads/2024/08/07/oceans.mp4\",\"mimetype\":\"video/mp4\",\"size\":23014356,\"uploadCount\":15,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/oceans.mp4\"},{\"id\":152,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"财务记账系统excel表格.xlsx\",\"hash\":\"b55ab38ff825b0360bea155510d9fee9c41812fabfe7e9fdb0aa36714195e266\",\"path\":\"/uploads/2024/08/07/财务记账系统excel表格.xlsx\",\"mimetype\":\"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet\",\"size\":97475,\"uploadCount\":4,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/财务记账系统excel表格.xlsx\"},{\"id\":153,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"测试Markdown.md\",\"hash\":\"9bab5812e9c7319230796121a872f2f10d47878d985c83fe88abd9e0119f73b0\",\"path\":\"/uploads/2024/08/07/测试Markdown.md\",\"mimetype\":\"application/octet-stream\",\"size\":11364,\"uploadCount\":2,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/测试Markdown.md\"},{\"id\":154,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"image.jpeg\",\"hash\":\"a737ff09ec2ce204c6a1e0edfe5af0b0c3a81c07af5d31f900b1ff55b39a2201\",\"path\":\"/uploads/2024/08/07/image.jpeg\",\"mimetype\":\"image/jpeg\",\"size\":106111,\"uploadCount\":11,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/image.jpeg\"},{\"id\":155,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"changtu1.jpg\",\"hash\":\"0d83b5b689384e4e08721f873a1c981cdcddd3de0f7493b23c21cc28efa4efee\",\"path\":\"/uploads/2024/08/07/changtu1.jpg\",\"mimetype\":\"image/jpeg\",\"size\":48593,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/changtu1.jpg\"},{\"id\":156,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.doc\",\"hash\":\"b7dcfae78826ae565dfdd434145d3b74aca506738c0c31952370dd6b610b549d\",\"path\":\"/uploads/2024/08/07/目录文件.doc\",\"mimetype\":\"application/msword\",\"size\":1055816,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.doc\"},{\"id\":157,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.htm\",\"hash\":\"c8cc7106cc4a16fedf0bafe622e8ede5905ff4f9b3064f03ecab7980dcb72671\",\"path\":\"/uploads/2024/08/07/目录文件.htm\",\"mimetype\":\"text/html\",\"size\":349870,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.htm\"},{\"id\":158,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.txt\",\"hash\":\"4fb5c4132a38bf42068b9cd58fa8419e792e786a4a4160faf8fabf33d623371f\",\"path\":\"/uploads/2024/08/07/目录文件.txt\",\"mimetype\":\"text/plain\",\"size\":413766,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.txt\"},{\"id\":159,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"时间线规则.xmind\",\"hash\":\"9e21393ff90f96b9570e6dc5d8f1b4ca148d520f738fea61d0e8633d86865cac\",\"path\":\"/uploads/2024/08/07/时间线规则.xmind\",\"mimetype\":\"application/octet-stream\",\"size\":47082,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/时间线规则.xmind\"},{\"id\":165,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"新建 PPT 演示文稿.ppt\",\"hash\":\"310b06ff0a793076844f8be83a752745b3915cd23e35427b88047b801be76424\",\"path\":\"/uploads/2024/08/07/新建 PPT 演示文稿.ppt\",\"mimetype\":\"application/vnd.ms-powerpoint\",\"size\":20992,\"uploadCount\":7,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/新建 PPT 演示文稿.ppt\"}],\"remark\":\"同一文件被多次上传时，只会保存一份至磁盘和增加一条附件记录；删除附件记录，将自动删除对应文件！\"}}',
    200,
    80,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    646,
    '2024-08-28 21:47:43.253303',
    '2024-08-28 21:47:43.253303',
    4,
    'admin',
    '角色组管理',
    '::1',
    '',
    '/admin/role',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":1,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"超级管理员\",\"slug\":\"super_admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":0,\"children\":[{\"id\":9,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通管理员\",\"slug\":\"admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":1,\"children\":[{\"id\":10,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"超级会员\",\"slug\":\"super_member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":9,\"children\":[{\"id\":11,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通会员\",\"slug\":\"member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":10,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通用户\",\"slug\":\"user\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":11,\"children\":null}]}]}]}]}],\"remark\":null}}',
    200,
    1012,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    647,
    '2024-08-28 21:47:46.224499',
    '2024-08-28 21:47:46.224499',
    4,
    'admin',
    '管理员管理-详情',
    '::1',
    '',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    801,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    648,
    '2024-08-28 21:47:56.313511',
    '2024-08-28 21:47:56.313511',
    4,
    'admin',
    '角色组管理',
    '::1',
    '',
    '/admin/role',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":1,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"超级管理员\",\"slug\":\"super_admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":0,\"children\":[{\"id\":9,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通管理员\",\"slug\":\"admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":1,\"children\":[{\"id\":10,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"超级会员\",\"slug\":\"super_member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":9,\"children\":[{\"id\":11,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通会员\",\"slug\":\"member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":10,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通用户\",\"slug\":\"user\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":11,\"children\":null}]}]}]}]}],\"remark\":null}}',
    200,
    10631,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    649,
    '2024-08-28 21:48:15.910409',
    '2024-08-28 21:48:15.910409',
    4,
    'admin',
    '角色组管理',
    '::1',
    '',
    '/admin/role',
    'GET',
    '{}',
    '{\"query\":\"SELECT `treeEntity`.`id` AS `treeEntity_id`, `treeEntity`.`update_time` AS `treeEntity_update_time`, `treeEntity`.`create_time` AS `treeEntity_create_time`, `treeEntity`.`name` AS `treeEntity_name`, `treeEntity`.`slug` AS `treeEntity_slug`, `treeEntity`.`description` AS `treeEntity_description`, `treeEntity`.`sort` AS `treeEntity_sort`, `treeEntity`.`status` AS `treeEntity_status`, `treeEntity`.`parent_id` AS `treeEntity_parent_id` FROM `admin_roles` `treeEntity` WHERE `treeEntity`.`parent_id` IS NULL\",\"parameters\":[],\"driverError\":{\"errno\":-4077,\"code\":\"ECONNRESET\",\"syscall\":\"read\",\"fatal\":true},\"errno\":-4077,\"code\":\"ECONNRESET\",\"syscall\":\"read\",\"fatal\":true}',
    200,
    19190,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    650,
    '2024-08-28 21:58:16.260843',
    '2024-08-28 21:58:16.260843',
    4,
    'admin',
    'refresh刷新token',
    '::1',
    '',
    '/admin/refresh?refreshToken=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJpYXQiOjE3MjQ4NTE0OTAsImV4cCI6MTcyNTQ1NjI5MH0.UKNg2G4I8oTpUH8Fzttp88pTRH5NUM4i-cB75G8CjGU',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"accessToken\":\"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJyb2xlcyI6WyLotoXnuqfnrqHnkIblkZgiXSwicGVybWlzc2lvbnMiOlsidXNlcl9ncm91cCIsImF1dGgiLCJhdXRoX2dyb3VwIiwiYXV0aF9sb2ciLCJ1c2VyIiwiYXV0aF9tZW51IiwiYXV0aF9hZG1pbiIsInVzZXJfaW5kZXgiLCJ1c2VyX3J1bGUiLCJ1c2VyX2xvZyIsInJvdXRpbmUiLCJyb3V0aW5lX2NvbmZpZyIsInJvdXRpbmVfYW5uZXgiLCJyb3V0aW5lX2luZm8iLCJtb2R1bGUiLCJhdXRoX2dyb3VwX2NyZWF0ZSIsImF1dGhfZ3JvdXBfdXBkYXRlIiwiYXV0aF9ncm91cF9pbmZvIiwiYXV0aF9ncm91cF9kZWxldGUiLCJhdXRoX2FkbWluX2NyZWF0ZSIsImF1dGhfYWRtaW5fdXBkYXRlIiwiYXV0aF9hZG1pbl9pbmZvIiwiYXV0aF9hZG1pbl9kZWxldGUiLCJob21lIl0sImFjY2Vzc1Rva2VuIjp0cnVlLCJpYXQiOjE3MjQ4NTM0OTUsImV4cCI6MTcyNDg1NTI5NX0.pzPIWKI5_TblDkeWrYbxBolm4WxMaLCHYh_4-xrDGfs\",\"refreshToken\":\"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJpYXQiOjE3MjQ4NTM0OTUsImV4cCI6MTcyNTQ1ODI5NX0.4AVe_9S4bUVLuGNQJqxnurFI_-FW4_Hyt8ONZd9FrBY\"}}',
    200,
    275,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    651,
    '2024-08-28 21:58:16.429055',
    '2024-08-28 21:58:16.429055',
    4,
    'admin',
    '附件管理',
    '::1',
    '',
    '/files/list?page=1&size=10',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"page\":1,\"size\":10,\"total\":15,\"records\":[{\"id\":151,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"oceans.mp4\",\"hash\":\"9f8f979374969429263495ffcaac832cd603b1efe4c66a05fafd6729dffef9af\",\"path\":\"/uploads/2024/08/07/oceans.mp4\",\"mimetype\":\"video/mp4\",\"size\":23014356,\"uploadCount\":15,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/oceans.mp4\"},{\"id\":152,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"财务记账系统excel表格.xlsx\",\"hash\":\"b55ab38ff825b0360bea155510d9fee9c41812fabfe7e9fdb0aa36714195e266\",\"path\":\"/uploads/2024/08/07/财务记账系统excel表格.xlsx\",\"mimetype\":\"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet\",\"size\":97475,\"uploadCount\":4,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/财务记账系统excel表格.xlsx\"},{\"id\":153,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"测试Markdown.md\",\"hash\":\"9bab5812e9c7319230796121a872f2f10d47878d985c83fe88abd9e0119f73b0\",\"path\":\"/uploads/2024/08/07/测试Markdown.md\",\"mimetype\":\"application/octet-stream\",\"size\":11364,\"uploadCount\":2,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/测试Markdown.md\"},{\"id\":154,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"image.jpeg\",\"hash\":\"a737ff09ec2ce204c6a1e0edfe5af0b0c3a81c07af5d31f900b1ff55b39a2201\",\"path\":\"/uploads/2024/08/07/image.jpeg\",\"mimetype\":\"image/jpeg\",\"size\":106111,\"uploadCount\":11,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/image.jpeg\"},{\"id\":155,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"changtu1.jpg\",\"hash\":\"0d83b5b689384e4e08721f873a1c981cdcddd3de0f7493b23c21cc28efa4efee\",\"path\":\"/uploads/2024/08/07/changtu1.jpg\",\"mimetype\":\"image/jpeg\",\"size\":48593,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/changtu1.jpg\"},{\"id\":156,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.doc\",\"hash\":\"b7dcfae78826ae565dfdd434145d3b74aca506738c0c31952370dd6b610b549d\",\"path\":\"/uploads/2024/08/07/目录文件.doc\",\"mimetype\":\"application/msword\",\"size\":1055816,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.doc\"},{\"id\":157,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.htm\",\"hash\":\"c8cc7106cc4a16fedf0bafe622e8ede5905ff4f9b3064f03ecab7980dcb72671\",\"path\":\"/uploads/2024/08/07/目录文件.htm\",\"mimetype\":\"text/html\",\"size\":349870,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.htm\"},{\"id\":158,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.txt\",\"hash\":\"4fb5c4132a38bf42068b9cd58fa8419e792e786a4a4160faf8fabf33d623371f\",\"path\":\"/uploads/2024/08/07/目录文件.txt\",\"mimetype\":\"text/plain\",\"size\":413766,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.txt\"},{\"id\":159,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"时间线规则.xmind\",\"hash\":\"9e21393ff90f96b9570e6dc5d8f1b4ca148d520f738fea61d0e8633d86865cac\",\"path\":\"/uploads/2024/08/07/时间线规则.xmind\",\"mimetype\":\"application/octet-stream\",\"size\":47082,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/时间线规则.xmind\"},{\"id\":165,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"新建 PPT 演示文稿.ppt\",\"hash\":\"310b06ff0a793076844f8be83a752745b3915cd23e35427b88047b801be76424\",\"path\":\"/uploads/2024/08/07/新建 PPT 演示文稿.ppt\",\"mimetype\":\"application/vnd.ms-powerpoint\",\"size\":20992,\"uploadCount\":7,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/新建 PPT 演示文稿.ppt\"}],\"remark\":\"同一文件被多次上传时，只会保存一份至磁盘和增加一条附件记录；删除附件记录，将自动删除对应文件！\"}}',
    200,
    165,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    652,
    '2024-08-28 21:58:18.771080',
    '2024-08-28 21:58:18.771080',
    4,
    'admin',
    '附件管理',
    '::1',
    '',
    '/files/list?page=1&size=10',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"page\":1,\"size\":10,\"total\":15,\"records\":[{\"id\":151,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"oceans.mp4\",\"hash\":\"9f8f979374969429263495ffcaac832cd603b1efe4c66a05fafd6729dffef9af\",\"path\":\"/uploads/2024/08/07/oceans.mp4\",\"mimetype\":\"video/mp4\",\"size\":23014356,\"uploadCount\":15,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/oceans.mp4\"},{\"id\":152,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"财务记账系统excel表格.xlsx\",\"hash\":\"b55ab38ff825b0360bea155510d9fee9c41812fabfe7e9fdb0aa36714195e266\",\"path\":\"/uploads/2024/08/07/财务记账系统excel表格.xlsx\",\"mimetype\":\"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet\",\"size\":97475,\"uploadCount\":4,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/财务记账系统excel表格.xlsx\"},{\"id\":153,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"测试Markdown.md\",\"hash\":\"9bab5812e9c7319230796121a872f2f10d47878d985c83fe88abd9e0119f73b0\",\"path\":\"/uploads/2024/08/07/测试Markdown.md\",\"mimetype\":\"application/octet-stream\",\"size\":11364,\"uploadCount\":2,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/测试Markdown.md\"},{\"id\":154,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"image.jpeg\",\"hash\":\"a737ff09ec2ce204c6a1e0edfe5af0b0c3a81c07af5d31f900b1ff55b39a2201\",\"path\":\"/uploads/2024/08/07/image.jpeg\",\"mimetype\":\"image/jpeg\",\"size\":106111,\"uploadCount\":11,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/image.jpeg\"},{\"id\":155,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"changtu1.jpg\",\"hash\":\"0d83b5b689384e4e08721f873a1c981cdcddd3de0f7493b23c21cc28efa4efee\",\"path\":\"/uploads/2024/08/07/changtu1.jpg\",\"mimetype\":\"image/jpeg\",\"size\":48593,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/changtu1.jpg\"},{\"id\":156,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.doc\",\"hash\":\"b7dcfae78826ae565dfdd434145d3b74aca506738c0c31952370dd6b610b549d\",\"path\":\"/uploads/2024/08/07/目录文件.doc\",\"mimetype\":\"application/msword\",\"size\":1055816,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.doc\"},{\"id\":157,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.htm\",\"hash\":\"c8cc7106cc4a16fedf0bafe622e8ede5905ff4f9b3064f03ecab7980dcb72671\",\"path\":\"/uploads/2024/08/07/目录文件.htm\",\"mimetype\":\"text/html\",\"size\":349870,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.htm\"},{\"id\":158,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.txt\",\"hash\":\"4fb5c4132a38bf42068b9cd58fa8419e792e786a4a4160faf8fabf33d623371f\",\"path\":\"/uploads/2024/08/07/目录文件.txt\",\"mimetype\":\"text/plain\",\"size\":413766,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.txt\"},{\"id\":159,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"时间线规则.xmind\",\"hash\":\"9e21393ff90f96b9570e6dc5d8f1b4ca148d520f738fea61d0e8633d86865cac\",\"path\":\"/uploads/2024/08/07/时间线规则.xmind\",\"mimetype\":\"application/octet-stream\",\"size\":47082,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/时间线规则.xmind\"},{\"id\":165,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"新建 PPT 演示文稿.ppt\",\"hash\":\"310b06ff0a793076844f8be83a752745b3915cd23e35427b88047b801be76424\",\"path\":\"/uploads/2024/08/07/新建 PPT 演示文稿.ppt\",\"mimetype\":\"application/vnd.ms-powerpoint\",\"size\":20992,\"uploadCount\":7,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/新建 PPT 演示文稿.ppt\"}],\"remark\":\"同一文件被多次上传时，只会保存一份至磁盘和增加一条附件记录；删除附件记录，将自动删除对应文件！\"}}',
    200,
    82,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    653,
    '2024-08-28 21:58:20.807083',
    '2024-08-28 21:58:20.807083',
    4,
    'admin',
    '附件管理',
    '::1',
    '',
    '/files/list?page=1&size=10',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"page\":1,\"size\":10,\"total\":15,\"records\":[{\"id\":151,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"oceans.mp4\",\"hash\":\"9f8f979374969429263495ffcaac832cd603b1efe4c66a05fafd6729dffef9af\",\"path\":\"/uploads/2024/08/07/oceans.mp4\",\"mimetype\":\"video/mp4\",\"size\":23014356,\"uploadCount\":15,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/oceans.mp4\"},{\"id\":152,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"财务记账系统excel表格.xlsx\",\"hash\":\"b55ab38ff825b0360bea155510d9fee9c41812fabfe7e9fdb0aa36714195e266\",\"path\":\"/uploads/2024/08/07/财务记账系统excel表格.xlsx\",\"mimetype\":\"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet\",\"size\":97475,\"uploadCount\":4,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/财务记账系统excel表格.xlsx\"},{\"id\":153,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"测试Markdown.md\",\"hash\":\"9bab5812e9c7319230796121a872f2f10d47878d985c83fe88abd9e0119f73b0\",\"path\":\"/uploads/2024/08/07/测试Markdown.md\",\"mimetype\":\"application/octet-stream\",\"size\":11364,\"uploadCount\":2,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/测试Markdown.md\"},{\"id\":154,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"image.jpeg\",\"hash\":\"a737ff09ec2ce204c6a1e0edfe5af0b0c3a81c07af5d31f900b1ff55b39a2201\",\"path\":\"/uploads/2024/08/07/image.jpeg\",\"mimetype\":\"image/jpeg\",\"size\":106111,\"uploadCount\":11,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/image.jpeg\"},{\"id\":155,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"changtu1.jpg\",\"hash\":\"0d83b5b689384e4e08721f873a1c981cdcddd3de0f7493b23c21cc28efa4efee\",\"path\":\"/uploads/2024/08/07/changtu1.jpg\",\"mimetype\":\"image/jpeg\",\"size\":48593,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/changtu1.jpg\"},{\"id\":156,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.doc\",\"hash\":\"b7dcfae78826ae565dfdd434145d3b74aca506738c0c31952370dd6b610b549d\",\"path\":\"/uploads/2024/08/07/目录文件.doc\",\"mimetype\":\"application/msword\",\"size\":1055816,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.doc\"},{\"id\":157,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.htm\",\"hash\":\"c8cc7106cc4a16fedf0bafe622e8ede5905ff4f9b3064f03ecab7980dcb72671\",\"path\":\"/uploads/2024/08/07/目录文件.htm\",\"mimetype\":\"text/html\",\"size\":349870,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.htm\"},{\"id\":158,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.txt\",\"hash\":\"4fb5c4132a38bf42068b9cd58fa8419e792e786a4a4160faf8fabf33d623371f\",\"path\":\"/uploads/2024/08/07/目录文件.txt\",\"mimetype\":\"text/plain\",\"size\":413766,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.txt\"},{\"id\":159,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"时间线规则.xmind\",\"hash\":\"9e21393ff90f96b9570e6dc5d8f1b4ca148d520f738fea61d0e8633d86865cac\",\"path\":\"/uploads/2024/08/07/时间线规则.xmind\",\"mimetype\":\"application/octet-stream\",\"size\":47082,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/时间线规则.xmind\"},{\"id\":165,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"新建 PPT 演示文稿.ppt\",\"hash\":\"310b06ff0a793076844f8be83a752745b3915cd23e35427b88047b801be76424\",\"path\":\"/uploads/2024/08/07/新建 PPT 演示文稿.ppt\",\"mimetype\":\"application/vnd.ms-powerpoint\",\"size\":20992,\"uploadCount\":7,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/新建 PPT 演示文稿.ppt\"}],\"remark\":\"同一文件被多次上传时，只会保存一份至磁盘和增加一条附件记录；删除附件记录，将自动删除对应文件！\"}}',
    200,
    66,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    654,
    '2024-08-28 21:58:25.329204',
    '2024-08-28 21:58:25.329204',
    4,
    'admin',
    '角色组管理',
    '::1',
    '',
    '/admin/role',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":1,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"超级管理员\",\"slug\":\"super_admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":0,\"children\":[{\"id\":9,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通管理员\",\"slug\":\"admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":1,\"children\":[{\"id\":10,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"超级会员\",\"slug\":\"super_member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":9,\"children\":[{\"id\":11,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通会员\",\"slug\":\"member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":10,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通用户\",\"slug\":\"user\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":11,\"children\":null}]}]}]}]}],\"remark\":null}}',
    200,
    63,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    655,
    '2024-08-28 21:58:27.980342',
    '2024-08-28 21:58:27.980342',
    4,
    'admin',
    '角色组管理',
    '::1',
    '',
    '/admin/role',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":1,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"超级管理员\",\"slug\":\"super_admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":0,\"children\":[{\"id\":9,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通管理员\",\"slug\":\"admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":1,\"children\":[{\"id\":10,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"超级会员\",\"slug\":\"super_member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":9,\"children\":[{\"id\":11,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通会员\",\"slug\":\"member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":10,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通用户\",\"slug\":\"user\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":11,\"children\":null}]}]}]}]}],\"remark\":null}}',
    200,
    65,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    656,
    '2024-08-28 21:58:29.352502',
    '2024-08-28 21:58:29.352502',
    4,
    'admin',
    '菜单规则管理',
    '::1',
    '',
    '/admin/permission',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":24,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"首页\",\"icon\":null,\"name\":\"home\",\"component\":null,\"parentId\":null,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":2,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"权限管理\",\"icon\":\"LineOutlined\",\"name\":\"auth\",\"component\":null,\"parentId\":null,\"sort\":98,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":3,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"角色组管理\",\"icon\":\"AimOutlined\",\"name\":\"auth_group\",\"component\":null,\"parentId\":2,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":16,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_group_create\",\"component\":null,\"parentId\":3,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":17,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_group_update\",\"component\":null,\"parentId\":3,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":18,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_group_info\",\"component\":null,\"parentId\":3,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":19,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_group_delete\",\"component\":null,\"parentId\":3,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":7,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"管理员管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_admin\",\"component\":null,\"parentId\":2,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":20,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_admin_create\",\"component\":null,\"parentId\":7,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":21,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_admin_update\",\"component\":null,\"parentId\":7,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":22,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_admin_info\",\"component\":null,\"parentId\":7,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":23,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_admin_delete\",\"component\":null,\"parentId\":7,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":6,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"菜单规则管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_menu\",\"component\":null,\"parentId\":2,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":4,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"管理员日志管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"auth_log\",\"component\":null,\"parentId\":2,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":5,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"user\",\"component\":null,\"parentId\":null,\"sort\":97,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":8,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员管理\",\"icon\":\"LineOutlined\",\"name\":\"user_index\",\"component\":null,\"parentId\":5,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":1,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员分组管理\",\"icon\":null,\"name\":\"user_group\",\"component\":null,\"parentId\":5,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":9,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员规则管理\",\"icon\":\"AimOutlined\",\"name\":\"user_rule\",\"component\":null,\"parentId\":5,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":10,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员日志管理\",\"icon\":\"LineOutlined\",\"name\":\"user_log\",\"component\":null,\"parentId\":5,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":11,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"常规管理\",\"icon\":\"LineOutlined\",\"name\":\"routine\",\"component\":null,\"parentId\":null,\"sort\":96,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"系统配置\",\"icon\":\"LineOutlined\",\"name\":\"routine_config\",\"component\":\"/Routine/Config\",\"parentId\":11,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":14,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"个人资料\",\"icon\":\"LineOutlined\",\"name\":\"routine_info\",\"component\":\"/Routine/Info\",\"parentId\":11,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":13,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"附件管理\",\"icon\":null,\"name\":\"routine_annex\",\"component\":\"/Routine/Annex\",\"parentId\":11,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":15,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"模块市场\",\"icon\":null,\"name\":\"module\",\"component\":\"/Module\",\"parentId\":null,\"sort\":95,\"type\":2,\"code\":null,\"cache\":0,\"status\":0}],\"remark\":null}}',
    200,
    38,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    657,
    '2024-08-28 21:58:51.204985',
    '2024-08-28 21:58:51.204985',
    4,
    'admin',
    '菜单规则管理',
    '::1',
    '',
    '/admin/permission',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":24,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"首页\",\"icon\":null,\"name\":\"home\",\"component\":null,\"parentId\":null,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":2,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"权限管理\",\"icon\":\"LineOutlined\",\"name\":\"auth\",\"component\":null,\"parentId\":null,\"sort\":98,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":3,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"角色组管理\",\"icon\":\"AimOutlined\",\"name\":\"auth_group\",\"component\":null,\"parentId\":2,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":16,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_group_create\",\"component\":null,\"parentId\":3,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":17,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_group_update\",\"component\":null,\"parentId\":3,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":18,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_group_info\",\"component\":null,\"parentId\":3,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":19,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_group_delete\",\"component\":null,\"parentId\":3,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":7,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"管理员管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_admin\",\"component\":null,\"parentId\":2,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":20,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_admin_create\",\"component\":null,\"parentId\":7,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":21,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_admin_update\",\"component\":null,\"parentId\":7,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":22,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_admin_info\",\"component\":null,\"parentId\":7,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":23,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_admin_delete\",\"component\":null,\"parentId\":7,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":6,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"菜单规则管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_menu\",\"component\":null,\"parentId\":2,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":4,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"管理员日志管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"auth_log\",\"component\":null,\"parentId\":2,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":5,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"user\",\"component\":null,\"parentId\":null,\"sort\":97,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":8,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员管理\",\"icon\":\"LineOutlined\",\"name\":\"user_index\",\"component\":null,\"parentId\":5,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":1,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员分组管理\",\"icon\":null,\"name\":\"user_group\",\"component\":null,\"parentId\":5,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":9,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员规则管理\",\"icon\":\"AimOutlined\",\"name\":\"user_rule\",\"component\":null,\"parentId\":5,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":10,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员日志管理\",\"icon\":\"LineOutlined\",\"name\":\"user_log\",\"component\":null,\"parentId\":5,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":11,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"常规管理\",\"icon\":\"LineOutlined\",\"name\":\"routine\",\"component\":null,\"parentId\":null,\"sort\":96,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"系统配置\",\"icon\":\"LineOutlined\",\"name\":\"routine_config\",\"component\":\"/Routine/Config\",\"parentId\":11,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":14,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"个人资料\",\"icon\":\"LineOutlined\",\"name\":\"routine_info\",\"component\":\"/Routine/Info\",\"parentId\":11,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":13,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"附件管理\",\"icon\":null,\"name\":\"routine_annex\",\"component\":\"/Routine/Annex\",\"parentId\":11,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":15,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"模块市场\",\"icon\":null,\"name\":\"module\",\"component\":\"/Module\",\"parentId\":null,\"sort\":95,\"type\":2,\"code\":null,\"cache\":0,\"status\":0}],\"remark\":null}}',
    200,
    38,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    658,
    '2024-08-28 22:02:12.241183',
    '2024-08-28 22:02:12.241183',
    4,
    'admin',
    '管理员管理-详情',
    '::1',
    '',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    131,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    659,
    '2024-08-28 22:02:12.325119',
    '2024-08-28 22:02:12.325119',
    4,
    'admin',
    '角色组管理',
    '::1',
    '',
    '/admin/role',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":1,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"超级管理员\",\"slug\":\"super_admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":0,\"children\":[{\"id\":9,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通管理员\",\"slug\":\"admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":1,\"children\":[{\"id\":10,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"超级会员\",\"slug\":\"super_member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":9,\"children\":[{\"id\":11,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通会员\",\"slug\":\"member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":10,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通用户\",\"slug\":\"user\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":11,\"children\":null}]}]}]}]}],\"remark\":null}}',
    200,
    214,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    660,
    '2024-08-28 22:02:14.216821',
    '2024-08-28 22:02:14.216821',
    4,
    'admin',
    '菜单规则管理',
    '::1',
    '',
    '/admin/permission',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":24,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"首页\",\"icon\":null,\"name\":\"home\",\"component\":null,\"parentId\":null,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":2,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"权限管理\",\"icon\":\"LineOutlined\",\"name\":\"auth\",\"component\":null,\"parentId\":null,\"sort\":98,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":3,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"角色组管理\",\"icon\":\"AimOutlined\",\"name\":\"auth_group\",\"component\":null,\"parentId\":2,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":16,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_group_create\",\"component\":null,\"parentId\":3,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":17,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_group_update\",\"component\":null,\"parentId\":3,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":18,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_group_info\",\"component\":null,\"parentId\":3,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":19,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_group_delete\",\"component\":null,\"parentId\":3,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":7,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"管理员管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_admin\",\"component\":null,\"parentId\":2,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":20,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_admin_create\",\"component\":null,\"parentId\":7,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":21,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_admin_update\",\"component\":null,\"parentId\":7,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":22,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_admin_info\",\"component\":null,\"parentId\":7,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":23,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_admin_delete\",\"component\":null,\"parentId\":7,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":6,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"菜单规则管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_menu\",\"component\":null,\"parentId\":2,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":4,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"管理员日志管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"auth_log\",\"component\":null,\"parentId\":2,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":5,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"user\",\"component\":null,\"parentId\":null,\"sort\":97,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":8,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员管理\",\"icon\":\"LineOutlined\",\"name\":\"user_index\",\"component\":null,\"parentId\":5,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":1,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员分组管理\",\"icon\":null,\"name\":\"user_group\",\"component\":null,\"parentId\":5,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":9,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员规则管理\",\"icon\":\"AimOutlined\",\"name\":\"user_rule\",\"component\":null,\"parentId\":5,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":10,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员日志管理\",\"icon\":\"LineOutlined\",\"name\":\"user_log\",\"component\":null,\"parentId\":5,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":11,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"常规管理\",\"icon\":\"LineOutlined\",\"name\":\"routine\",\"component\":null,\"parentId\":null,\"sort\":96,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"系统配置\",\"icon\":\"LineOutlined\",\"name\":\"routine_config\",\"component\":\"/Routine/Config\",\"parentId\":11,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":14,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"个人资料\",\"icon\":\"LineOutlined\",\"name\":\"routine_info\",\"component\":\"/Routine/Info\",\"parentId\":11,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":13,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"附件管理\",\"icon\":null,\"name\":\"routine_annex\",\"component\":\"/Routine/Annex\",\"parentId\":11,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":15,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"模块市场\",\"icon\":null,\"name\":\"module\",\"component\":\"/Module\",\"parentId\":null,\"sort\":95,\"type\":2,\"code\":null,\"cache\":0,\"status\":0}],\"remark\":null}}',
    200,
    49,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    661,
    '2024-08-28 22:02:25.257949',
    '2024-08-28 22:02:25.257949',
    4,
    'admin',
    '管理员管理-详情',
    '::1',
    '',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    87,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    662,
    '2024-08-28 22:02:30.986879',
    '2024-08-28 22:02:30.986879',
    4,
    'admin',
    '菜单规则管理',
    '::1',
    '',
    '/admin/permission',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":24,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"首页\",\"icon\":null,\"name\":\"home\",\"component\":null,\"parentId\":null,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":2,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"权限管理\",\"icon\":\"LineOutlined\",\"name\":\"auth\",\"component\":null,\"parentId\":null,\"sort\":98,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":3,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"角色组管理\",\"icon\":\"AimOutlined\",\"name\":\"auth_group\",\"component\":null,\"parentId\":2,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":16,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_group_create\",\"component\":null,\"parentId\":3,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":17,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_group_update\",\"component\":null,\"parentId\":3,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":18,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_group_info\",\"component\":null,\"parentId\":3,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":19,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_group_delete\",\"component\":null,\"parentId\":3,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":7,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"管理员管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_admin\",\"component\":null,\"parentId\":2,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":20,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_admin_create\",\"component\":null,\"parentId\":7,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":21,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_admin_update\",\"component\":null,\"parentId\":7,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":22,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_admin_info\",\"component\":null,\"parentId\":7,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":23,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_admin_delete\",\"component\":null,\"parentId\":7,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":6,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"菜单规则管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_menu\",\"component\":null,\"parentId\":2,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":4,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"管理员日志管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"auth_log\",\"component\":null,\"parentId\":2,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":5,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"user\",\"component\":null,\"parentId\":null,\"sort\":97,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":8,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员管理\",\"icon\":\"LineOutlined\",\"name\":\"user_index\",\"component\":null,\"parentId\":5,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":1,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员分组管理\",\"icon\":null,\"name\":\"user_group\",\"component\":null,\"parentId\":5,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":9,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员规则管理\",\"icon\":\"AimOutlined\",\"name\":\"user_rule\",\"component\":null,\"parentId\":5,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":10,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员日志管理\",\"icon\":\"LineOutlined\",\"name\":\"user_log\",\"component\":null,\"parentId\":5,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":11,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"常规管理\",\"icon\":\"LineOutlined\",\"name\":\"routine\",\"component\":null,\"parentId\":null,\"sort\":96,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"系统配置\",\"icon\":\"LineOutlined\",\"name\":\"routine_config\",\"component\":\"/Routine/Config\",\"parentId\":11,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":14,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"个人资料\",\"icon\":\"LineOutlined\",\"name\":\"routine_info\",\"component\":\"/Routine/Info\",\"parentId\":11,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":13,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"附件管理\",\"icon\":null,\"name\":\"routine_annex\",\"component\":\"/Routine/Annex\",\"parentId\":11,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":15,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"模块市场\",\"icon\":null,\"name\":\"module\",\"component\":\"/Module\",\"parentId\":null,\"sort\":95,\"type\":2,\"code\":null,\"cache\":0,\"status\":0}],\"remark\":null}}',
    200,
    46,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    663,
    '2024-08-28 22:02:32.081744',
    '2024-08-28 22:02:32.081744',
    4,
    'admin',
    '菜单规则管理',
    '::1',
    '',
    '/admin/permission',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":24,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"首页\",\"icon\":null,\"name\":\"home\",\"component\":null,\"parentId\":null,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":2,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"权限管理\",\"icon\":\"LineOutlined\",\"name\":\"auth\",\"component\":null,\"parentId\":null,\"sort\":98,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":3,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"角色组管理\",\"icon\":\"AimOutlined\",\"name\":\"auth_group\",\"component\":null,\"parentId\":2,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":16,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_group_create\",\"component\":null,\"parentId\":3,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":17,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_group_update\",\"component\":null,\"parentId\":3,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":18,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_group_info\",\"component\":null,\"parentId\":3,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":19,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_group_delete\",\"component\":null,\"parentId\":3,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":7,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"管理员管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_admin\",\"component\":null,\"parentId\":2,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":20,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_admin_create\",\"component\":null,\"parentId\":7,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":21,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_admin_update\",\"component\":null,\"parentId\":7,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":22,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_admin_info\",\"component\":null,\"parentId\":7,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":23,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_admin_delete\",\"component\":null,\"parentId\":7,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":6,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"菜单规则管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_menu\",\"component\":null,\"parentId\":2,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":4,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"管理员日志管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"auth_log\",\"component\":null,\"parentId\":2,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":5,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"user\",\"component\":null,\"parentId\":null,\"sort\":97,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":8,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员管理\",\"icon\":\"LineOutlined\",\"name\":\"user_index\",\"component\":null,\"parentId\":5,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":1,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员分组管理\",\"icon\":null,\"name\":\"user_group\",\"component\":null,\"parentId\":5,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":9,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员规则管理\",\"icon\":\"AimOutlined\",\"name\":\"user_rule\",\"component\":null,\"parentId\":5,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":10,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员日志管理\",\"icon\":\"LineOutlined\",\"name\":\"user_log\",\"component\":null,\"parentId\":5,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":11,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"常规管理\",\"icon\":\"LineOutlined\",\"name\":\"routine\",\"component\":null,\"parentId\":null,\"sort\":96,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"系统配置\",\"icon\":\"LineOutlined\",\"name\":\"routine_config\",\"component\":\"/Routine/Config\",\"parentId\":11,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":14,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"个人资料\",\"icon\":\"LineOutlined\",\"name\":\"routine_info\",\"component\":\"/Routine/Info\",\"parentId\":11,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":13,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"附件管理\",\"icon\":null,\"name\":\"routine_annex\",\"component\":\"/Routine/Annex\",\"parentId\":11,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":15,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"模块市场\",\"icon\":null,\"name\":\"module\",\"component\":\"/Module\",\"parentId\":null,\"sort\":95,\"type\":2,\"code\":null,\"cache\":0,\"status\":0}],\"remark\":null}}',
    200,
    45,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    664,
    '2024-08-28 22:02:34.439008',
    '2024-08-28 22:02:34.439008',
    4,
    'admin',
    '菜单规则管理',
    '::1',
    '',
    '/admin/permission',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":24,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"首页\",\"icon\":null,\"name\":\"home\",\"component\":null,\"parentId\":null,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":2,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"权限管理\",\"icon\":\"LineOutlined\",\"name\":\"auth\",\"component\":null,\"parentId\":null,\"sort\":98,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":3,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"角色组管理\",\"icon\":\"AimOutlined\",\"name\":\"auth_group\",\"component\":null,\"parentId\":2,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":16,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_group_create\",\"component\":null,\"parentId\":3,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":17,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_group_update\",\"component\":null,\"parentId\":3,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":18,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_group_info\",\"component\":null,\"parentId\":3,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":19,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_group_delete\",\"component\":null,\"parentId\":3,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":7,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"管理员管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_admin\",\"component\":null,\"parentId\":2,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":20,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_admin_create\",\"component\":null,\"parentId\":7,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":21,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_admin_update\",\"component\":null,\"parentId\":7,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":22,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_admin_info\",\"component\":null,\"parentId\":7,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":23,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_admin_delete\",\"component\":null,\"parentId\":7,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":6,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"菜单规则管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_menu\",\"component\":null,\"parentId\":2,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":4,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"管理员日志管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"auth_log\",\"component\":null,\"parentId\":2,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":5,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"user\",\"component\":null,\"parentId\":null,\"sort\":97,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":8,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员管理\",\"icon\":\"LineOutlined\",\"name\":\"user_index\",\"component\":null,\"parentId\":5,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":1,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员分组管理\",\"icon\":null,\"name\":\"user_group\",\"component\":null,\"parentId\":5,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":9,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员规则管理\",\"icon\":\"AimOutlined\",\"name\":\"user_rule\",\"component\":null,\"parentId\":5,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":10,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员日志管理\",\"icon\":\"LineOutlined\",\"name\":\"user_log\",\"component\":null,\"parentId\":5,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":11,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"常规管理\",\"icon\":\"LineOutlined\",\"name\":\"routine\",\"component\":null,\"parentId\":null,\"sort\":96,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"系统配置\",\"icon\":\"LineOutlined\",\"name\":\"routine_config\",\"component\":\"/Routine/Config\",\"parentId\":11,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":14,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"个人资料\",\"icon\":\"LineOutlined\",\"name\":\"routine_info\",\"component\":\"/Routine/Info\",\"parentId\":11,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":13,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"附件管理\",\"icon\":null,\"name\":\"routine_annex\",\"component\":\"/Routine/Annex\",\"parentId\":11,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":15,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"模块市场\",\"icon\":null,\"name\":\"module\",\"component\":\"/Module\",\"parentId\":null,\"sort\":95,\"type\":2,\"code\":null,\"cache\":0,\"status\":0}],\"remark\":null}}',
    200,
    43,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    665,
    '2024-08-28 22:02:53.101621',
    '2024-08-28 22:02:53.101621',
    4,
    'admin',
    '菜单规则管理',
    '::1',
    '',
    '/admin/permission',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":24,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"首页\",\"icon\":null,\"name\":\"home\",\"component\":null,\"parentId\":null,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":2,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"权限管理\",\"icon\":\"LineOutlined\",\"name\":\"auth\",\"component\":null,\"parentId\":null,\"sort\":98,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":3,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"角色组管理\",\"icon\":\"AimOutlined\",\"name\":\"auth_group\",\"component\":null,\"parentId\":2,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":16,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_group_create\",\"component\":null,\"parentId\":3,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":17,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_group_update\",\"component\":null,\"parentId\":3,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":18,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_group_info\",\"component\":null,\"parentId\":3,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":19,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_group_delete\",\"component\":null,\"parentId\":3,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":7,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"管理员管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_admin\",\"component\":null,\"parentId\":2,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":20,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_admin_create\",\"component\":null,\"parentId\":7,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":21,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_admin_update\",\"component\":null,\"parentId\":7,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":22,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_admin_info\",\"component\":null,\"parentId\":7,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":23,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_admin_delete\",\"component\":null,\"parentId\":7,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":6,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"菜单规则管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_menu\",\"component\":null,\"parentId\":2,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":4,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"管理员日志管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"auth_log\",\"component\":null,\"parentId\":2,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":5,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"user\",\"component\":null,\"parentId\":null,\"sort\":97,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":8,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员管理\",\"icon\":\"LineOutlined\",\"name\":\"user_index\",\"component\":null,\"parentId\":5,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":1,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员分组管理\",\"icon\":null,\"name\":\"user_group\",\"component\":null,\"parentId\":5,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":9,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员规则管理\",\"icon\":\"AimOutlined\",\"name\":\"user_rule\",\"component\":null,\"parentId\":5,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":10,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员日志管理\",\"icon\":\"LineOutlined\",\"name\":\"user_log\",\"component\":null,\"parentId\":5,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":11,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"常规管理\",\"icon\":\"LineOutlined\",\"name\":\"routine\",\"component\":null,\"parentId\":null,\"sort\":96,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"系统配置\",\"icon\":\"LineOutlined\",\"name\":\"routine_config\",\"component\":\"/Routine/Config\",\"parentId\":11,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":14,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"个人资料\",\"icon\":\"LineOutlined\",\"name\":\"routine_info\",\"component\":\"/Routine/Info\",\"parentId\":11,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":13,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"附件管理\",\"icon\":null,\"name\":\"routine_annex\",\"component\":\"/Routine/Annex\",\"parentId\":11,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":15,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"模块市场\",\"icon\":null,\"name\":\"module\",\"component\":\"/Module\",\"parentId\":null,\"sort\":95,\"type\":2,\"code\":null,\"cache\":0,\"status\":0}],\"remark\":null}}',
    200,
    42,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    666,
    '2024-08-28 22:02:53.155096',
    '2024-08-28 22:02:53.155096',
    4,
    'admin',
    '管理员管理-详情',
    '::1',
    '',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    93,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    667,
    '2024-08-28 22:02:56.183528',
    '2024-08-28 22:02:56.183528',
    4,
    'admin',
    '菜单规则管理',
    '::1',
    '',
    '/admin/permission',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":24,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"首页\",\"icon\":null,\"name\":\"home\",\"component\":null,\"parentId\":null,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":2,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"权限管理\",\"icon\":\"LineOutlined\",\"name\":\"auth\",\"component\":null,\"parentId\":null,\"sort\":98,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":3,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"角色组管理\",\"icon\":\"AimOutlined\",\"name\":\"auth_group\",\"component\":null,\"parentId\":2,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":16,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_group_create\",\"component\":null,\"parentId\":3,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":17,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_group_update\",\"component\":null,\"parentId\":3,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":18,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_group_info\",\"component\":null,\"parentId\":3,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":19,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_group_delete\",\"component\":null,\"parentId\":3,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":7,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"管理员管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_admin\",\"component\":null,\"parentId\":2,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":20,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_admin_create\",\"component\":null,\"parentId\":7,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":21,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_admin_update\",\"component\":null,\"parentId\":7,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":22,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_admin_info\",\"component\":null,\"parentId\":7,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":23,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_admin_delete\",\"component\":null,\"parentId\":7,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":6,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"菜单规则管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_menu\",\"component\":null,\"parentId\":2,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":4,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"管理员日志管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"auth_log\",\"component\":null,\"parentId\":2,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":5,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"user\",\"component\":null,\"parentId\":null,\"sort\":97,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":8,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员管理\",\"icon\":\"LineOutlined\",\"name\":\"user_index\",\"component\":null,\"parentId\":5,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":1,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员分组管理\",\"icon\":null,\"name\":\"user_group\",\"component\":null,\"parentId\":5,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":9,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员规则管理\",\"icon\":\"AimOutlined\",\"name\":\"user_rule\",\"component\":null,\"parentId\":5,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":10,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员日志管理\",\"icon\":\"LineOutlined\",\"name\":\"user_log\",\"component\":null,\"parentId\":5,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":11,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"常规管理\",\"icon\":\"LineOutlined\",\"name\":\"routine\",\"component\":null,\"parentId\":null,\"sort\":96,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"系统配置\",\"icon\":\"LineOutlined\",\"name\":\"routine_config\",\"component\":\"/Routine/Config\",\"parentId\":11,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":14,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"个人资料\",\"icon\":\"LineOutlined\",\"name\":\"routine_info\",\"component\":\"/Routine/Info\",\"parentId\":11,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":13,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"附件管理\",\"icon\":null,\"name\":\"routine_annex\",\"component\":\"/Routine/Annex\",\"parentId\":11,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":15,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"模块市场\",\"icon\":null,\"name\":\"module\",\"component\":\"/Module\",\"parentId\":null,\"sort\":95,\"type\":2,\"code\":null,\"cache\":0,\"status\":0}],\"remark\":null}}',
    200,
    41,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    668,
    '2024-08-28 22:02:59.122591',
    '2024-08-28 22:02:59.122591',
    4,
    'admin',
    '角色组管理',
    '::1',
    '',
    '/admin/role',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":1,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"超级管理员\",\"slug\":\"super_admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":0,\"children\":[{\"id\":9,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通管理员\",\"slug\":\"admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":1,\"children\":[{\"id\":10,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"超级会员\",\"slug\":\"super_member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":9,\"children\":[{\"id\":11,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通会员\",\"slug\":\"member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":10,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通用户\",\"slug\":\"user\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":11,\"children\":null}]}]}]}]}],\"remark\":null}}',
    200,
    65,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    669,
    '2024-08-28 22:03:00.672505',
    '2024-08-28 22:03:00.672505',
    4,
    'admin',
    '菜单规则管理',
    '::1',
    '',
    '/admin/permission',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":24,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"首页\",\"icon\":null,\"name\":\"home\",\"component\":null,\"parentId\":null,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":2,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"权限管理\",\"icon\":\"LineOutlined\",\"name\":\"auth\",\"component\":null,\"parentId\":null,\"sort\":98,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":3,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"角色组管理\",\"icon\":\"AimOutlined\",\"name\":\"auth_group\",\"component\":null,\"parentId\":2,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":16,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_group_create\",\"component\":null,\"parentId\":3,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":17,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_group_update\",\"component\":null,\"parentId\":3,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":18,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_group_info\",\"component\":null,\"parentId\":3,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":19,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_group_delete\",\"component\":null,\"parentId\":3,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":7,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"管理员管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_admin\",\"component\":null,\"parentId\":2,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":20,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_admin_create\",\"component\":null,\"parentId\":7,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":21,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_admin_update\",\"component\":null,\"parentId\":7,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":22,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_admin_info\",\"component\":null,\"parentId\":7,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":23,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_admin_delete\",\"component\":null,\"parentId\":7,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":6,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"菜单规则管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_menu\",\"component\":null,\"parentId\":2,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":4,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"管理员日志管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"auth_log\",\"component\":null,\"parentId\":2,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":5,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"user\",\"component\":null,\"parentId\":null,\"sort\":97,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":8,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员管理\",\"icon\":\"LineOutlined\",\"name\":\"user_index\",\"component\":null,\"parentId\":5,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":1,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员分组管理\",\"icon\":null,\"name\":\"user_group\",\"component\":null,\"parentId\":5,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":9,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员规则管理\",\"icon\":\"AimOutlined\",\"name\":\"user_rule\",\"component\":null,\"parentId\":5,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":10,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员日志管理\",\"icon\":\"LineOutlined\",\"name\":\"user_log\",\"component\":null,\"parentId\":5,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":11,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"常规管理\",\"icon\":\"LineOutlined\",\"name\":\"routine\",\"component\":null,\"parentId\":null,\"sort\":96,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"系统配置\",\"icon\":\"LineOutlined\",\"name\":\"routine_config\",\"component\":\"/Routine/Config\",\"parentId\":11,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":14,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"个人资料\",\"icon\":\"LineOutlined\",\"name\":\"routine_info\",\"component\":\"/Routine/Info\",\"parentId\":11,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":13,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"附件管理\",\"icon\":null,\"name\":\"routine_annex\",\"component\":\"/Routine/Annex\",\"parentId\":11,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":15,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"模块市场\",\"icon\":null,\"name\":\"module\",\"component\":\"/Module\",\"parentId\":null,\"sort\":95,\"type\":2,\"code\":null,\"cache\":0,\"status\":0}],\"remark\":null}}',
    200,
    37,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    670,
    '2024-08-28 22:03:04.355388',
    '2024-08-28 22:03:04.355388',
    4,
    'admin',
    '菜单规则管理',
    '::1',
    '',
    '/admin/permission',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":24,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"首页\",\"icon\":null,\"name\":\"home\",\"component\":null,\"parentId\":null,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":2,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"权限管理\",\"icon\":\"LineOutlined\",\"name\":\"auth\",\"component\":null,\"parentId\":null,\"sort\":98,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":3,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"角色组管理\",\"icon\":\"AimOutlined\",\"name\":\"auth_group\",\"component\":null,\"parentId\":2,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":16,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_group_create\",\"component\":null,\"parentId\":3,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":17,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_group_update\",\"component\":null,\"parentId\":3,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":18,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_group_info\",\"component\":null,\"parentId\":3,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":19,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_group_delete\",\"component\":null,\"parentId\":3,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":7,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"管理员管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_admin\",\"component\":null,\"parentId\":2,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":20,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_admin_create\",\"component\":null,\"parentId\":7,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":21,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_admin_update\",\"component\":null,\"parentId\":7,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":22,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_admin_info\",\"component\":null,\"parentId\":7,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":23,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_admin_delete\",\"component\":null,\"parentId\":7,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":6,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"菜单规则管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_menu\",\"component\":null,\"parentId\":2,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":4,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"管理员日志管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"auth_log\",\"component\":null,\"parentId\":2,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":5,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"user\",\"component\":null,\"parentId\":null,\"sort\":97,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":8,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员管理\",\"icon\":\"LineOutlined\",\"name\":\"user_index\",\"component\":null,\"parentId\":5,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":1,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员分组管理\",\"icon\":null,\"name\":\"user_group\",\"component\":null,\"parentId\":5,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":9,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员规则管理\",\"icon\":\"AimOutlined\",\"name\":\"user_rule\",\"component\":null,\"parentId\":5,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":10,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员日志管理\",\"icon\":\"LineOutlined\",\"name\":\"user_log\",\"component\":null,\"parentId\":5,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":11,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"常规管理\",\"icon\":\"LineOutlined\",\"name\":\"routine\",\"component\":null,\"parentId\":null,\"sort\":96,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"系统配置\",\"icon\":\"LineOutlined\",\"name\":\"routine_config\",\"component\":\"/Routine/Config\",\"parentId\":11,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":14,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"个人资料\",\"icon\":\"LineOutlined\",\"name\":\"routine_info\",\"component\":\"/Routine/Info\",\"parentId\":11,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":13,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"附件管理\",\"icon\":null,\"name\":\"routine_annex\",\"component\":\"/Routine/Annex\",\"parentId\":11,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":15,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"模块市场\",\"icon\":null,\"name\":\"module\",\"component\":\"/Module\",\"parentId\":null,\"sort\":95,\"type\":2,\"code\":null,\"cache\":0,\"status\":0}],\"remark\":null}}',
    200,
    45,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    671,
    '2024-08-28 22:03:06.935088',
    '2024-08-28 22:03:06.935088',
    4,
    'admin',
    '菜单规则管理',
    '::1',
    '',
    '/admin/permission',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":24,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"首页\",\"icon\":null,\"name\":\"home\",\"component\":null,\"parentId\":null,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":2,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"权限管理\",\"icon\":\"LineOutlined\",\"name\":\"auth\",\"component\":null,\"parentId\":null,\"sort\":98,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":3,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"角色组管理\",\"icon\":\"AimOutlined\",\"name\":\"auth_group\",\"component\":null,\"parentId\":2,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":16,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_group_create\",\"component\":null,\"parentId\":3,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":17,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_group_update\",\"component\":null,\"parentId\":3,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":18,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_group_info\",\"component\":null,\"parentId\":3,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":19,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_group_delete\",\"component\":null,\"parentId\":3,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":7,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"管理员管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_admin\",\"component\":null,\"parentId\":2,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":20,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_admin_create\",\"component\":null,\"parentId\":7,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":21,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_admin_update\",\"component\":null,\"parentId\":7,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":22,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_admin_info\",\"component\":null,\"parentId\":7,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":23,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_admin_delete\",\"component\":null,\"parentId\":7,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":6,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"菜单规则管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_menu\",\"component\":null,\"parentId\":2,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":4,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"管理员日志管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"auth_log\",\"component\":null,\"parentId\":2,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":5,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"user\",\"component\":null,\"parentId\":null,\"sort\":97,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":8,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员管理\",\"icon\":\"LineOutlined\",\"name\":\"user_index\",\"component\":null,\"parentId\":5,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":1,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员分组管理\",\"icon\":null,\"name\":\"user_group\",\"component\":null,\"parentId\":5,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":9,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员规则管理\",\"icon\":\"AimOutlined\",\"name\":\"user_rule\",\"component\":null,\"parentId\":5,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":10,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员日志管理\",\"icon\":\"LineOutlined\",\"name\":\"user_log\",\"component\":null,\"parentId\":5,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":11,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"常规管理\",\"icon\":\"LineOutlined\",\"name\":\"routine\",\"component\":null,\"parentId\":null,\"sort\":96,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"系统配置\",\"icon\":\"LineOutlined\",\"name\":\"routine_config\",\"component\":\"/Routine/Config\",\"parentId\":11,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":14,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"个人资料\",\"icon\":\"LineOutlined\",\"name\":\"routine_info\",\"component\":\"/Routine/Info\",\"parentId\":11,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":13,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"附件管理\",\"icon\":null,\"name\":\"routine_annex\",\"component\":\"/Routine/Annex\",\"parentId\":11,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":15,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"模块市场\",\"icon\":null,\"name\":\"module\",\"component\":\"/Module\",\"parentId\":null,\"sort\":95,\"type\":2,\"code\":null,\"cache\":0,\"status\":0}],\"remark\":null}}',
    200,
    43,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    672,
    '2024-08-28 22:03:11.279868',
    '2024-08-28 22:03:11.279868',
    4,
    'admin',
    '菜单规则管理',
    '::1',
    '',
    '/admin/permission',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":24,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"首页\",\"icon\":null,\"name\":\"home\",\"component\":null,\"parentId\":null,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":2,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"权限管理\",\"icon\":\"LineOutlined\",\"name\":\"auth\",\"component\":null,\"parentId\":null,\"sort\":98,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":3,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"角色组管理\",\"icon\":\"AimOutlined\",\"name\":\"auth_group\",\"component\":null,\"parentId\":2,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":16,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_group_create\",\"component\":null,\"parentId\":3,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":17,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_group_update\",\"component\":null,\"parentId\":3,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":18,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_group_info\",\"component\":null,\"parentId\":3,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":19,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_group_delete\",\"component\":null,\"parentId\":3,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":7,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"管理员管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_admin\",\"component\":null,\"parentId\":2,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":20,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_admin_create\",\"component\":null,\"parentId\":7,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":21,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_admin_update\",\"component\":null,\"parentId\":7,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":22,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_admin_info\",\"component\":null,\"parentId\":7,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":23,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_admin_delete\",\"component\":null,\"parentId\":7,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":6,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"菜单规则管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_menu\",\"component\":null,\"parentId\":2,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":4,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"管理员日志管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"auth_log\",\"component\":null,\"parentId\":2,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":5,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"user\",\"component\":null,\"parentId\":null,\"sort\":97,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":8,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员管理\",\"icon\":\"LineOutlined\",\"name\":\"user_index\",\"component\":null,\"parentId\":5,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":1,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员分组管理\",\"icon\":null,\"name\":\"user_group\",\"component\":null,\"parentId\":5,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":9,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员规则管理\",\"icon\":\"AimOutlined\",\"name\":\"user_rule\",\"component\":null,\"parentId\":5,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":10,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员日志管理\",\"icon\":\"LineOutlined\",\"name\":\"user_log\",\"component\":null,\"parentId\":5,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":11,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"常规管理\",\"icon\":\"LineOutlined\",\"name\":\"routine\",\"component\":null,\"parentId\":null,\"sort\":96,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"系统配置\",\"icon\":\"LineOutlined\",\"name\":\"routine_config\",\"component\":\"/Routine/Config\",\"parentId\":11,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":14,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"个人资料\",\"icon\":\"LineOutlined\",\"name\":\"routine_info\",\"component\":\"/Routine/Info\",\"parentId\":11,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":13,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"附件管理\",\"icon\":null,\"name\":\"routine_annex\",\"component\":\"/Routine/Annex\",\"parentId\":11,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":15,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"模块市场\",\"icon\":null,\"name\":\"module\",\"component\":\"/Module\",\"parentId\":null,\"sort\":95,\"type\":2,\"code\":null,\"cache\":0,\"status\":0}],\"remark\":null}}',
    200,
    37,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    673,
    '2024-08-28 22:03:11.347059',
    '2024-08-28 22:03:11.347059',
    4,
    'admin',
    '管理员管理-详情',
    '::1',
    '',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    86,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    674,
    '2024-08-28 22:03:15.511761',
    '2024-08-28 22:03:15.511761',
    4,
    'admin',
    '菜单规则管理',
    '::1',
    '',
    '/admin/permission',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":24,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"首页\",\"icon\":null,\"name\":\"home\",\"component\":null,\"parentId\":null,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":2,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"权限管理\",\"icon\":\"LineOutlined\",\"name\":\"auth\",\"component\":null,\"parentId\":null,\"sort\":98,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":3,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"角色组管理\",\"icon\":\"AimOutlined\",\"name\":\"auth_group\",\"component\":null,\"parentId\":2,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":16,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_group_create\",\"component\":null,\"parentId\":3,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":17,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_group_update\",\"component\":null,\"parentId\":3,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":18,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_group_info\",\"component\":null,\"parentId\":3,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":19,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_group_delete\",\"component\":null,\"parentId\":3,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":7,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"管理员管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_admin\",\"component\":null,\"parentId\":2,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":20,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_admin_create\",\"component\":null,\"parentId\":7,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":21,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_admin_update\",\"component\":null,\"parentId\":7,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":22,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_admin_info\",\"component\":null,\"parentId\":7,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":23,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_admin_delete\",\"component\":null,\"parentId\":7,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":6,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"菜单规则管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_menu\",\"component\":null,\"parentId\":2,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":4,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"管理员日志管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"auth_log\",\"component\":null,\"parentId\":2,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":5,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"user\",\"component\":null,\"parentId\":null,\"sort\":97,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":8,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员管理\",\"icon\":\"LineOutlined\",\"name\":\"user_index\",\"component\":null,\"parentId\":5,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":1,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员分组管理\",\"icon\":null,\"name\":\"user_group\",\"component\":null,\"parentId\":5,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":9,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员规则管理\",\"icon\":\"AimOutlined\",\"name\":\"user_rule\",\"component\":null,\"parentId\":5,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":10,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员日志管理\",\"icon\":\"LineOutlined\",\"name\":\"user_log\",\"component\":null,\"parentId\":5,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":11,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"常规管理\",\"icon\":\"LineOutlined\",\"name\":\"routine\",\"component\":null,\"parentId\":null,\"sort\":96,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"系统配置\",\"icon\":\"LineOutlined\",\"name\":\"routine_config\",\"component\":\"/Routine/Config\",\"parentId\":11,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":14,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"个人资料\",\"icon\":\"LineOutlined\",\"name\":\"routine_info\",\"component\":\"/Routine/Info\",\"parentId\":11,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":13,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"附件管理\",\"icon\":null,\"name\":\"routine_annex\",\"component\":\"/Routine/Annex\",\"parentId\":11,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":15,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"模块市场\",\"icon\":null,\"name\":\"module\",\"component\":\"/Module\",\"parentId\":null,\"sort\":95,\"type\":2,\"code\":null,\"cache\":0,\"status\":0}],\"remark\":null}}',
    200,
    37,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    675,
    '2024-08-28 22:03:43.980972',
    '2024-08-28 22:03:43.980972',
    4,
    'admin',
    '菜单规则管理',
    '::1',
    '',
    '/admin/permission',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":24,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"首页\",\"icon\":null,\"name\":\"home\",\"component\":null,\"parentId\":null,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":2,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"权限管理\",\"icon\":\"LineOutlined\",\"name\":\"auth\",\"component\":null,\"parentId\":null,\"sort\":98,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":3,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"角色组管理\",\"icon\":\"AimOutlined\",\"name\":\"auth_group\",\"component\":null,\"parentId\":2,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":16,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_group_create\",\"component\":null,\"parentId\":3,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":17,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_group_update\",\"component\":null,\"parentId\":3,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":18,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_group_info\",\"component\":null,\"parentId\":3,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":19,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_group_delete\",\"component\":null,\"parentId\":3,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":7,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"管理员管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_admin\",\"component\":null,\"parentId\":2,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":20,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_admin_create\",\"component\":null,\"parentId\":7,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":21,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_admin_update\",\"component\":null,\"parentId\":7,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":22,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_admin_info\",\"component\":null,\"parentId\":7,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":23,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_admin_delete\",\"component\":null,\"parentId\":7,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":6,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"菜单规则管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_menu\",\"component\":null,\"parentId\":2,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":4,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"管理员日志管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"auth_log\",\"component\":null,\"parentId\":2,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":5,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"user\",\"component\":null,\"parentId\":null,\"sort\":97,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":8,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员管理\",\"icon\":\"LineOutlined\",\"name\":\"user_index\",\"component\":null,\"parentId\":5,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":1,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员分组管理\",\"icon\":null,\"name\":\"user_group\",\"component\":null,\"parentId\":5,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":9,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员规则管理\",\"icon\":\"AimOutlined\",\"name\":\"user_rule\",\"component\":null,\"parentId\":5,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":10,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员日志管理\",\"icon\":\"LineOutlined\",\"name\":\"user_log\",\"component\":null,\"parentId\":5,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":11,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"常规管理\",\"icon\":\"LineOutlined\",\"name\":\"routine\",\"component\":null,\"parentId\":null,\"sort\":96,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"系统配置\",\"icon\":\"LineOutlined\",\"name\":\"routine_config\",\"component\":\"/Routine/Config\",\"parentId\":11,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":14,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"个人资料\",\"icon\":\"LineOutlined\",\"name\":\"routine_info\",\"component\":\"/Routine/Info\",\"parentId\":11,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":13,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"附件管理\",\"icon\":null,\"name\":\"routine_annex\",\"component\":\"/Routine/Annex\",\"parentId\":11,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":15,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"模块市场\",\"icon\":null,\"name\":\"module\",\"component\":\"/Module\",\"parentId\":null,\"sort\":95,\"type\":2,\"code\":null,\"cache\":0,\"status\":0}],\"remark\":null}}',
    200,
    44,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    676,
    '2024-08-28 22:03:43.987135',
    '2024-08-28 22:03:43.987135',
    4,
    'admin',
    '管理员管理-详情',
    '::1',
    '',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    71,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    677,
    '2024-08-28 22:03:47.998843',
    '2024-08-28 22:03:47.998843',
    4,
    'admin',
    '菜单规则管理',
    '::1',
    '',
    '/admin/permission',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":24,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"首页\",\"icon\":null,\"name\":\"home\",\"component\":null,\"parentId\":null,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":2,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"权限管理\",\"icon\":\"LineOutlined\",\"name\":\"auth\",\"component\":null,\"parentId\":null,\"sort\":98,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":3,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"角色组管理\",\"icon\":\"AimOutlined\",\"name\":\"auth_group\",\"component\":null,\"parentId\":2,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":16,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_group_create\",\"component\":null,\"parentId\":3,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":17,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_group_update\",\"component\":null,\"parentId\":3,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":18,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_group_info\",\"component\":null,\"parentId\":3,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":19,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_group_delete\",\"component\":null,\"parentId\":3,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":7,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"管理员管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_admin\",\"component\":null,\"parentId\":2,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":20,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_admin_create\",\"component\":null,\"parentId\":7,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":21,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_admin_update\",\"component\":null,\"parentId\":7,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":22,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_admin_info\",\"component\":null,\"parentId\":7,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":23,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_admin_delete\",\"component\":null,\"parentId\":7,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":6,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"菜单规则管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_menu\",\"component\":null,\"parentId\":2,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":4,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"管理员日志管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"auth_log\",\"component\":null,\"parentId\":2,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":5,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"user\",\"component\":null,\"parentId\":null,\"sort\":97,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":8,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员管理\",\"icon\":\"LineOutlined\",\"name\":\"user_index\",\"component\":null,\"parentId\":5,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":1,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员分组管理\",\"icon\":null,\"name\":\"user_group\",\"component\":null,\"parentId\":5,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":9,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员规则管理\",\"icon\":\"AimOutlined\",\"name\":\"user_rule\",\"component\":null,\"parentId\":5,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":10,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员日志管理\",\"icon\":\"LineOutlined\",\"name\":\"user_log\",\"component\":null,\"parentId\":5,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":11,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"常规管理\",\"icon\":\"LineOutlined\",\"name\":\"routine\",\"component\":null,\"parentId\":null,\"sort\":96,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"系统配置\",\"icon\":\"LineOutlined\",\"name\":\"routine_config\",\"component\":\"/Routine/Config\",\"parentId\":11,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":14,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"个人资料\",\"icon\":\"LineOutlined\",\"name\":\"routine_info\",\"component\":\"/Routine/Info\",\"parentId\":11,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":13,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"附件管理\",\"icon\":null,\"name\":\"routine_annex\",\"component\":\"/Routine/Annex\",\"parentId\":11,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":15,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"模块市场\",\"icon\":null,\"name\":\"module\",\"component\":\"/Module\",\"parentId\":null,\"sort\":95,\"type\":2,\"code\":null,\"cache\":0,\"status\":0}],\"remark\":null}}',
    200,
    38,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    678,
    '2024-08-28 22:03:53.058199',
    '2024-08-28 22:03:53.058199',
    4,
    'admin',
    '菜单规则管理',
    '::1',
    '',
    '/admin/permission',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":24,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"首页\",\"icon\":null,\"name\":\"home\",\"component\":null,\"parentId\":null,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":2,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"权限管理\",\"icon\":\"LineOutlined\",\"name\":\"auth\",\"component\":null,\"parentId\":null,\"sort\":98,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":3,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"角色组管理\",\"icon\":\"AimOutlined\",\"name\":\"auth_group\",\"component\":null,\"parentId\":2,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":16,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_group_create\",\"component\":null,\"parentId\":3,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":17,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_group_update\",\"component\":null,\"parentId\":3,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":18,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_group_info\",\"component\":null,\"parentId\":3,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":19,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_group_delete\",\"component\":null,\"parentId\":3,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":7,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"管理员管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_admin\",\"component\":null,\"parentId\":2,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":20,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_admin_create\",\"component\":null,\"parentId\":7,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":21,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_admin_update\",\"component\":null,\"parentId\":7,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":22,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_admin_info\",\"component\":null,\"parentId\":7,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":23,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_admin_delete\",\"component\":null,\"parentId\":7,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":6,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"菜单规则管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_menu\",\"component\":null,\"parentId\":2,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":4,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"管理员日志管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"auth_log\",\"component\":null,\"parentId\":2,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":5,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"user\",\"component\":null,\"parentId\":null,\"sort\":97,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":8,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员管理\",\"icon\":\"LineOutlined\",\"name\":\"user_index\",\"component\":null,\"parentId\":5,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":1,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员分组管理\",\"icon\":null,\"name\":\"user_group\",\"component\":null,\"parentId\":5,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":9,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员规则管理\",\"icon\":\"AimOutlined\",\"name\":\"user_rule\",\"component\":null,\"parentId\":5,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":10,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员日志管理\",\"icon\":\"LineOutlined\",\"name\":\"user_log\",\"component\":null,\"parentId\":5,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":11,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"常规管理\",\"icon\":\"LineOutlined\",\"name\":\"routine\",\"component\":null,\"parentId\":null,\"sort\":96,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"系统配置\",\"icon\":\"LineOutlined\",\"name\":\"routine_config\",\"component\":\"/Routine/Config\",\"parentId\":11,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":14,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"个人资料\",\"icon\":\"LineOutlined\",\"name\":\"routine_info\",\"component\":\"/Routine/Info\",\"parentId\":11,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":13,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"附件管理\",\"icon\":null,\"name\":\"routine_annex\",\"component\":\"/Routine/Annex\",\"parentId\":11,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":15,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"模块市场\",\"icon\":null,\"name\":\"module\",\"component\":\"/Module\",\"parentId\":null,\"sort\":95,\"type\":2,\"code\":null,\"cache\":0,\"status\":0}],\"remark\":null}}',
    200,
    36,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    679,
    '2024-08-28 22:04:00.341745',
    '2024-08-28 22:04:00.341745',
    4,
    'admin',
    '菜单规则管理',
    '::1',
    '',
    '/admin/permission',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":24,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"首页\",\"icon\":null,\"name\":\"home\",\"component\":null,\"parentId\":null,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":2,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"权限管理\",\"icon\":\"LineOutlined\",\"name\":\"auth\",\"component\":null,\"parentId\":null,\"sort\":98,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":3,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"角色组管理\",\"icon\":\"AimOutlined\",\"name\":\"auth_group\",\"component\":null,\"parentId\":2,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":16,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_group_create\",\"component\":null,\"parentId\":3,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":17,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_group_update\",\"component\":null,\"parentId\":3,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":18,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_group_info\",\"component\":null,\"parentId\":3,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":19,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_group_delete\",\"component\":null,\"parentId\":3,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":7,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"管理员管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_admin\",\"component\":null,\"parentId\":2,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":20,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_admin_create\",\"component\":null,\"parentId\":7,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":21,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_admin_update\",\"component\":null,\"parentId\":7,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":22,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_admin_info\",\"component\":null,\"parentId\":7,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":23,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_admin_delete\",\"component\":null,\"parentId\":7,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":6,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"菜单规则管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_menu\",\"component\":null,\"parentId\":2,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":4,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"管理员日志管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"auth_log\",\"component\":null,\"parentId\":2,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":5,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"user\",\"component\":null,\"parentId\":null,\"sort\":97,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":8,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员管理\",\"icon\":\"LineOutlined\",\"name\":\"user_index\",\"component\":null,\"parentId\":5,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":1,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员分组管理\",\"icon\":null,\"name\":\"user_group\",\"component\":null,\"parentId\":5,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":9,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员规则管理\",\"icon\":\"AimOutlined\",\"name\":\"user_rule\",\"component\":null,\"parentId\":5,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":10,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员日志管理\",\"icon\":\"LineOutlined\",\"name\":\"user_log\",\"component\":null,\"parentId\":5,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":11,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"常规管理\",\"icon\":\"LineOutlined\",\"name\":\"routine\",\"component\":null,\"parentId\":null,\"sort\":96,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"系统配置\",\"icon\":\"LineOutlined\",\"name\":\"routine_config\",\"component\":\"/Routine/Config\",\"parentId\":11,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":14,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"个人资料\",\"icon\":\"LineOutlined\",\"name\":\"routine_info\",\"component\":\"/Routine/Info\",\"parentId\":11,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":13,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"附件管理\",\"icon\":null,\"name\":\"routine_annex\",\"component\":\"/Routine/Annex\",\"parentId\":11,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":15,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"模块市场\",\"icon\":null,\"name\":\"module\",\"component\":\"/Module\",\"parentId\":null,\"sort\":95,\"type\":2,\"code\":null,\"cache\":0,\"status\":0}],\"remark\":null}}',
    200,
    46,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    680,
    '2024-08-28 22:04:10.013170',
    '2024-08-28 22:04:10.013170',
    4,
    'admin',
    '管理员管理-详情',
    '::1',
    '',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    85,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    681,
    '2024-08-28 22:04:12.296892',
    '2024-08-28 22:04:12.296892',
    4,
    'admin',
    '菜单规则管理',
    '::1',
    '',
    '/admin/permission',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":24,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"首页\",\"icon\":null,\"name\":\"home\",\"component\":null,\"parentId\":null,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":2,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"权限管理\",\"icon\":\"LineOutlined\",\"name\":\"auth\",\"component\":null,\"parentId\":null,\"sort\":98,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":3,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"角色组管理\",\"icon\":\"AimOutlined\",\"name\":\"auth_group\",\"component\":null,\"parentId\":2,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":16,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_group_create\",\"component\":null,\"parentId\":3,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":17,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_group_update\",\"component\":null,\"parentId\":3,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":18,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_group_info\",\"component\":null,\"parentId\":3,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":19,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_group_delete\",\"component\":null,\"parentId\":3,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":7,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"管理员管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_admin\",\"component\":null,\"parentId\":2,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":20,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"新增\",\"icon\":null,\"name\":\"auth_admin_create\",\"component\":null,\"parentId\":7,\"sort\":99,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":21,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"编辑\",\"icon\":null,\"name\":\"auth_admin_update\",\"component\":null,\"parentId\":7,\"sort\":98,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":22,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"查看\",\"icon\":null,\"name\":\"auth_admin_info\",\"component\":null,\"parentId\":7,\"sort\":97,\"type\":3,\"code\":null,\"cache\":0,\"status\":1},{\"id\":23,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"删除\",\"icon\":null,\"name\":\"auth_admin_delete\",\"component\":null,\"parentId\":7,\"sort\":96,\"type\":3,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":6,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"菜单规则管理\",\"icon\":\"LineOutlined\",\"name\":\"auth_menu\",\"component\":null,\"parentId\":2,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":4,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"管理员日志管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"auth_log\",\"component\":null,\"parentId\":2,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":5,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员管理\",\"icon\":\"AlibabaOutlined\",\"name\":\"user\",\"component\":null,\"parentId\":null,\"sort\":97,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":8,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员管理\",\"icon\":\"LineOutlined\",\"name\":\"user_index\",\"component\":null,\"parentId\":5,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":1,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员分组管理\",\"icon\":null,\"name\":\"user_group\",\"component\":null,\"parentId\":5,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":9,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员规则管理\",\"icon\":\"AimOutlined\",\"name\":\"user_rule\",\"component\":null,\"parentId\":5,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":10,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"会员日志管理\",\"icon\":\"LineOutlined\",\"name\":\"user_log\",\"component\":null,\"parentId\":5,\"sort\":96,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":11,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"常规管理\",\"icon\":\"LineOutlined\",\"name\":\"routine\",\"component\":null,\"parentId\":null,\"sort\":96,\"type\":1,\"code\":null,\"cache\":0,\"status\":1,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"系统配置\",\"icon\":\"LineOutlined\",\"name\":\"routine_config\",\"component\":\"/Routine/Config\",\"parentId\":11,\"sort\":99,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":14,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"个人资料\",\"icon\":\"LineOutlined\",\"name\":\"routine_info\",\"component\":\"/Routine/Info\",\"parentId\":11,\"sort\":98,\"type\":2,\"code\":null,\"cache\":0,\"status\":1},{\"id\":13,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"附件管理\",\"icon\":null,\"name\":\"routine_annex\",\"component\":\"/Routine/Annex\",\"parentId\":11,\"sort\":97,\"type\":2,\"code\":null,\"cache\":0,\"status\":1}]},{\"id\":15,\"updateTime\":\"2024-08-27 02:19:48\",\"createTime\":\"2024-08-27 02:19:48\",\"title\":\"模块市场\",\"icon\":null,\"name\":\"module\",\"component\":\"/Module\",\"parentId\":null,\"sort\":95,\"type\":2,\"code\":null,\"cache\":0,\"status\":0}],\"remark\":null}}',
    200,
    45,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    682,
    '2024-08-28 22:10:48.536657',
    '2024-08-28 22:10:48.536657',
    4,
    'admin',
    '管理员管理-详情',
    '::1',
    '',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    171,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    683,
    '2024-08-28 22:10:56.588212',
    '2024-08-28 22:10:56.588212',
    4,
    'admin',
    '管理员管理-详情',
    '::1',
    '',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    71,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    684,
    '2024-08-28 22:13:20.985021',
    '2024-08-28 22:13:20.985021',
    4,
    'admin',
    '管理员管理-详情',
    '::1',
    '',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    233,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    685,
    '2024-08-28 22:13:33.943071',
    '2024-08-28 22:13:33.943071',
    4,
    'admin',
    '附件管理',
    '::1',
    '',
    '/files/list?page=1&size=10',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"page\":1,\"size\":10,\"total\":15,\"records\":[{\"id\":151,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"oceans.mp4\",\"hash\":\"9f8f979374969429263495ffcaac832cd603b1efe4c66a05fafd6729dffef9af\",\"path\":\"/uploads/2024/08/07/oceans.mp4\",\"mimetype\":\"video/mp4\",\"size\":23014356,\"uploadCount\":15,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/oceans.mp4\"},{\"id\":152,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"财务记账系统excel表格.xlsx\",\"hash\":\"b55ab38ff825b0360bea155510d9fee9c41812fabfe7e9fdb0aa36714195e266\",\"path\":\"/uploads/2024/08/07/财务记账系统excel表格.xlsx\",\"mimetype\":\"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet\",\"size\":97475,\"uploadCount\":4,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/财务记账系统excel表格.xlsx\"},{\"id\":153,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"测试Markdown.md\",\"hash\":\"9bab5812e9c7319230796121a872f2f10d47878d985c83fe88abd9e0119f73b0\",\"path\":\"/uploads/2024/08/07/测试Markdown.md\",\"mimetype\":\"application/octet-stream\",\"size\":11364,\"uploadCount\":2,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/测试Markdown.md\"},{\"id\":154,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"image.jpeg\",\"hash\":\"a737ff09ec2ce204c6a1e0edfe5af0b0c3a81c07af5d31f900b1ff55b39a2201\",\"path\":\"/uploads/2024/08/07/image.jpeg\",\"mimetype\":\"image/jpeg\",\"size\":106111,\"uploadCount\":11,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/image.jpeg\"},{\"id\":155,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"changtu1.jpg\",\"hash\":\"0d83b5b689384e4e08721f873a1c981cdcddd3de0f7493b23c21cc28efa4efee\",\"path\":\"/uploads/2024/08/07/changtu1.jpg\",\"mimetype\":\"image/jpeg\",\"size\":48593,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/changtu1.jpg\"},{\"id\":156,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.doc\",\"hash\":\"b7dcfae78826ae565dfdd434145d3b74aca506738c0c31952370dd6b610b549d\",\"path\":\"/uploads/2024/08/07/目录文件.doc\",\"mimetype\":\"application/msword\",\"size\":1055816,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.doc\"},{\"id\":157,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.htm\",\"hash\":\"c8cc7106cc4a16fedf0bafe622e8ede5905ff4f9b3064f03ecab7980dcb72671\",\"path\":\"/uploads/2024/08/07/目录文件.htm\",\"mimetype\":\"text/html\",\"size\":349870,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.htm\"},{\"id\":158,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.txt\",\"hash\":\"4fb5c4132a38bf42068b9cd58fa8419e792e786a4a4160faf8fabf33d623371f\",\"path\":\"/uploads/2024/08/07/目录文件.txt\",\"mimetype\":\"text/plain\",\"size\":413766,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.txt\"},{\"id\":159,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"时间线规则.xmind\",\"hash\":\"9e21393ff90f96b9570e6dc5d8f1b4ca148d520f738fea61d0e8633d86865cac\",\"path\":\"/uploads/2024/08/07/时间线规则.xmind\",\"mimetype\":\"application/octet-stream\",\"size\":47082,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/时间线规则.xmind\"},{\"id\":165,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"新建 PPT 演示文稿.ppt\",\"hash\":\"310b06ff0a793076844f8be83a752745b3915cd23e35427b88047b801be76424\",\"path\":\"/uploads/2024/08/07/新建 PPT 演示文稿.ppt\",\"mimetype\":\"application/vnd.ms-powerpoint\",\"size\":20992,\"uploadCount\":7,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/新建 PPT 演示文稿.ppt\"}],\"remark\":\"同一文件被多次上传时，只会保存一份至磁盘和增加一条附件记录；删除附件记录，将自动删除对应文件！\"}}',
    200,
    71,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    686,
    '2024-08-28 22:13:44.285911',
    '2024-08-28 22:13:44.285911',
    4,
    'admin',
    '附件管理',
    '::1',
    '',
    '/files/list?page=1&size=10',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"page\":1,\"size\":10,\"total\":15,\"records\":[{\"id\":151,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"oceans.mp4\",\"hash\":\"9f8f979374969429263495ffcaac832cd603b1efe4c66a05fafd6729dffef9af\",\"path\":\"/uploads/2024/08/07/oceans.mp4\",\"mimetype\":\"video/mp4\",\"size\":23014356,\"uploadCount\":15,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/oceans.mp4\"},{\"id\":152,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"财务记账系统excel表格.xlsx\",\"hash\":\"b55ab38ff825b0360bea155510d9fee9c41812fabfe7e9fdb0aa36714195e266\",\"path\":\"/uploads/2024/08/07/财务记账系统excel表格.xlsx\",\"mimetype\":\"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet\",\"size\":97475,\"uploadCount\":4,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/财务记账系统excel表格.xlsx\"},{\"id\":153,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"测试Markdown.md\",\"hash\":\"9bab5812e9c7319230796121a872f2f10d47878d985c83fe88abd9e0119f73b0\",\"path\":\"/uploads/2024/08/07/测试Markdown.md\",\"mimetype\":\"application/octet-stream\",\"size\":11364,\"uploadCount\":2,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/测试Markdown.md\"},{\"id\":154,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"image.jpeg\",\"hash\":\"a737ff09ec2ce204c6a1e0edfe5af0b0c3a81c07af5d31f900b1ff55b39a2201\",\"path\":\"/uploads/2024/08/07/image.jpeg\",\"mimetype\":\"image/jpeg\",\"size\":106111,\"uploadCount\":11,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/image.jpeg\"},{\"id\":155,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"changtu1.jpg\",\"hash\":\"0d83b5b689384e4e08721f873a1c981cdcddd3de0f7493b23c21cc28efa4efee\",\"path\":\"/uploads/2024/08/07/changtu1.jpg\",\"mimetype\":\"image/jpeg\",\"size\":48593,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/changtu1.jpg\"},{\"id\":156,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.doc\",\"hash\":\"b7dcfae78826ae565dfdd434145d3b74aca506738c0c31952370dd6b610b549d\",\"path\":\"/uploads/2024/08/07/目录文件.doc\",\"mimetype\":\"application/msword\",\"size\":1055816,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.doc\"},{\"id\":157,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.htm\",\"hash\":\"c8cc7106cc4a16fedf0bafe622e8ede5905ff4f9b3064f03ecab7980dcb72671\",\"path\":\"/uploads/2024/08/07/目录文件.htm\",\"mimetype\":\"text/html\",\"size\":349870,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.htm\"},{\"id\":158,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.txt\",\"hash\":\"4fb5c4132a38bf42068b9cd58fa8419e792e786a4a4160faf8fabf33d623371f\",\"path\":\"/uploads/2024/08/07/目录文件.txt\",\"mimetype\":\"text/plain\",\"size\":413766,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.txt\"},{\"id\":159,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"时间线规则.xmind\",\"hash\":\"9e21393ff90f96b9570e6dc5d8f1b4ca148d520f738fea61d0e8633d86865cac\",\"path\":\"/uploads/2024/08/07/时间线规则.xmind\",\"mimetype\":\"application/octet-stream\",\"size\":47082,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/时间线规则.xmind\"},{\"id\":165,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"新建 PPT 演示文稿.ppt\",\"hash\":\"310b06ff0a793076844f8be83a752745b3915cd23e35427b88047b801be76424\",\"path\":\"/uploads/2024/08/07/新建 PPT 演示文稿.ppt\",\"mimetype\":\"application/vnd.ms-powerpoint\",\"size\":20992,\"uploadCount\":7,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/新建 PPT 演示文稿.ppt\"}],\"remark\":\"同一文件被多次上传时，只会保存一份至磁盘和增加一条附件记录；删除附件记录，将自动删除对应文件！\"}}',
    200,
    71,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    687,
    '2024-08-28 22:14:12.271756',
    '2024-08-28 22:14:12.271756',
    4,
    'admin',
    '管理员管理-详情',
    '::1',
    '',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    71,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    688,
    '2024-08-28 22:15:23.079555',
    '2024-08-28 22:15:23.079555',
    4,
    'admin',
    '管理员管理-详情',
    '::1',
    '',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    106,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    689,
    '2024-08-28 22:15:28.206416',
    '2024-08-28 22:15:28.206416',
    4,
    'admin',
    '管理员管理-详情',
    '::1',
    '',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    74,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    690,
    '2024-08-28 22:16:11.770834',
    '2024-08-28 22:16:11.770834',
    4,
    'admin',
    '附件管理',
    '::1',
    '',
    '/files/list?page=1&size=10',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"page\":1,\"size\":10,\"total\":15,\"records\":[{\"id\":151,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"oceans.mp4\",\"hash\":\"9f8f979374969429263495ffcaac832cd603b1efe4c66a05fafd6729dffef9af\",\"path\":\"/uploads/2024/08/07/oceans.mp4\",\"mimetype\":\"video/mp4\",\"size\":23014356,\"uploadCount\":15,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/oceans.mp4\"},{\"id\":152,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"财务记账系统excel表格.xlsx\",\"hash\":\"b55ab38ff825b0360bea155510d9fee9c41812fabfe7e9fdb0aa36714195e266\",\"path\":\"/uploads/2024/08/07/财务记账系统excel表格.xlsx\",\"mimetype\":\"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet\",\"size\":97475,\"uploadCount\":4,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/财务记账系统excel表格.xlsx\"},{\"id\":153,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"测试Markdown.md\",\"hash\":\"9bab5812e9c7319230796121a872f2f10d47878d985c83fe88abd9e0119f73b0\",\"path\":\"/uploads/2024/08/07/测试Markdown.md\",\"mimetype\":\"application/octet-stream\",\"size\":11364,\"uploadCount\":2,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/测试Markdown.md\"},{\"id\":154,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"image.jpeg\",\"hash\":\"a737ff09ec2ce204c6a1e0edfe5af0b0c3a81c07af5d31f900b1ff55b39a2201\",\"path\":\"/uploads/2024/08/07/image.jpeg\",\"mimetype\":\"image/jpeg\",\"size\":106111,\"uploadCount\":11,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/image.jpeg\"},{\"id\":155,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"changtu1.jpg\",\"hash\":\"0d83b5b689384e4e08721f873a1c981cdcddd3de0f7493b23c21cc28efa4efee\",\"path\":\"/uploads/2024/08/07/changtu1.jpg\",\"mimetype\":\"image/jpeg\",\"size\":48593,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/changtu1.jpg\"},{\"id\":156,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.doc\",\"hash\":\"b7dcfae78826ae565dfdd434145d3b74aca506738c0c31952370dd6b610b549d\",\"path\":\"/uploads/2024/08/07/目录文件.doc\",\"mimetype\":\"application/msword\",\"size\":1055816,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.doc\"},{\"id\":157,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.htm\",\"hash\":\"c8cc7106cc4a16fedf0bafe622e8ede5905ff4f9b3064f03ecab7980dcb72671\",\"path\":\"/uploads/2024/08/07/目录文件.htm\",\"mimetype\":\"text/html\",\"size\":349870,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.htm\"},{\"id\":158,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.txt\",\"hash\":\"4fb5c4132a38bf42068b9cd58fa8419e792e786a4a4160faf8fabf33d623371f\",\"path\":\"/uploads/2024/08/07/目录文件.txt\",\"mimetype\":\"text/plain\",\"size\":413766,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.txt\"},{\"id\":159,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"时间线规则.xmind\",\"hash\":\"9e21393ff90f96b9570e6dc5d8f1b4ca148d520f738fea61d0e8633d86865cac\",\"path\":\"/uploads/2024/08/07/时间线规则.xmind\",\"mimetype\":\"application/octet-stream\",\"size\":47082,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/时间线规则.xmind\"},{\"id\":165,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"新建 PPT 演示文稿.ppt\",\"hash\":\"310b06ff0a793076844f8be83a752745b3915cd23e35427b88047b801be76424\",\"path\":\"/uploads/2024/08/07/新建 PPT 演示文稿.ppt\",\"mimetype\":\"application/vnd.ms-powerpoint\",\"size\":20992,\"uploadCount\":7,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/新建 PPT 演示文稿.ppt\"}],\"remark\":\"同一文件被多次上传时，只会保存一份至磁盘和增加一条附件记录；删除附件记录，将自动删除对应文件！\"}}',
    200,
    100,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    691,
    '2024-08-28 22:16:16.066199',
    '2024-08-28 22:16:16.066199',
    4,
    'admin',
    '管理员管理-详情',
    '::1',
    '',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    76,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    692,
    '2024-08-28 22:17:06.765231',
    '2024-08-28 22:17:06.765231',
    4,
    'admin',
    '管理员管理-详情',
    '::1',
    '',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    81,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    693,
    '2024-08-28 22:17:35.688557',
    '2024-08-28 22:17:35.688557',
    4,
    'admin',
    '管理员管理-详情',
    '::1',
    '',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    77,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    694,
    '2024-08-28 22:18:02.928917',
    '2024-08-28 22:18:02.928917',
    4,
    'admin',
    '管理员管理-详情',
    '::1',
    '',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    81,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    695,
    '2024-08-28 22:19:25.254307',
    '2024-08-28 22:19:25.254307',
    4,
    'admin',
    '管理员管理-详情',
    '::1',
    '',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    119,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    696,
    '2024-08-28 22:19:49.358814',
    '2024-08-28 22:19:49.358814',
    4,
    'admin',
    '附件管理',
    '::1',
    '',
    '/files/list?page=1&size=10',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"page\":1,\"size\":10,\"total\":15,\"records\":[{\"id\":151,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"oceans.mp4\",\"hash\":\"9f8f979374969429263495ffcaac832cd603b1efe4c66a05fafd6729dffef9af\",\"path\":\"/uploads/2024/08/07/oceans.mp4\",\"mimetype\":\"video/mp4\",\"size\":23014356,\"uploadCount\":15,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/oceans.mp4\"},{\"id\":152,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"财务记账系统excel表格.xlsx\",\"hash\":\"b55ab38ff825b0360bea155510d9fee9c41812fabfe7e9fdb0aa36714195e266\",\"path\":\"/uploads/2024/08/07/财务记账系统excel表格.xlsx\",\"mimetype\":\"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet\",\"size\":97475,\"uploadCount\":4,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/财务记账系统excel表格.xlsx\"},{\"id\":153,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"测试Markdown.md\",\"hash\":\"9bab5812e9c7319230796121a872f2f10d47878d985c83fe88abd9e0119f73b0\",\"path\":\"/uploads/2024/08/07/测试Markdown.md\",\"mimetype\":\"application/octet-stream\",\"size\":11364,\"uploadCount\":2,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/测试Markdown.md\"},{\"id\":154,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"image.jpeg\",\"hash\":\"a737ff09ec2ce204c6a1e0edfe5af0b0c3a81c07af5d31f900b1ff55b39a2201\",\"path\":\"/uploads/2024/08/07/image.jpeg\",\"mimetype\":\"image/jpeg\",\"size\":106111,\"uploadCount\":11,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/image.jpeg\"},{\"id\":155,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"changtu1.jpg\",\"hash\":\"0d83b5b689384e4e08721f873a1c981cdcddd3de0f7493b23c21cc28efa4efee\",\"path\":\"/uploads/2024/08/07/changtu1.jpg\",\"mimetype\":\"image/jpeg\",\"size\":48593,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/changtu1.jpg\"},{\"id\":156,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.doc\",\"hash\":\"b7dcfae78826ae565dfdd434145d3b74aca506738c0c31952370dd6b610b549d\",\"path\":\"/uploads/2024/08/07/目录文件.doc\",\"mimetype\":\"application/msword\",\"size\":1055816,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.doc\"},{\"id\":157,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.htm\",\"hash\":\"c8cc7106cc4a16fedf0bafe622e8ede5905ff4f9b3064f03ecab7980dcb72671\",\"path\":\"/uploads/2024/08/07/目录文件.htm\",\"mimetype\":\"text/html\",\"size\":349870,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.htm\"},{\"id\":158,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.txt\",\"hash\":\"4fb5c4132a38bf42068b9cd58fa8419e792e786a4a4160faf8fabf33d623371f\",\"path\":\"/uploads/2024/08/07/目录文件.txt\",\"mimetype\":\"text/plain\",\"size\":413766,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.txt\"},{\"id\":159,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"时间线规则.xmind\",\"hash\":\"9e21393ff90f96b9570e6dc5d8f1b4ca148d520f738fea61d0e8633d86865cac\",\"path\":\"/uploads/2024/08/07/时间线规则.xmind\",\"mimetype\":\"application/octet-stream\",\"size\":47082,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/时间线规则.xmind\"},{\"id\":165,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"新建 PPT 演示文稿.ppt\",\"hash\":\"310b06ff0a793076844f8be83a752745b3915cd23e35427b88047b801be76424\",\"path\":\"/uploads/2024/08/07/新建 PPT 演示文稿.ppt\",\"mimetype\":\"application/vnd.ms-powerpoint\",\"size\":20992,\"uploadCount\":7,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/新建 PPT 演示文稿.ppt\"}],\"remark\":\"同一文件被多次上传时，只会保存一份至磁盘和增加一条附件记录；删除附件记录，将自动删除对应文件！\"}}',
    200,
    86,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    697,
    '2024-08-28 22:20:13.581774',
    '2024-08-28 22:20:13.581774',
    4,
    'admin',
    '附件管理',
    '::1',
    '',
    '/files/list?page=1&size=10',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"page\":1,\"size\":10,\"total\":15,\"records\":[{\"id\":151,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"oceans.mp4\",\"hash\":\"9f8f979374969429263495ffcaac832cd603b1efe4c66a05fafd6729dffef9af\",\"path\":\"/uploads/2024/08/07/oceans.mp4\",\"mimetype\":\"video/mp4\",\"size\":23014356,\"uploadCount\":15,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/oceans.mp4\"},{\"id\":152,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"财务记账系统excel表格.xlsx\",\"hash\":\"b55ab38ff825b0360bea155510d9fee9c41812fabfe7e9fdb0aa36714195e266\",\"path\":\"/uploads/2024/08/07/财务记账系统excel表格.xlsx\",\"mimetype\":\"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet\",\"size\":97475,\"uploadCount\":4,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/财务记账系统excel表格.xlsx\"},{\"id\":153,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"测试Markdown.md\",\"hash\":\"9bab5812e9c7319230796121a872f2f10d47878d985c83fe88abd9e0119f73b0\",\"path\":\"/uploads/2024/08/07/测试Markdown.md\",\"mimetype\":\"application/octet-stream\",\"size\":11364,\"uploadCount\":2,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/测试Markdown.md\"},{\"id\":154,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"image.jpeg\",\"hash\":\"a737ff09ec2ce204c6a1e0edfe5af0b0c3a81c07af5d31f900b1ff55b39a2201\",\"path\":\"/uploads/2024/08/07/image.jpeg\",\"mimetype\":\"image/jpeg\",\"size\":106111,\"uploadCount\":11,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/image.jpeg\"},{\"id\":155,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"changtu1.jpg\",\"hash\":\"0d83b5b689384e4e08721f873a1c981cdcddd3de0f7493b23c21cc28efa4efee\",\"path\":\"/uploads/2024/08/07/changtu1.jpg\",\"mimetype\":\"image/jpeg\",\"size\":48593,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/changtu1.jpg\"},{\"id\":156,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.doc\",\"hash\":\"b7dcfae78826ae565dfdd434145d3b74aca506738c0c31952370dd6b610b549d\",\"path\":\"/uploads/2024/08/07/目录文件.doc\",\"mimetype\":\"application/msword\",\"size\":1055816,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.doc\"},{\"id\":157,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.htm\",\"hash\":\"c8cc7106cc4a16fedf0bafe622e8ede5905ff4f9b3064f03ecab7980dcb72671\",\"path\":\"/uploads/2024/08/07/目录文件.htm\",\"mimetype\":\"text/html\",\"size\":349870,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.htm\"},{\"id\":158,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.txt\",\"hash\":\"4fb5c4132a38bf42068b9cd58fa8419e792e786a4a4160faf8fabf33d623371f\",\"path\":\"/uploads/2024/08/07/目录文件.txt\",\"mimetype\":\"text/plain\",\"size\":413766,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.txt\"},{\"id\":159,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"时间线规则.xmind\",\"hash\":\"9e21393ff90f96b9570e6dc5d8f1b4ca148d520f738fea61d0e8633d86865cac\",\"path\":\"/uploads/2024/08/07/时间线规则.xmind\",\"mimetype\":\"application/octet-stream\",\"size\":47082,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/时间线规则.xmind\"},{\"id\":165,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"新建 PPT 演示文稿.ppt\",\"hash\":\"310b06ff0a793076844f8be83a752745b3915cd23e35427b88047b801be76424\",\"path\":\"/uploads/2024/08/07/新建 PPT 演示文稿.ppt\",\"mimetype\":\"application/vnd.ms-powerpoint\",\"size\":20992,\"uploadCount\":7,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/新建 PPT 演示文稿.ppt\"}],\"remark\":\"同一文件被多次上传时，只会保存一份至磁盘和增加一条附件记录；删除附件记录，将自动删除对应文件！\"}}',
    200,
    70,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    698,
    '2024-08-28 22:20:16.048944',
    '2024-08-28 22:20:16.048944',
    4,
    'admin',
    '附件管理',
    '::1',
    '',
    '/files/list?page=1&size=10',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"page\":1,\"size\":10,\"total\":15,\"records\":[{\"id\":151,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"oceans.mp4\",\"hash\":\"9f8f979374969429263495ffcaac832cd603b1efe4c66a05fafd6729dffef9af\",\"path\":\"/uploads/2024/08/07/oceans.mp4\",\"mimetype\":\"video/mp4\",\"size\":23014356,\"uploadCount\":15,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/oceans.mp4\"},{\"id\":152,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"财务记账系统excel表格.xlsx\",\"hash\":\"b55ab38ff825b0360bea155510d9fee9c41812fabfe7e9fdb0aa36714195e266\",\"path\":\"/uploads/2024/08/07/财务记账系统excel表格.xlsx\",\"mimetype\":\"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet\",\"size\":97475,\"uploadCount\":4,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/财务记账系统excel表格.xlsx\"},{\"id\":153,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"测试Markdown.md\",\"hash\":\"9bab5812e9c7319230796121a872f2f10d47878d985c83fe88abd9e0119f73b0\",\"path\":\"/uploads/2024/08/07/测试Markdown.md\",\"mimetype\":\"application/octet-stream\",\"size\":11364,\"uploadCount\":2,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/测试Markdown.md\"},{\"id\":154,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"image.jpeg\",\"hash\":\"a737ff09ec2ce204c6a1e0edfe5af0b0c3a81c07af5d31f900b1ff55b39a2201\",\"path\":\"/uploads/2024/08/07/image.jpeg\",\"mimetype\":\"image/jpeg\",\"size\":106111,\"uploadCount\":11,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/image.jpeg\"},{\"id\":155,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"changtu1.jpg\",\"hash\":\"0d83b5b689384e4e08721f873a1c981cdcddd3de0f7493b23c21cc28efa4efee\",\"path\":\"/uploads/2024/08/07/changtu1.jpg\",\"mimetype\":\"image/jpeg\",\"size\":48593,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/changtu1.jpg\"},{\"id\":156,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.doc\",\"hash\":\"b7dcfae78826ae565dfdd434145d3b74aca506738c0c31952370dd6b610b549d\",\"path\":\"/uploads/2024/08/07/目录文件.doc\",\"mimetype\":\"application/msword\",\"size\":1055816,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.doc\"},{\"id\":157,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.htm\",\"hash\":\"c8cc7106cc4a16fedf0bafe622e8ede5905ff4f9b3064f03ecab7980dcb72671\",\"path\":\"/uploads/2024/08/07/目录文件.htm\",\"mimetype\":\"text/html\",\"size\":349870,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.htm\"},{\"id\":158,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.txt\",\"hash\":\"4fb5c4132a38bf42068b9cd58fa8419e792e786a4a4160faf8fabf33d623371f\",\"path\":\"/uploads/2024/08/07/目录文件.txt\",\"mimetype\":\"text/plain\",\"size\":413766,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.txt\"},{\"id\":159,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"时间线规则.xmind\",\"hash\":\"9e21393ff90f96b9570e6dc5d8f1b4ca148d520f738fea61d0e8633d86865cac\",\"path\":\"/uploads/2024/08/07/时间线规则.xmind\",\"mimetype\":\"application/octet-stream\",\"size\":47082,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/时间线规则.xmind\"},{\"id\":165,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"新建 PPT 演示文稿.ppt\",\"hash\":\"310b06ff0a793076844f8be83a752745b3915cd23e35427b88047b801be76424\",\"path\":\"/uploads/2024/08/07/新建 PPT 演示文稿.ppt\",\"mimetype\":\"application/vnd.ms-powerpoint\",\"size\":20992,\"uploadCount\":7,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/新建 PPT 演示文稿.ppt\"}],\"remark\":\"同一文件被多次上传时，只会保存一份至磁盘和增加一条附件记录；删除附件记录，将自动删除对应文件！\"}}',
    200,
    71,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    699,
    '2024-08-28 22:20:20.620127',
    '2024-08-28 22:20:20.620127',
    4,
    'admin',
    '附件管理',
    '::1',
    '',
    '/files/list?page=1&size=10',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"page\":1,\"size\":10,\"total\":15,\"records\":[{\"id\":151,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"oceans.mp4\",\"hash\":\"9f8f979374969429263495ffcaac832cd603b1efe4c66a05fafd6729dffef9af\",\"path\":\"/uploads/2024/08/07/oceans.mp4\",\"mimetype\":\"video/mp4\",\"size\":23014356,\"uploadCount\":15,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/oceans.mp4\"},{\"id\":152,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"财务记账系统excel表格.xlsx\",\"hash\":\"b55ab38ff825b0360bea155510d9fee9c41812fabfe7e9fdb0aa36714195e266\",\"path\":\"/uploads/2024/08/07/财务记账系统excel表格.xlsx\",\"mimetype\":\"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet\",\"size\":97475,\"uploadCount\":4,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/财务记账系统excel表格.xlsx\"},{\"id\":153,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"测试Markdown.md\",\"hash\":\"9bab5812e9c7319230796121a872f2f10d47878d985c83fe88abd9e0119f73b0\",\"path\":\"/uploads/2024/08/07/测试Markdown.md\",\"mimetype\":\"application/octet-stream\",\"size\":11364,\"uploadCount\":2,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/测试Markdown.md\"},{\"id\":154,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"image.jpeg\",\"hash\":\"a737ff09ec2ce204c6a1e0edfe5af0b0c3a81c07af5d31f900b1ff55b39a2201\",\"path\":\"/uploads/2024/08/07/image.jpeg\",\"mimetype\":\"image/jpeg\",\"size\":106111,\"uploadCount\":11,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/image.jpeg\"},{\"id\":155,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"changtu1.jpg\",\"hash\":\"0d83b5b689384e4e08721f873a1c981cdcddd3de0f7493b23c21cc28efa4efee\",\"path\":\"/uploads/2024/08/07/changtu1.jpg\",\"mimetype\":\"image/jpeg\",\"size\":48593,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/changtu1.jpg\"},{\"id\":156,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.doc\",\"hash\":\"b7dcfae78826ae565dfdd434145d3b74aca506738c0c31952370dd6b610b549d\",\"path\":\"/uploads/2024/08/07/目录文件.doc\",\"mimetype\":\"application/msword\",\"size\":1055816,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.doc\"},{\"id\":157,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.htm\",\"hash\":\"c8cc7106cc4a16fedf0bafe622e8ede5905ff4f9b3064f03ecab7980dcb72671\",\"path\":\"/uploads/2024/08/07/目录文件.htm\",\"mimetype\":\"text/html\",\"size\":349870,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.htm\"},{\"id\":158,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.txt\",\"hash\":\"4fb5c4132a38bf42068b9cd58fa8419e792e786a4a4160faf8fabf33d623371f\",\"path\":\"/uploads/2024/08/07/目录文件.txt\",\"mimetype\":\"text/plain\",\"size\":413766,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.txt\"},{\"id\":159,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"时间线规则.xmind\",\"hash\":\"9e21393ff90f96b9570e6dc5d8f1b4ca148d520f738fea61d0e8633d86865cac\",\"path\":\"/uploads/2024/08/07/时间线规则.xmind\",\"mimetype\":\"application/octet-stream\",\"size\":47082,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/时间线规则.xmind\"},{\"id\":165,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"新建 PPT 演示文稿.ppt\",\"hash\":\"310b06ff0a793076844f8be83a752745b3915cd23e35427b88047b801be76424\",\"path\":\"/uploads/2024/08/07/新建 PPT 演示文稿.ppt\",\"mimetype\":\"application/vnd.ms-powerpoint\",\"size\":20992,\"uploadCount\":7,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/新建 PPT 演示文稿.ppt\"}],\"remark\":\"同一文件被多次上传时，只会保存一份至磁盘和增加一条附件记录；删除附件记录，将自动删除对应文件！\"}}',
    200,
    70,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    700,
    '2024-08-28 22:20:22.072809',
    '2024-08-28 22:20:22.072809',
    4,
    'admin',
    '附件管理',
    '::1',
    '',
    '/files/list?page=1&size=10',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"page\":1,\"size\":10,\"total\":15,\"records\":[{\"id\":151,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"oceans.mp4\",\"hash\":\"9f8f979374969429263495ffcaac832cd603b1efe4c66a05fafd6729dffef9af\",\"path\":\"/uploads/2024/08/07/oceans.mp4\",\"mimetype\":\"video/mp4\",\"size\":23014356,\"uploadCount\":15,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/oceans.mp4\"},{\"id\":152,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"财务记账系统excel表格.xlsx\",\"hash\":\"b55ab38ff825b0360bea155510d9fee9c41812fabfe7e9fdb0aa36714195e266\",\"path\":\"/uploads/2024/08/07/财务记账系统excel表格.xlsx\",\"mimetype\":\"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet\",\"size\":97475,\"uploadCount\":4,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/财务记账系统excel表格.xlsx\"},{\"id\":153,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"测试Markdown.md\",\"hash\":\"9bab5812e9c7319230796121a872f2f10d47878d985c83fe88abd9e0119f73b0\",\"path\":\"/uploads/2024/08/07/测试Markdown.md\",\"mimetype\":\"application/octet-stream\",\"size\":11364,\"uploadCount\":2,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/测试Markdown.md\"},{\"id\":154,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"image.jpeg\",\"hash\":\"a737ff09ec2ce204c6a1e0edfe5af0b0c3a81c07af5d31f900b1ff55b39a2201\",\"path\":\"/uploads/2024/08/07/image.jpeg\",\"mimetype\":\"image/jpeg\",\"size\":106111,\"uploadCount\":11,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/image.jpeg\"},{\"id\":155,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"changtu1.jpg\",\"hash\":\"0d83b5b689384e4e08721f873a1c981cdcddd3de0f7493b23c21cc28efa4efee\",\"path\":\"/uploads/2024/08/07/changtu1.jpg\",\"mimetype\":\"image/jpeg\",\"size\":48593,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/changtu1.jpg\"},{\"id\":156,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.doc\",\"hash\":\"b7dcfae78826ae565dfdd434145d3b74aca506738c0c31952370dd6b610b549d\",\"path\":\"/uploads/2024/08/07/目录文件.doc\",\"mimetype\":\"application/msword\",\"size\":1055816,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.doc\"},{\"id\":157,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.htm\",\"hash\":\"c8cc7106cc4a16fedf0bafe622e8ede5905ff4f9b3064f03ecab7980dcb72671\",\"path\":\"/uploads/2024/08/07/目录文件.htm\",\"mimetype\":\"text/html\",\"size\":349870,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.htm\"},{\"id\":158,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.txt\",\"hash\":\"4fb5c4132a38bf42068b9cd58fa8419e792e786a4a4160faf8fabf33d623371f\",\"path\":\"/uploads/2024/08/07/目录文件.txt\",\"mimetype\":\"text/plain\",\"size\":413766,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.txt\"},{\"id\":159,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"时间线规则.xmind\",\"hash\":\"9e21393ff90f96b9570e6dc5d8f1b4ca148d520f738fea61d0e8633d86865cac\",\"path\":\"/uploads/2024/08/07/时间线规则.xmind\",\"mimetype\":\"application/octet-stream\",\"size\":47082,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/时间线规则.xmind\"},{\"id\":165,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"新建 PPT 演示文稿.ppt\",\"hash\":\"310b06ff0a793076844f8be83a752745b3915cd23e35427b88047b801be76424\",\"path\":\"/uploads/2024/08/07/新建 PPT 演示文稿.ppt\",\"mimetype\":\"application/vnd.ms-powerpoint\",\"size\":20992,\"uploadCount\":7,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/新建 PPT 演示文稿.ppt\"}],\"remark\":\"同一文件被多次上传时，只会保存一份至磁盘和增加一条附件记录；删除附件记录，将自动删除对应文件！\"}}',
    200,
    70,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    701,
    '2024-08-28 22:21:07.383811',
    '2024-08-28 22:21:07.383811',
    4,
    'admin',
    '角色组管理',
    '::1',
    '',
    '/admin/role',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":1,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"超级管理员\",\"slug\":\"super_admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":0,\"children\":[{\"id\":9,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通管理员\",\"slug\":\"admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":1,\"children\":[{\"id\":10,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"超级会员\",\"slug\":\"super_member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":9,\"children\":[{\"id\":11,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通会员\",\"slug\":\"member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":10,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通用户\",\"slug\":\"user\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":11,\"children\":null}]}]}]}]}],\"remark\":null}}',
    200,
    76,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    702,
    '2024-08-28 22:22:24.410595',
    '2024-08-28 22:22:24.410595',
    4,
    'admin',
    '附件管理',
    '::1',
    '',
    '/files/list?page=1&size=10',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"page\":1,\"size\":10,\"total\":15,\"records\":[{\"id\":151,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"oceans.mp4\",\"hash\":\"9f8f979374969429263495ffcaac832cd603b1efe4c66a05fafd6729dffef9af\",\"path\":\"/uploads/2024/08/07/oceans.mp4\",\"mimetype\":\"video/mp4\",\"size\":23014356,\"uploadCount\":15,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/oceans.mp4\"},{\"id\":152,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"财务记账系统excel表格.xlsx\",\"hash\":\"b55ab38ff825b0360bea155510d9fee9c41812fabfe7e9fdb0aa36714195e266\",\"path\":\"/uploads/2024/08/07/财务记账系统excel表格.xlsx\",\"mimetype\":\"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet\",\"size\":97475,\"uploadCount\":4,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/财务记账系统excel表格.xlsx\"},{\"id\":153,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"测试Markdown.md\",\"hash\":\"9bab5812e9c7319230796121a872f2f10d47878d985c83fe88abd9e0119f73b0\",\"path\":\"/uploads/2024/08/07/测试Markdown.md\",\"mimetype\":\"application/octet-stream\",\"size\":11364,\"uploadCount\":2,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/测试Markdown.md\"},{\"id\":154,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"image.jpeg\",\"hash\":\"a737ff09ec2ce204c6a1e0edfe5af0b0c3a81c07af5d31f900b1ff55b39a2201\",\"path\":\"/uploads/2024/08/07/image.jpeg\",\"mimetype\":\"image/jpeg\",\"size\":106111,\"uploadCount\":11,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/image.jpeg\"},{\"id\":155,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"changtu1.jpg\",\"hash\":\"0d83b5b689384e4e08721f873a1c981cdcddd3de0f7493b23c21cc28efa4efee\",\"path\":\"/uploads/2024/08/07/changtu1.jpg\",\"mimetype\":\"image/jpeg\",\"size\":48593,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/changtu1.jpg\"},{\"id\":156,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.doc\",\"hash\":\"b7dcfae78826ae565dfdd434145d3b74aca506738c0c31952370dd6b610b549d\",\"path\":\"/uploads/2024/08/07/目录文件.doc\",\"mimetype\":\"application/msword\",\"size\":1055816,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.doc\"},{\"id\":157,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.htm\",\"hash\":\"c8cc7106cc4a16fedf0bafe622e8ede5905ff4f9b3064f03ecab7980dcb72671\",\"path\":\"/uploads/2024/08/07/目录文件.htm\",\"mimetype\":\"text/html\",\"size\":349870,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.htm\"},{\"id\":158,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.txt\",\"hash\":\"4fb5c4132a38bf42068b9cd58fa8419e792e786a4a4160faf8fabf33d623371f\",\"path\":\"/uploads/2024/08/07/目录文件.txt\",\"mimetype\":\"text/plain\",\"size\":413766,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.txt\"},{\"id\":159,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"时间线规则.xmind\",\"hash\":\"9e21393ff90f96b9570e6dc5d8f1b4ca148d520f738fea61d0e8633d86865cac\",\"path\":\"/uploads/2024/08/07/时间线规则.xmind\",\"mimetype\":\"application/octet-stream\",\"size\":47082,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/时间线规则.xmind\"},{\"id\":165,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"新建 PPT 演示文稿.ppt\",\"hash\":\"310b06ff0a793076844f8be83a752745b3915cd23e35427b88047b801be76424\",\"path\":\"/uploads/2024/08/07/新建 PPT 演示文稿.ppt\",\"mimetype\":\"application/vnd.ms-powerpoint\",\"size\":20992,\"uploadCount\":7,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/新建 PPT 演示文稿.ppt\"}],\"remark\":\"同一文件被多次上传时，只会保存一份至磁盘和增加一条附件记录；删除附件记录，将自动删除对应文件！\"}}',
    200,
    123,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    703,
    '2024-08-28 22:22:26.927315',
    '2024-08-28 22:22:26.927315',
    4,
    'admin',
    '附件管理',
    '::1',
    '',
    '/files/list?page=1&size=10',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"page\":1,\"size\":10,\"total\":15,\"records\":[{\"id\":151,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"oceans.mp4\",\"hash\":\"9f8f979374969429263495ffcaac832cd603b1efe4c66a05fafd6729dffef9af\",\"path\":\"/uploads/2024/08/07/oceans.mp4\",\"mimetype\":\"video/mp4\",\"size\":23014356,\"uploadCount\":15,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/oceans.mp4\"},{\"id\":152,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"财务记账系统excel表格.xlsx\",\"hash\":\"b55ab38ff825b0360bea155510d9fee9c41812fabfe7e9fdb0aa36714195e266\",\"path\":\"/uploads/2024/08/07/财务记账系统excel表格.xlsx\",\"mimetype\":\"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet\",\"size\":97475,\"uploadCount\":4,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/财务记账系统excel表格.xlsx\"},{\"id\":153,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"测试Markdown.md\",\"hash\":\"9bab5812e9c7319230796121a872f2f10d47878d985c83fe88abd9e0119f73b0\",\"path\":\"/uploads/2024/08/07/测试Markdown.md\",\"mimetype\":\"application/octet-stream\",\"size\":11364,\"uploadCount\":2,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/测试Markdown.md\"},{\"id\":154,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"image.jpeg\",\"hash\":\"a737ff09ec2ce204c6a1e0edfe5af0b0c3a81c07af5d31f900b1ff55b39a2201\",\"path\":\"/uploads/2024/08/07/image.jpeg\",\"mimetype\":\"image/jpeg\",\"size\":106111,\"uploadCount\":11,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/image.jpeg\"},{\"id\":155,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"changtu1.jpg\",\"hash\":\"0d83b5b689384e4e08721f873a1c981cdcddd3de0f7493b23c21cc28efa4efee\",\"path\":\"/uploads/2024/08/07/changtu1.jpg\",\"mimetype\":\"image/jpeg\",\"size\":48593,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/changtu1.jpg\"},{\"id\":156,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.doc\",\"hash\":\"b7dcfae78826ae565dfdd434145d3b74aca506738c0c31952370dd6b610b549d\",\"path\":\"/uploads/2024/08/07/目录文件.doc\",\"mimetype\":\"application/msword\",\"size\":1055816,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.doc\"},{\"id\":157,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.htm\",\"hash\":\"c8cc7106cc4a16fedf0bafe622e8ede5905ff4f9b3064f03ecab7980dcb72671\",\"path\":\"/uploads/2024/08/07/目录文件.htm\",\"mimetype\":\"text/html\",\"size\":349870,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.htm\"},{\"id\":158,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.txt\",\"hash\":\"4fb5c4132a38bf42068b9cd58fa8419e792e786a4a4160faf8fabf33d623371f\",\"path\":\"/uploads/2024/08/07/目录文件.txt\",\"mimetype\":\"text/plain\",\"size\":413766,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.txt\"},{\"id\":159,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"时间线规则.xmind\",\"hash\":\"9e21393ff90f96b9570e6dc5d8f1b4ca148d520f738fea61d0e8633d86865cac\",\"path\":\"/uploads/2024/08/07/时间线规则.xmind\",\"mimetype\":\"application/octet-stream\",\"size\":47082,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/时间线规则.xmind\"},{\"id\":165,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"新建 PPT 演示文稿.ppt\",\"hash\":\"310b06ff0a793076844f8be83a752745b3915cd23e35427b88047b801be76424\",\"path\":\"/uploads/2024/08/07/新建 PPT 演示文稿.ppt\",\"mimetype\":\"application/vnd.ms-powerpoint\",\"size\":20992,\"uploadCount\":7,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/新建 PPT 演示文稿.ppt\"}],\"remark\":\"同一文件被多次上传时，只会保存一份至磁盘和增加一条附件记录；删除附件记录，将自动删除对应文件！\"}}',
    200,
    73,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    704,
    '2024-08-28 22:22:48.036544',
    '2024-08-28 22:22:48.036544',
    4,
    'admin',
    '附件管理',
    '::1',
    '',
    '/files/list?page=1&size=10',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"page\":1,\"size\":10,\"total\":15,\"records\":[{\"id\":151,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"oceans.mp4\",\"hash\":\"9f8f979374969429263495ffcaac832cd603b1efe4c66a05fafd6729dffef9af\",\"path\":\"/uploads/2024/08/07/oceans.mp4\",\"mimetype\":\"video/mp4\",\"size\":23014356,\"uploadCount\":15,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/oceans.mp4\"},{\"id\":152,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"财务记账系统excel表格.xlsx\",\"hash\":\"b55ab38ff825b0360bea155510d9fee9c41812fabfe7e9fdb0aa36714195e266\",\"path\":\"/uploads/2024/08/07/财务记账系统excel表格.xlsx\",\"mimetype\":\"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet\",\"size\":97475,\"uploadCount\":4,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/财务记账系统excel表格.xlsx\"},{\"id\":153,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"测试Markdown.md\",\"hash\":\"9bab5812e9c7319230796121a872f2f10d47878d985c83fe88abd9e0119f73b0\",\"path\":\"/uploads/2024/08/07/测试Markdown.md\",\"mimetype\":\"application/octet-stream\",\"size\":11364,\"uploadCount\":2,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/测试Markdown.md\"},{\"id\":154,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"image.jpeg\",\"hash\":\"a737ff09ec2ce204c6a1e0edfe5af0b0c3a81c07af5d31f900b1ff55b39a2201\",\"path\":\"/uploads/2024/08/07/image.jpeg\",\"mimetype\":\"image/jpeg\",\"size\":106111,\"uploadCount\":11,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/image.jpeg\"},{\"id\":155,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"changtu1.jpg\",\"hash\":\"0d83b5b689384e4e08721f873a1c981cdcddd3de0f7493b23c21cc28efa4efee\",\"path\":\"/uploads/2024/08/07/changtu1.jpg\",\"mimetype\":\"image/jpeg\",\"size\":48593,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/changtu1.jpg\"},{\"id\":156,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.doc\",\"hash\":\"b7dcfae78826ae565dfdd434145d3b74aca506738c0c31952370dd6b610b549d\",\"path\":\"/uploads/2024/08/07/目录文件.doc\",\"mimetype\":\"application/msword\",\"size\":1055816,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.doc\"},{\"id\":157,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.htm\",\"hash\":\"c8cc7106cc4a16fedf0bafe622e8ede5905ff4f9b3064f03ecab7980dcb72671\",\"path\":\"/uploads/2024/08/07/目录文件.htm\",\"mimetype\":\"text/html\",\"size\":349870,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.htm\"},{\"id\":158,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.txt\",\"hash\":\"4fb5c4132a38bf42068b9cd58fa8419e792e786a4a4160faf8fabf33d623371f\",\"path\":\"/uploads/2024/08/07/目录文件.txt\",\"mimetype\":\"text/plain\",\"size\":413766,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.txt\"},{\"id\":159,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"时间线规则.xmind\",\"hash\":\"9e21393ff90f96b9570e6dc5d8f1b4ca148d520f738fea61d0e8633d86865cac\",\"path\":\"/uploads/2024/08/07/时间线规则.xmind\",\"mimetype\":\"application/octet-stream\",\"size\":47082,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/时间线规则.xmind\"},{\"id\":165,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"新建 PPT 演示文稿.ppt\",\"hash\":\"310b06ff0a793076844f8be83a752745b3915cd23e35427b88047b801be76424\",\"path\":\"/uploads/2024/08/07/新建 PPT 演示文稿.ppt\",\"mimetype\":\"application/vnd.ms-powerpoint\",\"size\":20992,\"uploadCount\":7,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/新建 PPT 演示文稿.ppt\"}],\"remark\":\"同一文件被多次上传时，只会保存一份至磁盘和增加一条附件记录；删除附件记录，将自动删除对应文件！\"}}',
    200,
    73,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    705,
    '2024-08-28 22:22:52.832972',
    '2024-08-28 22:22:52.832972',
    4,
    'admin',
    '管理员管理-详情',
    '::1',
    '',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    72,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    706,
    '2024-08-28 22:23:09.338691',
    '2024-08-28 22:23:09.338691',
    4,
    'admin',
    '管理员管理-详情',
    '::1',
    '',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    85,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    707,
    '2024-08-28 22:26:38.545401',
    '2024-08-28 22:26:38.545401',
    4,
    'admin',
    '管理员管理-详情',
    '::1',
    '',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    145,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    708,
    '2024-08-28 22:26:38.610771',
    '2024-08-28 22:26:38.610771',
    4,
    'admin',
    '附件管理',
    '::1',
    '',
    '/files/list?page=1&size=10',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"page\":1,\"size\":10,\"total\":15,\"records\":[{\"id\":151,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"oceans.mp4\",\"hash\":\"9f8f979374969429263495ffcaac832cd603b1efe4c66a05fafd6729dffef9af\",\"path\":\"/uploads/2024/08/07/oceans.mp4\",\"mimetype\":\"video/mp4\",\"size\":23014356,\"uploadCount\":15,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/oceans.mp4\"},{\"id\":152,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"财务记账系统excel表格.xlsx\",\"hash\":\"b55ab38ff825b0360bea155510d9fee9c41812fabfe7e9fdb0aa36714195e266\",\"path\":\"/uploads/2024/08/07/财务记账系统excel表格.xlsx\",\"mimetype\":\"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet\",\"size\":97475,\"uploadCount\":4,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/财务记账系统excel表格.xlsx\"},{\"id\":153,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"测试Markdown.md\",\"hash\":\"9bab5812e9c7319230796121a872f2f10d47878d985c83fe88abd9e0119f73b0\",\"path\":\"/uploads/2024/08/07/测试Markdown.md\",\"mimetype\":\"application/octet-stream\",\"size\":11364,\"uploadCount\":2,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/测试Markdown.md\"},{\"id\":154,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"image.jpeg\",\"hash\":\"a737ff09ec2ce204c6a1e0edfe5af0b0c3a81c07af5d31f900b1ff55b39a2201\",\"path\":\"/uploads/2024/08/07/image.jpeg\",\"mimetype\":\"image/jpeg\",\"size\":106111,\"uploadCount\":11,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/image.jpeg\"},{\"id\":155,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"changtu1.jpg\",\"hash\":\"0d83b5b689384e4e08721f873a1c981cdcddd3de0f7493b23c21cc28efa4efee\",\"path\":\"/uploads/2024/08/07/changtu1.jpg\",\"mimetype\":\"image/jpeg\",\"size\":48593,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/changtu1.jpg\"},{\"id\":156,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.doc\",\"hash\":\"b7dcfae78826ae565dfdd434145d3b74aca506738c0c31952370dd6b610b549d\",\"path\":\"/uploads/2024/08/07/目录文件.doc\",\"mimetype\":\"application/msword\",\"size\":1055816,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.doc\"},{\"id\":157,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.htm\",\"hash\":\"c8cc7106cc4a16fedf0bafe622e8ede5905ff4f9b3064f03ecab7980dcb72671\",\"path\":\"/uploads/2024/08/07/目录文件.htm\",\"mimetype\":\"text/html\",\"size\":349870,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.htm\"},{\"id\":158,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.txt\",\"hash\":\"4fb5c4132a38bf42068b9cd58fa8419e792e786a4a4160faf8fabf33d623371f\",\"path\":\"/uploads/2024/08/07/目录文件.txt\",\"mimetype\":\"text/plain\",\"size\":413766,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.txt\"},{\"id\":159,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"时间线规则.xmind\",\"hash\":\"9e21393ff90f96b9570e6dc5d8f1b4ca148d520f738fea61d0e8633d86865cac\",\"path\":\"/uploads/2024/08/07/时间线规则.xmind\",\"mimetype\":\"application/octet-stream\",\"size\":47082,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/时间线规则.xmind\"},{\"id\":165,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"新建 PPT 演示文稿.ppt\",\"hash\":\"310b06ff0a793076844f8be83a752745b3915cd23e35427b88047b801be76424\",\"path\":\"/uploads/2024/08/07/新建 PPT 演示文稿.ppt\",\"mimetype\":\"application/vnd.ms-powerpoint\",\"size\":20992,\"uploadCount\":7,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/新建 PPT 演示文稿.ppt\"}],\"remark\":\"同一文件被多次上传时，只会保存一份至磁盘和增加一条附件记录；删除附件记录，将自动删除对应文件！\"}}',
    200,
    200,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    709,
    '2024-08-28 22:26:46.953977',
    '2024-08-28 22:26:46.953977',
    4,
    'admin',
    '附件管理',
    '::1',
    '',
    '/files/list?page=1&size=10',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"page\":1,\"size\":10,\"total\":15,\"records\":[{\"id\":151,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"oceans.mp4\",\"hash\":\"9f8f979374969429263495ffcaac832cd603b1efe4c66a05fafd6729dffef9af\",\"path\":\"/uploads/2024/08/07/oceans.mp4\",\"mimetype\":\"video/mp4\",\"size\":23014356,\"uploadCount\":15,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/oceans.mp4\"},{\"id\":152,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"财务记账系统excel表格.xlsx\",\"hash\":\"b55ab38ff825b0360bea155510d9fee9c41812fabfe7e9fdb0aa36714195e266\",\"path\":\"/uploads/2024/08/07/财务记账系统excel表格.xlsx\",\"mimetype\":\"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet\",\"size\":97475,\"uploadCount\":4,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/财务记账系统excel表格.xlsx\"},{\"id\":153,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"测试Markdown.md\",\"hash\":\"9bab5812e9c7319230796121a872f2f10d47878d985c83fe88abd9e0119f73b0\",\"path\":\"/uploads/2024/08/07/测试Markdown.md\",\"mimetype\":\"application/octet-stream\",\"size\":11364,\"uploadCount\":2,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/测试Markdown.md\"},{\"id\":154,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"image.jpeg\",\"hash\":\"a737ff09ec2ce204c6a1e0edfe5af0b0c3a81c07af5d31f900b1ff55b39a2201\",\"path\":\"/uploads/2024/08/07/image.jpeg\",\"mimetype\":\"image/jpeg\",\"size\":106111,\"uploadCount\":11,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/image.jpeg\"},{\"id\":155,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"changtu1.jpg\",\"hash\":\"0d83b5b689384e4e08721f873a1c981cdcddd3de0f7493b23c21cc28efa4efee\",\"path\":\"/uploads/2024/08/07/changtu1.jpg\",\"mimetype\":\"image/jpeg\",\"size\":48593,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/changtu1.jpg\"},{\"id\":156,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.doc\",\"hash\":\"b7dcfae78826ae565dfdd434145d3b74aca506738c0c31952370dd6b610b549d\",\"path\":\"/uploads/2024/08/07/目录文件.doc\",\"mimetype\":\"application/msword\",\"size\":1055816,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.doc\"},{\"id\":157,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.htm\",\"hash\":\"c8cc7106cc4a16fedf0bafe622e8ede5905ff4f9b3064f03ecab7980dcb72671\",\"path\":\"/uploads/2024/08/07/目录文件.htm\",\"mimetype\":\"text/html\",\"size\":349870,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.htm\"},{\"id\":158,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.txt\",\"hash\":\"4fb5c4132a38bf42068b9cd58fa8419e792e786a4a4160faf8fabf33d623371f\",\"path\":\"/uploads/2024/08/07/目录文件.txt\",\"mimetype\":\"text/plain\",\"size\":413766,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.txt\"},{\"id\":159,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"时间线规则.xmind\",\"hash\":\"9e21393ff90f96b9570e6dc5d8f1b4ca148d520f738fea61d0e8633d86865cac\",\"path\":\"/uploads/2024/08/07/时间线规则.xmind\",\"mimetype\":\"application/octet-stream\",\"size\":47082,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/时间线规则.xmind\"},{\"id\":165,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"新建 PPT 演示文稿.ppt\",\"hash\":\"310b06ff0a793076844f8be83a752745b3915cd23e35427b88047b801be76424\",\"path\":\"/uploads/2024/08/07/新建 PPT 演示文稿.ppt\",\"mimetype\":\"application/vnd.ms-powerpoint\",\"size\":20992,\"uploadCount\":7,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/新建 PPT 演示文稿.ppt\"}],\"remark\":\"同一文件被多次上传时，只会保存一份至磁盘和增加一条附件记录；删除附件记录，将自动删除对应文件！\"}}',
    200,
    72,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    710,
    '2024-08-28 22:29:46.620481',
    '2024-08-28 22:29:46.620481',
    4,
    'admin',
    'refresh刷新token',
    '::1',
    '',
    '/admin/refresh?refreshToken=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJpYXQiOjE3MjQ4NTM0OTUsImV4cCI6MTcyNTQ1ODI5NX0.4AVe_9S4bUVLuGNQJqxnurFI_-FW4_Hyt8ONZd9FrBY',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"accessToken\":\"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJyb2xlcyI6WyLotoXnuqfnrqHnkIblkZgiXSwicGVybWlzc2lvbnMiOlsidXNlcl9ncm91cCIsImF1dGgiLCJhdXRoX2dyb3VwIiwiYXV0aF9sb2ciLCJ1c2VyIiwiYXV0aF9tZW51IiwiYXV0aF9hZG1pbiIsInVzZXJfaW5kZXgiLCJ1c2VyX3J1bGUiLCJ1c2VyX2xvZyIsInJvdXRpbmUiLCJyb3V0aW5lX2NvbmZpZyIsInJvdXRpbmVfYW5uZXgiLCJyb3V0aW5lX2luZm8iLCJtb2R1bGUiLCJhdXRoX2dyb3VwX2NyZWF0ZSIsImF1dGhfZ3JvdXBfdXBkYXRlIiwiYXV0aF9ncm91cF9pbmZvIiwiYXV0aF9ncm91cF9kZWxldGUiLCJhdXRoX2FkbWluX2NyZWF0ZSIsImF1dGhfYWRtaW5fdXBkYXRlIiwiYXV0aF9hZG1pbl9pbmZvIiwiYXV0aF9hZG1pbl9kZWxldGUiLCJob21lIl0sImFjY2Vzc1Rva2VuIjp0cnVlLCJpYXQiOjE3MjQ4NTUzODUsImV4cCI6MTcyNDg1NzE4NX0.fj-_Kp_qK4mc4GMKri-p9TRphP_C7TFmw7rU4rudfKE\",\"refreshToken\":\"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJpYXQiOjE3MjQ4NTUzODUsImV4cCI6MTcyNTQ2MDE4NX0.JM27yCAZZwVRItyfz9Ugoz5Mz-X8oKfloeHwG6fjva8\"}}',
    200,
    164,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    711,
    '2024-08-28 22:29:46.834998',
    '2024-08-28 22:29:46.834998',
    4,
    'admin',
    '管理员管理-详情',
    '::1',
    '',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    198,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    712,
    '2024-08-28 22:33:42.355751',
    '2024-08-28 22:33:42.355751',
    4,
    'admin',
    '附件管理',
    '::1',
    '',
    '/files/list?page=1&size=10',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"page\":1,\"size\":10,\"total\":15,\"records\":[{\"id\":151,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"oceans.mp4\",\"hash\":\"9f8f979374969429263495ffcaac832cd603b1efe4c66a05fafd6729dffef9af\",\"path\":\"/uploads/2024/08/07/oceans.mp4\",\"mimetype\":\"video/mp4\",\"size\":23014356,\"uploadCount\":15,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/oceans.mp4\"},{\"id\":152,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"财务记账系统excel表格.xlsx\",\"hash\":\"b55ab38ff825b0360bea155510d9fee9c41812fabfe7e9fdb0aa36714195e266\",\"path\":\"/uploads/2024/08/07/财务记账系统excel表格.xlsx\",\"mimetype\":\"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet\",\"size\":97475,\"uploadCount\":4,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/财务记账系统excel表格.xlsx\"},{\"id\":153,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"测试Markdown.md\",\"hash\":\"9bab5812e9c7319230796121a872f2f10d47878d985c83fe88abd9e0119f73b0\",\"path\":\"/uploads/2024/08/07/测试Markdown.md\",\"mimetype\":\"application/octet-stream\",\"size\":11364,\"uploadCount\":2,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/测试Markdown.md\"},{\"id\":154,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"image.jpeg\",\"hash\":\"a737ff09ec2ce204c6a1e0edfe5af0b0c3a81c07af5d31f900b1ff55b39a2201\",\"path\":\"/uploads/2024/08/07/image.jpeg\",\"mimetype\":\"image/jpeg\",\"size\":106111,\"uploadCount\":11,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/image.jpeg\"},{\"id\":155,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"changtu1.jpg\",\"hash\":\"0d83b5b689384e4e08721f873a1c981cdcddd3de0f7493b23c21cc28efa4efee\",\"path\":\"/uploads/2024/08/07/changtu1.jpg\",\"mimetype\":\"image/jpeg\",\"size\":48593,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/changtu1.jpg\"},{\"id\":156,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.doc\",\"hash\":\"b7dcfae78826ae565dfdd434145d3b74aca506738c0c31952370dd6b610b549d\",\"path\":\"/uploads/2024/08/07/目录文件.doc\",\"mimetype\":\"application/msword\",\"size\":1055816,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.doc\"},{\"id\":157,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.htm\",\"hash\":\"c8cc7106cc4a16fedf0bafe622e8ede5905ff4f9b3064f03ecab7980dcb72671\",\"path\":\"/uploads/2024/08/07/目录文件.htm\",\"mimetype\":\"text/html\",\"size\":349870,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.htm\"},{\"id\":158,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.txt\",\"hash\":\"4fb5c4132a38bf42068b9cd58fa8419e792e786a4a4160faf8fabf33d623371f\",\"path\":\"/uploads/2024/08/07/目录文件.txt\",\"mimetype\":\"text/plain\",\"size\":413766,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.txt\"},{\"id\":159,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"时间线规则.xmind\",\"hash\":\"9e21393ff90f96b9570e6dc5d8f1b4ca148d520f738fea61d0e8633d86865cac\",\"path\":\"/uploads/2024/08/07/时间线规则.xmind\",\"mimetype\":\"application/octet-stream\",\"size\":47082,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/时间线规则.xmind\"},{\"id\":165,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"新建 PPT 演示文稿.ppt\",\"hash\":\"310b06ff0a793076844f8be83a752745b3915cd23e35427b88047b801be76424\",\"path\":\"/uploads/2024/08/07/新建 PPT 演示文稿.ppt\",\"mimetype\":\"application/vnd.ms-powerpoint\",\"size\":20992,\"uploadCount\":7,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/新建 PPT 演示文稿.ppt\"}],\"remark\":\"同一文件被多次上传时，只会保存一份至磁盘和增加一条附件记录；删除附件记录，将自动删除对应文件！\"}}',
    200,
    127,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    713,
    '2024-08-28 22:33:44.904700',
    '2024-08-28 22:33:44.904700',
    4,
    'admin',
    '附件管理',
    '::1',
    '',
    '/files/list?page=1&size=10',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"page\":1,\"size\":10,\"total\":15,\"records\":[{\"id\":151,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"oceans.mp4\",\"hash\":\"9f8f979374969429263495ffcaac832cd603b1efe4c66a05fafd6729dffef9af\",\"path\":\"/uploads/2024/08/07/oceans.mp4\",\"mimetype\":\"video/mp4\",\"size\":23014356,\"uploadCount\":15,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/oceans.mp4\"},{\"id\":152,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"财务记账系统excel表格.xlsx\",\"hash\":\"b55ab38ff825b0360bea155510d9fee9c41812fabfe7e9fdb0aa36714195e266\",\"path\":\"/uploads/2024/08/07/财务记账系统excel表格.xlsx\",\"mimetype\":\"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet\",\"size\":97475,\"uploadCount\":4,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/财务记账系统excel表格.xlsx\"},{\"id\":153,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"测试Markdown.md\",\"hash\":\"9bab5812e9c7319230796121a872f2f10d47878d985c83fe88abd9e0119f73b0\",\"path\":\"/uploads/2024/08/07/测试Markdown.md\",\"mimetype\":\"application/octet-stream\",\"size\":11364,\"uploadCount\":2,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/测试Markdown.md\"},{\"id\":154,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"image.jpeg\",\"hash\":\"a737ff09ec2ce204c6a1e0edfe5af0b0c3a81c07af5d31f900b1ff55b39a2201\",\"path\":\"/uploads/2024/08/07/image.jpeg\",\"mimetype\":\"image/jpeg\",\"size\":106111,\"uploadCount\":11,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/image.jpeg\"},{\"id\":155,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"changtu1.jpg\",\"hash\":\"0d83b5b689384e4e08721f873a1c981cdcddd3de0f7493b23c21cc28efa4efee\",\"path\":\"/uploads/2024/08/07/changtu1.jpg\",\"mimetype\":\"image/jpeg\",\"size\":48593,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/changtu1.jpg\"},{\"id\":156,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.doc\",\"hash\":\"b7dcfae78826ae565dfdd434145d3b74aca506738c0c31952370dd6b610b549d\",\"path\":\"/uploads/2024/08/07/目录文件.doc\",\"mimetype\":\"application/msword\",\"size\":1055816,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.doc\"},{\"id\":157,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.htm\",\"hash\":\"c8cc7106cc4a16fedf0bafe622e8ede5905ff4f9b3064f03ecab7980dcb72671\",\"path\":\"/uploads/2024/08/07/目录文件.htm\",\"mimetype\":\"text/html\",\"size\":349870,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.htm\"},{\"id\":158,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.txt\",\"hash\":\"4fb5c4132a38bf42068b9cd58fa8419e792e786a4a4160faf8fabf33d623371f\",\"path\":\"/uploads/2024/08/07/目录文件.txt\",\"mimetype\":\"text/plain\",\"size\":413766,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.txt\"},{\"id\":159,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"时间线规则.xmind\",\"hash\":\"9e21393ff90f96b9570e6dc5d8f1b4ca148d520f738fea61d0e8633d86865cac\",\"path\":\"/uploads/2024/08/07/时间线规则.xmind\",\"mimetype\":\"application/octet-stream\",\"size\":47082,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/时间线规则.xmind\"},{\"id\":165,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"新建 PPT 演示文稿.ppt\",\"hash\":\"310b06ff0a793076844f8be83a752745b3915cd23e35427b88047b801be76424\",\"path\":\"/uploads/2024/08/07/新建 PPT 演示文稿.ppt\",\"mimetype\":\"application/vnd.ms-powerpoint\",\"size\":20992,\"uploadCount\":7,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/新建 PPT 演示文稿.ppt\"}],\"remark\":\"同一文件被多次上传时，只会保存一份至磁盘和增加一条附件记录；删除附件记录，将自动删除对应文件！\"}}',
    200,
    81,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    714,
    '2024-08-28 22:33:47.347509',
    '2024-08-28 22:33:47.347509',
    4,
    'admin',
    '附件管理',
    '::1',
    '',
    '/files/list?page=1&size=10',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"page\":1,\"size\":10,\"total\":15,\"records\":[{\"id\":151,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"oceans.mp4\",\"hash\":\"9f8f979374969429263495ffcaac832cd603b1efe4c66a05fafd6729dffef9af\",\"path\":\"/uploads/2024/08/07/oceans.mp4\",\"mimetype\":\"video/mp4\",\"size\":23014356,\"uploadCount\":15,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/oceans.mp4\"},{\"id\":152,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"财务记账系统excel表格.xlsx\",\"hash\":\"b55ab38ff825b0360bea155510d9fee9c41812fabfe7e9fdb0aa36714195e266\",\"path\":\"/uploads/2024/08/07/财务记账系统excel表格.xlsx\",\"mimetype\":\"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet\",\"size\":97475,\"uploadCount\":4,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/财务记账系统excel表格.xlsx\"},{\"id\":153,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"测试Markdown.md\",\"hash\":\"9bab5812e9c7319230796121a872f2f10d47878d985c83fe88abd9e0119f73b0\",\"path\":\"/uploads/2024/08/07/测试Markdown.md\",\"mimetype\":\"application/octet-stream\",\"size\":11364,\"uploadCount\":2,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/测试Markdown.md\"},{\"id\":154,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"image.jpeg\",\"hash\":\"a737ff09ec2ce204c6a1e0edfe5af0b0c3a81c07af5d31f900b1ff55b39a2201\",\"path\":\"/uploads/2024/08/07/image.jpeg\",\"mimetype\":\"image/jpeg\",\"size\":106111,\"uploadCount\":11,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/image.jpeg\"},{\"id\":155,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"changtu1.jpg\",\"hash\":\"0d83b5b689384e4e08721f873a1c981cdcddd3de0f7493b23c21cc28efa4efee\",\"path\":\"/uploads/2024/08/07/changtu1.jpg\",\"mimetype\":\"image/jpeg\",\"size\":48593,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/changtu1.jpg\"},{\"id\":156,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.doc\",\"hash\":\"b7dcfae78826ae565dfdd434145d3b74aca506738c0c31952370dd6b610b549d\",\"path\":\"/uploads/2024/08/07/目录文件.doc\",\"mimetype\":\"application/msword\",\"size\":1055816,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.doc\"},{\"id\":157,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.htm\",\"hash\":\"c8cc7106cc4a16fedf0bafe622e8ede5905ff4f9b3064f03ecab7980dcb72671\",\"path\":\"/uploads/2024/08/07/目录文件.htm\",\"mimetype\":\"text/html\",\"size\":349870,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.htm\"},{\"id\":158,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.txt\",\"hash\":\"4fb5c4132a38bf42068b9cd58fa8419e792e786a4a4160faf8fabf33d623371f\",\"path\":\"/uploads/2024/08/07/目录文件.txt\",\"mimetype\":\"text/plain\",\"size\":413766,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.txt\"},{\"id\":159,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"时间线规则.xmind\",\"hash\":\"9e21393ff90f96b9570e6dc5d8f1b4ca148d520f738fea61d0e8633d86865cac\",\"path\":\"/uploads/2024/08/07/时间线规则.xmind\",\"mimetype\":\"application/octet-stream\",\"size\":47082,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/时间线规则.xmind\"},{\"id\":165,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"新建 PPT 演示文稿.ppt\",\"hash\":\"310b06ff0a793076844f8be83a752745b3915cd23e35427b88047b801be76424\",\"path\":\"/uploads/2024/08/07/新建 PPT 演示文稿.ppt\",\"mimetype\":\"application/vnd.ms-powerpoint\",\"size\":20992,\"uploadCount\":7,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/新建 PPT 演示文稿.ppt\"}],\"remark\":\"同一文件被多次上传时，只会保存一份至磁盘和增加一条附件记录；删除附件记录，将自动删除对应文件！\"}}',
    200,
    83,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    715,
    '2024-09-02 09:24:25.086441',
    '2024-09-02 09:24:25.086441',
    4,
    'admin',
    'refresh刷新token',
    '127.0.0.1',
    '内网IP',
    '/admin/refresh?refreshToken=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJpYXQiOjE3MjQ4MzkwMTgsImV4cCI6MTcyNTQ0MzgxOH0.KqK_sgMN3I1RUE2J09grhI8usNp2F9dG1BQL3m3iAKA',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"accessToken\":\"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJyb2xlcyI6WyLotoXnuqfnrqHnkIblkZgiXSwicGVybWlzc2lvbnMiOlsidXNlcl9ncm91cCIsImF1dGgiLCJhdXRoX2dyb3VwIiwiYXV0aF9sb2ciLCJ1c2VyIiwiYXV0aF9tZW51IiwiYXV0aF9hZG1pbiIsInVzZXJfaW5kZXgiLCJ1c2VyX3J1bGUiLCJ1c2VyX2xvZyIsInJvdXRpbmUiLCJyb3V0aW5lX2NvbmZpZyIsInJvdXRpbmVfYW5uZXgiLCJyb3V0aW5lX2luZm8iLCJtb2R1bGUiLCJhdXRoX2dyb3VwX2NyZWF0ZSIsImF1dGhfZ3JvdXBfdXBkYXRlIiwiYXV0aF9ncm91cF9pbmZvIiwiYXV0aF9ncm91cF9kZWxldGUiLCJhdXRoX2FkbWluX2NyZWF0ZSIsImF1dGhfYWRtaW5fdXBkYXRlIiwiYXV0aF9hZG1pbl9pbmZvIiwiYXV0aF9hZG1pbl9kZWxldGUiLCJob21lIl0sImFjY2Vzc1Rva2VuIjp0cnVlLCJpYXQiOjE3MjUyNDAzMTYsImV4cCI6MTcyNTI0MjExNn0.ocWAirWHA7h5d2rB31hDR86FUCTfaoa4m0E_N9Irgfg\",\"refreshToken\":\"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJpYXQiOjE3MjUyNDAzMTYsImV4cCI6MTcyNTg0NTExNn0.hYxvbZjAtOQTlUCmcjPBCXVwEx0rxeuyfbMGD2CoSUY\"}}',
    200,
    179,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    716,
    '2024-09-02 09:24:25.281811',
    '2024-09-02 09:24:25.281811',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    181,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    717,
    '2024-09-02 09:24:25.320794',
    '2024-09-02 09:24:25.320794',
    4,
    'admin',
    '角色组管理',
    '127.0.0.1',
    '内网IP',
    '/admin/role',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":1,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"超级管理员\",\"slug\":\"super_admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":0,\"children\":[{\"id\":9,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通管理员\",\"slug\":\"admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":1,\"children\":[{\"id\":10,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"超级会员\",\"slug\":\"super_member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":9,\"children\":[{\"id\":11,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通会员\",\"slug\":\"member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":10,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通用户\",\"slug\":\"user\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":11,\"children\":null}]}]}]}]}],\"remark\":null}}',
    200,
    214,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    718,
    '2024-09-02 09:24:33.129136',
    '2024-09-02 09:24:33.129136',
    4,
    'admin',
    '角色组管理',
    '127.0.0.1',
    '内网IP',
    '/admin/role',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":1,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"超级管理员\",\"slug\":\"super_admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":0,\"children\":[{\"id\":9,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通管理员\",\"slug\":\"admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":1,\"children\":[{\"id\":10,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"超级会员\",\"slug\":\"super_member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":9,\"children\":[{\"id\":11,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通会员\",\"slug\":\"member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":10,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通用户\",\"slug\":\"user\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":11,\"children\":null}]}]}]}]}],\"remark\":null}}',
    200,
    82,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    719,
    '2024-09-02 09:24:34.390589',
    '2024-09-02 09:24:34.390589',
    4,
    'admin',
    '角色组管理',
    '127.0.0.1',
    '内网IP',
    '/admin/role',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"records\":[{\"id\":1,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"超级管理员\",\"slug\":\"super_admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":0,\"children\":[{\"id\":9,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通管理员\",\"slug\":\"admin\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":1,\"children\":[{\"id\":10,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"超级会员\",\"slug\":\"super_member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":9,\"children\":[{\"id\":11,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通会员\",\"slug\":\"member\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":10,\"children\":[{\"id\":12,\"updateTime\":\"2024-08-27 02:19:49\",\"createTime\":\"2024-08-27 02:19:49\",\"name\":\"普通用户\",\"slug\":\"user\",\"description\":null,\"sort\":99,\"status\":1,\"parentId\":11,\"children\":null}]}]}]}]}],\"remark\":null}}',
    200,
    89,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    720,
    '2024-09-02 09:24:34.390755',
    '2024-09-02 09:24:34.390755',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    99,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    721,
    '2024-09-02 09:24:39.620778',
    '2024-09-02 09:24:39.620778',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    85,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    722,
    '2024-09-02 09:35:16.896169',
    '2024-09-02 09:35:16.896169',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    135,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    723,
    '2024-09-02 09:35:19.803107',
    '2024-09-02 09:35:19.803107',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    84,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    724,
    '2024-09-02 10:04:36.719572',
    '2024-09-02 10:04:36.719572',
    4,
    'admin',
    'refresh刷新token',
    '127.0.0.1',
    '内网IP',
    '/admin/refresh?refreshToken=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJpYXQiOjE3MjUyNDAzMTYsImV4cCI6MTcyNTg0NTExNn0.hYxvbZjAtOQTlUCmcjPBCXVwEx0rxeuyfbMGD2CoSUY',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"accessToken\":\"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJyb2xlcyI6WyLotoXnuqfnrqHnkIblkZgiXSwicGVybWlzc2lvbnMiOlsidXNlcl9ncm91cCIsImF1dGgiLCJhdXRoX2dyb3VwIiwiYXV0aF9sb2ciLCJ1c2VyIiwiYXV0aF9tZW51IiwiYXV0aF9hZG1pbiIsInVzZXJfaW5kZXgiLCJ1c2VyX3J1bGUiLCJ1c2VyX2xvZyIsInJvdXRpbmUiLCJyb3V0aW5lX2NvbmZpZyIsInJvdXRpbmVfYW5uZXgiLCJyb3V0aW5lX2luZm8iLCJtb2R1bGUiLCJhdXRoX2dyb3VwX2NyZWF0ZSIsImF1dGhfZ3JvdXBfdXBkYXRlIiwiYXV0aF9ncm91cF9pbmZvIiwiYXV0aF9ncm91cF9kZWxldGUiLCJhdXRoX2FkbWluX2NyZWF0ZSIsImF1dGhfYWRtaW5fdXBkYXRlIiwiYXV0aF9hZG1pbl9pbmZvIiwiYXV0aF9hZG1pbl9kZWxldGUiLCJob21lIl0sImFjY2Vzc1Rva2VuIjp0cnVlLCJpYXQiOjE3MjUyNDI3MjgsImV4cCI6MTcyNTI0NDUyOH0.-U6Zfrv2Vtj0Al7dOTVyDFr0z722_1CKF0fcXiM0MPc\",\"refreshToken\":\"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJpYXQiOjE3MjUyNDI3MjgsImV4cCI6MTcyNTg0NzUyOH0.whfRottUTDWVs7mNTusJMm-ZlyAjQdXIRzoTHMlgHMY\"}}',
    200,
    153,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    725,
    '2024-09-02 10:04:36.847492',
    '2024-09-02 10:04:36.847492',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    106,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    726,
    '2024-09-02 10:06:17.469861',
    '2024-09-02 10:06:17.469861',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    157,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    727,
    '2024-09-02 10:07:30.458450',
    '2024-09-02 10:07:30.458450',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    101,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    728,
    '2024-09-02 10:07:48.910245',
    '2024-09-02 10:07:48.910245',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    87,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    729,
    '2024-09-02 10:09:55.758839',
    '2024-09-02 10:09:55.758839',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    337,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    730,
    '2024-09-03 14:45:28.554566',
    '2024-09-03 14:45:28.554566',
    4,
    'admin',
    'refresh刷新token',
    '127.0.0.1',
    '内网IP',
    '/admin/refresh?refreshToken=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJpYXQiOjE3MjUyNDI3MjgsImV4cCI6MTcyNTg0NzUyOH0.whfRottUTDWVs7mNTusJMm-ZlyAjQdXIRzoTHMlgHMY',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"accessToken\":\"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJyb2xlcyI6WyLotoXnuqfnrqHnkIblkZgiXSwicGVybWlzc2lvbnMiOlsidXNlcl9ncm91cCIsImF1dGgiLCJhdXRoX2dyb3VwIiwiYXV0aF9sb2ciLCJ1c2VyIiwiYXV0aF9tZW51IiwiYXV0aF9hZG1pbiIsInVzZXJfaW5kZXgiLCJ1c2VyX3J1bGUiLCJ1c2VyX2xvZyIsInJvdXRpbmUiLCJyb3V0aW5lX2NvbmZpZyIsInJvdXRpbmVfYW5uZXgiLCJyb3V0aW5lX2luZm8iLCJtb2R1bGUiLCJhdXRoX2dyb3VwX2NyZWF0ZSIsImF1dGhfZ3JvdXBfdXBkYXRlIiwiYXV0aF9ncm91cF9pbmZvIiwiYXV0aF9ncm91cF9kZWxldGUiLCJhdXRoX2FkbWluX2NyZWF0ZSIsImF1dGhfYWRtaW5fdXBkYXRlIiwiYXV0aF9hZG1pbl9pbmZvIiwiYXV0aF9hZG1pbl9kZWxldGUiLCJob21lIl0sImFjY2Vzc1Rva2VuIjp0cnVlLCJpYXQiOjE3MjUzNDU5ODAsImV4cCI6MTcyNTM0Nzc4MH0.y-e2kttA7oUX6LRYtKLIVhbr3b1MXKGEJJbmM8b0usk\",\"refreshToken\":\"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJpYXQiOjE3MjUzNDU5ODAsImV4cCI6MTcyNTk1MDc4MH0.IB_cbrPl7zBQFfVU_y8c8j_H5pzJQPUfMLTRq8Odalw\"}}',
    200,
    255,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    731,
    '2024-09-03 14:45:28.694601',
    '2024-09-03 14:45:28.694601',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    141,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    732,
    '2024-09-03 14:45:41.444775',
    '2024-09-03 14:45:41.444775',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    77,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    733,
    '2024-09-03 14:45:43.287448',
    '2024-09-03 14:45:43.287448',
    4,
    'admin',
    '附件管理',
    '127.0.0.1',
    '内网IP',
    '/files/list?page=1&size=10',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"page\":1,\"size\":10,\"total\":15,\"records\":[{\"id\":151,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"oceans.mp4\",\"hash\":\"9f8f979374969429263495ffcaac832cd603b1efe4c66a05fafd6729dffef9af\",\"path\":\"/uploads/2024/08/07/oceans.mp4\",\"mimetype\":\"video/mp4\",\"size\":23014356,\"uploadCount\":15,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/oceans.mp4\"},{\"id\":152,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"财务记账系统excel表格.xlsx\",\"hash\":\"b55ab38ff825b0360bea155510d9fee9c41812fabfe7e9fdb0aa36714195e266\",\"path\":\"/uploads/2024/08/07/财务记账系统excel表格.xlsx\",\"mimetype\":\"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet\",\"size\":97475,\"uploadCount\":4,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/财务记账系统excel表格.xlsx\"},{\"id\":153,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"测试Markdown.md\",\"hash\":\"9bab5812e9c7319230796121a872f2f10d47878d985c83fe88abd9e0119f73b0\",\"path\":\"/uploads/2024/08/07/测试Markdown.md\",\"mimetype\":\"application/octet-stream\",\"size\":11364,\"uploadCount\":2,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/测试Markdown.md\"},{\"id\":154,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"image.jpeg\",\"hash\":\"a737ff09ec2ce204c6a1e0edfe5af0b0c3a81c07af5d31f900b1ff55b39a2201\",\"path\":\"/uploads/2024/08/07/image.jpeg\",\"mimetype\":\"image/jpeg\",\"size\":106111,\"uploadCount\":11,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/image.jpeg\"},{\"id\":155,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"changtu1.jpg\",\"hash\":\"0d83b5b689384e4e08721f873a1c981cdcddd3de0f7493b23c21cc28efa4efee\",\"path\":\"/uploads/2024/08/07/changtu1.jpg\",\"mimetype\":\"image/jpeg\",\"size\":48593,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/changtu1.jpg\"},{\"id\":156,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.doc\",\"hash\":\"b7dcfae78826ae565dfdd434145d3b74aca506738c0c31952370dd6b610b549d\",\"path\":\"/uploads/2024/08/07/目录文件.doc\",\"mimetype\":\"application/msword\",\"size\":1055816,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.doc\"},{\"id\":157,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.htm\",\"hash\":\"c8cc7106cc4a16fedf0bafe622e8ede5905ff4f9b3064f03ecab7980dcb72671\",\"path\":\"/uploads/2024/08/07/目录文件.htm\",\"mimetype\":\"text/html\",\"size\":349870,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.htm\"},{\"id\":158,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.txt\",\"hash\":\"4fb5c4132a38bf42068b9cd58fa8419e792e786a4a4160faf8fabf33d623371f\",\"path\":\"/uploads/2024/08/07/目录文件.txt\",\"mimetype\":\"text/plain\",\"size\":413766,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.txt\"},{\"id\":159,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"时间线规则.xmind\",\"hash\":\"9e21393ff90f96b9570e6dc5d8f1b4ca148d520f738fea61d0e8633d86865cac\",\"path\":\"/uploads/2024/08/07/时间线规则.xmind\",\"mimetype\":\"application/octet-stream\",\"size\":47082,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/时间线规则.xmind\"},{\"id\":165,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"新建 PPT 演示文稿.ppt\",\"hash\":\"310b06ff0a793076844f8be83a752745b3915cd23e35427b88047b801be76424\",\"path\":\"/uploads/2024/08/07/新建 PPT 演示文稿.ppt\",\"mimetype\":\"application/vnd.ms-powerpoint\",\"size\":20992,\"uploadCount\":7,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/新建 PPT 演示文稿.ppt\"}],\"remark\":\"同一文件被多次上传时，只会保存一份至磁盘和增加一条附件记录；删除附件记录，将自动删除对应文件！\"}}',
    200,
    63,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    734,
    '2024-09-03 14:45:44.367788',
    '2024-09-03 14:45:44.367788',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    69,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    735,
    '2024-09-03 14:45:45.825042',
    '2024-09-03 14:45:45.825042',
    4,
    'admin',
    '附件管理',
    '127.0.0.1',
    '内网IP',
    '/files/list?page=1&size=10',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"page\":1,\"size\":10,\"total\":15,\"records\":[{\"id\":151,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"oceans.mp4\",\"hash\":\"9f8f979374969429263495ffcaac832cd603b1efe4c66a05fafd6729dffef9af\",\"path\":\"/uploads/2024/08/07/oceans.mp4\",\"mimetype\":\"video/mp4\",\"size\":23014356,\"uploadCount\":15,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/oceans.mp4\"},{\"id\":152,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"财务记账系统excel表格.xlsx\",\"hash\":\"b55ab38ff825b0360bea155510d9fee9c41812fabfe7e9fdb0aa36714195e266\",\"path\":\"/uploads/2024/08/07/财务记账系统excel表格.xlsx\",\"mimetype\":\"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet\",\"size\":97475,\"uploadCount\":4,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/财务记账系统excel表格.xlsx\"},{\"id\":153,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"测试Markdown.md\",\"hash\":\"9bab5812e9c7319230796121a872f2f10d47878d985c83fe88abd9e0119f73b0\",\"path\":\"/uploads/2024/08/07/测试Markdown.md\",\"mimetype\":\"application/octet-stream\",\"size\":11364,\"uploadCount\":2,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/测试Markdown.md\"},{\"id\":154,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"image.jpeg\",\"hash\":\"a737ff09ec2ce204c6a1e0edfe5af0b0c3a81c07af5d31f900b1ff55b39a2201\",\"path\":\"/uploads/2024/08/07/image.jpeg\",\"mimetype\":\"image/jpeg\",\"size\":106111,\"uploadCount\":11,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/image.jpeg\"},{\"id\":155,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"changtu1.jpg\",\"hash\":\"0d83b5b689384e4e08721f873a1c981cdcddd3de0f7493b23c21cc28efa4efee\",\"path\":\"/uploads/2024/08/07/changtu1.jpg\",\"mimetype\":\"image/jpeg\",\"size\":48593,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/changtu1.jpg\"},{\"id\":156,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.doc\",\"hash\":\"b7dcfae78826ae565dfdd434145d3b74aca506738c0c31952370dd6b610b549d\",\"path\":\"/uploads/2024/08/07/目录文件.doc\",\"mimetype\":\"application/msword\",\"size\":1055816,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.doc\"},{\"id\":157,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.htm\",\"hash\":\"c8cc7106cc4a16fedf0bafe622e8ede5905ff4f9b3064f03ecab7980dcb72671\",\"path\":\"/uploads/2024/08/07/目录文件.htm\",\"mimetype\":\"text/html\",\"size\":349870,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.htm\"},{\"id\":158,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.txt\",\"hash\":\"4fb5c4132a38bf42068b9cd58fa8419e792e786a4a4160faf8fabf33d623371f\",\"path\":\"/uploads/2024/08/07/目录文件.txt\",\"mimetype\":\"text/plain\",\"size\":413766,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.txt\"},{\"id\":159,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"时间线规则.xmind\",\"hash\":\"9e21393ff90f96b9570e6dc5d8f1b4ca148d520f738fea61d0e8633d86865cac\",\"path\":\"/uploads/2024/08/07/时间线规则.xmind\",\"mimetype\":\"application/octet-stream\",\"size\":47082,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/时间线规则.xmind\"},{\"id\":165,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"新建 PPT 演示文稿.ppt\",\"hash\":\"310b06ff0a793076844f8be83a752745b3915cd23e35427b88047b801be76424\",\"path\":\"/uploads/2024/08/07/新建 PPT 演示文稿.ppt\",\"mimetype\":\"application/vnd.ms-powerpoint\",\"size\":20992,\"uploadCount\":7,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/新建 PPT 演示文稿.ppt\"}],\"remark\":\"同一文件被多次上传时，只会保存一份至磁盘和增加一条附件记录；删除附件记录，将自动删除对应文件！\"}}',
    200,
    68,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    736,
    '2024-09-03 14:45:47.074437',
    '2024-09-03 14:45:47.074437',
    4,
    'admin',
    '附件管理',
    '127.0.0.1',
    '内网IP',
    '/files/list?page=1&size=10',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"page\":1,\"size\":10,\"total\":15,\"records\":[{\"id\":151,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"oceans.mp4\",\"hash\":\"9f8f979374969429263495ffcaac832cd603b1efe4c66a05fafd6729dffef9af\",\"path\":\"/uploads/2024/08/07/oceans.mp4\",\"mimetype\":\"video/mp4\",\"size\":23014356,\"uploadCount\":15,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/oceans.mp4\"},{\"id\":152,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"财务记账系统excel表格.xlsx\",\"hash\":\"b55ab38ff825b0360bea155510d9fee9c41812fabfe7e9fdb0aa36714195e266\",\"path\":\"/uploads/2024/08/07/财务记账系统excel表格.xlsx\",\"mimetype\":\"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet\",\"size\":97475,\"uploadCount\":4,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/财务记账系统excel表格.xlsx\"},{\"id\":153,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"测试Markdown.md\",\"hash\":\"9bab5812e9c7319230796121a872f2f10d47878d985c83fe88abd9e0119f73b0\",\"path\":\"/uploads/2024/08/07/测试Markdown.md\",\"mimetype\":\"application/octet-stream\",\"size\":11364,\"uploadCount\":2,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/测试Markdown.md\"},{\"id\":154,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"image.jpeg\",\"hash\":\"a737ff09ec2ce204c6a1e0edfe5af0b0c3a81c07af5d31f900b1ff55b39a2201\",\"path\":\"/uploads/2024/08/07/image.jpeg\",\"mimetype\":\"image/jpeg\",\"size\":106111,\"uploadCount\":11,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/image.jpeg\"},{\"id\":155,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"changtu1.jpg\",\"hash\":\"0d83b5b689384e4e08721f873a1c981cdcddd3de0f7493b23c21cc28efa4efee\",\"path\":\"/uploads/2024/08/07/changtu1.jpg\",\"mimetype\":\"image/jpeg\",\"size\":48593,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/changtu1.jpg\"},{\"id\":156,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.doc\",\"hash\":\"b7dcfae78826ae565dfdd434145d3b74aca506738c0c31952370dd6b610b549d\",\"path\":\"/uploads/2024/08/07/目录文件.doc\",\"mimetype\":\"application/msword\",\"size\":1055816,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.doc\"},{\"id\":157,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.htm\",\"hash\":\"c8cc7106cc4a16fedf0bafe622e8ede5905ff4f9b3064f03ecab7980dcb72671\",\"path\":\"/uploads/2024/08/07/目录文件.htm\",\"mimetype\":\"text/html\",\"size\":349870,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.htm\"},{\"id\":158,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.txt\",\"hash\":\"4fb5c4132a38bf42068b9cd58fa8419e792e786a4a4160faf8fabf33d623371f\",\"path\":\"/uploads/2024/08/07/目录文件.txt\",\"mimetype\":\"text/plain\",\"size\":413766,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.txt\"},{\"id\":159,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"时间线规则.xmind\",\"hash\":\"9e21393ff90f96b9570e6dc5d8f1b4ca148d520f738fea61d0e8633d86865cac\",\"path\":\"/uploads/2024/08/07/时间线规则.xmind\",\"mimetype\":\"application/octet-stream\",\"size\":47082,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/时间线规则.xmind\"},{\"id\":165,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"新建 PPT 演示文稿.ppt\",\"hash\":\"310b06ff0a793076844f8be83a752745b3915cd23e35427b88047b801be76424\",\"path\":\"/uploads/2024/08/07/新建 PPT 演示文稿.ppt\",\"mimetype\":\"application/vnd.ms-powerpoint\",\"size\":20992,\"uploadCount\":7,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/新建 PPT 演示文稿.ppt\"}],\"remark\":\"同一文件被多次上传时，只会保存一份至磁盘和增加一条附件记录；删除附件记录，将自动删除对应文件！\"}}',
    200,
    62,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    737,
    '2024-09-03 14:45:50.426520',
    '2024-09-03 14:45:50.426520',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    58,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    738,
    '2024-09-03 14:45:52.181980',
    '2024-09-03 14:45:52.181980',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    75,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    739,
    '2024-09-03 14:45:53.448017',
    '2024-09-03 14:45:53.448017',
    4,
    'admin',
    '附件管理',
    '127.0.0.1',
    '内网IP',
    '/files/list?page=1&size=10',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"page\":1,\"size\":10,\"total\":15,\"records\":[{\"id\":151,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"oceans.mp4\",\"hash\":\"9f8f979374969429263495ffcaac832cd603b1efe4c66a05fafd6729dffef9af\",\"path\":\"/uploads/2024/08/07/oceans.mp4\",\"mimetype\":\"video/mp4\",\"size\":23014356,\"uploadCount\":15,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/oceans.mp4\"},{\"id\":152,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"财务记账系统excel表格.xlsx\",\"hash\":\"b55ab38ff825b0360bea155510d9fee9c41812fabfe7e9fdb0aa36714195e266\",\"path\":\"/uploads/2024/08/07/财务记账系统excel表格.xlsx\",\"mimetype\":\"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet\",\"size\":97475,\"uploadCount\":4,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/财务记账系统excel表格.xlsx\"},{\"id\":153,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"测试Markdown.md\",\"hash\":\"9bab5812e9c7319230796121a872f2f10d47878d985c83fe88abd9e0119f73b0\",\"path\":\"/uploads/2024/08/07/测试Markdown.md\",\"mimetype\":\"application/octet-stream\",\"size\":11364,\"uploadCount\":2,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/测试Markdown.md\"},{\"id\":154,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"image.jpeg\",\"hash\":\"a737ff09ec2ce204c6a1e0edfe5af0b0c3a81c07af5d31f900b1ff55b39a2201\",\"path\":\"/uploads/2024/08/07/image.jpeg\",\"mimetype\":\"image/jpeg\",\"size\":106111,\"uploadCount\":11,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/image.jpeg\"},{\"id\":155,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"changtu1.jpg\",\"hash\":\"0d83b5b689384e4e08721f873a1c981cdcddd3de0f7493b23c21cc28efa4efee\",\"path\":\"/uploads/2024/08/07/changtu1.jpg\",\"mimetype\":\"image/jpeg\",\"size\":48593,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/changtu1.jpg\"},{\"id\":156,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.doc\",\"hash\":\"b7dcfae78826ae565dfdd434145d3b74aca506738c0c31952370dd6b610b549d\",\"path\":\"/uploads/2024/08/07/目录文件.doc\",\"mimetype\":\"application/msword\",\"size\":1055816,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.doc\"},{\"id\":157,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.htm\",\"hash\":\"c8cc7106cc4a16fedf0bafe622e8ede5905ff4f9b3064f03ecab7980dcb72671\",\"path\":\"/uploads/2024/08/07/目录文件.htm\",\"mimetype\":\"text/html\",\"size\":349870,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.htm\"},{\"id\":158,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.txt\",\"hash\":\"4fb5c4132a38bf42068b9cd58fa8419e792e786a4a4160faf8fabf33d623371f\",\"path\":\"/uploads/2024/08/07/目录文件.txt\",\"mimetype\":\"text/plain\",\"size\":413766,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.txt\"},{\"id\":159,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"时间线规则.xmind\",\"hash\":\"9e21393ff90f96b9570e6dc5d8f1b4ca148d520f738fea61d0e8633d86865cac\",\"path\":\"/uploads/2024/08/07/时间线规则.xmind\",\"mimetype\":\"application/octet-stream\",\"size\":47082,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/时间线规则.xmind\"},{\"id\":165,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"新建 PPT 演示文稿.ppt\",\"hash\":\"310b06ff0a793076844f8be83a752745b3915cd23e35427b88047b801be76424\",\"path\":\"/uploads/2024/08/07/新建 PPT 演示文稿.ppt\",\"mimetype\":\"application/vnd.ms-powerpoint\",\"size\":20992,\"uploadCount\":7,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/新建 PPT 演示文稿.ppt\"}],\"remark\":\"同一文件被多次上传时，只会保存一份至磁盘和增加一条附件记录；删除附件记录，将自动删除对应文件！\"}}',
    200,
    55,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    740,
    '2024-09-03 14:45:54.017268',
    '2024-09-03 14:45:54.017268',
    4,
    'admin',
    '附件管理',
    '127.0.0.1',
    '内网IP',
    '/files/list?page=1&size=10',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"page\":1,\"size\":10,\"total\":15,\"records\":[{\"id\":151,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"oceans.mp4\",\"hash\":\"9f8f979374969429263495ffcaac832cd603b1efe4c66a05fafd6729dffef9af\",\"path\":\"/uploads/2024/08/07/oceans.mp4\",\"mimetype\":\"video/mp4\",\"size\":23014356,\"uploadCount\":15,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/oceans.mp4\"},{\"id\":152,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"财务记账系统excel表格.xlsx\",\"hash\":\"b55ab38ff825b0360bea155510d9fee9c41812fabfe7e9fdb0aa36714195e266\",\"path\":\"/uploads/2024/08/07/财务记账系统excel表格.xlsx\",\"mimetype\":\"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet\",\"size\":97475,\"uploadCount\":4,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/财务记账系统excel表格.xlsx\"},{\"id\":153,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"测试Markdown.md\",\"hash\":\"9bab5812e9c7319230796121a872f2f10d47878d985c83fe88abd9e0119f73b0\",\"path\":\"/uploads/2024/08/07/测试Markdown.md\",\"mimetype\":\"application/octet-stream\",\"size\":11364,\"uploadCount\":2,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/测试Markdown.md\"},{\"id\":154,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"image.jpeg\",\"hash\":\"a737ff09ec2ce204c6a1e0edfe5af0b0c3a81c07af5d31f900b1ff55b39a2201\",\"path\":\"/uploads/2024/08/07/image.jpeg\",\"mimetype\":\"image/jpeg\",\"size\":106111,\"uploadCount\":11,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/image.jpeg\"},{\"id\":155,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"changtu1.jpg\",\"hash\":\"0d83b5b689384e4e08721f873a1c981cdcddd3de0f7493b23c21cc28efa4efee\",\"path\":\"/uploads/2024/08/07/changtu1.jpg\",\"mimetype\":\"image/jpeg\",\"size\":48593,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/changtu1.jpg\"},{\"id\":156,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.doc\",\"hash\":\"b7dcfae78826ae565dfdd434145d3b74aca506738c0c31952370dd6b610b549d\",\"path\":\"/uploads/2024/08/07/目录文件.doc\",\"mimetype\":\"application/msword\",\"size\":1055816,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.doc\"},{\"id\":157,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.htm\",\"hash\":\"c8cc7106cc4a16fedf0bafe622e8ede5905ff4f9b3064f03ecab7980dcb72671\",\"path\":\"/uploads/2024/08/07/目录文件.htm\",\"mimetype\":\"text/html\",\"size\":349870,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.htm\"},{\"id\":158,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.txt\",\"hash\":\"4fb5c4132a38bf42068b9cd58fa8419e792e786a4a4160faf8fabf33d623371f\",\"path\":\"/uploads/2024/08/07/目录文件.txt\",\"mimetype\":\"text/plain\",\"size\":413766,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.txt\"},{\"id\":159,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"时间线规则.xmind\",\"hash\":\"9e21393ff90f96b9570e6dc5d8f1b4ca148d520f738fea61d0e8633d86865cac\",\"path\":\"/uploads/2024/08/07/时间线规则.xmind\",\"mimetype\":\"application/octet-stream\",\"size\":47082,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/时间线规则.xmind\"},{\"id\":165,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"新建 PPT 演示文稿.ppt\",\"hash\":\"310b06ff0a793076844f8be83a752745b3915cd23e35427b88047b801be76424\",\"path\":\"/uploads/2024/08/07/新建 PPT 演示文稿.ppt\",\"mimetype\":\"application/vnd.ms-powerpoint\",\"size\":20992,\"uploadCount\":7,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/新建 PPT 演示文稿.ppt\"}],\"remark\":\"同一文件被多次上传时，只会保存一份至磁盘和增加一条附件记录；删除附件记录，将自动删除对应文件！\"}}',
    200,
    56,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    741,
    '2024-09-03 14:47:21.007437',
    '2024-09-03 14:47:21.007437',
    4,
    'admin',
    '附件管理',
    '127.0.0.1',
    '内网IP',
    '/files/list?page=1&size=10',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"page\":1,\"size\":10,\"total\":15,\"records\":[{\"id\":151,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"oceans.mp4\",\"hash\":\"9f8f979374969429263495ffcaac832cd603b1efe4c66a05fafd6729dffef9af\",\"path\":\"/uploads/2024/08/07/oceans.mp4\",\"mimetype\":\"video/mp4\",\"size\":23014356,\"uploadCount\":15,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/oceans.mp4\"},{\"id\":152,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"财务记账系统excel表格.xlsx\",\"hash\":\"b55ab38ff825b0360bea155510d9fee9c41812fabfe7e9fdb0aa36714195e266\",\"path\":\"/uploads/2024/08/07/财务记账系统excel表格.xlsx\",\"mimetype\":\"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet\",\"size\":97475,\"uploadCount\":4,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/财务记账系统excel表格.xlsx\"},{\"id\":153,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"测试Markdown.md\",\"hash\":\"9bab5812e9c7319230796121a872f2f10d47878d985c83fe88abd9e0119f73b0\",\"path\":\"/uploads/2024/08/07/测试Markdown.md\",\"mimetype\":\"application/octet-stream\",\"size\":11364,\"uploadCount\":2,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/测试Markdown.md\"},{\"id\":154,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"image.jpeg\",\"hash\":\"a737ff09ec2ce204c6a1e0edfe5af0b0c3a81c07af5d31f900b1ff55b39a2201\",\"path\":\"/uploads/2024/08/07/image.jpeg\",\"mimetype\":\"image/jpeg\",\"size\":106111,\"uploadCount\":11,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/image.jpeg\"},{\"id\":155,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"changtu1.jpg\",\"hash\":\"0d83b5b689384e4e08721f873a1c981cdcddd3de0f7493b23c21cc28efa4efee\",\"path\":\"/uploads/2024/08/07/changtu1.jpg\",\"mimetype\":\"image/jpeg\",\"size\":48593,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/changtu1.jpg\"},{\"id\":156,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.doc\",\"hash\":\"b7dcfae78826ae565dfdd434145d3b74aca506738c0c31952370dd6b610b549d\",\"path\":\"/uploads/2024/08/07/目录文件.doc\",\"mimetype\":\"application/msword\",\"size\":1055816,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.doc\"},{\"id\":157,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.htm\",\"hash\":\"c8cc7106cc4a16fedf0bafe622e8ede5905ff4f9b3064f03ecab7980dcb72671\",\"path\":\"/uploads/2024/08/07/目录文件.htm\",\"mimetype\":\"text/html\",\"size\":349870,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.htm\"},{\"id\":158,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.txt\",\"hash\":\"4fb5c4132a38bf42068b9cd58fa8419e792e786a4a4160faf8fabf33d623371f\",\"path\":\"/uploads/2024/08/07/目录文件.txt\",\"mimetype\":\"text/plain\",\"size\":413766,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.txt\"},{\"id\":159,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"时间线规则.xmind\",\"hash\":\"9e21393ff90f96b9570e6dc5d8f1b4ca148d520f738fea61d0e8633d86865cac\",\"path\":\"/uploads/2024/08/07/时间线规则.xmind\",\"mimetype\":\"application/octet-stream\",\"size\":47082,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/时间线规则.xmind\"},{\"id\":165,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"新建 PPT 演示文稿.ppt\",\"hash\":\"310b06ff0a793076844f8be83a752745b3915cd23e35427b88047b801be76424\",\"path\":\"/uploads/2024/08/07/新建 PPT 演示文稿.ppt\",\"mimetype\":\"application/vnd.ms-powerpoint\",\"size\":20992,\"uploadCount\":7,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/新建 PPT 演示文稿.ppt\"}],\"remark\":\"同一文件被多次上传时，只会保存一份至磁盘和增加一条附件记录；删除附件记录，将自动删除对应文件！\"}}',
    200,
    110,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    742,
    '2024-09-03 14:47:23.272016',
    '2024-09-03 14:47:23.272016',
    4,
    'admin',
    '附件管理',
    '127.0.0.1',
    '内网IP',
    '/files/list?page=1&size=10',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"page\":1,\"size\":10,\"total\":15,\"records\":[{\"id\":151,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"oceans.mp4\",\"hash\":\"9f8f979374969429263495ffcaac832cd603b1efe4c66a05fafd6729dffef9af\",\"path\":\"/uploads/2024/08/07/oceans.mp4\",\"mimetype\":\"video/mp4\",\"size\":23014356,\"uploadCount\":15,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/oceans.mp4\"},{\"id\":152,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"财务记账系统excel表格.xlsx\",\"hash\":\"b55ab38ff825b0360bea155510d9fee9c41812fabfe7e9fdb0aa36714195e266\",\"path\":\"/uploads/2024/08/07/财务记账系统excel表格.xlsx\",\"mimetype\":\"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet\",\"size\":97475,\"uploadCount\":4,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/财务记账系统excel表格.xlsx\"},{\"id\":153,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"测试Markdown.md\",\"hash\":\"9bab5812e9c7319230796121a872f2f10d47878d985c83fe88abd9e0119f73b0\",\"path\":\"/uploads/2024/08/07/测试Markdown.md\",\"mimetype\":\"application/octet-stream\",\"size\":11364,\"uploadCount\":2,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/测试Markdown.md\"},{\"id\":154,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"image.jpeg\",\"hash\":\"a737ff09ec2ce204c6a1e0edfe5af0b0c3a81c07af5d31f900b1ff55b39a2201\",\"path\":\"/uploads/2024/08/07/image.jpeg\",\"mimetype\":\"image/jpeg\",\"size\":106111,\"uploadCount\":11,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/image.jpeg\"},{\"id\":155,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"changtu1.jpg\",\"hash\":\"0d83b5b689384e4e08721f873a1c981cdcddd3de0f7493b23c21cc28efa4efee\",\"path\":\"/uploads/2024/08/07/changtu1.jpg\",\"mimetype\":\"image/jpeg\",\"size\":48593,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/changtu1.jpg\"},{\"id\":156,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.doc\",\"hash\":\"b7dcfae78826ae565dfdd434145d3b74aca506738c0c31952370dd6b610b549d\",\"path\":\"/uploads/2024/08/07/目录文件.doc\",\"mimetype\":\"application/msword\",\"size\":1055816,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.doc\"},{\"id\":157,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.htm\",\"hash\":\"c8cc7106cc4a16fedf0bafe622e8ede5905ff4f9b3064f03ecab7980dcb72671\",\"path\":\"/uploads/2024/08/07/目录文件.htm\",\"mimetype\":\"text/html\",\"size\":349870,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.htm\"},{\"id\":158,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.txt\",\"hash\":\"4fb5c4132a38bf42068b9cd58fa8419e792e786a4a4160faf8fabf33d623371f\",\"path\":\"/uploads/2024/08/07/目录文件.txt\",\"mimetype\":\"text/plain\",\"size\":413766,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.txt\"},{\"id\":159,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"时间线规则.xmind\",\"hash\":\"9e21393ff90f96b9570e6dc5d8f1b4ca148d520f738fea61d0e8633d86865cac\",\"path\":\"/uploads/2024/08/07/时间线规则.xmind\",\"mimetype\":\"application/octet-stream\",\"size\":47082,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/时间线规则.xmind\"},{\"id\":165,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"新建 PPT 演示文稿.ppt\",\"hash\":\"310b06ff0a793076844f8be83a752745b3915cd23e35427b88047b801be76424\",\"path\":\"/uploads/2024/08/07/新建 PPT 演示文稿.ppt\",\"mimetype\":\"application/vnd.ms-powerpoint\",\"size\":20992,\"uploadCount\":7,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/新建 PPT 演示文稿.ppt\"}],\"remark\":\"同一文件被多次上传时，只会保存一份至磁盘和增加一条附件记录；删除附件记录，将自动删除对应文件！\"}}',
    200,
    57,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    743,
    '2024-09-03 14:47:39.682446',
    '2024-09-03 14:47:39.682446',
    4,
    'admin',
    '附件管理',
    '127.0.0.1',
    '内网IP',
    '/files/list?page=1&size=10',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"page\":1,\"size\":10,\"total\":15,\"records\":[{\"id\":151,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"oceans.mp4\",\"hash\":\"9f8f979374969429263495ffcaac832cd603b1efe4c66a05fafd6729dffef9af\",\"path\":\"/uploads/2024/08/07/oceans.mp4\",\"mimetype\":\"video/mp4\",\"size\":23014356,\"uploadCount\":15,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/oceans.mp4\"},{\"id\":152,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"财务记账系统excel表格.xlsx\",\"hash\":\"b55ab38ff825b0360bea155510d9fee9c41812fabfe7e9fdb0aa36714195e266\",\"path\":\"/uploads/2024/08/07/财务记账系统excel表格.xlsx\",\"mimetype\":\"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet\",\"size\":97475,\"uploadCount\":4,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/财务记账系统excel表格.xlsx\"},{\"id\":153,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"测试Markdown.md\",\"hash\":\"9bab5812e9c7319230796121a872f2f10d47878d985c83fe88abd9e0119f73b0\",\"path\":\"/uploads/2024/08/07/测试Markdown.md\",\"mimetype\":\"application/octet-stream\",\"size\":11364,\"uploadCount\":2,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/测试Markdown.md\"},{\"id\":154,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"image.jpeg\",\"hash\":\"a737ff09ec2ce204c6a1e0edfe5af0b0c3a81c07af5d31f900b1ff55b39a2201\",\"path\":\"/uploads/2024/08/07/image.jpeg\",\"mimetype\":\"image/jpeg\",\"size\":106111,\"uploadCount\":11,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/image.jpeg\"},{\"id\":155,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"changtu1.jpg\",\"hash\":\"0d83b5b689384e4e08721f873a1c981cdcddd3de0f7493b23c21cc28efa4efee\",\"path\":\"/uploads/2024/08/07/changtu1.jpg\",\"mimetype\":\"image/jpeg\",\"size\":48593,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/changtu1.jpg\"},{\"id\":156,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.doc\",\"hash\":\"b7dcfae78826ae565dfdd434145d3b74aca506738c0c31952370dd6b610b549d\",\"path\":\"/uploads/2024/08/07/目录文件.doc\",\"mimetype\":\"application/msword\",\"size\":1055816,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.doc\"},{\"id\":157,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.htm\",\"hash\":\"c8cc7106cc4a16fedf0bafe622e8ede5905ff4f9b3064f03ecab7980dcb72671\",\"path\":\"/uploads/2024/08/07/目录文件.htm\",\"mimetype\":\"text/html\",\"size\":349870,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.htm\"},{\"id\":158,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.txt\",\"hash\":\"4fb5c4132a38bf42068b9cd58fa8419e792e786a4a4160faf8fabf33d623371f\",\"path\":\"/uploads/2024/08/07/目录文件.txt\",\"mimetype\":\"text/plain\",\"size\":413766,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.txt\"},{\"id\":159,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"时间线规则.xmind\",\"hash\":\"9e21393ff90f96b9570e6dc5d8f1b4ca148d520f738fea61d0e8633d86865cac\",\"path\":\"/uploads/2024/08/07/时间线规则.xmind\",\"mimetype\":\"application/octet-stream\",\"size\":47082,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/时间线规则.xmind\"},{\"id\":165,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"新建 PPT 演示文稿.ppt\",\"hash\":\"310b06ff0a793076844f8be83a752745b3915cd23e35427b88047b801be76424\",\"path\":\"/uploads/2024/08/07/新建 PPT 演示文稿.ppt\",\"mimetype\":\"application/vnd.ms-powerpoint\",\"size\":20992,\"uploadCount\":7,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/新建 PPT 演示文稿.ppt\"}],\"remark\":\"同一文件被多次上传时，只会保存一份至磁盘和增加一条附件记录；删除附件记录，将自动删除对应文件！\"}}',
    200,
    56,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    744,
    '2024-09-03 14:48:36.984713',
    '2024-09-03 14:48:36.984713',
    4,
    'admin',
    '附件管理',
    '127.0.0.1',
    '内网IP',
    '/files/list?page=1&size=10',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"page\":1,\"size\":10,\"total\":15,\"records\":[{\"id\":151,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"oceans.mp4\",\"hash\":\"9f8f979374969429263495ffcaac832cd603b1efe4c66a05fafd6729dffef9af\",\"path\":\"/uploads/2024/08/07/oceans.mp4\",\"mimetype\":\"video/mp4\",\"size\":23014356,\"uploadCount\":15,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/oceans.mp4\"},{\"id\":152,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"财务记账系统excel表格.xlsx\",\"hash\":\"b55ab38ff825b0360bea155510d9fee9c41812fabfe7e9fdb0aa36714195e266\",\"path\":\"/uploads/2024/08/07/财务记账系统excel表格.xlsx\",\"mimetype\":\"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet\",\"size\":97475,\"uploadCount\":4,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/财务记账系统excel表格.xlsx\"},{\"id\":153,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"测试Markdown.md\",\"hash\":\"9bab5812e9c7319230796121a872f2f10d47878d985c83fe88abd9e0119f73b0\",\"path\":\"/uploads/2024/08/07/测试Markdown.md\",\"mimetype\":\"application/octet-stream\",\"size\":11364,\"uploadCount\":2,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/测试Markdown.md\"},{\"id\":154,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"image.jpeg\",\"hash\":\"a737ff09ec2ce204c6a1e0edfe5af0b0c3a81c07af5d31f900b1ff55b39a2201\",\"path\":\"/uploads/2024/08/07/image.jpeg\",\"mimetype\":\"image/jpeg\",\"size\":106111,\"uploadCount\":11,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/image.jpeg\"},{\"id\":155,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"changtu1.jpg\",\"hash\":\"0d83b5b689384e4e08721f873a1c981cdcddd3de0f7493b23c21cc28efa4efee\",\"path\":\"/uploads/2024/08/07/changtu1.jpg\",\"mimetype\":\"image/jpeg\",\"size\":48593,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/changtu1.jpg\"},{\"id\":156,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.doc\",\"hash\":\"b7dcfae78826ae565dfdd434145d3b74aca506738c0c31952370dd6b610b549d\",\"path\":\"/uploads/2024/08/07/目录文件.doc\",\"mimetype\":\"application/msword\",\"size\":1055816,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.doc\"},{\"id\":157,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.htm\",\"hash\":\"c8cc7106cc4a16fedf0bafe622e8ede5905ff4f9b3064f03ecab7980dcb72671\",\"path\":\"/uploads/2024/08/07/目录文件.htm\",\"mimetype\":\"text/html\",\"size\":349870,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.htm\"},{\"id\":158,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.txt\",\"hash\":\"4fb5c4132a38bf42068b9cd58fa8419e792e786a4a4160faf8fabf33d623371f\",\"path\":\"/uploads/2024/08/07/目录文件.txt\",\"mimetype\":\"text/plain\",\"size\":413766,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.txt\"},{\"id\":159,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"时间线规则.xmind\",\"hash\":\"9e21393ff90f96b9570e6dc5d8f1b4ca148d520f738fea61d0e8633d86865cac\",\"path\":\"/uploads/2024/08/07/时间线规则.xmind\",\"mimetype\":\"application/octet-stream\",\"size\":47082,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/时间线规则.xmind\"},{\"id\":165,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"新建 PPT 演示文稿.ppt\",\"hash\":\"310b06ff0a793076844f8be83a752745b3915cd23e35427b88047b801be76424\",\"path\":\"/uploads/2024/08/07/新建 PPT 演示文稿.ppt\",\"mimetype\":\"application/vnd.ms-powerpoint\",\"size\":20992,\"uploadCount\":7,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/新建 PPT 演示文稿.ppt\"}],\"remark\":\"同一文件被多次上传时，只会保存一份至磁盘和增加一条附件记录；删除附件记录，将自动删除对应文件！\"}}',
    200,
    56,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    745,
    '2024-09-03 14:49:22.524078',
    '2024-09-03 14:49:22.524078',
    4,
    'admin',
    '附件管理',
    '127.0.0.1',
    '内网IP',
    '/files/list?page=1&size=10',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"page\":1,\"size\":10,\"total\":15,\"records\":[{\"id\":151,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"oceans.mp4\",\"hash\":\"9f8f979374969429263495ffcaac832cd603b1efe4c66a05fafd6729dffef9af\",\"path\":\"/uploads/2024/08/07/oceans.mp4\",\"mimetype\":\"video/mp4\",\"size\":23014356,\"uploadCount\":15,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/oceans.mp4\"},{\"id\":152,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"财务记账系统excel表格.xlsx\",\"hash\":\"b55ab38ff825b0360bea155510d9fee9c41812fabfe7e9fdb0aa36714195e266\",\"path\":\"/uploads/2024/08/07/财务记账系统excel表格.xlsx\",\"mimetype\":\"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet\",\"size\":97475,\"uploadCount\":4,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/财务记账系统excel表格.xlsx\"},{\"id\":153,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"测试Markdown.md\",\"hash\":\"9bab5812e9c7319230796121a872f2f10d47878d985c83fe88abd9e0119f73b0\",\"path\":\"/uploads/2024/08/07/测试Markdown.md\",\"mimetype\":\"application/octet-stream\",\"size\":11364,\"uploadCount\":2,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/测试Markdown.md\"},{\"id\":154,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"image.jpeg\",\"hash\":\"a737ff09ec2ce204c6a1e0edfe5af0b0c3a81c07af5d31f900b1ff55b39a2201\",\"path\":\"/uploads/2024/08/07/image.jpeg\",\"mimetype\":\"image/jpeg\",\"size\":106111,\"uploadCount\":11,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/image.jpeg\"},{\"id\":155,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"changtu1.jpg\",\"hash\":\"0d83b5b689384e4e08721f873a1c981cdcddd3de0f7493b23c21cc28efa4efee\",\"path\":\"/uploads/2024/08/07/changtu1.jpg\",\"mimetype\":\"image/jpeg\",\"size\":48593,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/changtu1.jpg\"},{\"id\":156,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.doc\",\"hash\":\"b7dcfae78826ae565dfdd434145d3b74aca506738c0c31952370dd6b610b549d\",\"path\":\"/uploads/2024/08/07/目录文件.doc\",\"mimetype\":\"application/msword\",\"size\":1055816,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.doc\"},{\"id\":157,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.htm\",\"hash\":\"c8cc7106cc4a16fedf0bafe622e8ede5905ff4f9b3064f03ecab7980dcb72671\",\"path\":\"/uploads/2024/08/07/目录文件.htm\",\"mimetype\":\"text/html\",\"size\":349870,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.htm\"},{\"id\":158,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.txt\",\"hash\":\"4fb5c4132a38bf42068b9cd58fa8419e792e786a4a4160faf8fabf33d623371f\",\"path\":\"/uploads/2024/08/07/目录文件.txt\",\"mimetype\":\"text/plain\",\"size\":413766,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.txt\"},{\"id\":159,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"时间线规则.xmind\",\"hash\":\"9e21393ff90f96b9570e6dc5d8f1b4ca148d520f738fea61d0e8633d86865cac\",\"path\":\"/uploads/2024/08/07/时间线规则.xmind\",\"mimetype\":\"application/octet-stream\",\"size\":47082,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/时间线规则.xmind\"},{\"id\":165,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"新建 PPT 演示文稿.ppt\",\"hash\":\"310b06ff0a793076844f8be83a752745b3915cd23e35427b88047b801be76424\",\"path\":\"/uploads/2024/08/07/新建 PPT 演示文稿.ppt\",\"mimetype\":\"application/vnd.ms-powerpoint\",\"size\":20992,\"uploadCount\":7,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/新建 PPT 演示文稿.ppt\"}],\"remark\":\"同一文件被多次上传时，只会保存一份至磁盘和增加一条附件记录；删除附件记录，将自动删除对应文件！\"}}',
    200,
    107,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    746,
    '2024-09-03 14:50:48.496028',
    '2024-09-03 14:50:48.496028',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    74,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    747,
    '2024-09-03 14:50:59.091654',
    '2024-09-03 14:50:59.091654',
    4,
    'admin',
    '附件管理',
    '127.0.0.1',
    '内网IP',
    '/files/list?page=1&size=10',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"page\":1,\"size\":10,\"total\":15,\"records\":[{\"id\":151,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"oceans.mp4\",\"hash\":\"9f8f979374969429263495ffcaac832cd603b1efe4c66a05fafd6729dffef9af\",\"path\":\"/uploads/2024/08/07/oceans.mp4\",\"mimetype\":\"video/mp4\",\"size\":23014356,\"uploadCount\":15,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/oceans.mp4\"},{\"id\":152,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"财务记账系统excel表格.xlsx\",\"hash\":\"b55ab38ff825b0360bea155510d9fee9c41812fabfe7e9fdb0aa36714195e266\",\"path\":\"/uploads/2024/08/07/财务记账系统excel表格.xlsx\",\"mimetype\":\"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet\",\"size\":97475,\"uploadCount\":4,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/财务记账系统excel表格.xlsx\"},{\"id\":153,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"测试Markdown.md\",\"hash\":\"9bab5812e9c7319230796121a872f2f10d47878d985c83fe88abd9e0119f73b0\",\"path\":\"/uploads/2024/08/07/测试Markdown.md\",\"mimetype\":\"application/octet-stream\",\"size\":11364,\"uploadCount\":2,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/测试Markdown.md\"},{\"id\":154,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"image.jpeg\",\"hash\":\"a737ff09ec2ce204c6a1e0edfe5af0b0c3a81c07af5d31f900b1ff55b39a2201\",\"path\":\"/uploads/2024/08/07/image.jpeg\",\"mimetype\":\"image/jpeg\",\"size\":106111,\"uploadCount\":11,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/image.jpeg\"},{\"id\":155,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"changtu1.jpg\",\"hash\":\"0d83b5b689384e4e08721f873a1c981cdcddd3de0f7493b23c21cc28efa4efee\",\"path\":\"/uploads/2024/08/07/changtu1.jpg\",\"mimetype\":\"image/jpeg\",\"size\":48593,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/changtu1.jpg\"},{\"id\":156,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.doc\",\"hash\":\"b7dcfae78826ae565dfdd434145d3b74aca506738c0c31952370dd6b610b549d\",\"path\":\"/uploads/2024/08/07/目录文件.doc\",\"mimetype\":\"application/msword\",\"size\":1055816,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.doc\"},{\"id\":157,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.htm\",\"hash\":\"c8cc7106cc4a16fedf0bafe622e8ede5905ff4f9b3064f03ecab7980dcb72671\",\"path\":\"/uploads/2024/08/07/目录文件.htm\",\"mimetype\":\"text/html\",\"size\":349870,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.htm\"},{\"id\":158,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.txt\",\"hash\":\"4fb5c4132a38bf42068b9cd58fa8419e792e786a4a4160faf8fabf33d623371f\",\"path\":\"/uploads/2024/08/07/目录文件.txt\",\"mimetype\":\"text/plain\",\"size\":413766,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.txt\"},{\"id\":159,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"时间线规则.xmind\",\"hash\":\"9e21393ff90f96b9570e6dc5d8f1b4ca148d520f738fea61d0e8633d86865cac\",\"path\":\"/uploads/2024/08/07/时间线规则.xmind\",\"mimetype\":\"application/octet-stream\",\"size\":47082,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/时间线规则.xmind\"},{\"id\":165,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"新建 PPT 演示文稿.ppt\",\"hash\":\"310b06ff0a793076844f8be83a752745b3915cd23e35427b88047b801be76424\",\"path\":\"/uploads/2024/08/07/新建 PPT 演示文稿.ppt\",\"mimetype\":\"application/vnd.ms-powerpoint\",\"size\":20992,\"uploadCount\":7,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/新建 PPT 演示文稿.ppt\"}],\"remark\":\"同一文件被多次上传时，只会保存一份至磁盘和增加一条附件记录；删除附件记录，将自动删除对应文件！\"}}',
    200,
    89,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    748,
    '2024-09-03 14:51:01.505994',
    '2024-09-03 14:51:01.505994',
    4,
    'admin',
    '附件管理',
    '127.0.0.1',
    '内网IP',
    '/files/list?page=1&size=10',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"page\":1,\"size\":10,\"total\":15,\"records\":[{\"id\":151,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"oceans.mp4\",\"hash\":\"9f8f979374969429263495ffcaac832cd603b1efe4c66a05fafd6729dffef9af\",\"path\":\"/uploads/2024/08/07/oceans.mp4\",\"mimetype\":\"video/mp4\",\"size\":23014356,\"uploadCount\":15,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/oceans.mp4\"},{\"id\":152,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"财务记账系统excel表格.xlsx\",\"hash\":\"b55ab38ff825b0360bea155510d9fee9c41812fabfe7e9fdb0aa36714195e266\",\"path\":\"/uploads/2024/08/07/财务记账系统excel表格.xlsx\",\"mimetype\":\"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet\",\"size\":97475,\"uploadCount\":4,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/财务记账系统excel表格.xlsx\"},{\"id\":153,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"测试Markdown.md\",\"hash\":\"9bab5812e9c7319230796121a872f2f10d47878d985c83fe88abd9e0119f73b0\",\"path\":\"/uploads/2024/08/07/测试Markdown.md\",\"mimetype\":\"application/octet-stream\",\"size\":11364,\"uploadCount\":2,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/测试Markdown.md\"},{\"id\":154,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"image.jpeg\",\"hash\":\"a737ff09ec2ce204c6a1e0edfe5af0b0c3a81c07af5d31f900b1ff55b39a2201\",\"path\":\"/uploads/2024/08/07/image.jpeg\",\"mimetype\":\"image/jpeg\",\"size\":106111,\"uploadCount\":11,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/image.jpeg\"},{\"id\":155,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"changtu1.jpg\",\"hash\":\"0d83b5b689384e4e08721f873a1c981cdcddd3de0f7493b23c21cc28efa4efee\",\"path\":\"/uploads/2024/08/07/changtu1.jpg\",\"mimetype\":\"image/jpeg\",\"size\":48593,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/changtu1.jpg\"},{\"id\":156,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.doc\",\"hash\":\"b7dcfae78826ae565dfdd434145d3b74aca506738c0c31952370dd6b610b549d\",\"path\":\"/uploads/2024/08/07/目录文件.doc\",\"mimetype\":\"application/msword\",\"size\":1055816,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.doc\"},{\"id\":157,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.htm\",\"hash\":\"c8cc7106cc4a16fedf0bafe622e8ede5905ff4f9b3064f03ecab7980dcb72671\",\"path\":\"/uploads/2024/08/07/目录文件.htm\",\"mimetype\":\"text/html\",\"size\":349870,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.htm\"},{\"id\":158,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.txt\",\"hash\":\"4fb5c4132a38bf42068b9cd58fa8419e792e786a4a4160faf8fabf33d623371f\",\"path\":\"/uploads/2024/08/07/目录文件.txt\",\"mimetype\":\"text/plain\",\"size\":413766,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.txt\"},{\"id\":159,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"时间线规则.xmind\",\"hash\":\"9e21393ff90f96b9570e6dc5d8f1b4ca148d520f738fea61d0e8633d86865cac\",\"path\":\"/uploads/2024/08/07/时间线规则.xmind\",\"mimetype\":\"application/octet-stream\",\"size\":47082,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/时间线规则.xmind\"},{\"id\":165,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"新建 PPT 演示文稿.ppt\",\"hash\":\"310b06ff0a793076844f8be83a752745b3915cd23e35427b88047b801be76424\",\"path\":\"/uploads/2024/08/07/新建 PPT 演示文稿.ppt\",\"mimetype\":\"application/vnd.ms-powerpoint\",\"size\":20992,\"uploadCount\":7,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/新建 PPT 演示文稿.ppt\"}],\"remark\":\"同一文件被多次上传时，只会保存一份至磁盘和增加一条附件记录；删除附件记录，将自动删除对应文件！\"}}',
    200,
    64,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    749,
    '2024-09-03 14:51:26.712386',
    '2024-09-03 14:51:26.712386',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    58,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    750,
    '2024-09-03 14:51:45.212254',
    '2024-09-03 14:51:45.212254',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    60,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    751,
    '2024-09-03 14:51:51.126259',
    '2024-09-03 14:51:51.126259',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    57,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    752,
    '2024-09-03 14:51:53.970487',
    '2024-09-03 14:51:53.970487',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    56,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    753,
    '2024-09-03 14:53:07.539014',
    '2024-09-03 14:53:07.539014',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    110,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    754,
    '2024-09-03 14:53:44.787641',
    '2024-09-03 14:53:44.787641',
    4,
    'admin',
    '附件管理',
    '127.0.0.1',
    '内网IP',
    '/files/list?page=1&size=10',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"page\":1,\"size\":10,\"total\":15,\"records\":[{\"id\":151,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"oceans.mp4\",\"hash\":\"9f8f979374969429263495ffcaac832cd603b1efe4c66a05fafd6729dffef9af\",\"path\":\"/uploads/2024/08/07/oceans.mp4\",\"mimetype\":\"video/mp4\",\"size\":23014356,\"uploadCount\":15,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/oceans.mp4\"},{\"id\":152,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"财务记账系统excel表格.xlsx\",\"hash\":\"b55ab38ff825b0360bea155510d9fee9c41812fabfe7e9fdb0aa36714195e266\",\"path\":\"/uploads/2024/08/07/财务记账系统excel表格.xlsx\",\"mimetype\":\"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet\",\"size\":97475,\"uploadCount\":4,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/财务记账系统excel表格.xlsx\"},{\"id\":153,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"测试Markdown.md\",\"hash\":\"9bab5812e9c7319230796121a872f2f10d47878d985c83fe88abd9e0119f73b0\",\"path\":\"/uploads/2024/08/07/测试Markdown.md\",\"mimetype\":\"application/octet-stream\",\"size\":11364,\"uploadCount\":2,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/测试Markdown.md\"},{\"id\":154,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"image.jpeg\",\"hash\":\"a737ff09ec2ce204c6a1e0edfe5af0b0c3a81c07af5d31f900b1ff55b39a2201\",\"path\":\"/uploads/2024/08/07/image.jpeg\",\"mimetype\":\"image/jpeg\",\"size\":106111,\"uploadCount\":11,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/image.jpeg\"},{\"id\":155,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"changtu1.jpg\",\"hash\":\"0d83b5b689384e4e08721f873a1c981cdcddd3de0f7493b23c21cc28efa4efee\",\"path\":\"/uploads/2024/08/07/changtu1.jpg\",\"mimetype\":\"image/jpeg\",\"size\":48593,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/changtu1.jpg\"},{\"id\":156,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.doc\",\"hash\":\"b7dcfae78826ae565dfdd434145d3b74aca506738c0c31952370dd6b610b549d\",\"path\":\"/uploads/2024/08/07/目录文件.doc\",\"mimetype\":\"application/msword\",\"size\":1055816,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.doc\"},{\"id\":157,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.htm\",\"hash\":\"c8cc7106cc4a16fedf0bafe622e8ede5905ff4f9b3064f03ecab7980dcb72671\",\"path\":\"/uploads/2024/08/07/目录文件.htm\",\"mimetype\":\"text/html\",\"size\":349870,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.htm\"},{\"id\":158,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.txt\",\"hash\":\"4fb5c4132a38bf42068b9cd58fa8419e792e786a4a4160faf8fabf33d623371f\",\"path\":\"/uploads/2024/08/07/目录文件.txt\",\"mimetype\":\"text/plain\",\"size\":413766,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.txt\"},{\"id\":159,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"时间线规则.xmind\",\"hash\":\"9e21393ff90f96b9570e6dc5d8f1b4ca148d520f738fea61d0e8633d86865cac\",\"path\":\"/uploads/2024/08/07/时间线规则.xmind\",\"mimetype\":\"application/octet-stream\",\"size\":47082,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/时间线规则.xmind\"},{\"id\":165,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"新建 PPT 演示文稿.ppt\",\"hash\":\"310b06ff0a793076844f8be83a752745b3915cd23e35427b88047b801be76424\",\"path\":\"/uploads/2024/08/07/新建 PPT 演示文稿.ppt\",\"mimetype\":\"application/vnd.ms-powerpoint\",\"size\":20992,\"uploadCount\":7,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/新建 PPT 演示文稿.ppt\"}],\"remark\":\"同一文件被多次上传时，只会保存一份至磁盘和增加一条附件记录；删除附件记录，将自动删除对应文件！\"}}',
    200,
    58,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    755,
    '2024-09-03 15:10:58.909090',
    '2024-09-03 15:10:58.909090',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    104,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    756,
    '2024-09-03 15:12:00.960838',
    '2024-09-03 15:12:00.960838',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    111,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    757,
    '2024-09-03 15:12:57.603438',
    '2024-09-03 15:12:57.603438',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    92,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    758,
    '2024-09-03 15:14:24.829799',
    '2024-09-03 15:14:24.829799',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    103,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    759,
    '2024-09-03 15:14:30.612020',
    '2024-09-03 15:14:30.612020',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    65,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    760,
    '2024-09-03 15:15:01.499617',
    '2024-09-03 15:15:01.499617',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    60,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    761,
    '2024-09-03 15:21:30.229819',
    '2024-09-03 15:21:30.229819',
    4,
    'admin',
    'refresh刷新token',
    '127.0.0.1',
    '内网IP',
    '/admin/refresh?refreshToken=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJpYXQiOjE3MjUzNDU5ODAsImV4cCI6MTcyNTk1MDc4MH0.IB_cbrPl7zBQFfVU_y8c8j_H5pzJQPUfMLTRq8Odalw',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"accessToken\":\"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJyb2xlcyI6WyLotoXnuqfnrqHnkIblkZgiXSwicGVybWlzc2lvbnMiOlsidXNlcl9ncm91cCIsImF1dGgiLCJhdXRoX2dyb3VwIiwiYXV0aF9sb2ciLCJ1c2VyIiwiYXV0aF9tZW51IiwiYXV0aF9hZG1pbiIsInVzZXJfaW5kZXgiLCJ1c2VyX3J1bGUiLCJ1c2VyX2xvZyIsInJvdXRpbmUiLCJyb3V0aW5lX2NvbmZpZyIsInJvdXRpbmVfYW5uZXgiLCJyb3V0aW5lX2luZm8iLCJtb2R1bGUiLCJhdXRoX2dyb3VwX2NyZWF0ZSIsImF1dGhfZ3JvdXBfdXBkYXRlIiwiYXV0aF9ncm91cF9pbmZvIiwiYXV0aF9ncm91cF9kZWxldGUiLCJhdXRoX2FkbWluX2NyZWF0ZSIsImF1dGhfYWRtaW5fdXBkYXRlIiwiYXV0aF9hZG1pbl9pbmZvIiwiYXV0aF9hZG1pbl9kZWxldGUiLCJob21lIl0sImFjY2Vzc1Rva2VuIjp0cnVlLCJpYXQiOjE3MjUzNDgxNDEsImV4cCI6MTcyNTM0OTk0MX0.mSZH3GCE7IlIYEtVDJdF41o8i3CUps9Nd3buuJSs-p0\",\"refreshToken\":\"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJpYXQiOjE3MjUzNDgxNDEsImV4cCI6MTcyNTk1Mjk0MX0.9OYQD19tRxQ1NyMHrI_Z4ELcW8tq7jpX1MV-db0YeCs\"}}',
    200,
    116,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    762,
    '2024-09-03 15:21:30.319464',
    '2024-09-03 15:21:30.319464',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    81,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    763,
    '2024-09-03 15:23:15.458558',
    '2024-09-03 15:23:15.458558',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    129,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    764,
    '2024-09-03 15:24:11.566825',
    '2024-09-03 15:24:11.566825',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    104,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    765,
    '2024-09-03 15:24:40.353347',
    '2024-09-03 15:24:40.353347',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    66,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    766,
    '2024-09-03 15:25:50.690440',
    '2024-09-03 15:25:50.690440',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    145,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    767,
    '2024-09-03 15:32:56.060598',
    '2024-09-03 15:32:56.060598',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    120,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    768,
    '2024-09-03 15:32:59.421815',
    '2024-09-03 15:32:59.421815',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    62,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    769,
    '2024-09-03 15:33:01.713546',
    '2024-09-03 15:33:01.713546',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    60,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    770,
    '2024-09-03 15:33:03.871775',
    '2024-09-03 15:33:03.871775',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    59,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    771,
    '2024-09-03 15:33:06.744792',
    '2024-09-03 15:33:06.744792',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    60,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    772,
    '2024-09-03 15:33:09.104767',
    '2024-09-03 15:33:09.104767',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    66,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    773,
    '2024-09-03 15:35:34.891292',
    '2024-09-03 15:35:34.891292',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    107,
    'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    774,
    '2024-09-03 15:38:27.121287',
    '2024-09-03 15:38:27.121287',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    175,
    'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    775,
    '2024-09-04 12:44:14.990574',
    '2024-09-04 12:44:14.990574',
    4,
    'admin',
    'refresh刷新token',
    '127.0.0.1',
    '内网IP',
    '/admin/refresh?refreshToken=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJpYXQiOjE3MjUzNDgxNDEsImV4cCI6MTcyNTk1Mjk0MX0.9OYQD19tRxQ1NyMHrI_Z4ELcW8tq7jpX1MV-db0YeCs',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"accessToken\":\"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJyb2xlcyI6WyLotoXnuqfnrqHnkIblkZgiXSwicGVybWlzc2lvbnMiOlsidXNlcl9ncm91cCIsImF1dGgiLCJhdXRoX2dyb3VwIiwiYXV0aF9sb2ciLCJ1c2VyIiwiYXV0aF9tZW51IiwiYXV0aF9hZG1pbiIsInVzZXJfaW5kZXgiLCJ1c2VyX3J1bGUiLCJ1c2VyX2xvZyIsInJvdXRpbmUiLCJyb3V0aW5lX2NvbmZpZyIsInJvdXRpbmVfYW5uZXgiLCJyb3V0aW5lX2luZm8iLCJtb2R1bGUiLCJhdXRoX2dyb3VwX2NyZWF0ZSIsImF1dGhfZ3JvdXBfdXBkYXRlIiwiYXV0aF9ncm91cF9pbmZvIiwiYXV0aF9ncm91cF9kZWxldGUiLCJhdXRoX2FkbWluX2NyZWF0ZSIsImF1dGhfYWRtaW5fdXBkYXRlIiwiYXV0aF9hZG1pbl9pbmZvIiwiYXV0aF9hZG1pbl9kZWxldGUiLCJob21lIl0sImFjY2Vzc1Rva2VuIjp0cnVlLCJpYXQiOjE3MjU0MjUxMDcsImV4cCI6MTcyNTQyNjkwN30.jotcXdH9y0UFs4sPLuf73uFNFqkrJ5fm9DJXiPq183c\",\"refreshToken\":\"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJpYXQiOjE3MjU0MjUxMDcsImV4cCI6MTcyNjAyOTkwN30.GjJyOTaB694s2FZmiJweK9encV6oF6kdceehU519mhY\"}}',
    200,
    266,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    776,
    '2024-09-04 12:44:15.149329',
    '2024-09-04 12:44:15.149329',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    154,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    777,
    '2024-09-07 10:54:56.274371',
    '2024-09-07 10:54:56.274371',
    4,
    'admin',
    'refresh刷新token',
    '127.0.0.1',
    '内网IP',
    '/admin/refresh?refreshToken=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJpYXQiOjE3MjU0MjUxMDcsImV4cCI6MTcyNjAyOTkwN30.GjJyOTaB694s2FZmiJweK9encV6oF6kdceehU519mhY',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"accessToken\":\"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJyb2xlcyI6WyLotoXnuqfnrqHnkIblkZgiXSwicGVybWlzc2lvbnMiOlsidXNlcl9ncm91cCIsImF1dGgiLCJhdXRoX2dyb3VwIiwiYXV0aF9sb2ciLCJ1c2VyIiwiYXV0aF9tZW51IiwiYXV0aF9hZG1pbiIsInVzZXJfaW5kZXgiLCJ1c2VyX3J1bGUiLCJ1c2VyX2xvZyIsInJvdXRpbmUiLCJyb3V0aW5lX2NvbmZpZyIsInJvdXRpbmVfYW5uZXgiLCJyb3V0aW5lX2luZm8iLCJtb2R1bGUiLCJhdXRoX2dyb3VwX2NyZWF0ZSIsImF1dGhfZ3JvdXBfdXBkYXRlIiwiYXV0aF9ncm91cF9pbmZvIiwiYXV0aF9ncm91cF9kZWxldGUiLCJhdXRoX2FkbWluX2NyZWF0ZSIsImF1dGhfYWRtaW5fdXBkYXRlIiwiYXV0aF9hZG1pbl9pbmZvIiwiYXV0aF9hZG1pbl9kZWxldGUiLCJob21lIl0sImFjY2Vzc1Rva2VuIjp0cnVlLCJpYXQiOjE3MjU2Nzc3NTEsImV4cCI6MTcyNTY3OTU1MX0.vtvHTOMFUtpOTXQfBNiPC83E3ZDEsaSYJZ-5GEgyokk\",\"refreshToken\":\"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJpYXQiOjE3MjU2Nzc3NTEsImV4cCI6MTcyNjI4MjU1MX0.DXvTr0pyD9bUKlS_by4F9jmPxgqGLjMu6t4epzvU-eg\"}}',
    200,
    136,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    778,
    '2024-09-07 10:54:56.455220',
    '2024-09-07 10:54:56.455220',
    4,
    'admin',
    '管理员管理-详情',
    '127.0.0.1',
    '内网IP',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-08-27 22:31:41\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-08-27 14:31:42\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    174,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    779,
    '2024-09-07 10:54:59.558759',
    '2024-09-07 10:54:59.558759',
    4,
    'admin',
    '附件管理',
    '127.0.0.1',
    '内网IP',
    '/files/list?page=1&size=10',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"page\":1,\"size\":10,\"total\":15,\"records\":[{\"id\":151,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"oceans.mp4\",\"hash\":\"9f8f979374969429263495ffcaac832cd603b1efe4c66a05fafd6729dffef9af\",\"path\":\"/uploads/2024/08/07/oceans.mp4\",\"mimetype\":\"video/mp4\",\"size\":23014356,\"uploadCount\":15,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/oceans.mp4\"},{\"id\":152,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"财务记账系统excel表格.xlsx\",\"hash\":\"b55ab38ff825b0360bea155510d9fee9c41812fabfe7e9fdb0aa36714195e266\",\"path\":\"/uploads/2024/08/07/财务记账系统excel表格.xlsx\",\"mimetype\":\"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet\",\"size\":97475,\"uploadCount\":4,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/财务记账系统excel表格.xlsx\"},{\"id\":153,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"测试Markdown.md\",\"hash\":\"9bab5812e9c7319230796121a872f2f10d47878d985c83fe88abd9e0119f73b0\",\"path\":\"/uploads/2024/08/07/测试Markdown.md\",\"mimetype\":\"application/octet-stream\",\"size\":11364,\"uploadCount\":2,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/测试Markdown.md\"},{\"id\":154,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"image.jpeg\",\"hash\":\"a737ff09ec2ce204c6a1e0edfe5af0b0c3a81c07af5d31f900b1ff55b39a2201\",\"path\":\"/uploads/2024/08/07/image.jpeg\",\"mimetype\":\"image/jpeg\",\"size\":106111,\"uploadCount\":11,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/image.jpeg\"},{\"id\":155,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"changtu1.jpg\",\"hash\":\"0d83b5b689384e4e08721f873a1c981cdcddd3de0f7493b23c21cc28efa4efee\",\"path\":\"/uploads/2024/08/07/changtu1.jpg\",\"mimetype\":\"image/jpeg\",\"size\":48593,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/changtu1.jpg\"},{\"id\":156,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.doc\",\"hash\":\"b7dcfae78826ae565dfdd434145d3b74aca506738c0c31952370dd6b610b549d\",\"path\":\"/uploads/2024/08/07/目录文件.doc\",\"mimetype\":\"application/msword\",\"size\":1055816,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.doc\"},{\"id\":157,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.htm\",\"hash\":\"c8cc7106cc4a16fedf0bafe622e8ede5905ff4f9b3064f03ecab7980dcb72671\",\"path\":\"/uploads/2024/08/07/目录文件.htm\",\"mimetype\":\"text/html\",\"size\":349870,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.htm\"},{\"id\":158,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.txt\",\"hash\":\"4fb5c4132a38bf42068b9cd58fa8419e792e786a4a4160faf8fabf33d623371f\",\"path\":\"/uploads/2024/08/07/目录文件.txt\",\"mimetype\":\"text/plain\",\"size\":413766,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.txt\"},{\"id\":159,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"时间线规则.xmind\",\"hash\":\"9e21393ff90f96b9570e6dc5d8f1b4ca148d520f738fea61d0e8633d86865cac\",\"path\":\"/uploads/2024/08/07/时间线规则.xmind\",\"mimetype\":\"application/octet-stream\",\"size\":47082,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/时间线规则.xmind\"},{\"id\":165,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"新建 PPT 演示文稿.ppt\",\"hash\":\"310b06ff0a793076844f8be83a752745b3915cd23e35427b88047b801be76424\",\"path\":\"/uploads/2024/08/07/新建 PPT 演示文稿.ppt\",\"mimetype\":\"application/vnd.ms-powerpoint\",\"size\":20992,\"uploadCount\":7,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/新建 PPT 演示文稿.ppt\"}],\"remark\":\"同一文件被多次上传时，只会保存一份至磁盘和增加一条附件记录；删除附件记录，将自动删除对应文件！\"}}',
    200,
    90,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    780,
    '2024-09-08 12:42:05.617003',
    '2024-09-08 12:42:05.617003',
    4,
    'admin',
    '登录',
    '::1',
    '',
    '/admin/login',
    'POST',
    '{\"username\":\"admin\",\"password\":\"123456\",\"captcha\":\"5\",\"remember\":1,\"uuid\":\"3d455ea7-5399-4e5b-af97-f134e895deec\"}',
    '{\"code\":201,\"message\":\"请求成功\",\"data\":{\"userInfo\":{\"id\":4,\"username\":\"admin\",\"nickname\":\"admin\",\"avatar\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-09-08 12:42:04\",\"createTime\":\"2024-08-27 02:19:49\",\"updateTime\":\"2024-08-27 22:31:41\",\"roles\":[\"超级管理员\"],\"permissions\":[\"user_group\",\"auth\",\"auth_group\",\"auth_log\",\"user\",\"auth_menu\",\"auth_admin\",\"user_index\",\"user_rule\",\"user_log\",\"routine\",\"routine_config\",\"routine_annex\",\"routine_info\",\"module\",\"auth_group_create\",\"auth_group_update\",\"auth_group_info\",\"auth_group_delete\",\"auth_admin_create\",\"auth_admin_update\",\"auth_admin_info\",\"auth_admin_delete\",\"home\"]},\"accessToken\":\"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJyb2xlcyI6WyLotoXnuqfnrqHnkIblkZgiXSwicGVybWlzc2lvbnMiOlsidXNlcl9ncm91cCIsImF1dGgiLCJhdXRoX2dyb3VwIiwiYXV0aF9sb2ciLCJ1c2VyIiwiYXV0aF9tZW51IiwiYXV0aF9hZG1pbiIsInVzZXJfaW5kZXgiLCJ1c2VyX3J1bGUiLCJ1c2VyX2xvZyIsInJvdXRpbmUiLCJyb3V0aW5lX2NvbmZpZyIsInJvdXRpbmVfYW5uZXgiLCJyb3V0aW5lX2luZm8iLCJtb2R1bGUiLCJhdXRoX2dyb3VwX2NyZWF0ZSIsImF1dGhfZ3JvdXBfdXBkYXRlIiwiYXV0aF9ncm91cF9pbmZvIiwiYXV0aF9ncm91cF9kZWxldGUiLCJhdXRoX2FkbWluX2NyZWF0ZSIsImF1dGhfYWRtaW5fdXBkYXRlIiwiYXV0aF9hZG1pbl9pbmZvIiwiYXV0aF9hZG1pbl9kZWxldGUiLCJob21lIl0sImFjY2Vzc1Rva2VuIjp0cnVlLCJpYXQiOjE3MjU3NzA1MjQsImV4cCI6MTcyNTc3MjMyNH0.Yv8Wd2hxs3tiAxb6814Ps6EMAHP33LI5c5B6NDq_YNw\",\"refreshToken\":\"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJpYXQiOjE3MjU3NzA1MjQsImV4cCI6MTcyNjM3NTMyNH0.paYoE1lF325pHX1UhtSGXQgbXc_RW_f2NrHtfC5O-AI\"}}',
    201,
    163,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    781,
    '2024-09-08 12:45:18.992089',
    '2024-09-08 12:45:18.992089',
    4,
    'admin',
    '登录',
    '::1',
    '',
    '/admin/login',
    'POST',
    '{\"username\":\"admin\",\"password\":\"123456\",\"captcha\":\"16\",\"remember\":1,\"uuid\":\"f9f7b855-f18f-40b4-9f84-2e8b3333780f\"}',
    '{\"code\":201,\"message\":\"请求成功\",\"data\":{\"userInfo\":{\"id\":4,\"username\":\"admin\",\"nickname\":\"admin\",\"avatar\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-09-08 12:45:19\",\"createTime\":\"2024-08-27 02:19:49\",\"updateTime\":\"2024-09-08 12:42:04\",\"roles\":[\"超级管理员\"],\"permissions\":[\"user_group\",\"auth\",\"auth_group\",\"auth_log\",\"user\",\"auth_menu\",\"auth_admin\",\"user_index\",\"user_rule\",\"user_log\",\"routine\",\"routine_config\",\"routine_annex\",\"routine_info\",\"module\",\"auth_group_create\",\"auth_group_update\",\"auth_group_info\",\"auth_group_delete\",\"auth_admin_create\",\"auth_admin_update\",\"auth_admin_info\",\"auth_admin_delete\",\"home\"]},\"accessToken\":\"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJyb2xlcyI6WyLotoXnuqfnrqHnkIblkZgiXSwicGVybWlzc2lvbnMiOlsidXNlcl9ncm91cCIsImF1dGgiLCJhdXRoX2dyb3VwIiwiYXV0aF9sb2ciLCJ1c2VyIiwiYXV0aF9tZW51IiwiYXV0aF9hZG1pbiIsInVzZXJfaW5kZXgiLCJ1c2VyX3J1bGUiLCJ1c2VyX2xvZyIsInJvdXRpbmUiLCJyb3V0aW5lX2NvbmZpZyIsInJvdXRpbmVfYW5uZXgiLCJyb3V0aW5lX2luZm8iLCJtb2R1bGUiLCJhdXRoX2dyb3VwX2NyZWF0ZSIsImF1dGhfZ3JvdXBfdXBkYXRlIiwiYXV0aF9ncm91cF9pbmZvIiwiYXV0aF9ncm91cF9kZWxldGUiLCJhdXRoX2FkbWluX2NyZWF0ZSIsImF1dGhfYWRtaW5fdXBkYXRlIiwiYXV0aF9hZG1pbl9pbmZvIiwiYXV0aF9hZG1pbl9kZWxldGUiLCJob21lIl0sImFjY2Vzc1Rva2VuIjp0cnVlLCJpYXQiOjE3MjU3NzA3MTksImV4cCI6MTcyNTc3MjUxOX0.ZlfeI78bfEEmwRQND5ktf_1gAevIOgNXjrW7_YOI_2Q\",\"refreshToken\":\"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJpYXQiOjE3MjU3NzA3MTksImV4cCI6MTcyNjM3NTUxOX0.c2DkOdEFLzUukDaR4ubnk2iKqOO4tw42a0NP6rMcBIA\"}}',
    201,
    156,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    782,
    '2024-09-08 12:45:20.250035',
    '2024-09-08 12:45:20.250035',
    4,
    'admin',
    '管理员管理-详情',
    '::1',
    '',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-09-08 12:45:18\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-09-08 12:45:19\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    79,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    783,
    '2024-09-08 12:45:35.188730',
    '2024-09-08 12:45:35.188730',
    4,
    'admin',
    '管理员管理-详情',
    '::1',
    '',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-09-08 12:45:18\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-09-08 12:45:19\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    73,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    784,
    '2024-09-08 12:45:56.959768',
    '2024-09-08 12:45:56.959768',
    4,
    'admin',
    '管理员管理-详情',
    '::1',
    '',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-09-08 12:45:18\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-09-08 12:45:19\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    79,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    785,
    '2024-09-08 12:47:02.666276',
    '2024-09-08 12:47:02.666276',
    4,
    'admin',
    '管理员管理-详情',
    '::1',
    '',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-09-08 12:45:18\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-09-08 12:45:19\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    73,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    786,
    '2024-09-08 12:48:33.260413',
    '2024-09-08 12:48:33.260413',
    4,
    'admin',
    '登录',
    '::1',
    '',
    '/admin/login',
    'POST',
    '{\"username\":\"admin\",\"password\":\"123456\",\"captcha\":\"4\",\"remember\":1,\"uuid\":\"eb9f9b3c-6703-43ad-be0d-18d608e97cfc\"}',
    '{\"code\":201,\"message\":\"请求成功\",\"data\":{\"userInfo\":{\"id\":4,\"username\":\"admin\",\"nickname\":\"admin\",\"avatar\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-09-08 12:48:33\",\"createTime\":\"2024-08-27 02:19:49\",\"updateTime\":\"2024-09-08 12:45:18\",\"roles\":[\"超级管理员\"],\"permissions\":[\"user_group\",\"auth\",\"auth_group\",\"auth_log\",\"user\",\"auth_menu\",\"auth_admin\",\"user_index\",\"user_rule\",\"user_log\",\"routine\",\"routine_config\",\"routine_annex\",\"routine_info\",\"module\",\"auth_group_create\",\"auth_group_update\",\"auth_group_info\",\"auth_group_delete\",\"auth_admin_create\",\"auth_admin_update\",\"auth_admin_info\",\"auth_admin_delete\",\"home\"]},\"accessToken\":\"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJyb2xlcyI6WyLotoXnuqfnrqHnkIblkZgiXSwicGVybWlzc2lvbnMiOlsidXNlcl9ncm91cCIsImF1dGgiLCJhdXRoX2dyb3VwIiwiYXV0aF9sb2ciLCJ1c2VyIiwiYXV0aF9tZW51IiwiYXV0aF9hZG1pbiIsInVzZXJfaW5kZXgiLCJ1c2VyX3J1bGUiLCJ1c2VyX2xvZyIsInJvdXRpbmUiLCJyb3V0aW5lX2NvbmZpZyIsInJvdXRpbmVfYW5uZXgiLCJyb3V0aW5lX2luZm8iLCJtb2R1bGUiLCJhdXRoX2dyb3VwX2NyZWF0ZSIsImF1dGhfZ3JvdXBfdXBkYXRlIiwiYXV0aF9ncm91cF9pbmZvIiwiYXV0aF9ncm91cF9kZWxldGUiLCJhdXRoX2FkbWluX2NyZWF0ZSIsImF1dGhfYWRtaW5fdXBkYXRlIiwiYXV0aF9hZG1pbl9pbmZvIiwiYXV0aF9hZG1pbl9kZWxldGUiLCJob21lIl0sImFjY2Vzc1Rva2VuIjp0cnVlLCJpYXQiOjE3MjU3NzA5MTMsImV4cCI6MTcyNTc3MjcxM30.9j5H5eQM6SDrg8cMfTf4VyGLp4390Q2JmrJuxEMeHKE\",\"refreshToken\":\"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJpYXQiOjE3MjU3NzA5MTMsImV4cCI6MTcyNjM3NTcxM30.gjqPPn4lj41Y8OJSqUxJ066j39qx8Z_F3-1DZIZYVZw\"}}',
    201,
    143,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    787,
    '2024-09-08 12:48:45.315303',
    '2024-09-08 12:48:45.315303',
    4,
    'admin',
    '管理员管理-详情',
    '::1',
    '',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-09-08 12:48:33\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-09-08 12:48:33\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    61,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    788,
    '2024-09-08 12:49:32.374641',
    '2024-09-08 12:49:32.374641',
    4,
    'admin',
    '登录',
    '::1',
    '',
    '/admin/login',
    'POST',
    '{\"username\":\"admin\",\"password\":\"123456\",\"captcha\":\"16\",\"remember\":1,\"uuid\":\"7d9137bd-9dc0-4596-8144-e6a1a7b9714e\"}',
    '{\"code\":201,\"message\":\"请求成功\",\"data\":{\"userInfo\":{\"id\":4,\"username\":\"admin\",\"nickname\":\"admin\",\"avatar\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-09-08 12:49:32\",\"createTime\":\"2024-08-27 02:19:49\",\"updateTime\":\"2024-09-08 12:48:33\",\"roles\":[\"超级管理员\"],\"permissions\":[\"user_group\",\"auth\",\"auth_group\",\"auth_log\",\"user\",\"auth_menu\",\"auth_admin\",\"user_index\",\"user_rule\",\"user_log\",\"routine\",\"routine_config\",\"routine_annex\",\"routine_info\",\"module\",\"auth_group_create\",\"auth_group_update\",\"auth_group_info\",\"auth_group_delete\",\"auth_admin_create\",\"auth_admin_update\",\"auth_admin_info\",\"auth_admin_delete\",\"home\"]},\"accessToken\":\"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJyb2xlcyI6WyLotoXnuqfnrqHnkIblkZgiXSwicGVybWlzc2lvbnMiOlsidXNlcl9ncm91cCIsImF1dGgiLCJhdXRoX2dyb3VwIiwiYXV0aF9sb2ciLCJ1c2VyIiwiYXV0aF9tZW51IiwiYXV0aF9hZG1pbiIsInVzZXJfaW5kZXgiLCJ1c2VyX3J1bGUiLCJ1c2VyX2xvZyIsInJvdXRpbmUiLCJyb3V0aW5lX2NvbmZpZyIsInJvdXRpbmVfYW5uZXgiLCJyb3V0aW5lX2luZm8iLCJtb2R1bGUiLCJhdXRoX2dyb3VwX2NyZWF0ZSIsImF1dGhfZ3JvdXBfdXBkYXRlIiwiYXV0aF9ncm91cF9pbmZvIiwiYXV0aF9ncm91cF9kZWxldGUiLCJhdXRoX2FkbWluX2NyZWF0ZSIsImF1dGhfYWRtaW5fdXBkYXRlIiwiYXV0aF9hZG1pbl9pbmZvIiwiYXV0aF9hZG1pbl9kZWxldGUiLCJob21lIl0sImFjY2Vzc1Rva2VuIjp0cnVlLCJpYXQiOjE3MjU3NzA5NzIsImV4cCI6MTcyNTc3Mjc3Mn0.cQufZviG5XqQ9UZH9-WhlVaJjoI1WDkZgOSDcHqG6Kw\",\"refreshToken\":\"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJpYXQiOjE3MjU3NzA5NzIsImV4cCI6MTcyNjM3NTc3Mn0.TJg_b6WK3HpN6SU9LeTnd7yLLdi-QIZkGT5gmWhXm7A\"}}',
    201,
    125,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    789,
    '2024-09-08 12:49:32.827709',
    '2024-09-08 12:49:32.827709',
    4,
    'admin',
    '管理员管理-详情',
    '::1',
    '',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-09-08 12:49:32\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-09-08 12:49:33\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    73,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    790,
    '2024-09-08 12:49:50.342740',
    '2024-09-08 12:49:50.342740',
    4,
    'admin',
    '管理员管理-详情',
    '::1',
    '',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-09-08 12:49:32\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-09-08 12:49:33\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    72,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    791,
    '2024-09-08 12:58:32.370860',
    '2024-09-08 12:58:32.370860',
    4,
    'admin',
    '登录',
    '::1',
    '',
    '/admin/login',
    'POST',
    '{\"username\":\"admin\",\"password\":\"123456\",\"captcha\":\"11\",\"remember\":1,\"uuid\":\"fcc857c1-cad2-4305-8e59-1a651056a0dc\"}',
    '{\"code\":201,\"message\":\"请求成功\",\"data\":{\"userInfo\":{\"id\":4,\"username\":\"admin\",\"nickname\":\"admin\",\"avatar\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-09-08 12:58:32\",\"createTime\":\"2024-08-27 02:19:49\",\"updateTime\":\"2024-09-08 12:49:32\",\"roles\":[\"超级管理员\"],\"permissions\":[\"user_group\",\"auth\",\"auth_group\",\"auth_log\",\"user\",\"auth_menu\",\"auth_admin\",\"user_index\",\"user_rule\",\"user_log\",\"routine\",\"routine_config\",\"routine_annex\",\"routine_info\",\"module\",\"auth_group_create\",\"auth_group_update\",\"auth_group_info\",\"auth_group_delete\",\"auth_admin_create\",\"auth_admin_update\",\"auth_admin_info\",\"auth_admin_delete\",\"home\"]},\"accessToken\":\"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJyb2xlcyI6WyLotoXnuqfnrqHnkIblkZgiXSwicGVybWlzc2lvbnMiOlsidXNlcl9ncm91cCIsImF1dGgiLCJhdXRoX2dyb3VwIiwiYXV0aF9sb2ciLCJ1c2VyIiwiYXV0aF9tZW51IiwiYXV0aF9hZG1pbiIsInVzZXJfaW5kZXgiLCJ1c2VyX3J1bGUiLCJ1c2VyX2xvZyIsInJvdXRpbmUiLCJyb3V0aW5lX2NvbmZpZyIsInJvdXRpbmVfYW5uZXgiLCJyb3V0aW5lX2luZm8iLCJtb2R1bGUiLCJhdXRoX2dyb3VwX2NyZWF0ZSIsImF1dGhfZ3JvdXBfdXBkYXRlIiwiYXV0aF9ncm91cF9pbmZvIiwiYXV0aF9ncm91cF9kZWxldGUiLCJhdXRoX2FkbWluX2NyZWF0ZSIsImF1dGhfYWRtaW5fdXBkYXRlIiwiYXV0aF9hZG1pbl9pbmZvIiwiYXV0aF9hZG1pbl9kZWxldGUiLCJob21lIl0sImFjY2Vzc1Rva2VuIjp0cnVlLCJpYXQiOjE3MjU3NzE1MTIsImV4cCI6MTcyNTc3MzMxMn0.Blcixjs_A3jBeGp1trVI4_mjNSF4W4m_x5uOee84H3o\",\"refreshToken\":\"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJpYXQiOjE3MjU3NzE1MTIsImV4cCI6MTcyNjM3NjMxMn0.GaCng93UKVCivHk1H8Qn7L3tf4NyiLM9qv3qXpfUeWU\"}}',
    201,
    378,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    792,
    '2024-09-08 12:58:32.870507',
    '2024-09-08 12:58:32.870507',
    4,
    'admin',
    '管理员管理-详情',
    '::1',
    '',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-09-08 12:58:32\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-09-08 12:58:32\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    67,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    793,
    '2024-09-08 12:58:40.493089',
    '2024-09-08 12:58:40.493089',
    4,
    'admin',
    '管理员管理-详情',
    '::1',
    '',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-09-08 12:58:32\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-09-08 12:58:32\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    63,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    794,
    '2024-09-08 13:01:41.437228',
    '2024-09-08 13:01:41.437228',
    4,
    'admin',
    '管理员管理-详情',
    '::1',
    '',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-09-08 12:58:32\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-09-08 12:58:32\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    116,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    795,
    '2024-09-08 13:02:13.087192',
    '2024-09-08 13:02:13.087192',
    4,
    'admin',
    '管理员管理-详情',
    '::1',
    '',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-09-08 12:58:32\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-09-08 12:58:32\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    321,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    796,
    '2024-09-08 13:02:26.423000',
    '2024-09-08 13:02:26.423000',
    4,
    'admin',
    '管理员管理-详情',
    '::1',
    '',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-09-08 12:58:32\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-09-08 12:58:32\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    61,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    797,
    '2024-09-08 13:03:46.219377',
    '2024-09-08 13:03:46.219377',
    4,
    'admin',
    '管理员管理-详情',
    '::1',
    '',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-09-08 12:58:32\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-09-08 12:58:32\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    99,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    798,
    '2024-09-08 13:05:00.842813',
    '2024-09-08 13:05:00.842813',
    4,
    'admin',
    '附件管理',
    '::1',
    '',
    '/files/list?page=1&size=10',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"page\":1,\"size\":10,\"total\":15,\"records\":[{\"id\":151,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"oceans.mp4\",\"hash\":\"9f8f979374969429263495ffcaac832cd603b1efe4c66a05fafd6729dffef9af\",\"path\":\"/uploads/2024/08/07/oceans.mp4\",\"mimetype\":\"video/mp4\",\"size\":23014356,\"uploadCount\":15,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/oceans.mp4\"},{\"id\":152,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"财务记账系统excel表格.xlsx\",\"hash\":\"b55ab38ff825b0360bea155510d9fee9c41812fabfe7e9fdb0aa36714195e266\",\"path\":\"/uploads/2024/08/07/财务记账系统excel表格.xlsx\",\"mimetype\":\"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet\",\"size\":97475,\"uploadCount\":4,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/财务记账系统excel表格.xlsx\"},{\"id\":153,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"测试Markdown.md\",\"hash\":\"9bab5812e9c7319230796121a872f2f10d47878d985c83fe88abd9e0119f73b0\",\"path\":\"/uploads/2024/08/07/测试Markdown.md\",\"mimetype\":\"application/octet-stream\",\"size\":11364,\"uploadCount\":2,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/测试Markdown.md\"},{\"id\":154,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"image.jpeg\",\"hash\":\"a737ff09ec2ce204c6a1e0edfe5af0b0c3a81c07af5d31f900b1ff55b39a2201\",\"path\":\"/uploads/2024/08/07/image.jpeg\",\"mimetype\":\"image/jpeg\",\"size\":106111,\"uploadCount\":11,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/image.jpeg\"},{\"id\":155,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"changtu1.jpg\",\"hash\":\"0d83b5b689384e4e08721f873a1c981cdcddd3de0f7493b23c21cc28efa4efee\",\"path\":\"/uploads/2024/08/07/changtu1.jpg\",\"mimetype\":\"image/jpeg\",\"size\":48593,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/changtu1.jpg\"},{\"id\":156,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.doc\",\"hash\":\"b7dcfae78826ae565dfdd434145d3b74aca506738c0c31952370dd6b610b549d\",\"path\":\"/uploads/2024/08/07/目录文件.doc\",\"mimetype\":\"application/msword\",\"size\":1055816,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.doc\"},{\"id\":157,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.htm\",\"hash\":\"c8cc7106cc4a16fedf0bafe622e8ede5905ff4f9b3064f03ecab7980dcb72671\",\"path\":\"/uploads/2024/08/07/目录文件.htm\",\"mimetype\":\"text/html\",\"size\":349870,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.htm\"},{\"id\":158,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.txt\",\"hash\":\"4fb5c4132a38bf42068b9cd58fa8419e792e786a4a4160faf8fabf33d623371f\",\"path\":\"/uploads/2024/08/07/目录文件.txt\",\"mimetype\":\"text/plain\",\"size\":413766,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.txt\"},{\"id\":159,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"时间线规则.xmind\",\"hash\":\"9e21393ff90f96b9570e6dc5d8f1b4ca148d520f738fea61d0e8633d86865cac\",\"path\":\"/uploads/2024/08/07/时间线规则.xmind\",\"mimetype\":\"application/octet-stream\",\"size\":47082,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/时间线规则.xmind\"},{\"id\":165,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"新建 PPT 演示文稿.ppt\",\"hash\":\"310b06ff0a793076844f8be83a752745b3915cd23e35427b88047b801be76424\",\"path\":\"/uploads/2024/08/07/新建 PPT 演示文稿.ppt\",\"mimetype\":\"application/vnd.ms-powerpoint\",\"size\":20992,\"uploadCount\":7,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/新建 PPT 演示文稿.ppt\"}],\"remark\":\"同一文件被多次上传时，只会保存一份至磁盘和增加一条附件记录；删除附件记录，将自动删除对应文件！\"}}',
    200,
    65,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    799,
    '2024-09-08 13:05:10.785505',
    '2024-09-08 13:05:10.785505',
    4,
    'admin',
    '管理员管理-详情',
    '::1',
    '',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-09-08 12:58:32\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-09-08 12:58:32\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    64,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    800,
    '2024-09-08 13:05:10.940010',
    '2024-09-08 13:05:10.940010',
    4,
    'admin',
    '附件管理',
    '::1',
    '',
    '/files/list?page=1&size=10',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"page\":1,\"size\":10,\"total\":15,\"records\":[{\"id\":151,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"oceans.mp4\",\"hash\":\"9f8f979374969429263495ffcaac832cd603b1efe4c66a05fafd6729dffef9af\",\"path\":\"/uploads/2024/08/07/oceans.mp4\",\"mimetype\":\"video/mp4\",\"size\":23014356,\"uploadCount\":15,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/oceans.mp4\"},{\"id\":152,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"财务记账系统excel表格.xlsx\",\"hash\":\"b55ab38ff825b0360bea155510d9fee9c41812fabfe7e9fdb0aa36714195e266\",\"path\":\"/uploads/2024/08/07/财务记账系统excel表格.xlsx\",\"mimetype\":\"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet\",\"size\":97475,\"uploadCount\":4,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/财务记账系统excel表格.xlsx\"},{\"id\":153,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"测试Markdown.md\",\"hash\":\"9bab5812e9c7319230796121a872f2f10d47878d985c83fe88abd9e0119f73b0\",\"path\":\"/uploads/2024/08/07/测试Markdown.md\",\"mimetype\":\"application/octet-stream\",\"size\":11364,\"uploadCount\":2,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/测试Markdown.md\"},{\"id\":154,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"image.jpeg\",\"hash\":\"a737ff09ec2ce204c6a1e0edfe5af0b0c3a81c07af5d31f900b1ff55b39a2201\",\"path\":\"/uploads/2024/08/07/image.jpeg\",\"mimetype\":\"image/jpeg\",\"size\":106111,\"uploadCount\":11,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/image.jpeg\"},{\"id\":155,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"changtu1.jpg\",\"hash\":\"0d83b5b689384e4e08721f873a1c981cdcddd3de0f7493b23c21cc28efa4efee\",\"path\":\"/uploads/2024/08/07/changtu1.jpg\",\"mimetype\":\"image/jpeg\",\"size\":48593,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/changtu1.jpg\"},{\"id\":156,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.doc\",\"hash\":\"b7dcfae78826ae565dfdd434145d3b74aca506738c0c31952370dd6b610b549d\",\"path\":\"/uploads/2024/08/07/目录文件.doc\",\"mimetype\":\"application/msword\",\"size\":1055816,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.doc\"},{\"id\":157,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.htm\",\"hash\":\"c8cc7106cc4a16fedf0bafe622e8ede5905ff4f9b3064f03ecab7980dcb72671\",\"path\":\"/uploads/2024/08/07/目录文件.htm\",\"mimetype\":\"text/html\",\"size\":349870,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.htm\"},{\"id\":158,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.txt\",\"hash\":\"4fb5c4132a38bf42068b9cd58fa8419e792e786a4a4160faf8fabf33d623371f\",\"path\":\"/uploads/2024/08/07/目录文件.txt\",\"mimetype\":\"text/plain\",\"size\":413766,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.txt\"},{\"id\":159,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"时间线规则.xmind\",\"hash\":\"9e21393ff90f96b9570e6dc5d8f1b4ca148d520f738fea61d0e8633d86865cac\",\"path\":\"/uploads/2024/08/07/时间线规则.xmind\",\"mimetype\":\"application/octet-stream\",\"size\":47082,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/时间线规则.xmind\"},{\"id\":165,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"新建 PPT 演示文稿.ppt\",\"hash\":\"310b06ff0a793076844f8be83a752745b3915cd23e35427b88047b801be76424\",\"path\":\"/uploads/2024/08/07/新建 PPT 演示文稿.ppt\",\"mimetype\":\"application/vnd.ms-powerpoint\",\"size\":20992,\"uploadCount\":7,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/新建 PPT 演示文稿.ppt\"}],\"remark\":\"同一文件被多次上传时，只会保存一份至磁盘和增加一条附件记录；删除附件记录，将自动删除对应文件！\"}}',
    200,
    195,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    801,
    '2024-09-08 13:50:01.048406',
    '2024-09-08 13:50:01.048406',
    4,
    'admin',
    'refresh刷新token',
    '::1',
    '',
    '/admin/refresh?refreshToken=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJpYXQiOjE3MjU3NzE1MTIsImV4cCI6MTcyNjM3NjMxMn0.GaCng93UKVCivHk1H8Qn7L3tf4NyiLM9qv3qXpfUeWU',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"accessToken\":\"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJyb2xlcyI6WyLotoXnuqfnrqHnkIblkZgiXSwicGVybWlzc2lvbnMiOlsidXNlcl9ncm91cCIsImF1dGgiLCJhdXRoX2dyb3VwIiwiYXV0aF9sb2ciLCJ1c2VyIiwiYXV0aF9tZW51IiwiYXV0aF9hZG1pbiIsInVzZXJfaW5kZXgiLCJ1c2VyX3J1bGUiLCJ1c2VyX2xvZyIsInJvdXRpbmUiLCJyb3V0aW5lX2NvbmZpZyIsInJvdXRpbmVfYW5uZXgiLCJyb3V0aW5lX2luZm8iLCJtb2R1bGUiLCJhdXRoX2dyb3VwX2NyZWF0ZSIsImF1dGhfZ3JvdXBfdXBkYXRlIiwiYXV0aF9ncm91cF9pbmZvIiwiYXV0aF9ncm91cF9kZWxldGUiLCJhdXRoX2FkbWluX2NyZWF0ZSIsImF1dGhfYWRtaW5fdXBkYXRlIiwiYXV0aF9hZG1pbl9pbmZvIiwiYXV0aF9hZG1pbl9kZWxldGUiLCJob21lIl0sImFjY2Vzc1Rva2VuIjp0cnVlLCJpYXQiOjE3MjU3NzQ2MDAsImV4cCI6MTcyNTc3NjQwMH0.RUGFm_NWTcRY--h5MeEFdfB3XcHIseYdrttFhyKhYyk\",\"refreshToken\":\"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJpYXQiOjE3MjU3NzQ2MDAsImV4cCI6MTcyNjM3OTQwMH0.44rnAJLMUnOLGnfYa_PtosL0l-p0oMKoOnVSFSONJUs\"}}',
    200,
    558,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    802,
    '2024-09-08 13:50:01.213498',
    '2024-09-08 13:50:01.213498',
    4,
    'admin',
    '管理员管理-详情',
    '::1',
    '',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-09-08 12:58:32\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-09-08 12:58:32\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    157,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    803,
    '2024-09-08 14:00:12.748534',
    '2024-09-08 14:00:12.748534',
    4,
    'admin',
    '管理员管理-详情',
    '::1',
    '',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-09-08 12:58:32\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-09-08 12:58:32\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    81,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    804,
    '2024-09-08 14:23:14.506894',
    '2024-09-08 14:23:14.506894',
    4,
    'admin',
    'refresh刷新token',
    '::1',
    '',
    '/admin/refresh?refreshToken=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJpYXQiOjE3MjU3NzQ2MDAsImV4cCI6MTcyNjM3OTQwMH0.44rnAJLMUnOLGnfYa_PtosL0l-p0oMKoOnVSFSONJUs',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"accessToken\":\"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJyb2xlcyI6WyLotoXnuqfnrqHnkIblkZgiXSwicGVybWlzc2lvbnMiOlsidXNlcl9ncm91cCIsImF1dGgiLCJhdXRoX2dyb3VwIiwiYXV0aF9sb2ciLCJ1c2VyIiwiYXV0aF9tZW51IiwiYXV0aF9hZG1pbiIsInVzZXJfaW5kZXgiLCJ1c2VyX3J1bGUiLCJ1c2VyX2xvZyIsInJvdXRpbmUiLCJyb3V0aW5lX2NvbmZpZyIsInJvdXRpbmVfYW5uZXgiLCJyb3V0aW5lX2luZm8iLCJtb2R1bGUiLCJhdXRoX2dyb3VwX2NyZWF0ZSIsImF1dGhfZ3JvdXBfdXBkYXRlIiwiYXV0aF9ncm91cF9pbmZvIiwiYXV0aF9ncm91cF9kZWxldGUiLCJhdXRoX2FkbWluX2NyZWF0ZSIsImF1dGhfYWRtaW5fdXBkYXRlIiwiYXV0aF9hZG1pbl9pbmZvIiwiYXV0aF9hZG1pbl9kZWxldGUiLCJob21lIl0sImFjY2Vzc1Rva2VuIjp0cnVlLCJpYXQiOjE3MjU3NzY1OTMsImV4cCI6MTcyNTc3ODM5M30.p838-4RwxBkM2st_MmbTwpA3lVXgr1kXCMlskbSHJ68\",\"refreshToken\":\"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJpYXQiOjE3MjU3NzY1OTMsImV4cCI6MTcyNjM4MTM5M30.pwMEMSSByOcSN3GyCVV2nCYmLLjTyjOpjrlUxN49bp0\"}}',
    200,
    123,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    805,
    '2024-09-08 14:23:14.752293',
    '2024-09-08 14:23:14.752293',
    4,
    'admin',
    '附件管理',
    '::1',
    '',
    '/files/list?page=1&size=10',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"page\":1,\"size\":10,\"total\":15,\"records\":[{\"id\":151,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"oceans.mp4\",\"hash\":\"9f8f979374969429263495ffcaac832cd603b1efe4c66a05fafd6729dffef9af\",\"path\":\"/uploads/2024/08/07/oceans.mp4\",\"mimetype\":\"video/mp4\",\"size\":23014356,\"uploadCount\":15,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/oceans.mp4\"},{\"id\":152,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"财务记账系统excel表格.xlsx\",\"hash\":\"b55ab38ff825b0360bea155510d9fee9c41812fabfe7e9fdb0aa36714195e266\",\"path\":\"/uploads/2024/08/07/财务记账系统excel表格.xlsx\",\"mimetype\":\"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet\",\"size\":97475,\"uploadCount\":4,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/财务记账系统excel表格.xlsx\"},{\"id\":153,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"测试Markdown.md\",\"hash\":\"9bab5812e9c7319230796121a872f2f10d47878d985c83fe88abd9e0119f73b0\",\"path\":\"/uploads/2024/08/07/测试Markdown.md\",\"mimetype\":\"application/octet-stream\",\"size\":11364,\"uploadCount\":2,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/测试Markdown.md\"},{\"id\":154,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"image.jpeg\",\"hash\":\"a737ff09ec2ce204c6a1e0edfe5af0b0c3a81c07af5d31f900b1ff55b39a2201\",\"path\":\"/uploads/2024/08/07/image.jpeg\",\"mimetype\":\"image/jpeg\",\"size\":106111,\"uploadCount\":11,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/image.jpeg\"},{\"id\":155,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"changtu1.jpg\",\"hash\":\"0d83b5b689384e4e08721f873a1c981cdcddd3de0f7493b23c21cc28efa4efee\",\"path\":\"/uploads/2024/08/07/changtu1.jpg\",\"mimetype\":\"image/jpeg\",\"size\":48593,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/changtu1.jpg\"},{\"id\":156,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.doc\",\"hash\":\"b7dcfae78826ae565dfdd434145d3b74aca506738c0c31952370dd6b610b549d\",\"path\":\"/uploads/2024/08/07/目录文件.doc\",\"mimetype\":\"application/msword\",\"size\":1055816,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.doc\"},{\"id\":157,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.htm\",\"hash\":\"c8cc7106cc4a16fedf0bafe622e8ede5905ff4f9b3064f03ecab7980dcb72671\",\"path\":\"/uploads/2024/08/07/目录文件.htm\",\"mimetype\":\"text/html\",\"size\":349870,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.htm\"},{\"id\":158,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"目录文件.txt\",\"hash\":\"4fb5c4132a38bf42068b9cd58fa8419e792e786a4a4160faf8fabf33d623371f\",\"path\":\"/uploads/2024/08/07/目录文件.txt\",\"mimetype\":\"text/plain\",\"size\":413766,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/目录文件.txt\"},{\"id\":159,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"时间线规则.xmind\",\"hash\":\"9e21393ff90f96b9570e6dc5d8f1b4ca148d520f738fea61d0e8633d86865cac\",\"path\":\"/uploads/2024/08/07/时间线规则.xmind\",\"mimetype\":\"application/octet-stream\",\"size\":47082,\"uploadCount\":1,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/时间线规则.xmind\"},{\"id\":165,\"updateTime\":\"2024-08-27 02:19:50\",\"createTime\":\"2024-08-27 02:19:50\",\"name\":\"新建 PPT 演示文稿.ppt\",\"hash\":\"310b06ff0a793076844f8be83a752745b3915cd23e35427b88047b801be76424\",\"path\":\"/uploads/2024/08/07/新建 PPT 演示文稿.ppt\",\"mimetype\":\"application/vnd.ms-powerpoint\",\"size\":20992,\"uploadCount\":7,\"username\":\"admin\",\"usertype\":1,\"url\":\"http://localhost:3010/uploads/2024/08/07/新建 PPT 演示文稿.ppt\"}],\"remark\":\"同一文件被多次上传时，只会保存一份至磁盘和增加一条附件记录；删除附件记录，将自动删除对应文件！\"}}',
    200,
    233,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    806,
    '2024-09-08 16:22:15.098029',
    '2024-09-08 16:22:15.098029',
    4,
    'admin',
    'refresh刷新token',
    '::1',
    '',
    '/admin/refresh?refreshToken=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJpYXQiOjE3MjU3NzY1OTMsImV4cCI6MTcyNjM4MTM5M30.pwMEMSSByOcSN3GyCVV2nCYmLLjTyjOpjrlUxN49bp0',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"accessToken\":\"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJyb2xlcyI6WyLotoXnuqfnrqHnkIblkZgiXSwicGVybWlzc2lvbnMiOlsidXNlcl9ncm91cCIsImF1dGgiLCJhdXRoX2dyb3VwIiwiYXV0aF9sb2ciLCJ1c2VyIiwiYXV0aF9tZW51IiwiYXV0aF9hZG1pbiIsInVzZXJfaW5kZXgiLCJ1c2VyX3J1bGUiLCJ1c2VyX2xvZyIsInJvdXRpbmUiLCJyb3V0aW5lX2NvbmZpZyIsInJvdXRpbmVfYW5uZXgiLCJyb3V0aW5lX2luZm8iLCJtb2R1bGUiLCJhdXRoX2dyb3VwX2NyZWF0ZSIsImF1dGhfZ3JvdXBfdXBkYXRlIiwiYXV0aF9ncm91cF9pbmZvIiwiYXV0aF9ncm91cF9kZWxldGUiLCJhdXRoX2FkbWluX2NyZWF0ZSIsImF1dGhfYWRtaW5fdXBkYXRlIiwiYXV0aF9hZG1pbl9pbmZvIiwiYXV0aF9hZG1pbl9kZWxldGUiLCJob21lIl0sImFjY2Vzc1Rva2VuIjp0cnVlLCJpYXQiOjE3MjU3ODM3MzQsImV4cCI6MTcyNTc4NTUzNH0.hR3vgcT51YBV_M3lddvy5mdR0fWc-jxapDdd9TkZj10\",\"refreshToken\":\"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJpYXQiOjE3MjU3ODM3MzQsImV4cCI6MTcyNjM4ODUzNH0.ubPQnpWbIr-2lPZP1upBrkaQRs7yWv1wNdag4NYwGKI\"}}',
    200,
    146,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    807,
    '2024-09-08 16:22:15.315681',
    '2024-09-08 16:22:15.315681',
    4,
    'admin',
    '管理员管理-详情',
    '::1',
    '',
    '/admin/detail/4',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"id\":4,\"updateTime\":\"2024-09-08 12:58:32\",\"username\":\"admin\",\"password\":null,\"nickname\":\"admin\",\"avatar\":\"/uploads/2024/07/13/640 (20).jpg\",\"email\":\"lxlsql@gmail.com\",\"phone\":null,\"motto\":null,\"status\":1,\"lastLoginIp\":\"::1\",\"lastLoginTime\":\"2024-09-08 12:58:32\",\"roles\":null,\"avatarFull\":\"http://localhost:3010/uploads/2024/07/13/640 (20).jpg\",\"roleIds\":[1]}}',
    200,
    179,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );
INSERT INTO
  `admin_logs` (
    `id`,
    `update_time`,
    `create_time`,
    `user_id`,
    `username`,
    `title`,
    `ip`,
    `ip_address`,
    `url`,
    `method`,
    `params`,
    `result`,
    `status`,
    `response_time`,
    `user_agent`
  )
VALUES
  (
    808,
    '2024-09-08 23:22:08.512620',
    '2024-09-08 23:22:08.512620',
    4,
    'admin',
    'refresh刷新token',
    '::1',
    '',
    '/admin/refresh?refreshToken=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJpYXQiOjE3MjU3ODM3MzQsImV4cCI6MTcyNjM4ODUzNH0.ubPQnpWbIr-2lPZP1upBrkaQRs7yWv1wNdag4NYwGKI',
    'GET',
    '{}',
    '{\"code\":200,\"message\":\"请求成功\",\"data\":{\"accessToken\":\"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJyb2xlcyI6WyLotoXnuqfnrqHnkIblkZgiXSwicGVybWlzc2lvbnMiOlsidXNlcl9ncm91cCIsImF1dGgiLCJhdXRoX2dyb3VwIiwiYXV0aF9sb2ciLCJ1c2VyIiwiYXV0aF9tZW51IiwiYXV0aF9hZG1pbiIsInVzZXJfaW5kZXgiLCJ1c2VyX3J1bGUiLCJ1c2VyX2xvZyIsInJvdXRpbmUiLCJyb3V0aW5lX2NvbmZpZyIsInJvdXRpbmVfYW5uZXgiLCJyb3V0aW5lX2luZm8iLCJtb2R1bGUiLCJhdXRoX2dyb3VwX2NyZWF0ZSIsImF1dGhfZ3JvdXBfdXBkYXRlIiwiYXV0aF9ncm91cF9pbmZvIiwiYXV0aF9ncm91cF9kZWxldGUiLCJhdXRoX2FkbWluX2NyZWF0ZSIsImF1dGhfYWRtaW5fdXBkYXRlIiwiYXV0aF9hZG1pbl9pbmZvIiwiYXV0aF9hZG1pbl9kZWxldGUiLCJob21lIl0sImFjY2Vzc1Rva2VuIjp0cnVlLCJpYXQiOjE3MjU4MDg5MjcsImV4cCI6MTcyNTgxMDcyN30.SOp3a0V4i5J2bst7YqpjUDruWSle46sNDYsYRpza5zI\",\"refreshToken\":\"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzaWduIjoiYWRtaW4iLCJ1c2VySWQiOjQsInVzZXJuYW1lIjoiYWRtaW4iLCJpYXQiOjE3MjU4MDg5MjcsImV4cCI6MTcyNjQxMzcyN30.sXFlBGtwtzKV6RZwKOT7wPnzqyMizMXqnn1RQOY_5CQ\"}}',
    200,
    112,
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36'
  );

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: admin_permissions
# ------------------------------------------------------------

INSERT INTO
  `admin_permissions` (
    `id`,
    `update_time`,
    `create_time`,
    `title`,
    `icon`,
    `name`,
    `path`,
    `component`,
    `parentId`,
    `sort`,
    `type`,
    `code`,
    `description`,
    `frame`,
    `cache`,
    `status`
  )
VALUES
  (
    1,
    '2024-08-27 02:19:48.347215',
    '2024-08-27 02:19:48.670919',
    '会员分组管理',
    NULL,
    'user_group',
    '/user/group',
    NULL,
    5,
    98,
    2,
    NULL,
    NULL,
    1,
    0,
    1
  );
INSERT INTO
  `admin_permissions` (
    `id`,
    `update_time`,
    `create_time`,
    `title`,
    `icon`,
    `name`,
    `path`,
    `component`,
    `parentId`,
    `sort`,
    `type`,
    `code`,
    `description`,
    `frame`,
    `cache`,
    `status`
  )
VALUES
  (
    2,
    '2024-08-27 02:19:48.347215',
    '2024-08-27 02:19:48.670919',
    '权限管理',
    'LineOutlined',
    'auth',
    '/auth',
    NULL,
    NULL,
    98,
    1,
    NULL,
    NULL,
    0,
    0,
    1
  );
INSERT INTO
  `admin_permissions` (
    `id`,
    `update_time`,
    `create_time`,
    `title`,
    `icon`,
    `name`,
    `path`,
    `component`,
    `parentId`,
    `sort`,
    `type`,
    `code`,
    `description`,
    `frame`,
    `cache`,
    `status`
  )
VALUES
  (
    3,
    '2024-08-27 02:19:48.347215',
    '2024-08-27 02:19:48.670919',
    '角色组管理',
    'AimOutlined',
    'auth_group',
    '/auth/group',
    NULL,
    2,
    99,
    2,
    NULL,
    NULL,
    1,
    0,
    1
  );
INSERT INTO
  `admin_permissions` (
    `id`,
    `update_time`,
    `create_time`,
    `title`,
    `icon`,
    `name`,
    `path`,
    `component`,
    `parentId`,
    `sort`,
    `type`,
    `code`,
    `description`,
    `frame`,
    `cache`,
    `status`
  )
VALUES
  (
    4,
    '2024-08-27 02:19:48.347215',
    '2024-08-27 02:19:48.670919',
    '管理员日志管理',
    'AlibabaOutlined',
    'auth_log',
    '/auth/log',
    NULL,
    2,
    96,
    2,
    NULL,
    NULL,
    1,
    0,
    1
  );
INSERT INTO
  `admin_permissions` (
    `id`,
    `update_time`,
    `create_time`,
    `title`,
    `icon`,
    `name`,
    `path`,
    `component`,
    `parentId`,
    `sort`,
    `type`,
    `code`,
    `description`,
    `frame`,
    `cache`,
    `status`
  )
VALUES
  (
    5,
    '2024-08-27 02:19:48.347215',
    '2024-08-27 02:19:48.670919',
    '会员管理',
    'AlibabaOutlined',
    'user',
    '/user',
    NULL,
    NULL,
    97,
    1,
    NULL,
    NULL,
    1,
    0,
    1
  );
INSERT INTO
  `admin_permissions` (
    `id`,
    `update_time`,
    `create_time`,
    `title`,
    `icon`,
    `name`,
    `path`,
    `component`,
    `parentId`,
    `sort`,
    `type`,
    `code`,
    `description`,
    `frame`,
    `cache`,
    `status`
  )
VALUES
  (
    6,
    '2024-08-27 02:19:48.347215',
    '2024-08-27 02:19:48.670919',
    '菜单规则管理',
    'LineOutlined',
    'auth_menu',
    '/auth/menu',
    NULL,
    2,
    97,
    2,
    NULL,
    NULL,
    1,
    0,
    1
  );
INSERT INTO
  `admin_permissions` (
    `id`,
    `update_time`,
    `create_time`,
    `title`,
    `icon`,
    `name`,
    `path`,
    `component`,
    `parentId`,
    `sort`,
    `type`,
    `code`,
    `description`,
    `frame`,
    `cache`,
    `status`
  )
VALUES
  (
    7,
    '2024-08-27 02:19:48.347215',
    '2024-08-27 02:19:48.670919',
    '管理员管理',
    'LineOutlined',
    'auth_admin',
    '/auth/admin',
    NULL,
    2,
    98,
    2,
    NULL,
    NULL,
    1,
    0,
    1
  );
INSERT INTO
  `admin_permissions` (
    `id`,
    `update_time`,
    `create_time`,
    `title`,
    `icon`,
    `name`,
    `path`,
    `component`,
    `parentId`,
    `sort`,
    `type`,
    `code`,
    `description`,
    `frame`,
    `cache`,
    `status`
  )
VALUES
  (
    8,
    '2024-08-27 02:19:48.347215',
    '2024-08-27 02:19:48.670919',
    '会员管理',
    'LineOutlined',
    'user_index',
    '/user/index',
    NULL,
    5,
    99,
    2,
    NULL,
    NULL,
    1,
    0,
    1
  );
INSERT INTO
  `admin_permissions` (
    `id`,
    `update_time`,
    `create_time`,
    `title`,
    `icon`,
    `name`,
    `path`,
    `component`,
    `parentId`,
    `sort`,
    `type`,
    `code`,
    `description`,
    `frame`,
    `cache`,
    `status`
  )
VALUES
  (
    9,
    '2024-08-27 02:19:48.347215',
    '2024-08-27 02:19:48.670919',
    '会员规则管理',
    'AimOutlined',
    'user_rule',
    '/User/Rule',
    NULL,
    5,
    97,
    2,
    NULL,
    NULL,
    1,
    0,
    1
  );
INSERT INTO
  `admin_permissions` (
    `id`,
    `update_time`,
    `create_time`,
    `title`,
    `icon`,
    `name`,
    `path`,
    `component`,
    `parentId`,
    `sort`,
    `type`,
    `code`,
    `description`,
    `frame`,
    `cache`,
    `status`
  )
VALUES
  (
    10,
    '2024-08-27 02:19:48.347215',
    '2024-08-27 02:19:48.670919',
    '会员日志管理',
    'LineOutlined',
    'user_log',
    '/User/Log',
    NULL,
    5,
    96,
    2,
    NULL,
    NULL,
    1,
    0,
    1
  );
INSERT INTO
  `admin_permissions` (
    `id`,
    `update_time`,
    `create_time`,
    `title`,
    `icon`,
    `name`,
    `path`,
    `component`,
    `parentId`,
    `sort`,
    `type`,
    `code`,
    `description`,
    `frame`,
    `cache`,
    `status`
  )
VALUES
  (
    11,
    '2024-08-27 02:19:48.347215',
    '2024-08-27 02:19:48.670919',
    '常规管理',
    'LineOutlined',
    'routine',
    '/routine',
    NULL,
    NULL,
    96,
    1,
    NULL,
    NULL,
    1,
    0,
    1
  );
INSERT INTO
  `admin_permissions` (
    `id`,
    `update_time`,
    `create_time`,
    `title`,
    `icon`,
    `name`,
    `path`,
    `component`,
    `parentId`,
    `sort`,
    `type`,
    `code`,
    `description`,
    `frame`,
    `cache`,
    `status`
  )
VALUES
  (
    12,
    '2024-08-27 02:19:48.347215',
    '2024-08-27 02:19:48.670919',
    '系统配置',
    'LineOutlined',
    'routine_config',
    '/routine/config',
    '/Routine/Config',
    11,
    99,
    2,
    NULL,
    NULL,
    1,
    0,
    1
  );
INSERT INTO
  `admin_permissions` (
    `id`,
    `update_time`,
    `create_time`,
    `title`,
    `icon`,
    `name`,
    `path`,
    `component`,
    `parentId`,
    `sort`,
    `type`,
    `code`,
    `description`,
    `frame`,
    `cache`,
    `status`
  )
VALUES
  (
    13,
    '2024-08-27 02:19:48.347215',
    '2024-08-27 02:19:48.670919',
    '附件管理',
    NULL,
    'routine_annex',
    '/routine/annex',
    '/Routine/Annex',
    11,
    97,
    2,
    NULL,
    NULL,
    1,
    0,
    1
  );
INSERT INTO
  `admin_permissions` (
    `id`,
    `update_time`,
    `create_time`,
    `title`,
    `icon`,
    `name`,
    `path`,
    `component`,
    `parentId`,
    `sort`,
    `type`,
    `code`,
    `description`,
    `frame`,
    `cache`,
    `status`
  )
VALUES
  (
    14,
    '2024-08-27 02:19:48.347215',
    '2024-08-27 02:19:48.670919',
    '个人资料',
    'LineOutlined',
    'routine_info',
    '/routine/info',
    '/Routine/Info',
    11,
    98,
    2,
    NULL,
    NULL,
    1,
    0,
    1
  );
INSERT INTO
  `admin_permissions` (
    `id`,
    `update_time`,
    `create_time`,
    `title`,
    `icon`,
    `name`,
    `path`,
    `component`,
    `parentId`,
    `sort`,
    `type`,
    `code`,
    `description`,
    `frame`,
    `cache`,
    `status`
  )
VALUES
  (
    15,
    '2024-08-27 02:19:48.347215',
    '2024-08-27 02:19:48.670919',
    '模块市场',
    NULL,
    'module',
    '/module',
    '/Module',
    NULL,
    95,
    2,
    NULL,
    NULL,
    1,
    0,
    0
  );
INSERT INTO
  `admin_permissions` (
    `id`,
    `update_time`,
    `create_time`,
    `title`,
    `icon`,
    `name`,
    `path`,
    `component`,
    `parentId`,
    `sort`,
    `type`,
    `code`,
    `description`,
    `frame`,
    `cache`,
    `status`
  )
VALUES
  (
    16,
    '2024-08-27 02:19:48.347215',
    '2024-08-27 02:19:48.670919',
    '新增',
    NULL,
    'auth_group_create',
    NULL,
    NULL,
    3,
    99,
    3,
    NULL,
    NULL,
    1,
    0,
    1
  );
INSERT INTO
  `admin_permissions` (
    `id`,
    `update_time`,
    `create_time`,
    `title`,
    `icon`,
    `name`,
    `path`,
    `component`,
    `parentId`,
    `sort`,
    `type`,
    `code`,
    `description`,
    `frame`,
    `cache`,
    `status`
  )
VALUES
  (
    17,
    '2024-08-27 02:19:48.347215',
    '2024-08-27 02:19:48.670919',
    '编辑',
    NULL,
    'auth_group_update',
    NULL,
    NULL,
    3,
    98,
    3,
    NULL,
    NULL,
    1,
    0,
    1
  );
INSERT INTO
  `admin_permissions` (
    `id`,
    `update_time`,
    `create_time`,
    `title`,
    `icon`,
    `name`,
    `path`,
    `component`,
    `parentId`,
    `sort`,
    `type`,
    `code`,
    `description`,
    `frame`,
    `cache`,
    `status`
  )
VALUES
  (
    18,
    '2024-08-27 02:19:48.347215',
    '2024-08-27 02:19:48.670919',
    '查看',
    NULL,
    'auth_group_info',
    NULL,
    NULL,
    3,
    97,
    3,
    NULL,
    NULL,
    1,
    0,
    1
  );
INSERT INTO
  `admin_permissions` (
    `id`,
    `update_time`,
    `create_time`,
    `title`,
    `icon`,
    `name`,
    `path`,
    `component`,
    `parentId`,
    `sort`,
    `type`,
    `code`,
    `description`,
    `frame`,
    `cache`,
    `status`
  )
VALUES
  (
    19,
    '2024-08-27 02:19:48.347215',
    '2024-08-27 02:19:48.670919',
    '删除',
    NULL,
    'auth_group_delete',
    NULL,
    NULL,
    3,
    96,
    3,
    NULL,
    NULL,
    1,
    0,
    1
  );
INSERT INTO
  `admin_permissions` (
    `id`,
    `update_time`,
    `create_time`,
    `title`,
    `icon`,
    `name`,
    `path`,
    `component`,
    `parentId`,
    `sort`,
    `type`,
    `code`,
    `description`,
    `frame`,
    `cache`,
    `status`
  )
VALUES
  (
    20,
    '2024-08-27 02:19:48.347215',
    '2024-08-27 02:19:48.670919',
    '新增',
    NULL,
    'auth_admin_create',
    NULL,
    NULL,
    7,
    99,
    3,
    NULL,
    NULL,
    1,
    0,
    1
  );
INSERT INTO
  `admin_permissions` (
    `id`,
    `update_time`,
    `create_time`,
    `title`,
    `icon`,
    `name`,
    `path`,
    `component`,
    `parentId`,
    `sort`,
    `type`,
    `code`,
    `description`,
    `frame`,
    `cache`,
    `status`
  )
VALUES
  (
    21,
    '2024-08-27 02:19:48.347215',
    '2024-08-27 02:19:48.670919',
    '编辑',
    NULL,
    'auth_admin_update',
    NULL,
    NULL,
    7,
    98,
    3,
    NULL,
    NULL,
    1,
    0,
    1
  );
INSERT INTO
  `admin_permissions` (
    `id`,
    `update_time`,
    `create_time`,
    `title`,
    `icon`,
    `name`,
    `path`,
    `component`,
    `parentId`,
    `sort`,
    `type`,
    `code`,
    `description`,
    `frame`,
    `cache`,
    `status`
  )
VALUES
  (
    22,
    '2024-08-27 02:19:48.347215',
    '2024-08-27 02:19:48.670919',
    '查看',
    NULL,
    'auth_admin_info',
    NULL,
    NULL,
    7,
    97,
    3,
    NULL,
    NULL,
    1,
    0,
    1
  );
INSERT INTO
  `admin_permissions` (
    `id`,
    `update_time`,
    `create_time`,
    `title`,
    `icon`,
    `name`,
    `path`,
    `component`,
    `parentId`,
    `sort`,
    `type`,
    `code`,
    `description`,
    `frame`,
    `cache`,
    `status`
  )
VALUES
  (
    23,
    '2024-08-27 02:19:48.347215',
    '2024-08-27 02:19:48.670919',
    '删除',
    NULL,
    'auth_admin_delete',
    NULL,
    NULL,
    7,
    96,
    3,
    NULL,
    NULL,
    1,
    0,
    1
  );
INSERT INTO
  `admin_permissions` (
    `id`,
    `update_time`,
    `create_time`,
    `title`,
    `icon`,
    `name`,
    `path`,
    `component`,
    `parentId`,
    `sort`,
    `type`,
    `code`,
    `description`,
    `frame`,
    `cache`,
    `status`
  )
VALUES
  (
    24,
    '2024-08-27 02:19:48.347215',
    '2024-08-27 02:19:48.670919',
    '首页',
    NULL,
    'home',
    '/home',
    NULL,
    NULL,
    99,
    2,
    NULL,
    NULL,
    1,
    0,
    1
  );

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: admin_role_permissions_relation
# ------------------------------------------------------------

INSERT INTO
  `admin_role_permissions_relation` (`role_id`, `permission_id`)
VALUES
  (1, 1);
INSERT INTO
  `admin_role_permissions_relation` (`role_id`, `permission_id`)
VALUES
  (1, 2);
INSERT INTO
  `admin_role_permissions_relation` (`role_id`, `permission_id`)
VALUES
  (1, 3);
INSERT INTO
  `admin_role_permissions_relation` (`role_id`, `permission_id`)
VALUES
  (1, 4);
INSERT INTO
  `admin_role_permissions_relation` (`role_id`, `permission_id`)
VALUES
  (1, 5);
INSERT INTO
  `admin_role_permissions_relation` (`role_id`, `permission_id`)
VALUES
  (1, 6);
INSERT INTO
  `admin_role_permissions_relation` (`role_id`, `permission_id`)
VALUES
  (1, 7);
INSERT INTO
  `admin_role_permissions_relation` (`role_id`, `permission_id`)
VALUES
  (1, 8);
INSERT INTO
  `admin_role_permissions_relation` (`role_id`, `permission_id`)
VALUES
  (1, 9);
INSERT INTO
  `admin_role_permissions_relation` (`role_id`, `permission_id`)
VALUES
  (1, 10);
INSERT INTO
  `admin_role_permissions_relation` (`role_id`, `permission_id`)
VALUES
  (1, 11);
INSERT INTO
  `admin_role_permissions_relation` (`role_id`, `permission_id`)
VALUES
  (1, 12);
INSERT INTO
  `admin_role_permissions_relation` (`role_id`, `permission_id`)
VALUES
  (1, 13);
INSERT INTO
  `admin_role_permissions_relation` (`role_id`, `permission_id`)
VALUES
  (1, 14);
INSERT INTO
  `admin_role_permissions_relation` (`role_id`, `permission_id`)
VALUES
  (1, 15);
INSERT INTO
  `admin_role_permissions_relation` (`role_id`, `permission_id`)
VALUES
  (1, 16);
INSERT INTO
  `admin_role_permissions_relation` (`role_id`, `permission_id`)
VALUES
  (1, 17);
INSERT INTO
  `admin_role_permissions_relation` (`role_id`, `permission_id`)
VALUES
  (1, 18);
INSERT INTO
  `admin_role_permissions_relation` (`role_id`, `permission_id`)
VALUES
  (1, 19);
INSERT INTO
  `admin_role_permissions_relation` (`role_id`, `permission_id`)
VALUES
  (1, 20);
INSERT INTO
  `admin_role_permissions_relation` (`role_id`, `permission_id`)
VALUES
  (1, 21);
INSERT INTO
  `admin_role_permissions_relation` (`role_id`, `permission_id`)
VALUES
  (1, 22);
INSERT INTO
  `admin_role_permissions_relation` (`role_id`, `permission_id`)
VALUES
  (1, 23);
INSERT INTO
  `admin_role_permissions_relation` (`role_id`, `permission_id`)
VALUES
  (1, 24);
INSERT INTO
  `admin_role_permissions_relation` (`role_id`, `permission_id`)
VALUES
  (9, 2);
INSERT INTO
  `admin_role_permissions_relation` (`role_id`, `permission_id`)
VALUES
  (9, 3);
INSERT INTO
  `admin_role_permissions_relation` (`role_id`, `permission_id`)
VALUES
  (9, 4);
INSERT INTO
  `admin_role_permissions_relation` (`role_id`, `permission_id`)
VALUES
  (9, 6);
INSERT INTO
  `admin_role_permissions_relation` (`role_id`, `permission_id`)
VALUES
  (9, 7);
INSERT INTO
  `admin_role_permissions_relation` (`role_id`, `permission_id`)
VALUES
  (9, 16);
INSERT INTO
  `admin_role_permissions_relation` (`role_id`, `permission_id`)
VALUES
  (9, 17);
INSERT INTO
  `admin_role_permissions_relation` (`role_id`, `permission_id`)
VALUES
  (9, 18);
INSERT INTO
  `admin_role_permissions_relation` (`role_id`, `permission_id`)
VALUES
  (9, 20);
INSERT INTO
  `admin_role_permissions_relation` (`role_id`, `permission_id`)
VALUES
  (9, 21);
INSERT INTO
  `admin_role_permissions_relation` (`role_id`, `permission_id`)
VALUES
  (9, 22);
INSERT INTO
  `admin_role_permissions_relation` (`role_id`, `permission_id`)
VALUES
  (9, 24);
INSERT INTO
  `admin_role_permissions_relation` (`role_id`, `permission_id`)
VALUES
  (10, 2);
INSERT INTO
  `admin_role_permissions_relation` (`role_id`, `permission_id`)
VALUES
  (10, 3);
INSERT INTO
  `admin_role_permissions_relation` (`role_id`, `permission_id`)
VALUES
  (10, 4);
INSERT INTO
  `admin_role_permissions_relation` (`role_id`, `permission_id`)
VALUES
  (10, 6);
INSERT INTO
  `admin_role_permissions_relation` (`role_id`, `permission_id`)
VALUES
  (10, 7);
INSERT INTO
  `admin_role_permissions_relation` (`role_id`, `permission_id`)
VALUES
  (10, 16);
INSERT INTO
  `admin_role_permissions_relation` (`role_id`, `permission_id`)
VALUES
  (10, 17);
INSERT INTO
  `admin_role_permissions_relation` (`role_id`, `permission_id`)
VALUES
  (10, 18);
INSERT INTO
  `admin_role_permissions_relation` (`role_id`, `permission_id`)
VALUES
  (10, 19);
INSERT INTO
  `admin_role_permissions_relation` (`role_id`, `permission_id`)
VALUES
  (10, 20);
INSERT INTO
  `admin_role_permissions_relation` (`role_id`, `permission_id`)
VALUES
  (10, 21);
INSERT INTO
  `admin_role_permissions_relation` (`role_id`, `permission_id`)
VALUES
  (10, 22);
INSERT INTO
  `admin_role_permissions_relation` (`role_id`, `permission_id`)
VALUES
  (10, 23);
INSERT INTO
  `admin_role_permissions_relation` (`role_id`, `permission_id`)
VALUES
  (11, 2);
INSERT INTO
  `admin_role_permissions_relation` (`role_id`, `permission_id`)
VALUES
  (11, 3);
INSERT INTO
  `admin_role_permissions_relation` (`role_id`, `permission_id`)
VALUES
  (11, 7);
INSERT INTO
  `admin_role_permissions_relation` (`role_id`, `permission_id`)
VALUES
  (11, 16);
INSERT INTO
  `admin_role_permissions_relation` (`role_id`, `permission_id`)
VALUES
  (11, 17);
INSERT INTO
  `admin_role_permissions_relation` (`role_id`, `permission_id`)
VALUES
  (11, 18);
INSERT INTO
  `admin_role_permissions_relation` (`role_id`, `permission_id`)
VALUES
  (11, 19);
INSERT INTO
  `admin_role_permissions_relation` (`role_id`, `permission_id`)
VALUES
  (11, 20);
INSERT INTO
  `admin_role_permissions_relation` (`role_id`, `permission_id`)
VALUES
  (11, 21);
INSERT INTO
  `admin_role_permissions_relation` (`role_id`, `permission_id`)
VALUES
  (11, 22);
INSERT INTO
  `admin_role_permissions_relation` (`role_id`, `permission_id`)
VALUES
  (11, 23);
INSERT INTO
  `admin_role_permissions_relation` (`role_id`, `permission_id`)
VALUES
  (12, 3);
INSERT INTO
  `admin_role_permissions_relation` (`role_id`, `permission_id`)
VALUES
  (12, 7);
INSERT INTO
  `admin_role_permissions_relation` (`role_id`, `permission_id`)
VALUES
  (12, 17);
INSERT INTO
  `admin_role_permissions_relation` (`role_id`, `permission_id`)
VALUES
  (12, 18);
INSERT INTO
  `admin_role_permissions_relation` (`role_id`, `permission_id`)
VALUES
  (12, 20);
INSERT INTO
  `admin_role_permissions_relation` (`role_id`, `permission_id`)
VALUES
  (12, 21);
INSERT INTO
  `admin_role_permissions_relation` (`role_id`, `permission_id`)
VALUES
  (12, 22);
INSERT INTO
  `admin_role_permissions_relation` (`role_id`, `permission_id`)
VALUES
  (12, 23);

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: admin_roles
# ------------------------------------------------------------

INSERT INTO
  `admin_roles` (
    `id`,
    `update_time`,
    `create_time`,
    `name`,
    `slug`,
    `description`,
    `sort`,
    `status`,
    `parent_id`
  )
VALUES
  (
    1,
    '2024-08-27 02:19:49.064334',
    '2024-08-27 02:19:49.366371',
    '超级管理员',
    'super_admin',
    NULL,
    99,
    1,
    NULL
  );
INSERT INTO
  `admin_roles` (
    `id`,
    `update_time`,
    `create_time`,
    `name`,
    `slug`,
    `description`,
    `sort`,
    `status`,
    `parent_id`
  )
VALUES
  (
    9,
    '2024-08-27 02:19:49.064334',
    '2024-08-27 02:19:49.366371',
    '普通管理员',
    'admin',
    NULL,
    99,
    1,
    1
  );
INSERT INTO
  `admin_roles` (
    `id`,
    `update_time`,
    `create_time`,
    `name`,
    `slug`,
    `description`,
    `sort`,
    `status`,
    `parent_id`
  )
VALUES
  (
    10,
    '2024-08-27 02:19:49.064334',
    '2024-08-27 02:19:49.366371',
    '超级会员',
    'super_member',
    NULL,
    99,
    1,
    9
  );
INSERT INTO
  `admin_roles` (
    `id`,
    `update_time`,
    `create_time`,
    `name`,
    `slug`,
    `description`,
    `sort`,
    `status`,
    `parent_id`
  )
VALUES
  (
    11,
    '2024-08-27 02:19:49.064334',
    '2024-08-27 02:19:49.366371',
    '普通会员',
    'member',
    NULL,
    99,
    1,
    10
  );
INSERT INTO
  `admin_roles` (
    `id`,
    `update_time`,
    `create_time`,
    `name`,
    `slug`,
    `description`,
    `sort`,
    `status`,
    `parent_id`
  )
VALUES
  (
    12,
    '2024-08-27 02:19:49.064334',
    '2024-08-27 02:19:49.366371',
    '普通用户',
    'user',
    NULL,
    99,
    1,
    11
  );

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: admin_roles_closure
# ------------------------------------------------------------

INSERT INTO
  `admin_roles_closure` (`id_ancestor`, `id_descendant`)
VALUES
  (1, 1);
INSERT INTO
  `admin_roles_closure` (`id_ancestor`, `id_descendant`)
VALUES
  (1, 9);
INSERT INTO
  `admin_roles_closure` (`id_ancestor`, `id_descendant`)
VALUES
  (1, 10);
INSERT INTO
  `admin_roles_closure` (`id_ancestor`, `id_descendant`)
VALUES
  (1, 11);
INSERT INTO
  `admin_roles_closure` (`id_ancestor`, `id_descendant`)
VALUES
  (1, 12);
INSERT INTO
  `admin_roles_closure` (`id_ancestor`, `id_descendant`)
VALUES
  (9, 9);
INSERT INTO
  `admin_roles_closure` (`id_ancestor`, `id_descendant`)
VALUES
  (9, 10);
INSERT INTO
  `admin_roles_closure` (`id_ancestor`, `id_descendant`)
VALUES
  (9, 11);
INSERT INTO
  `admin_roles_closure` (`id_ancestor`, `id_descendant`)
VALUES
  (9, 12);
INSERT INTO
  `admin_roles_closure` (`id_ancestor`, `id_descendant`)
VALUES
  (10, 10);
INSERT INTO
  `admin_roles_closure` (`id_ancestor`, `id_descendant`)
VALUES
  (10, 11);
INSERT INTO
  `admin_roles_closure` (`id_ancestor`, `id_descendant`)
VALUES
  (10, 12);
INSERT INTO
  `admin_roles_closure` (`id_ancestor`, `id_descendant`)
VALUES
  (11, 11);
INSERT INTO
  `admin_roles_closure` (`id_ancestor`, `id_descendant`)
VALUES
  (11, 12);
INSERT INTO
  `admin_roles_closure` (`id_ancestor`, `id_descendant`)
VALUES
  (12, 12);

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: admin_roles_relation
# ------------------------------------------------------------

INSERT INTO
  `admin_roles_relation` (`admin_id`, `role_id`)
VALUES
  (4, 1);
INSERT INTO
  `admin_roles_relation` (`admin_id`, `role_id`)
VALUES
  (6, 1);
INSERT INTO
  `admin_roles_relation` (`admin_id`, `role_id`)
VALUES
  (6, 9);
INSERT INTO
  `admin_roles_relation` (`admin_id`, `role_id`)
VALUES
  (7, 12);
INSERT INTO
  `admin_roles_relation` (`admin_id`, `role_id`)
VALUES
  (8, 9);
INSERT INTO
  `admin_roles_relation` (`admin_id`, `role_id`)
VALUES
  (8, 11);

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: admins
# ------------------------------------------------------------

INSERT INTO
  `admins` (
    `id`,
    `update_time`,
    `create_time`,
    `username`,
    `password`,
    `nickname`,
    `avatar`,
    `email`,
    `phone`,
    `motto`,
    `status`,
    `last_login_ip`,
    `last_login_time`
  )
VALUES
  (
    4,
    '2024-09-08 12:58:32.000000',
    '2024-08-27 02:19:49.879849',
    'admin',
    'f52bcfe6884963f5ac1e723241c78778',
    'admin',
    '/uploads/2024/07/13/640 (20).jpg',
    'lxlsql@gmail.com',
    NULL,
    NULL,
    1,
    '::1',
    '2024-09-08 12:58:32'
  );
INSERT INTO
  `admins` (
    `id`,
    `update_time`,
    `create_time`,
    `username`,
    `password`,
    `nickname`,
    `avatar`,
    `email`,
    `phone`,
    `motto`,
    `status`,
    `last_login_ip`,
    `last_login_time`
  )
VALUES
  (
    6,
    '2024-08-27 02:19:49.645675',
    '2024-08-27 02:19:49.879849',
    'test',
    'f52bcfe6884963f5ac1e723241c78778',
    'test',
    '/uploads/2024/07/13/640 (21).jpg',
    '123456@qq.com',
    '13612341234',
    NULL,
    1,
    '127.0.0.1',
    '2024-08-01 06:32:01'
  );
INSERT INTO
  `admins` (
    `id`,
    `update_time`,
    `create_time`,
    `username`,
    `password`,
    `nickname`,
    `avatar`,
    `email`,
    `phone`,
    `motto`,
    `status`,
    `last_login_ip`,
    `last_login_time`
  )
VALUES
  (
    7,
    '2024-08-27 02:19:49.645675',
    '2024-08-27 02:19:49.879849',
    'test01',
    'f52bcfe6884963f5ac1e723241c78778',
    'test01',
    '/uploads/2024/07/13/微信图片_20240305174355.jpg',
    '123456@qq.com',
    '13612341234',
    NULL,
    1,
    '127.0.0.1',
    '2024-08-10 07:00:28'
  );
INSERT INTO
  `admins` (
    `id`,
    `update_time`,
    `create_time`,
    `username`,
    `password`,
    `nickname`,
    `avatar`,
    `email`,
    `phone`,
    `motto`,
    `status`,
    `last_login_ip`,
    `last_login_time`
  )
VALUES
  (
    8,
    '2024-08-27 02:19:49.645675',
    '2024-08-27 02:19:49.879849',
    'test02',
    'f52bcfe6884963f5ac1e723241c78778',
    'test02',
    '/uploads/2024/08/10/640 (19).jpg',
    NULL,
    NULL,
    NULL,
    1,
    '127.0.0.1',
    '2024-08-10 06:48:50'
  );

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: config
# ------------------------------------------------------------

INSERT INTO
  `config` (
    `id`,
    `update_time`,
    `create_time`,
    `title`,
    `name`,
    `type`,
    `tip`,
    `rule`,
    `content`,
    `value`,
    `extend`,
    `input_extend`,
    `weight`,
    `group_id`
  )
VALUES
  (
    1,
    '2024-08-27 02:19:51.243189',
    '2024-08-27 02:19:51.466492',
    '站点名称',
    'siteName',
    'input',
    NULL,
    'required',
    NULL,
    '\"Pirate Admin\"',
    NULL,
    NULL,
    99,
    1
  );
INSERT INTO
  `config` (
    `id`,
    `update_time`,
    `create_time`,
    `title`,
    `name`,
    `type`,
    `tip`,
    `rule`,
    `content`,
    `value`,
    `extend`,
    `input_extend`,
    `weight`,
    `group_id`
  )
VALUES
  (
    3,
    '2024-08-27 02:19:51.243189',
    '2024-08-27 02:19:51.466492',
    'SMTP 服务器',
    'host',
    'input',
    NULL,
    'required',
    NULL,
    '\"smtp.qq.com\"',
    NULL,
    NULL,
    99,
    2
  );
INSERT INTO
  `config` (
    `id`,
    `update_time`,
    `create_time`,
    `title`,
    `name`,
    `type`,
    `tip`,
    `rule`,
    `content`,
    `value`,
    `extend`,
    `input_extend`,
    `weight`,
    `group_id`
  )
VALUES
  (
    8,
    '2024-08-27 02:19:51.243189',
    '2024-08-27 02:19:51.466492',
    '备案号',
    'recordNo',
    'input',
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    'placeholder=本站域名备案号',
    98,
    1
  );
INSERT INTO
  `config` (
    `id`,
    `update_time`,
    `create_time`,
    `title`,
    `name`,
    `type`,
    `tip`,
    `rule`,
    `content`,
    `value`,
    `extend`,
    `input_extend`,
    `weight`,
    `group_id`
  )
VALUES
  (
    9,
    '2024-08-27 02:19:51.243189',
    '2024-08-27 02:19:51.466492',
    '版本号',
    'version',
    'input',
    NULL,
    NULL,
    NULL,
    '\"1.0.0\"',
    NULL,
    'placeholder=系统版本号',
    97,
    1
  );
INSERT INTO
  `config` (
    `id`,
    `update_time`,
    `create_time`,
    `title`,
    `name`,
    `type`,
    `tip`,
    `rule`,
    `content`,
    `value`,
    `extend`,
    `input_extend`,
    `weight`,
    `group_id`
  )
VALUES
  (
    10,
    '2024-08-27 02:19:51.243189',
    '2024-08-27 02:19:51.466492',
    '时区',
    'timeZone',
    'input',
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    'placeholder=系统时区',
    96,
    1
  );
INSERT INTO
  `config` (
    `id`,
    `update_time`,
    `create_time`,
    `title`,
    `name`,
    `type`,
    `tip`,
    `rule`,
    `content`,
    `value`,
    `extend`,
    `input_extend`,
    `weight`,
    `group_id`
  )
VALUES
  (
    11,
    '2024-08-27 02:19:51.243189',
    '2024-08-27 02:19:51.466492',
    '禁止访问IP',
    'noAccessIp',
    'textarea',
    NULL,
    NULL,
    NULL,
    '\"\"',
    NULL,
    'placeholder=禁止访问站点的IP列表，一行一个',
    95,
    1
  );
INSERT INTO
  `config` (
    `id`,
    `update_time`,
    `create_time`,
    `title`,
    `name`,
    `type`,
    `tip`,
    `rule`,
    `content`,
    `value`,
    `extend`,
    `input_extend`,
    `weight`,
    `group_id`
  )
VALUES
  (
    12,
    '2024-08-27 02:19:51.243189',
    '2024-08-27 02:19:51.466492',
    '配置分组',
    'configGroup',
    'key-value',
    NULL,
    'array',
    NULL,
    '[{\"key\":\"basic\",\"value\":\"基础配置\"},{\"key\":\"email\",\"value\":\"邮件配置\"},{\"key\":\"configQuickEntrance\",\"value\":\"快捷配置入口\"}]',
    NULL,
    '',
    94,
    1
  );
INSERT INTO
  `config` (
    `id`,
    `update_time`,
    `create_time`,
    `title`,
    `name`,
    `type`,
    `tip`,
    `rule`,
    `content`,
    `value`,
    `extend`,
    `input_extend`,
    `weight`,
    `group_id`
  )
VALUES
  (
    13,
    '2024-09-03 14:53:15.000000',
    '2024-08-27 02:19:51.466492',
    '快捷配置入口',
    'configQuickEntrance',
    'key-value',
    NULL,
    NULL,
    NULL,
    '[{\"key\":\"首页\",\"value\":\"/admin/dashboard\"},{\"key\":\"系统配置\",\"value\":\"/admin/routine/config\"}]',
    NULL,
    NULL,
    99,
    3
  );
INSERT INTO
  `config` (
    `id`,
    `update_time`,
    `create_time`,
    `title`,
    `name`,
    `type`,
    `tip`,
    `rule`,
    `content`,
    `value`,
    `extend`,
    `input_extend`,
    `weight`,
    `group_id`
  )
VALUES
  (
    14,
    '2024-08-27 02:19:51.243189',
    '2024-08-27 02:19:51.466492',
    'SMTP 端口',
    'port',
    'input-number',
    NULL,
    'number',
    NULL,
    '587',
    NULL,
    'class=w-[100%]\nmin=0\nmax=65535',
    98,
    2
  );
INSERT INTO
  `config` (
    `id`,
    `update_time`,
    `create_time`,
    `title`,
    `name`,
    `type`,
    `tip`,
    `rule`,
    `content`,
    `value`,
    `extend`,
    `input_extend`,
    `weight`,
    `group_id`
  )
VALUES
  (
    15,
    '2024-08-27 02:19:51.243189',
    '2024-08-27 02:19:51.466492',
    'SMTP 用户名',
    'user',
    'input',
    NULL,
    NULL,
    NULL,
    '\"2455880592@qq.com\"',
    NULL,
    NULL,
    97,
    2
  );
INSERT INTO
  `config` (
    `id`,
    `update_time`,
    `create_time`,
    `title`,
    `name`,
    `type`,
    `tip`,
    `rule`,
    `content`,
    `value`,
    `extend`,
    `input_extend`,
    `weight`,
    `group_id`
  )
VALUES
  (
    16,
    '2024-08-27 02:19:51.243189',
    '2024-08-27 02:19:51.466492',
    'SMTP 密码',
    'pass',
    'input-password',
    NULL,
    NULL,
    NULL,
    '\"zdfhruhtocjuecbb\"',
    NULL,
    'autocomplete=new-password',
    96,
    2
  );
INSERT INTO
  `config` (
    `id`,
    `update_time`,
    `create_time`,
    `title`,
    `name`,
    `type`,
    `tip`,
    `rule`,
    `content`,
    `value`,
    `extend`,
    `input_extend`,
    `weight`,
    `group_id`
  )
VALUES
  (
    17,
    '2024-09-09 00:03:51.000000',
    '2024-08-28 10:12:33.000085',
    '日志保留天数',
    'daysToKeep',
    'input',
    NULL,
    NULL,
    NULL,
    '7',
    NULL,
    NULL,
    0,
    NULL
  );

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: config_group
# ------------------------------------------------------------

INSERT INTO
  `config_group` (`id`, `name`, `title`)
VALUES
  (1, 'basic', '基础配置');
INSERT INTO
  `config_group` (`id`, `name`, `title`)
VALUES
  (2, 'email', '邮件配置');
INSERT INTO
  `config_group` (`id`, `name`, `title`)
VALUES
  (3, 'configQuickEntrance', '快捷配置入口');

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: cron
# ------------------------------------------------------------

INSERT INTO
  `cron` (
    `id`,
    `update_time`,
    `create_time`,
    `name`,
    `type`,
    `description`,
    `cycle`,
    `cycle_type`,
    `save`,
    `sort`,
    `notice`,
    `notice_channel`,
    `status`,
    `cron`
  )
VALUES
  (
    1,
    '2024-09-08 16:31:37.905697',
    '2024-09-08 16:23:18.842254',
    '定时备份数据库',
    'sql_backup',
    NULL,
    NULL,
    NULL,
    NULL,
    0,
    0,
    NULL,
    1,
    '32 16 * * *'
  );

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: cron-log
# ------------------------------------------------------------

INSERT INTO
  `cron-log` (
    `id`,
    `create_time`,
    `result`,
    `status`,
    `cronId`,
    `backupFilePath`
  )
VALUES
  (
    1,
    '2024-09-08 23:59:52.296958',
    '开始数据库备份过程 - 2024-09-08T15:59:05.734Z\n数据库配置: {\"host\":\"119.23.48.155\",\"user\":\"pirate_admin_dev\",\"password\":\"***\",\"database\":\"pirate_admin_dev\"}\n开始执行 mysqldump\n数据库备份成功完成\n备份文件: backup-2024-09-08T15-59-05-734Z}.sql\n文件大小: 854.16 KB\n备份用时: 35.872 秒\n备份结束时间: 2024-09-08T15:59:41.606Z',
    1,
    NULL,
    'D:\\小冷睡着了\\Pirate-Admin\\packages\\server\\backups\\backup-2024-09-08T15-59-05-734Z}.sql'
  );
INSERT INTO
  `cron-log` (
    `id`,
    `create_time`,
    `result`,
    `status`,
    `cronId`,
    `backupFilePath`
  )
VALUES
  (
    2,
    '2024-09-09 00:02:08.748988',
    '开始数据库备份过程 - 2024-09-08T16:02:06.079Z\n数据库配置: {\"host\":\"119.23.48.155\",\"user\":\"pirate_admin_dev\",\"password\":\"***\",\"database\":\"pirate_admin_dev\"}\n创建备份目录: D:\\小冷睡着了\\Pirate-Admin\\packages\\server\\backups\n开始执行 mysqldump\n数据库备份成功完成\n备份文件: backup-2024-09-08T16-02-06-079Z.sql\n文件大小: 854.86 KB\n备份用时: 1.74 秒\n备份结束时间: 2024-09-08T16:02:07.819Z',
    1,
    NULL,
    'D:\\小冷睡着了\\Pirate-Admin\\packages\\server\\backups\\backup-2024-09-08T16-02-06-079Z.sql'
  );

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: files
# ------------------------------------------------------------

INSERT INTO
  `files` (
    `id`,
    `update_time`,
    `create_time`,
    `name`,
    `hash`,
    `path`,
    `mimetype`,
    `size`,
    `upload_count`,
    `username`,
    `usertype`
  )
VALUES
  (
    151,
    '2024-08-27 02:19:50.194165',
    '2024-08-27 02:19:50.416060',
    'oceans.mp4',
    '9f8f979374969429263495ffcaac832cd603b1efe4c66a05fafd6729dffef9af',
    '/uploads/2024/08/07/oceans.mp4',
    'video/mp4',
    23014356,
    15,
    'admin',
    1
  );
INSERT INTO
  `files` (
    `id`,
    `update_time`,
    `create_time`,
    `name`,
    `hash`,
    `path`,
    `mimetype`,
    `size`,
    `upload_count`,
    `username`,
    `usertype`
  )
VALUES
  (
    152,
    '2024-08-27 02:19:50.194165',
    '2024-08-27 02:19:50.416060',
    '财务记账系统excel表格.xlsx',
    'b55ab38ff825b0360bea155510d9fee9c41812fabfe7e9fdb0aa36714195e266',
    '/uploads/2024/08/07/财务记账系统excel表格.xlsx',
    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    97475,
    4,
    'admin',
    1
  );
INSERT INTO
  `files` (
    `id`,
    `update_time`,
    `create_time`,
    `name`,
    `hash`,
    `path`,
    `mimetype`,
    `size`,
    `upload_count`,
    `username`,
    `usertype`
  )
VALUES
  (
    153,
    '2024-08-27 02:19:50.194165',
    '2024-08-27 02:19:50.416060',
    '测试Markdown.md',
    '9bab5812e9c7319230796121a872f2f10d47878d985c83fe88abd9e0119f73b0',
    '/uploads/2024/08/07/测试Markdown.md',
    'application/octet-stream',
    11364,
    2,
    'admin',
    1
  );
INSERT INTO
  `files` (
    `id`,
    `update_time`,
    `create_time`,
    `name`,
    `hash`,
    `path`,
    `mimetype`,
    `size`,
    `upload_count`,
    `username`,
    `usertype`
  )
VALUES
  (
    154,
    '2024-08-27 02:19:50.194165',
    '2024-08-27 02:19:50.416060',
    'image.jpeg',
    'a737ff09ec2ce204c6a1e0edfe5af0b0c3a81c07af5d31f900b1ff55b39a2201',
    '/uploads/2024/08/07/image.jpeg',
    'image/jpeg',
    106111,
    11,
    'admin',
    1
  );
INSERT INTO
  `files` (
    `id`,
    `update_time`,
    `create_time`,
    `name`,
    `hash`,
    `path`,
    `mimetype`,
    `size`,
    `upload_count`,
    `username`,
    `usertype`
  )
VALUES
  (
    155,
    '2024-08-27 02:19:50.194165',
    '2024-08-27 02:19:50.416060',
    'changtu1.jpg',
    '0d83b5b689384e4e08721f873a1c981cdcddd3de0f7493b23c21cc28efa4efee',
    '/uploads/2024/08/07/changtu1.jpg',
    'image/jpeg',
    48593,
    1,
    'admin',
    1
  );
INSERT INTO
  `files` (
    `id`,
    `update_time`,
    `create_time`,
    `name`,
    `hash`,
    `path`,
    `mimetype`,
    `size`,
    `upload_count`,
    `username`,
    `usertype`
  )
VALUES
  (
    156,
    '2024-08-27 02:19:50.194165',
    '2024-08-27 02:19:50.416060',
    '目录文件.doc',
    'b7dcfae78826ae565dfdd434145d3b74aca506738c0c31952370dd6b610b549d',
    '/uploads/2024/08/07/目录文件.doc',
    'application/msword',
    1055816,
    1,
    'admin',
    1
  );
INSERT INTO
  `files` (
    `id`,
    `update_time`,
    `create_time`,
    `name`,
    `hash`,
    `path`,
    `mimetype`,
    `size`,
    `upload_count`,
    `username`,
    `usertype`
  )
VALUES
  (
    157,
    '2024-08-27 02:19:50.194165',
    '2024-08-27 02:19:50.416060',
    '目录文件.htm',
    'c8cc7106cc4a16fedf0bafe622e8ede5905ff4f9b3064f03ecab7980dcb72671',
    '/uploads/2024/08/07/目录文件.htm',
    'text/html',
    349870,
    1,
    'admin',
    1
  );
INSERT INTO
  `files` (
    `id`,
    `update_time`,
    `create_time`,
    `name`,
    `hash`,
    `path`,
    `mimetype`,
    `size`,
    `upload_count`,
    `username`,
    `usertype`
  )
VALUES
  (
    158,
    '2024-08-27 02:19:50.194165',
    '2024-08-27 02:19:50.416060',
    '目录文件.txt',
    '4fb5c4132a38bf42068b9cd58fa8419e792e786a4a4160faf8fabf33d623371f',
    '/uploads/2024/08/07/目录文件.txt',
    'text/plain',
    413766,
    1,
    'admin',
    1
  );
INSERT INTO
  `files` (
    `id`,
    `update_time`,
    `create_time`,
    `name`,
    `hash`,
    `path`,
    `mimetype`,
    `size`,
    `upload_count`,
    `username`,
    `usertype`
  )
VALUES
  (
    159,
    '2024-08-27 02:19:50.194165',
    '2024-08-27 02:19:50.416060',
    '时间线规则.xmind',
    '9e21393ff90f96b9570e6dc5d8f1b4ca148d520f738fea61d0e8633d86865cac',
    '/uploads/2024/08/07/时间线规则.xmind',
    'application/octet-stream',
    47082,
    1,
    'admin',
    1
  );
INSERT INTO
  `files` (
    `id`,
    `update_time`,
    `create_time`,
    `name`,
    `hash`,
    `path`,
    `mimetype`,
    `size`,
    `upload_count`,
    `username`,
    `usertype`
  )
VALUES
  (
    165,
    '2024-08-27 02:19:50.194165',
    '2024-08-27 02:19:50.416060',
    '新建 PPT 演示文稿.ppt',
    '310b06ff0a793076844f8be83a752745b3915cd23e35427b88047b801be76424',
    '/uploads/2024/08/07/新建 PPT 演示文稿.ppt',
    'application/vnd.ms-powerpoint',
    20992,
    7,
    'admin',
    1
  );
INSERT INTO
  `files` (
    `id`,
    `update_time`,
    `create_time`,
    `name`,
    `hash`,
    `path`,
    `mimetype`,
    `size`,
    `upload_count`,
    `username`,
    `usertype`
  )
VALUES
  (
    166,
    '2024-08-27 02:19:50.194165',
    '2024-08-27 02:19:50.416060',
    '新建 Microsoft Excel 工作表.xlsx',
    'caeb42858652a3240842f39c5777e7163d93ec47b88f0ce06bff6c09cee21271',
    '/uploads/2024/08/07/新建 Microsoft Excel 工作表.xlsx',
    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    6602,
    1,
    'admin',
    1
  );
INSERT INTO
  `files` (
    `id`,
    `update_time`,
    `create_time`,
    `name`,
    `hash`,
    `path`,
    `mimetype`,
    `size`,
    `upload_count`,
    `username`,
    `usertype`
  )
VALUES
  (
    167,
    '2024-08-27 02:19:50.194165',
    '2024-08-27 02:19:50.416060',
    '新建 WinRAR ZIP 压缩文件.ZIP',
    '8739c76e681f900923b900c9df0ef75cf421d39cabb54650c4b9ad19b6a76d85',
    '/uploads/2024/08/07/新建 WinRAR ZIP 压缩文件.ZIP',
    'application/x-zip-compressed',
    22,
    1,
    'admin',
    1
  );
INSERT INTO
  `files` (
    `id`,
    `update_time`,
    `create_time`,
    `name`,
    `hash`,
    `path`,
    `mimetype`,
    `size`,
    `upload_count`,
    `username`,
    `usertype`
  )
VALUES
  (
    168,
    '2024-08-27 02:19:50.194165',
    '2024-08-27 02:19:50.416060',
    '新建 XLS 工作表.rar',
    '6215c79a7d791b99d0d351c1692a92575811dd847e2f67b7b24dd85f66b32358',
    '/uploads/2024/08/07/新建 XLS 工作表.rar',
    'application/x-compressed',
    5541,
    1,
    'admin',
    1
  );
INSERT INTO
  `files` (
    `id`,
    `update_time`,
    `create_time`,
    `name`,
    `hash`,
    `path`,
    `mimetype`,
    `size`,
    `upload_count`,
    `username`,
    `usertype`
  )
VALUES
  (
    169,
    '2024-08-27 02:19:50.194165',
    '2024-08-27 02:19:50.416060',
    '640 (19).jpg',
    'd0fba6d55183191f96c39671f087acad70386a3593da89978aafaf9a8da8bd7e',
    '/uploads/2024/08/10/640 (19).jpg',
    'image/jpeg',
    58686,
    1,
    'admin',
    1
  );
INSERT INTO
  `files` (
    `id`,
    `update_time`,
    `create_time`,
    `name`,
    `hash`,
    `path`,
    `mimetype`,
    `size`,
    `upload_count`,
    `username`,
    `usertype`
  )
VALUES
  (
    170,
    '2024-08-27 02:19:50.194165',
    '2024-08-27 02:19:50.416060',
    '超宽图片.jpg',
    '9993abaae64732b2715121704a9b0973043688dd1ba11165046832ef20c53ffc',
    '/uploads/2024/08/17/超宽图片.jpg',
    'image/jpeg',
    6064,
    1,
    'admin',
    1
  );

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: user_permissions
# ------------------------------------------------------------


# ------------------------------------------------------------
# DATA DUMP FOR TABLE: user_role_permissions_relation
# ------------------------------------------------------------


# ------------------------------------------------------------
# DATA DUMP FOR TABLE: user_roles
# ------------------------------------------------------------


# ------------------------------------------------------------
# DATA DUMP FOR TABLE: user_roles_closure
# ------------------------------------------------------------


# ------------------------------------------------------------
# DATA DUMP FOR TABLE: user_roles_relation
# ------------------------------------------------------------


# ------------------------------------------------------------
# DATA DUMP FOR TABLE: users
# ------------------------------------------------------------

INSERT INTO
  `users` (
    `id`,
    `update_time`,
    `create_time`,
    `username`,
    `password`,
    `nickname`,
    `avatar`,
    `gender`,
    `email`,
    `phone`,
    `sign`,
    `status`,
    `last_login_ip`,
    `last_login_time`
  )
VALUES
  (
    1,
    '2024-08-27 02:19:47.811590',
    '2024-08-27 02:19:48.023312',
    'user',
    'f52bcfe6884963f5ac1e723241c78778',
    'User',
    NULL,
    0,
    NULL,
    NULL,
    NULL,
    1,
    '127.0.0.1',
    '2024-07-27 17:34:56'
  );

/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
