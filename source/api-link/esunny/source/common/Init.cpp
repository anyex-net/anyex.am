//
// Created by root on 3/1/21.
//


#include "../../include/common/Init.h"
#include "iostream"
#include "../../include/common/config.h"
#include "../../include/common/QuoteThread.h"
#include "../../include/common/Http.h"
#include "../../include/common/Account.h"
#include "../../include/spdlog/sinks/stdout_color_sinks.h"
#include "../../include/spdlog/sinks/basic_file_sink.h"
#include "../../include/spdlog/spdlog.h"
#include "../../include/tool/sw/redis++/redis++.h"
#include "../../include/spdlog/sinks/easy_file_sink.h"
#include <lib_acl_cpp/include/acl_cpp/lib_acl.hpp>
#include <async_logger.h>
#include <async.h>

using namespace sw::redis;


MYSQL *mysql_conn = mysql_init(NULL);;
std::map<std::string, std::shared_ptr<Account>> ACCOUNTS;
std::string ConfigFile = "config/config.properties";
Redis       *m_redis;

//acl::redis_pubsub acl_redis;

// 初始化日志
void init::initLog() {
    char tmp_ym[16];
    char tmp_md[16];
    time_t timep = time(0);
    strftime(tmp_ym, sizeof(tmp_ym), "%Y_%m", localtime(&timep));
    strftime(tmp_md, sizeof(tmp_md), "%m_%d", localtime(&timep));
    std::string subdirectory_name = tmp_ym;
    std::string pszFlowPath = "logs/" + subdirectory_name;

    // 创建具有多个接收器的记录器，每个接收器都有自己的格式和日志级别
    std::string base_filename = pszFlowPath + "/" + tmp_md + ".log";
    std::cout << "base_filename" << base_filename << std::endl;

    try
    {
        spdlog::init_thread_pool(8192, 1);
        auto console_sink = std::make_shared<spdlog::sinks::stdout_color_sink_mt>();
        console_sink->set_level(spdlog::level::trace);
        std::string value;
        Config configSettings(ConfigFile);
        std::string server_type = configSettings.Read("server_type", value);
        if (server_type == "quoteServer") {
            auto quote_sink= std::make_shared<spdlog::sinks::easy_file_sink_mt>("logs/quote/quoteServer", 1048576*200, 0);
            quote_sink->set_level(spdlog::level::trace);
            std::vector<spdlog::sink_ptr> sinks {console_sink, quote_sink};
            auto quote_logger = std::make_shared<spdlog::async_logger>("trade", sinks.begin(), sinks.end(), spdlog::thread_pool(), spdlog::async_overflow_policy::block);
            spdlog::set_default_logger(quote_logger);
        } else {
            auto trade_sink= std::make_shared<spdlog::sinks::easy_file_sink_mt>("logs/trade/tradeServer", 1048576*200, 0);
            trade_sink->set_level(spdlog::level::trace);
            std::vector<spdlog::sink_ptr> sinks {console_sink, trade_sink};
            auto trade_logger = std::make_shared<spdlog::async_logger>("trade", sinks.begin(), sinks.end(), spdlog::thread_pool(), spdlog::async_overflow_policy::block);
            spdlog::set_default_logger(trade_logger);
        }
        // 格式设置：[年月日 时分秒毫秒] [logger实例名] [日志等级] [线程ID] 日志正文
        spdlog::set_pattern("[%Y%m%d %T.%e][%n][%l][thread %t] %v");
        // 为所有已注册的记录器打开间隔为5秒的定期刷新
        spdlog::flush_every(std::chrono::seconds(5));
        spdlog::info("日志初始化成功");
    }
    catch (const spdlog::spdlog_ex& ex)
    {
        std::cout << "Log initialization failed: " << ex.what() << std::endl;
    }
}

