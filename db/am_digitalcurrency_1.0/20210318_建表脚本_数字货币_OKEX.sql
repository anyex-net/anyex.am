use amdigitalcurrency;

drop table if exists OkexAccountAsset;
create table OkexAccountAsset
(
    id        bigint                    not null comment '主键' primary key,
    accountId bigInt(20)                not null comment '平台账户ID',
    apiKey    varchar(255)              not null comment '外部平台apikey',
    uTime     bigInt(20)      default 0 not null comment '账户信息的更新时间',
    totalEq   decimal(24, 12) default 0 not null comment '美金层面权益',
    isoEq     decimal(24, 12) default 0 not null comment '美金层面逐仓仓位权益',
    adjEq     decimal(24, 12) default 0 not null comment '美金层面有效保证金',
    imr       decimal(24, 12) default 0 not null comment '美金层面占用保证金',
    mmr       decimal(24, 12) default 0 not null comment '美金层面维持保证金',
    mgnRatio  decimal(24, 12) default 0 not null comment '美金层面保证金率',
    unique index (accountId, apiKey)
) comment '账户余额汇总';

drop table if exists OkexAccountAssetDetail;
create table OkexAccountAssetDetail
(
    id        bigint                    not null comment '主键' primary key,
    accountId bigInt(20)                not null comment '平台账户ID',
    apiKey    varchar(255)              not null comment '外部平台apikey',
    uTime     bigInt(20)      default 0 not null comment '账户信息的更新时间',
    ccy       varchar(20)               not null comment '币种',
    eq        decimal(24, 12) default 0 not null comment '币种总权益',
    isoEq     decimal(24, 12) default 0 not null comment '币种逐仓仓位权益',
    availEq   decimal(24, 12) default 0 not null comment '可用保证金',
    disEq     decimal(24, 12) default 0 not null comment '美金层面币种折算权益',
    availBal  decimal(24, 12) default 0 not null comment '可用余额',
    frozenBal decimal(24, 12) default 0 not null comment '币种占用金额',
    ordFrozen decimal(24, 12) default 0 not null comment '挂单冻结数量',
    liab      decimal(24, 12) default 0 not null comment '币种负债额',
    upl       decimal(24, 12) default 0 not null comment '未实现盈亏',
    uplLiab   decimal(24, 12) default 0 not null comment '由于仓位未实现亏损导致的负债',
    crossLiab decimal(24, 12) default 0 not null comment '币种全仓负债额',
    isoLiab   decimal(24, 12) default 0 not null comment '币种逐仓负债额',
    mgnRatio  decimal(24, 12) default 0 not null comment '保证金率',
    interest  decimal(24, 12) default 0 not null comment '计息',
    unique index (accountId, apiKey, ccy)
) comment '账户余额明细';

drop table if exists OkexAccountPosition;
create table OkexAccountPosition
(
    id        bigint                    not null comment '主键' primary key,
    accountId bigInt(20)                not null comment '平台账户ID',
    apiKey    varchar(255)              not null comment '外部平台apikey',
    instType  varchar(50)               not null comment '产品类型',
    mgnMode   varchar(20)               not null comment '保证金模式',
    posId     varchar(50)               not null comment '持仓ID',
    posSide   varchar(30)               not null comment '持仓方向',
    pos       decimal(24, 12) default 0 not null comment '持仓数量',
    posCcy    varchar(20)               not null comment '仓位资产币种',
    availPos  decimal(24, 12) default 0 not null comment '可平仓数量',
    avgPx     decimal(24, 12) default 0 not null comment '开仓平均价',
    upl       decimal(24, 12) default 0 not null comment '未实现收益',
    uplRatio  decimal(24, 12) default 0 not null comment '未实现收益率',
    instId    varchar(50)               not null comment '产品ID',
    lever     decimal(8, 4)   default 1 not null comment '杠杆倍数',
    liqPx     decimal(24, 12) default 0 not null comment '预估强平价',
    imr       decimal(24, 12) default 0 not null comment '初始保证金',
    margin    decimal(24, 12) default 0 not null comment '保证金余额',
    mgnRatio  decimal(24, 12) default 0 not null comment '保证金率',
    mmr       decimal(24, 12) default 0 not null comment '维持保证金',
    liab      decimal(24, 12) default 0 not null comment '负债额',
    liabCcy   varchar(20)               not null comment '负债币种',
    interest  decimal(24, 12) default 0 not null comment '利息',
    tradeId   varchar(50)               not null comment '最新成交ID',
    optVal    decimal(24, 12) default 0 not null comment '期权市值',
    adl       varchar(20)               not null comment '信号区 ',
    ccy       varchar(20)               not null comment '占用保证金的币种',
    last      decimal(24, 12) default 0 not null comment '最新成交价',
    cTime     bigInt(20)      default 0 not null comment '持仓创建时间',
    uTime     bigInt(20)      default 0 not null comment '最近一次持仓更新时间',
    unique index (accountId, apiKey, instId, posId)
) comment '账户持仓信息';

