use amdigitalcurrency;

drop table if exists HuobiSpotInstruments;
create table HuobiSpotInstruments
(
    id                     bigint not null comment '主键' primary key,
    baseCurrency           varchar(20) comment '交易对中的基础币种',
    quoteCurrency          varchar(20) comment '交易对中的报价币种',
    pricePrecision         int(4) comment '交易对报价的精度',
    amountPrecision        int(4) comment '交易对基础币种计数精度',
    symbolPartition        varchar(20) comment '交易区',
    symbol                 varchar(30) comment '交易对',
    state                  varchar(30) comment '交易对状态',
    valuePrecision         int(4) comment '交易对交易金额的精度',
    minOrderAmt            decimal(24, 12) comment '交易对限价单最小下单量',
    maxOrderAmt            decimal(24, 12) comment '交易对限价单最大下单量 ',
    limitOrderMinOrderAmt  decimal(24, 12) comment '交易对限价单最小下单量 ',
    limitOrderMaxOrderAmt  decimal(24, 12) comment '交易对限价单最大下单量',
    sellMarketMinOrderAmt  decimal(24, 12) comment '交易对市价卖单最小下单量',
    sellMarketMaxOrderAmt  decimal(24, 12) comment '交易对市价卖单最大下单量',
    buyMarketMaxOrderValue decimal(24, 12) comment '交易对市价买单最大下单金额',
    minOrderValue          decimal(24, 12) comment '交易对限价单和市价买单最小下单金额',
    maxOrderValue          decimal(24, 12) comment '交易对限价单和市价买单最大下单金额 ',
    leverageRatio          decimal(24, 12) comment '交易对杠杆最大倍数',
    underlying             varchar(20) comment '标的交易代码 ',
    mgmtFeeRate            decimal(24, 12) comment '持仓管理费费率 ',
    chargeTime             varchar(30) comment '持仓管理费收取时间',
    rebalTime              varchar(30) comment '每日调仓时间',
    rebalThreshold         decimal(24, 12) comment '临时调仓阈值',
    initNav                decimal(24, 12) comment '初始净值',
    apiTrading             varchar(30) comment 'API交易使能标记',
    unique index (symbol)
) comment '现货交易对';

drop table if exists HuobiCurrencys;
create table HuobiCurrencys
(
    id       bigint not null comment '主键' primary key,
    currency varchar(20) comment '币种',
    unique index (currency)
) comment '币种';

drop table if exists HuobiSpotAccountInfo;
create table HuobiSpotAccountInfo
(
    id             bigint       not null comment '主键' primary key,
    accountId      bigInt(20)   not null comment '平台账户ID',
    apiKey         varchar(255) not null comment '外部平台apikey',
    huobiAccountId bigInt(20) comment 'account-id',
    state          varchar(30) comment '账户状态',
    type           varchar(30) comment '账户类型',
    subtype        varchar(30) comment '子账户类型',
    unique index (accountId, apiKey, huobiAccountId)
) comment '现货账户信息';

drop table if exists HuobiSpotAccountBalance;
create table HuobiSpotAccountBalance
(
    id             bigint       not null comment '主键' primary key,
    accountId      bigInt(20)   not null comment '平台账户ID',
    apiKey         varchar(255) not null comment '外部平台apikey',
    huobiAccountId decimal(24, 12) comment '币种',
    currency       varchar(20) comment '币种',
    trade          decimal(24, 12) comment '交易余额',
    frozen         decimal(24, 12) comment '冻结余额',
    loan           decimal(24, 12) comment '待还借贷本金',
    interest       decimal(24, 12) comment '待还借贷利息',
    lockAmount     decimal(24, 12) comment '锁仓',
    bank           decimal(24, 12) comment '储蓄',
    unique index (accountId, apiKey, currency)
) comment '现货账户余额';

