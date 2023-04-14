#pragma once

#include <acl_cpp/stdlib/string.hpp>
#include <unistd.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <acl_cpp/stdlib/log.hpp>
#include <rdkafka.h>
#include <acl_cpp/redis/redis_pubsub.hpp>

#define DOUBLE_MAX_VALUE 1.79769E308
using namespace std;

namespace CtpUtil {
    bool GetHostInfo(acl::string& HostName, acl::string& IP);

    void KafkaOrRedis(const char *TOPIC_NAME, char* value, size_t len);

    char* CtpConvert(char *value, size_t len);

    int CodeConvert(char *fromCode, char *toCode, char *inbuf, size_t inlen, char *outbuf, size_t *outlen);

    bool CreateDirs(const string &dirName);
};