drop table if exists OkexAccountFill;
create table OkexAccountFill
(
    id          bigint                   not null comment '主键' primary key,
    accountId   bigInt(20)               not null comment '平台账户ID',
    apiKey      varchar(255)             not null comment '外部平台apikey',
    instType    varchar(50)              not null comment '产品类型',
    billId      varchar(50)              not null comment '账单ID',
    type        varchar(30)              not null comment '账单类型',
    subType     varchar(30)              not null comment '账单子类型',
    ts          bigInt(20)               not null comment '账单创建时间',
    balChg      decimal(24, 12) default 0 not null comment '账户层面的余额变动数量',
    posBalChg   decimal(24, 12) default 0 not null comment '仓位层面的余额变动数量',
    bal         decimal(24, 12) default 0 not null comment '账户层面的余额数量',
    posBal      decimal(24, 12) default 0 not null comment '仓位层面的余额数量',
    sz          decimal(24, 12) default 0 not null comment '数量',
    ccy         varchar(20)              not null comment '账户余额币种',
    pnl         decimal(24, 12) default 0 not null comment '收益',
    fee         decimal(24, 12) default 0 not null comment '手续费',
    mgnMode     varchar(20)              not null comment '保证金模式',
    instId      varchar(50)              not null comment '产品ID',
    ordId       varchar(50)              not null comment '订单ID',
    fromAccount varchar(10)              not null comment '转出账户',
    toAccount   varchar(10)              not null comment '转入账户',
    notes       varchar(255) comment '备注',
    unique index (accountId, apiKey, billId)
) comment '账户账单流水';

drop table if exists OkexAccountConfig;
create table OkexAccountConfig
(
    id         bigint                     not null comment '主键' primary key,
    accountId  bigInt(20)                 not null comment '平台账户ID',
    apiKey     varchar(255)               not null comment '外部平台apikey',
    uid        varchar(30)                not null comment '账户ID',
    acctLv     varchar(30)                not null comment '账户层级',
    posMode    varchar(30) default 'none' not null comment '持仓方式',
    autoLoan   char(1)     default '0'    not null comment '是否自动借币',
    greeksType varchar(20)                not null comment '展示方式',
    unique index (accountId, apiKey, uid)
) comment '账户配置';

drop table if exists OkexAccountInterest;
create table OkexAccountInterest
(
    id           bigint               not null comment '主键' primary key,
    accountId    bigInt(20)           not null comment '平台账户ID',
    apiKey       varchar(255)         not null comment '外部平台apikey',
    instId       varchar(30)          not null comment '产品ID',
    ccy          varchar(20)          not null comment '币种',
    mgnMode      varchar(20)          not null comment '持仓模式',
    interestRate decimal(12, 4)       not null comment '利率',
    liab         decimal(24, 12)      not null comment '计息负债',
    interest     decimal(24, 12)      not null comment '利息',
    ts           bigInt(20) default 0 not null comment '计息时间',
    unique index (accountId,apiKey,instId,ts,ccy,mgnMode)
) comment '账户计息记录';