drop table if exists HuobiSpotAccountFund;
create table HuobiSpotAccountFund
(
    id             bigint not null comment '主键' primary key,
    accountId      bigInt(20) comment '主键',
    apiKey         bigInt(20) comment '平台账户ID',
    huobiAccountId bigInt(20) comment '账户编号',
    currency       varchar(20) comment '币种',
    transactAmt    decimal(24, 12) comment '变动金额（入账为正 or 出账为负）',
    transactType   varchar(30) comment '变动类型',
    availBalance   decimal(24, 12) comment '可用余额',
    acctBalance    decimal(24, 12) comment '账户余额',
    transactTime   bigInt(20) comment '交易时间（数据库记录时间）',
    recordId       bigInt(20) comment '记录ID',
    unique index (accountId, apiKey, recordId)
) comment '现货账户流水';

drop table if exists HuobiSpotAccountLedger;
create table HuobiSpotAccountLedger
(
    id             bigint not null comment '主键' primary key,
    accountId      bigInt(20) comment '平台账户ID',
    apiKey         varchar(255) comment '外部平台apikey',
    huobiAccountId bigInt(20) comment '账户编号',
    currency       varchar(20) comment '币种',
    transactAmt    decimal(24, 12) comment '变动金额',
    transactType   varchar(30) comment '变动类型',
    transferType   varchar(30) comment '划转类型',
    transactId     bigInt(20) comment '交易流水号',
    transactTime   bigInt(20) comment '交易时间',
    transferer     bigInt(20) comment '付款方账户ID',
    transferee     bigInt(20) comment '收款方账户ID',
    unique index (accountId, apiKey, transactId)
) comment '现货账户财务流水';

drop table if exists HuobiAccountDepositAddress;
create table HuobiAccountDepositAddress
(
    id         bigint not null comment '主键' primary key,
    accountId  bigInt(20) comment '平台账户ID',
    apiKey     varchar(255) comment '外部平台apikey',
    currency   varchar(20) comment '币种',
    address    varchar(255) comment '充币地址',
    addressTag varchar(20) comment '充币地址标签',
    chain      varchar(20) comment '链名称',
    unique index (accountId, apiKey, chain, address)
) comment '现货充值地址';

drop table if exists HuobiAccountWithdrawAddress;
create table HuobiAccountWithdrawAddress
(
    id         bigint not null comment '主键' primary key,
    accountId  bigInt(20) comment '平台账户ID',
    apiKey     varchar(255) comment '外部平台apikey',
    chain      varchar(20) comment '链名称',
    note       varchar(20) comment '地址备注',
    addressTag varchar(20) comment '地址标签，如有',
    address    varchar(255) comment '地址'
) comment '现货提币地址';

drop table if exists HuobiDepositWithdrawRecord;
create table HuobiDepositWithdrawRecord
(
    id             bigint not null comment '主键' primary key,
    accountId      bigInt(20) comment '平台账户ID',
    apiKey         varchar(255) comment '外部平台apikey',
    huobiAccountId bigInt(20) comment '账户编号',
    type           varchar(30) comment '类型',
    currency       varchar(20) comment '币种',
    txHash         varchar(255) comment '交易哈希',
    chain          varchar(20) comment '链名称',
    amount         decimal(24, 12) comment '个数',
    address        varchar(255) comment '目的地址',
    addressTag     varchar(30) comment '地址标签',
    fee            decimal(24, 12) comment '手续费',
    state          varchar(30) comment '状态',
    errorCode      varchar(30) comment '提币失败错误码',
    errorMsg       varchar(30) comment '提币失败错误描述',
    createdAt      bigInt(20) comment '发起时间',
    updatedAt      bigInt(20) comment '最后更新时间',
    unique index (accountId, apiKey, txHash)
) comment '现货充提记录';

drop table if exists HuobiSpotAccountOrder;
create table HuobiSpotAccountOrder
(
    id              bigint not null comment '主键' primary key,
    accountId       bigInt(20) comment '平台账户ID',
    apiKey          varchar(255) comment '外部平台apikey',
    huobiAccountId  bigInt(20) comment '账户编号',
    amount          decimal(24, 12) comment '订单数量',
    canceledAt      bigInt(20) comment '订单撤销时间',
    createdAt       bigInt(20) comment '订单创建时间',
    fieldAmount     decimal(24, 12) comment '已成交数量',
    fieldCashAmount decimal(24, 12) comment '已成交总金额',
    fieldFees       decimal(24, 12) comment '已成交手续费',
    finishedAt      bigInt(20) comment '订单变为终结态的时间',
    orderId         bigInt(20) comment '订单ID',
    clientOrderId   varchar(50) comment '用户自编订单号',
    price           decimal(24, 12) comment '订单价格',
    source          varchar(30) comment '订单来源',
    state           varchar(30) comment '订单状态',
    symbol          varchar(30) comment '交易对',
    type            varchar(30) comment '订单类型',
    stopPrice       decimal(24, 12) comment '止盈止损订单触发价格',
    operator        varchar(30) comment '止盈止损订单触发价运算符',
    unique index (accountId, apiKey, orderId)
) comment '现货订单';

