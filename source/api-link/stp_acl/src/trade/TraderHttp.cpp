//
// Created by root on 4/14/21.
//

#include <iostream>
#include <stdlib/acl_argv.h>
#include "trade/TraderHttp.h"
#include "http/MasterService.h"
#include "http/HttpService.h"

std::vector<std::pair<const char *, TraderSpi*>> TraderHttp::sm_vTrader;

TraderHttp::TraderHttp() {}

TraderHttp::~TraderHttp() {}

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

//void TradeHttp::setTradeApi(TraderSpi *spi) {
//    p_tradeSpi = spi;
//}

void TraderHttp::setTraderVector(std::vector<std::pair<const char *, TraderSpi*>> trade) {
    sm_vTrader = trade;
}


void TraderHttp::start(const char* addrs) {
    MasterService ms;
    HttpService& service = ms.get_service();

    // 设置配置参数表
    ms.set_cfg_int(var_conf_int_tab)
            .set_cfg_int64(var_conf_int64_tab)
            .set_cfg_str(var_conf_str_tab)
            .set_cfg_bool(var_conf_bool_tab);

    // Register http handlers according different url path
    service.Get("/QryExchange", this->ReqQryExchange)
            .Get("/QrySecurity", this->ReqQrySecurity)
            .Get("/QryMarket", this->ReqQryMarket)
            .Get("/QryShareholderAccount", this->ReqQryShareholderAccount)
            .Get("/QryTradingAccount", this->ReqQryTradingAccount)
            .Post("/OrderInsert", this->ReqOrderInsert)
            .Post("/OrderAction", this->ReqOrderAction)
            .Get("/QryOrder", this->ReqQryOrder)
            .Get("/QryTrade", this->ReqQryTrade)
            .Get("/QryPosition", this->ReqQryPosition)
            .Get("/QryUser", this->ReqQryUser)
            .Get("/QryInvestor", this->ReqQryInvestor)
            .Get("/QryInvestorTradingFee", this->ReqQryInvestorTradingFee)
            .Get("/QryTradingFee", this->ReqQryTradingFee)
            .Get("/QryOrderFundDetail", this->ReqQryOrderFundDetail)
            .Default(http_default);

    if (setenv("SERVICE_LOG", "logs/trade/tradeServer.log", 1) == 0) {
        logger("modify the environment SERVICE_LOG");
    }
    // 开始运行

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
    ms.run_alone(addrs, NULL, count, max_threads);
}



// 请求报单录入
bool TraderHttp::ReqOrderInsert(HttpRequest& req, HttpResponse& res)
{
    logger("报单录入");
    acl::string write_buf;
    const char* params[9]{NULL};
    bool bParams = true;
    acl::json* json = req.getJson();
    if (NULL == json) {
        acl::string data("{ \"err\": \"no json\"}");
        res.setContentLength(data.size());
        return res.write(data);
    }

    ACL_ARGV *argv = acl_argv_split("InvestorID,SecurityID,ShareholderID,ExchangeID,Direction,"
                                    "OrderPriceType,Volume,TimeCondition,VolumeCondition", ",");
//    ACL_ARGV *argv = acl_argv_split("InvestorID,SecurityID,ShareholderID,ExchangeID,Direction,"
//                                    "OrderPriceType,Volume,", ",");
    ACL_ITER iter;  // 遍历指针
    unsigned int i= 0;
    // 遍历分割后的结果
            acl_foreach(iter, argv) {
        // 从遍历指针中取出字符串型数据
        const char *iter_ptr =  (const char*) iter.data;
        acl::json_node* jsonNode = json->getFirstElementByTagName(iter_ptr);
        if (NULL == jsonNode) {
            bParams = false;
            logger_error("%s is null", iter_ptr);
            write_buf.format_append("%s is null ", iter_ptr);
            break;
        } else {
            params[i] = jsonNode->get_text();
        }
        ++i;
    }
    const char *OrderRef = NULL;
    acl::json_node* jsonNode = json->getFirstElementByTagName("OrderRef");
    if (jsonNode != NULL)
    {
        OrderRef = jsonNode->get_text();
    }
    // 如果为市价单，不必填写价格
    const char *LimitPrice = NULL;
    if (strcmp(params[5], "1") != 0) {
        acl::json_node* jsonNode = json->getFirstElementByTagName("LimitPrice");
        if (NULL == jsonNode) {
            bParams = false;
            logger_error("LimitPrice is null");
            write_buf.format("LimitPrice is null");
        } else {
            LimitPrice = jsonNode->get_text();
        }
    }
    const char *SInfo = NULL;
    jsonNode = json->getFirstElementByTagName("SInfo");
    if (jsonNode != NULL)
    {
        SInfo = jsonNode->get_text();
    }

    if (bParams) {
        bool trader_threads_vector = false;
        for(auto v = sm_vTrader.begin(); v != sm_vTrader.end(); ++v) {
            if (strcmp(v->first, params[0]) == 0) {
                TraderSpi* tradeSpi = (TraderSpi*)v->second;
                int rt = tradeSpi->reqOrderInsert(params[1], params[2],params[3],OrderRef, params[4],params[5],
                                       LimitPrice,params[6], SInfo, params[7], params[8]);
                write_buf.format("%d", rt);
                trader_threads_vector = true;
                break;
            }
        }
        if (!trader_threads_vector) {
            logger("InvestorID is invalid, The corresponding thread could not be found!, InvestorID= %s", params[0]);
            write_buf.format("%d", -19001);
        }
    }

    // 释放内存
    acl_argv_free(argv);
    res.setContentLength(write_buf.size());
    return res.write(write_buf);
}

