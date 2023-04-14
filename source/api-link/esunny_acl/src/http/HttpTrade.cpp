//
// Created by root on 4/14/21.
//

#include <Trade.h>
#include <iostream>
#include "HttpTrade.h"
#include "MasterService.h"
#include "HttpService.h"

extern std::vector<std::pair<acl::string, Trade *>> trade_vector;

HttpTrade::HttpTrade() {}

HttpTrade::~HttpTrade() {}

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

void HttpTrade::start(const char* addrs) {
    MasterService ms;
    HttpService& service = ms.get_service();

    // 设置配置参数表
    ms.set_cfg_int(var_conf_int_tab)
            .set_cfg_int64(var_conf_int64_tab)
            .set_cfg_str(var_conf_str_tab)
            .set_cfg_bool(var_conf_bool_tab);

    // Register http handlers according different url path
    service.Get("/QryCurrencyInfo", this->QryCurrencyInfo)
            .Get("/QryExchangeInfo", this->QryExchangeInfo)
            .Get("/QryAccountInfo", this->QryAccountInfo)
            .Get("/QryCommodity", this->QryCommodity)
            .Get("/QryExchangeContract", this->QryExchangeContract)
            .Get("/QryFundData", this->QryFundData)
            .Get("/QryPositionInfo", this->QryPositionInfo)
            .Get("/QryPositionSummaryInfo", this->QryPositionSummaryInfo)
            .Get("/QryOrderInfo", this->QryOrderInfo)
            .Get("/QryFillInfo", this->QryFillInfo)
            .Get("/QryOrderInfoByOrderNo", this->QryOrderInfoByOrderNo)
            .Get("/QryFillInfoByOrderNo", this->QryFillInfoByOrderNo)
            .Post("/InsertOrder", this->InsertOrder)
            .Post("/CancelOrder", this->CancelOrder)
            .Get("/ConnectTrade", this->ConnectTrade)
            .Get("/DisConnectTrade", this->DisConnectTrade)
            .Get("/QryAccountFeeRent", this->QryAccountFeeRent)
            .Get("/QryAccountMarginRent", this->QryAccountMarginRent)
            .Default(http_default);

    if (setenv("SERVICE_LOG", "logs/trade/tradeServer.log", 1) == 0) {
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
    ms.run_alone(addrs, NULL, count, max_threads);
}

bool HttpTrade::QryCurrencyInfo(HttpRequest& req, HttpResponse& res)
{
    logger("查询币种信息");
    acl::string write_buf;
    const char* param = NULL;
    bool params_flag = true;

    param = req.getHeader("AccountNo");
    if (NULL == param) {
        params_flag = false;
        logger_error("AccountNo is null");
        write_buf.format("AccountNo is null");
    }

    if (params_flag) {
        bool quote_vector_flag = false;
        for(auto v = trade_vector.begin(); v != trade_vector.end(); ++v) {
            if (strcmp(param, (v->first).c_str()) == 0) {
                Trade* t = (Trade*)v->second;
                int rt = t->t_qryCurrency();
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

bool HttpTrade::QryExchangeInfo(HttpRequest& req, HttpResponse& res)
{
    logger("查询交易所信息");
    acl::string write_buf;
    const char* param = NULL;
    bool params_flag = true;

    param = req.getHeader("AccountNo");
    if (NULL == param) {
        params_flag = false;
        logger_error("AccountNo is null");
        write_buf.format("AccountNo is null");
    }

    if (params_flag) {
        bool quote_vector_flag = false;
        for(auto v = trade_vector.begin(); v != trade_vector.end(); ++v) {
            if (strcmp(param, (v->first).c_str()) == 0) {
                Trade* t = (Trade*)v->second;
                int rt = t->t_qryExchange();
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

bool HttpTrade::QryAccountInfo(HttpRequest& req, HttpResponse& res)
{
    logger("查询账户信息");
    acl::string write_buf;
    const char* param = NULL;
    
    bool params_flag = true;

    param = req.getHeader("AccountNo");
    if (NULL == param) {
        params_flag = false;
        logger_error("AccountNo is null");
        write_buf.format("AccountNo is null");
    }

    if (params_flag) {
        bool quote_vector_flag = false;
        for(auto v = trade_vector.begin(); v != trade_vector.end(); ++v) {
            if (strcmp(param, (v->first).c_str()) == 0) {
                Trade* t = (Trade*)v->second;
                int rt = t->t_qryAccount();
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

bool HttpTrade::QryCommodity(HttpRequest& req, HttpResponse& res)
{
    logger("查询品种信息");
    acl::string write_buf;
    const char* param = NULL;
    
    bool params_flag = true;

    param = req.getHeader("AccountNo");
    if (NULL == param) {
        params_flag = false;
        logger_error("AccountNo is null");
        write_buf.format("AccountNo is null");
    }

    if (params_flag) {
        bool quote_vector_flag = false;
        for(auto v = trade_vector.begin(); v != trade_vector.end(); ++v) {
            if (strcmp(param, (v->first).c_str()) == 0) {
                Trade* t = (Trade*)v->second;
                int rt = t->t_qryCommodity();
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

bool HttpTrade::QryExchangeContract(HttpRequest& req, HttpResponse& res)
{
    logger("查询合约");
    acl::string write_buf;
    const char* params[3]{NULL};
    
    bool params_flag = true;

    params[0] = req.getHeader("AccountNo");
    if (NULL == params[0]) {
        params_flag = false;
        logger_error("AccountNo is null");
        write_buf.format("AccountNo is null");
    } else {
        logger_debug(DEBUG_TEST2, 1, "AccountNo = %s", params[0]);
    }

    params[1] = req.getHeader("ExchangeNo");
    params[2] = req.getHeader("CommodityNo");

    if (params_flag) {
        bool quote_vector_flag = false;
        for(auto v = trade_vector.begin(); v != trade_vector.end(); ++v) {
            if (strcmp(params[0], (v->first).c_str()) == 0) {
                Trade* t = (Trade*)v->second;
                int rt = t->t_qryContract(params[1], params[2]);
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
    res.setContentLength(write_buf.size());
    return res.write(write_buf);
}

bool HttpTrade::QryFundData(HttpRequest& req, HttpResponse& res)
{
    logger("查询用户资金");
    acl::string write_buf;
    const char* param = NULL;
    bool params_flag = true;

    param = req.getHeader("AccountNo");
    if (NULL == param) {
        params_flag = false;
        logger_error("AccountNo is null");
        write_buf.format("AccountNo is null");
    }

    if (params_flag) {
        bool quote_vector_flag = false;
        for(auto v = trade_vector.begin(); v != trade_vector.end(); ++v) {
            if (strcmp(param, (v->first).c_str()) == 0) {
                Trade* t = (Trade*)v->second;
                int rt = t->t_qryFund();
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

bool HttpTrade::QryPositionInfo(HttpRequest& req, HttpResponse& res)
{
    logger("查询持仓明细");
    acl::string write_buf;
    const char* param = NULL;
    bool params_flag = true;
    param = req.getHeader("AccountNo");
    if (NULL == param) {
        params_flag = false;
        logger_error("AccountNo is null");
        write_buf.format("AccountNo is null");
    }

    if (params_flag) {
        bool quote_vector_flag = false;
        for(auto v = trade_vector.begin(); v != trade_vector.end(); ++v) {
            if (strcmp(param, (v->first).c_str()) == 0) {
                Trade* t = (Trade*)v->second;
                int rt = t->t_qryPosition();
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

bool HttpTrade::QryPositionSummaryInfo(HttpRequest& req, HttpResponse& res)
{
    logger("查询持仓汇总");
    acl::string write_buf;
    const char* param = NULL;
    bool params_flag = true;
    param = req.getHeader("AccountNo");
    if (NULL == param) {
        params_flag = false;
        logger_error("AccountNo is null");
        write_buf.format("AccountNo is null");
    }

    if (params_flag) {
        bool quote_vector_flag = false;
        for(auto v = trade_vector.begin(); v != trade_vector.end(); ++v) {
            if (strcmp(param, (v->first).c_str()) == 0) {
                Trade* t = (Trade*)v->second;
                int rt = t->t_qryPositionSummary();
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

bool HttpTrade::QryOrderInfo(HttpRequest& req, HttpResponse& res)
{
    logger("查询订单");
    acl::string write_buf;
    const char* param = NULL;
    bool params_flag = true;
    param = req.getHeader("AccountNo");
    if (NULL == param) {
        params_flag = false;
        logger_error("AccountNo is null");
        write_buf.format("AccountNo is null");
    }

    if (params_flag) {
        bool quote_vector_flag = false;
        for(auto v = trade_vector.begin(); v != trade_vector.end(); ++v) {
            if (strcmp(param, (v->first).c_str()) == 0) {
                Trade* t = (Trade*)v->second;
                int rt = t->t_qryOrder();
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

bool HttpTrade::QryFillInfo(HttpRequest& req, HttpResponse& res)
{
    logger("查询成交");
    acl::string write_buf;
    const char* param = NULL;
    bool params_flag = true;
    param = req.getHeader("AccountNo");
    if (NULL == param) {
        params_flag = false;
        logger_error("AccountNo is null");
        write_buf.format("AccountNo is null");
    }

    if (params_flag) {
        bool quote_vector_flag = false;
        for(auto v = trade_vector.begin(); v != trade_vector.end(); ++v) {
            if (strcmp(param, (v->first).c_str()) == 0) {
                Trade* t = (Trade*)v->second;
                int rt = t->t_qryFill();
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

bool HttpTrade::QryOrderInfoByOrderNo(HttpRequest& req, HttpResponse& res)
{
    logger("根据订单号查询订单");
    acl::string write_buf;
    const char* AccountNo = NULL, *OrderNo = NULL;
    bool params_flag = true;

    AccountNo = req.getHeader("AccountNo");
    if (NULL == AccountNo) {
        params_flag = false;
        logger_error("AccountNo is null");
        write_buf.format("AccountNo is null");
    }
    OrderNo = req.getHeader("OrderNo");
    if (NULL == OrderNo) {
        params_flag = false;
        logger_error("OrderNo is null");
        write_buf.format("OrderNo is null");
    }

    if (params_flag) {
        bool quote_vector_flag = false;
        for(auto v = trade_vector.begin(); v != trade_vector.end(); ++v) {
            if (v->first == AccountNo) {
                Trade* t = (Trade*)v->second;
                int rt = t->t_qryOrderByOrderNo(OrderNo);
                write_buf.format("%d", rt);
                quote_vector_flag = true;
                break;
            }
        }
        if (!quote_vector_flag) {
            logger_error("AccountNo is invalid, The corresponding thread could not be found!, AccountNo= %s", AccountNo);
            write_buf.format("%d", -19001);
        }
    }
    
    res.setContentLength(write_buf.size());
    return res.write(write_buf);
}

bool HttpTrade::QryFillInfoByOrderNo(HttpRequest& req, HttpResponse& res)
{
    logger("根据成交号查询成交");
    acl::string write_buf;
    const char* AccountNo = NULL, *OrderNo = NULL;
    bool params_flag = true;
    AccountNo = req.getHeader("AccountNo");
    if (NULL == AccountNo) {
        params_flag = false;
        logger_error("AccountNo is null");
        write_buf.format("AccountNo is null");
    }
    OrderNo = req.getHeader("OrderNo");
    if (NULL == OrderNo) {
        params_flag = false;
        logger_error("OrderNo is null");
        write_buf.format("OrderNo is null");
    }
    if (params_flag) {
        bool quote_vector_flag = false;
        for(auto v = trade_vector.begin(); v != trade_vector.end(); ++v) {
            if (v->first == AccountNo) {
                Trade* t = (Trade*)v->second;
                int rt = t->t_qryFillByOrderNo(OrderNo);
                write_buf.format("%d", rt);
                quote_vector_flag = true;
                break;
            }
        }
        if (!quote_vector_flag) {
            logger_error("AccountNo is invalid, The corresponding thread could not be found!, AccountNo= %s", AccountNo);
            write_buf.format("%d", -19001);
        }
    }

    res.setContentLength(write_buf.size());
    return res.write(write_buf);
}

bool HttpTrade::InsertOrder(HttpRequest& req, HttpResponse& res)
{
    logger("下单");
    acl::string write_buf;
    const char* params[8]{NULL};
    bool params_flag = true;
    acl::json* json = req.getJson();
    if (json == NULL) {
        acl::string data("{ \"err\": \"no json\"}");
        res.setContentLength(data.size());
        return res.write(data);
    }
    
    ACL_ARGV *argv = acl_argv_split("AccountNo,ExchangeNo,"
                                    "CommodityNo,ContractNo,OrderType,TimeInForce,"
                                    "OrderSide,OrderQty", ",");
    ACL_ITER iter;  // 遍历指针
    // 遍历分割后的结果
     acl_foreach(iter, argv) {
        // 从遍历指针中取出字符串型数据
        const char *iter_ptr =  (const char*) iter.data;
        acl::json_node* jsonNode = json->getFirstElementByTagName(iter_ptr);
        if (NULL == jsonNode) {
            params_flag = false;
            logger_error("%s is null", iter_ptr);
            write_buf.format("%s is null", iter_ptr);
            break;
        } else {
            params[iter.i] = jsonNode->get_text();
        }
    }
    // 市价与市价止损不必填写价格
    const char *OrderPrice = NULL;
    if ((strcmp(params[4], "1") != 0) && (strcmp(params[4], "3") != 0))
    {
        acl::json_node* jsonNode1 = json->getFirstElementByTagName("OrderPrice");
        if (NULL == jsonNode1) {
            params_flag = false;
            logger_error("OrderPrice is null");
            write_buf.format("OrderPrice is null", OrderPrice);
        } else {
            OrderPrice = jsonNode1->get_text();
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
//             params_flag = false;
//             logger_error("StopPrice is null", StopPrice);
//             write_buf.format("StopPrice is null", StopPrice);
//         } else {
//             StopPrice = jsonNode1->get_text();
//         }
//     }

    if (params_flag) {
        bool quote_vector_flag = false;
        for(auto v = trade_vector.begin(); v != trade_vector.end(); ++v) {
            if (strcmp(params[0], (v->first).c_str()) == 0) {
                Trade* t = (Trade*)v->second;
                int rt = t->t_insertOrder(params[1],params[2],params[3],
                        params[4],params[5],params[6],OrderPrice,params[7],RefString);
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

bool HttpTrade::CancelOrder(HttpRequest& req, HttpResponse& res)
{
    logger("撤单");
    acl::string write_buf;
    const char* AccountNo = NULL, *OrderNo = NULL;
    bool params_flag = true;

    acl::json* json = req.getJson();
    if (NULL == json) {
        acl::string data("{ \"err\": \"no json\"}");
        res.setContentLength(data.size());
        return res.write(data);
    }
    acl::json_node* jsonNode1 = json->getFirstElementByTagName("AccountNo");
    if (NULL == jsonNode1) {
        params_flag = false;
        logger_error("AccountNo is null");
        write_buf.format("AccountNo is null");
    } else {
        AccountNo = jsonNode1->get_text();
    }
    acl::json_node* jsonNode2 = json->getFirstElementByTagName("OrderNo");
    if (NULL == jsonNode2) {
        params_flag = false;
        logger_error("OrderNo is null");
        write_buf.format("OrderNo is null");
    } else {
        OrderNo = jsonNode2->get_text();
    }

    if (params_flag) {
        bool quote_vector_flag = false;
        for(auto v = trade_vector.begin(); v != trade_vector.end(); ++v) {
            if (strcmp(AccountNo, (v->first).c_str()) == 0) {
                Trade* t = (Trade*)v->second;
                int rt = t->t_canncelOrder(OrderNo);
                write_buf.format("%d", rt);
                quote_vector_flag = true;
                break;
            }
        }
        if (!quote_vector_flag) {
            logger_error("AccountNo is invalid, The corresponding thread could not be found!, AccountNo= %s", AccountNo);
            write_buf.format("%d", -19001);
        }
    }
    
    res.setContentLength(write_buf.size());
    return res.write(write_buf);
}

bool HttpTrade::ConnectTrade(HttpRequest& req, HttpResponse& res)
{
    logger("重连交易");
    acl::string write_buf;
    const char* param = NULL;
    bool params_flag = true;
    param = req.getHeader("AccountNo");
    if (NULL == param) {
        params_flag = false;
        logger_error("AccountNo is null");
        write_buf.format("AccountNo is null");
    }


    if (params_flag) {
        bool quote_vector_flag = false;
        for(auto v = trade_vector.begin(); v != trade_vector.end(); ++v) {
            if (strcmp(param, (v->first).c_str()) == 0) {
                Trade* t = (Trade*)v->second;
                int rt = t->t_login();
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

bool HttpTrade::DisConnectTrade(HttpRequest& req, HttpResponse& res)
{
    logger("断开交易");
    acl::string write_buf;
    const char* param = NULL;
    bool params_flag = true;
    param = req.getHeader("AccountNo");
    if (NULL == param) {
        params_flag = false;
        logger_error("AccountNo is null");
        write_buf.format("AccountNo is null");
    }

    if (params_flag) {
        bool quote_vector_flag = false;
        for(auto v = trade_vector.begin(); v != trade_vector.end(); ++v) {
            if (strcmp(param, (v->first).c_str()) == 0) {
                Trade* t = (Trade*)v->second;
                int rt = t->t_disConnect();
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


bool HttpTrade::QryAccountFeeRent(HttpRequest& req, HttpResponse& res)
{
    logger("客户手续费计算参数查询");
    acl::string write_buf;
    const char* param = NULL;
    bool params_flag = true;
    param = req.getHeader("AccountNo");
    if (NULL == param) {
        params_flag = false;
        logger_error("AccountNo is null");
        write_buf.format("AccountNo is null");
    }

    if (params_flag) {
        bool quote_vector_flag = false;
        for(auto v = trade_vector.begin(); v != trade_vector.end(); ++v) {
            if (strcmp(param, (v->first).c_str()) == 0) {
                Trade* t = (Trade*)v->second;
                int rt = t->t_qryAccountFeeRent();
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

bool HttpTrade::QryAccountMarginRent(HttpRequest& req, HttpResponse& res)
{
    logger("客户保证金计算参数查询");
    acl::string write_buf;
    const char* param = NULL;
    bool params_flag = true;
    param = req.getHeader("AccountNo");
    if (NULL == param) {
        params_flag = false;
        logger_error("AccountNo is null");
        write_buf.format("AccountNo is null");
    }

    if (params_flag) {
        bool quote_vector_flag = false;
        for(auto v = trade_vector.begin(); v != trade_vector.end(); ++v) {
            if (strcmp(param, (v->first).c_str()) == 0) {
                Trade* t = (Trade*)v->second;
                int rt = t->t_qryAccountMarginRent();
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