########################行情指令
编号：3 （q_subscribeQuote）
接口：SubscribeQuote
http接口：SubscribeQuoteWhole
http参数：
{"AccountNo",   "ES"},
{"ExchangeNo",   "COMEX"},
{"CommodityNo",   "HG"},
{"ContractNo",   "2108"}
应答：OnRspSubscribeQuote （TapAPIQuoteWhole）
通知：OnRtnQuote 行情实时推送 （TapAPIQuoteWhole）
topic：TopicSubscribeQuoteWhole

编号：4 （q_unSubscribeQuote）
接口：UnSubscribeQuote
http接口：UnSubscribeQuoteWhole
http参数：
{"AccountNo",   "ES"},
{"ExchangeNo",   "COMEX"},
{"CommodityNo",   "HG"},
{"ContractNo",   "2108"}
应答：OnRspUnSubscribeQuote （TapAPIContract）
topic：TopicUnSubscribeQuoteWhole



########################交易指令
###下单（买入卖出）：
编号：11	(t_insertOrder)
接口：InsertOrder
http接口：InsertOrder （POST）
http参数：
{"AccountNo",   "RDGJ06"},
{"ExchangeNo",  "NYMEX"},
{"CommodityNo",  "CL"},
{"ContractNo",  "2105"},
{"OrderType",   "2"},
{"TimeInForce", "0"},
{"OrderSide",   "B"},
{"OrderPrice",  "71"},
{"OrderQty",    "1"},
{"RefString", "12345678"}    // 预留字符串
应答：OnRspOrderAction (TapAPIOrderActionRsp)
topic: TopicOrderInfo
通知(用户委托成交后触发)：
     1.OnRtnFund 用户资金变化通知，实时推送 (TapAPIFundData)
     2.OnRtnOrder 新委托通知、委托变化通知 (TapAPIOrderInfoNotice)
     3.OnRtnFill 成交信息通知 （TapAPIFillInfo）
     4.OnRtnPosition 持仓变化推送通知 （TapAPIPositionInfo）
     5.OnRtnPositionSummary 持仓汇总变化推送通知 （TopicPositionSummaryInfo）
     6.OnRtnPositionProfit 持仓盈亏变化通知，实时推送 （TapAPIPositionProfitNotice）
topic：TopicFundData、TopicOrderInfo、TopicFillInfo、TopicPositionInfo、TopicPositionSummaryInfo、TopicPositionInfo


###撤单：
编号：12 （t_canncelOrder）
接口：CancelOrder
http接口：CancelOrder （POST）
http参数：
{"AccountNo",   "RDGJ06"},
{"OrderNo",  ""},
应答：OnRspOrderAction (TapAPIOrderActionRsp)
topic: TopicOrderInfo
通知：OnRtnOrder 新委托通知、委托变化通知 (TapAPIOrderInfoNotice)
topic: TopicOrderInfo


###改单（暂不对接）：
编号：13 （t_modify）
接口：AmendOrder
应答：OnRspOrderAction
通知：OnRtnOrder 委托变化通知



########################获取用户交易信息
###查询委托订单：
编号：51	(t_qryOrder)
接口：QryOrder
http接口：QryOrderInfo
http参数：{"AccountNo", "RDGJ06"}
应答：OnRspQryOrder （TapAPIOrderInfo）
topic: TopicOrderInfo

###查询成交订单：
编号：53 （t_qryFill）
接口：QryFill
http接口：QryFillInfo
http参数：{"AccountNo", "RDGJ06"}
应答：OnRspQryFill （TapAPIFillInfo）
topic: TopicFillInfo

###查询持仓订单：
编号：54 （t_qryPosition）
接口：QryPosition
http接口：QryPositionInfo
http参数：{"AccountNo",   "RDGJ06"}
应答：OnRspQryPosition （TapAPIPositionInfo）
topic: TopicPositionInfo