drop table if exists HuobiSpotAccountOrderDetail;
create table HuobiSpotAccountOrderDetail
(
    id                bigint not null comment '主键' primary key,
    accountId         bigInt(20) comment '平台账户ID',
    apiKey            varchar(255) comment '外部平台apikey',
    createdAt         bigInt(20) comment '该成交记录创建的时间戳',
    filledAmount      decimal(24, 12) comment '成交数量',
    filledFees        decimal(24, 12) comment '交易手续费',
    feeCurrency       varchar(20) comment '交易手续费或交易返佣币种',
    detailId          bigInt(20) comment '订单成交记录ID',
    matchId           bigInt(20) comment '撮合ID',
    orderId           bigInt(20) comment '订单ID',
    tradeId           bigInt(20) comment 'Unique trade ID',
    price             varchar(30) comment '成交价格',
    source            varchar(30) comment '订单来源',
    symbol            varchar(30) comment '交易对',
    type              varchar(30) comment '订单类型',
    role              varchar(30) comment '成交角色',
    filledPoints      decimal(24, 12) comment '抵扣数量',
    feeDeductCurrency varchar(30) comment '抵扣类型',
    feeDeductState    varchar(30) comment '抵扣状态',
    unique index (accountId, apiKey, detailId)
) comment '现货成交明细';

drop table if exists HuobiSpotAccountOrderAlgo;
create table HuobiSpotAccountOrderAlgo
(
    id              bigint not null comment '主键' primary key,
    accountId       bigInt(20) comment '平台账户ID',
    apiKey          varchar(255) comment '外部平台apikey',
    huobiAccountId  bigInt(20) comment '账户编号',
    source          varchar(30) comment '订单来源',
    clientOrderId   varchar(30) comment '用户自编订单号',
    orderId         varchar(30) comment '订单编号',
    symbol          varchar(30) comment '交易代码',
    orderPrice      decimal(24, 12) comment '订单价格',
    orderSize       decimal(24, 12) comment '订单数量',
    orderValue      decimal(24, 12) comment '订单金额',
    orderSide       varchar(30) comment '订单方向',
    timeInForce     varchar(30) comment '订单有效期',
    orderType       varchar(30) comment '订单类型',
    stopPrice       decimal(24, 12) comment '触发价',
    trailingRate    decimal(24, 12) comment '回调幅度',
    orderOrigTime   varchar(30) comment '订单创建时间',
    lastActTime     varchar(30) comment '订单最近更新时间',
    orderCreateTime varchar(30) comment '订单触发时间',
    orderStatus     varchar(30) comment '订单状态',
    errCode         varchar(30) comment '订单被拒状态码',
    errMessage      varchar(255) comment '订单被拒错误消息',
    unique index (accountId, apiKey, orderId)
) comment '现货策略委托';

drop table if exists HuobiMarginLoanInfo;
create table HuobiMarginLoanInfo
(
    id           bigint not null comment '主键' primary key,
    currency     varchar(20) comment '币种',
    interestRate decimal(24, 12) comment '基础日币息率',
    minLoanAmt   decimal(24, 12) comment '最小允许借币金额',
    maxLoanAmt   decimal(24, 12) comment '最大允许借币金额',
    loanableAmt  decimal(24, 12) comment '最大可借金额',
    actualRate   decimal(24, 12) comment '实际借币币息率',
    unique index (currency)
) comment '借币基础信息';

