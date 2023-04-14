#pragma once
#include <TORATstpTraderApi.h>
#include <map>
#include <common/Account.h>
#include "TraderApi.h"
#include <memory>

using namespace TORASTOCKAPI;

class TraderSpi : public CTORATstpTraderSpi
{
public:
    TraderSpi(CTORATstpTraderApi *api,std::shared_ptr<Account> account);
    ~TraderSpi();
//    void setAccount(std::shared_ptr<Account> account);
    void InitDataTypeConst();

    void reqUserLogin();  // 登录
    int reqOrderInsert(const char *SecurityID,const char *ShareholderID,const char *ExchangeID,const char *OrderRef,
                       const char *Direction,const char *OrderPriceType,const char *LimitPrice,const char* Volume,
                       const char *SInfo, const char *TimeCondition, const char *VolumeCondition);  // 报单录入
    int reqOrderAction(const char *ExchangeID,const char *FrontID,const char *SessionID,const char *OrderRef,const char *SInfo);  // 撤单
    int reqQryOrder();
    int reqQryTrade();
    int reqQryPosition();

    int reqQryExchange(const char *ExchangeID);  // 请求查询交易所
    int reqQrySecurity(const char* SecurityID,const char* ExchangeID,const char* ProductID);  // 查询证券信息
    int reqQryMarket(const char *ExchangeID,const char *MarketID);  // 查询市场
    int reqQryShareholderAccount(const char* ExchangeID,const char* MarketID,const char* ShareholderID,const char* TradingCodeClass);  // 查询股东账户
    int reqQryShareholderParam();
    int reqQryTradingAccount(const char *InvestorID,const char *CurrencyID,const char *AccountID,const char *AccountType,const char *DepartmentID);  // 查询资金账户

    int reqQryLofFundInfo(const char *ExchangeID,const char *FundID,const char *MainFundID);  // LOF基金信息查询
    int reqQryUser();  // 查询用户请求
    int reqQryInvestor();  // 查询投资者请求

    int reqQryInvestorTradingFee(const char *ExchangeID,const char *DepartmentID);  // 查询佣金费率
    int reqQryTradingFee(const char *ExchangeID);  // 查询基础交易费率响应
    int reqQryOrderFundDetail();  // 查询报单明细资金

public:
    ///当客户端与交易后台建立起通信连接时（还未登录前），该方法被调用。
    virtual void OnFrontConnected();

    ///当客户端与交易后台通信连接断开时，该方法被调用。当发生这个情况后，API会自动重新连接，客户端可不做处理。
    ///@param nReason 错误原因
    ///        -3 连接已断开
    ///        -4 网络读失败
    ///        -5 网络写失败
    ///        -6 订阅流错误
    ///        -7 流序号错误
    ///        -8 错误的心跳报文
    ///        -9 错误的报文
    ///		  -15 网络读失败
    ///		  -16 网络写失败
    virtual void OnFrontDisconnected(int nReason);

    ///错误应答
    virtual void OnRspError(TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast);

    ///获取连接信息应答
    virtual void OnRspGetConnectionInfo(TORASTOCKAPI::CTORATstpConnectionInfoField *pConnectionInfoField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID);

    ///登录响应
    virtual void OnRspUserLogin(TORASTOCKAPI::CTORATstpRspUserLoginField *pRspUserLoginField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID);

    ///登出响应
    virtual void OnRspUserLogout(TORASTOCKAPI::CTORATstpUserLogoutField *pUserLogoutField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID);

    ///修改密码响应
    virtual void OnRspUserPasswordUpdate(CTORATstpUserPasswordUpdateField *pUserPasswordUpdateField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID);

    ///录入设备序列响应
    virtual void OnRspInputDeviceSerial(CTORATstpRspInputDeviceSerialField *pRspInputDeviceSerialField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID);

    ///报单录入响应
    virtual void OnRspOrderInsert(CTORATstpInputOrderField *pInputOrderField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID);

    ///报单回报
    virtual void OnRtnOrder(CTORATstpOrderField *pOrderField);

    ///报单错误回报
    virtual void OnErrRtnOrderInsert(CTORATstpInputOrderField *pInputOrderField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID);

    ///成交回报
    virtual void OnRtnTrade(CTORATstpTradeField *pTradeField);

