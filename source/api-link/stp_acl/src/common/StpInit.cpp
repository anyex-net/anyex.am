//
// Created by root on 8/4/21.
//

#include <acl_cpp/stdlib/log.hpp>
#include "../../include/common/StpInit.h"
#include <acl_cpp/db/db_mysql.hpp>
#include <acl_cpp/db/query.hpp>
#include <stdlib/acl_xinetd_cfg.h>
#include <acl_cpp/stdlib/string.hpp>
#include <regex>
#include <stdlib/acl_argv.h>
#include "common/InitParams.h"
#include "common/StpUtil.h"
#include <stdlib/acl_msg.h>
#include <TORATstpXMdApi.h>
#include <md/MdSpi.h>
#include <md/MdHttp.h>
#include <thread>
#include <TORATstpTraderApi.h>
#include <trade/TraderSpi.h>
#include <trade/TraderHttp.h>
#include <iostream>

char *server_type;
char *server_mode;
char *single_account;
char *mysql_addr;
char *mysql_dbname;
char *mysql_username;
char *mysql_password;
char *redis_addr;
char *redis_password;
char *kafka_broker;
char *kafka_enable;
//char *md_list;
char *server_debug;
char *stdout_open;

static ACL_CFG_STR_TABLE __conf_str_tab[] = {
        /* 配置项名称, 配置项缺省值, 存储配置项值的地址 */
        { "server_type", "tradeServer", &server_type },
        { "server_mode", "singleAccount", &server_mode },
        { "single_account", "Q578432149", &single_account },
        { "mysql_addr", "127.0.0.1:3306", &mysql_addr },
        { "mysql_dbname", "mysql", &mysql_dbname },
        { "mysql_username", "root", &mysql_username },
        { "mysql_password", "root", &mysql_password },
        { "redis_addr", "127.0.0.1:6379", &redis_addr },
        { "redis_password", "", &redis_password },
        { "kafka_broker", "192.168.31.42:9092", &kafka_broker },
        { "kafka_enable", "true", &kafka_enable },
//        { "md_list", "", &md_list },
        { "server_debug", "", &server_debug },
        { "stdout_open", "", &stdout_open },
        { 0, 0, 0 }
};

static std::map<std::string, std::shared_ptr<Account>> ACCOUNTS;
rd_kafka_t *rk;
acl::redis_pubsub redis_pubsub;

// 初始化配置文件
void initConfiguration()
{
    ACL_XINETD_CFG_PARSER *cfg;  // 配置解析对象
    const char *filepath = "conf/stpServer.conf";
    cfg = acl_xinetd_cfg_load(filepath);  // 读取并解析配置文件
    if (NULL == cfg)
    {
        printf("加载配置文件:%s 错误: %s", filepath, acl_last_serror());
        exit(-1);
    }
    acl_xinetd_params_str_table(cfg, __conf_str_tab);  // 读取所有字符串类型的配置项

    printf("server_type=%s\r\n", server_type);
    printf("mysql_addr=%s\r\n", mysql_addr);
    printf("mysql_dbname=%s\r\n", mysql_dbname);
    printf("mysql_username=%s\r\n", mysql_username);
    printf("mysql_password=%s\r\n", mysql_password);
    printf("redis_addr=%s\r\n", redis_addr);
    printf("redis_password=%s\r\n", redis_password);
    printf("kafka_broker=%s\r\n", kafka_broker);
    printf("kafka_enable=%s\r\n", kafka_enable);
//    printf("md_list=%s\r\n", md_list);
    printf("server_debug=%s\r\n", server_debug);
    printf("stdout_open=%s\r\n", stdout_open);

    acl_xinetd_cfg_free(cfg);  // 释放内存
}

// 初始化日志
void initLog()
{
    if (strcmp(stdout_open, "true") == 0)
    {
        acl::log::stdout_open(true);
    }
    if (strcmp(server_type, "tradeServer") == 0)
    {
        StpUtil::CreateDirs("logs/trade");
        logger_open("logs/trade/tradeServer.log", "trade", server_debug);
    }
    if (strcmp(server_type, "mdServer") == 0)
    {
        StpUtil::CreateDirs("logs/md");
        logger_open("logs/md/mdServer.log", "md", server_debug);
    }
}

