//
// Created by root on 4/12/21.
//

#include <Quote.h>
#include "HttpQuote.h"
#include "MasterService.h"
#include "HttpService.h"


extern std::vector<std::pair<acl::string, Quote *>> quote_vector;

HttpQuote::HttpQuote() {}

HttpQuote::~HttpQuote() {}

static bool http_default(const char* path, HttpRequest& req, HttpResponse& res)
{
    acl::string body_buf;
    res.setStatus(404);
    req.getBody(body_buf);
    acl::string buf  = "404 ";
    buf += path;
    buf += " not found\r\n";
    res.setContentLength(buf.size());
    logger_error("not found %s", path);
    return res.write(buf);
}

static bool http_get_root(HttpRequest&, HttpResponse& res)
{
    acl::string buf("hello world!\r\n");
    res.setContentLength(buf.size());
    return res.write(buf);
}

void HttpQuote::start(const char* addrs) {
    MasterService ms;
    HttpService& service = ms.get_service();

    // 设置配置参数表
    ms.set_cfg_int(var_conf_int_tab)
            .set_cfg_int64(var_conf_int64_tab)
            .set_cfg_str(var_conf_str_tab)
            .set_cfg_bool(var_conf_bool_tab);

    // Register http handlers according different url path
    service.Get("/", http_get_root)
            .Get("/SubscribeQuoteWhole", this->SubscribeQuoteWhole)
            .Get("/UnSubscribeQuoteWhole", this->UnSubscribeQuoteWhole)
            .Get("/ConnectQuote", this->ConnectQuote)
            .Get("/DisConnectQuote", this->DisConnectQuote)
            .Default(http_default);

    if (setenv("SERVICE_LOG", "logs/quote/quoteServer.log", 1) == 0) {
        logger("modify the environment SERVICE_LOG");
    }
    // 开始运行

    int argc = 1;
//    if (argc == 1 || (argc >= 2 && strcmp(argv[1], "alone") == 0)) {

        // 监听的地址列表，格式：ip|port1,ip|port2,...
//        const char* addrs = "192.168.31.7|8888";

        // 测试时设置该值 > 0 则指定服务器处理客户端连接过程的
        // 会话总数（一个连接从接收到关闭称之为一个会话），当
        // 处理的连接会话数超过此值，测试过程结束；如果该值设
        // 为 0，则测试过程永远不结束
        unsigned int count = 0;

        // 测试过程中指定线程池最大线程个数
        unsigned int max_threads = 100;

        // 单独运行方式

//        if (argc >= 3) {
//            ms.run_alone(addrs, argv[2], count, max_threads);
//        } else {
            ms.run_alone(addrs, NULL, count, max_threads);
//        }

//        printf("Enter any key to exit now\r\n");
//        getchar();
//    } else {
        // acl_master 控制模式运行
//        ms.run_daemon(argc, argv);
//    }
}

bool HttpQuote::SubscribeQuoteWhole(HttpRequest& req, HttpResponse& res)
{
    logger("订阅行情");
    acl::string write_buf;
    const char* params[4];
    bool params_flag = true;
    ACL_ARGV *argv = acl_argv_split("AccountNo,ExchangeNo,"
                                    "CommodityNo,ContractNo", ",");
    ACL_ITER iter;  // 遍历指针
    // 遍历分割后的结果
    acl_foreach(iter, argv) {
        // 从遍历指针中取出字符串型数据
        const char *iter_ptr =  (const char*) iter.data;
        params[iter.i] = req.getHeader(iter_ptr);
        if (NULL == params[iter.i]) {
            params_flag = false;
            logger_error("%s is null", iter_ptr);
            write_buf.format("%s is null", iter_ptr);
            break;
        }
    }

    if (params_flag) {
        bool quote_vector_flag = false;
        for(auto v = quote_vector.begin(); v != quote_vector.end(); ++v) {
            if (strcmp(params[0], (v->first).c_str()) == 0) {
                Quote* q = (Quote*)v->second;
                int rt = q->q_subscribeQuote(params[1], params[2], params[3]);
                write_buf.format("%d", rt);
                quote_vector_flag = true;
                break;
            }
        }
        if (!quote_vector_flag) {
            logger_error("AccountNo is invalid, The corresponding thread could not be found!, AccountNo= %s", params[0]);
            write_buf.format("%d", -19001);
        }
    }

    // 释放内存
    acl_argv_free(argv);
    res.setContentLength(write_buf.size());
    return res.write(write_buf);
}

