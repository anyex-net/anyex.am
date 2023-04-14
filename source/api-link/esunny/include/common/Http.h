//
// Created by root on 2/24/21.
//

#ifndef ESUNNY_C_HTTP_H
#define ESUNNY_C_HTTP_H
#include "../../include/common/httplib.h"

using namespace httplib;

class Http {
public:
    Http();
    ~Http();

    static void testHttp(const Request &req, Response &res);

    // Trade
    // GET
    void initTradeServer(const char* host, int port);
    static void QryCurrencyInfo(const Request &req, Response &res);
    static void QryExchangeInfo(const Request &req, Response &res);
    static void QryCommodity(const Request &req, Response &res);
    static void QryExchangeContract(const Request &req, Response &res);
    static void QryAccountInfo(const Request &req, Response &res);
    static void QryFundData(const Request &req, Response &res);
    static void QryPositionInfo(const Request &req, Response &res);
    static void QryOrderInfo(const Request &req, Response &res);
    static void QryFillInfo(const Request &req, Response &res);
    static void QryOrderInfoByOrderNo(const Request &req, Response &res);
    static void QryFillInfoByOrderNo(const Request &req, Response &res);
    static void ConnectTrade(const Request &req, Response &res);
    static void DisConnectTrade(const Request &req, Response &res);
    // POST
    static void InsertOrder(const Request &req, Response &res);
    static void CancelOrder(const Request &req, Response &res);

    // Quote
    void initQuoteServer(const char* host, int port);
    static void SubscribeQuote(const Request &req, Response &res);
    static void UnSubscribeQuote(const Request &req, Response &res);
    static void ConnectQuote(const Request &req, Response &res);
    static void DisConnectQuote(const Request &req, Response &res);

private:
    static std::string getParams(const Request &req, std::string key);
    static std::string validateParameter(
            const Request &req, Response &res, bool &param_flag, std::string key, std::string &value);
};


#endif //ESUNNY_C_HTTP_H
