#####切换stp系统
* 主题: ctp主题前加上Stp(如:StpTopicDepthMarketData)
* 查询产品与持仓明细不可用
* 下单参数CombOffsetFlag、CombHedgeFlag,stp不做要求
* 撤单新增参数 ExchangeID




##############################行情
#####订阅行情 （IF2103, rb2105, a2107, CF103, sc2105）
编号：1	(subscribeMarketData)
接口：SubscribeMarketData
http请求接口：SubscribeMarketData
http请求参数：
    key: InvestorID        value: 183110
    key: ppInstrumentID    value: IF2106,rb2107
应答：OnRspSubMarketData （CThostFtdcSpecificInstrumentField CThostFtdcRspInfoField）
应答主题：TopicSubscribeMarketData
通知：OnRtnDepthMarketData 行情详情通知 （CThostFtdcDepthMarketDataField）
通知主题:：TopicDepthMarketData

#####取消行情
编号：2	(unSubscribeMarketData)
接口：OnRspUnSubMarketData （CThostFtdcSpecificInstrumentField CThostFtdcRspInfoField）
http请求接口：OnRspUnSubMarketData
http请求参数：
    key: InvestorID        value: 183110
    key: ppInstrumentID    value: IF2106,rb2107
主题：TopicUnSubscribeMarketData

#####退出登录 行情登出问题尚未解决，接口不通
编号：6 (reqUserLogout)
接口：ReqUserLogout
http请求参数：
http请求接口：ReqUserLogout



##############################交易
#####报单 （开仓、平仓）
######## 调用函数ReqOrderInsert报单后，如果在CTP端验资验仓等通不过，则客户端会回调函数OnRspOrderInsert（主题：TopicInputOrder TopicRspInfo）和OnErrRtnOrderInsert（主题：TopicInputOrder TopicRspInfo）；
######## 如果通过则先回调一次OnRtnOrder（主题：TopicOrder）
######## CTP再将报单报往交易所，如果交易所验资验仓没通过将返回错误给CTP，此时客户端会回调OnRtnOrder（主题：TopicOrder）；如果交易所检查正确则此时也会再次回调OnRtnOrder（主题：TopicOrder）
编号：1  （reqOrderInsert）
接口：ReqOrderInsert
http请求接口：ReqOrderInsert (Post)
http请求参数：
{
    "InvestorID" : "183110",    // 投资者ID
    "ExchangeID" : "SHFE",  // 交易所ID 全部大写 CFFEX、CZCE、DCE、INE、SHFE
    "InstrumentID" : "sc2106",  // 合约ID
    "Direction" : '0',      // 买卖方向(0->buy 1->sell)
    "OrderPriceType" : '2'  // 报单价格条件(1->市价 2->限价) (SimNow不支持市价单(即报单价格类型为THOST_FTDC_OPT_AnyPrice任意价)，
                                实盘里面，部分交易所如上期所和能源中心也不支持市价单，中金所部分合约也不能用市价类型下单)
    "LimitPrice" : ,    // 限价单时需要填写，否则不传，注意价格要是最小报价单位（查询合约可得）的整数倍
    "VolumeTotalOriginal" : 1,  // 数量
    "CombOffsetFlag" : 0    // 组合开平标志(0->开仓 1->平仓/平昨 3->平今) 除了上期所/能源中心外，不区分平今平昨，平仓统一使用 1
    "CombHedgeFlag" : "1"   // 组合投机套保标志 (1->投机 2->套利 3->套保 5->做市商 6->第一腿投机第二腿套保 大商所专用
                                                7->第一腿套保第二腿投机  大商所专用)
    "OrderRef" : "" // 可不填，由系统自动填写；用户填写，必须保持递增                                            
}
应答：OnRspOrderInsert （ReqOrderInsert有字段填写不对）（CThostFtdcInputOrderField CThostFtdcRspInfoField）、
     OnErrRtnOrderInsert（CTP柜台报错）（CThostFtdcInputOrderField CThostFtdcRspInfoField）
报单应答主题：TopicInputOrder
通知：OnRtnOrder 报单状态变化（未成交、撤单）、交易所拒单通知 （CThostFtdcOrderField）
     OnRtnTrade 报单成交通知 (CThostFtdcTradeField)
报单通知主题：TopicOrder TopicTrade

