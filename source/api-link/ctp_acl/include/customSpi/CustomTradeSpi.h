#pragma once
// ---- 派生的交易类 ---- //
#include <ThostFtdcTraderApi.h>
#include <Account.h>
#include "SimpleEvent.h"
#include <memory>
#include <map>

using namespace std;

class CustomTradeSpi : public CThostFtdcTraderSpi
{
    // ---- 自定义函数 ---- //
public:
    CustomTradeSpi(void);
    ~CustomTradeSpi(void);


    void loopCmd();
    void printHelp();
    void SetTradeApi(CThostFtdcTraderApi* tradeApi);
    void SetAccount(std::shared_ptr<Account> account);

    int reqAuthenticate(); // 客户端认证请求
    int reqUserLogin(); // 登录请求
    int reqUserLogout(); // 登出请求

    int reqOrderInsert(const char *exchangeId, const char *instrumentID, const char *direction,
                       const char *orderPriceType,const char *limitPrice, const char* volume,
                       const char *combOffsetFlag, const char *CombHedgeFlag, const char *OrderRef); // 请求报单录入
    void reqParkedOrderInsert(); // 预埋单录入请求
    void reqParkedOrderAction(); // 预埋撤单录入请求
    int reqOrderAction(const char *frontID, const char *orderRef, const char *sessionId,
                       const char *instrumentID, const char* ExchangeID); // 报单操作请求
    void reqQueryMaxOrderVolume(); // 查询最大保报单数量

    void reqRemoveParkedOrder(); // 请求删除预埋单
    void reqRemoveParkedOrderAction(); // 请求删除预埋撤单

    int reqQryOrder(); // 请求查询报单
    void reqQryParkedOrder(); // 请求查询预埋单
    void reqQryParkedOrderAction(); // 请求查询预埋单撤单
    int reqQryTrade(); // 请求查询成交
    int reqQryInvestorPosition(); // 请求查询投资者持仓
    int reqQryInvestorPositionDetail(const char *InstrumentID, const char *ExchangeID); // 请求查询投资者持仓明细

    int reqQryExchange(const char *ExchangeID); // 请求查询交易所
    int reqQryProduct(const char *ProductID, const char *ExchangeID); // 请求查询产品
    int reqQryInstrument(const char *InstrumentID, const char *ExchangeID); // 请求查询合约
    int reqQryTradingAccount(); // 请求查询资金帐户
    int reqQryInvestor(); // 请求查询投资者
    int reqQryTradingCode(); // 请求查询交易编号

    int reqQryInstrumentMarginRate(const char *HedgeFlag, const char *InstrumentID); // 请求查询合约保证金金率
    int reqQryInstrumentCommissionRate(const char *InstrumentID, const char *ExchangeID); // 请求查询合约手续费率
    int reqQryInstrumentOrderCommRate(const char *InstrumentID); // 查询报单手续费率 中金所持有
    void reqQryExchangeMarginRate(); // 请求查询交易所保证金率
    void reqQryExchangeMarginRateAdjust(); // 请求查询交易所调整保证金率
    int reqQryBrokerTradingParams();  // 请求查询经纪公司交易参数

    int reqQryDepthMarketData(const char *InstrumentID); // 请求查询行情
    int reqQrySettlementInfo(const char *TradingDay); // 请求查询投资者结算结果（可以按要求查某天、月的结算单）
    int reqSettlementInfoConfirm(); // 投资者结果确认
    int reqQrySettlementInfoConfirm(); // 查询结算信息确认

    void reqQryForQuote(); // 请求查询询价

// ---- ctp_api部分回调接口 ---- //
public:
    ///当客户端与交易后台建立起通信连接时（还未登录前），该方法被调用。
    void OnFrontConnected();

    ///登录请求响应
    void OnRspUserLogin(CThostFtdcRspUserLoginField *pRspUserLogin, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);

    ///错误应答
    void OnRspError(CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);

    ///当客户端与交易后台通信连接断开时，该方法被调用。当发生这个情况后，API会自动重新连接，客户端可不做处理。
    void OnFrontDisconnected(int nReason);

    ///心跳超时警告。当长时间未收到报文时，该方法被调用。
    void OnHeartBeatWarning(int nTimeLapse);

    ///登出请求响应
    void OnRspUserLogout(CThostFtdcUserLogoutField *pUserLogout, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);

    ///投资者结算结果确认响应
    void OnRspSettlementInfoConfirm(CThostFtdcSettlementInfoConfirmField *pSettlementInfoConfirm, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);

    ///请求查询结算信息确认响应
    void OnRspQrySettlementInfoConfirm(CThostFtdcSettlementInfoConfirmField *pSettlementInfoConfirm, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);

    ///请求查询合约响应
    void OnRspQryInstrument(CThostFtdcInstrumentField *pInstrument, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);

    ///请求查询资金账户响应
    void OnRspQryTradingAccount(CThostFtdcTradingAccountField *pTradingAccount, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);

    ///请求查询投资者持仓响应
    void OnRspQryInvestorPosition(CThostFtdcInvestorPositionField *pInvestorPosition, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);

