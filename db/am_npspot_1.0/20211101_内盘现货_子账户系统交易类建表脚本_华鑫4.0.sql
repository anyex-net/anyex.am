/*use amnpspot;*/

drop table if exists SubStpNpSpotAccountInfo;
create table SubStpNpSpotAccountInfo
(
    id                              bigint        not null comment '主键' primary key,
    subAccountId                    bigint(20)    not null comment '子账户AM平台账户ID',
    motherNpspotAccountInfoId       bigint(20)    not null comment '母账户内盘现货投资者帐号ID',
    remark                          varchar(256)  not null comment '备注',
    unique index (`subAccountId`)
) comment '子账户投资帐号信息表';

drop table if exists SubStpNpSpotTradingAccount;
create table SubStpNpSpotTradingAccount
(
    id                              bigint                      not null comment '主键' primary key,
    subAccountId                    bigint(20)                  not null comment '子账户AM平台账户ID',
    /*
    brokerID                        varchar(12)                 not null comment '经纪公司代码',
    departmentID                    varchar(12)                 not null comment '经纪公司部门代码',
    accountNo                       varchar(22)                 not null comment '资金账户代码(对应AccountID)',
    investorID                      varchar(17)                 not null comment '资金账户所属投资者代码',
    */
    currencyID                      char                        not null comment '币种代码',
    preDeposit                      decimal(22, 8) default 0    not null comment '上日结存',
    usefulMoney                     decimal(22, 8) default 0    not null comment '可用资金',
    fetchLimit                      decimal(22, 8) default 0    not null comment '可取资金',
    preUnDeliveredMoney             decimal(22, 8) default 0    not null comment '上日未交收金额(港股通专用字段)',
    unDeliveredMoney                decimal(22, 8) default 0    not null comment '可用未交收金额(港股通专用字段)',
    deposit                         decimal(22, 8) default 0    not null comment '当日入金金额',
    withdraw                        decimal(22, 8) default 0    not null comment '当日出金金额',
    frozenCash                      decimal(22, 8) default 0    not null comment '冻结的资金(港股通该字段不包括未交收部分冻结资金)',
    unDeliveredFrozenCash           decimal(22, 8) default 0    not null comment '冻结未交收金额(港股通专用)',
    frozenCommission                decimal(22, 8) default 0    not null comment '冻结的手续费(港股通该字段不包括未交收部分冻结手续费)',
    unDeliveredFrozenCommission     decimal(22, 8) default 0    not null comment '冻结未交收手续费(港股通专用)',
    commission                      decimal(22, 8) default 0    not null comment '手续费(港股通该字段不包括未交收部分手续费)',
    unDeliveredCommission           decimal(22, 8) default 0    not null comment '占用未交收手续费(港股通专用)',
    accountType                     char                        not null comment '资金账户类型',
    bankID                          char                        not null comment '银行代码',
    bankAccountID                   varchar(32)                 not null comment '银行账户',
    royaltyIn                       decimal(22, 8) default 0    not null comment '权利金收入(两融专用)',
    royaltyOut                      decimal(22, 8) default 0    not null comment '权利金支出(两融专用)',
    creditSellAmount                decimal(22, 8) default 0    not null comment '融券卖出金额(两融专用)',
    creditSellUseAmount             decimal(22, 8) default 0    not null comment '融券卖出使用金额(用于偿还融资负债或买特殊品种的金额)(两融专用)',
    virtualAssets                   decimal(22, 8) default 0    not null comment '虚拟资产(两融专用)',
    creditSellFrozenAmount          decimal(22, 8) default 0    not null comment '融券卖出金额冻结(用于偿还融资负债或买特殊品种的未成交冻结金额)(两融专用)',
#     unique index (`subAccountId`, `investorID`, `accountNo`)
    unique index (`subAccountId`, `currencyID`)
) comment '子账户资金账户息表';

