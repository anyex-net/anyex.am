use amdigitalcurrency;

drop table if exists HuobiSwapUsdtCoinInstruments;
create table HuobiSwapUsdtCoinInstruments
(
    id                bigint not null comment '主键' primary key,
    symbol            varchar(30) comment '品种代码',
    contractCode      varchar(30) comment '合约代码',
    contractType      varchar(30) comment '合约类型',
    contractSize      decimal(24, 12) comment '合约面值',
    priceTick         decimal(24, 12) comment '合约价格最小变动精度',
    deliveryDate      varchar(30) comment '合约永续(U)日期',
    createDate        varchar(30) comment '合约上市日期',
    settlementTime    varchar(30) comment '下次结算时间',
    deliveryTime      varchar(30) comment '永续(U)时间',
    contractStatus    varchar(30) comment '合约状态',
    supportMarginMode varchar(30) comment '合约支持的保证金模式',
    unique index (contractCode)
) comment '永续合约(U)交易对';

drop table if exists HuobiSwapUsdtAccountAsset;
create table HuobiSwapUsdtAccountAsset
(
    id                bigint       not null comment '主键' primary key,
    accountId         bigInt(20)   not null comment '平台账户ID',
    apiKey            varchar(255) not null comment '外部平台apikey',
    symbol            varchar(30) comment '品种代码',
    contractCode      varchar(30) comment '合约代码',
    marginAsset       decimal(24, 12) comment '保证金币种',
    marginBalance     decimal(24, 12) comment '账户权益',
    marginStatic      decimal(24, 12) comment '静态权益',
    marginPosition    decimal(24, 12) comment '持仓保证金',
    marginFrozen      decimal(24, 12) comment '冻结保证金',
    marginAvailable   decimal(24, 12) comment '可用保证金',
    profitReal        decimal(24, 12) comment '已实现盈亏',
    profitUnreal      decimal(24, 12) comment '未实现盈亏',
    riskRate          decimal(24, 12) comment '保证金率',
    liquidationPrice  decimal(24, 12) comment '预估强平价',
    withdrawAvailable decimal(24, 12) comment '可划转数量',
    leverRate         decimal(24, 12) comment '杠杠倍数',
    adjustFactor      decimal(24, 12) comment '调整系数',
    marginMode        varchar(30) comment '保证金模式',
    marginAccount     varchar(30) comment '保证金账户',
    unique index (accountId, apiKey, contractCode)
) comment '永续(U)合约逐仓账户信息';

drop table if exists HuobiSwapUsdtCrossAccountAsset;
create table HuobiSwapUsdtCrossAccountAsset
(
    id                bigint       not null comment '主键' primary key,
    accountId         bigInt(20)   not null comment '平台账户ID',
    apiKey            varchar(255) not null comment '外部平台apikey',
    marginMode        varchar(30) comment '保证金模式',
    marginAccount     varchar(30) comment '保证金账户',
    marginAsset       varchar(30) comment '保证金币种',
    marginBalance     decimal(24, 12) comment '账户权益',
    marginStatic      decimal(24, 12) comment '静态权益',
    marginPosition    decimal(24, 12) comment '持仓保证金',
    marginFrozen      decimal(24, 12) comment '冻结保证金',
    profitReal        decimal(24, 12) comment '已实现盈亏',
    profitUnreal      decimal(24, 12) comment '未实现盈亏',
    withdrawAvailable decimal(24, 12) comment '可划转数量',
    riskRate          decimal(24, 12) comment '保证金率',
    unique index (accountId, apiKey, marginAccount)
) comment '永续(U)合约全仓账户信息';

drop table if exists HuobiSwapUsdtCrossAccountAssetDetail;
create table HuobiSwapUsdtCrossAccountAssetDetail
(
    id               bigint       not null comment '主键' primary key,
    accountId        bigInt(20)   not null comment '平台账户ID',
    apiKey           varchar(255) not null comment '外部平台apikey',
    symbol           varchar(30) comment '品种代码',
    contractCode     varchar(30) comment '合约代码',
    marginPosition   decimal(24, 12) comment '持仓保证金',
    marginFrozen     decimal(24, 12) comment '冻结保证金',
    marginAvailable  decimal(24, 12) comment '可用保证金',
    profitUnreal     decimal(24, 12) comment '未实现盈亏',
    liquidationPrice decimal(24, 12) comment '预估强平价',
    leverRate        decimal(24, 12) comment '杠杠倍数',
    adjustFactor     decimal(24, 12) comment '调整系数',
    unique index (accountId, apiKey, contractCode, symbol)
) comment '永续(U)合约全仓账户信息明细';

