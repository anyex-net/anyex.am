//
// Created by root on 4/12/21.
//

#include <md/MdSpi.h>
#include <md/MdHttp.h>
#include <http/MasterService.h>
#include <http/HttpService.h>
#include <stdlib/acl_argv.h>

std::vector<std::pair<const char *, MdSpi *>> MdHttp::sm_vMd;

MdHttp::MdHttp() {}

MdHttp::~MdHttp() {}

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

//void MdHttp::setMdSpi(MdSpi *mdSpi) {
//    sm_pMdSpi = mdSpi;
//}

void MdHttp::setMdVector(std::vector<std::pair<const char *, MdSpi *>> md) {
    sm_vMd = md;
}

void MdHttp::start(const char* addrs) {
    MasterService ms;
    HttpService& service = ms.get_service();

    // 设置配置参数表
    ms.set_cfg_int(var_conf_int_tab)
            .set_cfg_int64(var_conf_int64_tab)
            .set_cfg_str(var_conf_str_tab)
            .set_cfg_bool(var_conf_bool_tab);

    // Register http handlers according different url path
    service.Get("/", http_get_root)
            .Get("/SubscribeMarketData", this->SubscribeMarketData)
            .Get("/UnSubscribeMarketData", this->UnSubscribeMarketData)
            .Get("/Logout", this->Logout)
            .Default(http_default);

    if (setenv("SERVICE_LOG", "logs/md/mdServer.log", 1) == 0) {
        logger("modify the environment SERVICE_LOG");
    }
    // 开始运行

    // 监听的地址列表，格式：ip|port1,ip|port2,...
//  const char* addrs = "192.168.31.7|8888";

    // 测试时设置该值 > 0 则指定服务器处理客户端连接过程的
    // 会话总数（一个连接从接收到关闭称之为一个会话），当
    // 处理的连接会话数超过此值，测试过程结束；如果该值设
    // 为 0，则测试过程永远不结束
    unsigned int count = 0;

    // 测试过程中指定线程池最大线程个数
    unsigned int max_threads = 100;

    // 单独运行方式
    ms.run_alone(addrs, NULL, count, max_threads);
}

// 请求订阅合约
bool MdHttp::SubscribeMarketData(HttpRequest& req, HttpResponse& res)
{
    logger("订阅合约");
    acl::string write_buf;
    const char* params[3]{NULL};
    bool params_flag = true;
    params[0] = req.getHeader("InvestorID");
    if (NULL == params[0]) {
        params_flag = false;
        logger_error("InvestorID is null");
        write_buf.format("InvestorID is null");
    }
    params[1] = req.getHeader("ppSecurityID");
    if (NULL == params[1]) {
        params_flag = false;
        logger_error("ppSecurityID is null");
        write_buf.append("ppSecurityID is null");
    } else {
        logger_debug(DEBUG_TEST2, 1, "ppSecurityID=%s", params[1]);
    }
    params[2] = req.getHeader("ExchangeID");
    if (NULL == params[2]) {
        params_flag = false;
        logger_error("ExchangeID is null");
        write_buf.format("ExchangeID is null");
    }

    if (params_flag) {
        int md_threads_vector = false;
        for(auto v = sm_vMd.begin(); v != sm_vMd.end(); ++v) {
            if (strcmp(v->first, params[0]) == 0) {
                MdSpi* mdSpi = (MdSpi*)v->second;
                int rt = mdSpi->subscribeMarketData(params[1], 0, params[2]);
                write_buf.format("%d", rt);
                md_threads_vector = true;
                break;
            }
        }
        if (!md_threads_vector) {
            logger_error("InvestorID is invalid, The corresponding thread could not be found!, InvestorID= %s", params[0]);
            write_buf.format("%d", -19001);
        }
    }

    res.setContentLength(write_buf.size());
    return res.write(write_buf);
}