drop table if exists SubStpNpSpotPosition;
create table SubStpNpSpotPosition
(
    id                              bigint                  not null comment '主键' primary key,
    subAccountId                    bigint(20)              not null comment '子账户AM平台账户ID',
    /*
    brokerID                        varchar(12)             not null comment '经纪公司代码',
    */
    exchangeID                      char                    not null comment '交易所代码',
#     investorID                      varchar(17)             not null comment '投资者代码',
    businessUnitID                  varchar(17)             not null comment '投资单元代码',
    marketID                        char                    not null comment '市场代码',
#     shareholderID                   varchar(12)             not null comment '股东账户代码',
    tradingDay                      varchar(10)             not null comment '交易日',
    securityID                      varchar(32)             not null comment '证券代码',
    securityName                    varchar(81)             not null comment '证券名称',
    historyPos                      int(11)                 not null comment '昨仓',
    historyPosFrozen                int(11)                 not null comment '昨仓冻结',
    todayBSPos                      int(11)                 not null comment '今买卖仓',
    todayBSPosFrozen                int(11)                 not null comment '今买卖仓冻结',
    todayPRPos                      int(11)                 not null comment '今日申赎持仓',
    todayPRPosFrozen                int(11)                 not null comment '今日申赎持仓冻结',
    todaySMPos                      int(11)                 not null comment '今拆分合并持仓',
    todaySMPosFrozen                int(11)                 not null comment '今拆分合并持仓冻结',
    historyPosPrice                 decimal(22,8) default 0 not null comment '昨仓成本价',
    totalPosCost                    decimal(22,8) default 0 not null comment '持仓成本',
    prePosition                     int(11)                 not null comment '上次余额(盘中不变)',
    availablePosition               int(11)                 not null comment '股份可用',
    currentPosition                 int(11)                 not null comment '股份余额',
    openPosCost                     decimal(22,8) default 0 not null comment '开仓成本',
    creditBuyPos                    int(11)                 not null comment '融资仓位(两融专用)',
    creditSellPos                   int(11)                 not null comment '融券仓位(两融专用)',
    todayCreditSellPos              int(11)                 not null comment '今日融券仓位(两融专用)',
    collateralOutPos                int(11)                 not null comment '划出仓位(两融专用)',
    repayUntradeVolume              int(11)                 not null comment '还券未成交数量(两融专用)',
    repayTransferUntradeVolume      int(11)                 not null comment '直接还券未成交数量(两融专用)',
    collateralBuyUntradeAmount      decimal(22,8) default 0 not null comment '担保品买入未成交金额(两融专用)',
    collateralBuyUntradeVolume      int(11)                 not null comment '担保品买入未成交数量(两融专用)',
    creditBuyAmount                 decimal(22,8) default 0 not null comment '融资买入金额(包含交易费用)(两融专用)',
    creditBuyUntradeAmount          decimal(22,8) default 0 not null comment '融资买入未成交金额(包含交易费用)(两融专用)',
    creditBuyFrozenMargin           decimal(22,8) default 0 not null comment '融资冻结保证金(两融专用)',
    creditBuyInterestFee            decimal(22,8) default 0 not null comment '融资买入利息(两融专用)',
    creditBuyUntradeVolume          int(11)                 not null comment '融资买入未成交数量(两融专用)',
    creditSellAmount                decimal(22,8) default 0 not null comment '融券卖出金额(以成交价计算)(两融专用)',
    creditSellUntradeAmount         decimal(22,8) default 0 not null comment '融券卖出未成交金额(两融专用)',
    creditSellFrozenMargin          decimal(22,8) default 0 not null comment '融券冻结保证金(两融专用)',
    creditSellInterestFee           decimal(22,8) default 0 not null comment '融券卖出息费(两融专用)',
    creditSellUntradeVolume         int(11)                 not null comment '融券卖出未成交数量(两融专用)',
    collateralInPos                 int(11)                 not null comment '划入待收仓(两融专用)',
    creditBuyFrozenCirculateMargin  decimal(22,8) default 0 not null comment '融资流动冻结保证金(两融专用)',
    creditSellFrozenCirculateMargin decimal(22,8) default 0 not null comment '融券流动冻结保证金(两融专用)',
    closeProfit                     decimal(22,8) default 0 not null comment '累计平仓盈亏(两融专用)',
    todayTotalOpenVolume            int(11)                 not null comment '当日累计开仓数量(两融专用)',
    positionProfit                  decimal(22,8) default 0 not null comment '持仓盈亏',
#     unique index (`subAccountId`, `exchangeID`, `investorID`, `securityID`)
    unique index (`subAccountId`, `exchangeID`, `securityID`)
) comment '子账户持仓汇总表';

