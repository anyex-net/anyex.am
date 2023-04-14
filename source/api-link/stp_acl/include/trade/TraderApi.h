////
//// Created by root on 8/17/21.
////
//
//#ifndef STP_ACL_TRADEAPI_H
//#define STP_ACL_TRADEAPI_H
//
//
//#include <TORATstpTraderApi.h>
//
//class TraderApi
//{
//public:
//    TraderApi() {};
//    ~TraderApi() {};
//
//private:
//    CTORATstpTraderApi *m_pApi;
//
//public:
//    ///创建TraderApi
//    ///@param pszFlowPath 存贮订阅信息文件的目录，默认为当前目录
//    ///@param bEncrpyt 网络数据是否加密传输，默认不加密
//    ///@return 创建出的TraderApi
//    CTORATstpTraderApi *CreateTstpTraderApi(const char *pszFlowPath = "", bool bEncrypt = false);
//
//    ///获取API版本号
//    ///@return 版本号
//    const char* GetApiVersion();
//
//    ///删除接口对象本身
//    ///@remark 不再使用本接口对象时,调用该函数删除接口对象
//    void Release();
//
//    ///初始化
//    ///@remark 初始化运行环境,只有调用后,接口才开始工作
//    void Init();
//
//    ///等待接口线程结束运行
//    ///@return 线程退出代码
//    int Join();
//
//    ///注册前置机网络地址
//    ///@param pszFrontAddress：前置机网络地址。
//    ///@remark 网络地址的格式为：“protocol://ipaddress:port”，如：”tcp://127.0.0.1:17001”。
//    ///@remark “tcp”代表传输协议，“127.0.0.1”代表服务器地址。”17001”代表服务器端口号。
//    void RegisterFront(char *pszFrontAddress);
//
//    ///注册名字服务器网络地址
//    ///@param pszNsAddress：名字服务器网络地址。
//    ///@remark 网络地址的格式为：“protocol://ipaddress:port”，如：”tcp://127.0.0.1:12001”。
//    ///@remark “tcp”代表传输协议，“127.0.0.1”代表服务器地址。”12001”代表服务器端口号。
//    ///@remark RegisterNameServer优先于RegisterFront
//    void RegisterNameServer(char *pszNsAddress);
//
//    ///注册衍生服务服务器网络地址
//    ///@param pszNsAddress：衍生服务服务器网络地址。
//    ///@remark 网络地址的格式为：“protocol://ipaddress:port”，如：”tcp://127.0.0.1:16001”。
//    ///@remark “tcp”代表传输协议，“127.0.0.1”代表服务器地址。”16001”代表服务器端口号。
//    void RegisterDeriveServer(char *pszDeriveAddress);
//
//    ///注册回调接口
//    ///@param pSpi 派生自回调接口类的实例
//    void RegisterSpi(CTORATstpTraderSpi *pSpi);
//
//    ///订阅私有流。
//    ///@param nResumeType 私有流重传方式
//    ///        TORA_TERT_RESTART:从本交易日开始重传
//    ///        TORA_TERT_RESUME:从上次收到的续传
//    ///        TORA_TERT_QUICK:只传送登录后私有流的内容
//    ///@remark 该方法要在Init方法前调用。若不调用则不会收到私有流的数据。
//    void SubscribePrivateTopic(TORA_TE_RESUME_TYPE nResumeType);
//
//    ///订阅公共流。
//    ///@param nResumeType 公共流重传方式
//    ///        TORA_TERT_RESTART:从本交易日开始重传
//    ///        TORA_TERT_RESUME:从上次收到的续传
//    ///        TORA_TERT_QUICK:只传送登录后公共流的内容
//    ///@remark 该方法要在Init方法前调用。若不调用则不会收到公共流的数据。
//    void SubscribePublicTopic(TORA_TE_RESUME_TYPE nResumeType);
//
//    ///获取连接信息
//    int ReqGetConnectionInfo(int nRequestID);
//
//    //登录请求
//    int ReqUserLogin(CTORATstpReqUserLoginField *pUserLogInField, int nRequestID);
//
//    //登出请求
//    int ReqUserLogout(CTORATstpUserLogoutField *pUserLogoutField, int nRequestID);
//
//    //修改密码请求
//    int ReqUserPasswordUpdate(CTORATstpUserPasswordUpdateField *pUserPasswordUpdateField, int nRequestID);
//
//    //请求录入设备序列
//    int ReqInputDeviceSerial(CTORATstpReqInputDeviceSerialField *pReqInputDeviceSerialField, int nRequestID);
//
//    //报单录入请求
//    int ReqOrderInsert(CTORATstpInputOrderField *pInputOrderField, int nRequestID);
//
//    //撤单请求
//    int ReqOrderAction(CTORATstpInputOrderActionField *pInputOrderActionField, int nRequestID);
//
//    //条件单录入请求
//    int ReqCondOrderInsert(CTORATstpInputCondOrderField *pInputCondOrderField, int nRequestID);
//
//    //条件单操作请求
//    int ReqCondOrderAction(CTORATstpInputCondOrderActionField *pInputCondOrderActionField, int nRequestID);
//
//    //录入节点资金分配信息请求
//    int ReqInputNodeFundAssignment(CTORATstpInputNodeFundAssignmentField *pInputNodeFundAssignmentField, int nRequestID);
//
//    //查询节点资金分配比例请求
//    int ReqInquiryNodeFundAssignment(CTORATstpReqInquiryNodeFundAssignmentField *pReqInquiryNodeFundAssignmentField, int nRequestID);
//
//    //查询集中交易系统资金请求
//    int ReqInquiryJZFund(CTORATstpReqInquiryJZFundField *pReqInquiryJZFundField, int nRequestID);
//
//    //资金转移请求
//    int ReqTransferFund(CTORATstpInputTransferFundField *pInputTransferFundField, int nRequestID);
//
//    //仓位转移请求
//    int ReqTransferPosition(CTORATstpInputTransferPositionField *pInputTransferPositionField, int nRequestID);
//
//    //担保品划转请求
//    int ReqTransferCollateral(CTORATstpInputTransferCollateralField *pInputTransferCollateralField, int nRequestID);
//
//    //查询银行账户余额请求
//    int ReqInquiryBankAccountFund(CTORATstpReqInquiryBankAccountFundField *pReqInquiryBankAccountFundField, int nRequestID);
//
//    //请求修改开仓成本
//    int ReqModifyOpenPosCost(CTORATstpReqModifyOpenPosCostField *pReqModifyOpenPosCostField, int nRequestID);
//
//    //查询交易成交集中度
//    int ReqInquiryTradeConcentration(CTORATstpInquiryTradeConcentrationField *pInquiryTradeConcentrationField, int nRequestID);
//
//    //查询最大委托量请求
//    int ReqInquiryMaxOrderVolume(CTORATstpReqInquiryMaxOrderVolumeField *pReqInquiryMaxOrderVolumeField, int nRequestID);
//
//    //查询历史委托请求(衍生服务)
//    int ReqInquiryHistoryOrder(CTORATstpQryHistoryOrderField *pQryHistoryOrderField, int nRequestID);
//
//    //查询历史成交请求(衍生服务)
//    int ReqInquiryHistoryTrade(CTORATstpQryHistoryTradeField *pQryHistoryTradeField, int nRequestID);
//
//    //录入标记事件请求(衍生服务)
//    int ReqInputRemarkEvent(CTORATstpInputRemarkEventField *pInputRemarkEventField, int nRequestID);
//
//    //更新标记事件请求(衍生服务)
//    int ReqUpdateRemarkEvent(CTORATstpUpdateRemarkEventField *pUpdateRemarkEventField, int nRequestID);
//
//    //删除标记事件请求(衍生服务)
//    int ReqDeleteRemarkEvent(CTORATstpDeleteRemarkEventField *pDeleteRemarkEventField, int nRequestID);
//
//    //查询历史标记事件请求(衍生服务)
//    int ReqInquiryHistoryRemarkEvent(CTORATstpQryRemarkEventField *pQryRemarkEventField, int nRequestID);
//
//    //查询交易所
//    int ReqQryExchange(CTORATstpQryExchangeField *pQryExchangeField, int nRequestID);
//
//    //查询实时行情
//    int ReqQryMarketData(CTORATstpQryMarketDataField *pQryMarketDataField, int nRequestID);
//
//    //查询证券信息
//    int ReqQrySecurity(CTORATstpQrySecurityField *pQrySecurityField, int nRequestID);
//
//    //查询ETF清单信息
//    int ReqQryETFFile(CTORATstpQryETFFileField *pQryETFFileField, int nRequestID);
//
//    //查询ETF成份证券信息
//    int ReqQryETFBasket(CTORATstpQryETFBasketField *pQryETFBasketField, int nRequestID);
//
//    //查询新股信息
//    int ReqQryIPOInfo(CTORATstpQryIPOInfoField *pQryIPOInfoField, int nRequestID);
//
//    //查询代理关系
//    int ReqQryBUProxy(CTORATstpQryBUProxyField *pQryBUProxyField, int nRequestID);
//
//    //查询User
//    int ReqQryUser(CTORATstpQryUserField *pQryUserField, int nRequestID);
//
//    //查询投资者
//    int ReqQryInvestor(CTORATstpQryInvestorField *pQryInvestorField, int nRequestID);
//
//    //查询股东账户
//    int ReqQryShareholderAccount(CTORATstpQryShareholderAccountField *pQryShareholderAccountField, int nRequestID);
//
//    //报单查询
//    int ReqQryOrder(CTORATstpQryOrderField *pQryOrderField, int nRequestID);
//
//    //查询撤单
//    int ReqQryOrderAction(CTORATstpQryOrderActionField *pQryOrderActionField, int nRequestID);
//
//    //成交查询
//    int ReqQryTrade(CTORATstpQryTradeField *pQryTradeField, int nRequestID);
//
//    //资金账户查询
//    int ReqQryTradingAccount(CTORATstpQryTradingAccountField *pQryTradingAccountField, int nRequestID);
//
//    //投资者持仓查询
//    int ReqQryPosition(CTORATstpQryPositionField *pQryPositionField, int nRequestID);
//
//    //查询基础交易费用
//    int ReqQryTradingFee(CTORATstpQryTradingFeeField *pQryTradingFeeField, int nRequestID);
//
//    //查询佣金费率
//    int ReqQryInvestorTradingFee(CTORATstpQryInvestorTradingFeeField *pQryInvestorTradingFeeField, int nRequestID);
//
//    //查询新股申购额度
//    int ReqQryIPOQuota(CTORATstpQryIPOQuotaField *pQryIPOQuotaField, int nRequestID);
//
//    //查询市场
//    int ReqQryMarket(CTORATstpQryMarketField *pQryMarketField, int nRequestID);
//
//    //报单明细资金查询
//    int ReqQryOrderFundDetail(CTORATstpQryOrderFundDetailField *pQryOrderFundDetailField, int nRequestID);
//
//    //查询资金转移流水
//    int ReqQryFundTransferDetail(CTORATstpQryFundTransferDetailField *pQryFundTransferDetailField, int nRequestID);
//
//    //查询持仓转移流水
//    int ReqQryPositionTransferDetail(CTORATstpQryPositionTransferDetailField *pQryPositionTransferDetailField, int nRequestID);
//
//    //请求投资者质押持仓查询
//    int ReqQryPledgePosition(CTORATstpQryPledgePositionField *pQryPledgePositionField, int nRequestID);
//
//    //请求证券质押信息查询
//    int ReqQryPledgeInfo(CTORATstpQryPledgeInfoField *pQryPledgeInfoField, int nRequestID);
//
//    //请求债券转股信息查询
//    int ReqQryConversionBondInfo(CTORATstpQryConversionBondInfoField *pQryConversionBondInfoField, int nRequestID);
//
//    //请求债券回售信息查询
//    int ReqQryBondPutbackInfo(CTORATstpQryBondPutbackInfoField *pQryBondPutbackInfoField, int nRequestID);
//
//    //请求标准券额度查询
//    int ReqQryStandardBondPosition(CTORATstpQryStandardBondPositionField *pQryStandardBondPositionField, int nRequestID);
//
//    //查询未到期债券质押回购委托
//    int ReqQryPrematurityRepoOrder(CTORATstpQryPrematurityRepoOrderField *pQryPrematurityRepoOrderField, int nRequestID);
//
//    //查询股东参数
//    int ReqQryShareholderParam(CTORATstpQryShareholderParamField *pQryShareholderParamField, int nRequestID);
//
//    //查询外围系统仓位调拨流水
//    int ReqQryPeripheryPositionTransferDetail(CTORATstpQryPeripheryPositionTransferDetailField *pQryPeripheryPositionTransferDetailField, int nRequestID);
//
//    //查询投资者条件单限制参数请求
//    int ReqQryInvestorCondOrderLimitParam(CTORATstpQryInvestorCondOrderLimitParamField *pQryInvestorCondOrderLimitParamField, int nRequestID);
//
//    //查询条件单请求
//    int ReqQryCondOrder(CTORATstpQryCondOrderField *pQryCondOrderField, int nRequestID);
//
//    //查询条件单撤单请求
//    int ReqQryCondOrderAction(CTORATstpQryCondOrderActionField *pQryCondOrderActionField, int nRequestID);
//
//    //查询交易通知请求
//    int ReqQryTradingNotice(CTORATstpQryTradingNoticeField *pQryTradingNoticeField, int nRequestID);
//
//    //查询新股申购配号结果
//    int ReqQryIPONumberResult(CTORATstpQryIPONumberResultField *pQryIPONumberResultField, int nRequestID);
//
//    //查询新股申购中签结果
//    int ReqQryIPOMatchNumberResult(CTORATstpQryIPOMatchNumberResultField *pQryIPOMatchNumberResultField, int nRequestID);
//
//    //查询深港通国际市场互联状态信息请求
//    int ReqQrySZSEImcParams(CTORATstpQrySZSEImcParamsField *pQrySZSEImcParamsField, int nRequestID);
//
//    //查询深港通国际市场互联汇率信息请求
//    int ReqQrySZSEImcExchangeRate(CTORATstpQrySZSEImcExchangeRateField *pQrySZSEImcExchangeRateField, int nRequestID);
//
//    //查询深港通最小价差信息请求
//    int ReqQrySZSEHKPriceTickInfo(CTORATstpQrySZSEHKPriceTickInfoField *pQrySZSEHKPriceTickInfoField, int nRequestID);
//
//    //查询交易协议请求
//    int ReqQryShareholderSpecPrivilege(CTORATstpQryShareholderSpecPrivilegeField *pQryShareholderSpecPrivilegeField, int nRequestID);
//
//    //查询投资者限仓信息请求
//    int ReqQryInvestorPositionLimit(CTORATstpQryInvestorPositionLimitField *pQryInvestorPositionLimitField, int nRequestID);
//
//    //查询盘后行情
//    int ReqQryPHMarketData(CTORATstpQryPHMarketDataField *pQryPHMarketDataField, int nRequestID);
//
//    //查询配股配债信息
//    int ReqQryRationalInfo(CTORATstpQryRationalInfoField *pQryRationalInfoField, int nRequestID);
//
//    //查询外围系统资金调拨流水
//    int ReqQryPeripheryFundTransferDetail(CTORATstpQryPeripheryFundTransferDetailField *pQryPeripheryFundTransferDetailField, int nRequestID);
//
//    //查询系统节点信息
//    int ReqQrySystemNodeInfo(CTORATstpQrySystemNodeInfoField *pQrySystemNodeInfoField, int nRequestID);
//
//    //LOF基金信息查询
//    int ReqQryLofFundInfo(CTORATstpQryLofFundInfoField *pQryLofFundInfoField, int nRequestID);
//};
//
//
//#endif //STP_ACL_TRADEAPI_H
