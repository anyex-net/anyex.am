//
// Created by root on 8/4/21.
//

#include "trade/InitTrade.h"
#include "common/InitParams.h"
#include <acl_cpp/stdlib/log.hpp>
#include "trade/TradeHttp.h"
#include "trade/TradeThread.h"

std::vector<std::pair<acl::string, Trade*>> trade_vector;

int initTradeThreads()
{
    if (strcmp(server_mode, "singleAccount") == 0) {
        bool single_account_flag = false;
        for (auto iter=ACCOUNTS.begin(); iter!=ACCOUNTS.end(); iter++) {
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
        trade_vector.push_back(std::make_pair(single_account, &tradeThread.objTrade));

        // 初始化http
        TradeHttp TradeHttp;
        const char *port = "|9202";
        TradeHttp.start(port);

    } else if (strcmp(server_mode, "multiAccount") == 0) {
        logger("交易多用户模式启动");
        // trade
        int trade_thread_num = ACCOUNTS.size();
        logger_debug(DEBUG_TEST1, 1, "trade_thread_num=%d", trade_thread_num);
        TradeThread tradeThread[trade_thread_num];
        int i = 0;
        for (auto iter=ACCOUNTS.begin(); iter!=ACCOUNTS.end(); iter++, i++) {
            logger("启动用户 %s", (iter->first).c_str());
            tradeThread[i].AccountNo = iter->first;
            if (tradeThread[i].start() == false)
            {
                logger_error("start tradeThread[%d] failed", i);
                return -1;
            }
            Trade *tradeThread1_objTrade = &(tradeThread[i].objTrade);
            trade_vector.push_back(std::make_pair(iter->first, tradeThread1_objTrade));
        }
        // 初始化http
        TradeHttp TradeHttp;
        const char *port = "|9202";
        TradeHttp.start(port);
    } else {
        logger_error("参数填入错误, server_mode: %s", server_mode);
        return -1;
    }
}