    ///撤单响应
    virtual void OnRspOrderAction(CTORATstpInputOrderActionField *pInputOrderActionField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID);

    ///撤单错误回报
    virtual void OnErrRtnOrderAction(CTORATstpInputOrderActionField *pInputOrderActionField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID);

    ///条件单录入响应
    virtual void OnRspCondOrderInsert(CTORATstpInputCondOrderField *pInputCondOrderField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID);

    ///条件单回报
    virtual void OnRtnCondOrder(CTORATstpConditionOrderField *pConditionOrderField);

    ///条件单录入错误回报
    virtual void OnErrRtnCondOrderInsert(CTORATstpInputCondOrderField *pInputCondOrderField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID);

    ///条件单撤单响应
    virtual void OnRspCondOrderAction(CTORATstpInputCondOrderActionField *pInputCondOrderActionField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID);

    ///条件单撤单错误回报
    virtual void OnErrRtnCondOrderAction(CTORATstpInputCondOrderActionField *pInputCondOrderActionField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID);

    ///协议交易报单录入响应
    virtual void OnRspNegoOrderInsert(CTORATstpInputNegoOrderField *pInputNegoOrderField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID);

    ///协议交易报单回报
    virtual void OnRtnNegoOrder(CTORATstpNegoOrderField *pNegoOrderField);

    ///协议交易报单错误回报
    virtual void OnErrRtnNegoOrderInsert(CTORATstpInputNegoOrderField *pInputNegoOrderField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID);

    ///协议交易成交回报
    virtual void OnRtnNegoTrade(CTORATstpNegoTradeField *pNegoTradeField);

    ///协议交易报单操作录入响应
    virtual void OnRspNegoOrderAction(CTORATstpInputNegoOrderActionField *pInputNegoOrderActionField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID);

    ///协议交易报单操作错误回报
    virtual void OnErrRtnNegoOrderAction(CTORATstpInputNegoOrderActionField *pInputNegoOrderActionField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID);

    ///市场状态回报
    virtual void OnRtnMarketStatus(TORASTOCKAPI::CTORATstpMarketStatusField *pMarketStatusField);

    ///资金转移响应
    virtual void OnRspTransferFund(CTORATstpInputTransferFundField *pInputTransferFundField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID);

    ///资金转移错误回报
    virtual void OnErrRtnTransferFund(CTORATstpInputTransferFundField *pInputTransferFundField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID);

    ///资金转移回报
    virtual void OnRtnTransferFund(CTORATstpTransferFundField *pTransferFundField);

    ///仓位转移响应
    virtual void OnRspTransferPosition(CTORATstpInputTransferPositionField *pInputTransferPositionField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID);

    ///仓位转移错误回报
    virtual void OnErrRtnTransferPosition(CTORATstpInputTransferPositionField *pInputTransferPositionField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID);

    ///仓位转移回报
    virtual void OnRtnTransferPosition(CTORATstpTransferPositionField *pTransferPositionField);

    ///外围系统仓位转移回报
    virtual void OnRtnPeripheryTransferPosition(CTORATstpPeripheryTransferPositionField *pPeripheryTransferPositionField);

    ///外围系统资金转移回报
    virtual void OnRtnPeripheryTransferFund(CTORATstpPeripheryTransferFundField *pPeripheryTransferFundField);

    ///查询集中交易系统资金响应
    virtual void OnRspInquiryJZFund(CTORATstpRspInquiryJZFundField *pRspInquiryJZFundField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID);

    ///查询银行账户余额响应
    virtual void OnRspInquiryBankAccountFund(CTORATstpRspInquiryBankAccountFundField *pRspInquiryBankAccountFundField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID);

    ///交易通知回报
    virtual void OnRtnTradingNotice(CTORATstpTradingNoticeField *pTradingNoticeField);

    ///查询最大报单量响应
    virtual void OnRspInquiryMaxOrderVolume(CTORATstpRspInquiryMaxOrderVolumeField *pRspInquiryMaxOrderVolumeField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID);

    ///交易成交集中度查询响应
    virtual void OnRspInquiryTradeConcentration(CTORATstpInquiryTradeConcentrationField *pInquiryTradeConcentrationField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID);