// 报单操作请求
bool TraderHttp::ReqOrderAction(HttpRequest& req, HttpResponse& res)
{
    logger("撤单");
    acl::string write_buf;
    const char* params[6]{NULL};
    bool bParams = true;
    acl::json* json = req.getJson();
    if (NULL == json) {
        acl::string data("{ \"err\": \"no json\"}");
        res.setContentLength(data.size());
        return res.write(data);
    }

    ACL_ARGV *argv = acl_argv_split("InvestorID,ExchangeID,FrontID,SessionID,OrderRef", ",");
    ACL_ITER iter;  // 遍历指针
    unsigned int i=0 ;
    // 遍历分割后的结果
            acl_foreach(iter, argv) {
        // 从遍历指针中取出字符串型数据
        const char *iter_ptr =  (const char*) iter.data;
        acl::json_node* jsonNode = json->getFirstElementByTagName(iter_ptr);
        if (NULL == jsonNode) {
            bParams = false;
            logger_error("%s is null", iter_ptr);
            write_buf.format_append("%s is null ", iter_ptr);
            break;
        } else {
            params[i] = jsonNode->get_text();
            logger("iter_ptr:%s", params[i]);
        }
        ++i;
    }

    acl::json_node* jsonNode = json->getFirstElementByTagName("SInfo");
     if (jsonNode != NULL)
     {
         params[5] = jsonNode->get_text();
     }

    if (bParams) {
        bool trader_threads_vector = false;
        for(auto v = sm_vTrader.begin(); v != sm_vTrader.end(); ++v) {
            if (strcmp(v->first, params[0]) == 0) {
                TraderSpi* tradeSpi = (TraderSpi*)v->second;
                int rt = tradeSpi->reqOrderAction(params[1],params[2],params[3],params[4],params[5]);
                write_buf.format("%d", rt);
                trader_threads_vector = true;
                break;
            }
        }
        if (!trader_threads_vector) {
            logger("InvestorID is invalid, The corresponding thread could not be found!, InvestorID= %s", params[0]);
            write_buf.format("%d", -19001);
        }
    }

    // 释放内存
    acl_argv_free(argv);
    res.setContentLength(write_buf.size());
    return res.write(write_buf);
}


// 请求查询报单
bool TraderHttp::ReqQryOrder(HttpRequest& req, HttpResponse& res)
{
    logger("查询报单");
    acl::string write_buf;
    const char* param;
    bool bParams = true;
    param = req.getHeader("InvestorID");
    if (NULL == param) {
        bParams = false;
        logger_error("InvestorID is null");
        write_buf.format("InvestorID is null");
    }

    if (bParams) {
        bool trader_threads_vector = false;
        for(auto v = sm_vTrader.begin(); v != sm_vTrader.end(); ++v) {
            if (strcmp(v->first, param) == 0) {
                TraderSpi* tradeSpi = (TraderSpi*)v->second;
                int rt = tradeSpi->reqQryOrder();
                write_buf.format("%d", rt);
                trader_threads_vector = true;
                break;
            }
        }
        if (!trader_threads_vector) {
            logger("InvestorID is invalid, The corresponding thread could not be found!, InvestorID= %s", param);
            write_buf.format("%d", -19001);
        }
    }
    res.setContentLength(write_buf.size());
    return res.write(write_buf);
}

