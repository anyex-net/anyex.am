//
// Created by root on 3/1/21.
//

#ifndef ESUNNY_INIT_H
#define ESUNNY_INIT_H

#endif //ESUNNY_INIT_H

#include "istream"
#include "../../include/tool/mysql/mysql.h"


namespace init
{
//    ITapQuoteAPI *pAPI;

    // 初始化日志
    void initLog();

    // 连接 mysql 数据库
    void connectToDatabase();

    // 初始化公共行情，并订阅行情
    void initQoute();

    // 初始化账户
    void initAccounts();

    // 初始化 redis++
    void initRedisPlusPlus();

    // 初始化httpTrade
    void initHttpTrade(const char* host, int port);

    // 初始化httpQuote
    void initHttpQuote(const char* host, int port);
}