bool HttpQuote::UnSubscribeQuoteWhole(HttpRequest& req, HttpResponse& res)
{
    logger("取消订阅");
//    // 获取 body 中的数据，如果没有消费HTTP BODY数据，会导致报错
    acl::string write_buf;
    const char* params[4];
    bool params_flag = true;

    ACL_ARGV *argv = acl_argv_split("AccountNo,ExchangeNo,"
                                    "CommodityNo,ContractNo", ",");
    ACL_ITER iter;  // 遍历指针
    // 遍历分割后的结果
    acl_foreach(iter, argv) {
        // 从遍历指针中取出字符串型数据
        const char *iter_ptr =  (const char*) iter.data;
        params[iter.i] = req.getHeader(iter_ptr);
        if (NULL == params[iter.i]) {
            params_flag = false;
            logger_error("%s is null", iter_ptr);
            write_buf.format("%s is null", iter_ptr);
            break;
        }
    }

    if (params_flag) {
        bool quote_vector_flag = false;
        for(auto v = quote_vector.begin(); v != quote_vector.end(); ++v) {
            if (strcmp(params[0], (v->first).c_str()) == 0) {
                Quote* q = (Quote*)v->second;
                int rt = q->q_unSubscribeQuote(params[1], params[2], params[3]);
                write_buf.format("%d", rt);
                quote_vector_flag = true;
                break;
            }
        }
        if (!quote_vector_flag) {
            logger_error("AccountNo is invalid, The corresponding thread could not be found!, AccountNo= %s", params[0]);
            write_buf.format("%d", -19001);
        }
    }

    // 释放内存
    acl_argv_free(argv);
    res.setContentLength(write_buf.size());
    return res.write(write_buf);
}

bool HttpQuote::ConnectQuote(HttpRequest& req, HttpResponse& res)
{
    logger("连接行情");
//    // 获取 body 中的数据，如果没有消费HTTP BODY数据，会导致报错
    acl::string write_buf;
    const char* param;
    bool params_flag = true;

    param = req.getHeader("AccountNo");
    if (NULL == param) {
        params_flag = false;
        logger_error("AccountNo is null");
        write_buf.format("AccountNo is null");
    }

    if (params_flag) {
        bool quote_vector_flag = false;
        for(auto v = quote_vector.begin(); v != quote_vector.end(); ++v) {
            if (strcmp(param, (v->first).c_str()) == 0) {
                Quote* q = (Quote*)v->second;
                int rt = q->q_login();
                write_buf.format("%d", rt);
                quote_vector_flag = true;
                break;
            }
        }
        if (!quote_vector_flag) {
            logger_error("AccountNo is invalid, The corresponding thread could not be found!, AccountNo= %s", param);
            write_buf.format("%d", -19001);
        }
    }

    res.setContentLength(write_buf.size());
    return res.write(write_buf);
}

bool HttpQuote::DisConnectQuote(HttpRequest& req, HttpResponse& res)
{
    logger("断开连接");
//    // 获取 body 中的数据，如果没有消费HTTP BODY数据，会导致报错
    acl::string write_buf;
    const char* param;
    bool params_flag = true;

    param = req.getHeader("AccountNo");
    if (NULL == param) {
        params_flag = false;
        logger_error("AccountNo is null");
        write_buf.format("AccountNo is null");
    }

    if (params_flag) {
        bool quote_vector_flag = false;
        for(auto v = quote_vector.begin(); v != quote_vector.end(); ++v) {
            if (strcmp(param, (v->first).c_str()) == 0) {
                Quote* q = (Quote*)v->second;
                int rt = q->q_disConnect();
                write_buf.format("%d", rt);
                quote_vector_flag = true;
                break;
            }
        }
        if (!quote_vector_flag) {
            logger_error("AccountNo is invalid, The corresponding thread could not be found!, AccountNo= %s", param);
            write_buf.format("%d", -19001);
        }
    }

    // 释放内存
    res.setContentLength(write_buf.size());
    return res.write(write_buf);
}