drop table if exists SubStpNpSpotOrder;
create table SubStpNpSpotOrder
(
    id                      bigint                  not null comment '主键' primary key,
    subAccountId            bigint(20)              not null comment '子账户AM平台账户ID',
    /*
    brokerID                varchar(12)             not null comment '经纪公司代码',
    */
    exchangeID              char                    not null comment '交易所代码',
    investorID              varchar(17)             not null comment '投资者代码',
    businessUnitID          varchar(17)             not null comment '投资单元代码',
    shareholderID           varchar(12)             not null comment '股东账户代码',
    securityID              varchar(32)             not null comment '证券代码',
    direction               char                    not null comment '买卖方向',
    orderPriceType          char                    not null comment '报单价格条件',
    timeCondition           char                    not null comment '有效期类型',
    volumeCondition         char                    not null comment '成交量类型',
    limitPrice              decimal(22,8) default 0          comment '价格',
    volumeTotalOriginal     int(11)                 not null comment '数量',
    lotType                 char                    not null comment '港股通订单数量类型',
    gTDate                  varchar(10)             not null comment '有效日期',
    operway                 char                    not null comment '委托方式',
    condCheck               char                    not null comment '条件检查',
    sInfo                   varchar(34)             not null comment '字符串附加信息',
    iInfo                   int(11)                 not null comment '整形附加信息',
    requestID               int(11)                          comment '请求编号',
    frontID                 int(11)                          comment '前置编号',
    sessionID               int(11)                          comment '会话编号',
    orderRef                int(11)                 not null comment '报单引用',
    orderLocalID            varchar(14)                      comment '本地报单编号',
    orderSysID              varchar(22)             not null comment '系统报单编号',
    orderStatus             char                             comment '报单状态',
    orderSubmitStatus       char                             comment '报单提交状态',
    statusMsg               varchar(82)                      comment '状态信息',
    volumeTraded            int(11)                          comment '已成交数量',
    volumeCanceled          int(11)                          comment '已撤销数量',
    tradingDay              varchar(10)                      comment '交易日',
    insertUser              varchar(17)                      comment '申报用户',
    insertDate              varchar(10)                      comment '申报日期',
    insertTime              varchar(10)                      comment '申报时间',
    acceptTime              varchar(10)                      comment '交易所接收时间',
    cancelUser              varchar(17)                      comment '撤销用户',
    cancelTime              varchar(10)                      comment '撤销时间',
#     departmentID            varchar(12)                      comment '经纪公司部门代码',
#     accountNo               varchar(22)                      comment '资金账户代码(对应AccountID)',
    currencyID              char                             comment '币种',
    pbuID                   varchar(12)                      comment '交易单元代码',
    turnover                decimal(22,8) default 0          comment '成交金额',
    orderType               char                             comment '报单类型',
    userProductInfo         varchar(12)                      comment '用户端产品信息',
    forceCloseReason        char                    not null comment '强平原因(两融专用)',
    creditQuotaID           varchar(18)                      comment '信用头寸编号(两融专用)',
    creditQuotaType         char                    not null comment '头寸类型(两融专用)',
    creditDebtID            varchar(22)             not null comment '信用负债编号(两融专用)',
    iPAddress               varchar(17)                      comment 'IP地址',
    macAddress              varchar(22)                      comment 'Mac地址',
    rtnFloatInfo            decimal(22,8) default 0          comment '回报附加浮点型数据信息',
    rtnIntInfo              int(11)                          comment '回报附加整型数据',
    errorID                 int(11)                          comment '错误代码',
    errorMsg                varchar(82)                      comment '错误信息',
    discountCouponID        int(11)                          comment '费息折扣券编号（0表示不使用折扣券）(两融专用)',
    actionFlag              char                             comment '操作标志',
    orderActionRef          int(11)                          comment '报单操作引用',
    cancelOrderSysID        varchar(22)                      comment '系统撤单编号',
    frozenCommission        decimal(22,8) default 0 not null comment '冻结手续费',
    frozenCash              decimal(22,8) default 0 not null comment '冻结资金',
    remainFrozenCommission  decimal(22,8) default 0 not null comment '剩余冻结手续费',
    remainFrozenCash        decimal(22,8) default 0 not null comment '剩余冻结资金',
    brokerageRatio          decimal(22,8) default 0 not null comment '佣金费率',
    brokerageFeeMin         decimal(22,8) default 0 not null comment '佣金费最低收取金额',
    stampTaxRatio           decimal(22,8) default 0 not null comment '印花税率',
    transferRatio           decimal(22,8) default 0 not null comment '过户费率',
#     unique index (`subAccountId`, `investorID`, `orderSysID`, `tradingDay`)
    unique index (`subAccountId`, `orderSysID`, `tradingDay`, `sInfo`)
) comment '子账户委托订单表';

