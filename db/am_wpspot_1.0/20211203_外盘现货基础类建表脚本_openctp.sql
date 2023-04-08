/*
CREATE DATABASE amwpspot;
use amwpspot;
*/

drop table if exists WpSpotBroker;
create table WpSpotBroker
(
    id              bigint       not null comment '主键' primary key,
    brokerID        varchar(10)  not null comment '经纪公司代码',
    brokerAbbr      varchar(10)  not null comment '经纪公司简称',
    brokerName      varchar(82)  not null comment '经纪公司名称',
    brokerDomain    varchar(255) not null comment '经纪公司域名',
    unique index (`brokerID`)
) comment '外盘现货经纪商信息表';

drop table if exists WpSpotExchange;
create table WpSpotExchange
(
    id                bigint                            not null comment '主键' primary key,
    exchangeID        varchar(10)                       not null comment '交易所代码',
    exchangeName      varchar(64)                       not null comment '交易所名称',
    exchangeProperty  varchar(8)                        not null comment '交易所属性(0正常、1根据成交生成报单)',
    exchangeDomain    varchar(255)                               comment '交易所域名',
    openMarket        varchar(10)                                comment '交易所是否开市(open、close)',
    enableStatus      varchar(16)     default 'disable' not null comment '启用状态(启用enable、不启用disable)',
    unique index (`exchangeID`)
) comment '外盘现货交易所表';

-- drop table if exists WpSpotExchangeProduct;
-- create table WpSpotExchangeProduct
-- (
--     id                    bigint                            not null comment '主键' primary key,
--     productID             varchar(32)                       not null comment '产品代码',
--     exchangeID            varchar(10)                       not null comment '交易所代码',
--     productName           varchar(32)                       not null comment '产品名称',
--     productClass          varchar(8)                        not null comment '产品类型(产品类型数据字典)',
--     VolumeMultiple        int(11)                           not null comment '合约数量乘数',
--     priceTick             decimal(22, 8)                    not null comment '最小变动价位',
--     maxMarketOrderVolume  int(11)                           not null comment '市价单最大下单量',
--     minMarketOrderVolume  int(11)                           not null comment '市价单最小下单量',
--     maxLimitOrderVolume   int(11)                           not null comment '限价单最大下单量',
--     minLimitOrderVolume   int(11)                           not null comment '限价单最小下单量',
--     positionType          varchar(8)                        not null comment '持仓类型(持仓类型数据字典)',
--     positionDateType      varchar(8)                        not null comment '持仓日期类型(持仓日期类型数据字典)',
--     closeDealType         varchar(8)                        not null comment '平仓处理类型(平仓处理类型数据字典)',
--     tradeCurrencyID       varchar(8)                        not null comment '交易币种类型(币种代码类型数据字典)',
--     mortgageFundUseRange  varchar(8)                        not null comment '质押资金可用范围(货币质押资金可用范围类型数据字典)',
--     exchangeProductID     varchar(32)                                comment '交易所产品代码',
--     underlyingMultiple    decimal(22, 8)                    not null comment '合约基础商品乘数',
--     enableStatus          varchar(16)     default 'disable' not null comment '启用状态(启用enable、不启用disable)',
--     unique index ( `productID`, `exchangeID`)
-- ) comment '外盘现货交易所产品表';

drop table if exists WpSpotExchangeInstrument;
create table WpSpotExchangeInstrument
(
    id                      bigint                           not null comment '主键' primary key,
    instrumentID            varchar(32)                      not null comment '合约代码',
    exchangeID              varchar(10)                      not null comment '交易所代码',
    instrumentName          varchar(32)                      not null comment '合约名称',
    exchangeInstID          varchar(32)                      not null comment '合约在交易所的代码',
    productID               varchar(32)                      not null comment '产品代码',
    productClass            varchar(8)                       not null comment '产品类型(产品类型数据字典)',
    deliveryYear            int(11)                          not null comment '交割年份',
    deliveryMonth           int(11)                          not null comment '交割月',
    maxMarketOrderVolume    int(11)                          not null comment '市价单最大下单量',
    minMarketOrderVolume    int(11)                          not null comment '市价单最小下单量',
    maxLimitOrderVolume     int(11)                          not null comment '限价单最大下单量',
    minLimitOrderVolume     int(11)                          not null comment '限价单最小下单量',
    volumeMultiple          int(11)                          not null comment '合约数量乘数',
    priceTick               decimal(22, 8)                   not null comment '最小变动价位',
    createDate              varchar(10)                      not null comment '创建日',
    openDate                varchar(10)                      not null comment '上市日',
    expireDate              varchar(10)                               comment '到期日',
    startDelivDate          varchar(10)                               comment '开始交割日',
    endDelivDate            varchar(10)                               comment '结束交割日',
    instLifePhase           varchar(32)                      not null comment '合约生命周期状态(合约生命周期状态类型数据字典)',
    isTrading               int(11)                          not null comment '当前是否交易',
    positionType            varchar(8)                       not null comment '持仓类型(持仓类型数据字典)',
    positionDateType        varchar(8)                       not null comment '持仓日期类型(持仓日期类型数据字典)',
    longMarginRatio         decimal(22, 8)                   not null comment '多头保证金率',
    shortMarginRatio        decimal(22, 8)                   not null comment '空头保证金率',
    maxMarginSideAlgorithm  varchar(8)                       not null comment '是否使用大额单边保证金算法(大额单边保证金算法类型数据字典)',
    underlyingInstrID       varchar(32)                               comment '基础商品代码',
    strikePrice             decimal(22, 8)                   not null comment '执行价',
    optionsType             varchar(8)                                comment '期权类型(期权类型类型数据字典)',
    underlyingMultiple      decimal(22, 8)                   not null comment '合约基础商品乘数',
    combinationType         varchar(8)                       not null comment '组合类型(组合类型数据字典)',
    enableStatus            varchar(16)    default 'disable' not null comment '启用状态(启用enable、不启用disable)',
    unique index (`exchangeID`, `instrumentID`, `productClass`)
) comment '外盘现货交易所合约表';

