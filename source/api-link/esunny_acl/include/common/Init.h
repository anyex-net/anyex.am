#pragma once
#include <acl_cpp/stdlib/log.hpp>
#include "../../include/common/General.h"

namespace init {
    // 初始化日志
    void initLog();

    // 初始化配置文件
    void initConfiguration();

    // 连接 mysql 数据库, 获取账户信息
    void connectToDatabase();

    // 初始化 redis
    void initRedis();

    // 初始化 kafka
    void initKafka();

};

