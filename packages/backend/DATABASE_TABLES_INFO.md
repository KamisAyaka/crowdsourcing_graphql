# 数据库表信息总结

## 📊 当前数据库状态

### 表数量统计
- **总表数**: 7个表
- **增强表数**: 6个表
- **任务缓存表**: 1个表

## 🗄️ 数据库表详细信息

### 1. 增强用户表 (enhanced_users)
**存储信息**: 增强的用户基础信息
- **记录数**: 11条
- **主要字段**:
  - `id`: 主键
  - `address`: 用户地址（唯一）
  - `created_at`: 创建时间
  - `updated_at`: 更新时间
  - `deleted_at`: 软删除时间

**示例数据**:
```
地址: 0x14dc79964da2c08b23698b3d3cc7ca32193d9955
创建时间: 2025-10-20 06:40:36
```

### 2. 用户行为统计表 (user_behavior_stats)
**存储信息**: 用户的行为统计数据，用于Guild Score计算
- **记录数**: 11条
- **主要字段**:
  - **任务统计**: `total_tasks_created`, `total_tasks_completed`, `task_completion_rate`
  - **投标统计**: `total_bids_placed`, `total_bids_won`, `bid_win_rate`
  - **争议统计**: `total_disputes_as_worker`, `dispute_win_rate`
  - **财务统计**: `total_earnings`, `total_spent`, `net_profit`
  - **质量指标**: `quality_score`, `reliability_score`, `collaboration_score`

**当前状态**: 所有用户都有默认的行为统计数据（初始值）

### 3. 投标表 (bids)
**存储信息**: 用户投标记录
- **记录数**: 0条
- **主要字段**:
  - `task_id`: 任务ID
  - `bidder_addr`: 投标者地址
  - `amount`: 投标金额
  - `estimated_time`: 预计完成时间
  - `status`: 投标状态

### 4. 争议表 (disputes)
**存储信息**: 任务争议记录
- **记录数**: 0条
- **主要字段**:
  - `dispute_id`: 争议ID
  - `task_id`: 任务ID
  - `worker_addr`: 工作者地址
  - `creator_addr`: 创建者地址
  - `status`: 争议状态
  - `worker_approved`: 工作者是否同意
  - `creator_approved`: 创建者是否同意

### 5. 增强公会分数表 (enhanced_guild_scores)
**存储信息**: 用户的Guild Score分数和排名
- **记录数**: 0条（待计算）
- **主要字段**:
  - `total_score`: 总分数
  - `rank`: 排名
  - `rank_title`: 称号（Novice到Legend）
  - **详细分数**: `task_completion_score`, `bidding_score`, `dispute_score`等
  - `time_decay_factor`: 时间衰减因子

### 6. 增强公会分数历史表 (enhanced_guild_score_histories)
**存储信息**: 分数变化历史记录
- **记录数**: 0条
- **主要字段**:
  - `previous_score`: 之前分数
  - `new_score`: 新分数
  - `score_change`: 分数变化
  - `change_reason`: 变化原因
  - `event_type`: 触发事件类型

### 7. 增强AI分析表 (enhanced_ai_analyses)
**存储信息**: AI分析结果
- **记录数**: 0条
- **主要字段**:
  - `analysis_type`: 分析类型
  - `result`: 分析结果
  - `confidence`: 置信度
  - `is_anomaly`: 是否异常
  - `recommendations`: 建议

## 📈 数据状态分析

### ✅ 已完成的表
1. **enhanced_users**: 11个用户已迁移
2. **user_behavior_stats**: 11个用户的行为统计已创建（默认值）

### ⏳ 待填充的表
1. **bids**: 需要从子图同步投标数据
2. **disputes**: 需要从子图同步争议数据
3. **enhanced_guild_scores**: 需要运行分数计算
4. **enhanced_guild_score_histories**: 需要运行分数计算
5. **enhanced_ai_analyses**: 需要运行AI分析

### 🔄 原有表（保持兼容）
1. **users**: 原始用户表（11条记录）
2. **user_profiles**: 用户档案表（0条记录）
3. **guild_scores**: 原始公会分数表（0条记录）
4. **guild_score_histories**: 原始分数历史表（0条记录）
5. **ai_analyses**: 原始AI分析表（0条记录）
6. **task_caches**: 任务缓存表（2条记录）

## 🚀 下一步操作

### 1. 计算用户分数
```bash
make calculate-scores
```

### 2. 同步更多数据
```bash
# 从子图同步投标数据
# 从子图同步争议数据
```

### 3. 查看结果
```bash
make view-ranking
```

## 📊 表关系图

```
enhanced_users (11条记录)
├── user_behavior_stats (11条记录)
├── enhanced_guild_scores (0条记录，待计算)
├── enhanced_guild_score_histories (0条记录，待计算)
├── enhanced_ai_analyses (0条记录，待分析)
├── bids (0条记录，待同步)
└── disputes (0条记录，待同步)

原有表（保持兼容）
├── users (11条记录)
├── user_profiles (0条记录)
├── guild_scores (0条记录)
├── guild_score_histories (0条记录)
├── ai_analyses (0条记录)
└── task_caches (2条记录)
```

## 🎯 数据完整性

- **用户数据**: ✅ 完整（11个用户）
- **行为统计**: ✅ 完整（11个用户的默认统计）
- **任务数据**: ✅ 部分（2个任务缓存）
- **投标数据**: ❌ 待同步
- **争议数据**: ❌ 待同步
- **分数数据**: ❌ 待计算
- **AI分析**: ❌ 待分析

这个数据库设计为众包平台提供了完整的数据基础，支持用户行为分析、声誉评分和AI分析功能。
