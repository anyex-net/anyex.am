//
// Created by root on 8/17/21.
//

#include <common/StpInit.h>
#include <md/MdSpi.h>
#include <md/MdHttp.h>

extern char *server_type;
extern char *server_mode;

int main()
{
    initConfiguration();
    initLog();
    connectToDatabase();
    initKafka();

    if (strcmp(server_type, "mdServer") == 0) {
        // 行情
        logger("启动行情");
        int ret = initMdThreads();
        return ret;
    } else if (strcmp(server_type, "tradeServer") == 0){    // 交易
        logger("启动交易");
        int ret = initTraderThreads();
        return ret;
    } else {
        logger_error("参数server_type(%s)填入错误, server_type: %s", server_type);
        return -1;
    }
//    if (kafka_enable) {
//        logger("Flushing final message.. ");
//        /*rd_kafka_flush是rd_kafka_poll()的抽象化，
//        等待所有未完成的produce请求完成，通常在销毁producer实例前完成
//        以确保所有排列中和正在传输的produce请求在销毁前完成*/
//        rd_kafka_flush(rk, 10*1000);
//
//        /* Destroy the producer instance */
//        rd_kafka_destroy(rk);
//    } else {
//        acl::redis_client_cluster *c = redis_pubsub.get_cluster();
//        delete c;
//        // 防止野指针
//        c = NULL;
//    }
    logger_close();
    logger("main process is end!");
    return 0;
}