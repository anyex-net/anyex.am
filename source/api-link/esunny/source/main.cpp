//
// Created by root on 3/1/21.
//
#include <lib_acl_cpp/include/acl_cpp/redis/redis_pubsub.hpp>
#include <lib_acl_cpp/include/acl_cpp/redis/redis_client_cluster.hpp>
#include "../include/spdlog/sinks/stdout_color_sinks.h"
#include "iostream"
#include "cstring"
#include "../include/common/Init.h"
#include "../include/common/TradeThread.h"
#include "../include/common/Account.h"
#include "../include/common/config.h"
#include "../include/quote/initQuote.h"
#include "../include/spdlog/sinks/daily_file_sink.h"
#include "../include/spdlog/spdlog.h"
#include "../../include/tool/sw/redis++/redis++.h"

using namespace sw::redis;

vector<pair<string, Trade*>> trade_vector;
extern std::map<std::string, std::shared_ptr<Account>> ACCOUNTS;
extern std::string ConfigFile;
acl::redis_pubsub acl_redis;
extern Redis *m_redis;

bool GetHostInfo(std::string& hostName, std::string& Ip) {
    char name[256];
    gethostname(name, sizeof(name));
    hostName = name;

    struct hostent* host = gethostbyname(name);
    char ipStr[32];
    const char* ret = inet_ntop(host->h_addrtype, host->h_addr_list[0], ipStr, sizeof(ipStr));
    if (NULL==ret) {
        spdlog::error("hostname transform to ip failed");
        return false;
    }
    Ip = ipStr;
    return true;
}



int main(int argc, char* argv[])
{
    char t[] = "wo shi char[]";
    int n = 3.142596;
    // [2021-03-18 11:38:27.232] [info] [main.cpp:46] char[]= wo shi char[], int[]= 3
    SPDLOG_INFO("char[]= {}, int[]= {}", t, n);

    // ��ʼ����־
    init::initLog();
    // ���� mysql ���ݿ�
    init::connectToDatabase();

    init::initAccounts();

    init::initRedisPlusPlus();
    std::string value;
    Config configSettings(ConfigFile);
    std::string server_type = configSettings.Read("server_type", value);
    std::string redis_host = configSettings.Read("redis_host", value);
    int redis_port = configSettings.Read("redis_port", 0);
    std::string redis_password = configSettings.Read("redis_password", value);
    std::string redis_addr = redis_host + ":" + to_string(redis_port);//�������ӵ����ݿ��ַ
    spdlog::info("redis_addr: {}", redis_addr);
    int conn_timeout=10;//����redis-server�ĳ�ʱʱ�䣨�룩
    int rw_timeout=10;//��redis-server����ͨ��IO�ĳ�ʱʱ�䣨�룩
    acl::redis_client_cluster cluster;
    cluster.set(redis_addr.c_str(), 10, conn_timeout, rw_timeout);
    cluster.set_password(redis_addr.c_str(), redis_password.c_str());
    acl_redis.set_cluster(&cluster);



    if (strcmp(server_type.c_str(), "quoteServer") == 0) {
        // �������
        spdlog::info("�����������");
        int res = initQuote::initQuoteProcess();
        return res;
    } else if (strcmp(server_type.c_str(), "tradeServer") == 0){
        std::string server_mode = configSettings.Read("server_mode", value);
       if (strcmp(server_mode.c_str(), "singleAccount") == 0) {
           std::string single_account = configSettings.Read("single_account", value);
           bool single_account_flag = false;
           for (auto iter = ACCOUNTS.begin(); iter != ACCOUNTS.end(); iter++) {
               if (strcmp(single_account.c_str(), iter->first.c_str()) == 0) {
                   single_account_flag = true;
                   break;
               }
           }

           if (!single_account_flag) {
               spdlog::error("�����������, single_account: {}", single_account);
               return -1;
           }

           spdlog::info("���û�ģʽ����");
           int http_trade_port = configSettings.Read("http_trade_port", 0);
           // Trade
           TradeThread tradeThread;
           tradeThread.AccountNo = single_account;
           tradeThread.start();
           trade_vector.push_back(make_pair(single_account, &tradeThread.objTrade));
           std::string hostName;
           std::string IP;
           bool ret = GetHostInfo(hostName, IP);
           if (true == ret) {
               spdlog::info("hostname: {}", hostName);
               spdlog::info("IP: {}", IP);
           } else {
               spdlog::info("failed");
           }

           // ��ʼ��http
           init::initHttpTrade(IP.c_str(), http_trade_port);
           tradeThread.interrupt();
           delete m_redis;
       } else if (strcmp(server_mode.c_str(), "multiAccount") == 0) {
           spdlog::info("���û�ģʽ����");
           const char* http_trade_host = configSettings.Read("http_trade_host", value).c_str();
           int http_trade_port = configSettings.Read("http_trade_port", 0);

           // trade
           cout << "size=" << ACCOUNTS.size() << endl;
           int trade_thread_num = ACCOUNTS.size();
           TradeThread tradeThread[trade_thread_num];
           int i = 0;
           for (auto iter = ACCOUNTS.begin(); iter != ACCOUNTS.end(); iter++, i++) {
               tradeThread[i].AccountNo = iter->first;
               tradeThread[i].start();
               Trade *tradeThread1_objTrade = &(tradeThread[i].objTrade);
               cout << iter->first << iter->second << endl;
               trade_vector.push_back(make_pair(iter->first, tradeThread1_objTrade));
           }
           //      ��ʼ��http
           cout << "is http" << endl;
           cout << http_trade_host << http_trade_port << endl;
           init::initHttpTrade(http_trade_host, http_trade_port);
           for (int i = 0; i < trade_thread_num; i++) {
               tradeThread[i].interrupt();
           }
       } else {
           spdlog::error("�����������, server_mode: {}", server_mode);
           return -1;
       }
    } else {
        spdlog::error("�����������, server_type: {}", server_type);
        return -1;
    }
    return 0;
}