// 连接 mysql 数据库
void connectToDatabase()
{
    acl::db_mysql db(mysql_addr, mysql_dbname, mysql_username, mysql_password);
    // 打开数据库连接
    if (db.open() == false) {
        logger_error("open db(%s@%s) error",
                     mysql_password, mysql_password);
        getchar();
        exit(-1);
    }

    logger("open db %s ok", mysql_dbname);

    acl::query query;
    query.create_sql("select userID,investorID,password,mdFrontAddr,tradeFrontAddr"
                     " from StpNpSpotAccountInfo where 1=1");

    if (db.exec_select(query) == false) {
        logger_error("select sql error");
        exit(-1);
    }

    int account_num = (int) db.length();
    if (account_num == 0) {
        logger_error("StpNpSpotAccountInfo is NULL");
        logger_close();
        exit(0);
    } else {
        // 获取账户信息
        for (size_t i=0; i<db.length(); ++i)
        {
            const acl::db_row* row = db[i];
            const char *investorID_ptr = (*row)["investorID"];
            const char *userID_ptr = (*row)["userID"];
            const char *password_ptr = (*row)["password"];
            const char *mdFrontAddr_ptr = (*row)["mdFrontAddr"];
            const char *tradeFrontAddr_ptr = (*row)["tradeFrontAddr"];
            if (investorID_ptr == NULL || password_ptr == NULL || mdFrontAddr_ptr == NULL || tradeFrontAddr_ptr == NULL
                || (strcmp(investorID_ptr, "") == 0) || (strcmp(userID_ptr, "") == 0)|| (strcmp(password_ptr, "") == 0)
                || (strcmp(mdFrontAddr_ptr, "") == 0) || (strcmp(tradeFrontAddr_ptr, "") == 0) || (strcmp(userID_ptr, "") == 0))
            {
                logger_error("error, query tradeAccount is failed");
                continue;
            }
            // 校验行情与交易前置地址格式 address:port(xx.xx.xx.xx:xxxx)
            std::string mdFrontAddr_str(mdFrontAddr_ptr);
            std::string tradeFrontAddr_str(tradeFrontAddr_ptr);
            std::regex regex_str("^(\\d|[1-9]\\d|1\\d{2}|2[0-4]\\d|25[0-5])\\.(\\d|[1-9]\\d|1\\d{2}|2[0-4]\\d|25[0-5])\\"
                                 ".(\\d|[1-9]\\d|1\\d{2}|2[0-4]\\d|25[0-5])\\.(\\d|[1-9]\\d|1\\d{2}|2[0-4]\\d|25[0-5])"
                                 ":([0-9]|[1-9]\\d|[1-9]\\d{2}|[1-9]\\d{3}|[1-5]\\d{4}|6[0-4]\\d{3}|65[0-4]\\d{2}|655[0-2]\\d|6553[0-5])$");
            bool mdApiAddr_flag = std::regex_match(mdFrontAddr_str, regex_str);
            bool tradeApiAddr_flag = std::regex_match(tradeFrontAddr_str, regex_str);
            if ((!mdApiAddr_flag) || (!tradeApiAddr_flag))
            {
                logger_error("账户%s行情或交易前置机地址配置错误", investorID_ptr);
                continue;
            }

            std::string mdFrontAddr, tradeFrontAddr;
            mdFrontAddr.append("tcp://").append(mdFrontAddr_ptr);
            tradeFrontAddr.append("tcp://").append(tradeFrontAddr_ptr);

            auto account = std::make_shared<Account>();
            account->setInvestorId(investorID_ptr);
            account->setUserId(userID_ptr);
//            account->setAccountId("00318289");
//            account->setLoginInAccountType("0");
            account->setPassword(password_ptr);
//            account->setDepartmentId("0001");
            account->setMdFrontAddr(mdFrontAddr);
            account->setTraderFrontAddr(tradeFrontAddr);
            // 把账户放入全局变量中
            ACCOUNTS.insert(std::make_pair(investorID_ptr, account));
        }

        // 释放查询结果
        db.free_result();
    }
}

// 初始化 redis
void initRedis()
{
    int conn_timeout=10;//连接redis-server的超时时间（秒）
    int rw_timeout=10;//与redis-server进行通信IO的超时时间（秒）
    acl::redis_client_cluster *cluster = new acl::redis_client_cluster();
    cluster->set(redis_addr, 10, conn_timeout, rw_timeout);
    cluster->set_password(redis_addr, redis_password);
    redis_pubsub.set_cluster(cluster);
}

/*
    每条消息调用一次该回调函数，说明消息是传递成功(rkmessage->err == RD_KAFKA_RESP_ERR_NO_ERROR)
    还是传递失败(rkmessage->err != RD_KAFKA_RESP_ERR_NO_ERROR)
    该回调函数由rd_kafka_poll()触发，在应用程序的线程上执行
 */
static void dr_msg_cb(rd_kafka_t *rk,
                      const rd_kafka_message_t *rkmessage, void *opaque){
    if(rkmessage->err)
        logger_error("Message delivery failed: %s", rd_kafka_err2str(rkmessage->err));
    else
        logger_debug(DEBUG_TEST3, 3, "Message delivered (%zd bytes): %s", rkmessage->len, rd_kafka_err2str(rkmessage->err));
    /* rkmessage被librdkafka自动销毁*/
}