// 连接 mysql 数据库
void init::connectToDatabase() {
    if (!mysql_conn) {
        spdlog::error("mysql_init failed");
    }
    std::string value;
    Config configSettings(ConfigFile);
    const char* host = configSettings.Read("mysql_host", value).c_str();
    const char* username = configSettings.Read("mysql_username", value).c_str();
    const char* password = configSettings.Read("mysql_password", value).c_str();
    const char* database= configSettings.Read("mysql_dbname", value).c_str();
    unsigned int port= configSettings.Read("mysql_port", 0);

    mysql_conn = mysql_real_connect(
            mysql_conn,
            host,
            username,
            password,
            database,
            port,
            NULL, 0 );   /* 建立实际连接 */
    /* 参数分别为：初始化的连接句柄指针，主机名（或者IP），用户名，密码，数据库名，0，NULL，0）后面三个参数在默认安装mysql>的情况下不用改 */

    if ( mysql_conn ){
        printf( "Connection success\n" );
    }
    else{
        printf( "Connection failed\n" );
    }
//    mysql_close( mysql_conn ); /* 关闭连接 */
//    mysql_conn = NULL;

//    std::cout << EXIT_SUCCESS ;
}

// 初始化账户
void init::initAccounts() {
//    cout << "sd";
//    global_logger->info("in ju zhong");
    MYSQL_RES *result;
    MYSQL_ROW row;
    MYSQL_FIELD *field;
    char sql[200] = {0};
    std::string nickName = "esunny_trade";
    sprintf(sql, "select loginName,loginPwd from Account where nickName = '%s'", nickName.c_str());
    int rt_num = mysql_query(mysql_conn, sql);
    std::cout << "rt_num=" << rt_num << std::endl;
    result = mysql_store_result(mysql_conn);
    if (result == NULL){
        printf("get search data failed\n");
    }

    while ((row=mysql_fetch_row(result))!=NULL) {
        printf("loginName:%s\tloginPwd:%s\n", row[0], row[1]);
        auto account = std::make_shared<Account>();
        account->setUserNo(row[0]);
        account->setPassword(row[1]);
        // 把账户放入全局变量中
        std::cout << "account->getUserNo=" <<  account->getUserNo() << std::endl;
        ACCOUNTS.insert(std::make_pair(account->getUserNo(), account));
        std::string userNo;
        std::cout << ACCOUNTS[account->getUserNo()] << std::endl;
    }

    // 注意用完数据库要及时回收资源
    if (result != NULL) mysql_free_result(result);
    mysql_close(mysql_conn); //关闭MySQL连接
    mysql_library_end(); //关闭MySQL库
}

// 初始化 redis++
void init::initRedisPlusPlus() {
    std::string value;
    Config configSettings(ConfigFile);
    std::string redis_host = configSettings.Read("redis_host", value);
    int redis_port = configSettings.Read("redis_port", 0);
    std::string redis_password = configSettings.Read("redis_password", value);
    try {
        ConnectionOptions connection_options;
        connection_options.host = redis_host;
        connection_options.port = redis_port;
        connection_options.password = redis_password;
        m_redis  = new Redis(connection_options);
    } catch (const sw::redis::IoError &ex) {
        spdlog::error(ex.what());
    }

//    const char *redis_addr="127.0.0.1:6379";//设置连接的数据库地址
//    int conn_timeout=10;//连接redis-server的超时时间（秒）
//    int rw_timeout=10;//与redis-server进行通信IO的超时时间（秒）
//    const char *passwd = "XpVFvpTuo4T0q8P8JQWnRdTz2EymvnU08WAWvwbw";
//    acl::redis_client_cluster cluster;
//    cluster.set(redis_addr, 10, conn_timeout, rw_timeout);
//    cluster.set_password(redis_addr, passwd);
//    acl_redis.set_cluster(&cluster);
}


// 初始化Http
void init::initHttpTrade(const char* host, int port){
    std::cout << "init http" << std::endl;
    Http* httpSever = new Http();
    httpSever->initTradeServer(host, port);
    delete httpSever;
}

// 初始化httpQuote
void init::initHttpQuote(const char* host, int port){
    std::cout << "init http" << std::endl;
    Http* httpSever = new Http();
    httpSever->initQuoteServer(host, port);
    delete httpSever;
}