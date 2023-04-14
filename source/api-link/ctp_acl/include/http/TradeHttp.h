#pragma once
#include "../include/customSpi/CustomTradeSpi.h"
#include "stdafx.h"
//using namespace std;

class TradeHttp {
public:
    TradeHttp();
    ~TradeHttp();

//    static void setTradeApi(CustomTradeSpi *);
    void setTradeVector(vector<pair<const char *, CustomTradeSpi*>> t);
    void start(const char* addrs);

private:

    // 请求查询交易所
    static bool ReqQryExchange(HttpRequest& req, HttpResponse& res);
    // 请求查询产品
    static bool ReqQryProduct(HttpRequest& req, HttpResponse& res);
    // 请求查询合约
    static bool ReqQryInstrument(HttpRequest& req, HttpResponse& res);
    // 请求查询资金帐户
    static bool ReqQryTradingAccount(HttpRequest& req, HttpResponse& res);
    // 请求查询投资者
    static bool ReqQryInvestor(HttpRequest& req, HttpResponse& res);
     //请求查询交易编号
    static bool ReqQryTradingCode(HttpRequest& req, HttpResponse& res);


    // 请求查询合约保证金金率
    static bool ReqQryInstrumentMarginRate(HttpRequest& req, HttpResponse& res);
    // 请求查询合约手续费率
    static bool ReqQryInstrumentCommissionRate(HttpRequest& req, HttpResponse& res);
    // 查询报单手续费率 中金所持有
    static bool ReqQryInstrumentOrderCommRate(HttpRequest& req, HttpResponse& res);
    // 请求查询交易所保证金率
    static bool ReqQryExchangeMarginRate(HttpRequest& req, HttpResponse& res);
    // 请求查询交易所调整保证金率
    static bool ReqQryExchangeMarginRateAdjust(HttpRequest& req, HttpResponse& res);
    // 请求查询经纪公司交易参数
    static bool ReqQryBrokerTradingParams(HttpRequest& req, HttpResponse& res);

    // 请求查询报单
    static bool ReqQryOrder(HttpRequest& req, HttpResponse& res);
    // 请求查询成交
    static bool ReqQryTrade(HttpRequest& req, HttpResponse& res);
    // 请求查询投资者持仓
    static bool ReqQryInvestorPosition(HttpRequest& req, HttpResponse& res);
    // 请求查询投资者持仓明细
    static bool ReqQryInvestorPositionDetail(HttpRequest& req, HttpResponse& res);


    // 请求查询行情
    static bool ReqQryDepthMarketData(HttpRequest& req, HttpResponse& res);
    // 请求查询投资者结算结果
    static bool ReqQrySettlementInfo(HttpRequest& req, HttpResponse& res);
    // 投资者结果确认
    static bool ReqSettlementInfoConfirm(HttpRequest& req, HttpResponse& res);
    // 查询结算信息确认
    static bool ReqQrySettlementInfoConfirm(HttpRequest& req, HttpResponse& res);


    // 请求报单录入
    static bool ReqOrderInsert(HttpRequest& req, HttpResponse& res);
    // 报单操作请求
    static bool ReqOrderAction(HttpRequest& req, HttpResponse& res);

    static bool ReqUserLogout(HttpRequest& req, HttpResponse& res);


public:
//    static CustomTradeSpi *m_pTradeSpi;
     static vector<pair<const char *, CustomTradeSpi*>> sm_vTrade;
};