drop table if exists HuobiSwapUsdtAccountPosition;
create table HuobiSwapUsdtAccountPosition
(
    id             bigint       not null comment '主键' primary key,
    accountId      bigInt(20)   not null comment '平台账户ID',
    apiKey         varchar(255) not null comment '外部平台apikey',
    symbol         varchar(30) comment '品种代码',
    contractCode   varchar(30) comment '合约代码',
    volume         decimal(24, 12) comment '持仓量（张）',
    available      decimal(24, 12) comment '可平仓数量（张）',
    frozen         decimal(24, 12) comment '冻结数量（张）',
    costOpen       decimal(24, 12) comment '开仓均价',
    costHold       decimal(24, 12) comment '持仓均价',
    profitUnreal   decimal(24, 12) comment '未实现盈亏',
    profitRate     decimal(24, 12) comment '收益率',
    profit         decimal(24, 12) comment '收益',
    marginAsset    varchar(30) comment '保证金币种',
    positionMargin decimal(24, 12) comment '持仓保证金',
    leverRate      varchar(30) comment '杠杠倍数',
    direction      varchar(30) comment 'buy:买 "sell":卖',
    lastPrice      decimal(24, 12) comment '最新价',
    marginMode     varchar(30) comment '保证金模式',
    marginAccount  varchar(30) comment '保证金账户',
    unique index (accountId, apiKey, contractCode, direction)
) comment '永续(U)合约账户逐仓持仓信息';

drop table if exists HuobiSwapUsdtCrossAccountPosition;
create table HuobiSwapUsdtCrossAccountPosition
(
    id             bigint       not null comment '主键' primary key,
    accountId      bigInt(20)   not null comment '平台账户ID',
    apiKey         varchar(255) not null comment '外部平台apikey',
    symbol         varchar(30) comment '品种代码',
    contractCode   varchar(30) comment '合约代码',
    marginMode     varchar(30) comment '保证金模式',
    marginAccount  varchar(30) comment '保证金账户',
    volume         decimal(24, 12) comment '持仓量（张）',
    available      decimal(24, 12) comment '可平仓数量（张）',
    frozen         decimal(24, 12) comment '冻结数量（张）',
    costOpen       decimal(24, 12) comment '开仓均价',
    costHold       decimal(24, 12) comment '持仓均价',
    profitUnreal   decimal(24, 12) comment '未实现盈亏',
    profitRate     decimal(24, 12) comment '收益率',
    profit         decimal(24, 12) comment '收益',
    marginAsset    varchar(30) comment '保证金币种',
    positionMargin decimal(24, 12) comment '持仓保证金',
    leverRate      decimal(8, 4) comment '杠杠倍数',
    direction      varchar(30) comment 'buy:买 "sell":卖',
    lastPrice      decimal(24, 12) comment '最新价',
    unique index (accountId, apiKey, contractCode, direction)
) comment '永续(U)合约账户全仓持仓信息';

drop table if exists HuobiSwapUsdtFinancialRecord;
create table HuobiSwapUsdtFinancialRecord
(
    id                bigint       not null comment '主键' primary key,
    accountId         bigInt(20)   not null comment '平台账户ID',
    apiKey            varchar(255) not null comment '外部平台apikey',
    recordId          bigInt(20) comment '财务记录ID',
    ts                bigInt(20) comment '创建时间',
    asset             varchar(30) comment '币种',
    contractCode      varchar(30) comment '合约代码',
    marginAccount     varchar(30) comment '保证金账户',
    faceMarginAccount varchar(30) comment '对手方保证金账户',
    type              int(4) comment '交易类型',
    amount            decimal(24, 12) comment '金额（计价货币）',
    unique index (accountId, apiKey, recordId)
) comment '永续(U)合约账户财务记录';

drop table if exists HuobiSwapUsdtSettlementRecord;
create table HuobiSwapUsdtSettlementRecord
(
    id                   bigint       not null comment '主键' primary key,
    accountId            bigInt(20)   not null comment '平台账户ID',
    apiKey               varchar(255) not null comment '外部平台apikey',
    symbol               varchar(30) comment '品种代码',
    contractCode         varchar(30) comment '合约代码',
    marginMode           varchar(30) comment '保证金模式',
    marginAccount        varchar(30) comment '保证金账户',
    marginBalanceInit    decimal(24, 12) comment '本期初始账户权益',
    marginBalance        decimal(24, 12) comment '本期结算后账户权益',
    settlementProfitReal decimal(24, 12) comment '本期结算已实现盈亏',
    settlementTime       bigInt(20) comment '本期结算或交割时间',
    clawback             decimal(24, 12) comment '本期分摊费用',
    fundingFee           decimal(24, 12) comment '本期资金费',
    offsetProfitloss     decimal(24, 12) comment '本期平仓盈亏',
    fee                  decimal(24, 12) comment '本期交易手续费',
    feeAsset             varchar(30) comment '手续费币种',
    unique index (accountId, apiKey, settlementTime)
) comment '永续(U)合约逐仓账户结算记录';

