# Toolboxes 数据库设计文档

## 数据库概述
本文档描述了 Toolboxes 项目的数据库设计，包括表结构、字段说明和索引设计。

## 表结构设计

### 1. 用户表 (users)
用于存储用户基本信息。

| 字段名 | 类型 | 允许空 | 默认值 | 说明 |
|--------|------|--------|--------|------|
| id | bigint unsigned | 否 | AUTO_INCREMENT | 用户ID |
| username | varchar(50) | 否 | - | 用户名 |
| password | varchar(255) | 否 | - | 密码(加密) |
| email | varchar(100) | 否 | - | 邮箱 |
| avatar | varchar(255) | 是 | NULL | 头像URL |
| status | tinyint | 否 | 1 | 状态(1:正常 0:禁用) |
| last_login | timestamp | 是 | NULL | 最后登录时间 |
| created_at | timestamp | 否 | CURRENT_TIMESTAMP | 创建时间 |
| updated_at | timestamp | 否 | CURRENT_TIMESTAMP | 更新时间 |

索引：
- PRIMARY KEY (`id`)
- UNIQUE KEY `idx_username` (`username`)
- UNIQUE KEY `idx_email` (`email`)

### 2. 签到记录表 (checkins)
记录用户的签到信息。

| 字段名 | 类型 | 允许空 | 默认值 | 说明 |
|--------|------|--------|--------|------|
| id | bigint unsigned | 否 | AUTO_INCREMENT | 签到ID |
| user_id | bigint unsigned | 否 | - | 用户ID |
| checkin_time | timestamp | 否 | CURRENT_TIMESTAMP | 签到时间 |
| checkin_type | tinyint | 否 | 1 | 签到类型(1:普通 2:补签) |
| location | varchar(255) | 是 | NULL | 签到地点 |
| ip_address | varchar(50) | 是 | NULL | 签到IP |
| device_info | varchar(255) | 是 | NULL | 设备信息 |
| created_at | timestamp | 否 | CURRENT_TIMESTAMP | 创建时间 |

索引：
- PRIMARY KEY (`id`)
- KEY `idx_user_id` (`user_id`)
- KEY `idx_checkin_time` (`checkin_time`)
- CONSTRAINT `fk_checkins_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)

### 3. 日历事件表 (calendar_events)
存储用户的日历事件信息。

| 字段名 | 类型 | 允许空 | 默认值 | 说明 |
|--------|------|--------|--------|------|
| id | bigint unsigned | 否 | AUTO_INCREMENT | 事件ID |
| user_id | bigint unsigned | 否 | - | 用户ID |
| title | varchar(255) | 否 | - | 事件标题 |
| description | text | 是 | NULL | 事件描述 |
| start_time | timestamp | 否 | - | 开始时间 |
| end_time | timestamp | 否 | - | 结束时间 |
| location | varchar(255) | 是 | NULL | 地点 |
| event_type | tinyint | 否 | 1 | 事件类型(1:个人 2:工作 3:假期) |
| reminder | int | 是 | NULL | 提醒时间(分钟) |
| status | tinyint | 否 | 1 | 状态(1:正常 2:已取消) |
| created_at | timestamp | 否 | CURRENT_TIMESTAMP | 创建时间 |
| updated_at | timestamp | 否 | CURRENT_TIMESTAMP | 更新时间 |

索引：
- PRIMARY KEY (`id`)
- KEY `idx_user_id` (`user_id`)
- KEY `idx_start_time` (`start_time`)
- KEY `idx_end_time` (`end_time`)
- CONSTRAINT `fk_events_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)

### 4. 事件参与者表 (event_participants)
管理日历事件的参与者信息。

| 字段名 | 类型 | 允许空 | 默认值 | 说明 |
|--------|------|--------|--------|------|
| id | bigint unsigned | 否 | AUTO_INCREMENT | 参与者ID |
| event_id | bigint unsigned | 否 | - | 事件ID |
| user_id | bigint unsigned | 否 | - | 用户ID |
| status | tinyint | 否 | 1 | 状态(1:待确认 2:已接受 3:已拒绝) |
| created_at | timestamp | 否 | CURRENT_TIMESTAMP | 创建时间 |
| updated_at | timestamp | 否 | CURRENT_TIMESTAMP | 更新时间 |

索引：
- PRIMARY KEY (`id`)
- UNIQUE KEY `idx_event_user` (`event_id`, `user_id`)
- CONSTRAINT `fk_participants_event` FOREIGN KEY (`event_id`) REFERENCES `calendar_events` (`id`)
- CONSTRAINT `fk_participants_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)

### 5. 系统配置表 (system_configs)
存储系统级配置信息。

| 字段名 | 类型 | 允许空 | 默���值 | 说明 |
|--------|------|--------|--------|------|
| id | bigint unsigned | 否 | AUTO_INCREMENT | 配置ID |
| config_key | varchar(50) | 否 | - | 配置键 |
| config_value | text | 否 | - | 配置值 |
| description | varchar(255) | 是 | NULL | 配置描述 |
| created_at | timestamp | 否 | CURRENT_TIMESTAMP | 创建时间 |
| updated_at | timestamp | 否 | CURRENT_TIMESTAMP | 更新时间 |

索引：
- PRIMARY KEY (`id`)
- UNIQUE KEY `idx_config_key` (`config_key`)

## 设计说明

### 通用设计原则
1. 所有表都使用 InnoDB 引擎
2. 字符集统一使用 utf8mb4
3. 主键均使用 bigint unsigned 类型
4. 包含创建和更新时间戳
5. 关键字段都建立了适当的索引

### 安全性考虑
1. 用户密码使用加密存储
2. 关键操作都有状态跟踪
3. 使用外键约束保证数据完整性

### 性能优化
1. 合理的字段类型选择
2. 针对查询场景创建索引
3. 避免过度索引
4. 适当的字段长度定义 