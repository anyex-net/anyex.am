//
// Created by root on 3/5/21.
//

#include "../../include/redis/RedisPolicy.h"
#include "istream"
using namespace std;

RedisPolicy::RedisPolicy()
{
    bool ret = publisher.init();
    if (!ret) {
        printf("Init failed.\n");

    }

    ret = publisher.connect();
    if (!ret) {
        printf("connect failed.");

    }

    ret = publisher.auth();
    if (!ret) {
        printf("publisher auth failed.\n");
    }

    //***********************************
//    RedisSubscriber::NotifyMessageFn fn =
//            bind(recieve_message, std::placeholders::_1,
//                 std::placeholders::_2, std::placeholders::_3);
//
//    bool ret1 = subscriber.init(fn);
//    if (!ret1) {
//        printf("Init failed.\n");
//    }
//
//    ret1 = subscriber.connect();
//    if (!ret1) {
//        printf("Connect failed.\n");
//    }
//
//    ret1 = subscriber.auth();
//    if (!ret1) {
//        printf("subscriber auth failed.\n");
//    }

//    subscriber.subscribe("QryAccount");
}

RedisPolicy::~RedisPolicy()
{
    publisher.disconnect();
    publisher.uninit();

    subscriber.disconnect();
    subscriber.uninit();
}


void RedisPolicy::publish(const std::string publish_name, const std::string publish_message)
{
    cout<<"RedisPolicy::publish()...\n"<<endl;
    bool res = publisher.publish(publish_name, publish_message);
    if (res) {
        std::cout << "publisher sucess!" << endl;
    } else {
        std::cout << "publisher failed!" << endl;
    }
}

void RedisPolicy::subscribe(const std::string subscribe_name)
{
    cout<<"RedisPolicy::subscribe()...\n"<<endl;
    subscriber.subscribe(subscribe_name);
}


void RedisPolicy::recieve_message(const char *channel_name,
                             const char *message, int len)
{
    printf("Recieve message:    channel name: %s    message: %s   len: %d\n",
           channel_name, message, len);
}