// 请求查询成交
bool TraderHttp::ReqQryTrade(HttpRequest& req, HttpResponse& res)
{
    logger("查询成交");
    acl::string write_buf;
    const char* param;
    bool bParams = true;
    param = req.getHeader("InvestorID");
    if (NULL == param) {
        bParams = false;
        logger_error("InvestorID is null");
        write_buf.format("InvestorID is null");
    }

    if (bParams) {
        bool trader_threads_vector = false;
        for(auto v = sm_vTrader.begin(); v != sm_vTrader.end(); ++v) {
            if (strcmp(v->first, param) == 0) {
                TraderSpi* tradeSpi = (TraderSpi*)v->second;
                int rt = tradeSpi->reqQryTrade();
                write_buf.format("%d", rt);
                trader_threads_vector = true;
                break;
            }
        }
        if (!trader_threads_vector) {
            logger("InvestorID is invalid, The corresponding thread could not be found!, InvestorID= %s", param);
            write_buf.format("%d", -19001);
        }
    }
    res.setContentLength(write_buf.size());
    return res.write(write_buf);
}

// 请求查询投资者持仓
bool TraderHttp::ReqQryPosition(HttpRequest& req, HttpResponse& res)
{
    logger("查询投资者持仓");
    acl::string write_buf;
    const char* param;
    bool bParams = true;
    param = req.getHeader("InvestorID");
    if (NULL == param) {
        bParams = false;
        logger_error("InvestorID is null");
        write_buf.format("InvestorID is null");
    }

    if (bParams) {
        bool trader_threads_vector = false;
        for(auto v = sm_vTrader.begin(); v != sm_vTrader.end(); ++v) {
            if (strcmp(v->first, param) == 0) {
                TraderSpi* tradeSpi = (TraderSpi*)v->second;
                int rt = tradeSpi->reqQryPosition();
                write_buf.format("%d", rt);
                trader_threads_vector = true;
                break;
            }
        }
        if (!trader_threads_vector) {
            logger("InvestorID is invalid, The corresponding thread could not be found!, InvestorID= %s", param);
            write_buf.format("%d", -19001);
        }
    }
    res.setContentLength(write_buf.size());
    return res.write(write_buf);
}




bool TraderHttp::ReqQryExchange(HttpRequest& req, HttpResponse& res)
{
    logger("查询交易所");
    acl::string write_buf;
    const char* params[2]{NULL};
    bool bParams = true;
    params[0] = req.getHeader("InvestorID");
    if (NULL == params[0]) {
        bParams = false;
        logger_error("InvestorID is null");
        write_buf.format("InvestorID is null");
    } else {
        logger("InvestorID = %s", params[0]);
    }

    params[1] = req.getHeader("ExchangeID");
    if (params[1] != NULL) {
        logger("ExchangeID = %s", params[1]);
    }
    if (bParams) {
        bool trader_threads_vector = false;
        for(auto v = sm_vTrader.begin(); v != sm_vTrader.end(); ++v) {
            if (strcmp(v->first, params[0]) == 0) {
                TraderSpi* tradeSpi = (TraderSpi*)v->second;
                int rt = tradeSpi->reqQryExchange(params[1]);
                write_buf.format("%d", rt);
                trader_threads_vector = true;
                break;
            }
        }
        if (!trader_threads_vector) {
            logger("InvestorID is invalid, The corresponding thread could not be found!, InvestorID= %s", params[0]);
            write_buf.format("%d", -19001);
        }
    }
    res.setContentLength(write_buf.size());
    return res.write(write_buf);
}

