#pragma once

#include <vector>
#include <http/stdafx.h>

#include "TraderSpi.h"

class TraderHttp {
public:
    TraderHttp();
    ~TraderHttp();

//    static void setTradeApi(CustomTradeSpi *);
    void setTraderVector(std::vector<std::pair<const char *, TraderSpi*>> t);
    void start(const char* addrs);

private:

    // 请求报单录入
    static bool ReqOrderInsert(HttpRequest& req, HttpResponse& res);
    // 报单操作请求
    static bool ReqOrderAction(HttpRequest& req, HttpResponse& res);

    // 请求查询报单
    static bool ReqQryOrder(HttpRequest& req, HttpResponse& res);
    // 请求查询成交
    static bool ReqQryTrade(HttpRequest& req, HttpResponse& res);
    // 请求查询投资者持仓
    static bool ReqQryPosition(HttpRequest& req, HttpResponse& res);

    static bool ReqUserLogout(HttpRequest& req, HttpResponse& res);


    // 请求查询交易所
    static bool ReqQryExchange(HttpRequest& req, HttpResponse& res);
    // 查询证券信息
    static bool ReqQrySecurity(HttpRequest& req, HttpResponse& res);
    // 查询市场
    static bool ReqQryMarket(HttpRequest& req, HttpResponse& res);
    // 查询股东账户
    static bool ReqQryShareholderAccount(HttpRequest& req, HttpResponse& res);
    // 请求查询资金帐户
    static bool ReqQryTradingAccount(HttpRequest& req, HttpResponse& res);

    // 查询用户请求
    static bool ReqQryUser(HttpRequest& req, HttpResponse& res);
    // 查询投资者请求
    static bool ReqQryInvestor(HttpRequest& req, HttpResponse& res);

    // 查询佣金费率
    static bool ReqQryInvestorTradingFee(HttpRequest &req, HttpResponse &res);
    // 查询基础交易费率响应
    static bool ReqQryTradingFee(HttpRequest &req, HttpResponse &res);

    static bool ReqQryOrderFundDetail(HttpRequest &req, HttpResponse &res);

private:
//    static CustomTradeSpi *m_pTradeSpi;
    static std::vector<std::pair<const char *, TraderSpi*>> sm_vTrader;
//    static bool findThreadByInvestorID(HttpRequest& req, HttpResponse& res);
};
