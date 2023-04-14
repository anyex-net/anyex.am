### 阅前须知
* 此为易盛内盘,行情与交易同账号
* 默认AccountNo: Q578432149; [内盘模拟账户注册地址](http://jsform3.com/web/formview/5ed9a12efc918f7ce73080dc)
* http参数：参数前加 * 表示此参数必填; 未加可不传,具体情况看后面说明
* 接口：如无特殊说明，皆是用 GET

#### 外盘与内盘的区别
- 没有币种查询;
- 没有持仓汇总信息; 外盘平仓不生成成交记录，内盘反之
- 新增平仓查询;
##


### 一、行情指令
**品种（CommodityNo）全部大写；合约（ContractNo）：除郑商所（ZCE）3个数字（如：111），其它交易所都是四个数字（如：2109)**
### 1、行情订阅
1. 编号：3 （q_subscribeQuote
2. 接口：SubscribeQuote
3. http接口：SubscribeQuoteWhole
4. http参数：*AccountNo,*ExchangeNo,*CommodityNo,*ContractNo
    {"AccountNo",   "Q578432149"},
    {"ExchangeNo",   "DCE"},
    {"CommodityNo",   "M"},
    {"ContractNo",   "2112"}
5. 应答：OnRspSubscribeQuote （TapAPIQuoteWhole)
6. 通知：OnRtnQuote 行情实时推送 （TapAPIQuoteWhole)
7. topic：NpTopicSubscribeQuoteWhole

### 2、取消订阅
1. 编号：4 （q_unSubscribeQuote
2. 接口：UnSubscribeQuote
3. http接口：UnSubscribeQuoteWhole
4. http参数：*AccountNo,*ExchangeNo,*CommodityNo,*ContractNo
    {"AccountNo",   "Q578432149"},
    {"ExchangeNo",   "DCE"},
    {"CommodityNo",   "M"},
    {"ContractNo",   "2112"}
5. 应答：OnRspUnSubscribeQuote （TapAPIContract）
topic：NpTopicUnSubscribeQuoteWhole



### 二、交易指令
### 2.1 交易相关操作
### 下单（买入卖出）：
1. 编号：11	(t_insertOrder)
2. 接口：InsertOrder
3. http接口：InsertOrder （**POST**）
4. http参数：
    *AccountNo      
    *ExchangeNo       
    *CommodityNo  
    *ContractNo 
    *OrderType   // 市价:'1';限价:'2';市价止损:'3';限价止损:'4';市价止盈:'C';限价止盈:'D'
    *TimeInForce   // 当日有效:'0';取消前有效:'1';指定日期前有效:'2';FAK或IOC:'3';FOK:'4'
    ExpireTime  // 有效日期(GTD情况下使用)yyyy-MM-dd \
    *OrderSide   
    *PositionEffect // 开平类型 开仓:'O'；平仓:'C'；平当日:'T' **注意：上期和能源平仓使用 'T'** \
    *OrderPrice  
    *OrderQty    
    RefString  // 预留字符串；功能在开发中，随意填写（请不要输入中文，会乱码）
5. topic: TopicOrderInfo
5. 通知(用户委托成交后触发)：
     1. OnRtnFund 用户资金变化通知，实时推送 (TapAPIFundData)
     2. OnRtnOrder 新委托通知、委托变化通知 (TapAPIOrderInfoNotice)
     3. OnRtnFill 成交信息通知 （TapAPIFillInfo）
     4. OnRtnPosition 持仓变化推送通知 （TapAPIPositionInfo）
     5. OnRtnClose 平仓变化推送通知 (TapAPICloseInfo)
     6. OnRtnPositionProfit 持仓盈亏变化通知，实时推送 （TapAPIPositionProfitNotice）
6. topic：NpTopicFundData、NpTopicOrderInfo、NpTopicFillInfo、NpTopicPositionInfo、NpTopicCloseInfo、NpTopicPositionInfo