drop table if exists SubStpNpSpotTrade;
create table SubStpNpSpotTrade
(
    id                      bigint                  not null comment '主键' primary key,
    subAccountId            bigint(20)              not null comment '子账户AM平台账户ID',
    /*
    brokerID                varchar(12)             not null comment '经纪公司代码',
    */
    exchangeID              char                    not null comment '交易所代码',
#     investorID              varchar(17)             not null comment '投资者代码',
#     departmentID            varchar(12)             not null comment '经纪公司部门代码',
    businessUnitID          varchar(17)             not null comment '投资单元代码',
#     shareholderID           varchar(12)             not null comment '股东账户代码',
    securityID              varchar(32)             not null comment '证券代码',
    tradeID                 varchar(22)             not null comment '成交编号',
    direction               char                    not null comment '买卖方向',
    orderSysID              varchar(22)             not null comment '系统报单编号',
    orderLocalID            varchar(14)             not null comment '本地报单编号',
    price                   decimal(22,8) default 0 not null comment '成交价格',
    volume                  int(11)                 not null comment '成交数量',
    tradeDate               varchar(10)             not null comment '成交日期',
    tradeTime               varchar(10)             not null comment '成交时间',
    tradingDay              varchar(10)             not null comment '交易日',
    pbuID                   varchar(12)             not null comment '交易单元代码',
    orderRef                int(11)                 not null comment '报单引用',
#     accountNo               varchar(22)             not null comment '资金账户代码(对应AccountID)',
    currencyID              char                    not null comment '币种',
#     unique index (`subAccountId`, `investorID`, `tradeID`, `direction`)
    unique index (`subAccountId`, `tradeID`, `direction`)
) comment '子账户成交表';

