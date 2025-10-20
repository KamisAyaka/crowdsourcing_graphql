# 子图数据概览

## 📊 从子图可以爬取的数据

基于对子图的查询，以下是可用的数据类型和示例：

## 👥 用户数据 (Users)

### 用户基本信息
```json
{
  "users": [
    {
      "id": "0x14dc79964da2c08b23698b3d3cc7ca32193d9955",
      "address": "0x14dc79964da2c08b23698b3d3cc7ca32193d9955",
      "profile": null,
      "createdTasks": [],
      "assignedTasks": [],
      "bids": [],
      "workerDisputes": [],
      "creatorDisputes": []
    }
  ]
}
```

### 用户关联数据
- **创建的任务**: `createdTasks`
- **分配的任务**: `assignedTasks`
- **投标记录**: `bids`
- **作为工作者的争议**: `workerDisputes`
- **作为创建者的争议**: `creatorDisputes`

## 📋 任务数据

### 1. 固定支付任务 (FixedPaymentTasks)
```json
{
  "fixedPaymentTasks": [
    {
      "id": "1",
      "taskId": "1",
      "creator": {
        "address": "0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266"
      },
      "worker": {
        "address": "0x70997970c51812dc3a010c7d01b50e0d17dc79c8"
      },
      "title": "Simple Task",
      "description": "This is a simple fixed payment task",
      "reward": "99000000000000000000",
      "deadline": "1763529315",
      "status": "Paid",
      "createdAt": "1760937415",
      "updatedAt": "1760937415"
    }
  ]
}
```

### 2. 投标任务 (BiddingTasks)
```json
{
  "biddingTasks": [
    {
      "id": "1",
      "taskId": "1",
      "creator": {
        "address": "0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266"
      },
      "worker": {
        "address": "0x70997970c51812dc3a010c7d01b50e0d17dc79c8"
      },
      "title": "Bidding Task",
      "description": "This is a task with bidding",
      "reward": "79200000000000000000",
      "deadline": "1763529315",
      "status": "Paid",
      "bids": [
        {
          "id": "1-0",
          "bidder": {
            "address": "0x3c44cdddb6a900fa2b585dd299e03d12fa4293bc"
          },
          "amount": "90000000000000000000",
          "estimatedTime": "604800",
          "description": "I can do this for 90 tokens"
        }
      ],
      "createdAt": "1760937415",
      "updatedAt": "1760937416"
    }
  ]
}
```

### 3. 里程碑任务 (MilestonePaymentTasks)
```json
{
  "milestonePaymentTasks": [
    {
      "id": "1",
      "taskId": "1",
      "creator": {
        "address": "0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266"
      },
      "worker": {
        "address": "0x3c44cdddb6a900fa2b585dd299e03d12fa4293bc"
      },
      "title": "Milestone Task",
      "description": "This is a task with milestones",
      "totalReward": "0",
      "deadline": "1766121315",
      "status": "InProgress",
      "milestones": [
        {
          "id": "1-0",
          "milestoneIndex": "0",
          "description": "First milestone",
          "reward": "50000000000000000000",
          "paid": true,
          "workProof": {
            "submitted": true,
            "approved": true
          }
        }
      ],
      "completedMilestonesCount": "3",
      "createdAt": "1760937416",
      "updatedAt": "1760937416"
    }
  ]
}
```

## 💰 投标数据 (Bids)

```json
{
  "bids": [
    {
      "id": "1-0",
      "taskId": "1",
      "bidder": {
        "address": "0x3c44cdddb6a900fa2b585dd299e03d12fa4293bc"
      },
      "amount": "90000000000000000000",
      "estimatedTime": "604800",
      "description": "I can do this for 90 tokens",
      "createdAt": "1760937415"
    }
  ]
}
```

## ⚖️ 争议数据 (Disputes)

```json
{
  "disputes": [
    {
      "id": "0",
      "disputeId": "0",
      "taskId": "2",
      "worker": {
        "address": "0x90f79bf6eb2c4f870365e785982e1f101e93b906"
      },
      "taskCreator": {
        "address": "0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266"
      },
      "rewardAmount": "150000000000000000000",
      "workerShare": "0",
      "status": "Filed",
      "proofOfWork": "Completed the disputed task",
      "workerApproved": false,
      "creatorApproved": false,
      "createdAt": "1760937416",
      "resolvedAt": null,
      "distributedAt": null
    }
  ]
}
```

## 📊 数据统计

### 当前子图数据量
- **用户数量**: 11个用户
- **固定支付任务**: 2个任务
- **投标任务**: 1个任务
- **里程碑任务**: 2个任务
- **投标记录**: 1个投标
- **争议记录**: 2个争议

### 任务状态分布
- **Paid**: 已完成并支付的任务
- **InProgress**: 进行中的任务
- **Cancelled**: 已取消的任务
- **Filed**: 已提交争议的任务

## 🔄 数据同步策略

### 1. 用户数据同步
- 同步用户基本信息
- 同步用户档案信息
- 同步用户技能信息

### 2. 任务数据同步
- 同步所有类型的任务
- 同步任务状态变化
- 同步任务完成情况

### 3. 投标数据同步
- 同步投标记录
- 同步投标结果
- 计算投标胜率

### 4. 争议数据同步
- 同步争议记录
- 同步争议解决情况
- 计算争议胜率

## 🎯 数据用途

### 用户行为分析
- **任务完成率**: 基于任务状态计算
- **投标胜率**: 基于投标结果计算
- **争议胜率**: 基于争议解决情况计算
- **财务统计**: 基于任务奖励和支付情况

### Guild Score计算
- **任务完成分数**: 基于任务完成情况
- **投标分数**: 基于投标表现
- **争议分数**: 基于争议处理情况
- **质量分数**: 基于任务完成质量

## 🚀 数据同步命令

```bash
# 同步所有用户数据
make sync-all

# 同步单个用户数据
make sync-user ADDRESS=0x1234...

# 查看同步状态
make sync-status
```

## 📈 数据质量

### 数据完整性
- ✅ 用户数据完整
- ✅ 任务数据完整
- ✅ 投标数据完整
- ✅ 争议数据完整

### 数据时效性
- 实时数据同步
- 增量数据更新
- 历史数据保留

这个子图为众包平台提供了丰富的数据源，支持全面的用户行为分析和声誉评分系统。
