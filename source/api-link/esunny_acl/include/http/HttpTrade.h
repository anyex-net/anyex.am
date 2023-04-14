#pragma once
#include "stdafx.h"
class HttpTrade {
public:
    HttpTrade();
    ~HttpTrade();

    void start(const char* addrs);

private:
    static bool QryCurrencyInfo(HttpRequest&, HttpResponse& res);
    static bool QryExchangeInfo(HttpRequest&, HttpResponse& res);
    static bool QryAccountInfo(HttpRequest&, HttpResponse& res);
    static bool QryCommodity(HttpRequest&, HttpResponse& res);
    static bool QryExchangeContract(HttpRequest&, HttpResponse& res);
    static bool QryFundData(HttpRequest&, HttpResponse& res);
    static bool QryPositionInfo(HttpRequest&, HttpResponse& res);
    static bool QryPositionSummaryInfo(HttpRequest&, HttpResponse& res);
    static bool QryOrderInfo(HttpRequest&, HttpResponse& res);
    static bool QryFillInfo(HttpRequest&, HttpResponse& res);
    static bool QryOrderInfoByOrderNo(HttpRequest&, HttpResponse& res);
    static bool QryFillInfoByOrderNo(HttpRequest&, HttpResponse& res);
    static bool InsertOrder(HttpRequest&, HttpResponse& res);
    static bool CancelOrder(HttpRequest&, HttpResponse& res);
    static bool ConnectTrade(HttpRequest&, HttpResponse& res);
    static bool DisConnectTrade(HttpRequest&, HttpResponse& res);
    // Rent
    static bool QryAccountFeeRent(HttpRequest&, HttpResponse& res);
    static bool QryAccountMarginRent(HttpRequest&, HttpResponse& res);
};

