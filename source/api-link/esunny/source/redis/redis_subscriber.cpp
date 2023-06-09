#include <stddef.h>
#include <assert.h>
#include <string.h>
#include "../../include/redis/redis_subscriber.h"
#include "../../include/common/config.h"

extern std::string ConfigFile;

RedisSubscriber::RedisSubscriber() : eventBase(0), eventThread(0),
                                     context(0) {
}

RedisSubscriber::~RedisSubscriber() {
}

bool RedisSubscriber::init(const NotifyMessageFn &fn) {
	// initialize the event
	notifyMessageFn = fn;
	eventBase = event_base_new();    // 创建libevent对象
	if (NULL == eventBase) {
		std::cout << "Create redis event failed." << std::endl;
		return false;
	}

	memset(&eventSem, 0, sizeof(eventSem));
	int ret = sem_init(&eventSem, 0, 0);
	if (ret != 0) {
		std::cout << "Init sem failed." << std::endl;
		return false;
	}

	return true;
}

bool RedisSubscriber::uninit() {
	eventBase = NULL;

	sem_destroy(&eventSem);
	return true;
}

bool RedisSubscriber::connect() {
    std::string value;
    Config configSettings(ConfigFile);
    const char* redis_host = configSettings.Read("redis_host", value).c_str();
    int redis_port = configSettings.Read("redis_port", 0);
	// connect redis
	context = redisAsyncConnect(redis_host, redis_port);    // 异步连接到redis服务器上，使用默认端口
	if (NULL == context) {
		std::cout << "Connect redis failed." << std::endl;
		return false;
	}

	if (context->err) {
		// 输出错误信息
		std::cout << "Connect redis error: " << context->err << context->errstr << std::endl;
		return false;
	}

	// attach the event
	redisLibeventAttach(context, eventBase);    // 将事件绑定到redis context上，使设置给redis的回调跟事件关联

	// 创建事件处理线程
	int ret = pthread_create(&eventThread, 0, &RedisSubscriber::event_thread, this);
	if (ret != 0) {
		std::cout << "Create event thread failed." << std::endl;
		disconnect();
		return false;
	}

	// 设置连接回调，当异步调用连接后，服务器处理连接请求结束后调用，通知调用者连接的状态
	redisAsyncSetConnectCallback(context,
	                             &RedisSubscriber::connect_callback);

	// 设置断开连接回调，当服务器断开连接后，通知调用者连接断开，调用者可以利用这个函数实现重连
	redisAsyncSetDisconnectCallback(context,
	                                &RedisSubscriber::disconnect_callback);

	// 启动事件线程
	sem_post(&eventSem);
	return true;
}

bool RedisSubscriber::disconnect() {
	if (context) {
		redisAsyncDisconnect(context);
		redisAsyncFree(context);
		context = NULL;
	}

	return true;
}

bool RedisSubscriber::auth() {
    std::string value;
    Config configSettings(ConfigFile);
    const char* redis_password = configSettings.Read("redis_password", value).c_str();
    int ret = redisAsyncCommand(context,
                                &RedisSubscriber::command_callback, this,"AUTH %s",
                                redis_password);

    if (REDIS_ERR == ret) {
        std::cout << "Subscriber auth command failed: " << ret << std::endl;
        return false;
    }

    std::cout << "Subscriber auth success" << std::endl;

    return true;
}

bool RedisSubscriber::subscribe(const std::string &channel_name) {
	int ret = redisAsyncCommand(context,
	                            &RedisSubscriber::command_callback, this, "SUBSCRIBE %s",
	                            channel_name.c_str());
	if (REDIS_ERR == ret) {
		std::cout << "Subscribe command failed: " << ret << std::endl;
		return false;
	}

	std::cout << "Subscribe success: " << channel_name.c_str() << std::endl;
	return true;
}

void RedisSubscriber::connect_callback(const redisAsyncContext *redis_context,
                                        int status) {
	if (status != REDIS_OK) {
		std::cout << "connect_callback Error: " << redis_context->errstr << std::endl;
	} else {
		std::cout << "Subscribe Redis connected!" << std::endl;
	}
}

void RedisSubscriber::disconnect_callback(
		const redisAsyncContext *redis_context, int status) {
	if (status != REDIS_OK) {
		// 这里异常退出，可以尝试重连
		std::cout << "disconnect_callback Error: " << redis_context->errstr << std::endl;
	}
}

// 消息接收回调函数
void RedisSubscriber::command_callback(redisAsyncContext *redis_context,
                                       void *reply, void *privdata) {
	if (NULL == reply || NULL == privdata) {
		return;
	}

	// 静态函数中，要使用类的成员变量，把当前的this指针传进来，用this指针间接访问
	RedisSubscriber *self_this = reinterpret_cast<RedisSubscriber *>(privdata);
	redisReply *redis_reply = reinterpret_cast<redisReply *>(reply);

	// 订阅接收到的消息是一个带三元素的数组
	if (redis_reply->type == REDIS_REPLY_ARRAY &&
	    redis_reply->elements == 3) {
		// 调用函数对象把消息通知给外层
		self_this->notifyMessageFn(redis_reply->element[1]->str,
		                           redis_reply->element[2]->str, redis_reply->element[2]->len);
	}
}

void *RedisSubscriber::event_thread(void *data) {
	if (NULL == data) {
		std::cout << "Error!" << std::endl;
		assert(false);
		return NULL;
	}

	RedisSubscriber *self_this = reinterpret_cast<RedisSubscriber *>(data);
	return self_this->event_proc();
}

void *RedisSubscriber::event_proc() {
	sem_wait(&eventSem);

	// 开启事件分发，event_base_dispatch会阻塞
	event_base_dispatch(eventBase);

	return NULL;
}