//
// Created by root on 3/17/21.
//

#include "../../include/tool/gtest/gtest.h"
#include "gtest_quote.h"

// SubscribeQuoteWhole ��������
TEST(SubscribeQuoteWholeTest, SubscribeQuoteWhole)
{
//    for (int i = 0; i < 100; ++i) {
EXPECT_EQ("0", SubscribeQuoteWhole("0"));
//    }

}

// UnSubscribeQuoteWhole ȡ����������
TEST(UnSubscribeQuoteWholeTest, UnSubscribeQuoteWhole)
{
    for (int i = 0; i < 100; ++i) {
        EXPECT_EQ("0", UnSubscribeQuoteWhole("0"));
    }

}
