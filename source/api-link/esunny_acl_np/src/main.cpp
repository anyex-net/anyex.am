//
// Created by root on 8/4/21.
//
#include "common/Init.h"
#include "common/InitParams.h"
#include "quote/InitQuote.h"
#include "trade/InitTrade.h"

int main(int argc, char *argv[])
{
    // 初始化配置文件
    init::initConfiguration();

    // 初始化日志
    init::initLog();

    // 连接 mysql 数据库
    init::connectToDatabase();

    // kafka or redis
    if (strcmp(kafka_enable, "true") == 0) {
        init::initKafka();
    } else {
        init::initRedis();
    }

    if (strcmp(server_type, "quoteServer") == 0) {
        // 行情进程
        logger("启动行情");
        int rt = initQuoteThreads();
        return rt;
    } else if (strcmp(server_type, "tradeServer") == 0){
        logger("启动交易");
        int rt = initTradeThreads();
        return rt;
    } else {
        logger_error("参数填入错误, server_type: %s", server_type);
        return -1;
    }

    logger("The main process exits correctly!");
    logger_close();

    return 0;
}
