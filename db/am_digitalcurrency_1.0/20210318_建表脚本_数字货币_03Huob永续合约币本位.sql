use amdigitalcurrency;

drop table if exists HuobiSwapCoinCoinInstruments;
create table HuobiSwapCoinCoinInstruments
(
    id             bigint not null comment '主键' primary key,
    symbol         varchar(30) comment '品种代码',
    contractCode   varchar(30) comment '合约代码',
    contractType   varchar(30) comment '合约类型',
    contractSize   decimal(24, 12) comment '合约面值',
    priceTick      decimal(24, 12) comment '合约价格最小变动精度',
    deliveryDate   varchar(30) comment '合约永续日期',
    createDate     varchar(30) comment '合约上市日期',
    settlementTime varchar(30) comment '下次结算时间',
    deliveryTime   varchar(30) comment '永续时间',
    contractStatus varchar(30) comment '合约状态',
    unique index (contractCode)
) comment '永续合约(币)交易对';

drop table if exists HuobiSwapCoinAccountAsset;
create table HuobiSwapCoinAccountAsset
(
    id                bigint       not null comment '主键' primary key,
    accountId         bigInt(20)   not null comment '平台账户ID',
    apiKey            varchar(255) not null comment '外部平台apikey',
    symbol            varchar(30) comment '品种代码',
    marginBalance     decimal(24, 12) comment '账户权益',
    marginPosition    decimal(24, 12) comment '持仓保证金',
    marginFrozen      decimal(24, 12) comment '冻结保证金',
    marginAvailable   decimal(24, 12) comment '可用保证金',
    profitReal        decimal(24, 12) comment '已实现盈亏',
    profitUnreal      decimal(24, 12) comment '未实现盈亏',
    riskRate          decimal(24, 12) comment '保证金率',
    liquidationPrice  decimal(24, 12) comment '预估强平价',
    withdrawAvailable decimal(24, 12) comment '可划转数量',
    leverRate         decimal(8, 4) comment '杠杠倍数',
    adjustFactor      decimal(24, 12) comment '调整系数',
    marginStatic      decimal(24, 12) comment '静态权益',
    unique index (accountId, apiKey, symbol)
) comment '永续合约账户信息';

drop table if exists HuobiSwapCoinAccountPosition;
create table HuobiSwapCoinAccountPosition
(
    id             bigint       not null comment '主键' primary key,
    accountId      bigInt(20)   not null comment '平台账户ID',
    apiKey         varchar(255) not null comment '外部平台apikey',
    symbol         varchar(30) comment '品种代码',
    contractCode   varchar(30) comment '合约代码',
    contractType   varchar(30) comment '合约类型',
    volume         decimal(24, 12) comment '持仓量',
    available      decimal(24, 12) comment '可平仓数量',
    frozen         decimal(24, 12) comment '冻结数量',
    costOpen       decimal(24, 12) comment '开仓均价',
    costHold       decimal(24, 12) comment '持仓均价',
    profitUnreal   decimal(24, 12) comment '未实现盈亏',
    profitRate     decimal(24, 12) comment '收益率',
    profit         decimal(24, 12) comment '收益',
    positionMargin decimal(24, 12) comment '持仓保证金',
    leverRate      decimal(8, 4) comment '杠杠倍数',
    direction      varchar(30) comment '买卖方向',
    lastPrice      decimal(24, 12) comment '最新价',
    unique index (accountId, apiKey, contractCode, direction)
) comment '永续合约账户持仓信息';

drop table if exists HuobiSwapCoinFinancialRecord;
create table HuobiSwapCoinFinancialRecord
(
    id           bigint       not null comment '主键' primary key,
    accountId    bigInt(20)   not null comment '平台账户ID',
    apiKey       varchar(255) not null comment '外部平台apikey',
    recordId     bigInt(20) comment '财务记录ID',
    ts           bigInt(20) comment '创建时间',
    symbol       varchar(20) comment '品种代码',
    type         int(4) comment '交易类型',
    amount       decimal(24, 12) comment '金额',
    contractCode varchar(30) comment '合约代码',
    unique index (accountId, apiKey, recordId)
) comment '永续合约账户财务记录';