###查询持仓汇总
编号：55 （t_qryPositionSummary）
接口：QryPositionSummary
http接口：QryPositionSummaryInfo
http参数：{"AccountNo",   "RDGJ06"}
应答：OnRspQryPositionSummary (TapAPIPositionSummary)
topic: TopicPositionSummaryInfo
通知: OnRtnPositionSummary (TapAPIPositionSummary)
topic: TopicPositionSummaryInfo

########################获取用户资金账号
###账户的资金信息：
编号：42 （t_qryFund）
接口：QryFund
http接口：QryFundData
http参数：{"AccountNo",   "RDGJ06"}
应答：OnRspQryFund (TapAPIFundData)
topic: TopicFundData
通知：OnRtnFund  用户资金变化通知，实时推送 (TapAPIFundData)
topic: TopicFundData

###账户信息：
编号：42 （t_qryAccount）
接口：QryAccount
http接口：QryAccountInfo
http参数：{"AccountNo",   "RDGJ06"}
应答：OnRspQryAccount (TapAPIAccountInfo)
topic: TopicQryAccountInfo

#########################获取客户手续费率和保证金率
###查询客户手续费计算参数：
编号：42 （t_qryAccountFeeRent）
接口：QryAccountFeeRent
http接口：QryAccountFeeRent
http参数：{"AccountNo",   "RDGJ06"}
应答：OnRspQryAccountFeeRent (TapAPIAccountFeeRentQryRsp)
topic: TopicAccountFeeRent

###查询客户保证金率计算参数：
编号：42 （t_qryAccountMarginRent）
接口：QryAccountMarginRent
http接口：QryAccountMarginRent
http参数：{"AccountNo",   "RDGJ06"}
应答：OnRspQryAccountMarginRent (TapAPIAccountMarginRentQryRsp)
topic: TopicAccountMarginRent

########################获取历史交易信息（暂不对接）
###历史委托查询请求：
编号：22 （t_qryHisOrder）
接口：QryHisOrder
应答：OnRspQryHisOrder

###历史成交查询请求：
编号：24 （t_qryHisMatch）
接口：QryHisMatch
应答：OnRspQryHisMatch

###历史持仓查询请求：
编号：25 （t_qryHisPosition）
接口：QryHisPosition
应答：OnRspQryHisPosition


########################获取基本信息
###查询系统日历（暂不对接）
编号：31 （t_qryTradingDate）
接口：QryTradingDate
应答：OnRspQryTradingDate

###查询交易所信息
编号：32 （t_qryExchange）
接口：QryExchange
http接口：QryExchangeInfo
http参数：{"AccountNo",   "RDGJ06"}
应答：OnRspQryExchange （TapAPIExchangeInfo）
topic: TopicQryExchangeInfo

###查询币种信息
编号：33 （t_qryCurrency）
接口：QryCurrency
http接口：QryCurrencyInfo
http参数：{"AccountNo",   "RDGJ06"}
应答：OnRspQryCurrency （TapAPICurrencyInfo）
topic: TopicQryCurrencyInfo

###查询品种信息
编号：34 （t_qryCommodity）
接口：QryCommodity
http接口：QryCommodity
http参数：{"AccountNo",   "RDGJ06"}
应答：OnRspQryCommodity （TapAPICommodityInfo）
topic: TopicQryExchangeCommodity

###查询合约信息
编号：35 （t_qryContract）
接口：QryContract
http接口：QryExchangeContract
http参数：
 {"AccountNo",   "RDGJ06"},
 {"ExchangeNo",  "NYMEX"}, 可为空（填写：查询指定交易所下所有合约，不填：查询所有合约）
 {"CommodityNo",  "CL"} 可为空 （ExchangeNo与CommodityNo必须同时填写，查询指定交易所指定品种下的所有合约）
应答：OnRspQryContract （TapAPITradeContractInfo）
topic: TopicQryExchangeContract