drop table if exists OkexAccountDepositAddr;
create table OkexAccountDepositAddr
(
    id        bigint       not null comment '主键' primary key,
    accountId bigInt(20)   not null comment '平台账户ID',
    apiKey    varchar(255) not null comment '外部平台apikey',
    addr      varchar(255) not null comment '充值地址',
    tag       varchar(30) comment '部分币种充值需要标签',
    memo      varchar(100) comment '部分币种充值需要标签',
    pmtId     varchar(100) comment '部分币种充值需要此字段',
    ccy       varchar(20)  not null comment '币种',
    toAccount varchar(20) comment '转入账户',
    unique index (accountId, apiKey, addr)
) comment '账户充值地址';

drop table if exists OkexAccountDepositHistory;
create table OkexAccountDepositHistory
(
    id          bigint          not null comment '主键' primary key,
    accountId   bigInt(20)      not null comment '平台账户ID',
    apiKey      varchar(255)    not null comment '外部平台apikey',
    ccy         varchar(20)     not null comment '币种名称，如 BTC',
    amt         decimal(24, 12) not null comment '充值数量',
    fromAccount varchar(255) comment '充值地址',
    toAccount   varchar(255)    not null comment '到账地址',
    txId        varchar(255)    not null comment '区块转账哈希记录',
    ts          bigInt(20)      not null comment '充值到账时间',
    state       varchar(2)      not null comment '充值状态',
    depId       varchar(50)     not null comment '充值记录 ID',
    unique index (accountId, apiKey, depId)
) comment '账户充值记录';

drop table if exists OkexAccountWithdrawalHistory;
create table OkexAccountWithdrawalHistory
(
    id          bigint                    not null comment '主键' primary key,
    accountId   bigInt(20)                not null comment '平台账户ID',
    apiKey      varchar(255)              not null comment '外部平台apikey',
    ccy         varchar(20)               not null comment '币种',
    amt         decimal(24, 12)           not null comment '数量',
    ts          bigInt(20)                not null comment '提币申请时间',
    fromAccount varchar(255) comment '提币地址',
    toAccount   varchar(255)              not null comment '收币地址',
    tag         varchar(30) comment '部分币种提币需要标签',
    pmtId       varchar(100) comment '部分币种提币需要此字段',
    memo        varchar(100) comment '部分币种提币需要此字段',
    txId        varchar(255) comment '提币哈希记录',
    fee         decimal(24, 12) default 0 not null comment '提币手续费',
    state       varchar(2)                not null comment '提币状态 ',
    wdId        varchar(50)               not null comment '提币申请 ID',
    unique index (accountId, apiKey, wdId)
) comment '账户提币记录';

drop table if exists OkexDepositWithdrawalCurrency;
create table OkexDepositWithdrawalCurrency
(
    id          bigint                          not null comment '主键' primary key,
    ccy         varchar(20)                     not null comment '币种名称',
    name        varchar(50)                     not null comment '币种中文名称',
    chain       varchar(50) comment '链',
    canDep      char(1)        default '0'      not null comment '是否可充值',
    canWd       char(1)        default '0'      not null comment '是否可提币',
    canInternal char(1)        default '0'      not null comment '是否可内部转账',
    minWd       decimal(12, 4) default 0.0001   not null comment '币种最小提币量',
    minFee      decimal(12, 4) default 0.0001   not null comment '最小提币手续费数量',
    maxFee      decimal(12, 4) default 90000000 not null comment '最大提币手续费数量',
    unique index (ccy, chain)
) comment '充提币种';

drop table if exists OkexAccountAssetBill;
create table OkexAccountAssetBill
(
    id        bigint          not null comment '主键' primary key,
    accountId bigInt(20)      not null comment '平台账户ID',
    apiKey    varchar(255)    not null comment '外部平台apikey',
    billId    varchar(50)     not null comment '账单 ID',
    ccy       varchar(20)     not null comment '账户余额币种',
    balChg    decimal(24, 12) not null comment '账户层面的余额变动数量',
    bal       decimal(24, 12) not null comment '账户层面的余额数量',
    type      varchar(10)     not null comment '账单类型',
    ts        bigInt(20)      not null comment '账单创建时间',
    unique index (accountId, apiKey, billId)
) comment '账户资金流水';