drop table if exists HuobiSwapCoinSettlementRecord;
create table HuobiSwapCoinSettlementRecord
(
    id                   bigint       not null comment '主键' primary key,
    accountId            bigInt(20)   not null comment '平台账户ID',
    apiKey               varchar(255) not null comment '外部平台apikey',
    symbol               varchar(30) comment '品种代码',
    marginBalanceInit    decimal(24, 12) comment '本期初始账户权益',
    marginBalance        decimal(24, 12) comment '本期结算后账户权益',
    settlementProfitReal decimal(24, 12) comment '本期结算已实现盈亏',
    settlementTime       bigInt(20) comment '本期结算时间',
    clawback             decimal(24, 12) comment '本期分摊费用',
    deliveryFee          decimal(24, 12) comment '本期永续手续费',
    offsetProfitloss     decimal(24, 12) comment '本期平仓盈亏',
    fee                  decimal(24, 12) comment '本期交易手续费',
    feeAsset             varchar(30) comment '手续费币种',
    positions            varchar(4096) comment '仓位信息',
    unique index (accountId, apiKey, settlementTime)
) comment '永续合约账户结算记录';

drop table if exists HuobiSwapCoinOrder;
create table HuobiSwapCoinOrder
(
    id              bigint       not null comment '主键' primary key,
    accountId       bigInt(20)   not null comment '平台账户ID',
    apiKey          varchar(255) not null comment '外部平台apikey',
    symbol          varchar(30) comment '品种代码',
    contractType    varchar(30) comment '合约类型',
    contractCode    varchar(30) comment '合约代码',
    volume          decimal(24, 12) comment '委托数量',
    price           decimal(24, 12) comment '委托价格',
    orderPriceType  varchar(30) comment '订单报价类型',
    direction       varchar(30) comment '买卖方向',
    offset          varchar(30) comment '开平方向',
    leverRate       decimal(8, 4) comment '杠杆倍数',
    orderId         bigInt(20) comment '订单ID',
    orderIdStr      varchar(30) comment '订单ID',
    clientOrderId   bigInt(20) comment '客户订单ID',
    createdAt       bigInt(20) comment '创建时间',
    canceledAt      bigInt(20) comment '撤单时间',
    tradeVolume     decimal(24, 12) comment '成交数量',
    tradeTurnover   decimal(24, 12) comment '成交总金额',
    fee             decimal(24, 12) comment '手续费',
    tradeAvgPrice   decimal(24, 12) comment '成交均价',
    marginFrozen    decimal(24, 12) comment '冻结保证金',
    profit          decimal(24, 12) comment '平仓盈亏',
    status          int(4) comment '订单状态',
    orderType       int(4) comment '订单类型',
    orderSource     varchar(30) comment '订单来源',
    feeAsset        varchar(30) comment '手续费币种',
    liquidationType varchar(30) comment '强平类型',
    isTpsl          int(1) comment '是否设置止盈止损',
    realProfit      decimal(24, 12) comment '真实收益',
    unique index (accountId, apiKey, orderId)
) comment '永续合约账户订单信息';

drop table if exists HuobiSwapCoinOrderDetail;
create table HuobiSwapCoinOrderDetail
(
    id               bigint       not null comment '主键' primary key,
    accountId        bigInt(20)   not null comment '平台账户ID',
    apiKey           varchar(255) not null comment '外部平台apikey',
    detailId         varchar(30) comment '全局唯一的交易标识',
    matchId          bigInt(20) comment '撮合结果id',
    orderId          bigInt(20) comment '订单ID',
    orderIdStr       varchar(30) comment 'String类型订单ID',
    symbol           varchar(30) comment '品种代码',
    orderSource      varchar(30) comment '订单来源',
    contractType     varchar(30) comment '合约类型',
    contractCode     varchar(30) comment '合约代码',
    direction        varchar(30) comment '买卖',
    offset           varchar(30) comment '开平',
    tradeVolume      decimal(24, 12) comment '累计成交数量',
    tradePrice       decimal(24, 12) comment '成交价格',
    tradeTurnover    decimal(24, 12) comment '本笔成交金额',
    createDate       bigInt(20) comment '成交时间',
    offsetProfitloss decimal(24, 12) comment '平仓盈亏',
    tradeFee         decimal(24, 12) comment '成交手续费',
    role             varchar(30) comment 'taker或maker',
    feeAsset         varchar(30) comment '手续费币种',
    realProfit       decimal(24, 12) comment '真实收益',
    unique index (accountId, apiKey, detailId)
) comment '永续合约账户成交明细';