drop table if exists WpSpotDepthMarketData;
create table WpSpotDepthMarketData
(
    id                   bigint                         not null comment '主键' primary key,
    tradingDay           varchar(10)                             comment '交易日',
    instrumentID         varchar(32)                    not null comment '合约代码',
    exchangeID           varchar(10)                    not null comment '交易所代码',
    exchangeInstID       varchar(32)                             comment '合约在交易所的代码',
    lastPrice            decimal(22, 8)                 not null comment '最新价',
    preSettlementPrice   decimal(22, 8)                 not null comment '上次结算价',
    preClosePrice        decimal(22, 8)                 not null comment '昨收盘',
    preOpenInterest      decimal(22, 8)                 not null comment '昨持仓量',
    openPrice            decimal(22, 8)                 not null comment '今开盘价',
    highestPrice         decimal(22, 8)                 not null comment '最高价',
    lowestPrice          decimal(22, 8)                 not null comment '最低价',
    volume               decimal(22, 8)                 not null comment '成交数量',
    turnover             decimal(22, 8)                 not null comment '成交金额',
    openInterest         decimal(22, 8)                 not null comment '持仓量',
    closePrice           decimal(22, 8)                 not null comment '今收盘',
    settlementPrice      decimal(22, 8)                 not null comment '本次结算价',
    upperLimitPrice      decimal(22, 8)                 not null comment '涨停板价',
    lowerLimitPrice      decimal(22, 8)                 not null comment '跌停板价',
    preDelta             decimal(22, 8)                 not null comment '昨虚实度',
    currDelta            decimal(22, 8)                 not null comment '今虚实度',
    updateTime           varchar(10)                    not null comment '最后修改时间',
    updateMillisec       int(11)                        not null comment '最后修改毫秒',
    bidPrice1            decimal(22, 8)                 not null comment '申买价一',
    bidVolume1           decimal(22, 8)                 not null comment '申买量一',
    askPrice1            decimal(22, 8)                 not null comment '申卖价一',
    askVolume1           decimal(22, 8)                 not null comment '申卖量一',
    bidPrice2            decimal(22, 8)                 not null comment '申买价二',
    bidVolume2           decimal(22, 8)                 not null comment '申买量二',
    askPrice2            decimal(22, 8)                 not null comment '申卖价二',
    askVolume2           decimal(22, 8)                 not null comment '申卖量二',
    bidPrice3            decimal(22, 8)                 not null comment '申买价三',
    bidVolume3           decimal(22, 8)                 not null comment '申买量三',
    askPrice3            decimal(22, 8)                 not null comment '申卖价三',
    askVolume3           decimal(22, 8)                 not null comment '申卖量三',
    bidPrice4            decimal(22, 8)                 not null comment '申买价四',
    bidVolume4           decimal(22, 8)                 not null comment '申买量四',
    askPrice4            decimal(22, 8)                 not null comment '申卖价四',
    askVolume4           decimal(22, 8)                 not null comment '申卖量四',
    bidPrice5            decimal(22, 8)                 not null comment '申买价五',
    bidVolume5           decimal(22, 8)                 not null comment '申买量五',
    askPrice5            decimal(22, 8)                 not null comment '申卖价五',
    askVolume5           decimal(22, 8)                 not null comment '申卖量五',
    averagePrice         decimal(22, 8)                 not null comment '当日均价',
    actionDay            varchar(10)                    not null comment '业务日期',
    changeReason         varchar(16) default 'entrust'  not null comment '行情变动原因(委托盘口entrust、撮和成交trade)',
    lastVolume           decimal(22, 8)                 not null comment '最新成交量',
    longUpdateTime       bigint(13)                     not null comment '行情更新时间'
) comment '外盘现货深度行情表';

drop table if exists WpSpotExchangeTradeDay;
create table WpSpotExchangeTradeDay
(
    id                      bigint                        not null comment '主键' primary key,
    exchangeID              varchar(10)                   not null comment '交易所代码',
    productClass            varchar(32)                   not null comment '产品类型',
    weekNum                 int                           not null comment '星期几(1~7)',
    isTradeDay              int                           not null comment '是否交易日(1交易日、0非交易日)',
    tradeDayTime            bigint(13)                    not null comment '交易日零点时间戳',
    tradeDayOpenTime        bigint(13)                    not null comment '交易日开盘时间戳',
    tradeDayCloseTime       bigint(13)                    not null comment '交易日收盘时间戳',
    unique index (`exchangeID`, `productClass`, `tradeDayTime`, `tradeDayOpenTime`)
) comment '外盘现货交易所交易日表';
