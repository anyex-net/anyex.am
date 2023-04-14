### 阅前须知
1. stp 交易与行情同账号
2. 默认账号:00318289,密码:34263091 [用户注册地址](http://n-sight.com.cn/)
3. http参数前加 * 表示必填
4. 如无特殊说明http传输方式都是 Get

### stp 特殊情况
1. 用户登录可以选择三种方式: 客户号(UserID)、资金账号(AccountID)、股东账号; 结构体中AccountID对应表中AccountNo
2. 默认股东账号 A00318289(上海A股)、700318289(深圳A股);具体信息可通过接口QrySecurity得到


## 一、行情

### 订阅行情
1. C++接口: SubscribeMarketData
2. http接口: SubscribeMarketData
3. http参数: *InvestorID;*ppSecurityID(588380,588400);*ExchangeID([交易所代码](#1exchangeid))
4. 应答: OnRspSubMarketData
5. 通知: OnRtnDepthMarketData (CTORATstpMarketDataField)
5. topic: StpTopicDepthMarketData

### 退订行情
1. C++接口: UnSubscribeMarketData
2. http接口: UnSubscribeMarketData
3. http参数: *InvestorID;*ppSecurityID(588380,588400);*ExchangeID([交易所代码](#1exchangeid)）
4. 应答: OnRspUnSubMarketData



## 二、交易

### 下单
1. C++接口: ReqOrderInsert
2. http接口: OrderInsert (**Post**)
3. http参数: 
    *InvestorID;    // 投资者代码\
    *ExchangeID;     [交易所代码](#1exchangeid)\
    *ShareholderID(股东账户代码);\
    *SecurityID(证券代码);\
    OrderRef(报单引用);\
    *Direction;         [买卖方向](#5directiontype)
    *OrderPriceType;    [报单价格条件](#6orderpricetype)
    LimitPrice(价格);\
    *Volume(数量);    // 必须是交易单位(QrySecurity可得)整数倍
    SInfo;  // 预留字符串\
    *TimeCondition  // [有效期类型](#9timecondition)
    *VolumeCondition  // [成交量类型](#10volumecondition)
4. 应答: OnRspOrderInsert (错误应答) (CTORATstpInputOrderField pRspInfo)
5. 通知: OnRtnOrder 报单状态变化（未成交、撤单）、交易所拒单通知 （CTORATstpOrderField）\
        OnRtnTrade 报单成交通知 (CTORATstpTradeField)
        OnErrRtnOrderInsert 报错错误回报 (CTORATstpInputOrderField)
6. topic: StpTopicOrder StpTopicTrade

### 撤单
1. C++接口: ReqOrderAction
2. http接口: OrderAction (**Post**)
3. http参数: 
    *InvestorID;    投资者代码\
    *ExchangeID;     [交易所代码](#1exchangeid)\
    *OrderSysID(系统报单编号)
4. 应答: OnRspOrderAction (交易系统返回的含有错误信息的撤单响应) (CTORATstpInputOrderActionField pRspInfo)
5. 通知: OnRtnOrder 报单状态变化（未成交、撤单）、交易所拒单通知 （CTORATstpOrderField）\
        OnErrRtnOrderAction (交易所会再次验证撤单指令的合法性) (CTORATstpInputOrderActionField pRspInfo)
6. topic: StpTopicOrder


### 查询订单
1. C++接口: ReqQryOrder
2. http接口: QryOrder
3. http参数: *InvestorID
4. 应答: OnRspQryOrder  (CTORATstpOrderField)
5. topic: StpTopicOrder

### 查询成交
1. C++接口: ReqQryTrade
2. http接口: QryTrade
3. http参数: *InvestorID
4. 应答: OnRspQryTrade  (CTORATstpTradeField)
5. topic: StpTopicTrade

### 查询持仓
1. C++接口: ReqQryPosition
2. http接口: QryPosition
3. http参数: *InvestorID
4. 应答: OnRspQryPosition  (CTORATstpPositionField)
5. topic: StpTopicPosition


### 查询交易所
1. C++接口: ReqQryExchange
2. http接口: QryExchange
3. http参数: *InvestorID;ExchangeID
    - 传入ExchangeID 查询具体交易所，不传查询所有
4. 应答: OnRspQryExchange  (CTORATstpExchangeField)
5. topic: StpTopicExchange

### 查询市场信息
1. C++接口: ReqQryMarket
2. http接口: QryMarket
3. http参数: *InvestorID;ExchangeID([交易所代码](#1exchangeid));MarketID([市场代码](#2marketid))
4. 应答: OnRspQryMarket  (CTORATstpMarketField)
5. topic: StpTopicMarket

### 查询证券信息
1. C++接口: ReqQrySecurity
2. http接口: QrySecurity
3. http参数: *InvestorID;ExchangeID;SecurityID(证券代码);ProductID
    - [ExchangeID交易所代码](#1exchangeid)
    - [ProductID产品代码](#3productid)
    - 不传查询所有证券信息；传入具体参数，查询具体证券信息
4. 应答: OnRspQrySecurity (CTORATstpSecurityField)
5. topic: StpTopicSecurity

### 查询股东账户
1. C++接口: ReqQryShareHolderAccount
2. http接口: QryShareHolderAccount
3. http参数: *InvestorID;ExchangeID;MarketID,ShareholderID(股东账户代码),TradingCodeClass
    - [ExchangeID交易所代码](#1exchangeid)
    - [MarketID市场代码](#2marketid)
    - [TradingCodeClass股东账户类型](#4tradingcodeclass)
    - 不传查询所有信息
4. 应答: OnRspQryShareHolderAccount (CTORATstpShareholderAccountField)
5. topic: StpTopicShareHolderAccount

### 查询资金账户
1. C++接口: ReqQryTradingAccount
2. http接口: QryTradingAccount
3. http参数: *InvestorID;ExchangeID,MarketID,TradingCodeClass
    - [ExchangeID交易所代码](#1exchangeid)
    - [MarketID市场代码](#2marketid)
    - [TradingCodeClass股东账户类型](#4tradingcodeclass)
    - 不传查询所有信息
4. 应答: OnRspQryTradingAccount (CTORATstpTradingAccountField)
5. topic: StpTopicTradingAccount

### 查询用户
1. C++接口: ReqQryUser
2. http接口: QryUser
3. http参数: *InvestorID
4. 应答: OnRspQryUser (CTORATstpUserField)
5. topic: 

### 查询投资者
1. C++接口: ReqQryInvestor
2. http接口: QryInvestor
3. http参数: *InvestorID
4. 应答: OnRspQryInvestor (CTORATstpInvestorField)
5. topic: StpTopicInvestorAccount


### 查询基础交易手续费率
1. C++接口: ReqQryTradingFee
2. http接口: QryTradingFee
3. http参数: *InvestorID,ExchangeID
4. 应答: OnRspQryTradingFee (CTORATstpTradingFeeField)
5. topic: StpTopicTradingFee

### 查询投资者手续费率
1. C++接口: ReqQryInvestorTradingFee
2. http接口: QryInvestorTradingFee
3. http参数: *InvestorID,ExchangeID
4. 应答: OnRspQryInvestorTradingFee (CTORATstpInvestorTradingFeeField)
5. topic: StpTopicInvestorTradingFee

### 查询报单资金明细
1. C++接口: ReqQryOrderFundDetail
2. http接口: QryOrderFundDetail
3. http参数: *InvestorID
4. 应答: OnRspQryOrderFundDetail (CTORATstpOrderFundDetailField)
5. topic: 

### 常用数据字典
#### 1.ExchangeID
- '0': 通用(内部使用)
- '1': 上海交易所
- '2': 深圳交易所
- '3': 香港交易所
- '4': 北京交易所
#### 2.MarketID
- '0': 通用(内部使用)
- '1': 上海A股
- '2': 深圳A股
- '3': 上海B股
- '4': 深圳B股
- '5': 深圳三版A股
- '6': 深圳三版B股
- '7': 境外市场
- '8': 深圳通港股市场
- '9': 上海通港股市场
- 'a': 北京股票
#### 3.ProductID
- '0': 通用(内部使用)
- '1': 上海股票
- '3': 上海基金
- '4': 上海债券
- '5': 上海标准债
- '6': 上海质押式回购
- '7': 深圳股票
- '9': 深圳基金
- 'a': 深圳债券
- 'b': 深圳标准债
- 'c': 深圳质押式回购
- 'd': 深圳通港股主板
- 'e': 深圳通港股创业板
- 'f': 深圳通港股扩充交易证券
- 'g': 深圳通港股NasdaqAMX市场
- 'i': 上海科创板
#### 4.TradingCodeClass
- '0': 未知
- '1': 投机
- '2': 套利
- '3': 套保
- 'a': 普通
- 'b': 信用
- 'c': 衍生品
#### 5.DirectionType
- '0': 买入
- '1': 卖出
- '2': ETF申购
- '3': ETF赎回
- '4': 新股申购
- '5': 正回购
- '6': 逆回购
- '8': 开放式基金申购
- '9': 开放式基金赎回
- 'a': 担保品划入
- 'b': 担保品划出
- 'd': 质押入库
- 'e': 质押出库
- 'f': 配股配债
- 'g': 基金拆分
- 'h': 基金合并
- 'i': 融资买入
- 'j': 融券卖出
- 'k': 卖券还款
- 'l': 买券还券
- 'm': 还券划转
- 'n': 余券划转
- 't': 债券转股
- 'u': 债券回售
- 'v': ETF实物申购
- 'w': ETF实物赎回
- 'x': 回售撤销
#### 6.OrderPriceType
- '1': 任意价(市价)
- '2': 限价
- '3': 最优价
- '8': 盘后定价
- 'G': 五档价
- 'a': 本方最优
#### 7.CombOffsetFlag
- '0': 开仓
- '1': 平仓
- '2': 强平
- '3': 平今
- '4': 平昨
- '5': 强减
- '6': 本地强平
#### 8.CombHedgeFlag
- '1': 投机
- '2': 套利
- '3': 套保
- '4': 备兑
#### 9.TimeCondition
- '1': 立即完成，否则撤销
- '2': 本节有效
- '3': 当日有效
- '4': 指定日期前有效
- '5': 撤销前有效
- '6': 集合竞价有效
#### 10.VolumeCondition
- '1': 任何数量
- '2': 最小数量
- '3': 全部数量