    ///请求修改开仓成本响应
    virtual void OnRspModifyOpenPosCost(CTORATstpReqModifyOpenPosCostField *pReqModifyOpenPosCostField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID);

    ///录入节点资金分配信息响应
    virtual void OnRspInputNodeFundAssignment(CTORATstpInputNodeFundAssignmentField *pInputNodeFundAssignmentField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID);

    ///查询节点资金分配比例响应
    virtual void OnRspInquiryNodeFundAssignment(CTORATstpRspInquiryNodeFundAssignmentField *pRspInquiryNodeFundAssignmentField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID);

    ///查询交易所响应
    virtual void OnRspQryExchange(CTORATstpExchangeField *pExchangeField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast);

    ///查询证券信息响应
    virtual void OnRspQrySecurity(CTORATstpSecurityField *pSecurityField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast);

    ///查询新股信息响应
    virtual void OnRspQryIPOInfo(CTORATstpIPOInfoField *pIPOInfoField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast);

    ///查询用户响应
    virtual void OnRspQryUser(CTORATstpUserField *pUserField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast);

    ///查询投资者响应
    virtual void OnRspQryInvestor(CTORATstpInvestorField *pInvestorField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast);

    ///查询股东账户响应
    virtual void OnRspQryShareholderAccount(CTORATstpShareholderAccountField *pShareholderAccountField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast);

    ///查询配股配债信息响应
    virtual void OnRspQryRationalInfo(CTORATstpRationalInfoField *pRationalInfoField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast);

    ///查询报单响应
    virtual void OnRspQryOrder(CTORATstpOrderField *pOrderField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast);

    ///查询撤单请求
    virtual void OnRspQryOrderAction(CTORATstpOrderActionField *pOrderActionField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast);

    ///查询成交响应
    virtual void OnRspQryTrade(CTORATstpTradeField *pTradeField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast);

    ///查询资金账户响应
    virtual void OnRspQryTradingAccount(CTORATstpTradingAccountField *pTradingAccountField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast);

    ///查询投资者持仓响应
    virtual void OnRspQryPosition(CTORATstpPositionField *pPositionField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast);

    ///查询基础交易费率响应
    virtual void OnRspQryTradingFee(CTORATstpTradingFeeField *pTradingFeeField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast);

    ///查询佣金费率响应
    virtual void OnRspQryInvestorTradingFee(CTORATstpInvestorTradingFeeField *pInvestorTradingFeeField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast);

    ///查询新股申购额度响应
    virtual void OnRspQryIPOQuota(CTORATstpIPOQuotaField *pIPOQuotaField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast);

    ///查询报单明细资金响应
    virtual void OnRspQryOrderFundDetail(CTORATstpOrderFundDetailField *pOrderFundDetailField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast);

    ///查询资金转移流水响应
    virtual void OnRspQryFundTransferDetail(CTORATstpFundTransferDetailField *pFundTransferDetailField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast);

    ///查询持仓转移流水响应
    virtual void OnRspQryPositionTransferDetail(CTORATstpPositionTransferDetailField *pPositionTransferDetailField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast);

    ///查询外围系统仓位调拨流水响应
    virtual void OnRspQryPeripheryPositionTransferDetail(CTORATstpPeripheryPositionTransferDetailField *pPeripheryPositionTransferDetailField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast);

    ///查询外围系统资金调拨流水响应
    virtual void OnRspQryPeripheryFundTransferDetail(CTORATstpPeripheryFundTransferDetailField *pPeripheryFundTransferDetailField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast);

    ///查询债券转股信息响应
    virtual void OnRspQryBondConversionInfo(CTORATstpBondConversionInfoField *pBondConversionInfoField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast);

    ///查询债券回售信息响应
    virtual void OnRspQryBondPutbackInfo(CTORATstpBondPutbackInfoField *pBondPutbackInfoField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast);

    ///查询投资者条件单限制参数响应
    virtual void OnRspQryInvestorCondOrderLimitParam(CTORATstpInvestorCondOrderLimitParamField *pInvestorCondOrderLimitParamField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast);

    ///查询条件单响应
    virtual void OnRspQryConditionOrder(CTORATstpConditionOrderField *pConditionOrderField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast);

    ///查询条件单撤单响应
    virtual void OnRspQryCondOrderAction(CTORATstpCondOrderActionField *pCondOrderActionField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast);

