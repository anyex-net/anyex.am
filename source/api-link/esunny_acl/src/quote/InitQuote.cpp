//
// Created by root on 4/12/21.
//

#include "../http/HttpQuote.h"
#include <../common/Account.h>
#include <iostream>
#include "../thread/QuoteThread.h"
#include "../quote/InitQuote.h"
#include "../common/utils/EsunnyUtil.h"

extern char *server_mode;
extern char *single_account;
extern std::map<acl::string, std::shared_ptr<Account>> QUOTE_ACCOUNTS;
std::vector<std::pair<acl::string, Quote *>> quote_vector;

int initQuote::initQuoteProcess(){

    if (strcmp(server_mode, "singleAccount") == 0) {
        bool quote_account_flag = false;
        for (auto iter=QUOTE_ACCOUNTS.begin(); iter!=QUOTE_ACCOUNTS.end(); iter++) {
            std::cout << "accountNo=" << iter->first.c_str() << std::endl;
            if (strcmp(single_account, (iter->first).c_str()) == 0) {
                quote_account_flag = true;
                break;
            }
        }
        if (!quote_account_flag) {
            logger_error("参数填入错误, single_account: %s", single_account);
            return -1;
        }

        logger("行情单用户模式启动");
        QuoteThread quoteThread;
        quoteThread.AccountNo = single_account;
        quoteThread.objQuote.setAccount(QUOTE_ACCOUNTS[single_account]);
//    quoteThread.set_detachable(false);
        if (quoteThread.start() == false)
        {
            logger_error("start quoteThread failed");
            return -1;
        }
        quote_vector.push_back(std::make_pair(single_account, &quoteThread.objQuote));

        HttpQuote httpQuote;
        const char *port = "|9001";
        httpQuote.start(port);
        return 0;

    } else if (strcmp(server_mode, "multiAccount") == 0){
        logger("行情多用户模式启动");
        int quote_thread_num = QUOTE_ACCOUNTS.size();
        logger_debug(DEBUG_TEST1, 1, "quote_thread_num=%d", quote_thread_num);
        std::cout << "quote_thread_num=" << quote_thread_num << std::endl;
        QuoteThread quoteThread[quote_thread_num];
        int i = 0;
        for (auto iter=QUOTE_ACCOUNTS.begin(); iter!=QUOTE_ACCOUNTS.end(); iter++, i++) {
            logger("启动用户 %s", (iter->first).c_str());
            quoteThread[i].AccountNo = iter->first;
            if (quoteThread[i].start() == false)
            {
                logger_error("start quoteThread[%d] failed", i);
                return -1;
            }
            Quote *quoteThread_objQuote = &(quoteThread[i].objQuote);
            quote_vector.push_back(std::make_pair(iter->first, quoteThread_objQuote));
        }
        // 初始化http
        HttpQuote httpQuote;
        const char *port = "|9001";
        httpQuote.start(port);
    } else {
        logger_error("参数填入错误, server_mode: %s", server_mode);
        return -1;
    }
}