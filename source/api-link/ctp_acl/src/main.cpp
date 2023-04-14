//
// Created by root on 5/10/21.
//
#include <iostream>
#include <map>
#include <memory>
#include "../include/Init.h"
#include <Account.h>
#include <ThostFtdcMdApi.h>
#include <ThostFtdcTraderApi.h>
#include <thread>
#include "../include/http/MdHttp.h"
#include "../include/http/TradeHttp.h"

extern char *kafka_enable;
extern char *server_type;
extern char *server_mode;
extern char *single_account;

extern std::map<acl::string, std::shared_ptr<Account>> ACCOUNTS;
extern rd_kafka_t *rk;
extern acl::redis_pubsub redis_pubsub;

#ifdef CTP
static const char* md_port = "9101";
static const char* trade_port = "9102";
#endif
#ifdef STP
static const char* md_port = "9401";
static const char* trade_port = "9402";
#endif
#ifdef OPENCTP
static const char* md_port = "9501";
static const char* trade_port = "9502";
#endif

int main(int argc, char* argv[])
{
    // 初始化配置文件
    ctp::init::initConfiguration();
    // 初始化日志
    ctp::init::initLog();
    // 连接 mysql 数据库
    ctp::init::connectToDatabase();
    // 使用kafka
    if (strcmp(kafka_enable, "true" ) == 0) {
        // 使用 kafka
        ctp::init::initKafka();
    } else {
        // 使用 redis
        ctp::init::initRedis();
    }

    if (strcmp(server_type, "mdServer") == 0) {
        // 行情
        logger("启动行情");
        if (strcmp(server_mode, "singleAccount") == 0) {
            logger("行情单用户模式启动");
            // 公共行情，不需要验证用户名和密码
            bool single_account_flag = false;
            for (auto iter = ACCOUNTS.begin(); iter != ACCOUNTS.end(); ++iter) {
//                logger("iter->first:%s, iter->second:%s", iter->first, iter->second);
                if (strcmp(single_account, iter->first.c_str()) == 0) {
                    single_account_flag = true;
                    break;
                }
            }
            if (!single_account_flag) {
                logger_error("参数填入错误, single_account: %s", single_account);
                return -1;
            }
#ifdef CTP
            std::string path = "logs/md/tmp/";
            path.append(single_account).append("/");
            CtpUtil::CreateDirs(path);
            logger("path=%s", path.c_str());
            CThostFtdcMdApi *g_pMdUserApi = CThostFtdcMdApi::CreateFtdcMdApi(path.c_str()); // 创建行情实例
#else
            CThostFtdcMdApi *g_pMdUserApi = CThostFtdcMdApi::CreateFtdcMdApi(); // 创建行情实例
#endif

            logger("MdApiVersion: %s", g_pMdUserApi->GetApiVersion());
            CustomMdSpi *pUserMdSpi = new CustomMdSpi();    // 创建行情回调实例
            g_pMdUserApi->RegisterSpi(pUserMdSpi);  // 注册事件类
            // 设置行情前置地址
            g_pMdUserApi->RegisterFront((ACCOUNTS[single_account]->getFrontMdAddress()).c_str());
            g_pMdUserApi->Init();   // 连接运行
            pUserMdSpi->SetMdApi(g_pMdUserApi);
            pUserMdSpi->SetAccount(ACCOUNTS[single_account]);
            std::vector<std::pair<const char *, CustomMdSpi*>> md_vector;
            md_vector.push_back(std::make_pair(single_account, pUserMdSpi));

            // http 转发, 行情的地址与端口皆取自数据库
            MdHttp mdHttp;
            mdHttp.SetMdVector(md_vector);
            std::thread mdHttpThread(&MdHttp::start, mdHttp, md_port);
#ifdef OPENCTP
            mdHttpThread.join();
#endif

            // 等到行情退出
            g_pMdUserApi->Join();
            delete pUserMdSpi;
            pUserMdSpi = NULL;
//        g_pMdUserApi->Release();
        } else if (strcmp(server_mode, "multiAccount") == 0) {
            logger("行情多用户模式启动");
            // md
            int md_thread_num = ACCOUNTS.size();
            CThostFtdcMdApi *g_pMdUserApi[md_thread_num];
            CustomMdSpi *pUserMdSpi[md_thread_num];
            std::vector<std::pair<const char *, CustomMdSpi*>> md_vector;
            int i = 0;
            for (auto iter = ACCOUNTS.begin(); iter != ACCOUNTS.end(); ++iter, ++i) {
#ifdef CTP
                std::string path = "logs/md/tmp/";
                path.append(iter->first).append("/");
                CtpUtil::CreateDirs(path);
                logger("path=%s", path.c_str());
                g_pMdUserApi[i] = CThostFtdcMdApi::CreateFtdcMdApi(path.c_str()); // 创建行实例
#else
                g_pMdUserApi[i] = CThostFtdcMdApi::CreateFtdcMdApi(); // 创建行实例
#endif

                logger("MdApiVersion: %s", g_pMdUserApi[i]->GetApiVersion());
                pUserMdSpi[i] = new CustomMdSpi();               // 创建行回调实例
                g_pMdUserApi[i]->RegisterSpi(pUserMdSpi[i]);                      // 注册事件类
                // 设置行情前置地址
                g_pMdUserApi[i]->RegisterFront((ACCOUNTS[iter->first]->getFrontMdAddress()).c_str());
                g_pMdUserApi[i]->Init();                                      // 连接运行
                pUserMdSpi[i]->SetMdApi(g_pMdUserApi[i]);
                pUserMdSpi[i]->SetAccount(iter->second);
                logger("id=%s", iter->first.c_str());
                md_vector.push_back(std::make_pair(iter->first.c_str(), pUserMdSpi[i]));
            }
            // 初始化http
            MdHttp *mdHttp = new MdHttp();
            mdHttp->SetMdVector(md_vector);
            std::thread mdHttpThread(&MdHttp::start, mdHttp, md_port);
#ifdef OPENCTP
            mdHttpThread.join();
#endif
            for (int j = 0; j < md_thread_num; j++) {
                g_pMdUserApi[j]->Join();
                delete pUserMdSpi[j];
                pUserMdSpi[j] = NULL;
//                g_pMdUserApi[j]->Release();
            }
            delete mdHttp;
        } else {
            logger_error("参数填入错误, server_mode: %s", server_mode);
            return -1;
        }

    } else if (strcmp(server_type, "tradeServer") == 0){    // 交易
        logger("启动交易");
        if (strcmp(server_mode, "singleAccount") == 0) {
            bool single_account_flag = false;
            for (auto iter = ACCOUNTS.begin(); iter != ACCOUNTS.end(); ++iter) {
//                logger("iter->first:%s, iter->second:%s", iter->first, iter->second);
                if (strcmp(single_account, iter->first.c_str()) == 0) {
                    single_account_flag = true;
                    break;
                }
            }

            if (!single_account_flag) {
                logger_error("参数填入错误, single_account: %s", single_account);
                return -1;
            }

            logger("交易单用户模式启动");
            // Trade
            // The file must exist and will not be created automatically
            std::string path = "logs/trade/tmp/";
            path.append(single_account).append("/");
            CtpUtil::CreateDirs(path);
            logger("path=%s", path.c_str());
            CThostFtdcTraderApi *g_pTradeUserApi = CThostFtdcTraderApi::CreateFtdcTraderApi(path.c_str()); // 创建交易实例
            logger("TradeApiVersion: %s", g_pTradeUserApi->GetApiVersion());
            CustomTradeSpi* pTradeSpi = new CustomTradeSpi();               // 创建交易回调实例
            g_pTradeUserApi->RegisterSpi(pTradeSpi);                      // 注册事件类
            g_pTradeUserApi->SubscribePublicTopic(THOST_TERT_RESTART);    // 订阅公共流
            g_pTradeUserApi->SubscribePrivateTopic(THOST_TERT_QUICK);   // 订阅私有流
            // 设置交易前置地址
            g_pTradeUserApi->RegisterFront((ACCOUNTS[single_account]->getFrontTradeAddress()).c_str());
            g_pTradeUserApi->Init();                                      // 连接运行
            pTradeSpi->SetTradeApi(g_pTradeUserApi);
            pTradeSpi->SetAccount(ACCOUNTS[single_account]);
            std::vector<std::pair<const char *, CustomTradeSpi*>> trade_vector;
            trade_vector.push_back(std::make_pair(single_account, pTradeSpi));

            // 初始化http
            TradeHttp tradeHttp;
            tradeHttp.setTradeVector(trade_vector);
            std::thread tradeHttpThread(&TradeHttp::start, tradeHttp, trade_port);

            g_pTradeUserApi->Join();
            g_pTradeUserApi = NULL;
            delete pTradeSpi;
            pTradeSpi = NULL;
//            delete tradeHttp;
//            tradeHttp = NULL;
//            g_pTradeUserApi->Release();
        } else if (strcmp(server_mode, "multiAccount") == 0) {
            logger("交易多用户模式启动");
            // trade
            int trade_thread_num = ACCOUNTS.size();
            std::cout << "trade_thread_num = " << trade_thread_num << std::endl;
            CThostFtdcTraderApi *g_pTradeUserApi[trade_thread_num];
            CustomTradeSpi *pTradeSpi[trade_thread_num];
            std::vector<std::pair<const char *, CustomTradeSpi*>> trade_vector;
            int i = 0;
            for (auto iter = ACCOUNTS.begin(); iter != ACCOUNTS.end(); ++iter, ++i) {
                std::string path = "logs/trade/tmp/";
                path.append(iter->first).append("/");
                CtpUtil::CreateDirs(path);
                logger("path=%s", path.c_str());
                g_pTradeUserApi[i] = CThostFtdcTraderApi::CreateFtdcTraderApi(path.c_str()); // 创建交易实例
                logger("TradeApiVersion: %s", g_pTradeUserApi[i]->GetApiVersion());
                pTradeSpi[i] = new CustomTradeSpi();               // 创建交易回调实例
                g_pTradeUserApi[i]->RegisterSpi(pTradeSpi[i]);                      // 注册事件类
                g_pTradeUserApi[i]->SubscribePublicTopic(THOST_TERT_RESTART);    // 订阅公共流
                g_pTradeUserApi[i]->SubscribePrivateTopic(THOST_TERT_QUICK);   // 订阅私有流
                // 设置交易前置地址
                g_pTradeUserApi[i]->RegisterFront((ACCOUNTS[iter->first]->getFrontTradeAddress()).c_str());
                g_pTradeUserApi[i]->Init();                                      // 连接运行
                pTradeSpi[i]->SetTradeApi(g_pTradeUserApi[i]);
                pTradeSpi[i]->SetAccount(iter->second);
                trade_vector.push_back(std::make_pair(iter->first.c_str(), pTradeSpi[i]));
            }
            // 初始化http
             TradeHttp *tradeHttp = new TradeHttp();
             tradeHttp->setTradeVector(trade_vector);
             std::thread tradeHttpThread(&TradeHttp::start, tradeHttp, trade_port);

            for (int j = 0; j < trade_thread_num; j++) {
                g_pTradeUserApi[j]->Join();
                delete pTradeSpi[j];
                pTradeSpi[j] = NULL;
//                g_pTradeUserApi[j]->Release();
            }
            delete tradeHttp;
        } else {
            logger_error("参数填入错误, server_mode: %s", server_mode);
            return -1;
        }
    } else {
        logger_error("参数填入错误, server_type: %s", server_type);
        return -1;
    }
    if (kafka_enable) {
        logger("Flushing final message.. ");
        /*rd_kafka_flush是rd_kafka_poll()的抽象化，
        等待所有未完成的produce请求完成，通常在销毁producer实例前完成
        以确保所有排列中和正在传输的produce请求在销毁前完成*/
        rd_kafka_flush(rk, 10*1000);

        /* Destroy the producer instance */
        rd_kafka_destroy(rk);
    } else {
        acl::redis_client_cluster *c = redis_pubsub.get_cluster();
        delete c;
        // 防止野指针
        c = NULL;
    }
    logger_close();
    logger("main process is end!");
    return 0;
}