// 请求取消订阅
bool MdHttp::UnSubscribeMarketData(HttpRequest& req, HttpResponse& res)
{
    logger("取消订阅");
//    // 获取 body 中的数据，如果没有消费HTTP BODY数据，会导致报错
    acl::string write_buf;
    const char* params[3]{NULL};
    bool params_flag = true;
    params[0] = req.getHeader("InvestorID");
    if (NULL == params[0]) {
        params_flag = false;
        logger_error("InvestorID is null");
        write_buf.format("InvestorID is null");
    }
    params[1] = req.getHeader("ppSecurityID");
    if (NULL == params[1]) {
        params_flag = false;
        logger_error("ppSecurityID is null");
        write_buf.append(", ppSecurityID is null");
    } else {
        logger_debug(DEBUG_TEST2, 1, "ppSecurityID=%s", params[1]);
    }
    params[2] = req.getHeader("ExchangeID");
    if (NULL == params[2]) {
        params_flag = false;
        logger_error("ExchangeID is null");
        write_buf.format("ExchangeID is null");
    }

    if (params_flag) {
        int md_threads_vector = false;
        for(auto v = sm_vMd.begin(); v != sm_vMd.end(); ++v) {
            if (strcmp(v->first, params[0]) == 0) {
                MdSpi* mdSpi = (MdSpi*)v->second;
                int rt = mdSpi->unSubscribeMarketData(params[1], 0, params[2]);
                write_buf.format("%d", rt);
                md_threads_vector = true;
                break;
            }
        }
        if (!md_threads_vector) {
            logger_error("AccountNo is invalid, The corresponding thread could not be found!, AccountNo= %s", params[0]);
            write_buf.format("%d", -19001);
        }
    }

    res.setContentLength(write_buf.size());
    return res.write(write_buf);
}

//bool Httpsm_pMdSpi::Connectsm_pMdSpi(HttpRequest& req, HttpResponse& res)
//{
//    logger("Connectsm_pMdSpi");
////    // 获取 body 中的数据，如果没有消费HTTP BODY数据，会导致报错
//    acl::string write_buf;
//    const char* param;
//    bool params_flag = true;
//
//    param = req.getHeader("AccountNo");
//    if (!param) {
//        params_flag = false;
//        logger_error("AccountNo is null");
//        write_buf.format("AccountNo is null");
//    }
//
//    if (params_flag) {
//        int md_threads_vector = false;
//        for(auto v = md_vector.begin(); v != md_vector.end(); ++v) {
//            if (v->first == param) {
//                sm_pMdSpi* q = (sm_pMdSpi*)v->second;
//                int rt = q->q_login();
//                write_buf.format("%d", rt);
//                md_threads_vector = true;
//                break;
//            }
//        }
//        if (!md_threads_vector) {
//            logger("AccountNo is invalid, The corresponding thread could not be found!, AccountNo= %s", param);
//            write_buf.format("%d", -19001);
//        }
//    }
//
//    res.setContentLength(write_buf.size());
//    return res.write(write_buf);
//}

//请求登出
bool MdHttp::Logout(HttpRequest& req, HttpResponse& res)
{
    logger("登出");
//    // 获取 body 中的数据，如果没有消费HTTP BODY数据，会导致报错
    acl::string write_buf;
//    const char* param;
//    bool params_flag = true;

//    param = req.getHeader("InvestorID");
//    if (!param) {
//        params_flag = false;
//        logger_error("InvestorID is null");
//        write_buf.format("InvestorID is null");
//    }

//    if (params_flag) {
//        int md_threads_vector = false;
//        for(auto v = md_vector.begin(); v != md_vector.end(); ++v) {
//            if (strcmp(v->first, param) == 0) {
//                sm_pMdSpi* mdSpi = (sm_pMdSpi*)v->second;
//                int rt = mdSpi->reqUserLogout();
//                write_buf.format("%d", rt);
//                md_threads_vector = true;
//                break;
//            }
//        }
//        if (!md_threads_vector) {
//            logger("AccountNo is invalid, The corresponding thread could not be found!, AccountNo= %s", param);
//            write_buf.format("%d", -19001);
//        }
//    }

//    if (params_flag) {
//        int rt = sm_pMdSpi->reqUserLogout();
//        write_buf.format("%d", rt);
//    }

    // 释放内存
    res.setContentLength(write_buf.size());
    return res.write(write_buf);
}