// 查询证券信息
bool TraderHttp::ReqQrySecurity(HttpRequest& req, HttpResponse& res)
{
    logger("查询证券信息");
    acl::string write_buf;
    const char* params[4]{NULL};
    bool bParams = true;
    params[0] = req.getHeader("InvestorID");
    if (NULL == params[0]) {
        bParams = false;
        logger_error("InvestorID is null");
        write_buf.format("InvestorID is null");
    } else {
        logger("InvestorID = %s", params[0]);
    }
    params[1] = req.getHeader("SecurityID");
    params[2] = req.getHeader("ExchangeID");
    params[3] = req.getHeader("ProductID");

    if (bParams) {
        bool trader_threads_vector = false;
        for(auto v = sm_vTrader.begin(); v != sm_vTrader.end(); ++v) {
            if (strcmp(v->first, params[0]) == 0) {
                TraderSpi* tradeSpi = (TraderSpi*)v->second;
                int rt = tradeSpi->reqQrySecurity(params[1],params[2],params[3]);
                write_buf.format("%d", rt);
                trader_threads_vector = true;
                break;
            }
        }
        if (!trader_threads_vector) {
            logger("InvestorID is invalid, The corresponding thread could not be found!, InvestorID= %s", params[0]);
            write_buf.format("%d", -19001);
        }
    }
    res.setContentLength(write_buf.size());
    return res.write(write_buf);
}

// 查询市场
bool TraderHttp::ReqQryMarket(HttpRequest& req, HttpResponse& res)
{
    logger("查询市场");
    acl::string write_buf;
    const char* params[5]{NULL};
    bool bParams = true;
    params[0] = req.getHeader("InvestorID");
    if (NULL == params[0]) {
        bParams = false;
        logger_error("InvestorID is null");
        write_buf.format("InvestorID is null");
    } else {
        logger("InvestorID = %s", params[0]);
    }
    params[1] = req.getHeader("ExchangeID");
    params[2] = req.getHeader("MarketID");
    if (bParams) {
        bool trader_threads_vector = false;
        for(auto v = sm_vTrader.begin(); v != sm_vTrader.end(); ++v) {
            if (strcmp(v->first, params[0]) == 0) {
                TraderSpi* tradeSpi = (TraderSpi*)v->second;
                int rt = tradeSpi->reqQryMarket(params[1],params[2]);
                write_buf.format("%d", rt);
                trader_threads_vector = true;
                break;
            }
        }
        if (!trader_threads_vector) {
            logger("InvestorID is invalid, The corresponding thread could not be found!, InvestorID= %s", params[0]);
            write_buf.format("%d", -19001);
        }
    }
    res.setContentLength(write_buf.size());
    return res.write(write_buf);
}

// 查询股东账户
bool TraderHttp::ReqQryShareholderAccount(HttpRequest& req, HttpResponse& res)
{
    logger("查询股东账户");
    acl::string write_buf;
    const char* params[5]{NULL};
    bool bParams = true;
    params[0] = req.getHeader("InvestorID");
    if (NULL == params[0]) {
        bParams = false;
        logger_error("InvestorID is null");
        write_buf.format("InvestorID is null");
    } else {
        logger("InvestorID = %s", params[0]);
    }
    params[1] = req.getHeader("ExchangeID");
    params[2] = req.getHeader("MarketID");
    params[3] = req.getHeader("ShareholderID");
    params[4] = req.getHeader("TradingCodeClass");

    if (bParams) {
        bool trader_threads_vector = false;
        for(auto v = sm_vTrader.begin(); v != sm_vTrader.end(); ++v) {
            if (strcmp(v->first, params[0]) == 0) {
                TraderSpi* tradeSpi = (TraderSpi*)v->second;
                int rt = tradeSpi->reqQryShareholderAccount(params[1],params[2],params[3],params[4]);
                write_buf.format("%d", rt);
                trader_threads_vector = true;
                break;
            }
        }
        if (!trader_threads_vector) {
            logger("InvestorID is invalid, The corresponding thread could not be found!, InvestorID= %s", params[0]);
            write_buf.format("%d", -19001);
        }
    }
    res.setContentLength(write_buf.size());
    return res.write(write_buf);
}


