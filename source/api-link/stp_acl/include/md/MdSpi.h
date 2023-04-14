#pragma once
#include <TORATstpXMdApi.h>
#include <acl_cpp/stdlib/string.hpp>
#include <memory>
#include <map>
#include <common/Account.h>

using namespace TORALEV1API;

class MdSpi : public CTORATstpXMdSpi
{
public:
    MdSpi(CTORATstpXMdApi *api,std::shared_ptr<Account> account);
    ~MdSpi();

    int subscribeMarketData(const char *ppSecurityID,int nCount,const char *ExchangeID); // 订阅行情
    int unSubscribeMarketData(const char *ppSecurityID,int nCount,const char *ExchangeID); // 退订行情

public:
    ///当客户端与交易后台建立起通信连接时（还未登录前），该方法被调用。
    virtual void OnFrontConnected();

    ///当客户端与交易后台通信连接断开时，该方法被调用。当发生这个情况后，API会自动重新连接，客户端可不做处理。
    ///        -3 连接已断开
    ///        -4 网络读失败
    ///        -5 网络写失败
    ///        -6 订阅流错误
    ///        -7 流序号错误
    ///        -8 错误的心跳报文
    ///        -9 错误的报文
    virtual void OnFrontDisconnected(int nReason);

    ///获取连接信息应答
    virtual void OnRspGetConnectionInfo(TORALEV1API::CTORATstpConnectionInfoField *pConnectionInfoField, TORALEV1API::CTORATstpRspInfoField *pRspInfoField, int nRequestID);

    ///登录应答
    virtual void OnRspUserLogin(TORALEV1API::CTORATstpRspUserLoginField *pRspUserLoginField, TORALEV1API::CTORATstpRspInfoField *pRspInfoField, int nRequestID);

    ///登出应答
    virtual void OnRspUserLogout(TORALEV1API::CTORATstpUserLogoutField *pUserLogoutField, TORALEV1API::CTORATstpRspInfoField *pRspInfoField, int nRequestID);

    ///订阅行情应答
    virtual void OnRspSubMarketData(CTORATstpSpecificSecurityField *pSpecificSecurityField, TORALEV1API::CTORATstpRspInfoField *pRspInfoField);

    ///退订行情应答
    virtual void OnRspUnSubMarketData(CTORATstpSpecificSecurityField *pSpecificSecurityField, TORALEV1API::CTORATstpRspInfoField *pRspInfoField);

    ///订阅盘后行情应答
    virtual void OnRspSubPHMarketData(CTORATstpSpecificSecurityField *pSpecificSecurityField, TORALEV1API::CTORATstpRspInfoField *pRspInfoField);

    ///退订盘后行情应答
    virtual void OnRspUnSubPHMarketData(CTORATstpSpecificSecurityField *pSpecificSecurityField, TORALEV1API::CTORATstpRspInfoField *pRspInfoField);

    ///订阅特定行情应答
    virtual void OnRspSubSpecialMarketData(CTORATstpSpecificSecurityField *pSpecificSecurityField, TORALEV1API::CTORATstpRspInfoField *pRspInfoField);

    ///退订特定行情应答
    virtual void OnRspUnSubSpecialMarketData(CTORATstpSpecificSecurityField *pSpecificSecurityField, TORALEV1API::CTORATstpRspInfoField *pRspInfoField);

    ///订阅简易行情应答
    virtual void OnRspSubSimplifyMarketData(CTORATstpSpecificSecurityField *pSpecificSecurityField, TORALEV1API::CTORATstpRspInfoField *pRspInfoField);

    ///退订简易行情应答
    virtual void OnRspUnSubSimplifyMarketData(CTORATstpSpecificSecurityField *pSpecificSecurityField, TORALEV1API::CTORATstpRspInfoField *pRspInfoField);

    ///订阅合约状态应答
    virtual void OnRspSubSecurityStatus(CTORATstpSpecificSecurityField *pSpecificSecurityField, TORALEV1API::CTORATstpRspInfoField *pRspInfoField);

    ///退订合约状态应答
    virtual void OnRspUnSubSecurityStatus(CTORATstpSpecificSecurityField *pSpecificSecurityField, TORALEV1API::CTORATstpRspInfoField *pRspInfoField);

    ///订阅市场状态应答
    virtual void OnRspSubMarketStatus(CTORATstpSpecificMarketField *pSpecificMarketField, TORALEV1API::CTORATstpRspInfoField *pRspInfoField);

    ///退订市场状态应答
    virtual void OnRspUnSubMarketStatus(CTORATstpSpecificMarketField *pSpecificMarketField, TORALEV1API::CTORATstpRspInfoField *pRspInfoField);

    ///订阅国际市场互联状态应答
    virtual void OnRspSubImcParams(CTORATstpSpecificMarketField *pSpecificMarketField, TORALEV1API::CTORATstpRspInfoField *pRspInfoField);

    ///退订国际市场互联状态应答
    virtual void OnRspUnSubImcParams(CTORATstpSpecificMarketField *pSpecificMarketField, TORALEV1API::CTORATstpRspInfoField *pRspInfoField);

    ///查询行情快照应答
    virtual void OnRspInquiryMarketDataMirror(CTORATstpMarketDataField *pMarketDataField, TORALEV1API::CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast);

    ///查询盘后行情快照应答
    virtual void OnRspInquiryPHMarketDataMirror(CTORATstpPHMarketDataField *pPHMarketDataField, TORALEV1API::CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast);

