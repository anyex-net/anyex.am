//
// Created by root on 3/5/21.
//

#ifndef TEST_REDISPOLICY_H
#define TEST_REDISPOLICY_H


#include "redis_publisher.h"
#include "redis_subscriber.h"

class RedisPolicy {

public:
    RedisPolicy();
    ~RedisPolicy();
    void publish(const std::string, const std::string);
    void subscribe(const std::string);
    static void recieve_message(const char *channel_name,const char *message, int len);

    RedisPublisher publisher;
    RedisSubscriber subscriber;
};


#endif //TEST_REDISPOLICY_H