drop table if exists OkexMarketTickers;
create table OkexMarketTickers
(
    id        bigint not null comment '主键' primary key,
    instType  varchar(30) comment '产品类型',
    instId    varchar(50) comment '产品ID',
    last      decimal(24, 12) comment '最新成交价',
    lastSz    decimal(24, 12) comment '最新成交的数量',
    askPx     decimal(24, 12) comment '卖一价',
    askSz     decimal(24, 12) comment '卖一价的挂单数数量',
    bidPx     decimal(24, 12) comment '买一价',
    bidSz     decimal(24, 12) comment '买一价的挂单数量',
    open24h   decimal(24, 12) comment '24小时开盘价',
    high24h   decimal(24, 12) comment '24小时最高价',
    low24h    decimal(24, 12) comment '24小时最低价',
    volCcy24h decimal(24, 12) comment '24小时成交量',
    vol24h    decimal(24, 12) comment '24小时成交量',
    sodUtc0   decimal(24, 12) comment 'UTC 0 时开盘价',
    sodUtc8   decimal(24, 12) comment 'UTC+8 时开盘价',
    ts        bigInt(20) comment '时间',
    unique index (instId)
) comment '行情信息';

drop table if exists OkexInstruments;
create table OkexInstruments
(
    id        bigint not null comment '主键' primary key,
    instType  varchar(30) comment '产品类型',
    instId    varchar(30) comment '产品id',
    uly       varchar(30) comment '合约标的指数',
    category  varchar(30) comment '手续费档位',
    baseCcy   varchar(30) comment '交易货币币种',
    quoteCcy  varchar(30) comment '计价货币币种',
    settleCcy varchar(30) comment '盈亏结算和保证金币种',
    ctVal     decimal(24, 12) comment '合约面值 ',
    ctMult    decimal(24, 12) comment '合约乘数',
    ctValCcy  varchar(30) comment '合约面值计价币种',
    optType   varchar(30) comment '期权类型',
    stk       varchar(30) comment '行权价格',
    listTime  bigInt(20) comment '上线日期',
    expTime   bigInt(20) comment '交割日期 ',
    lever     decimal(8, 4) comment '杠杆倍数',
    tickSz    decimal(24, 12) comment '下单价格精度',
    lotSz     decimal(24, 12) comment '下单数量精度',
    minSz     decimal(24, 12) comment '最小下单数量',
    ctType    varchar(30) comment '合约类型',
    alias     varchar(30) comment '合约日期别名',
    state     varchar(30) comment '产品状态',
    unique index (instId)
) comment '产品信息';

