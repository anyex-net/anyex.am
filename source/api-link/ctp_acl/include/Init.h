#pragma once
#include <acl_cpp/stdlib/log.hpp>
#include <map>
#include <memory>
#include <rdkafka.h>
#include <acl_cpp/redis/redis_pubsub.hpp>
#include "Account.h"
#include "utils/CtpUtil.h"
#include "General.h"

namespace ctp {
class init {

public:
    // 初始化配置文件
    static void initConfiguration();

    // 初始化日志
    static void initLog();

    // 连接 mysql 数据库, 获取账户信息
    static void connectToDatabase();

    // 初始化 redis
    static void initRedis();

    // 初始化 kafka
    static void initKafka();

//public:
//    static std::map<acl::string, std::shared_ptr<Account>> ACCOUNTS;
//    static rd_kafka_t *rk;
//    static acl::redis_pubsub redis_pubsub;
};

} // namespace ctp