drop table if exists SubStpNpSpotOrderHis;
create table SubStpNpSpotOrderHis
(
    id                      bigint                  not null comment '主键' primary key,
    subAccountId            bigint(20)              not null comment '子账户AM平台账户ID',
    /*
    brokerID                varchar(12)             not null comment '经纪公司代码',
    */
    exchangeID              char                    not null comment '交易所代码',
    investorID              varchar(17)             not null comment '投资者代码',
    businessUnitID          varchar(17)             not null comment '投资单元代码',
    shareholderID           varchar(12)             not null comment '股东账户代码',
    securityID              varchar(32)             not null comment '证券代码',
    direction               char                    not null comment '买卖方向',
    orderPriceType          char                    not null comment '报单价格条件',
    timeCondition           char                    not null comment '有效期类型',
    volumeCondition         char                    not null comment '成交量类型',
    limitPrice              decimal(22,8) default 0          comment '价格',
    volumeTotalOriginal     int(11)                 not null comment '数量',
    lotType                 char                    not null comment '港股通订单数量类型',
    gTDate                  varchar(10)             not null comment '有效日期',
    operway                 char                    not null comment '委托方式',
    condCheck               char                    not null comment '条件检查',
    sInfo                   varchar(34)             not null comment '字符串附加信息',
    iInfo                   int(11)                 not null comment '整形附加信息',
    requestID               int(11)                          comment '请求编号',
    frontID                 int(11)                          comment '前置编号',
    sessionID               int(11)                          comment '会话编号',
    orderRef                int(11)                 not null comment '报单引用',
    orderLocalID            varchar(14)                      comment '本地报单编号',
    orderSysID              varchar(22)             not null comment '系统报单编号',
    orderStatus             char                             comment '报单状态',
    orderSubmitStatus       char                             comment '报单提交状态',
    statusMsg               varchar(82)                      comment '状态信息',
    volumeTraded            int(11)                          comment '已成交数量',
    volumeCanceled          int(11)                          comment '已撤销数量',
    tradingDay              varchar(10)                      comment '交易日',
    insertUser              varchar(17)                      comment '申报用户',
    insertDate              varchar(10)                      comment '申报日期',
    insertTime              varchar(10)                      comment '申报时间',
    acceptTime              varchar(10)                      comment '交易所接收时间',
    cancelUser              varchar(17)                      comment '撤销用户',
    cancelTime              varchar(10)                      comment '撤销时间',
#     departmentID            varchar(12)                      comment '经纪公司部门代码',
#     accountNo               varchar(22)                      comment '资金账户代码(对应AccountID)',
    currencyID              char                             comment '币种',
    pbuID                   varchar(12)                      comment '交易单元代码',
    turnover                decimal(22,8) default 0          comment '成交金额',
    orderType               char                             comment '报单类型',
    userProductInfo         varchar(12)                      comment '用户端产品信息',
    forceCloseReason        char                    not null comment '强平原因(两融专用)',
    creditQuotaID           varchar(18)                      comment '信用头寸编号(两融专用)',
    creditQuotaType         char                    not null comment '头寸类型(两融专用)',
    creditDebtID            varchar(22)             not null comment '信用负债编号(两融专用)',
    iPAddress               varchar(17)                      comment 'IP地址',
    macAddress              varchar(22)                      comment 'Mac地址',
    rtnFloatInfo            decimal(22,8) default 0          comment '回报附加浮点型数据信息',
    rtnIntInfo              int(11)                          comment '回报附加整型数据',
    errorID                 int(11)                          comment '错误代码',
    errorMsg                varchar(82)                      comment '错误信息',
    discountCouponID        int(11)                          comment '费息折扣券编号（0表示不使用折扣券）(两融专用)',
    actionFlag              char                             comment '操作标志',
    orderActionRef          int(11)                          comment '报单操作引用',
    cancelOrderSysID        varchar(22)                      comment '系统撤单编号',
    frozenCommission        decimal(22,8) default 0 not null comment '冻结手续费',
    frozenCash              decimal(22,8) default 0 not null comment '冻结资金',
    remainFrozenCommission  decimal(22,8) default 0 not null comment '剩余冻结手续费',
    remainFrozenCash        decimal(22,8) default 0 not null comment '剩余冻结资金',
    brokerageRatio          decimal(22,8) default 0 not null comment '佣金费率',
    brokerageFeeMin         decimal(22,8) default 0 not null comment '佣金费最低收取金额',
    stampTaxRatio           decimal(22,8) default 0 not null comment '印花税率',
    transferRatio           decimal(22,8) default 0 not null comment '过户费率',
#     unique index (`subAccountId`, `investorID`, `orderSysID`, `tradingDay`)
    unique index (`subAccountId`, `orderSysID`, `tradingDay`, `sInfo`)
) comment '子账户委托订单历史表';