drop table if exists OkexTradeOrder;
create table OkexTradeOrder
(
    id          bigint       not null comment '主键' primary key,
    accountId   bigInt(20)   not null comment '平台账户ID',
    apiKey      varchar(255) not null comment '外部平台apikey',
    instType    varchar(30) comment '产品类型',
    instId      varchar(50) comment '产品ID',
    ccy         varchar(20) comment '保证金币种',
    ordId       varchar(50) comment '订单ID',
    clOrdId     varchar(50) comment '客户自定义订单ID',
    tag         varchar(50) comment '订单标签',
    px          decimal(24, 12) comment '委托价格',
    sz          decimal(24, 12) comment '委托数量',
    pnl         decimal(24, 12) comment '收益',
    ordType     varchar(50) comment '订单类型',
    side        varchar(50) comment '订单方向',
    posSide     varchar(50) comment '持仓方向',
    tdMode      varchar(50) comment '交易模式',
    accFillSz   decimal(24, 12) comment '累计成交数量',
    fillPx      decimal(24, 12) comment '最新成交价格',
    tradeId     varchar(50) comment '最新成交ID',
    fillSz      decimal(24, 12) comment '最新成交数量',
    fillTime    bigInt(20) comment '最新成交时间',
    avgPx       decimal(24, 12) comment '成交均价',
    state       varchar(50) comment '订单状态',
    lever       decimal(8, 4) comment '杠杆倍数',
    tpTriggerPx decimal(24, 12) comment '止盈触发价',
    tpOrdPx     decimal(24, 12) comment '止盈委托价',
    slTriggerPx decimal(24, 12) comment '止损触发价',
    slOrdPx     decimal(24, 12) comment '止损委托价',
    feeCcy      varchar(20) comment '交易手续费币种',
    fee         decimal(24, 12) comment '订单交易手续费',
    rebateCcy   varchar(20) comment '返佣金币种',
    rebate      decimal(24, 12) comment '返佣金额',
    category    varchar(20) comment '订单种类',
    uTime       bigInt(20) comment '订单状态更新时间',
    cTime       bigInt(20) comment '订单创建时间',
    unique index (ordId, accountId, apiKey)
) comment '账户订单信息';

drop table if exists OkexTradeFill;
create table OkexTradeFill
(
    id        bigint       not null comment '主键' primary key,
    accountId bigInt(20)   not null comment '平台账户ID',
    apiKey    varchar(255) not null comment '外部平台apikey',
    instType  varchar(30) comment '产品类型',
    instId    varchar(50) comment '产品 ID',
    tradeId   varchar(50) comment '最新成交 ID',
    ordId     varchar(50) comment '订单 ID',
    billId    varchar(50) comment '账单 ID',
    tag       varchar(50) comment '订单标签',
    fillPx    decimal(24, 12) comment '最新成交价格',
    fillSz    decimal(24, 12) comment '最新成交数量',
    side      varchar(10) comment '订单方向',
    posSide   varchar(10) comment '持仓方向',
    execType  varchar(10) comment '流动性方向',
    feeCcy    varchar(20) comment '交易手续费币种或者返佣金币种',
    fee       decimal(24, 12) comment '手续费金额或者返佣金额',
    ts        bigInt(20) comment '成交明细产生时间',
    unique index (billId, accountId, apiKey)
) comment '账户成交明细';

drop table if exists OkexTradeOrderAlgo;
create table OkexTradeOrderAlgo
(
    id          bigint       not null comment '主键' primary key,
    accountId   bigInt(20)   not null comment '平台账户ID',
    apiKey      varchar(255) not null comment '外部平台apikey',
    instType    varchar(30) comment '产品类型',
    instId      varchar(30) comment '产品ID',
    ccy         varchar(20) comment '保证金币种',
    ordId       varchar(50) comment '订单ID',
    algoId      varchar(128) comment '策略委托单ID',
    sz          decimal(24, 12) comment '委托数量',
    ordType     varchar(20) comment '订单类型',
    side        varchar(20) comment '订单方向',
    posSide     varchar(20) comment '持仓方向',
    tdMode      varchar(20) comment '交易模式',
    state       varchar(20) comment '订单状态',
    lever       decimal(8, 4) comment '杠杆倍数',
    tpTriggerPx decimal(24, 12) comment '止盈触发价',
    tpOrdPx     decimal(24, 12) comment '止盈委托价',
    slTriggerPx decimal(24, 12) comment '止损触发价',
    slOrdPx     decimal(24, 12) comment '止损委托价',
    triggerPx   decimal(24, 12) comment '计划委托触发价格',
    ordPx       decimal(24, 12) comment '计划委托委托价格',
    actualSz    decimal(24, 12) comment '实际委托量',
    actualPx    decimal(24, 12) comment '实际委托价',
    actualSide  varchar(20) comment '实际触发方向',
    triggerTime bigInt(20) comment '策略委托触发时间',
    cTime       bigInt(20) comment '订单创建时间',
    unique index (algoId, accountId, apiKey)
) comment '账户策略委托单';

