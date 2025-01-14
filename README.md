# Toolboxes 项目

## 项目概述
Toolboxes 是一个全栈开发的工具集合平台，采用前后端分离架构，提供多种实用工具和服务。

## 技术架构

### 后端 (`/backend`)
- 主要使用 Go 语言开发
- 核心模块：
  - `models`: 数据模型层，包含用户系统、签到系统和日历事件
  - `middleware`: 中间件层，提供日志记录、链路追踪、加密服务等功能

### 前端 (`/frontend`)
- 包含统一的请求处理模块
- 使用 Node.js 环境进行开发

## 主要功能
1. 用户系统
   - 用户注册登录
   - 用户信息管理

2. 签到系统
   - 用户签到
   - 签到记录追踪

3. 日历事件
   - 事件创建和管理
   - 日程安排

## 系统特性
1. 安全性
   - 加密中间件保护数据安全
   - 令牌桶算法实现精确限流
     - 可配置桶容量和填充速率
     - 支持分布式限流
     - 防止突发流量冲击

2. 可观测性
   - 完整的日志记录系统
   - 分布式链路追踪

3. 性能优化
   - 请求限流
   - 统一的前端请求处理

## 项目结构