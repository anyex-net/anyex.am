#pragma once
#include <acl_cpp/stdlib/string.hpp>
#include <acl_cpp/stdlib/log.hpp>
#include <rdkafka.h>
#include <memory>
#include <map>
#include "Account.h"
#include <acl_cpp/redis/redis_client.hpp>
#include <acl_cpp/redis/redis_client_cluster.hpp>
#include <acl_cpp/redis/redis_pubsub.hpp>

#define DEBUG_BASE	100
#define DEBUG_TEST1	(DEBUG_BASE + 1)
#define DEBUG_TEST2	(DEBUG_BASE + 2)
#define DEBUG_TEST3	(DEBUG_BASE + 3)


//extern char *server_type;
//extern char *server_mode;
//extern char *single_account;
//extern char *mysql_addr;
//extern char *mysql_dbname;
//extern char *mysql_username;
//extern char *mysql_password;
//extern char *redis_addr;
//extern char *redis_password;
//extern char *kafka_broker;
//extern char *kafka_enable;
//extern char *quote_list;
//extern char *server_debug;
//extern char *stdout_open;


//extern std::map<acl::string, std::shared_ptr<Account>> ACCOUNTS;
//extern rd_kafka_t *rk;
//extern acl::redis_pubsub redis_pubsub;