// 请求查询资金帐户
bool TraderHttp::ReqQryTradingAccount(HttpRequest& req, HttpResponse& res)
{
    logger("查询资金账户");
    acl::string write_buf;
    const char* params[5];
    bool bParams = true;
    params[0] = req.getHeader("InvestorID");
    if (NULL == params[0]) {
        bParams = false;
        logger_error("InvestorID is null");
        write_buf.format("InvestorID is null");
    } else {
        logger("InvestorID = %s", params[0]);
    }
    params[1] = req.getHeader("CurrencyID");
    params[2] = req.getHeader("AccountID");
    params[3] = req.getHeader("AccountType");
    params[4] = req.getHeader("DepartmentID");


    if (bParams) {
        bool trader_threads_vector = false;
        for(auto v = sm_vTrader.begin(); v != sm_vTrader.end(); ++v) {
            if (strcmp(v->first, params[0]) == 0) {
                TraderSpi* tradeSpi = (TraderSpi*)v->second;
                int rt = tradeSpi->reqQryTradingAccount(params[0],params[1],params[2],params[3],params[4]);
                write_buf.format("%d", rt);
                trader_threads_vector = true;
                break;
            }
        }
        if (!trader_threads_vector) {
            logger("InvestorID is invalid, The corresponding thread could not be found!, InvestorID= %s", params[0]);
            write_buf.format("%d", -19001);
        }
    }
    res.setContentLength(write_buf.size());
    return res.write(write_buf);
}

// 查询用户请求
bool TraderHttp::ReqQryUser(HttpRequest& req, HttpResponse& res)
{
    logger("查询用户请求");
    acl::string write_buf;
    const char* params[5];
    bool bParams = true;
    params[0] = req.getHeader("InvestorID");
    if (NULL == params[0]) {
        bParams = false;
        logger_error("InvestorID is null");
        write_buf.format("InvestorID is null");
    } else {
        logger("InvestorID = %s", params[0]);
    }

    if (bParams) {
        bool trader_threads_vector = false;
        for(auto v = sm_vTrader.begin(); v != sm_vTrader.end(); ++v) {
            if (strcmp(v->first, params[0]) == 0) {
                TraderSpi* tradeSpi = (TraderSpi*)v->second;
                int rt = tradeSpi->reqQryUser();
                write_buf.format("%d", rt);
                trader_threads_vector = true;
                break;
            }
        }
        if (!trader_threads_vector) {
            logger("InvestorID is invalid, The corresponding thread could not be found!, InvestorID= %s", params[0]);
            write_buf.format("%d", -19001);
        }
    }
    res.setContentLength(write_buf.size());
    return res.write(write_buf);
}
// 查询投资者请求
bool TraderHttp::ReqQryInvestor(HttpRequest& req, HttpResponse& res)
{
    logger("查询投资者请求");
    acl::string write_buf;
    const char* params[1];
    bool bParams = true;
    params[0] = req.getHeader("InvestorID");
    if (NULL == params[0]) {
        bParams = false;
        logger_error("InvestorID is null");
        write_buf.format("InvestorID is null");
    } else {
        logger("InvestorID = %s", params[0]);
    }

    if (bParams) {
        bool trader_threads_vector = false;
        for(auto v = sm_vTrader.begin(); v != sm_vTrader.end(); ++v) {
            if (strcmp(v->first, params[0]) == 0) {
                TraderSpi* tradeSpi = (TraderSpi*)v->second;
                int rt = tradeSpi->reqQryInvestor();
                write_buf.format("%d", rt);
                trader_threads_vector = true;
                break;
            }
        }
        if (!trader_threads_vector) {
            logger("InvestorID is invalid, The corresponding thread could not be found!, InvestorID= %s", params[0]);
            write_buf.format("%d", -19001);
        }
    }
    res.setContentLength(write_buf.size());
    return res.write(write_buf);
}

// 查询佣金费率
bool TraderHttp::ReqQryInvestorTradingFee(HttpRequest &req, HttpResponse &res)
{
    logger("查询佣金费率");
    acl::string write_buf;
    const char* params[3];
    bool bParams = true;
    params[0] = req.getHeader("InvestorID");
    if (NULL == params[0]) {
        bParams = false;
        logger_error("InvestorID is null");
        write_buf.format("InvestorID is null");
    } else {
        logger("InvestorID = %s", params[0]);
    }

    params[1] = req.getHeader("ExchangeID");
    params[2] = req.getHeader("DepartmentID");

    if (bParams) {
        bool trader_threads_vector = false;
        for(auto v = sm_vTrader.begin(); v != sm_vTrader.end(); ++v) {
            if (strcmp(v->first, params[0]) == 0) {
                TraderSpi* tradeSpi = (TraderSpi*)v->second;
                int rt = tradeSpi->reqQryInvestorTradingFee(params[1], params[2]);
                write_buf.format("%d", rt);
                trader_threads_vector = true;
                break;
            }
        }
        if (!trader_threads_vector) {
            logger("InvestorID is invalid, The corresponding thread could not be found!, InvestorID= %s", params[0]);
            write_buf.format("%d", -19001);
        }
    }
    res.setContentLength(write_buf.size());
    return res.write(write_buf);
}

