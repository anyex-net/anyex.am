/*use amwpfutures;*/

drop table if exists WpfuturesCurrencyInfo;
create table WpfuturesCurrencyInfo
(
    id              bigint                   not null comment '主键' primary key,
    currencyNo      varchar(10)              not null comment '币种编号',
    currencyGroupNo varchar(10)              not null comment '币种组编号',
    tradeRate       decimal(22, 8) default 0 not null comment '交易汇率',
    tradeRate2      decimal(22, 8) default 0 not null comment '交易汇率2',
    futureAlg       char(1)                  not null comment '币种组独立标志',
    optionAlg       char(1)                  not null comment '是否是基币',
    unique index (`currencyNo`, `currencyGroupNo`)
) comment '外盘期货币种信息表';

drop table if exists WpfuturesBrokerInfo;
create table WpfuturesBrokerInfo
(
    id              bigint       not null comment '主键' primary key,
    brokerNo        varchar(12)  not null comment '经纪商编码',
    brokerName      varchar(64)  not null comment '经纪商名称',
    brokerDomain    varchar(255) not null comment '经纪商域名',
    unique index (`brokerNo`)
) comment '外盘期货经纪商信息表';

drop table if exists WpfuturesExchangeInfo;
create table WpfuturesExchangeInfo
(
    id              bigint                        not null comment '主键' primary key,
    exchangeNo      varchar(10)                   not null comment '交易所编码',
    exchangeName    varchar(64)                   not null comment '交易所名称',
    exchangeDomain  varchar(255)                  not null comment '交易所域名',
    openMarket      varchar(10)                   not null comment '交易所是否开市(open、close)',
    enableStatus    varchar(16) default 'disable' not null comment '启用状态(启用enable、不启用disable)',
    unique index (`exchangeNo`)
) comment '外盘期货交易所信息表';

drop table if exists WpfuturesExchangeCommodity;
create table WpfuturesExchangeCommodity
(
    id                   bigint                         not null comment '主键' primary key,
    exchangeNo           varchar(10)                    not null comment '交易所编码',
    commodityType        char(1)                                  comment '品种类型',
    commodityNo          varchar(10)                     not null comment '品种编号',
    commodityName        varchar(20)                     not null comment '品种名称',
    commodityEngName     varchar(30)                     not null comment '品种英文名称',
    relateExchangeNo     varchar(10)                              comment '',
    relateCommodityType  char(1)                                  comment '',
    relateCommodityNo    varchar(10)                              comment '',
    relateExchangeNo2    varchar(10)                              comment '',
    relateCommodityType2 char(1)                                  comment '',
    relateCommodityNo2   varchar(10)                              comment '',
    currencyGroupNo      varchar(10)                              comment '',
    tradeCurrency        varchar(10)                              comment '交易币种',
    contractSize         decimal(22, 8) default 0                 comment '每手乘数',
    openCloseMode        char(1)                                  comment '开平方式',
    strikePriceTimes     decimal(22, 8) default 0                 comment '执行价格倍数',
    commodityTickSize    decimal(22, 8) default 0                 comment '最小变动价位',
    commodityDenominator int(11)        default 0                 comment '报价分母',
    cmbDirect            char(1)                                  comment '组合方向',
    deliveryMode         char(1)                                  comment '交割行权方式',
    deliveryDays         int(11)        default 0                 comment '交割日偏移',
    addOneTime           varchar(32)                              comment 'T+1分割时间',
    commodityTimeZone    int(11)        default 0                 comment '品种时区',
    isAddOne             char(1)                                  comment '是否处于T+1时段',
    enableStatus         varchar(16)   default 'disable' not null comment '启用状态(启用enable、不启用disable)',
    unique index (`exchangeNo`, `commodityType`, `commodityNo`)
) comment '外盘期货交易所期货品种信息表';

drop table if exists WpfuturesExchangeContract;
create table WpfuturesExchangeContract
(
    id                      bigint                        not null comment '主键' primary key,
    exchangeNo              varchar(10)                   not null comment '交易所编码',
    commodityType           char(1)                       not null comment '品种类型',
    commodityNo             varchar(10)                   not null comment '品种编号',
    contractNo1             varchar(10)                   not null comment '合约代码1',
    strikePrice1            varchar(10)                            comment '执行价1',
    callOrPutFlag1          char(1)                                comment '看涨看跌标示1',
    contractNo2             varchar(10)                            comment '合约代码2',
    strikePrice2            varchar(10)                            comment '执行价2',
    callOrPutFlag2          char(1)                                comment '看涨看跌标示2',
    contractType            char(1)                                comment '合约类型',
    quoteUnderlyingContract varchar(10)                            comment '行情真实合约',
    contractName            varchar(70)                            comment '合约名称',
    contractExpDate         varchar(32)                            comment '合约到期日',
    lastTradeDate           varchar(32)                            comment '最后交易日',
    firstNoticeDate         varchar(32)                            comment '首次通知日',
    enableStatus            varchar(16) default 'disable' not null comment '启用状态(启用enable、不启用disable)',
    unique index (`exchangeNo`, `commodityType`, `commodityNo`, `contractNo1`)
) comment '外盘期货交易所期货合约信息表';

