//
// Created by root on 4/9/21.
//

#include <memory>
#include <unistd.h>
#include <acl_cpp/db/db_mysql.hpp>
#include <acl_cpp/db/query.hpp>
#include <acl_cpp/redis/redis_client.hpp>
#include <acl_cpp/redis/redis_client_cluster.hpp>
#include <acl_cpp/redis/redis_pubsub.hpp>
#include <stdlib/acl_xinetd_cfg.h>
#include "../../include/common/Init.h"
#include "../../include/common/Account.h"
#include <acl_cpp/stdlib/string.hpp>
#include <rdkafka.h>
#include <stdlib/acl_argv.h>
#include <regex>
#include <stdlib/acl_msg.h>
#include <utils/EsunnyUtil.h>

// config
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
char *quote_list;
char *server_debug;
char *stdout_open;


static ACL_CFG_STR_TABLE __conf_str_tab[] = {
        /* 配置项名称, 配置项缺省值, 存储配置项值的地址 */
        { "server_type", "tradeServer", &server_type },
        { "server_mode", "singleAccount", &server_mode },
        { "single_account", "RDGJ06", &single_account },
        { "mysql_addr", "127.0.0.1:3306", &mysql_addr },
        { "mysql_dbname", "mysql", &mysql_dbname },
        { "mysql_username", "root", &mysql_username },
        { "mysql_password", "root", &mysql_password },
        { "redis_addr", "127.0.0.1:6379", &redis_addr },
        { "redis_password", "", &redis_password },
        { "kafka_broker", "192.168.31.42:9092", &kafka_broker },
        { "kafka_enable", "true", &kafka_enable },
        { "quote_list", "", &quote_list },
        { "server_debug", "all:0", &server_debug },
        { "stdout_open", "true", &stdout_open },
        { 0, 0, 0 }
};

std::map<acl::string, std::shared_ptr<Account>> QUOTE_ACCOUNTS;
std::map<acl::string, std::shared_ptr<Account>> TRADE_ACCOUNTS;
rd_kafka_t *rk;
acl::redis_pubsub redis_pubsub;

