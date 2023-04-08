/*
CREATE DATABASE amnpspot;
use amnpspot;
*/

drop table if exists StpNpSpotBroker;
create table StpNpSpotBroker
(
    id              bigint       not null comment '主键' primary key,
    brokerID        varchar(10)  not null comment '经纪公司代码',
    brokerAbbr      varchar(10)  not null comment '经纪公司简称',
    brokerName      varchar(82)  not null comment '经纪公司名称',
    brokerDomain    varchar(255) not null comment '经纪公司域名',
    unique index (`brokerID`)
) comment '内盘现货经纪商信息表';

drop table if exists StpNpSpotExchangeTradeDay;
create table StpNpSpotExchangeTradeDay
(
    id                      bigint                        not null comment '主键' primary key,
    exchangeID              varchar(10)                   not null comment '交易所代码',
    productID               varchar(32)                   not null comment '产品代码',
    weekNum                 int                           not null comment '星期几(1~7)',
    isTradeDay              int                           not null comment '是否交易日(1交易日、0非交易日)',
    tradeDayTime            bigint(13)                    not null comment '交易日零点时间戳',
    tradeDayOpenTime        bigint(13)                    not null comment '交易日开盘时间戳',
    tradeDayCloseTime       bigint(13)                    not null comment '交易日收盘时间戳',
    unique index (`exchangeID`, `productID`, `tradeDayTime`, `tradeDayOpenTime`)
) comment '内盘现货交易所交易日表';

drop table if exists StpNpSpotExchange;
create table StpNpSpotExchange
(
    id                      bigint                       	not null comment '主键' primary key,
    exchangeID              char                   		 	not null comment '交易所代码',
    exchangeName            varchar(62)                  	not null comment '交易所名称',
    tradingDay              varchar(10)                  	not null comment '交易日',
    dataSyncStatus          char                         	not null comment '数据同步状态',
    enableStatus      		varchar(16)	default 'disable'	not null comment '启用状态(启用enable、不启用disable)',
    unique index (`exchangeID`)
) comment '内盘现货交易所表';

drop table if exists StpNpSpotSecurity;
create table StpNpSpotSecurity
(
    id                                  bigint                  		not null comment '主键' primary key,
    tradingDay                          varchar(10)             		not null comment '交易日',
    exchangeID                          char                    		not null comment '交易所代码',
    securityID                          varchar(32)             		not null comment '证券代码',
    securityName                        varchar(82)             		not null comment '证券名称',
    shortSecurityName                   varchar(82)             		not null comment '证券名称(短)',
    underlyingSecurityID                varchar(32)             		not null comment '基础证券代码',
    marketID                            char                    		not null comment '市场代码',
    productID                           char                    		not null comment '产品代码',
    securityType                        char                    		not null comment '证券类别',
    orderUnit                           char                    		not null comment '申报单位',
    limitBuyTradingUnit                 int(11)                 		not null comment '限价买入交易单位',
    maxLimitOrderBuyVolume              int(11)                 		not null comment '限价单买最大下单量',
    minLimitOrderBuyVolume              int(11)                 		not null comment '限价单买最小下单量',
    limitSellTradingUnit                int(11)                 		not null comment '限价卖出交易单位',
    maxLimitOrderSellVolume             int(11)                 		not null comment '限价单卖最大下单量',
    minLimitOrderSellVolume             int(11)                 		not null comment '限价单卖最小下单量',
    marketBuyTradingUnit                int(11)                 		not null comment '市价买入交易单位',
    maxMarketOrderBuyVolume             int(11)                 		not null comment '市价单买最大下单量',
    minMarketOrderBuyVolume             int(11)                 		not null comment '市价单买最小下单量',
    marketSellTradingUnit               int(11)                 		not null comment '市价卖出交易单位',
    maxMarketOrderSellVolume            int(11)                 		not null comment '市价单卖最大下单量',
    minMarketOrderSellVolume            int(11)                 		not null comment '市价单卖最小下单量',
    fixPriceBuyTradingUnit              int(11)                 		not null comment '盘后定价买入交易单位',
    maxFixPriceOrderBuyVolume           int(11)                 		not null comment '盘后定价买最大下单量',
    minFixPriceOrderBuyVolume           int(11)                 		not null comment '盘后定价买最小下单量',
    fixPriceSellTradingUnit             int(11)                 		not null comment '盘后定价卖出交易单位',
    maxFixPriceOrderSellVolume          int(11)                 		not null comment '盘后定价卖最大下单量',
    minFixPriceOrderSellVolume          int(11)                 		not null comment '盘后定价卖最小下单量',
    volumeMultiple                      int(11)                 		not null comment '数量乘数',
    priceTick                           decimal(22, 8)          		not null comment '最小变动价位',
    openDate                            varchar(10)             		not null comment '上市日',
    parValue                            decimal(22, 8)          		not null comment '面值',
    securityStatus                      bigint(20)              		not null comment '证券状态',
    bondInterest                        decimal(22, 8)          		not null comment '债券应计利息',
    conversionRate                      decimal(22, 8)          		not null comment '折算率',
    totalEquity                         decimal(22, 8)          		not null comment '总股本',
    circulationEquity                   decimal(22, 8)          		not null comment '流通股本',
    bPriceLimit                         int(11)                 		not null comment '是否限制涨跌停板价',
    preClosePrice                       decimal(22, 8)          		not null comment '昨收盘价',
    upperLimitPrice                     decimal(22, 8)          		not null comment '涨停板价',
    lowerLimitPrice                     decimal(22, 8)          		not null comment '跌停板价',
    enableStatus      					varchar(16) default 'disable'	not null comment '启用状态(启用enable、不启用disable)',
    unique index (`exchangeID`, `securityID`)
) comment '内盘现货证券信息表';