// 初始化 kafka
void initKafka()
{
    /*
     * C
     */
    char errstr[512];
    /* 创建一个kafka配置占位 */
    rd_kafka_conf_t *conf = rd_kafka_conf_new();

    /*创建broker集群*/
    if (rd_kafka_conf_set(conf, "bootstrap.servers", kafka_broker, errstr,
                          sizeof(errstr)) != RD_KAFKA_CONF_OK) {
        logger_error("%s", errstr);
        exit(1);
    }

    /*设置发送报告回调函数，rd_kafka_produce()接收的每条消息都会调用一次该回调函数
     *应用程序需要定期调用rd_kafka_poll()来服务排队的发送报告回调函数*/
    rd_kafka_conf_set_dr_msg_cb(conf, dr_msg_cb);

    /*创建producer实例
      rd_kafka_new()获取conf对象的所有权,应用程序在此调用之后不得再次引用它*/
    rk = rd_kafka_new(RD_KAFKA_PRODUCER, conf, errstr, sizeof(errstr));
    if(!rk){
        logger_error("%% Failed to create new producer:%s", errstr);
        exit(1);
    }

    /*实例化一个或多个topics(`rd_kafka_topic_t`)来提供生产或消费，topic
    对象保存topic特定的配置，并在内部填充所有可用分区和leader brokers，*/
//    rkt = rd_kafka_topic_new(rk, topic, NULL);
//    if (!rkt){
//        fprintf(stderr, "%% Failed to create topic object: %s\n",
//                rd_kafka_err2str(rd_kafka_last_error()));
//        rd_kafka_destroy(rk);
//        exit(1);
//    }
}

int initMdThreads()
{
    if (strcmp(server_mode, "singleAccount") == 0) {
        logger("行情单用户模式启动");

        // 公共行情，不需要验证用户名和密码
        bool single_account_flag = false;
        for (auto iter = ACCOUNTS.begin(); iter != ACCOUNTS.end(); iter++) {
//                logger("iter->first:%s, iter->second:%s", iter->first, iter->second);
            if (strcmp(single_account, iter->first.c_str()) == 0) {
                single_account_flag = true;
                break;
            }
        }
        if (!single_account_flag) {
            logger_error("参数single_account(%s)填入错误", single_account);
            return -1;
        }
        CTORATstpXMdApi *mdApi = CTORATstpXMdApi::CreateTstpXMdApi();
        logger("MdApiVersion: %s", mdApi->GetApiVersion());
        MdSpi mdSpi(mdApi, ACCOUNTS[single_account]);
        mdApi->RegisterSpi(&mdSpi);
        //        mdApi->RegisterFront("tcp://210.14.72.21:4402");
        mdApi->RegisterFront((char*)(ACCOUNTS[single_account]->getMdFrontAddr()).c_str());
        mdApi->Init();
        std::vector<std::pair<const char *, MdSpi*>> md_vector;
        md_vector.push_back(std::make_pair(single_account, &mdSpi));

        MdHttp mdHttp;
        mdHttp.setMdVector(md_vector);
        std::thread mdHttpThread(&MdHttp::start, mdHttp, "|9301");
        mdHttpThread.detach();

        // 等到行情退出
        mdApi->Join();
//        mdApi->Release();
    } else if (strcmp(server_mode, "multiAccount") == 0) {
        logger("行情多用户模式启动");
        // md
        int md_thread_num = ACCOUNTS.size();
        CTORATstpXMdApi *mdApi[md_thread_num];
        MdSpi *pUserMdSpi[md_thread_num];
        std::vector<std::pair<const char *, MdSpi*>> md_vector;
        int i = 0;
        for (auto iter = ACCOUNTS.begin(); iter != ACCOUNTS.end(); ++iter, ++i) {
            mdApi[i] = CTORATstpXMdApi::CreateTstpXMdApi();
            logger("MdApiVersion: %s", mdApi[i]->GetApiVersion());
            pUserMdSpi[i] = new MdSpi(mdApi[i], iter->second);
            mdApi[i]->RegisterSpi(pUserMdSpi[i]);
            // 设置行情前置地址
            //        mdApi->RegisterFront("tcp://210.14.72.21:4402");
            mdApi[i]->RegisterFront((char*)(iter->second->getMdFrontAddr()).c_str());
            mdApi[i]->Init();
//            mdApi[i]->SetAccount(iter->second);
            md_vector.push_back(std::make_pair(iter->first.c_str(), pUserMdSpi[i]));
        }
        // 初始化http
        MdHttp mdHttp;
        mdHttp.setMdVector(md_vector);
        std::thread mdHttpThread(&MdHttp::start, mdHttp, "|9301");
        mdHttpThread.detach();

        for (int j = 0; j < md_thread_num; j++) {
            mdApi[j]->Join();
            delete pUserMdSpi[j];
            pUserMdSpi[j] = NULL;
//                g_pMdUserApi[j]->Release();
        }
    } else {
        logger_error("参数server_mode(%s)填入错误", server_mode);
        return -1;
    }
}

