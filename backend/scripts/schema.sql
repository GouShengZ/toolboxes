-- 用户表
CREATE TABLE `users` (
    `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '用户ID',
    `username` varchar(50) NOT NULL COMMENT '用户名',
    `password` varchar(255) NOT NULL COMMENT '密码(加密)',
    `email` varchar(100) NOT NULL COMMENT '邮箱',
    `avatar` varchar(255) DEFAULT NULL COMMENT '头像URL',
    `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态(1:正常 0:禁用)',
    `last_login` timestamp NULL DEFAULT NULL COMMENT '最后登录时间',
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_username` (`username`),
    UNIQUE KEY `idx_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户表';

-- 签到记录表
CREATE TABLE `checkins` (
    `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '签到ID',
    `user_id` bigint unsigned NOT NULL COMMENT '用户ID',
    `checkin_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '签到时间',
    `checkin_type` tinyint NOT NULL DEFAULT '1' COMMENT '签到类型(1:普通签到 2:补签)',
    `location` varchar(255) DEFAULT NULL COMMENT '签到地点',
    `ip_address` varchar(50) DEFAULT NULL COMMENT '签到IP',
    `device_info` varchar(255) DEFAULT NULL COMMENT '设备信息',
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`id`),
    KEY `idx_user_id` (`user_id`),
    KEY `idx_checkin_time` (`checkin_time`),
    CONSTRAINT `fk_checkins_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='签到记录表';

-- 日历事件表
CREATE TABLE `calendar_events` (
    `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '事件ID',
    `user_id` bigint unsigned NOT NULL COMMENT '用户ID',
    `title` varchar(255) NOT NULL COMMENT '事件标题',
    `description` text DEFAULT NULL COMMENT '事件描述',
    `start_time` timestamp NOT NULL COMMENT '开始时间',
    `end_time` timestamp NOT NULL COMMENT '结束时间',
    `location` varchar(255) DEFAULT NULL COMMENT '地点',
    `event_type` tinyint NOT NULL DEFAULT '1' COMMENT '事件类型(1:个人 2:工作 3:假期)',
    `reminder` int DEFAULT NULL COMMENT '提醒时间(分钟)',
    `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态(1:正常 2:已取消)',
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_user_id` (`user_id`),
    KEY `idx_start_time` (`start_time`),
    KEY `idx_end_time` (`end_time`),
    CONSTRAINT `fk_events_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='日历事件表';

-- 事件参与者表
CREATE TABLE `event_participants` (
    `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '参与者ID',
    `event_id` bigint unsigned NOT NULL COMMENT '事件ID',
    `user_id` bigint unsigned NOT NULL COMMENT '用户ID',
    `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态(1:待确认 2:已接受 3:已拒绝)',
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_event_user` (`event_id`, `user_id`),
    CONSTRAINT `fk_participants_event` FOREIGN KEY (`event_id`) REFERENCES `calendar_events` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_participants_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='事件参与者表';

-- 系统配置表
CREATE TABLE `system_configs` (
    `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '配置ID',
    `config_key` varchar(50) NOT NULL COMMENT '配置键',
    `config_value` text NOT NULL COMMENT '配置值',
    `description` varchar(255) DEFAULT NULL COMMENT '配置描述',
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_config_key` (`config_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统配置表'; 