drop table if exists StpNpSpotTradingFee;
create table StpNpSpotTradingFee
(
    id                      bigint                   not null comment '主键' primary key,
    exchangeID              char                     not null comment '交易所代码',
    productID               char                     not null comment '产品代码',
    securityType            char                     not null comment '证券类别代码',
    securityID              varchar(32)              not null comment '证券代码',
    bizClass                char                     not null comment '业务类别',
    stampTaxRatioByAmt      decimal(22, 8) default 0 not null comment '印花税(港股印花税)按金额收取比例',
    stampTaxRatioByPar      decimal(22, 8) default 0 not null comment '印花税(港股印花税)按面值收取比例',
    stampTaxFeePerOrder     decimal(22, 8) default 0 not null comment '印花税(港股印花税,单位港币)按笔收取金额',
    stampTaxFeeByVolume     decimal(22, 8) default 0 not null comment '印花税(港股印花税,单位港币)按数量收取金额',
    stampTaxFeeMin          decimal(22, 8) default 0 not null comment '印花税(港股印花税,单位港币)最低收取金额',
    stampTaxFeeMax          decimal(22, 8) default 0 not null comment '印花税(港股印花税,单位港币)最高收取金额',
    transferRatioByAmt      decimal(22, 8) default 0 not null comment '过户费(港股证券组合费)按金额收取比例',
    transferRatioByPar      decimal(22, 8) default 0 not null comment '过户费(港股证券组合费)按面值收取比例',
    transferFeePerOrder     decimal(22, 8) default 0 not null comment '过户费(港股证券组合费,单位港币)按笔收取金额',
    transferFeeByVolume     decimal(22, 8) default 0 not null comment '过户费(港股证券组合费,单位港币)按数量收取金额',
    transferFeeMin          decimal(22, 8) default 0 not null comment '过户费(港股证券组合费,单位港币)最低收取金额',
    transferFeeMax          decimal(22, 8) default 0 not null comment '过户费(港股证券组合费,单位港币)最高收取金额',
    handlingRatioByAmt      decimal(22, 8) default 0 not null comment '经手费(港股交易费)按金额收取比例',
    handlingRatioByPar      decimal(22, 8) default 0 not null comment '经手费(港股交易费)按面值收取比例',
    handlingFeePerOrder     decimal(22, 8) default 0 not null comment '经手费(港股交易费,单位港币)按笔收取金额',
    handlingFeeByVolume     decimal(22, 8) default 0 not null comment '经手费(港股交易费,单位港币)按数量收取金额',
    handlingFeeMin          decimal(22, 8) default 0 not null comment '经手费(港股交易费,单位港币)最低收取金额',
    handlingFeeMax          decimal(22, 8) default 0 not null comment '经手费(港股交易费,单位港币)最高收取金额',
    regulateRatioByAmt      decimal(22, 8) default 0 not null comment '证管费(港股交易征费)按金额收取比例',
    regulateRatioByPar      decimal(22, 8) default 0 not null comment '证管费(港股交易征费)按面值收取比例',
    regulateFeePerOrder     decimal(22, 8) default 0 not null comment '证管费(港股交易征费,单位港币)按笔收取金额',
    regulateFeeByVolume     decimal(22, 8) default 0 not null comment '证管费(港股交易征费,单位港币)按数量收取金额',
    regulateFeeMin          decimal(22, 8) default 0 not null comment '证管费(港股交易征费,单位港币)最低收取金额',
    RegulateFeeMax          decimal(22, 8) default 0 not null comment '证管费(港股交易征费,单位港币)最高收取金额',
    settlementRatioByAmt    decimal(22, 8) default 0 not null comment '结算费(港股股份交收费)按金额收取比例',
    settlementRatioByPar    decimal(22, 8) default 0 not null comment '结算费(港股股份交收费)按面值收取比例',
    settlementFeePerOrder   decimal(22, 8) default 0 not null comment '结算费(港股股份交收费,单位港币)按笔收取金额',
    settlementFeeByVolume   decimal(22, 8) default 0 not null comment '结算费(港股股份交收费,单位港币)按数量收取金额',
    settlementFeeMin        decimal(22, 8) default 0 not null comment '结算费(港股股份交收费,单位港币)最低收取金额',
    settlementFeeMax        decimal(22, 8) default 0 not null comment '结算费(港股股份交收费,单位港币)最高收取金额',
    unique index (`exchangeID`, `productID`, `securityType`, `securityID`, `bizClass`)
) comment '内盘现货基础交易费率表';

