# 增强数据库设计和Guild Score计算算法

## 🎯 概述

基于子图数据结构的深入分析，我们重新设计了数据库表结构并优化了Guild Score计算算法，以更好地支持用户行为分析和声誉评分。

## 📊 子图数据结构分析

### 可查询的主要实体

1. **用户相关**
   - `User`: 基础用户信息
   - `UserProfile`: 用户档案（姓名、邮箱、简介、网站）
   - `UserSkills`: 用户技能
   - `UserNFT`: 用户NFT信息

2. **任务相关**
   - `FixedPaymentTask`: 固定支付任务
   - `BiddingTask`: 投标任务
   - `MilestonePaymentTask`: 里程碑支付任务
   - `Bid`: 投标记录

3. **争议相关**
   - `Dispute`: 争议记录
   - `AdminVote`: 管理员投票

4. **其他**
   - `Content`: 内容创建
   - `RentalProject`: 租赁项目
   - `Proposal`: 提案
   - `Vote`: 投票记录

## 🗄️ 增强数据库表设计

### 1. 增强用户表 (enhanced_users)
```sql
CREATE TABLE enhanced_users (
    id SERIAL PRIMARY KEY,
    address VARCHAR(42) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    deleted_at TIMESTAMP NULL
);
```

### 2. 用户行为统计表 (user_behavior_stats)
```sql
CREATE TABLE user_behavior_stats (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES enhanced_users(id),
    
    -- 任务统计
    total_tasks_created INTEGER DEFAULT 0,
    total_tasks_completed INTEGER DEFAULT 0,
    total_tasks_assigned INTEGER DEFAULT 0,
    task_completion_rate DECIMAL(5,2) DEFAULT 0,
    
    -- 投标统计
    total_bids_placed INTEGER DEFAULT 0,
    total_bids_won INTEGER DEFAULT 0,
    bid_win_rate DECIMAL(5,2) DEFAULT 0,
    average_bid_amount DECIMAL(20,0) DEFAULT 0,
    
    -- 争议统计
    total_disputes_as_worker INTEGER DEFAULT 0,
    total_disputes_as_creator INTEGER DEFAULT 0,
    disputes_won_as_worker INTEGER DEFAULT 0,
    disputes_won_as_creator INTEGER DEFAULT 0,
    dispute_win_rate DECIMAL(5,2) DEFAULT 0,
    
    -- 财务统计
    total_earnings DECIMAL(20,0) DEFAULT 0,
    total_spent DECIMAL(20,0) DEFAULT 0,
    net_profit DECIMAL(20,0) DEFAULT 0,
    
    -- 时间统计
    average_task_duration BIGINT DEFAULT 0,
    total_active_time BIGINT DEFAULT 0,
    last_activity_at TIMESTAMP NULL,
    
    -- 质量指标
    on_time_delivery_rate DECIMAL(5,2) DEFAULT 0,
    quality_score DECIMAL(5,2) DEFAULT 0,
    reliability_score DECIMAL(5,2) DEFAULT 0,
    
    -- 社交指标
    collaboration_score DECIMAL(5,2) DEFAULT 0,
    communication_score DECIMAL(5,2) DEFAULT 0,
    
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);
```

### 3. 投标表 (bids)
```sql
CREATE TABLE bids (
    id SERIAL PRIMARY KEY,
    task_id VARCHAR(255) NOT NULL,
    bidder_addr VARCHAR(42) NOT NULL,
    amount DECIMAL(20,0) NOT NULL,
    estimated_time BIGINT NOT NULL,
    description TEXT,
    status VARCHAR(50) DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);
```

### 4. 争议表 (disputes)
```sql
CREATE TABLE disputes (
    id SERIAL PRIMARY KEY,
    dispute_id VARCHAR(255) NOT NULL,
    task_id VARCHAR(255) NOT NULL,
    worker_addr VARCHAR(42) NOT NULL,
    creator_addr VARCHAR(42) NOT NULL,
    reward_amount DECIMAL(20,0) NOT NULL,
    worker_share DECIMAL(20,0) NOT NULL,
    status VARCHAR(50) NOT NULL,
    proof_of_work TEXT,
    worker_approved BOOLEAN DEFAULT FALSE,
    creator_approved BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT NOW(),
    resolved_at TIMESTAMP NULL,
    distributed_at TIMESTAMP NULL
);
```