    ///查询特定行情快照应答
    virtual void OnRspInquirySpecialMarketDataMirror(CTORATstpSpecialMarketDataField *pMarketDataField, TORALEV1API::CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast);

    ///订阅期权行情应答
    virtual void OnRspSubSPMarketData(CTORATstpSpecificSecurityField *pSpecificSecurityField, TORALEV1API::CTORATstpRspInfoField *pRspInfoField);

    ///退订期权行情应答
    virtual void OnRspUnSubSPMarketData(CTORATstpSpecificSecurityField *pSpecificSecurityField, TORALEV1API::CTORATstpRspInfoField *pRspInfoField);

    ///订阅期权简易行情应答
    virtual void OnRspSubSPSimplifyMarketData(CTORATstpSpecificSecurityField *pSpecificSecurityField, TORALEV1API::CTORATstpRspInfoField *pRspInfoField);

    ///退订期权简易行情应答
    virtual void OnRspUnSubSPSimplifyMarketData(CTORATstpSpecificSecurityField *pSpecificSecurityField, TORALEV1API::CTORATstpRspInfoField *pRspInfoField);

    ///订阅期权合约状态应答
    virtual void OnRspSubSPSecurityStatus(CTORATstpSpecificSecurityField *pSpecificSecurityField, TORALEV1API::CTORATstpRspInfoField *pRspInfoField);

    ///退订期权合约状态应答
    virtual void OnRspUnSubSPSecurityStatus(CTORATstpSpecificSecurityField *pSpecificSecurityField, TORALEV1API::CTORATstpRspInfoField *pRspInfoField);

    ///订阅期权市场状态应答
    virtual void OnRspSubSPMarketStatus(CTORATstpSpecificMarketField *pSpecificMarketField, TORALEV1API::CTORATstpRspInfoField *pRspInfoField);

    ///退订期权市场状态应答
    virtual void OnRspUnSubSPMarketStatus(CTORATstpSpecificMarketField *pSpecificMarketField, TORALEV1API::CTORATstpRspInfoField *pRspInfoField);

    ///查询期权行情快照应答
    virtual void OnRspInquirySPMarketDataMirror(CTORATstpMarketDataField *pMarketDataField, TORALEV1API::CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast);

    ///行情通知
    virtual void OnRtnMarketData(CTORATstpMarketDataField *pMarketDataField);

    ///盘后行情通知
    virtual void OnRtnPHMarketData(CTORATstpPHMarketDataField *pPHMarketDataField);

    ///特定行情通知
    virtual void OnRtnSpecialMarketData(CTORATstpSpecialMarketDataField *pSpecialMarketDataField);

    ///简易行情通知
    virtual void OnRtnSimplifyMarketData(CTORATstpSimplifyMarketDataField *pSimplifyMarketDataField);

    ///合约状态
    virtual void OnRtnSecurityStatus(CTORATstpSecurityStatusField *pSecurityStatusField);

    ///市场状态
    virtual void OnRtnMarketStatus(TORALEV1API::CTORATstpMarketStatusField *pMarketStatusField);

    ///国际市场互联状态
    virtual void OnRtnImcParams(CTORATstpImcParamsField *pImcParamsField);

    ///期权行情通知
    virtual void OnRtnSPMarketData(CTORATstpMarketDataField *pMarketDataField);

    ///期权简易行情通知
    virtual void OnRtnSPSimplifyMarketData(CTORATstpSimplifyMarketDataField *pSimplifyMarketDataField);

    ///期权合约状态通知
    virtual void OnRtnSPSecurityStatus(CTORATstpSecurityStatusField *pSecurityStatusField);

    ///期权市场状态通知
    virtual void OnRtnSPMarketStatus(TORALEV1API::CTORATstpMarketStatusField *pMarketStatusField);
    
    ///订阅合成快照应答(衍生服务)
    virtual void OnRspSubRapidMarketData(CTORATstpSpecificSecurityField *pSpecificSecurityField, TORALEV1API::CTORATstpRspInfoField *pRspInfoField);

    ///退订合成快照应答(衍生服务)
    virtual void OnRspUnSubRapidMarketData(CTORATstpSpecificSecurityField *pSpecificSecurityField, TORALEV1API::CTORATstpRspInfoField *pRspInfoField);

    ///合成快照通知(衍生服务)
    virtual void OnRtnRapidMarketData(CTORATstpRapidMarketDataField *pRapidMarketDataField);

    ///订阅资金流向行情应答(衍生服务)
    virtual void OnRspSubFundsFlowMarketData(CTORATstpSpecificSecurityField *pSpecificSecurityField, TORALEV1API::CTORATstpRspInfoField *pRspInfoField);

    ///退订资金流向行情应答(衍生服务)
    virtual void OnRspUnSubFundsFlowMarketData(CTORATstpSpecificSecurityField *pSpecificSecurityField, TORALEV1API::CTORATstpRspInfoField *pRspInfoField);

    ///资金流向行情通知(衍生服务)
    virtual void OnRtnFundsFlowMarketData(CTORATstpFundsFlowMarketDataField *pFundsFlowMarketDataField);
    

private:
    CTORATstpXMdApi *m_pMdApi;
    TORALEV1API::CTORATstpRspUserLoginField m_pLoginUserField;

    void MdThreadReConnFn();
    bool isErrorRspInfo(TORALEV1API::CTORATstpRspInfoField *pRspInfo);

    std::shared_ptr<Account> m_pAccount;

};

