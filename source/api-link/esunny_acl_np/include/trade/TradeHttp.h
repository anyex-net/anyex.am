#pragma once
#include "http/stdafx.h"
class TradeHttp {
public:
    TradeHttp();
    ~TradeHttp();

    void start(const char* addrs);

private:
    /// 交易相关操作
    static bool InsertOrder(HttpRequest&, HttpResponse&);
    static bool CancelOrder(HttpRequest&, HttpResponse&);
    /// 查询用户交易信息
    static bool QryOrderInfo(HttpRequest&, HttpResponse&);
    static bool QryFillInfo(HttpRequest&, HttpResponse&);
    static bool QryPositionInfo(HttpRequest&, HttpResponse&);
    static bool QryCloseInfo(HttpRequest&, HttpResponse&);
    /// 查询用户资金账号
    static bool QryAccountInfo(HttpRequest&, HttpResponse&);
    static bool QryFundData(HttpRequest&, HttpResponse&);
    /// 公共查询
    static bool QryExchangeInfo(HttpRequest&, HttpResponse&);
    static bool QryCommodityInfo(HttpRequest&, HttpResponse&);
    static bool QryContractInfo(HttpRequest&, HttpResponse&);

    /// 查询客户最终费率
    static bool QryAccountRentInfo(HttpRequest&, HttpResponse&);

    static bool ConnectTrade(HttpRequest&, HttpResponse&);
    static bool DisConnectTrade(HttpRequest&, HttpResponse&);
};