### 5. 增强公会分数表 (enhanced_guild_scores)
```sql
CREATE TABLE enhanced_guild_scores (
    id SERIAL PRIMARY KEY,
    user_id INTEGER UNIQUE NOT NULL REFERENCES enhanced_users(id),
    
    -- 基础分数
    total_score DECIMAL(10,2) DEFAULT 0,
    rank INTEGER DEFAULT 0,
    rank_title VARCHAR(50) DEFAULT 'Novice',
    
    -- 详细分数组成
    task_completion_score DECIMAL(10,2) DEFAULT 0,
    task_creation_score DECIMAL(10,2) DEFAULT 0,
    bidding_score DECIMAL(10,2) DEFAULT 0,
    dispute_score DECIMAL(10,2) DEFAULT 0,
    quality_score DECIMAL(10,2) DEFAULT 0,
    reliability_score DECIMAL(10,2) DEFAULT 0,
    collaboration_score DECIMAL(10,2) DEFAULT 0,
    communication_score DECIMAL(10,2) DEFAULT 0,
    activity_score DECIMAL(10,2) DEFAULT 0,
    
    -- 时间衰减因子
    time_decay_factor DECIMAL(5,2) DEFAULT 1.0,
    raw_score DECIMAL(10,2) DEFAULT 0,
    
    -- 统计信息
    total_tasks INTEGER DEFAULT 0,
    completed_tasks INTEGER DEFAULT 0,
    dispute_count INTEGER DEFAULT 0,
    last_activity_at TIMESTAMP NULL,
    
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);
```

## 🧮 增强Guild Score计算算法

### 分数组成权重

1. **任务完成分数 (40%)**
   - 基础分数：完成率 × 100
   - 质量奖励：按时交付率 × 20
   - 数量奖励：完成任务数量 × 2（最高50分）

2. **任务创建分数 (20%)**
   - 基础分数：创建任务数量 × 10
   - 质量奖励：任务完成率 × 30

3. **投标分数 (15%)**
   - 基础分数：投标胜率 × 50
   - 活跃度奖励：投标数量 × 2（最高30分）
   - 质量奖励：平均投标金额合理性

4. **争议分数 (10%)**
   - 负向影响：争议数量惩罚
   - 争议胜率奖励

5. **质量分数 (10%)**
   - 综合质量指标

6. **可靠性分数 (5%)**
   - 基于任务完成率和争议率

7. **协作分数 (5%)**
   - 协作指标

8. **沟通分数 (5%)**
   - 沟通指标

9. **活跃度分数 (5%)**
   - 活跃时间分数
   - 最近活跃度奖励

### 时间衰减算法

```go
// 时间衰减公式：1 / (1 + days/30)
decayFactor := 1.0 / (1.0 + daysSinceActivity/30.0)
```

### 排名系统

| 分数范围 | 排名 | 称号 |
|---------|------|------|
| ≥1000   | 1    | Legend |
| ≥800    | 2    | Master |
| ≥600    | 3    | Expert |
| ≥400    | 4    | Advanced |
| ≥200    | 5    | Intermediate |
| ≥100    | 6    | Beginner |
| <100    | 7    | Novice |

## 🚀 使用方法

### 数据库迁移
```bash
# 执行数据库迁移
make migrate

# 执行数据迁移
make data-migration
```

### 查看数据
```bash
# 查看增强用户数据
make db-enhanced-users

# 查看行为统计数据
make db-behavior-stats

# 查看增强分数数据
make db-enhanced-scores
```

### 计算分数
```bash
# 计算所有用户分数
make calculate-scores

# 查看用户排名
make view-ranking
```

## 📈 数据同步流程

1. **从子图获取数据**
   - 用户基本信息
   - 任务数据（创建、分配、完成）
   - 投标数据
   - 争议数据

2. **计算行为统计**
   - 任务完成率
   - 投标胜率
   - 争议胜率
   - 财务统计
   - 质量指标

3. **计算Guild Score**
   - 应用各项分数权重
   - 应用时间衰减
   - 计算排名和称号

4. **记录历史**
   - 分数变化历史
   - 排名变化历史
   - 变化原因分析

## 🔧 技术特性

- **模块化设计**: 每个组件独立可测试
- **可扩展性**: 易于添加新的评分维度
- **性能优化**: 使用索引和缓存
- **数据完整性**: 外键约束和数据验证
- **历史追踪**: 完整的分数变化历史
- **实时更新**: 支持增量数据同步

## 📊 监控和统计

- 用户行为分析
- 分数分布统计
- 排名变化趋势
- 争议解决率
- 任务完成质量

这个增强的数据库设计和Guild Score计算算法为众包平台提供了更全面、更准确的用户声誉评估系统。