drop table if exists HuobiMarginAccountInfo;
create table HuobiMarginAccountInfo
(
    id                   bigint not null comment '主键' primary key,
    accountId            bigInt(20) comment '平台账户ID',
    apiKey               varchar(255) comment '外部平台apikey',
    currency             varchar(20) comment '币种',
    trade                decimal(24, 12) comment '交易余额',
    frozen               decimal(24, 12) comment '冻结余额',
    loan                 decimal(24, 12) comment '待还借贷本金',
    interest             decimal(24, 12) comment '待还借贷利息',
    transferOutAvailable decimal(24, 12) comment '可划转额',
    loanAvailable        decimal(24, 12) comment '可借额',
    unique index (accountId, apiKey, currency)
) comment '借币账户信息(逐仓)';

drop table if exists HuobiMarginCrossAccountInfo;
create table HuobiMarginCrossAccountInfo
(
    id                   bigint not null comment '主键' primary key,
    accountId            bigInt(20) comment '平台账户ID',
    apiKey               varchar(255) comment '外部平台apikey',
    currency             varchar(20) comment '币种',
    trade                decimal(24, 12) comment '交易余额',
    frozen               decimal(24, 12) comment '冻结余额',
    loan                 decimal(24, 12) comment '待还借贷本金',
    interest             decimal(24, 12) comment '待还借贷利息',
    transferOutAvailable decimal(24, 12) comment '可划转额',
    loanAvailable        decimal(24, 12) comment '可借额',
    unique index (accountId, apiKey, currency)
) comment '借币账户信息(全仓)';

drop table if exists HuobiMarginOrder;
create table HuobiMarginOrder
(
    id               bigint not null comment '主键' primary key,
    accountId        bigInt(20) comment '平台账户ID',
    apiKey           varchar(255) comment '外部平台apikey',
    orderId          bigInt(20) comment '订单号',
    userId           bigInt(20) comment '用户ID',
    huobiAccountId   bigInt(20) comment '账户ID',
    symbol           varchar(30) comment '交易对',
    currency         varchar(20) comment '币种',
    loanAmount       decimal(24, 12) comment '借币本金总额',
    loanBalance      decimal(24, 12) comment '未还本金',
    interestRate     decimal(24, 12) comment '币息率',
    interestAmount   decimal(24, 12) comment '币息总额',
    interestBalance  decimal(24, 12) comment '未还币息',
    createdAt        bigInt(20) comment '借币发起时间',
    accruedAt        bigInt(20) comment '最近一次计息时间',
    state            varchar(30) comment '订单状态',
    paidPoint        decimal(24, 12) comment '已支付点卡金额（用于还息）',
    paidCoin         decimal(24, 12) comment '已支付原币金额（用于还息）',
    deductRate       decimal(24, 12) comment '抵扣率（用于还息）',
    deductCurrency   varchar(30) comment '抵扣币种（用于还息）',
    deductAmount     decimal(24, 12) comment '抵扣金额（用于还息）',
    updatedAt        bigInt(20) comment '更新时间',
    hourInterestRate decimal(24, 12) comment '时息率',
    dayInterestRate  decimal(24, 12) comment '日息率',
    unique index (accountId, apiKey, orderId)
) comment '借币订单(逐仓)';

drop table if exists HuobiMarginCrossOrder;
create table HuobiMarginCrossOrder
(
    id              bigint not null comment '主键' primary key,
    accountId       bigInt(20) comment '平台账户ID',
    apiKey          varchar(255) comment '外部平台apikey',
    orderId         bigInt(20) comment '订单号',
    userId          bigInt(20) comment '用户ID',
    huobiAccountId  bigInt(20) comment '账户ID',
    currency        varchar(20) comment '币种',
    loanAmount      decimal(24, 12) comment '借币本金总额',
    loanBalance     decimal(24, 12) comment '未还本金',
    interestAmount  decimal(24, 12) comment '币息总额',
    interestBalance decimal(24, 12) comment '未还币息',
    filledPoints    decimal(24, 12) comment '点卡抵扣数量',
    filledHt        decimal(24, 12) comment 'HT抵扣数量',
    createdAt       bigInt(20) comment '借币发起时间',
    accruedAt       bigInt(20) comment '最近一次计息时间',
    state           varchar(30) comment '订单状态',
    unique index (accountId, apiKey, orderId)
) comment '借币订单(全仓)';