drop table if exists HuobiSwapCoinOrderPlan;
create table HuobiSwapCoinOrderPlan
(
    id              bigint       not null comment '主键' primary key,
    accountId       bigInt(20)   not null comment '平台账户ID',
    apiKey          varchar(255) not null comment '外部平台apikey',
    symbol          varchar(30) comment '合约品种',
    contractCode    varchar(30) comment '合约代码',
    contractType    varchar(30) comment '合约类型',
    triggerType     varchar(30) comment '触发类型',
    volume          decimal(24, 12) comment '委托数量',
    orderType       varchar(30) comment '订单类型',
    direction       varchar(30) comment '订单方向',
    offset          varchar(30) comment '开平标志',
    leverRate       int(4) comment '杠杆倍数',
    orderId         bigInt(20) comment '计划委托单订单ID',
    orderIdStr      varchar(30) comment '字符串类型的订单ID',
    relationOrderId varchar(30) comment '订单id',
    orderPriceType  varchar(30) comment '订单报价类型',
    status          varchar(30) comment '订单状态',
    orderSource     varchar(30) comment '来源',
    triggerPrice    decimal(24, 12) comment '触发价',
    triggeredPrice  decimal(24, 12) comment '被触发时的价格',
    orderPrice      decimal(24, 12) comment '委托价',
    createdAt       bigInt(20) comment '订单创建时间',
    triggeredAt     bigInt(20) comment '触发时间',
    orderInsertAt   bigInt(20) comment '下order单时间',
    canceledAt      bigInt(20) comment '撤单时间',
    updateTime      bigInt(20) comment '订单更新时间',
    failCode        int(6) comment '被触发时下order单失败错误码',
    failReason      varchar(255) comment '被触发时下order单失败原因',
    unique index (accountId, apiKey, orderId)
) comment '永续合约计划委托';

drop table if exists HuobiSwapCoinOrderTpsl;
create table HuobiSwapCoinOrderTpsl
(
    id                  bigint       not null comment '主键' primary key,
    accountId           bigInt(20)   not null comment '平台账户ID',
    apiKey              varchar(255) not null comment '外部平台apikey',
    symbol              varchar(30) comment '品种代码',
    contractType        varchar(30) comment '合约类型',
    contractCode        varchar(30) comment '合约代码',
    volume              decimal(24, 12) comment '委托数量',
    orderType           int(4) comment '订单类型',
    tpslOrderType       varchar(30) comment '止盈止损类型',
    direction           varchar(30) comment '买卖方向',
    orderId             bigInt(20) comment '止盈止损订单ID',
    orderIdStr          varchar(30) comment '字符串类型的止盈止损订单ID',
    orderSource         varchar(30) comment '来源',
    orderPrice          decimal(24, 12) comment '委托价',
    triggerType         varchar(30) comment '触发类型',
    triggerPrice        decimal(24, 12) comment '触发价',
    createdAt           bigInt(20) comment '订单创建时间',
    orderPriceType      varchar(30) comment '订单报价类型',
    status              int(4) comment '订单状态：',
    sourceOrderId       varchar(30) comment '源限价单的订单id',
    relationTpslOrderId varchar(30) comment '关联的止盈止损单id',
    unique index (accountId, apiKey, orderId)
) comment '永续合约止盈止损委托';
