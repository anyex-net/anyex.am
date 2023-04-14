//
// Created by root on 3/15/21.
//

#include "../../include/tool/gtest/gtest.h"
#include "gtest_trade.h"

// QryFillInfo 查询成交
TEST(QryFillInfoTest, QryFill)
{
    for (int i =0; i < 100; i++) {
        EXPECT_EQ("0", QryFillInfo("0"));
    }
}

// QryPositionInfo 查询账户持仓
TEST(QryPositionInfoTest, QryPosition)
{
    EXPECT_EQ("0", QryPositionInfo("0"));
}

// QryOrderInfo 查询订单
TEST(QryOrderInfoTest, QryOrderInfo)
{
    EXPECT_EQ("0", QryOrderInfo("0"));
}

// QryOrderInfoByOrderNo 根据订单号查成交订单
TEST(QryOrderInfoByOrderNoTest, QryOrderInfoByOrderNo)
{

    EXPECT_EQ("0", QryOrderInfoByOrderNo("0"));
}

// QryFillInfoByOrderNo 根据订单号查成交订单
TEST(QryFillInfoTestByOrderNo, QryFillInfoByOrderNo)
{
    EXPECT_EQ("0", QryOrderInfoByOrderNo("0"));
}

// InsertOrder
TEST(InsertOrderTest, InsertOrder)
{
    for (int i = 0; i < 100; ++i) {
        EXPECT_EQ("0", InsertOrder("0"));
    }

}

// CancelOrder 取消订单
TEST(CancelOrderTest, CancelOrder)
{
    for (int i = 0; i < 100; ++i) {
    EXPECT_EQ("0", CancelOrder("0"));
    }

}

/// Common
// QryCommodity 查询所有品种信息
TEST(QryCommodityTest, QryCommodity)
{
//    for (int i = 0; i < 100; ++i) {
    EXPECT_EQ("0", QryCommodity("0"));
//    }

}

// QryCurrencyInfo 查询所有币种信息
TEST(QryCurrencyInfoTest, QryCurrencyInfo)
{
//    for (int i = 0; i < 100; ++i) {
    EXPECT_EQ("0", QryCurrencyInfo("0"));
//    }

}

// CancelOrder 查询所有交易所信息
TEST(QryExchangeInfoTest, QryExchangeInfo)
{
//    for (int i = 0; i < 100; ++i) {
    EXPECT_EQ("0", QryExchangeInfo("0"));
//    }

}

// QryAccountInfo 查询客户信息
TEST(QryAccountInfoTest, QryAccountInfo)
{
//    for (int i = 0; i < 10; ++i) {
    EXPECT_EQ("0", QryAccountInfo("0"));
//    }

}

// QryExchangeContract 查询交易所合约信息
TEST(QryExchangeContractTest, QryExchangeContract)
{
//    for (int i = 0; i < 100; ++i) {
    EXPECT_EQ("0", QryExchangeContract("0"));
//    }

}

// QryFundData 查询客户资金
TEST(QryFundDataTest, QryFundData)
{
//    for (int i = 0; i < 100; ++i) {
    EXPECT_EQ("0", QryFundData("0"));
//    }

}