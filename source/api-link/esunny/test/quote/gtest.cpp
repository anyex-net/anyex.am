//
// Created by root on 3/17/21.
//

#include "../../include/tool/gtest/gtest.h"
#include "gtest_quote.h"

// SubscribeQuoteWhole 订阅行情
TEST(SubscribeQuoteWholeTest, SubscribeQuoteWhole)
{
//    for (int i = 0; i < 100; ++i) {
EXPECT_EQ("0", SubscribeQuoteWhole("0"));
//    }

}

// UnSubscribeQuoteWhole 取消订阅行情
TEST(UnSubscribeQuoteWholeTest, UnSubscribeQuoteWhole)
{
    for (int i = 0; i < 100; ++i) {
        EXPECT_EQ("0", UnSubscribeQuoteWhole("0"));
    }

}
