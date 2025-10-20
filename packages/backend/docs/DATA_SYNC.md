# 数据同步功能文档

## 概述

数据同步功能用于从子图（Subgraph）爬取用户行为数据到后端数据库中，为声誉评分系统提供数据支持。

## 功能特性

- **全量同步**: 同步所有用户的数据
- **增量同步**: 定期同步最近活跃用户的数据
- **单用户同步**: 同步指定用户的数据
- **批量同步**: 批量同步多个用户的数据
- **自动调度**: 支持定时自动同步
- **API接口**: 提供REST API进行手动同步

## 架构设计

### 核心组件

1. **Subgraph客户端** (`pkg/subgraph/client.go`)
   - 负责与子图进行GraphQL通信
   - 提供各种查询方法

2. **数据同步服务** (`internal/service/sync/data_sync_service.go`)
   - 核心同步逻辑
   - 数据转换和映射
   - 数据库操作

3. **同步调度器** (`internal/service/sync/sync_scheduler.go`)
   - 定时任务管理
   - 全量和增量同步调度

4. **API处理器** (`internal/api/handlers/sync_handler.go`)
   - REST API接口
   - 手动触发同步

## 数据流程

```
子图 (Subgraph) → GraphQL查询 → 数据转换 → 后端数据库
```

### 同步的数据类型

1. **用户基础信息**
   - 用户地址
   - 用户资料（姓名、邮箱、简介等）
   - 用户技能

2. **任务数据**
   - 固定支付任务
   - 投标任务
   - 里程碑任务

3. **争议数据**
   - 争议记录
   - 争议状态

4. **投标数据**
   - 用户投标记录
   - 投标金额和时间

## 使用方法

### 1. 自动同步

服务启动后会自动开始数据同步：

```bash
# 启动后端服务
cd packages/backend
make dev
```

同步调度器会自动运行：
- **全量同步**: 每天执行一次（开发模式：10分钟一次）
- **增量同步**: 每5分钟执行一次（开发模式：1分钟一次）

### 2. 手动同步

#### 使用CLI工具

```bash
# 全量同步所有用户
go run cmd/sync/main.go -action all

# 同步单个用户
go run cmd/sync/main.go -action user -address 0x1234...

# 批量同步多个用户
go run cmd/sync/main.go -action batch -addresses 0x1234...,0x5678...,0x9abc...
```

#### 使用API接口

```bash
# 全量同步
curl -X POST http://localhost:8080/api/v1/sync/users

# 同步单个用户
curl -X POST http://localhost:8080/api/v1/sync/users/0x1234...

# 批量同步
curl -X POST http://localhost:8080/api/v1/sync/users/batch \
  -H "Content-Type: application/json" \
  -d '{"addresses": ["0x1234...", "0x5678...", "0x9abc..."]}'

# 查看同步状态
curl http://localhost:8080/api/v1/sync/status
```

### 3. 配置选项

在 `config.yaml` 中配置同步参数：

```yaml
scheduler:
  weekly_update_enabled: true
  weekly_update_day: "sunday"
  weekly_update_hour: 2
  
  monthly_update_enabled: true
  monthly_update_day: 1
  monthly_update_hour: 3
  
  # 开发模式配置
  dev_mode: true
  dev_weekly_interval_minutes: 10
  dev_monthly_interval_minutes: 30
```

## API接口文档

### 同步所有用户

```http
POST /api/v1/sync/users
```

**响应:**
```json
{
  "message": "全量用户数据同步已启动",
  "status": "started"
}
```

### 同步单个用户

```http
POST /api/v1/sync/users/{address}
```

**参数:**
- `address`: 用户地址

**响应:**
```json
{
  "message": "用户数据同步完成",
  "address": "0x1234...",
  "status": "completed"
}
```

### 批量同步用户

```http
POST /api/v1/sync/users/batch
```

**请求体:**
```json
{
  "addresses": ["0x1234...", "0x5678...", "0x9abc..."]
}
```

**响应:**
```json
{
  "message": "批量同步完成",
  "total": 3,
  "success_count": 2,
  "failure_count": 1,
  "results": [
    {
      "address": "0x1234...",
      "status": "success"
    },
    {
      "address": "0x5678...",
      "status": "failed",
      "error": "用户不存在"
    }
  ]
}
```

### 获取同步状态

```http
GET /api/v1/sync/status
```

**响应:**
```json
{
  "status": "running",
  "last_sync_time": "2024-01-01T12:00:00Z",
  "sync_interval": "5 minutes",
  "dev_mode": true
}
```

## 数据库表结构

### 用户表 (users)
- `id`: 主键
- `address`: 用户地址（唯一）
- `created_at`: 创建时间
- `updated_at`: 更新时间

### 用户资料表 (user_profiles)
- `id`: 主键
- `user_id`: 用户ID（外键）
- `name`: 姓名
- `email`: 邮箱
- `bio`: 简介
- `website`: 网站
- `skills`: 技能列表

### 任务缓存表 (task_caches)
- `id`: 主键
- `task_id`: 任务ID（唯一）
- `task_type`: 任务类型（fixed, bidding, milestone）
- `creator_addr`: 创建者地址
- `worker_addr`: 工作者地址
- `status`: 任务状态
- `reward`: 奖励金额
- `deadline`: 截止时间
- `raw_data`: 原始数据（JSON）
- `last_synced`: 最后同步时间

## 监控和日志

### 日志级别

- **INFO**: 正常同步操作
- **WARN**: 同步警告（如用户不存在）
- **ERROR**: 同步错误

### 监控指标

- 同步成功率
- 同步耗时
- 数据量统计
- 错误率

## 故障排除

### 常见问题

1. **子图连接失败**
   - 检查子图URL配置
   - 确认子图服务是否运行

2. **数据库连接失败**
   - 检查数据库配置
   - 确认数据库服务是否运行

3. **同步数据不完整**
   - 检查子图数据是否完整
   - 查看同步日志

### 调试方法

1. **查看日志**
```bash
# 查看后端日志
make logs

# 查看特定同步日志
grep "sync" logs/app.log
```

2. **手动测试同步**
```bash
# 测试单个用户同步
go run cmd/sync/main.go -action user -address 0x1234...
```

3. **检查数据库**
```sql
-- 查看用户数据
SELECT * FROM users LIMIT 10;

-- 查看任务缓存
SELECT * FROM task_caches LIMIT 10;

-- 查看同步统计
SELECT COUNT(*) as total_users FROM users;
SELECT COUNT(*) as total_tasks FROM task_caches;
```

## 性能优化

### 批量处理

- 使用批量插入减少数据库操作
- 分批处理大量用户数据

### 增量同步

- 只同步最近活跃的用户
- 根据最后同步时间判断是否需要更新

### 错误处理

- 单个用户同步失败不影响其他用户
- 记录详细的错误信息
- 支持重试机制

## 扩展功能

### 未来计划

1. **智能同步**
   - 根据用户活跃度智能选择同步频率
   - 预测用户行为模式

2. **数据验证**
   - 同步数据完整性检查
   - 数据一致性验证

3. **性能监控**
   - 实时同步状态监控
   - 性能指标收集

4. **数据清理**
   - 自动清理过期数据
   - 数据压缩和归档
