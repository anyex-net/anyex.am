//
// Created by root on 5/10/21.
//

#include "../include/Init.h"
#include <stdlib/acl_xinetd_cfg.h>
#include <acl_cpp/db/db_mysql.hpp>
#include <acl_cpp/db/query.hpp>
#include <memory>
#include <unistd.h>
#include <acl_cpp/redis/redis_client.hpp>
#include <acl_cpp/redis/redis_client_cluster.hpp>
#include <acl_cpp/redis/redis_pubsub.hpp>
#include <rdkafka.h>
#include <regex>
#include <stdlib/acl_msg.h>

// ---- 全局参数声明 ---- //
char *server_type;
char *server_mode;
char *single_account;
char *kafka_enable;
char *md_list;

// ---- 参数声明 ---- //
static char *mysql_addr;
static char *mysql_dbname;
static char *mysql_username;
static char *mysql_password;
static char *redis_addr;
static char *redis_password;
static char *kafka_broker;
static char *stdout_open;
static char *server_debug;



static ACL_CFG_STR_TABLE __conf_str_tab[] = {
        /* 配置项名称, 配置项缺省值, 存储配置项值的地址 */
        { "mysql_addr", "127.0.0.1:3306", &mysql_addr },
        { "mysql_dbname", "mysql", &mysql_dbname },
        { "mysql_username", "root", &mysql_username },
        { "mysql_password", "root", &mysql_password },
        { "server_type", "tradeServer", &server_type },
        { "server_mode", "singleAccount", &server_mode },
        { "single_account", "183110", &single_account },
        { "redis_addr", "127.0.0.1:6379", &redis_addr },
        { "redis_password", "", &redis_password },
        { "kafka_broker", "1234", &kafka_broker },
        { "kafka_enable", "true", &kafka_enable },
        { "md_list", "", &md_list },
        { "stdout_open", "", &stdout_open },
        { "server_debug", "", &server_debug },
        { 0, 0, 0 }
};


map<acl::string, shared_ptr<Account>> ACCOUNTS;
rd_kafka_t *rk;
acl::redis_pubsub redis_pubsub;