### 撤单：
1. 编号：12 （t_canncelOrder）
2. 接口：CancelOrder
3. http接口：CancelOrder （**POST**）
4. http参数：*AccountNo;*OrderNo
5. 通知：OnRtnOrder 新委托通知、委托变化通知 (TapAPIOrderInfoNotice)
6. topic: NpTopicOrderInfo



### 2.2 查询用户交易信息
### 查询委托订单：
1. 编号：51	(t_qryOrder)
2. 接口：QryOrder（该接口可以多次调用，但是查询频率的要求，没两秒可以查询一次）
3. http接口：QryOrderInfo
4. http参数：*AccountNo;*OrderQryType('A': 返回所有委托; 'U': 只返回未结束的委托)
5. 应答：OnRspQryOrder （TapAPIOrderInfo）
6. topic: NpTopicOrderInfo

### 查询成交订单：
1. 编号：53 （t_qryFill）
2. 接口：QryFill （该接口只能进行一次调用，建议初始化时调用一次，后续的通知通过OnRtnFill获得）
3. http接口：QryFillInfo
4. http参数：*AccountNo
5. 应答：OnRspQryFill （TapAPIFillInfo）
6. topic: NpTopicFillInfo

### 查询持仓订单：
1. 编号：54 （t_qryPosition）
2. 接口：QryPosition （该接口可以多次调用，但是查询频率的要求，每两秒可以查询一次）
3. http接口：QryPositionInfo
4. http参数：*AccountNo
5. 应答：OnRspQryPosition （TapAPIPositionInfo）
6. topic: NpTopicPositionInfo

### 查询平仓
1. 编号：55 （t_qryClose）
2. 接口：QryClose （该接口只能进行一次调用，建议初始化时调用一次，后续的通知通过OnRtnClose获得）
3. http接口：QryCloseInfo
4. http参数：*AccountNo
5. 应答：OnRspQryClose (TapAPICloseInfo)
6. topic: NpTopicCloseInfo


### 2.3 查询用户资金账号
### 账户信息：
1. 编号：42 （t_qryAccount）
2. 接口：QryAccount
3. http接口：QryAccountInfo
4. http参数：*AccountNo
5. 应答：OnRspQryAccount (TapAPIAccountInfo)
6. topic: NpTopicQryAccountInfo

### 账户的资金信息：
1. 编号：42 （t_qryFund）
2. 接口：QryFund （该接口只能进行一次调用，建议初始化时调用一次，后续的通知通过OnRtnFund获得）
3. http接口：QryFundData
4. http参数：*AccountNo
5. 应答：OnRspQryFund (TapAPIFundData)
6. topic: TopicFundData



### 2.4 获取基本信息
### 查询交易所信息
1. 编号：32 （t_qryExchange）
2. 接口：QryExchange
3. http接口：QryExchangeInfo
4. http参数：*AccountNo
5. 应答：OnRspQryExchange （TapAPIExchangeInfo）
6. topic: NpTopicQryExchangeInfo

### 查询品种信息
1. 编号：34 （t_qryCommodity）
2. 接口：QryCommodity
3. http接口：QryCommodityInfo
4. http参数：*AccountNo
5. 应答：OnRspQryCommodity （TapAPICommodityInfo）
6. topic: NpTopicQryCommodityInfo

### 查询合约信息
1. 编号：35 （t_qryContract）
2. 接口：QryContract
3. http接口：QryContractInfo
4. http参数：*AccountNo;ExchangeNo;CommodityNo;CommodityType (**1. 全部留空：查所有合约 2.仅交易所编码有效：查该交易所下所有品种的合约
                                                                3.交易所编码和品种类型有效：查该交易所下指定品种类型的合约 4.交易所编码、品种类型和品种编码都有效：查该品种下的所有合约**)
5. 应答：OnRspQryContract （TapAPITradeContractInfo）
6. topic: NpTopicQryContractInfo