drop table if exists WpfuturesQuoteWhole;
create table WpfuturesQuoteWhole
(
    id               bigint                             not null comment '主键' primary key,
    exchangeNo       varchar(10)                        not null comment '交易所编码',
    commodityType    char(1)                            not null comment '品种类型',
    commodityNo      varchar(10)                        not null comment '品种编号',
    contractNo       varchar(10)                        not null comment '合约代码1',
    currencyNo       varchar(10)                        not null comment '币种编号',
    tradingState     char(1)                            not null comment '交易状态1,集合竞价2,集合竞价撮合3,连续交易4,交易暂停5,闭市',
    dateTimeStamp    varchar(32)                        not null comment '时间戳',
    qPreClosingPrice decimal(22, 8) default 0           not null comment '昨收盘价',
    qPreSettlePrice  decimal(22, 8) default 0           not null comment '昨结算价',
    qPrePositionQty  decimal(22, 8) default 0           not null comment '昨持仓量',
    qOpeningPrice    decimal(22, 8) default 0           not null comment '开盘价',
    qLastPrice       decimal(22, 8) default 0           not null comment '最新价',
    qHighPrice       decimal(22, 8) default 0           not null comment '最高价',
    qLowPrice        decimal(22, 8) default 0           not null comment '最低价',
    qHisHighPrice    decimal(22, 8) default 0           not null comment '历史最高价',
    qHisLowPrice     decimal(22, 8) default 0           not null comment '历史最低价',
    qLimitUpPrice    decimal(22, 8) default 0           not null comment '涨停价',
    qLimitDownPrice  decimal(22, 8) default 0           not null comment '跌停价',
    qTotalQty        decimal(22, 8) default 0           not null comment '当日总成交量',
    qTotalTurnover   decimal(22, 8) default 0           not null comment '当日成交金额',
    qPositionQty     decimal(22, 8) default 0           not null comment '持仓量',
    qAveragePrice    decimal(22, 8) default 0           not null comment '均价',
    qClosingPrice    decimal(22, 8) default 0           not null comment '收盘价',
    qSettlePrice     decimal(22, 8) default 0           not null comment '结算价',
    qLastQty         decimal(22, 8) default 0           not null comment '最新成交量',
    qBidPrice        varchar(255)   default '[]'        not null comment '买价1-20档',
    qBidQty          varchar(255)   default '[]'        not null comment '买量1-20档',
    qAskPrice        varchar(255)   default '[]'        not null comment '卖价1-20档',
    qAskQty          varchar(255)   default '[]'        not null comment '卖量1-20档',
    qImpliedBidPrice decimal(22, 8) default 0           not null comment '隐含买价',
    qImpliedBidQty   decimal(22, 8) default 0           not null comment '隐含买量',
    qImpliedAskPrice decimal(22, 8) default 0           not null comment '隐含卖价',
    qImpliedAskQty   decimal(22, 8) default 0           not null comment '隐含卖量',
    qPreDelta        decimal(22, 8) default 0           not null comment '昨虚实度',
    qCurrDelta       decimal(22, 8) default 0           not null comment '今虚实度',
    qInsideQty       decimal(22, 8) default 0           not null comment '内盘量',
    qOutsideQty      decimal(22, 8) default 0           not null comment '外盘量',
    qTurnoverRate    decimal(22, 8) default 0           not null comment '换手率',
    q5DAvgQty        decimal(22, 8) default 0           not null comment '五日均量',
    qPERatio         decimal(22, 8) default 0           not null comment '市盈率',
    qTotalValue      decimal(22, 8) default 0           not null comment '总市值',
    qNegotiableValue decimal(22, 8) default 0           not null comment '流通市值',
    qPositionTrend   decimal(22, 8) default 0           not null comment '持仓走势',
    qChangeSpeed     decimal(22, 8) default 0           not null comment '涨速',
    qChangeRate      decimal(22, 8) default 0           not null comment '涨幅',
    qChangeValue     decimal(22, 8) default 0           not null comment '涨跌值',
    qSwing           decimal(22, 8) default 0           not null comment '振幅',
    qTotalBidQty     decimal(22, 8) default 0           not null comment '委买总量',
    qTotalAskQty     decimal(22, 8) default 0           not null comment '委卖总量',
    underlyContract  varchar(1024)                               comment '虚拟合约对应的真实合约(对象)',
    changeReason     varchar(16)    default 'entrust'   not null comment '行情变动原因(委托盘口entrust、撮和成交trade)'
) comment '外盘期货行情表';

drop table if exists WpfuturesExchangeTradeDay;
create table WpfuturesExchangeTradeDay
(
    id                      bigint                        not null comment '主键' primary key,
    exchangeNo              varchar(10)                   not null comment '交易所编码',
    commodityNo             varchar(10)                   not null comment '品种编号',
    weekNum                 int                           not null comment '星期几(1~7)',
    isTradeDay              int                           not null comment '是否交易日(1交易日、0非交易日)',
    tradeDayTime            bigint(13)                    not null comment '交易日零点时间戳',
    tradeDayOpenTime        bigint(13)                    not null comment '交易日开盘时间戳',
    tradeDayCloseTime       bigint(13)                    not null comment '交易日收盘时间戳',
    unique index (`exchangeNo`, `commodityNo`, `tradeDayTime`)
) comment '外盘期货交易所交易日表';
