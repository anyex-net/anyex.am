//
// Created by root on 3/15/21.
//
#include "../../include/common/httplib.h"
#include "gtest_trade.h"

using namespace httplib;
Client client("http://192.168.31.7:1234");


std::string QryFillInfo(std::string errorCode)
{
//    Client client("http://192.168.31.7:1234");

    std::multimap<std::string, std::string, detail::ci> headers;
    headers.insert({
                           {"AccountNo", "RDGJ06"}
    });
    Result res = client.Get("/QryFillInfo", headers);
    if (res) {
        errorCode = res->body;
        return errorCode;
    }
}

std::string QryPositionInfo(std::string errorCode)
{
//    Client client("http://192.168.31.7:1234");

    std::multimap<std::string, std::string, detail::ci> headers;
    headers.insert({
                           {"AccountNo", "RDGJ06"}
                   });
    Result res = client.Get("/QryPositionInfo", headers);
    if (res) {
        errorCode = res->body;
        return errorCode;
    }
}

std::string QryOrderInfo(std::string errorCode)
{
    std::multimap<std::string, std::string, detail::ci> headers;
    headers.insert({
                           {"AccountNo", "RDGJ06"}
                   });
    Result res = client.Get("/QryOrderInfo", headers);
    if (res) {
        errorCode = res->body;
        std::cout << errorCode << std::endl;
        return errorCode;
    }
}

std::string QryOrderInfoByOrderNo(std::string errorCode)
{
    std::multimap<std::string, std::string, detail::ci> headers;
    headers.insert({
                           {"AccountNo", "RDGJ06"},
                           {"OrderNo", "OA202103160000075500"}
                   });
    Result res = client.Get("/QryOrderInfoByOrderNo", headers);
    if (res) {
        errorCode = res->body;
        return errorCode;
    }
}

std::string QryFillInfoByOrderNo(std::string errorCode)
{
    std::multimap<std::string, std::string, detail::ci> headers;
    headers.insert({
                           {"AccountNo", "RDGJ06"},
                           {"OrderNo", "OA202103160000075500"}
                   });
    Result res = client.Get("/QryFillInfoByOrderNo", headers);
    if (res) {
        errorCode = res->body;
        return errorCode;
    }
}

std::string InsertOrder(std::string errorCode) {
    std::multimap<std::string, std::string, detail::ci> headers;
    std::multimap<std::string, std::string> params;
    headers.insert({
                           {"AccountNo",   "RDGJ06"},
                           {"ExchangeNo",  "NYMEX"},
                           {"CommodityNo",  "CL"},
                           {"ContractNo",  "2105"},
                           {"OrderType",   "2"},
                           {"TimeInForce", "0"},
                           {"OrderSide",   "B"},
                           {"OrderPrice",  "71"},
                           {"OrderQty",    "1"}
                   });
    Result res = client.Post("/InsertOrder", headers, params);
    if (res) {
        errorCode = res->body;
        return errorCode;
    }
}

std::string CancelOrder(std::string errorCode) {
    std::multimap<std::string, std::string, detail::ci> headers;
    std::multimap<std::string, std::string> params;
    headers.insert({
                           {"AccountNo",   "RDGJ06"},
                           {"OrderNo",  "OA202103170000008703"},
                   });
    Result res = client.Post("/CancelOrder", headers, params);
    if (res) {
        errorCode = res->body;
        return errorCode;
    }
}


/// Common
std::string QryCommodity(std::string errorCode) {
    std::multimap<std::string, std::string, detail::ci> headers;
    headers.insert({
                           {"AccountNo",   "RDGJ06"}
                   });
    Result res = client.Get("/QryCommodity", headers);
    if (res) {
        errorCode = res->body;
        return errorCode;
    }
}

std::string QryCurrencyInfo(std::string errorCode) {
    std::multimap<std::string, std::string, detail::ci> headers;
    headers.insert({
                           {"AccountNo",   "RDGJ06"}
                   });
    Result res = client.Get("/QryCurrencyInfo", headers);
    if (res) {
        errorCode = res->body;
        return errorCode;
    }
}

std::string QryExchangeInfo(std::string errorCode) {
    std::multimap<std::string, std::string, detail::ci> headers;
    headers.insert({
                           {"AccountNo",   "RDGJ06"}
                   });
    Result res = client.Get("/QryExchangeInfo", headers);
    if (res) {
        errorCode = res->body;
        return errorCode;
    }
}

std::string QryAccountInfo(std::string errorCode) {
    std::multimap<std::string, std::string, detail::ci> headers;
    headers.insert({
                           {"AccountNo",   "RDGJ06"}
                   });
    Result res = client.Get("/QryAccountInfo", headers);
    if (res) {
        errorCode = res->body;
        return errorCode;
    }
}

std::string QryExchangeContract(std::string errorCode) {
    std::multimap<std::string, std::string, detail::ci> headers;
    headers.insert({
                           {"AccountNo",   "RDGJ06"},
                           {"ExchangeNo",   "COMEX"}
                   });
    Result res = client.Get("/QryExchangeContract", headers);
    if (res) {
        errorCode = res->body;
        return errorCode;
    }
}


std::string QryFundData(std::string errorCode) {
    std::multimap<std::string, std::string, detail::ci> headers;
    headers.insert({
                           {"AccountNo",   "RDGJ06"}
                   });
    Result res = client.Get("/QryFundData", headers);
    if (res) {
        errorCode = res->body;
        return errorCode;
    }
}