    ///查询交易通知响应
    virtual void OnRspQryTradingNotice(CTORATstpTradingNoticeField *pTradingNoticeField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast);

    ///查询新股申购配号结果响应
    virtual void OnRspQryIPONumberResult(CTORATstpIPONumberResultField *pIPONumberResultField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast);

    ///查询新股申购中签结果响应
    virtual void OnRspQryIPOMatchNumberResult(CTORATstpIPOMatchNumberResultField *pIPOMatchNumberResultField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast);

    ///查询交易协议响应
    virtual void OnRspQryShareholderSpecPrivilege(CTORATstpShareholderSpecPrivilegeField *pShareholderSpecPrivilegeField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast);

    ///查询市场响应
    virtual void OnRspQryMarket(CTORATstpMarketField *pMarketField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast);

    ///查询ETF清单信息响应
    virtual void OnRspQryETFFile(CTORATstpETFFileField *pETFFileField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast);

    ///查询ETF成份证券信息响应
    virtual void OnRspQryETFBasket(CTORATstpETFBasketField *pETFBasketField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast);

    ///查询投资者限仓信息响应
    virtual void OnRspQryInvestorPositionLimit(CTORATstpInvestorPositionLimitField *pInvestorPositionLimitField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast);

    ///查询深港通国际市场互联状态信息响应
    virtual void OnRspQrySZSEImcParams(CTORATstpSZSEImcParamsField *pSZSEImcParamsField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast);

    ///查询深港通国际市场互联汇率信息响应
    virtual void OnRspQrySZSEImcExchangeRate(CTORATstpSZSEImcExchangeRateField *pSZSEImcExchangeRateField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast);

    ///查询深港通最小价差信息响应
    virtual void OnRspQrySZSEHKPriceTickInfo(CTORATstpSZSEHKPriceTickInfoField *pSZSEHKPriceTickInfoField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast);

    ///查询LOF基金信息响应
    virtual void OnRspQryLofFundInfo(CTORATstpLofFundInfoField *pLofFundInfoField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast);

    ///查询投资者质押持仓响应
    virtual void OnRspQryPledgePosition(CTORATstpPledgePositionField *pPledgePositionField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast);

    ///查询证券质押信息响应
    virtual void OnRspQryPledgeInfo(CTORATstpPledgeInfoField *pPledgeInfoField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast);

    ///查询系统节点信息响应
    virtual void OnRspQrySystemNodeInfo(CTORATstpSystemNodeInfoField *pSystemNodeInfoField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast);

    ///查询标准券额度响应
    virtual void OnRspQryStandardBondPosition(CTORATstpStandardBondPositionField *pStandardBondPositionField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast);

    ///查询未到期债券质押回购委托响应
    virtual void OnRspQryPrematurityRepoOrder(CTORATstpPrematurityRepoOrderField *pPrematurityRepoOrderField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast);

    ///查询协议交易报单响应
    virtual void OnRspQryNegoOrder(CTORATstpNegoOrderField *pNegoOrderField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast);

    ///查询协议交易撤单响应
    virtual void OnRspQryNegoOrderAction(CTORATstpNegoOrderActionField *pNegoOrderActionField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast);

    ///查询协议交易成交响应
    virtual void OnRspQryNegoTrade(CTORATstpNegoTradeField *pNegoTradeField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast);

    ///查询协议交易参数响应
    virtual void OnRspQryNegotiationParam(CTORATstpNegotiationParamField *pNegotiationParamField, TORASTOCKAPI::CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast);



private:
    CTORATstpTraderApi *m_pTraderApi;
    TORASTOCKAPI::CTORATstpRspUserLoginField m_pLoginUserField;
    TTORATstpOrderRefType	MaxOrderRef;
    std::string TerminalInfo;   //  设备信息

    std::shared_ptr<Account> m_pAccount;    //  账户信息

    std::map<char, std::string> DataTypeConst;

    void TraderThreadReConnFn();
    bool isTradingOrder(CTORATstpOrderField *pOrder);
    bool isErrorRspInfo(TORASTOCKAPI::CTORATstpRspInfoField *pRspInfo);

    const char* GetValue(char key);
};

//std::map<char, std::string> TraderSpi::DataTypeConst;

