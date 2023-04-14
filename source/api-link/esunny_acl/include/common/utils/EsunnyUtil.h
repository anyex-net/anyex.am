#pragma once

#include <acl_cpp/stdlib/string.hpp>
#include <unistd.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <acl_cpp/stdlib/log.hpp>
#include <rdkafka.h>
#include <acl_cpp/redis/redis_pubsub.hpp>

namespace EsunnyUtil {
    bool GetHostInfo(acl::string& hostName, acl::string& Ip);

    bool CreateDirs(const std::string& dirName);

    char* EsunnyConvert(char *value, size_t len);

    void KafkaOrRedis(const char *TOPIC_NAME, char* value, size_t len);

    int CodeConvert(char *fromCode, char *toCode, char *inbuf, size_t inlen, char *outbuf, size_t *outlen);
};

