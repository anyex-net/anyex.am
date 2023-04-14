////
//// Created by root on 8/18/21.
////
//
//#ifndef STPSERVER_MDAPI_H
//#define STPSERVER_MDAPI_H
//
//
//#include <TORATstpMdApi.h>
//
//class MdApi
//{
//public:
//    MdApi();
//    ~MdApi();
//
//private:
//    CTORATstpMdApi *m_pApi;
//
//public:
//    ///创建MdApi
//    ///@return 创建出的MdApi
//    ///@param eMDSubMode:行情订阅模式，目前支持TCP和UDP组播两种方式
//    ///@param eDeriveMDSubMode:衍生服务极速行情订阅模式，目前仅极速行情支持TCP和UDP组播两种订阅方式，其他衍生服务功能自动以TCP方式订阅
//    CTORATstpMdApi *CreateTstpMdApi(const TTORATstpMDSubModeType &eMDSubMode = TORA_TSTP_MST_TCP, const TTORATstpMDSubModeType &eDeriveMDSubMode = TORA_TSTP_MST_TCP);
//
//    ///获取API版本号
//    ///@return 版本号
//    const char* GetApiVersion();
//
//    ///删除接口对象本身
//    ///@remark 不再使用本接口对象时,调用该函数删除接口对象
//    virtual void Release();
//
//    ///初始化
//    ///@remark 初始化运行环境,只有调用后,接口才开始工作
//    virtual void Init();
//
//    ///等待接口线程结束运行
//    ///@return 线程退出代码
//    virtual int Join();
//
//    ///注册前置机网络地址
//    ///@param pszFrontAddress：前置机网络地址。
//    ///@remark 网络地址的格式为：“protocol://ipaddress:port”，如：”tcp://127.0.0.1:17001”。
//    ///@remark “tcp”代表传输协议，“127.0.0.1”代表服务器地址。”17001”代表服务器端口号。
//    virtual void RegisterFront(char *pszFrontAddress);
//
//    ///注册名字服务器网络地址
//    ///@param pszNsAddress：名字服务器网络地址。
//    ///@remark 网络地址的格式为：“protocol://ipaddress:port”，如：”tcp://127.0.0.1:12001”。
//    ///@remark “tcp”代表传输协议，“127.0.0.1”代表服务器地址。”12001”代表服务器端口号。
//    ///@remark RegisterNameServer优先于RegisterFront
//    virtual void RegisterNameServer(char *pszNsAddress);
//
//    ///注册组播地址
//    ///@param pszMulticastAddress:组播网络地址,如:"udp://224.3.9.110:34567"。
//    ///@param pszInterfaceIP:接收网卡地址,如:"127.0.0.1",填NULL则依次轮询尝试本机所有网卡加入组播组。
//    ///@param pszSourceIp:组播数据包源地址,如:"127.0.0.1",填NULL表示不校验数据包源。
//    ///@remark 仅在使用UDP组播方式工作时有效
//    virtual void RegisterMulticast(char *pszMulticastAddress, char *pszInterfaceIP, char *pszSourceIp);
//
//    ///注册衍生服务服务器网络地址
//    ///@param pszNsAddress：衍生服务服务器网络地址。
//    ///@remark 网络地址的格式为：“protocol://ipaddress:port”，如：”tcp://127.0.0.1:15001”。
//    ///@remark “tcp”代表传输协议，“127.0.0.1”代表服务器地址。”15001”代表服务器端口号。
//    virtual void RegisterDeriveServer(char *pszDeriveAddress);
//
//    ///注册衍生服务服务器组播地址（仅限极速行情使用）
//    ///@param pszMulticastAddress:组播网络地址,如:"udp://224.3.9.110:34567"。
//    ///@param pszInterfaceIP:接收网卡地址,如:"127.0.0.1",填NULL则依次轮询尝试本机所有网卡加入组播组。
//    ///@param pszSourceIp:组播数据包源地址,如:"127.0.0.1",填NULL表示不校验数据包源。
//    ///@remark 仅在使用UDP组播方式工作时有效
//    virtual void RegisterDeriveMulticast(char * pszMulticastAddress, char * pszInterfaceIP, char * pszSourceIp);
//
//    ///注册回调接口
//    ///@param pSpi 派生自回调接口类的实例
//    virtual void RegisterSpi(CTORATstpMdSpi *pSpi);
//
//    ///获取连接信息
//    virtual int ReqGetConnectionInfo(int nRequestID);
//
//    ///用户登录请求
//    virtual int ReqUserLogin(CTORATstpReqUserLoginField *pReqUserLoginField, int nRequestID);
//
//    ///登出请求
//    virtual int ReqUserLogout(CTORATstpUserLogoutField *pUserLogout, int nRequestID);
//
//    ///订阅行情。
//    ///@param ppInstrumentID 合约ID
//    ///@param nCount 要订阅/退订行情的合约个数
//    ///@remark
//    virtual int SubscribeMarketData(char **ppSecurityID, int nCount, TTORATstpExchangeIDType ExchageID);
//
//    ///退订行情。
//    ///@param ppInstrumentID 合约ID
//    ///@param nCount 要订阅/退订行情的合约个数
//    ///@remark
//    virtual int UnSubscribeMarketData(char **ppSecurityID, int nCount, TTORATstpExchangeIDType ExchageID);
//
//    ///订阅盘后行情。
//    ///@param ppInstrumentID 合约ID
//    ///@param nCount 要订阅/退订行情的合约个数
//    ///@remark
//    virtual int SubscribePHMarketData(char **ppSecurityID, int nCount, TTORATstpExchangeIDType ExchageID);
//
//    ///退订盘后行情。
//    ///@param ppInstrumentID 合约ID
//    ///@param nCount 要订阅/退订行情的合约个数
//    ///@remark
//    virtual int UnSubscribePHMarketData(char **ppSecurityID, int nCount, TTORATstpExchangeIDType ExchageID);
//
//    ///订阅特定行情。
//    ///@param ppInstrumentID 合约ID
//    ///@param nCount 要订阅/退订行情的合约个数
//    ///@remark
//    virtual int SubscribeSpecialMarketData(char **ppSecurityID, int nCount, TTORATstpExchangeIDType ExchageID);
//
//    ///退订特定行情。
//    ///@param ppInstrumentID 合约ID
//    ///@param nCount 要订阅/退订行情的合约个数
//    ///@remark
//    virtual int UnSubscribeSpecialMarketData(char **ppSecurityID, int nCount, TTORATstpExchangeIDType ExchageID);
//
//    ///查询行情快照
//    ///@param pInquiryMarketDataField 请求
//    ///@param nRequestID
//    virtual int ReqInquiryMarketDataMirror(CTORATstpInquiryMarketDataField *pInquiryMarketDataField, int nRequestID);
//
//    ///查询盘后行情快照
//    ///@param
//    ///@param nRequestID
//    virtual int ReqInquiryPHMarketDataMirror(CTORATstpInquiryMarketDataField *pInquiryMarketDataField, int nRequestID);
//
//    ///查询特定行情快照
//    ///@param pInquiryMarketDataField 请求
//    ///@param nRequestID
//    virtual int ReqInquirySpecialMarketDataMirror(CTORATstpInquirySpecialMarketDataField *pInquirySpecialMarketDataField, int nRequestID);
//
//    ///订阅极速行情。
//    ///@param ppInstrumentID 合约ID
//    ///@param nCount 要订阅/退订行情的合约个数
//    ///@remark
//    virtual int SubscribeRapidMarketData(char **ppSecurityID, int nCount, TTORATstpExchangeIDType ExchageID);
//
//    ///退订极速行情。
//    ///@param ppInstrumentID 合约ID
//    ///@param nCount 要订阅/退订行情的合约个数
//    ///@remark
//    virtual int UnSubscribeRapidMarketData(char **ppSecurityID, int nCount, TTORATstpExchangeIDType ExchageID);
//
//    ///订阅资金流向行情。
//    ///@param ppInstrumentID 合约ID
//    ///@param nCount 要订阅/退订行情的合约个数
//    ///@remark
//    virtual int SubscribeFundsFlowMarketData(char *ppInstrumentID[], int nCount, TTORATstpExchangeIDType ExchageID);
//
//    ///退订资金流向行情。
//    ///@param ppInstrumentID 合约ID
//    ///@param nCount 要订阅/退订行情的合约个数
//    ///@remark
//    virtual int UnSubscribeFundsFlowMarketData(char *ppInstrumentID[], int nCount, TTORATstpExchangeIDType ExchageID);
//
//    ///订阅行业指数行情。
//    ///@param ppInstrumentID 合约ID
//    ///@param nCount 要订阅/退订行情的合约个数
//    ///@remark
//    virtual int SubscribeIndustryIndexData(char *ppInstrumentID[], int nCount, TTORATstpExchangeIDType ExchageID);
//
//    ///退订行业指数行情。
//    ///@param ppInstrumentID 合约ID
//    ///@param nCount 要订阅/退订行情的合约个数
//    ///@remark
//    virtual int UnSubscribeIndustryIndexData(char *ppInstrumentID[], int nCount, TTORATstpExchangeIDType ExchageID);
//
//    ///订阅概念指数行情。
//    ///@param ppInstrumentID 合约ID
//    ///@param nCount 要订阅/退订行情的合约个数
//    ///@remark
//    virtual int SubscribeConceptionIndexData(char *ppInstrumentID[], int nCount, TTORATstpExchangeIDType ExchageID);
//
//    ///退订概念指数行情。
//    ///@param ppInstrumentID 合约ID
//    ///@param nCount 要订阅/退订行情的合约个数
//    ///@remark
//    virtual int UnSubscribeConceptionIndexData(char *ppInstrumentID[], int nCount, TTORATstpExchangeIDType ExchageID);
//
//    ///订阅地域指数行情。
//    ///@param ppInstrumentID 合约ID
//    ///@param nCount 要订阅/退订行情的合约个数
//    ///@remark
//    virtual int SubscribeRegionIndexData(char *ppInstrumentID[], int nCount, TTORATstpExchangeIDType ExchageID);
//
//    ///退订地域指数行情。
//    ///@param ppInstrumentID 合约ID
//    ///@param nCount 要订阅/退订行情的合约个数
//    ///@remark
//    virtual int UnSubscribeRegionIndexData(char *ppInstrumentID[], int nCount, TTORATstpExchangeIDType ExchageID);
//
//    ///订阅价格波动异常委托明细
//    ///@param ExchangeID 交易所代码
//    ///@param SecurityID 合约代码
//    ///@param Ratio 波动幅度
//    ///@remark
//    virtual int SubscribeEffectOrderDetail(TTORATstpExchangeIDType ExchangeID, TTORATstpSecurityIDType SecurityID, TTORATstpRatioType Ratio);
//
//    ///退订价格波动异常委托明细
//    ///@param ExchangeID 交易所代码
//    ///@param SecurityID 合约代码
//    ///@remark
//    virtual int UnSubscribeEffectOrderDetail(TTORATstpExchangeIDType ExchangeID, TTORATstpSecurityIDType SecurityID);
//
//    ///订阅价格波动异常成交明细
//    ///@param ExchangeID 交易所代码
//    ///@param SecurityID 合约代码
//    ///@param Ratio 波动幅度
//    ///@remark
//    virtual int SubscribeEffectTradeDetail(TTORATstpExchangeIDType ExchangeID, TTORATstpSecurityIDType SecurityID, TTORATstpRatioType Ratio);
//
//    ///退订价格波动异常成交明细
//    ///@param ExchangeID 交易所代码
//    ///@param SecurityID 合约代码
//    ///@remark
//    virtual int UnSubscribeEffectTradeDetail(TTORATstpExchangeIDType ExchangeID, TTORATstpSecurityIDType SecurityID);
//
//    ///查询复权信息
//    ///@param pQryRightsAdjustmentField 请求
//    ///@param nRequestID 请求ID
//    ///@remark
//    virtual int ReqQryRightsAdjustmentInfo(CTORATstpQryRightsAdjustmentInfoField *pQryRightsAdjustmentField, int nRequestID);
//
//    ///查询历史资金流向信息
//    ///@param pQryHistoryFundsFlowField 请求
//    ///@param nRequestID 请求ID
//    ///@remark
//    virtual int ReqQryHistoryFundsFlowInfo(CTORATstpQryHistoryFundsFlowInfoField *pQryHistoryFundsFlowField, int nRequestID);
//
//    ///查询财务指标信息
//    ///@param pQryFinancialIndicatorField 请求
//    ///@param nRequestID 请求ID
//    ///@remark
//    virtual int ReqQryFinancialIndicatorInfo(CTORATstpQryFinancialIndicatorInfoField *pQryFinancialIndicatorField, int nRequestID);
//
//    ///查询分红信息
//    ///@param pQryDividendInfoField 请求
//    ///@param nRequestID 请求ID
//    ///@remark
//    virtual int ReqQryDividendInfo(CTORATstpQryDividendInfoField *pQryDividendInfoField, int nRequestID);
//
//    ///查询送股配股数据信息
//    ///@param pQryRightIssueInfoField 请求
//    ///@param nRequestID 请求ID
//    ///@remark
//    virtual int ReqQryRightIssueInfo(CTORATstpQryRightIssueInfoField *pQryRightIssueInfoField, int nRequestID);
//
//    ///查询公司资料数据信息
//    ///@param pQryCompanyDescriptionInfoField 请求
//    ///@param nRequestID 请求ID
//    ///@remark
//    virtual int ReqQryCompanyDescriptionInfo(CTORATstpQryCompanyDescriptionInfoField *pQryCompanyDescriptionInfoField, int nRequestID);
//
//    ///查询主营业务数据信息
//    ///@param pQrySalesSegmentInfoField 请求
//    ///@param nRequestID 请求ID
//    ///@remark
//    virtual int ReqQrySalesSegmentInfo(CTORATstpQrySalesSegmentInfoField *pQrySalesSegmentInfoField, int nRequestID);
//
//    ///查询股本结构数据信息
//    ///@param pQryEquityStructureInfoField 请求
//    ///@param nRequestID 请求ID
//    ///@remark
//    virtual int ReqQryEquityStructureInfo(CTORATstpQryEquityStructureInfoField *pQryEquityStructureInfoField, int nRequestID);
//
//    ///查询十大股东数据信息
//    ///@param pQryTopTenHoldersInfoField 请求
//    ///@param nRequestID 请求ID
//    ///@remark
//    virtual int ReqQryTopTenHoldersInfo(CTORATstpQryTopTenHoldersInfoField *pQryTopTenHoldersInfoField, int nRequestID);
//
//    ///查询十大流通股东数据信息
//    ///@param pQryTopTenFloatHoldersInfoField 请求
//    ///@param nRequestID 请求ID
//    ///@remark
//    virtual int ReqQryTopTenFloatHoldersInfo(CTORATstpQryTopTenFloatHoldersInfoField *pQryTopTenFloatHoldersInfoField, int nRequestID);
//
//    ///查询个股所属行业板块信息
//    ///@param pQryIndustryInfoField 请求
//    ///@param nRequestID 请求ID
//    ///@remark
//    virtual int ReqQryIndustryInfo(CTORATstpQryIndustryInfoField *pQryIndustryInfoField, int nRequestID);
//
//    ///查询个股所属概念板块信息
//    ///@param pQryConceptionInfoField 请求
//    ///@param nRequestID 请求ID
//    ///@remark
//    virtual int ReqQryConceptionInfo(CTORATstpQryConceptionInfoField *pQryConceptionInfoField, int nRequestID);
//
//    ///查询个股所属地域版块信息
//    ///@param pQryRegionInfoField 请求
//    ///@param nRequestID 请求ID
//    ///@remark
//    virtual int ReqQryRegionInfo(CTORATstpQryRegionInfoField *pQryRegionInfoField, int nRequestID);
//
//    ///查询指数描述信息数据信息
//    ///@param pQryIndexDescriptionInfoField 请求
//    ///@param nRequestID 请求ID
//    ///@remark
//    virtual int ReqQryIndexDescriptionInfo(CTORATstpQryIndexDescriptionInfoField *pQryIndexDescriptionInfoField, int nRequestID);
//
//    ///查询行业板块成分股数据信息
//    ///@param pQryIndustryConstituentsInfoField 请求
//    ///@param nRequestID 请求ID
//    ///@remark
//    virtual int ReqQryIndustryConstituentsInfo(CTORATstpQryIndustryConstituentsInfoField *pQryIndustryConstituentsInfoField, int nRequestID);
//
//    ///查询概念板块成分股数据信息
//    ///@param pQryConceptionConstituentsInfoField 请求
//    ///@param nRequestID 请求ID
//    ///@remark
//    virtual int ReqQryConceptionConstituentsInfo(CTORATstpQryConceptionConstituentsInfoField *pQryConceptionConstituentsInfoField, int nRequestID);
//
//    ///查询地域板块成分股数据信息
//    ///@param pQryRegionInfoField 请求
//    ///@param nRequestID 请求ID
//    ///@remark
//    virtual int ReqQryRegionConstituentsInfo(CTORATstpQryRegionConstituentsInfoField *pQryRegionConstituentsInfoField, int nRequestID);
//
//    ///查询行业版块指数列表
//    ///@param pQryIndustryCodeListField 请求
//    ///@param nRequestID 请求ID
//    ///@remark
//    virtual int ReqQryIndustryCodeList(CTORATstpQryIndustryCodeListField *pQryIndustryCodeListField, int nRequestID);
//
//    ///查询概念版块指数列表
//    ///@param pQryConceptionCodeListField 请求
//    ///@param nRequestID 请求ID
//    ///@remark
//    virtual int ReqQryConceptionCodeList(CTORATstpQryConceptionCodeListField *pQryConceptionCodeListField, int nRequestID);
//
//    ///查询地域版块指数列表
//    ///@param pQryRegionCodeListField 请求
//    ///@param nRequestID 请求ID
//    ///@remark
//    virtual int ReqQryRegionCodeList(CTORATstpQryRegionCodeListField *pQryRegionCodeListField, int nRequestID);
//
//    ///查询自由流通股本信息
//    ///@param pQryFreeFloatSharesField 请求
//    ///@param nRequestID 请求ID
//    ///@remark
//    virtual int ReqQryFreeFloatSharesInfo(CTORATstpQryFreeFloatSharesInfoField *pQryFreeFloatSharesField, int nRequestID);
//
//    ///查询盘口委托
//    ///@param pInquiryQueueingOrdersField 请求
//    ///@param nRequestID 请求ID
//    ///@remark
//    virtual int ReqQryQueueingOrders(CTORATstpInquiryQueueingOrdersField *pInquiryQueueingOrdersField, int nRequestID);
//
//    ///查询持仓量价分布信息
//    ///@param pQryPriceDistributionField 请求
//    ///@param nRequestID 请求ID
//    ///@remark
//    virtual int ReqQryPriceDistributionInfo(CTORATstpQryPriceDistributionInfoField *pQryPriceDistributionField, int nRequestID);
//
//    ///查询历史极值价格信息
//    ///@param pQryPriceExtremumField 请求
//    ///@param nRequestID 请求ID
//    ///@remark
//    virtual int ReqQryPriceExtremumInfo(CTORATstpQryPriceExtremumInfoField *pQryPriceExtremumField, int nRequestID);
//
//};
//
//
//#endif //STPSERVER_MDAPI_H
