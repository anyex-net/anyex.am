#pragma once

namespace init
{
    // 初始化配置文件
    void initConfiguration();

    // 初始化日志
    void initLog();

    // 连接 mysql 数据库, 获取账户信息
    void connectToDatabase();

    // 初始化 redis
    void initRedis();

    // 初始化 kafka
    void initKafka();
};