int initTraderThreads()
{
    if (strcmp(server_mode, "singleAccount") == 0) {
        bool single_account_flag = false;
        for (auto iter = ACCOUNTS.begin(); iter != ACCOUNTS.end(); iter++) {
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
        // Trader
        // The file must exist and will not be created automatically
        std::string path = "logs/trade/tmp/";
        path.append(single_account).append("/");
        StpUtil::CreateDirs(path);
        logger("path=%s", path.c_str());
        CTORATstpTraderApi *traderApi = CTORATstpTraderApi::CreateTstpTraderApi(path.c_str());
        logger("TradeApiVersion: %s", traderApi->GetApiVersion());
        TraderSpi traderSpi(traderApi,ACCOUNTS[single_account]);
        traderApi->RegisterSpi(&traderSpi);
//        traderApi->RegisterFront("tcp://210.14.72.21:4400");
        char *front_addr = (char*)(ACCOUNTS[single_account]->getTraderFrontAddr()).c_str();
        traderApi->RegisterFront(front_addr);
        traderApi->SubscribePrivateTopic(TORASTOCKAPI::TORA_TERT_QUICK);
        traderApi->SubscribePublicTopic(TORASTOCKAPI::TORA_TERT_RESTART);
        traderApi->Init();
//        traderSpi.setAccount(ACCOUNTS[single_account]);
        std::vector<std::pair<const char *, TraderSpi*>> trader_vector;
        trader_vector.push_back(std::make_pair(single_account, &traderSpi));

        // 初始化http
        TraderHttp traderHttp;
        traderHttp.setTraderVector(trader_vector);
        std::thread traderHttpThread(&TraderHttp::start, traderHttp, "|9302");
        traderHttpThread.detach();

        traderApi->Join();
        traderApi = NULL;
//            delete tradeHttp;
//            tradeHttp = NULL;
//            g_pTradeUserApi->Release();
    } else if (strcmp(server_mode, "multiAccount") == 0) {
        logger("交易多用户模式启动");
        int trade_thread_num = ACCOUNTS.size();
        CTORATstpTraderApi *traderApi[trade_thread_num];
        TraderSpi *traderSpi[trade_thread_num];
        int i=0;
        std::vector<std::pair<const char *, TraderSpi*>> trader_vector;
        for (auto iter = ACCOUNTS.begin(); iter != ACCOUNTS.end(); ++iter, ++i) {
            std::string path = "logs/trade/tmp/";
            path.append(iter->first).append("/");
            StpUtil::CreateDirs(path);
            logger("path=%s", path.c_str());
            traderApi[i] = CTORATstpTraderApi::CreateTstpTraderApi(path.c_str());
            logger("TradeApiVersion: %s", traderApi[i]->GetApiVersion());
            traderSpi[i] = new TraderSpi(traderApi[i],iter->second);
//            traderSpi[i]->InitDataTypeConst();
//            if (traderSpi[i] == NULL)
//            {
//                std::cout << "null" << std::endl;
//                continue;
//            }
            traderApi[i]->RegisterSpi(traderSpi[i]);
            traderApi[i]->SubscribePrivateTopic(TORASTOCKAPI::TORA_TERT_QUICK);
            traderApi[i]->SubscribePublicTopic(TORASTOCKAPI::TORA_TERT_QUICK);
            // 设置交易前置地址
//            traderApi[i]->RegisterFront("tcp://210.14.72.21:4400");
            traderApi[i]->RegisterFront((char*)(iter->second->getTraderFrontAddr()).c_str());
            traderApi[i]->Init();
//            traderSpi[i]->setAccount(iter->second);
            trader_vector.push_back(std::make_pair(iter->first.c_str(), traderSpi[i]));
        }
        // 初始化http
        TraderHttp traderHttp;
        traderHttp.setTraderVector(trader_vector);
        std::thread traderHttpThread(&TraderHttp::start, traderHttp, "|9302");
        traderHttpThread.join();

        for (int j = 0; j < trade_thread_num; j++) {
            traderApi[j]->Join();
//            delete traderSpi[j];
//            traderSpi[j] = NULL;
//                g_pTradeUserApi[j]->Release();
        }

    } else {
        logger_error("参数填入错误, server_mode: %s", server_mode);
        return -1;
    }
}