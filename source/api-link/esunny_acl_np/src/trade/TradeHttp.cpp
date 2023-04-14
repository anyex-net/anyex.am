//
// Created by root on 4/14/21.
//
#include <iostream>
#include <stdlib/acl_argv.h>
//#include <acl_cpp/lib_acl.hpp>
#include "trade/TradeHttp.h"
#include "trade/Trade.h"
#include "http/MasterService.h"
#include "http/HttpService.h"

extern std::vector<std::pair<acl::string, Trade *>> trade_vector;

TradeHttp::TradeHttp() {}

TradeHttp::~TradeHttp() {}

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

void TradeHttp::start(const char* addrs) {
    MasterService ms;
    HttpService& service = ms.get_service();

    // 设置配置参数表
    ms.set_cfg_int(var_conf_int_tab)
            .set_cfg_int64(var_conf_int64_tab)
            .set_cfg_str(var_conf_str_tab)
            .set_cfg_bool(var_conf_bool_tab);

    // Register http handlers according different url path
    service.Post("/InsertOrder", this->InsertOrder)
            .Post("/CancelOrder", this->CancelOrder)
            .Get("/QryExchangeInfo", this->QryExchangeInfo)
            .Get("/QryAccountInfo", this->QryAccountInfo)
            .Get("/QryCommodityInfo", this->QryCommodityInfo)
            .Get("/QryContractInfo", this->QryContractInfo)
            .Get("/QryFundData", this->QryFundData)
            .Get("/QryPositionInfo", this->QryPositionInfo)
            .Get("/QryCloseInfo", this->QryCloseInfo)
            .Get("/QryOrderInfo", this->QryOrderInfo)
            .Get("/QryFillInfo", this->QryFillInfo)
            .Get("/QryAccountRentInfo", this->QryAccountRentInfo)
//            .Get("/ConnectTrade", this->ConnectTrade)
//            .Get("/DisConnectTrade", this->DisConnectTrade)
            .Default(http_default);
//    logger_close();
    // bin
    if (setenv("SERVICE_LOG", "logs/trade/tradeServer.log", 1) == 0) {
        logger("modify the environment SERVICE_LOG");
    }
    // 开始运行
    int argc = 1;
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

/// 交易相关操作
// 下单
bool TradeHttp::InsertOrder(HttpRequest& req, HttpResponse& res)
{
    logger("下单");
    acl::string write_buf;
    const char* params[9]{NULL};
    bool bParams = true;
    acl::json* json = req.getJson();
    if (json == NULL)
    {
        acl::string data("{ \"err\": \"no json\"}");
        res.setContentLength(data.size());
        return res.write(data);
    }

    ACL_ARGV *argv = acl_argv_split("AccountNo,ExchangeNo,"
                                    "CommodityNo,ContractNo,OrderType,TimeInForce,"
                                    "OrderSide,PositionEffect,OrderQty,RefString", ",");
    ACL_ITER iter;  // 遍历指针
    // 遍历分割后的结果
     acl_foreach(iter, argv)
     {
        // 从遍历指针中取出字符串型数据
        const char *iter_ptr =  (const char*) iter.data;
        acl::json_node* jsonNode = json->getFirstElementByTagName(iter_ptr);
        if (NULL == jsonNode)
        {
            bParams = false;
            logger_error("%s is null", iter_ptr);
            write_buf.format("%s is null", iter_ptr);
            break;
        }
        else {
            params[iter.i] = jsonNode->get_text();
        }
    }

    // 市价与市价止损不必填写价格
    const char *OrderPrice = NULL;
    if ((strcmp(params[4], "1") != 0) && (strcmp(params[4], "3") != 0) && (strcmp(params[4], "C") != 0))
    {
        acl::json_node* jsonNode1 = json->getFirstElementByTagName("OrderPrice");
        if (NULL == jsonNode1)
        {
            bParams = false;
            logger_error("OrderPrice is null");
            write_buf.format("OrderPrice is null", OrderPrice);
        }
        else {
            OrderPrice = jsonNode1->get_text();
        }
    }
    // 委托有效类型是指定日期前有效，须填写日期
    const char *ExpireTime = NULL;
    if ((strcmp(params[5], "2") == 0))
    {
        acl::json_node* jsonNode1 = json->getFirstElementByTagName("ExpireTime");
        if (NULL == jsonNode1) {
            bParams = false;
            logger_error("ExpireTime is null");
            write_buf.format("ExpireTime is null", OrderPrice);
        } else {
            ExpireTime = jsonNode1->get_text();
        }
    }

    const char *RefString = NULL;
    acl::json_node* jsonNode2 = json->getFirstElementByTagName("RefString");
    if (jsonNode2 != NULL) {
        RefString = jsonNode2->get_text();
    }

//    const char *StopPrice = NULL;
//     if ((strcmp(params[4], "3") == 0) || ((strcmp(params[4], "4") == 0)))
//     {
//         logger("params[4] %s", params[4]);
//         acl::json_node* jsonNode1 = json->getFirstElementByTagName("StopPrice");
//         if (NULL == jsonNode1) {
//             bParams = false;
//             logger_error("StopPrice is null", StopPrice);
//             write_buf.format("StopPrice is null", StopPrice);
//         } else {
//             StopPrice = jsonNode1->get_text();
//         }
//     }

    if (bParams)
    {
        bool trade_threads_vector = false;
        for(auto v = trade_vector.begin(); v != trade_vector.end(); ++v)
        {
            if (strcmp(params[0], (v->first).c_str()) == 0)
            {
                Trade* t = (Trade*)v->second;
                int rt = t->t_insertOrder(params[1],params[2],params[3],
                        params[4],params[5],ExpireTime,params[6],params[7],
                        OrderPrice,params[8],RefString);
                write_buf.format("%d", rt);
                trade_threads_vector = true;
                break;
            }
        }
        if (!trade_threads_vector)
        {
            logger_error("AccountNo is invalid, The corresponding thread could not be found!, AccountNo= %s", params[0]);
            write_buf.format("%d", -19001);
        }
    }
    // 释放内存
    acl_argv_free(argv);
    res.setContentLength(write_buf.size());
    return res.write(write_buf);
}

bool TradeHttp::CancelOrder(HttpRequest& req, HttpResponse& res)
{
    logger("撤单");
    acl::string write_buf;
    const char* AccountNo = NULL, *OrderNo = NULL;
    bool bParams = true;

    acl::json* json = req.getJson();
    if (NULL == json)
    {
        acl::string data("{ \"err\": \"no json\"}");
        res.setContentLength(data.size());
        return res.write(data);
    }
    acl::json_node* jsonNode1 = json->getFirstElementByTagName("AccountNo");
    if (NULL == jsonNode1)
    {
        bParams = false;
        logger_error("AccountNo is null");
        write_buf.format("AccountNo is null");
    }
    else
    {
        AccountNo = jsonNode1->get_text();
    }
    acl::json_node* jsonNode2 = json->getFirstElementByTagName("OrderNo");
    if (NULL == jsonNode2)
    {
        bParams = false;
        logger_error("OrderNo is null");
        write_buf.format("OrderNo is null");
    }
    else
    {
        OrderNo = jsonNode2->get_text();
    }

    if (bParams)
    {
        bool trade_threads_vector = false;
        for(auto v = trade_vector.begin(); v != trade_vector.end(); ++v)
        {
            if (strcmp(AccountNo, (v->first).c_str()) == 0)
            {
                Trade* t = (Trade*)v->second;
                int rt = t->t_cancelOrder(OrderNo);
                write_buf.format("%d", rt);
                trade_threads_vector = true;
                break;
            }
        }
        if (!trade_threads_vector)
        {
            logger_error("AccountNo is invalid, The corresponding thread could not be found!, AccountNo= %s", AccountNo);
            write_buf.format("%d", -19001);
        }
    }
    res.setContentLength(write_buf.size());
    return res.write(write_buf);
}

/// 查询用户交易信息
bool TradeHttp::QryOrderInfo(HttpRequest& req, HttpResponse& res)
{
    logger("查询委托");
    acl::string write_buf;
    bool bParams = true;
    const char* AccountNo = req.getHeader("AccountNo");
    if (NULL == AccountNo)
    {
        bParams = false;
        logger_error("AccountNo is null");
        write_buf.format("AccountNo is null");
    }
    const char *OrderQryType = req.getHeader("OrderQryType");
    if (NULL == OrderQryType)
    {
        bParams = false;
        logger_error("OrderQryType is null");
        write_buf.format("OrderQryType is null");
    }

    if (bParams)
    {
        bool trade_threads_vector = false;
        for(auto v = trade_vector.begin(); v != trade_vector.end(); ++v)
        {
            if (strcmp(AccountNo, (v->first).c_str()) == 0)
            {
                Trade* t = (Trade*)v->second;
                int rt = t->t_qryOrder(OrderQryType);
                write_buf.format("%d", rt);
                trade_threads_vector = true;
                break;
            }
        }
        if (!trade_threads_vector) {
            logger_error("AccountNo is invalid, The corresponding thread could not be found!, AccountNo= %s", AccountNo);
            write_buf.format("%d", -19001);
        }
    }

    res.setContentLength(write_buf.size());
    return res.write(write_buf);
}

bool TradeHttp::QryFillInfo(HttpRequest& req, HttpResponse& res)
{
    logger("查询成交");
    acl::string write_buf;
    bool bParams = true;
    const char* param = req.getHeader("AccountNo");
    if (NULL == param)
    {
        bParams = false;
        logger_error("AccountNo is null");
        write_buf.format("AccountNo is null");
    }

    if (bParams) {
        bool trade_threads_vector = false;
        for(auto v = trade_vector.begin(); v != trade_vector.end(); ++v)
        {
            if (strcmp(param, (v->first).c_str()) == 0)
            {
                Trade* t = (Trade*)v->second;
                int rt = t->t_qryFill();
                write_buf.format("%d", rt);
                trade_threads_vector = true;
                break;
            }
        }
        if (!trade_threads_vector)
        {
            logger_error("AccountNo is invalid, The corresponding thread could not be found!, AccountNo= %s", param);
            write_buf.format("%d", -19001);
        }
    }
    res.setContentLength(write_buf.size());
    return res.write(write_buf);
}

bool TradeHttp::QryPositionInfo(HttpRequest& req, HttpResponse& res)
{
    logger("查询持仓");
    acl::string write_buf;
    const char* param = NULL;
    bool bParams = true;
    param = req.getHeader("AccountNo");
    if (NULL == param)
    {
        bParams = false;
        logger_error("AccountNo is null");
        write_buf.format("AccountNo is null");
    }

    if (bParams) {
        bool trade_threads_vector = false;
        for(auto v = trade_vector.begin(); v != trade_vector.end(); ++v)
        {
            if (strcmp(param, (v->first).c_str()) == 0)
            {
                Trade* t = (Trade*)v->second;
                int rt = t->t_qryPosition();
                write_buf.format("%d", rt);
                trade_threads_vector = true;
                break;
            }
        }
        if (!trade_threads_vector)
        {
            logger_error("AccountNo is invalid, The corresponding thread could not be found!, AccountNo= %s", param);
            write_buf.format("%d", -19001);
        }
    }
    res.setContentLength(write_buf.size());
    return res.write(write_buf);
}

bool TradeHttp::QryCloseInfo(HttpRequest& req, HttpResponse& res)
{
    logger("查询平仓");
    acl::string write_buf;
    const char* param = NULL;
    bool bParams = true;
    param = req.getHeader("AccountNo");
    if (NULL == param)
    {
        bParams = false;
        logger_error("AccountNo is null");
        write_buf.format("AccountNo is null");
    }

    if (bParams) {
        bool trade_threads_vector = false;
        for(auto v = trade_vector.begin(); v != trade_vector.end(); ++v)
        {
            if (strcmp(param, (v->first).c_str()) == 0)
            {
                Trade* t = (Trade*)v->second;
                int rt = t->t_qryClose();
                write_buf.format("%d", rt);
                trade_threads_vector = true;
                break;
            }
        }
        if (!trade_threads_vector)
        {
            logger_error("AccountNo is invalid, The corresponding thread could not be found!, AccountNo= %s", param);
            write_buf.format("%d", -19001);
        }
    }
    res.setContentLength(write_buf.size());
    return res.write(write_buf);
}


/// 查询用户资金账号
bool TradeHttp::QryAccountInfo(HttpRequest& req, HttpResponse& res)
{
    logger("查询账户信息");
    acl::string write_buf;
    const char* param = NULL;

    bool bParams = true;

    param = req.getHeader("AccountNo");
    if (NULL == param)
    {
        bParams = false;
        logger_error("AccountNo is null");
        write_buf.format("AccountNo is null");
    }

    if (bParams) {
        bool trade_threads_vector = false;
        for(auto v = trade_vector.begin(); v != trade_vector.end(); ++v)
        {
            if (strcmp(param, (v->first).c_str()) == 0)
            {
                Trade* t = (Trade*)v->second;
                int rt = t->t_qryAccount();
                write_buf.format("%d", rt);
                trade_threads_vector = true;
                break;
            }
        }
        if (!trade_threads_vector)
        {
            logger_error("AccountNo is invalid, The corresponding thread could not be found!, AccountNo= %s", param);
            write_buf.format("%d", -19001);
        }
    }
    res.setContentLength(write_buf.size());
    return res.write(write_buf);
}

bool TradeHttp::QryFundData(HttpRequest& req, HttpResponse& res)
{
    logger("查询账户资金信息");
    acl::string write_buf;
    const char* param = NULL;
    bool bParams = true;

    param = req.getHeader("AccountNo");
    if (NULL == param)
    {
        bParams = false;
        logger_error("AccountNo is null");
        write_buf.format("AccountNo is null");
    }

    if (bParams) {
        bool trade_threads_vector = false;
        for(auto v = trade_vector.begin(); v != trade_vector.end(); ++v)
        {
            if (strcmp(param, (v->first).c_str()) == 0) {
                Trade* t = (Trade*)v->second;
                int rt = t->t_qryFund();
                write_buf.format("%d", rt);
                trade_threads_vector = true;
                break;
            }
        }
        if (!trade_threads_vector)
        {
            logger_error("AccountNo is invalid, The corresponding thread could not be found!, AccountNo= %s", param);
            write_buf.format("%d", -19001);
        }
    }

    res.setContentLength(write_buf.size());
    return res.write(write_buf);
}


/// 公共查询
bool TradeHttp::QryExchangeInfo(HttpRequest& req, HttpResponse& res)
{
    logger("查询交易所信息");
    acl::string write_buf;
    const char* param = NULL;
    bool bParams = true;

    param = req.getHeader("AccountNo");
    if (NULL == param)
    {
        bParams = false;
        logger_error("AccountNo is null");
        write_buf.format("AccountNo is null");
    }

    if (bParams) {
        bool trade_threads_vector = false;
        for(auto v = trade_vector.begin(); v != trade_vector.end(); ++v)
        {
            if (strcmp(param, (v->first).c_str()) == 0)
            {
                Trade* t = (Trade*)v->second;
                int rt = t->t_qryExchange();
                write_buf.format("%d", rt);
                trade_threads_vector = true;
                break;
            }
        }
        if (!trade_threads_vector)
        {
            logger_error("AccountNo is invalid, The corresponding thread could not be found!, AccountNo= %s", param);
            write_buf.format("%d", -19001);
        }
    }

    // 释放内存
    res.setContentLength(write_buf.size());
    return res.write(write_buf);
}

bool TradeHttp::QryCommodityInfo(HttpRequest& req, HttpResponse& res)
{
    logger("查询品种信息");
    acl::string write_buf;
    const char* param = NULL;

    bool bParams = true;

    param = req.getHeader("AccountNo");
    if (NULL == param)
    {
        bParams = false;
        logger_error("AccountNo is null");
        write_buf.format("AccountNo is null");
    }

    if (bParams) {
        bool trade_threads_vector = false;
        for(auto v = trade_vector.begin(); v != trade_vector.end(); ++v)
        {
            if (strcmp(param, (v->first).c_str()) == 0)
            {
                Trade* t = (Trade*)v->second;
                int rt = t->t_qryCommodity();
                write_buf.format("%d", rt);
                trade_threads_vector = true;
                break;
            }
        }
        if (!trade_threads_vector)
        {
            logger_error("AccountNo is invalid, The corresponding thread could not be found!, AccountNo= %s", param);
            write_buf.format("%d", -19001);
        }
    }

    // 释放内存
    res.setContentLength(write_buf.size());
    return res.write(write_buf);
}

bool TradeHttp::QryContractInfo(HttpRequest& req, HttpResponse& res)
{
    logger("查询合约信息");
    acl::string write_buf;
    const char* params[4]{NULL};

    bool bParams = true;

    params[0] = req.getHeader("AccountNo");
    if (NULL == params[0])
    {
        bParams = false;
        logger_error("AccountNo is null");
        write_buf.format("AccountNo is null");
    } else
        {
        logger_debug(DEBUG_TEST2, 1, "AccountNo = %s", params[0]);
    }

    params[1] = req.getHeader("ExchangeNo");
    params[2] = req.getHeader("CommodityNo");
    params[3] = req.getHeader("CommodityType");

    if (bParams)
    {
        bool trade_threads_vector = false;
        for(auto v = trade_vector.begin(); v != trade_vector.end(); ++v)
        {
            if (strcmp(params[0], (v->first).c_str()) == 0)
            {
                Trade* t = (Trade*)v->second;
                int rt = t->t_qryContract(params[1], params[2], params[3]);
                write_buf.format("%d", rt);
                trade_threads_vector = true;
                break;
            }
        }
        if (!trade_threads_vector)
        {
            logger_error("AccountNo is invalid, The corresponding thread could not be found!, AccountNo= %s", params[0]);
            write_buf.format("%d", -19001);
        }
    }
    res.setContentLength(write_buf.size());
    return res.write(write_buf);
}

/// 查询客户最终费率
bool TradeHttp::QryAccountRentInfo(HttpRequest& req, HttpResponse& res)
{
    logger("查询客户最终费率");
    acl::string write_buf;
    const char* params[5];
    bool bParams = true;
    params[0] = req.getHeader("AccountNo");
    if (NULL == params[0])
    {
        bParams = false;
        logger_error("AccountNo is null");
        write_buf.format("AccountNo is null");
    }

    params[2] = req.getHeader("ExchangeNo");
    params[3] = req.getHeader("CommodityNo");
    params[1] = req.getHeader("CommodityType");
    params[4] = req.getHeader("ContractNo");

    if (bParams)
    {
        bool trade_threads_vector = false;
        for(auto v = trade_vector.begin(); v != trade_vector.end(); ++v)
        {
            if (strcmp(params[0], (v->first).c_str()) == 0)
            {
                Trade* t = (Trade*)v->second;
                int rt = t->t_qryAccountRent(params[1], params[2], params[3], params[4]);
                write_buf.format("%d", rt);
                trade_threads_vector = true;
                break;
            }
        }
        if (!trade_threads_vector) {
            logger_error("AccountNo is invalid, The corresponding thread could not be found!, AccountNo= %s", params[0]);
            write_buf.format("%d", -19001);
        }
    }

    res.setContentLength(write_buf.size());
    return res.write(write_buf);
}

bool TradeHttp::ConnectTrade(HttpRequest& req, HttpResponse& res)
{
    logger("连接交易");
    acl::string write_buf;
    const char* param = NULL;
    bool bParams = true;
    param = req.getHeader("AccountNo");
    if (NULL == param)
    {
        bParams = false;
        logger_error("AccountNo is null");
        write_buf.format("AccountNo is null");
    }


    if (bParams)
    {
        bool trade_threads_vector = false;
        for(auto v = trade_vector.begin(); v != trade_vector.end(); ++v)
        {
            if (strcmp(param, (v->first).c_str()) == 0)
            {
                Trade* t = (Trade*)v->second;
//                int rt = t->t_login();
//                write_buf.format("%d", rt);
                trade_threads_vector = true;
                break;
            }
        }
        if (!trade_threads_vector) {
            logger_error("AccountNo is invalid, The corresponding thread could not be found!, AccountNo= %s", param);
            write_buf.format("%d", -19001);
        }
    }

    res.setContentLength(write_buf.size());
    return res.write(write_buf);
}

bool TradeHttp::DisConnectTrade(HttpRequest& req, HttpResponse& res)
{
    logger("断开连接");
    acl::string write_buf;
    const char* param = NULL;
    bool bParams = true;
    param = req.getHeader("AccountNo");
    if (NULL == param) {
        bParams = false;
        logger_error("AccountNo is null");
        write_buf.format("AccountNo is null");
    }

    if (bParams) {
        bool trade_threads_vector = false;
        for(auto v = trade_vector.begin(); v != trade_vector.end(); ++v) {
            if (strcmp(param, (v->first).c_str()) == 0) {
                Trade* t = (Trade*)v->second;
//                int rt = t->t_disConnect();
//                write_buf.format("%d", rt);
                trade_threads_vector = true;
                break;
            }
        }
        if (!trade_threads_vector) {
            logger_error("AccountNo is invalid, The corresponding thread could not be found!, AccountNo= %s", param);
            write_buf.format("%d", -19001);
        }
    }

    res.setContentLength(write_buf.size());
    return res.write(write_buf);
}