    ///报单录入请求响应
    void OnRspOrderInsert(CThostFtdcInputOrderField *pInputOrder, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);

    ///报单操作请求响应
    void OnRspOrderAction(CThostFtdcInputOrderActionField *pInputOrderAction, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);

    ///报单通知
    void OnRtnOrder(CThostFtdcOrderField *pOrder);

    ///成交通知
    void OnRtnTrade(CThostFtdcTradeField *pTrade);

    ///请求查询询价响应
    void OnRspQryForQuote(CThostFtdcForQuoteField *pForQuote, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);

    ///报单录入错误回报
    void OnErrRtnOrderInsert(CThostFtdcInputOrderField *pInputOrder, CThostFtdcRspInfoField *pRspInfo);

    ///报单操作错误回报
    void OnErrRtnOrderAction(CThostFtdcOrderActionField *pOrderAction, CThostFtdcRspInfoField *pRspInfo);

    ///请求查询合约保证金率
    int ReqQryInstrumentMarginRate(CThostFtdcQryInstrumentMarginRateField *pQryInstrumentMarginRate, int nRequestID);

    ///请求查询合约手续费率
    int ReqQryInstrumentCommissionRate(CThostFtdcQryInstrumentCommissionRateField *pQryInstrumentCommissionRate, int nRequestID);

    ///请求查询报单手续费
    int ReqQryInstrumentOrderCommRate(CThostFtdcQryInstrumentOrderCommRateField *pQryInstrumentOrderCommRate, int nRequestID);

    ///请求查询合约保证金率响应
    void OnRspQryInstrumentMarginRate(CThostFtdcInstrumentMarginRateField *pInstrumentMarginRate, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);

    ///请求查询合约手续费率响应
    void OnRspQryInstrumentCommissionRate(CThostFtdcInstrumentCommissionRateField *pInstrumentCommissionRate, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);

    ///请求查询报单手续费响应
    void OnRspQryInstrumentOrderCommRate(CThostFtdcInstrumentOrderCommRateField *pInstrumentOrderCommRate, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);

    ///请求查询交易所响应
    void OnRspQryExchange(CThostFtdcExchangeField *pExchange, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);

    ///请求查询产品响应
    void OnRspQryProduct(CThostFtdcProductField *pProduct, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);

    ///请求查询报单响应
    void OnRspQryOrder(CThostFtdcOrderField *pOrder, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);

    ///请求查询成交响应
    void OnRspQryTrade(CThostFtdcTradeField *pTrade, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);

    ///请求查询投资者持仓明细响应
    void OnRspQryInvestorPositionDetail(CThostFtdcInvestorPositionDetailField *pInvestorPositionDetail, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);

    ///请求查询行情响应
    void OnRspQryDepthMarketData(CThostFtdcDepthMarketDataField *pDepthMarketData, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);

    ///请求查询投资者响应
    void OnRspQryInvestor(CThostFtdcInvestorField *pInvestor, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);

    ///请求查询交易编码响应
    void OnRspQryTradingCode(CThostFtdcTradingCodeField *pTradingCode, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);

    ///请求查询投资者结算结果响应
    void OnRspQrySettlementInfo(CThostFtdcSettlementInfoField *pSettlementInfo, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);

    ///预埋单录入请求响应
    void OnRspParkedOrderInsert(CThostFtdcParkedOrderField *pParkedOrder, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);

    ///预埋撤单录入请求响应
    void OnRspParkedOrderAction(CThostFtdcParkedOrderActionField *pParkedOrderAction, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);

    ///删除预埋单响应
    void OnRspRemoveParkedOrder(CThostFtdcRemoveParkedOrderField *pRemoveParkedOrder, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);

    ///删除预埋撤单响应
    void OnRspRemoveParkedOrderAction(CThostFtdcRemoveParkedOrderActionField *pRemoveParkedOrderAction, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);

    ///请求查询预埋单响应
    void OnRspQryParkedOrder(CThostFtdcParkedOrderField *pParkedOrder, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);

    ///请求查询预埋撤单响应
    void OnRspQryParkedOrderAction(CThostFtdcParkedOrderActionField *pParkedOrderAction, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);

    ///客户端认证响应
    void OnRspAuthenticate(CThostFtdcRspAuthenticateField *pRspAuthenticateField, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);

    ///请求查询经纪公司交易参数响应
    void OnRspQryBrokerTradingParams(CThostFtdcBrokerTradingParamsField *pBrokerTradingParams, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast);


private:
    CThostFtdcTraderApi *m_pTradeUserApi; // // 交易指针
    bool m_bAuthFlag; // 客户端认证的标识
    bool m_bLoginFlag; // 登陆成功的标识
    bool m_bLogoutFlag;

    SimpleEvent m_Event;
    std::shared_ptr<Account> m_pAccount;

    void TradeThreadReConnFn();
    bool isErrorRspInfo(CThostFtdcRspInfoField *pRspInfo); // 是否收到错误信息
    bool isMyOrder(CThostFtdcOrderField *pOrder); // 是否我的报单回报
    bool isTradingOrder(CThostFtdcOrderField *pOrder); // 是否正在交易的报单
};