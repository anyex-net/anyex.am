//
// Created by root on 3/15/21.
//

#include "../../include/tool/gtest/gtest.h"
#include "gtest_trade.h"

// QryFillInfo ��ѯ�ɽ�
TEST(QryFillInfoTest, QryFill)
{
    for (int i =0; i < 100; i++) {
        EXPECT_EQ("0", QryFillInfo("0"));
    }
}

// QryPositionInfo ��ѯ�˻��ֲ�
TEST(QryPositionInfoTest, QryPosition)
{
    EXPECT_EQ("0", QryPositionInfo("0"));
}

// QryOrderInfo ��ѯ����
TEST(QryOrderInfoTest, QryOrderInfo)
{
    EXPECT_EQ("0", QryOrderInfo("0"));
}

// QryOrderInfoByOrderNo ���ݶ����Ų�ɽ�����
TEST(QryOrderInfoByOrderNoTest, QryOrderInfoByOrderNo)
{

    EXPECT_EQ("0", QryOrderInfoByOrderNo("0"));
}

// QryFillInfoByOrderNo ���ݶ����Ų�ɽ�����
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

// CancelOrder ȡ������
TEST(CancelOrderTest, CancelOrder)
{
    for (int i = 0; i < 100; ++i) {
    EXPECT_EQ("0", CancelOrder("0"));
    }

}

/// Common
// QryCommodity ��ѯ����Ʒ����Ϣ
TEST(QryCommodityTest, QryCommodity)
{
//    for (int i = 0; i < 100; ++i) {
    EXPECT_EQ("0", QryCommodity("0"));
//    }

}

// QryCurrencyInfo ��ѯ���б�����Ϣ
TEST(QryCurrencyInfoTest, QryCurrencyInfo)
{
//    for (int i = 0; i < 100; ++i) {
    EXPECT_EQ("0", QryCurrencyInfo("0"));
//    }

}

// CancelOrder ��ѯ���н�������Ϣ
TEST(QryExchangeInfoTest, QryExchangeInfo)
{
//    for (int i = 0; i < 100; ++i) {
    EXPECT_EQ("0", QryExchangeInfo("0"));
//    }

}

// QryAccountInfo ��ѯ�ͻ���Ϣ
TEST(QryAccountInfoTest, QryAccountInfo)
{
//    for (int i = 0; i < 10; ++i) {
    EXPECT_EQ("0", QryAccountInfo("0"));
//    }

}

// QryExchangeContract ��ѯ��������Լ��Ϣ
TEST(QryExchangeContractTest, QryExchangeContract)
{
//    for (int i = 0; i < 100; ++i) {
    EXPECT_EQ("0", QryExchangeContract("0"));
//    }

}

// QryFundData ��ѯ�ͻ��ʽ�
TEST(QryFundDataTest, QryFundData)
{
//    for (int i = 0; i < 100; ++i) {
    EXPECT_EQ("0", QryFundData("0"));
//    }

}