#####撤单
######## 客户通过ReqOrderAction指令申请撤单，如果通过CTP端检查则返回第1个OnRtnOrder（主题：TopicOrder）回报，
######## 如果不通过则返回OnRspOrderAction（主题：TopicInputOrderAction TopicRspInfo）和OnErrRtnOrderAction（主题：TopicOrderAction TopicRspInfo） 回报；
######## 通过后报入交易所，交易所端检查通过，CTP返回第2个OnRtnOrde（主题：TopicOrder）回报，如果不通过则返回OnErrRtnOrderAction（主题：TopicOrderAction TopicRspInfo）回报
编号：2  （reqOrderAction）
接口：ReqOrderAction
http请求接口：ReqOrderAction (Post)
http请求参数：
{
    "InvestorID" : "183110",    // 投资者ID
    "FrontID" : "", // 前置ID
    "OrderRef" : ,  // 报单引用，是本地会话全局唯一编号，必须保持递增；
                    可由用户维护，也可由系统自动填写，系统填写是右对齐的，撤单填写时必须和CTP返回的一致
                    （例如，按头文件，OrderRef有效位为12个字节。如果CTP返回的OrderSysID为“           5”，
                    该字符串一共有12个字节，前面11个为空格，撤单时也要原样右对齐填写）
    "InstrumentID" : ,  // 合约ID
    "SessionID" : , // 会话ID
    "ExchangeID" // Stp 必填
}
应答：OnRspOrderAction（CThostFtdcInputOrderActionField CThostFtdcRspInfoField）、
     OnErrRtnOrderAction（CTP柜台报错）（CThostFtdcOrderActionField CThostFtdcRspInfoField）
撤单应答主题：TopicInputOrderAction TopicOrderAction
通知：OnRtnOrder 报单状态变化（撤单）、交易所拒单通知 (CThostFtdcOrderField)
撤单通知主题：TopicOrder

#####查询报单
编号：3  （reqQryOrder）
接口：ReqQryOrder
http请求接口：ReqQryOrder
http请求参数：key: InvestorID    value: 183110
应答：OnRspQryOrder （CThostFtdcOrderField CThostFtdcRspInfoField）
应答主题：TopicOrder

#####查询成交
编号：4  （reqQryTrade）
接口：reqQryTrade
http请求接口：ReqQryTrade
http请求参数：key: InvestorID    value: 183110
应答：OnRspQryTrade （CThostFtdcTradeField CThostFtdcRspInfoField)
应答主题：TopicTrade

#####查询持仓
编号：5  （reqQryInvestorPosition）
接口：ReqQryInvestorPosition
http请求接口：ReqQryInvestorPosition
http请求参数：key: InvestorID    value: 183110
应答：OnRspQryInvestorPosition（CThostFtdcInvestorPositionField CThostFtdcRspInfoField）
应答主题：TopicInvestorPosition

#####请求查询投资者持仓明细
编号：12 （reqQryInvestorPositionDetail）
接口：reqQryInvestorPositionDetail
http请求接口：ReqQryInvestorPositionDetail
http请求参数：key: InvestorID    value: 183110
            key: InstrumentID    value: au2108（查某个合约的持仓明细） 
应答：OnRspQryInvestorPositionDetail （包含平仓记录）（CThostFtdcInvestorPositionDetailField CThostFtdcRspInfoField）
应答主题：TopicInvestorPositionDetail





#####请求查询交易所，可按交易所查询
编号：11 （reqQryExchange）
接口：ReqQryExchange
http请求接口：ReqQryExchange
http请求参数：key: InvestorID    value: 183110
            key: ExchangeID （可不传）   value: SHFE 
应答：OnRspQryExchange （CThostFtdcExchangeField CThostFtdcRspInfoField）
应答主题：TopicExchange

#####请求查询所有产品
编号：18 （reqQryProduct）
接口：ReqQryProduct
http请求接口：ReqQryProduct
http请求参数：key: InvestorID（必填）    value: 183110
            key: ProductID（可不传）    value: ag
            key: ExchangeID（可不传）    value: SHFE（ProductID,ExchangeID同时填写）
应答：OnRspQryProduct（CThostFtdcProductField CThostFtdcRspInfoField）
应答主题：TopicProduct

#####请求查询所有合约
编号：7  （reqQueryInstrument）
接口：ReqQryInstrument
http请求接口：ReqQryInstrument
http请求参数：key: InvestorID（必填）   value: 183110
            key: InstrumentID（可不传）   value: rb2107 
            key: ExchangeID （可不传）  value: SHFE （InstrumentID,ExchangeID都为空，查询所有合约信息
            只填InstrumentID，只查询该合约;只填ExchangeID,查询交易所下的所有合约信息）
应答：OnRspQryInstrument （CThostFtdcInstrumentField CThostFtdcRspInfoField）
应答主题：TopicInstrument

#####请求查询资金帐户
编号：10 （reqQueryTradingAccount）
接口：ReqQryTradingAccount
http请求接口：ReqQryTradingAccount
http请求参数：key: InvestorID    value: 183110
应答：OnRspQryTradingAccount （CThostFtdcTradingAccountField CThostFtdcRspInfoField）
应答主题：TopicTradingAccount