drop table if exists StpNpSpotMarketData;
create table StpNpSpotMarketData
(
    id                  bigint                         	not null comment '主键' primary key,
    tradingDay          varchar(10)                    	not null comment '交易日',
    securityID         	varchar(32)                    	not null comment '证券代码',
    exchangeID          char                        	not null comment '交易所代码',
    securityName		varchar(81)                    	not null comment '证券名称',
    preClosePrice 		decimal(22, 8)					not null comment '昨收盘价',
    openPrice 			decimal(22, 8)					not null comment '今开盘价',
    volume 				decimal(22, 8)					not null comment '成交量',
    turnover 			decimal(22, 8)					not null comment '成交额',
    tradingCount 		decimal(22, 8)					not null comment '成交笔数',
    lastPrice 			decimal(22, 8)					not null comment '最新价',
    highestPrice 		decimal(22, 8)					not null comment '最高价',
    lowestPrice 		decimal(22, 8)					not null comment '最低价',
    bidPrice1 			decimal(22, 8)					not null comment '买1价',
    askPrice1 			decimal(22, 8)					not null comment '卖1价',
    upperLimitPrice 	decimal(22, 8)					not null comment '涨停价',
    lowerLimitPrice 	decimal(22, 8)					not null comment '跌停价',
    pERatio1 			decimal(22, 8)					not null comment '市盈率1',
    pERatio2 			decimal(22, 8)					not null comment '市盈率2',
    priceUpDown1 		decimal(22, 8)					not null comment '价格升跌1',
    priceUpDown2 		decimal(22, 8)					not null comment '价格升跌2',
    openInterest 		decimal(22, 8)					not null comment '持仓量',
    bidVolume1			decimal(22, 8)					not null comment '买1量',
    askVolume1			decimal(22, 8)					not null comment '卖1量',
    bidPrice2 			decimal(22, 8)					not null comment '买2价',
    bidVolume2			decimal(22, 8)					not null comment '买2量',
    askPrice2			decimal(22, 8)					not null comment '卖2价',
    askVolume2			decimal(22, 8)					not null comment '卖2量',
    bidPrice3			decimal(22, 8)					not null comment '买3价',
    bidVolume3			decimal(22, 8)					not null comment '买3量',
    askPrice3			decimal(22, 8)					not null comment '卖3价',
    askVolume3			decimal(22, 8)					not null comment '卖3量',
    bidPrice4			decimal(22, 8)					not null comment '买4价',
    bidVolume4			decimal(22, 8)					not null comment '买4量',
    askPrice4			decimal(22, 8)					not null comment '卖4价',
    askVolume4			decimal(22, 8)					not null comment '卖4量',
    bidPrice5			decimal(22, 8)					not null comment '买5价',
    bidVolume5			decimal(22, 8)					not null comment '买5量',
    askPrice5			decimal(22, 8)					not null comment '卖5价',
    askVolume5			decimal(22, 8)					not null comment '卖5量',
    updateTime			varchar(10)						not null comment '更新时间',
    updateMillisec		int(11)							not null comment '更新毫秒',
    closePrice			decimal(22, 8)					not null comment '今收盘价',
    settlementPrice		decimal(22, 8)					not null comment '今结算价',
    mDSecurityStat		char							not null comment '行情产品实时状态',
    hWFlag				int(11)							not null comment '是否警示板块',
    preCloseIOPV		decimal(22, 8)					not null comment '基金T-1日收盘时刻净值',
    iOPV				decimal(22, 8)					not null comment '基金实时参考净值',
    changeReason        varchar(16) default 'entrust'  	not null comment '行情变动原因(委托盘口entrust、撮和成交trade)',
    lastVolume          decimal(22, 8)                 	not null comment '最新成交量',
    longUpdateTime      bigint(13)                     	not null comment '行情更新时间'
) comment '内盘现货深度行情表';