drop table if exists HuobiSwapCrossUsdtSettlementRecord;
create table HuobiSwapCrossUsdtSettlementRecord
(
    id                   bigint       not null comment '主键' primary key,
    accountId            bigInt(20)   not null comment '平台账户ID',
    apiKey               varchar(255) not null comment '外部平台apikey',
    marginMode           varchar(30) comment '保证金模式',
    marginAccount        varchar(30) comment '保证金账户',
    marginBalanceInit    decimal(24, 12) comment '本期初始账户权益',
    marginBalance        decimal(24, 12) comment '本期结算后账户权益',
    settlementProfitReal decimal(24, 12) comment '本期结算已实现盈亏',
    settlementTime       bigInt(20) comment '本期结算或交割时间',
    clawback             decimal(24, 12) comment '本期分摊费用',
    fundingFee           decimal(24, 12) comment '本期总资金费',
    offsetProfitloss     decimal(24, 12) comment '本期总平仓盈亏',
    fee                  decimal(24, 12) comment '本期总交易手续费',
    feeAsset             varchar(30) comment '手续费币种',
    contractDetail       varchar(2000) comment '所有合约',
    unique index (accountId, apiKey, settlementTime)
) comment '永续(U)合约全仓账户结算记录';

drop table if exists HuobiSwapUsdtOrder;
create table HuobiSwapUsdtOrder
(
    id              bigint       not null comment '主键' primary key,
    accountId       bigInt(20)   not null comment '平台账户ID',
    apiKey          varchar(255) not null comment '外部平台apikey',
    symbol          varchar(30) comment '品种代码',
    contractCode    varchar(30) comment '合约代码',
    volume          decimal(24, 12) comment '委托数量',
    price           decimal(24, 12) comment '委托价格',
    orderPriceType  varchar(30) comment '订单报价类型',
    direction       varchar(30) comment '买卖方向',
    offset          varchar(30) comment '开平方向',
    leverRate       Int(4) comment '杠杆倍数',
    orderId         bigInt(20) comment '订单ID',
    orderIdStr      varchar(30) comment 'String类型订单ID',
    clientOrderId   bigInt(20) comment '客户订单ID',
    createdAt       bigInt(20) comment '创建时间',
    tradeVolume     decimal(24, 12) comment '成交数量',
    tradeTurnover   decimal(24, 12) comment '成交总金额',
    fee             decimal(24, 12) comment '手续费',
    tradeAvgPrice   decimal(24, 12) comment '成交均价',
    marginAsset     varchar(30) comment '保证金币种',
    marginFrozen    decimal(24, 12) comment '冻结保证金',
    profit          decimal(24, 12) comment '平仓盈亏',
    status          Int(4) comment '订单状态',
    orderType       Int(4) comment '订单类型',
    orderSource     varchar(30) comment '订单来源',
    feeAsset        varchar(30) comment '手续费币种',
    liquidationType varchar(30) comment '结算类型',
    canceledAt      bigInt(20) comment '撤单时间',
    marginAccount   varchar(30) comment '保证金账户',
    marginMode      varchar(30) comment '保证金模式',
    isTpsl          Int(4) comment '是否设置止盈止损',
    realProfit      decimal(24, 12) comment '真实收益',
    unique index (accountId, apiKey, orderId)
) comment '永续(U)合约账户订单信息';

drop table if exists HuobiSwapUsdtOrderDetail;
create table HuobiSwapUsdtOrderDetail
(
    id               bigint       not null comment '主键' primary key,
    accountId        bigInt(20)   not null comment '平台账户ID',
    apiKey           varchar(255) not null comment '外部平台apikey',
    detailId         varchar(30) comment '全局唯一的交易标识',
    matchId          bigInt(20) comment '撮合结果id',
    orderId          bigInt(20) comment '订单ID',
    orderIdStr       varchar(30) comment '订单ID',
    symbol           varchar(30) comment '品种代码',
    orderSource      varchar(30) comment '订单来源',
    contractCode     varchar(30) comment '合约代码',
    direction        varchar(30) comment '买卖方向',
    offset           varchar(30) comment '开平方向',
    tradeVolume      decimal(24, 12) comment '成交数量',
    tradePrice       decimal(24, 12) comment '成交价格',
    tradeTurnover    decimal(24, 12) comment '成交金额',
    createDate       bigInt(20) comment '成交时间',
    offsetProfitloss decimal(24, 12) comment '平仓盈亏',
    tradeFee         decimal(24, 12) comment '成交手续费',
    role             varchar(30) comment 'taker或maker',
    feeAsset         varchar(30) comment '手续费币种',
    marginMode       varchar(30) comment '保证金模式',
    marginAccount    varchar(30) comment '保证金账户',
    realProfit       decimal(24, 12) comment '真实收益',
    unique index (accountId, apiKey, detailId)
) comment '永续(U)合约账户成交明细';