// 初始化配置文件
void init::initConfiguration()
{
    ACL_XINETD_CFG_PARSER *cfg;  // 配置解析对象
    const char *filepath = "conf/esunnyServer.cf";
    cfg = acl_xinetd_cfg_load(filepath);  // 读取并解析配置文件
    if (NULL == cfg)
    {
        printf("加载配置文件:%s 错误: %s\r\n", filepath, acl_last_serror());
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
    printf("quote_list=%s\r\n", quote_list);
    printf("server_debug=%s\r\n", server_debug);
    printf("stdout_open=%s\r\n", stdout_open);

    acl_xinetd_cfg_free(cfg);  // 释放内存
}

// 初始化日志
void init::initLog()
{
    if (strcmp(stdout_open, "true") == 0) {
        acl::log::stdout_open(true);
    }
    if (strcmp(server_type, "tradeServer") == 0) {
        EsunnyUtil::CreateDirs("logs/trade");
        logger_open("logs/trade/tradeServer.log", "trade", server_debug);
    }
    if (strcmp(server_type, "quoteServer") == 0) {
        EsunnyUtil::CreateDirs("logs/quote");
        logger_open("logs/quote/quoteServer.log", "quote", server_debug);
    }
}

// 连接 mysql 数据库
void init::connectToDatabase()
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
    query.create_sql("select accountNo,accountPassword,accountAuthCode,quoteAccountNo,quoteAccountPassword,"
                     "quoteAccountAuthCode,quoteApiAddr,tradeApiAddr"
                     " from WpfuturesAccountInfo where 1=1");

    if (db.exec_select(query) == false) {
        logger_error("select sql error");
        exit(-1);
    }

    // 获取账户信息
    ACL_ARGV *argv = NULL;
    for (size_t i=0; i<db.length(); i++)
    {
        const acl::db_row* row = db[i];

        const char *quoteAccountNo_ptr = NULL, *quotePassword_ptr = NULL, *quoteAuthCode_ptr = NULL;
        const char *accountNo_ptr = (*row)["accountNo"];
        const char *password_ptr = (*row)["accountPassword"];
        const char *authCode_ptr = (*row)["accountAuthCode"];
        const char *quoteApiAddr_ptr = (*row)["quoteApiAddr"];
        const char *tradeApiAddr_ptr = (*row)["tradeApiAddr"];
        if (accountNo_ptr == NULL || password_ptr == NULL || authCode_ptr == NULL
            || quoteApiAddr_ptr == NULL || quoteApiAddr_ptr == NULL || (strcmp(accountNo_ptr, "") == 0)
            || (strcmp(password_ptr, "") == 0) || (strcmp(authCode_ptr, "") == 0)
            || (strcmp(quoteApiAddr_ptr, "") == 0) || (strcmp(tradeApiAddr_ptr, "") == 0))
        {
            logger_error("error, query tradeAccount failed");
            continue;
        }
        // 校验行情与交易前置地址
        std::string quoteApiAddr_str(quoteApiAddr_ptr);
        std::string tradeApiAddr_str(tradeApiAddr_ptr);
        std::regex regex_str("^(\\d|[1-9]\\d|1\\d{2}|2[0-4]\\d|25[0-5])\\.(\\d|[1-9]\\d|1\\d{2}|2[0-4]\\d|25[0-5])\\"
                             ".(\\d|[1-9]\\d|1\\d{2}|2[0-4]\\d|25[0-5])\\.(\\d|[1-9]\\d|1\\d{2}|2[0-4]\\d|25[0-5])"
                             ":([0-9]|[1-9]\\d|[1-9]\\d{2}|[1-9]\\d{3}|[1-5]\\d{4}|6[0-4]\\d{3}|65[0-4]\\d{2}|655[0-2]\\d|6553[0-5])$");
        bool quoteApiAddr_flag = std::regex_match(quoteApiAddr_str, regex_str);
        bool tradeApiAddr_flag = std::regex_match(tradeApiAddr_str, regex_str);
        if ((!quoteApiAddr_flag) || (!tradeApiAddr_flag))
        {
            logger_error("账户%s行情或交易前置机地址配置错误", accountNo_ptr);
            continue;
        }

        acl::string comb_addr;
        comb_addr.append(quoteApiAddr_ptr).append(":").append(tradeApiAddr_ptr);
        const char *addr[4]{NULL};
        argv = acl_argv_split(comb_addr, ":");
        ACL_ITER iter;
        acl_foreach(iter, argv) {
            addr[iter.i] = (const char *)iter.data;
        }

        const char *quote_ip = addr[0];
        const char *trade_ip = addr[2];
        unsigned short trade_port = atoi(addr[3]);
        unsigned short quote_port = atoi(addr[1]);

        auto trade_account = std::make_shared<Account>();
        trade_account->setAccountNo(accountNo_ptr);
        trade_account->setPassword(password_ptr);
        trade_account->setAuthCode(authCode_ptr);
        trade_account->setIp(trade_ip);
        trade_account->setPort(trade_port);
        // 把交易账户放入全局变量中
        TRADE_ACCOUNTS.insert(std::make_pair(accountNo_ptr,trade_account));

        auto quote_account = std::make_shared<Account>();
        quote_account->setAccountNo(accountNo_ptr);
        quote_account->setPassword(password_ptr);
        quote_account->setAuthCode(authCode_ptr);
        quote_account->setIp(quote_ip);
        quote_account->setPort(quote_port);
        // 行情与交易账号不相同
        quoteAccountNo_ptr = (*row)["quoteAccountNo"];
        if ((quoteAccountNo_ptr != NULL) || (strcmp(quoteAccountNo_ptr, "") == 0)) {
            quotePassword_ptr = (*row)["quoteAccountPassword"];
            quoteAuthCode_ptr = (*row)["quoteAccountAuthCode"];
            if (quotePassword_ptr == NULL || quoteAuthCode_ptr == NULL
                || (strcmp(quotePassword_ptr, "") == 0) || (strcmp(quoteAuthCode_ptr, "") == 0))
            {
                logger_error("error, query quoteAccount failed, accountNo %s", accountNo_ptr);
//                TRADE_ACCOUNTS.erase(accountNo_ptr);
                continue;
            }
            quote_account->setAccountNo(quoteAccountNo_ptr);
            quote_account->setPassword(quotePassword_ptr);
            quote_account->setAuthCode(quoteAuthCode_ptr);
        }
        // 把行情账户放入全局变量中
        QUOTE_ACCOUNTS.insert(std::make_pair(quoteAccountNo_ptr ,quote_account));
    }

    // 释放内存
    acl_argv_free(argv);
    // 释放查询结果
    db.free_result();
}

// 初始化 redis
void init::initRedis()
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
void init::initKafka()
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
