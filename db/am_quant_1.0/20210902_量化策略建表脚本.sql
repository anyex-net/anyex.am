
drop table if exists QuantStrategyType;
create table QuantStrategyType
(
  id                  bigint          not null comment '主键' primary key,
  strategyType        varchar(20)     not null comment '策略类型',
  strategyTypeName    varchar(128)    not null comment '策略类型名称',
  status              int             not null comment '启用状态（0禁用1启用）',
  remark              varchar(128)    not null comment '备注',
  riskLevel           varchar(32)     not null comment '风险等级',
  feeRate             varchar(32)     not null comment '费率',
  hisYearYield        varchar(32)     not null comment '历史年化收益率',
  updateTime          bigint          not null comment '更新时间',
  createTime          bigint          not null comment '记录创建时间'
)
comment '量化策略类型信息表';

insert into QuantStrategyType(id, strategyType, strategyTypeName, status,remark,riskLevel,feeRate,hisYearYield, updateTime, createTime)
values (1, 'PLAddPos', '浮盈加仓', 1, '大概率爆仓，小概率百倍','极高','0.01%','无',1630570739000, 1630570739000);

drop table if exists QuantStrategyInfo;
create table QuantStrategyInfo
(
  id                  bigint          not null comment '主键' primary key,
  accountId           bigint          not null comment '账户id',
  strategyType        varchar(20)     not null comment '策略类型',
  strategyId          bigint          not null comment '策略id',
  strategyName        varchar(20)     not null comment '策略名称',
  accountNo           varchar(20)     not null comment '资金账号',
  status              int             not null comment '运行状态（0已暂停1运行中2运行异常3启动中4暂停中）',
  updateTime          bigint          not null comment '更新时间',
  exchange            varchar(10)     not null comment '交易所',
  marketType          varchar(10)     not null comment '市场类型(wp,np,vcoin)',
  contractCode        varchar(20)     not null comment '合约代码',
  createTime          bigint          not null comment '记录创建时间'
)
comment '量化策略信息表';

drop table if exists QuantStrategyPLAddPos;
create table QuantStrategyPLAddPos
(
  id                    bigint          not null comment '主键' primary key,
  accountId             bigint          not null comment '账户id',
  strategyName          varchar(20)     not null comment '策略名称',
  accountNo             varchar(20)     not null comment '资金账号',
  updateTime            bigint          not null comment '更新时间',
  exchange              varchar(10)     not null comment '交易所',
  marketType            varchar(10)     not null comment '市场类型（np,wp）',
  contractNo            varchar(20)     not null comment '合约号',
  createTime            bigint          not null comment '记录创建时间',
  currencyNo            varchar(20)     not null comment '保证金币种',
  product               varchar(20)     not null comment '合约品种代码',
  entrustDirect         varchar(10)     not null comment '开仓方向（buy，sell）',
  stopProfitPrice       decimal(24, 8)  not null comment '止盈价',
  stopProfitPriceRatio  decimal(8, 4)   not null comment '止盈容错比例',
  maxEntrustAmt         decimal(16, 8)  not null comment '最大单笔委托数量',
  openPositionPrice     decimal(24, 8)  not null comment '起始开仓价格',
  stopAddPositionPrice  decimal(24, 8)  not null comment '停止加仓价格'
)
comment '浮盈加仓策略配置表';

drop table if exists QuantStrategyVolume;
create table QuantStrategyVolume
(
  id                  bigint          not null comment '主键' primary key,
  accountId           bigint          not null comment '账户id',
  strategyType        varchar(20)     not null comment '策略类型',
  strategyId          bigint          not null comment '策略id',
  accountNo           varchar(20)     not null comment '资金账号',
  exchange            varchar(10)     not null comment '交易所',
  marketType          varchar(10)     not null comment '市场类型(wp,np,vcoin)',
  contractCode        varchar(20)     not null comment '合约代码',
  volume              decimal(24,8)   not null comment '成交额',
  createTime          bigint          not null comment '记录创建时间'
)
comment '量化策略成交量统计表';