########################################################################
#####查询合约保证金率 用于实际交易中冻结和占用的计算
编号：6  （reqQryInstrumentMarginRate）
接口：ReqQryInstrumentMarginRate
http请求接口：ReqQryInstrumentMarginRate
http请求参数：key: InvestorID（必填）   value: 183110
            key: HedgeFlag（必填）   value: 1 (投机套保标志类型 1->投机 2->套利 3->套保)
            key: InstrumentID（可不传）   value: rb2107 (如果InstrumentID填空，则返回客户当前持仓对应的合约保证金率，否则返回相应InstrumentID的保证金率)
应答：OnRspQryInstrumentMarginRate (CThostFtdcInstrumentMarginRateField CThostFtdcRspInfoField)
topic: TopicInstrumentMarginRate

#####查询合约手续费率 这里返回的InvestorID为00000000代表投资者通用的费率
编号：8  （reqQryInstrumentCommissionRate）
接口：ReqQryInstrumentCommissionRate
http请求接口：ReqQryInstrumentCommissionRate
http请求参数：key: InvestorID（必填）   value: 183110
            key: InstrumentID（可不传）   value: rb2107 (如果InstrumentID填空，则返回客户当前持仓对应的手续费率，否则返回相应InstrumentID的手续费率)
应答：OnRspQryInstrumentCommissionRate (CThostFtdcInstrumentCommissionRateField CThostFtdcRspInfoField)
topic: TopicInstrumentCommissionRate

#####查询报单申报手续费（就是每报撤一次单子都会收一笔费用），目前来说这是中金所特有的 这里返回的InvestorID为00000000代表投资者通用的费率
编号：9  （reqQryInstrumentOrderCommRate）
接口：ReqQryInstrumentOrderCommRate
http请求接口：ReqQryInstrumentOrderCommRate
http请求参数：key: InvestorID（必填）   value: 183110
            key: InstrumentID（可不传）   value: rb2107 (如果InstrumentID填空，则返回客户当前持仓对应的手续费率，否则返回相应InstrumentID的手续费率)
应答：OnRspQryInstrumentOrderCommRate (CThostFtdcInstrumentOrderCommRateField CThostFtdcRspInfoField)
topic: TopicInstrumentOrderCommRate

#####查询经纪公司交易参数
编号：9  （reqQryBrokerTradingParams）
接口：ReqQryBrokerTradingParams
http请求接口：ReqQryBrokerTradingParams
http请求参数：key: InvestorID（必填）   value: 183110
应答：OnRspQryBrokerTradingParams (CThostFtdcBrokerTradingParamsField CThostFtdcRspInfoField)
topic: TopicBrokerTradingParams




#####请求查询行情
编号：16 （reqQryDepthMarketData）
接口：ReqQryDepthMarketData
http请求接口：ReqQryDepthMarketData
http请求参数：key: InvestorID（必填）   value: 183110
            key: InstrumentID（必填）  value: rb2107
应答：OnRspQryDepthMarketData (CThostFtdcDepthMarketDataField CThostFtdcRspInfoField)
topic: TopicTradeDepthMarketData

#####请求查询投资者结算结果 返回前一日的结算结果 可以按要求查某天、月的结算单
编号：17 （reqQrySettlementInfo）
接口：ReqQrySettlementInfo
http请求接口：ReqQrySettlementInfo
http请求参数：key: InvestorID（必填）   value: 183110
            key: TradingDay （可不传） value: 查询某一天的结算单，填写格式为"yyyymmdd"，查询某一月的结算单，填写格式为"yyyymm"；
                                            前提是系统生成了日（月）结算单，否则返回为空，不传返回前一日的结算结果
应答：OnRspQrySettlementInfo (CThostFtdcSettlementInfoField CThostFtdcRspInfoField)
topic: TopicSettlementInfo

#####投资者结果确认 登录成功后必须调用，若未调用，执行交易时报错 value="42" prompt="CTP:结算结果未确认"
编号：26 （reqSettlementInfoConfirm）
接口：ReqQrySettlementInfo
http请求接口：ReqSettlementInfoConfirm
http请求参数：key: InvestorID（必填）   value: 183110
应答：OnRspQrySettlementInfo (CThostFtdcSettlementInfoConfirmField CThostFtdcRspInfoField)
topic: TopicSettlementInfoConfirm

#####查询结算信息确认 查看是否调用确认，若无，返回空
编号：27 （reqQrySettlementInfoConfirm）
接口：ReqQrySettlementInfo
http请求接口：ReqQrySettlementInfoConfirm
http请求参数：key: InvestorID（必填）   value: 183110
应答：OnRspQrySettlementInfo (CThostFtdcSettlementInfoConfirmField CThostFtdcRspInfoField)
topic: TopicSettlementInfoConfirm