//
// Created by root on 4/8/21.
//

#include <memory>
#include <iostream>
#include <HttpTrade.h>
#include "Account.h"
#include "TradeThread.h"
#include "Init.h"
#include "utils/EsunnyUtil.h"
#include <InitQuote.h>
#include <signal.h>

extern char *server_type;
extern char *server_mode;
extern char *single_account;
extern char *kafka_enable;
extern std::map<acl::string, std::shared_ptr<Account>> TRADE_ACCOUNTS;
vector<pair<acl::string, Trade*>> trade_vector;
extern rd_kafka_t *rk;

//static void stop(int sig){
//    if (kafka_enable) {
////        logger_error("Flushing final message.. ");
////        /*rd_kafka_flush是rd_kafka_poll()的抽象化，
////        等待所有未完成的produce请求完成，通常在销毁producer实例前完成
////        以确保所有排列中和正在传输的produce请求在销毁前完成*/
////        rd_kafka_flush(rk, 10*1000);
////
////        /* Destroy the producer instance */
////        rd_kafka_destroy(rk);
//    } else {
//
//    }
//
//
//}

int main(int argc, char* argv[])
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

    /*用于中断的信号 Press Ctrl-C or Ctrl-D to exit*/
//    signal(SIGINT, stop);

    if (strcmp(server_type, "quoteServer") == 0) {
        // 行情进程
        logger("启动行情");
        int res = initQuote::initQuoteProcess();
        return res;
    } else if (strcmp(server_type, "tradeServer") == 0){
        logger("启动交易");
        if (strcmp(server_mode, "singleAccount") == 0) {
            bool single_account_flag = false;
            for (auto iter=TRADE_ACCOUNTS.begin(); iter!=TRADE_ACCOUNTS.end(); ++iter) {
                if (strcmp(single_account, (iter->first).c_str()) == 0) {
                    single_account_flag = true;
                    break;
                }
            }

            if (!single_account_flag) {
                logger_error("参数填入错误, single_account: %s", single_account);
                return -1;
            }

            logger("交易单用户模式启动");
            TradeThread tradeThread;
            tradeThread.AccountNo = single_account;
//            tradeThread.set_detachable(false);
            if (tradeThread.start() == false)
            {
                logger_error("start tradeThread failed");
                return -1;
            }
            trade_vector.push_back(make_pair(single_account, &tradeThread.objTrade));

            // 初始化http
            HttpTrade httpTrade;
            const char *port = "|9002";
            httpTrade.start(port);

        } else if (strcmp(server_mode, "multiAccount") == 0) {
            logger("交易多用户模式启动");
            // trade
            int trade_thread_num = TRADE_ACCOUNTS.size();
            logger_debug(DEBUG_TEST1, 1, "trade_thread_num=%d", trade_thread_num);
            TradeThread tradeThread[trade_thread_num];
            int i = 0;
            for (auto iter=TRADE_ACCOUNTS.begin(); iter!=TRADE_ACCOUNTS.end(); ++iter, ++i) {
                logger("启动用户 %s", (iter->first).c_str());
                tradeThread[i].AccountNo = iter->first;
                if (tradeThread[i].start() == false)
                {
                    logger_error("start tradeThread[%d] failed", i);
                    return -1;
                }
                Trade *tradeThread1_objTrade = &(tradeThread[i].objTrade);
                trade_vector.push_back(make_pair(iter->first, tradeThread1_objTrade));
            }
            // 初始化http
            HttpTrade httpTrade;
            const char *port = "|9002";
            httpTrade.start(port);
        } else {
            logger_error("参数填入错误, server_mode: %s", server_mode);
            return -1;
        }
    } else {
        logger_error("参数填入错误, server_type: %s", server_type);
        return -1;
    }

    logger("The main process exits correctly!");
    logger_close();

    return 0;
}