drop table if exists HuobiSwapUsdtOrderPlan;
create table HuobiSwapUsdtOrderPlan
(
    id              bigint       not null comment '主键' primary key,
    accountId       bigInt(20)   not null comment '平台账户ID',
    apiKey          varchar(255) not null comment '外部平台apikey',
    symbol          varchar(30) comment '合约品种',
    contractCode    varchar(30) comment '合约代码',
    marginMode      varchar(30) comment '保证金模式',
    marginAccount   varchar(30) comment '保证金账户',
    triggerType     varchar(30) comment '触发类型',
    volume          decimal(24, 12) comment '委托数量',
    orderType       Int(4) comment '订单类型',
    direction       varchar(30) comment '订单方向',
    offset          varchar(30) comment '开平标志',
    leverRate       Int(4) comment '杠杆倍数',
    orderId         bigInt(20) comment '计划委托单订单ID',
    orderIdStr      varchar(30) comment '字符串类型的订单ID',
    relationOrderId varchar(30) comment '该字段为关联限价单的关联字段，未触发前数值为-1',
    orderPriceType  varchar(30) comment '订单报价类型',
    status          Int(4) comment '订单状态',
    orderSource     varchar(30) comment '来源',
    triggerPrice    decimal(24, 12) comment '触发价',
    triggeredPrice  decimal(24, 12) comment '被触发时的价格',
    orderPrice      decimal(24, 12) comment '委托价',
    createdAt       bigInt(20) comment '订单创建时间',
    updateTime      bigInt(20) comment '订单更新时间，单位：毫秒',
    triggeredAt     bigInt(20) comment '触发时间',
    orderInsertAt   bigInt(20) comment '下order单时间',
    canceledAt      bigInt(20) comment '撤单时间',
    failCode        Int(4) comment '被触发时下order单失败错误码',
    failReason      varchar(255) comment '被触发时下order单失败原因',
    unique index (accountId, apiKey, orderId)
) comment '永续(U)合约计划委托';

drop table if exists HuobiSwapUsdtOrderTpsl;
create table HuobiSwapUsdtOrderTpsl
(
    id                  bigint       not null comment '主键' primary key,
    accountId           bigInt(20)   not null comment '平台账户ID',
    apiKey              varchar(255) not null comment '外部平台apikey',
    symbol              varchar(30) comment '品种代码',
    contractCode        varchar(30) comment '合约代码',
    marginMode          varchar(30) comment '保证金模式',
    marginAccount       varchar(30) comment '保证金账户',
    volume              decimal(24, 12) comment '委托数量',
    orderType           Int(4) comment '订单类型',
    tpslOrderType       varchar(30) comment '止盈止损类型',
    direction           varchar(30) comment '买卖方向',
    orderId             bigInt(20) comment '止盈止损订单ID',
    orderIdStr          varchar(30) comment '字符串类型的止盈止损订单ID',
    orderSource         varchar(30) comment '来源',
    triggerType         varchar(30) comment '触发类型',
    triggerPrice        decimal(24, 12) comment '触发价',
    createdAt           bigInt(20) comment '订单创建时间',
    orderPriceType      varchar(30) comment '订单报价类型',
    orderPrice          decimal(24, 12) comment '委托价',
    status              Int(4) comment '订单状态：',
    sourceOrderId       varchar(30) comment '源限价单的订单id',
    relationTpslOrderId varchar(30) comment '关联的止盈止损单id',
    canceledAt          bigInt(20) comment '撤单时间',
    failCode            Int(4) comment '失败错误码',
    failReason          varchar(255) comment '失败原因',
    triggeredPrice      decimal(24, 12) comment '被触发时的价格',
    relationOrderId     varchar(30) comment '关联限价单',
    updateTime          bigInt(20) comment '订单更新时间',
    unique index (accountId, apiKey, orderId)
) comment '永续(U)合约止盈止损委托';
