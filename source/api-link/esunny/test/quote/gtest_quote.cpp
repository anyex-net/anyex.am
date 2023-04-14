//
// Created by root on 3/17/21.
//

#include "gtest_quote.h"
#include "../../include/common/httplib.h"

using namespace httplib;
Client q_client("http://192.168.31.7:9001");

std::string SubscribeQuoteWhole(std::string errorCode) {
    std::multimap<std::string, std::string, detail::ci> headers;
    headers.insert({
                           {"AccountNo",   "ES"},
                           {"ExchangeNo",   "COMEX"},
                           {"CommodityNo",   "HG"},
                           {"ContractNo",   "2108"}
                   });
    Result res = q_client.Get("/SubscribeQuoteWhole", headers);
    if (res) {
        errorCode = res->body;
        return errorCode;
    }
}

std::string UnSubscribeQuoteWhole(std::string errorCode) {
    std::multimap<std::string, std::string, detail::ci> headers;
    headers.insert({
                           {"AccountNo",   "ES"},
                           {"ExchangeNo",   "COMEX"},
                           {"CommodityNo",   "HG"},
                           {"ContractNo",   "2108"}
                   });
    Result res = q_client.Get("/UnSubscribeQuoteWhole", headers);
    if (res) {
        errorCode = res->body;
        return errorCode;
    }
}