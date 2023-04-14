//
// Created by root on 3/15/21.
//

#ifndef ESUNNYSERVER_GTEST_TRADE_H
#define ESUNNYSERVER_GTEST_TRADE_H

std::string QryFillInfo(std::string errorCode);
std::string QryPositionInfo(std::string errorCode);
std::string QryOrderInfo(std::string errorCode);
std::string QryOrderInfoByOrderNo(std::string errorCode);
std::string QryFillInfoByOrderNo(std::string errorCode);
std::string InsertOrder(std::string errorCode);
std::string CancelOrder(std::string errorCode);

/// Common
std::string QryCommodity(std::string errorCode);
std::string QryCurrencyInfo(std::string errorCode);
std::string QryExchangeInfo(std::string errorCode);
std::string QryAccountInfo(std::string errorCode);
std::string QryExchangeContract(std::string errorCode);
std::string QryFundData(std::string errorCode);
#endif //ESUNNYSERVER_GTEST_TRADE_H
