# 数据同步功能使用说明

## 🎯 功能概述

数据同步功能实现了从子图（Subgraph）自动爬取用户行为数据到后端数据库，为声誉评分系统提供数据支持。

## 🚀 快速开始

### 1. 启动服务

```bash
# 启动数据库
cd packages/backend
make docker-up

# 启动后端服务（包含自动同步）
make dev
```

### 2. 手动同步

```bash
# 全量同步所有用户
make sync-all

# 同步单个用户
make sync-user ADDRESS=0x1234...

# 查看同步状态
make sync-status
```

### 3. API接口

```bash
# 全量同步
curl -X POST http://localhost:8080/api/v1/sync/users

# 同步单个用户
curl -X POST http://localhost:8080/api/v1/sync/users/0x1234...

# 批量同步
curl -X POST http://localhost:8080/api/v1/sync/users/batch \
  -H "Content-Type: application/json" \
  -d '{"addresses": ["0x1234...", "0x5678..."]}'

# 查看状态
curl http://localhost:8080/api/v1/sync/status
```

## 📊 同步的数据类型

- **用户基础信息**: 地址、资料、技能
- **任务数据**: 固定支付、投标、里程碑任务  
- **争议数据**: 争议记录和状态
- **投标数据**: 用户投标记录

## ⚙️ 配置选项

在 `config.yaml` 中配置：

```yaml
scheduler:
  dev_mode: true  # 开发模式
  dev_weekly_interval_minutes: 10  # 全量同步间隔
  dev_monthly_interval_minutes: 30  # 增量同步间隔
```

## 🔧 开发模式

开发模式下同步频率更高：
- 全量同步：每10分钟
- 增量同步：每1分钟

## 📝 测试

```bash
# 运行测试脚本
make test-sync

# 或直接运行
./scripts/test_sync.sh
```

## 🗄️ 数据库表

同步的数据存储在以下表中：
- `users`: 用户基础信息
- `user_profiles`: 用户资料和技能
- `task_caches`: 任务数据缓存
- `guild_scores`: 声誉评分
- `guild_score_histories`: 评分历史

## 📈 监控

- 查看日志：`make logs`
- 同步状态：`curl http://localhost:8080/api/v1/sync/status`
- 数据库统计：`docker exec guild-score-postgres psql -U postgres -d guild_score -c "SELECT COUNT(*) FROM users;"`

## 🚨 故障排除

### 常见问题

1. **数据库连接失败**
   ```bash
   # 检查数据库是否运行
   docker ps | grep postgres
   
   # 重启数据库
   make docker-down && make docker-up
   ```

2. **子图连接失败**
   - 检查子图URL配置
   - 确认子图服务是否运行

3. **同步数据不完整**
   - 查看同步日志
   - 检查子图数据是否完整

### 调试方法

```bash
# 查看详细日志
make logs

# 手动测试同步
go run cmd/sync/main.go -action user -address 0x1234...

# 检查数据库数据
docker exec guild-score-postgres psql -U postgres -d guild_score -c "SELECT * FROM users LIMIT 5;"
```

## 📚 详细文档

完整的技术文档请参考：`docs/DATA_SYNC.md`

## 🎉 完成

现在你的数据同步功能已经完全实现并可以使用了！

- ✅ 自动定时同步
- ✅ 手动同步API
- ✅ CLI工具
- ✅ 完整的错误处理
- ✅ 详细的文档和测试
