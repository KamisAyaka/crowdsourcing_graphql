# 数据库设置说明

## 🎯 概述

为了不影响现有的子图数据库，我们为后端服务创建了一个独立的PostgreSQL数据库。

## 🗄️ 数据库配置

### 新数据库信息
- **容器名**: `guild-score-postgres`
- **端口**: `5433` (避免与现有数据库冲突)
- **数据库名**: `guild_score`
- **用户名**: `postgres`
- **密码**: `123456`
- **主机**: `localhost`

### 现有数据库 (保留)
- **子图数据库**: 端口 `5432` (保持不变)
- **其他数据库**: 端口 `5440` (保持不变)

## 🚀 快速开始

### 1. 创建新数据库
```bash
cd packages/backend
make db-new
```

### 2. 启动后端服务
```bash
make dev
```

### 3. 检查数据库状态
```bash
make db-status
make db-tables
```

## 🔧 数据库管理命令

### 基本操作
```bash
# 创建新数据库
make db-new

# 停止数据库
make db-stop

# 重启数据库
make db-restart

# 检查状态
make db-status

# 查看表结构
make db-tables

# 查看用户数据
make db-users
```

### 直接数据库操作
```bash
# 连接数据库
docker exec -it guild-score-postgres psql -U postgres -d guild_score

# 查看所有表
docker exec guild-score-postgres psql -U postgres -d guild_score -c "\dt"

# 查看用户数据
docker exec guild-score-postgres psql -U postgres -d guild_score -c "SELECT * FROM users LIMIT 5;"

# 查看任务缓存
docker exec guild-score-postgres psql -U postgres -d guild_score -c "SELECT * FROM task_caches LIMIT 5;"
```

## 📊 数据库表结构

### 核心表
1. **users** - 用户基础信息
2. **user_profiles** - 用户资料和技能
3. **guild_scores** - 声誉评分
4. **guild_score_histories** - 评分历史
5. **task_caches** - 任务数据缓存
6. **ai_analyses** - AI分析结果

### 表关系
```
users (1) ←→ (1) user_profiles
users (1) ←→ (1) guild_scores
users (1) ←→ (*) guild_score_histories
users (1) ←→ (*) task_caches
users (1) ←→ (*) ai_analyses
```

## 🔍 数据同步验证

### 检查同步状态
```bash
# 查看同步状态
make sync-status

# 手动触发同步
make sync-all

# 检查同步结果
make db-users
```

### 监控数据
```bash
# 实时查看用户数据
watch -n 5 'docker exec guild-score-postgres psql -U postgres -d guild_score -c "SELECT COUNT(*) FROM users;"'

# 查看任务数据
docker exec guild-score-postgres psql -U postgres -d guild_score -c "SELECT COUNT(*) FROM task_caches;"
```

## 🛠️ 故障排除

### 常见问题

1. **数据库连接失败**
   ```bash
   # 检查容器是否运行
   docker ps | grep guild-score-postgres
   
   # 检查端口是否被占用
   netstat -tlnp | grep 5433
   ```

2. **端口冲突**
   ```bash
   # 如果5433端口被占用，可以修改配置
   # 编辑 config.yaml 中的 port: 5433 改为其他端口
   ```

3. **数据同步失败**
   ```bash
   # 检查后端服务日志
   make logs
   
   # 检查数据库连接
   make db-status
   ```

### 重置数据库
```bash
# 完全重置数据库
make db-stop
make db-new
make dev
```

## 📈 性能监控

### 数据库性能
```bash
# 查看数据库大小
docker exec guild-score-postgres psql -U postgres -d guild_score -c "SELECT pg_size_pretty(pg_database_size('guild_score'));"

# 查看表大小
docker exec guild-score-postgres psql -U postgres -d guild_score -c "SELECT schemaname,tablename,pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) as size FROM pg_tables WHERE schemaname='public' ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;"
```

### 连接监控
```bash
# 查看活跃连接
docker exec guild-score-postgres psql -U postgres -d guild_score -c "SELECT * FROM pg_stat_activity WHERE datname='guild_score';"
```

## 🔒 安全注意事项

1. **密码安全**: 生产环境中请修改默认密码
2. **网络访问**: 数据库仅监听localhost，确保安全
3. **数据备份**: 定期备份重要数据
4. **权限管理**: 使用最小权限原则

## 📚 相关文档

- [数据同步功能文档](DATA_SYNC.md)
- [API接口文档](README_SYNC.md)
- [后端服务配置](config.yaml)

## ✅ 验证清单

- [ ] 数据库容器运行正常
- [ ] 后端服务连接成功
- [ ] 所有表结构创建完成
- [ ] 数据同步功能正常
- [ ] API接口响应正常
- [ ] 与现有数据库无冲突

现在你的新数据库已经准备就绪，可以开始使用数据同步功能了！