namespace ctp
{
// 初始化配置文件
void init::initConfiguration() {

    ACL_XINETD_CFG_PARSER *cfg;  // 配置解析对象
    const char *filepath;
#ifdef STP
        filepath = "conf/ctp2StpServer.cf";
#endif
#ifdef OPENCTP
        filepath = "conf/openCtpServer.cf";
#endif
#ifdef CTP
        filepath = "conf/ctpServer.cf";
#endif

    cfg = acl_xinetd_cfg_load(filepath);  // 读取并解析配置文件
    if (NULL == cfg)
    {
        fprintf(stderr, "加载配置文件:%s 错误: %s", filepath, acl_last_serror());
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
    printf("single_account=%s\r\n", single_account);
    printf("md_list=%s\r\n", md_list);
    printf("stdout_open=%s\r\n", stdout_open);
    printf("server_debug=%s\r\n", server_debug);
    acl_xinetd_cfg_free(cfg);  // 释放内存
}

// 初始化日志
void init::initLog() {
    if (strcmp(stdout_open, "true") == 0) {
        acl::log::stdout_open(true);
    }
    if (strcmp(server_type, "tradeServer") == 0) {
        CtpUtil::CreateDirs("logs/trade");
        CtpUtil::CreateDirs("logs/trade/tmp");
        logger_open("logs/trade/tradeServer.log", "trade", server_debug);
    }
    if (strcmp(server_type, "mdServer") == 0) {
        CtpUtil::CreateDirs("logs/md");
#ifdef CTP
        CtpUtil::CreateDirs("logs/md/tmp");
#endif
        logger_open("logs/md/mdServer.log", "md", server_debug);
    }
}

// 连接 mysql 数据库
void init::connectToDatabase() {
    const char* table_name;

#ifdef STP
        logger("连接STP数据库");
        table_name = "NpSpotAccountInfo";
#endif
#ifdef OPENCTP
        logger("连接OPENCTP数据库");
        table_name = "WpSpotAccountInfo";
#endif
#ifdef CTP
        logger("连接CTP数据库");
        table_name = "NpfuturesAccountInfo";
#endif

    acl::db_mysql db(mysql_addr, mysql_dbname, mysql_username, mysql_password);
    // 打开数据库连接
    if (db.open() == false) {
        logger_error("open db(%s@%s) error",
                     mysql_addr, mysql_dbname);
        getchar();
        exit(-1);
    }

    logger("open db %s ok", mysql_dbname);
    acl::query query;
    query.create_sql("select brokerID,investorID,investorPassword,authCode,appID,mdFrontAddr,tradeFrontAddr"
                     " from %s where 1=1", table_name);
    if (db.exec_select(query) == false) {
        logger_error("select sql error");
        exit(-1);
    }
    logger("sql = %s", query.to_string().c_str());

    // 获取账户信息
    int db_length_ret = (int) db.length();
    if (db_length_ret == 0) {
        db.free_result();
        logger("数据库中未有账户，进程退出");
        logger_close();
        exit(0);
    } else {
        logger("db_length_ret=%d", db_length_ret);
        for (size_t i = 0; i < db.length(); i++) {
            const acl::db_row *row = db[i];

            // 取出该行记录中某个字段的值
            const char *brokerID_ptr = (*row)["brokerID"];
            const char *investorID_ptr = (*row)["investorID"];
            const char *investorPwd_ptr = (*row)["investorPassword"];
            const char *authCode_ptr = (*row)["authCode"];
            const char *appID_ptr = (*row)["appID"];
            const char *mdFrontAddr_ptr = (*row)["mdFrontAddr"];
            const char *tradeFrontAddr_ptr = (*row)["tradeFrontAddr"];
            if (brokerID_ptr == NULL || investorID_ptr == NULL || investorPwd_ptr == NULL ||
                authCode_ptr == NULL || appID_ptr == NULL || mdFrontAddr_ptr == NULL || tradeFrontAddr_ptr == NULL
                || (strcmp(brokerID_ptr, "") == 0) || (strcmp(investorID_ptr, "") == 0) || (strcmp(investorPwd_ptr, "") == 0)
                || (strcmp(authCode_ptr, "") == 0) || (strcmp(appID_ptr, "") == 0) || (strcmp(mdFrontAddr_ptr, "") == 0)
                || (strcmp(tradeFrontAddr_ptr, "") == 0)) {
                logger_error("数据库查询错误，字段为空");
                continue;
            }
            // 校验行情与交易前置地址  格式: address:port(x.x.x.x:x)
            string mdFrontAddr_str(mdFrontAddr_ptr);
            string tradeFrontAddr_str(tradeFrontAddr_ptr);
            regex regex_str("^(\\d|[1-9]\\d|1\\d{2}|2[0-4]\\d|25[0-5])\\.(\\d|[1-9]\\d|1\\d{2}|2[0-4]\\d|25[0-5])\\"
                                 ".(\\d|[1-9]\\d|1\\d{2}|2[0-4]\\d|25[0-5])\\.(\\d|[1-9]\\d|1\\d{2}|2[0-4]\\d|25[0-5])"
                                 ":([0-9]|[1-9]\\d|[1-9]\\d{2}|[1-9]\\d{3}|[1-5]\\d{4}|6[0-4]\\d{3}|65[0-4]\\d{2}|655[0-2]\\d|6553[0-5])$");
            bool mdFrontAddr_str_flag = regex_match(mdFrontAddr_str, regex_str);
            bool tradeFrontAddr_flag = regex_match(tradeFrontAddr_str, regex_str);
            if ((!mdFrontAddr_str_flag) || (!tradeFrontAddr_flag))
            {
                logger_error("账户%s行情或交易前置机地址配置错误", investorID_ptr);
                continue;
            }
            acl::string mdFrontAddr;
            acl::string tradeFrontAddr;
            mdFrontAddr.append("tcp://").append(mdFrontAddr_ptr);
            tradeFrontAddr.append("tcp://").append(tradeFrontAddr_ptr);
            auto account = make_shared<Account>();
            account->setBrokerID(brokerID_ptr);
            account->setInvesterID(investorID_ptr);
            account->setInvesterPwd(investorPwd_ptr);
            account->setAuthCode(authCode_ptr);
            account->setAppId(appID_ptr);
            account->setFrontMdAddewss(mdFrontAddr);
            account->setFrontTradeAddress(tradeFrontAddr);

            // 把账户放入全局变量中
            // or use a smart pointer
            acl::string gInvesterID = investorID_ptr;
            logger("investerID=%s", investorID_ptr);
            logger("mdFrontAddr=%s", mdFrontAddr.c_str());
            logger("tradeFrontAddr=%s", tradeFrontAddr.c_str());
            ACCOUNTS.insert(make_pair(gInvesterID, account));
        }
    }
    // 释放查询结果
    db.free_result();

    if (ACCOUNTS.size() == 0)
    {
        logger_error("存入数据格式错误，请检查");
        logger_close();
        exit(-1);
    }
}

// 初始化 redis
void init::initRedis() {
    int conn_timeout = 10;//连接redis-server的超时时间（秒）
    int rw_timeout = 10;//与redis-server进行通信IO的超时时间（秒）
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
                      const rd_kafka_message_t *rkmessage, void *opaque) {
    if (rkmessage->err)
        logger_error("Message delivery failed: %s", rd_kafka_err2str(rkmessage->err));
    else
        logger_debug(DEBUG_TEST3, 3 ,"Message delivered (%zd bytes): %s", rkmessage->len, rd_kafka_err2str(rkmessage->err));
    /* rkmessage被librdkafka自动销毁*/
}

// 初始化 kafka
void init::initKafka() {
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
        exit(-1);
    }

    /*设置发送报告回调函数，rd_kafka_produce()接收的每条消息都会调用一次该回调函数
     *应用程序需要定期调用rd_kafka_poll()来服务排队的发送报告回调函数*/
    rd_kafka_conf_set_dr_msg_cb(conf, dr_msg_cb);

    /*创建producer实例
      rd_kafka_new()获取conf对象的所有权,应用程序在此调用之后不得再次引用它*/
    rk = rd_kafka_new(RD_KAFKA_PRODUCER, conf, errstr, sizeof(errstr));
    if (!rk) {
        logger_error("%% Failed to create new producer:%s", errstr);
        exit(-1);
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

} // namespace ctp