// 查询基础交易费率响应
bool TraderHttp::ReqQryTradingFee(HttpRequest &req, HttpResponse &res)
{
    logger("查询基础交易费率");
    acl::string write_buf;
    const char* params[2];
    bool bParams = true;
    params[0] = req.getHeader("InvestorID");
    if (NULL == params[0]) {
        bParams = false;
        logger_error("InvestorID is null");
        write_buf.format("InvestorID is null");
    } else {
        logger("InvestorID = %s", params[0]);
    }

    params[1] = req.getHeader("ExchangeID");

    if (bParams) {
        bool trader_threads_vector = false;
        for(auto v = sm_vTrader.begin(); v != sm_vTrader.end(); ++v) {
            if (strcmp(v->first, params[0]) == 0) {
                TraderSpi* tradeSpi = (TraderSpi*)v->second;
                int rt = tradeSpi->reqQryTradingFee(params[1]);
                write_buf.format("%d", rt);
                trader_threads_vector = true;
                break;
            }
        }
        if (!trader_threads_vector) {
            logger("InvestorID is invalid, The corresponding thread could not be found!, InvestorID= %s", params[0]);
            write_buf.format("%d", -19001);
        }
    }
    res.setContentLength(write_buf.size());
    return res.write(write_buf);
}


bool TraderHttp::ReqQryOrderFundDetail(HttpRequest &req, HttpResponse &res)
{
    logger("ReqQryOrderFundDetail");
    acl::string write_buf;
    const char* params[1];
    bool bParams = true;
    params[0] = req.getHeader("InvestorID");
    if (NULL == params[0]) {
        bParams = false;
        logger_error("InvestorID is null");
        write_buf.format("InvestorID is null");
    } else {
        logger("InvestorID = %s", params[0]);
    }

    if (bParams) {
        bool trader_threads_vector = false;
        for(auto v = sm_vTrader.begin(); v != sm_vTrader.end(); ++v) {
            if (strcmp(v->first, params[0]) == 0) {
                TraderSpi* tradeSpi = (TraderSpi*)v->second;
                int rt = tradeSpi->reqQryOrderFundDetail();
                write_buf.format("%d", rt);
                trader_threads_vector = true;
                break;
            }
        }
        if (!trader_threads_vector) {
            logger("InvestorID is invalid, The corresponding thread could not be found!, InvestorID= %s", params[0]);
            write_buf.format("%d", -19001);
        }
    }
    res.setContentLength(write_buf.size());
    return res.write(write_buf);
}

// 请求登出
bool TraderHttp::ReqUserLogout(HttpRequest& req, HttpResponse& res)
{
    logger("登出");
    acl::string write_buf;
    const char* param;
    bool bParams = true;
    param = req.getHeader("InvestorID");
    if (NULL == param) {
        bParams = false;
        logger_error("InvestorID is null");
        write_buf.format("InvestorID is null");
    }

//    if (bParams) {
//        bool trader_threads_vector = false;
//        for(auto v = sm_vTrader.begin(); v != sm_vTrader.end(); ++v) {
//            if (strcmp(v->first, param) == 0) {
//                TraderSpi* tradeSpi = (TraderSpi*)v->second;
//                int rt = tradeSpi->reqUserLogout();
//                write_buf.format("%d", rt);
//                trader_threads_vector = true;
//                break;
//            }
//        }
//        if (!trader_threads_vector) {
//            logger("InvestorID is invalid, The corresponding thread could not be found!, InvestorID= %s", param);
//            write_buf.format("%d", -19001);
//        }
//    }
    res.setContentLength(write_buf.size());
    return res.write(write_buf);
}


