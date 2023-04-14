//
// Created by root on 4/14/21.
//

#include <iostream>
#include "TradeHttp.h"
#include "MasterService.h"
#include "HttpService.h"

vector<pair<const char *, CustomTradeSpi*>> TradeHttp::sm_vTrade;

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

//void TradeHttp::setTradeApi(CustomTradeSpi *spi) {
//    p_tradeSpi = spi;
//}

void TradeHttp::setTradeVector(vector<pair<const char *, CustomTradeSpi*>> trade) {
    sm_vTrade = trade;
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
    service.Get("/ReqQryExchange", this->ReqQryExchange)
            .Get("/ReqQryProduct", this->ReqQryProduct)
            .Get("/ReqQryInstrument", this->ReqQryInstrument)
            .Get("/ReqQryTradingAccount", this->ReqQryTradingAccount)
            .Get("/ReqQryInvestor", this->ReqQryInvestor)
            .Get("/ReqQryTradingCode", this->ReqQryTradingCode)
            .Get("/ReqQryOrder", this->ReqQryOrder)
            .Get("/ReqQryTrade", this->ReqQryTrade)
            .Get("/ReqQryInvestorPosition", this->ReqQryInvestorPosition)
            .Get("/ReqQryInvestorPositionDetail", this->ReqQryInvestorPositionDetail)
            .Get("/ReqQryInstrumentMarginRate", this->ReqQryInstrumentMarginRate)
            .Get("/ReqQryInstrumentCommissionRate", this->ReqQryInstrumentCommissionRate)
            .Get("/ReqQryInstrumentOrderCommRate", this->ReqQryInstrumentOrderCommRate)
            .Get("/ReqQryDepthMarketData", this->ReqQryDepthMarketData)
            .Get("/ReqQrySettlementInfo", this->ReqQrySettlementInfo)
            .Get("/ReqSettlementInfoConfirm", this->ReqSettlementInfoConfirm)
            .Get("/ReqQrySettlementInfoConfirm", this->ReqQrySettlementInfoConfirm)
            .Post("/ReqOrderInsert", this->ReqOrderInsert)
            .Post("/ReqOrderAction", this->ReqOrderAction)
            .Get("/ReqUserLogout", this->ReqUserLogout)
            .Get("/ReqQryBrokerTradingParams", this->ReqQryBrokerTradingParams)
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



bool TradeHttp::ReqQryExchange(HttpRequest& req, HttpResponse& res)
{
    logger("查询交易所");
    acl::string write_buf;
    const char* params[2];
    bool params_flag = true;
    params[0] = req.getHeader("InvestorID");
    if (NULL == params[0]) {
        params_flag = false;
        logger_error("InvestorID is null");
        write_buf.format("InvestorID is null");
    } else {
        logger("InvestorID = %s", params[0]);
    }

    params[1] = req.getHeader("ExchangeID");
    if (params[1] != NULL) {
        logger("ExchangeID = %s", params[1]);
    }

    if (params_flag) {
        bool quote_vector_flag = false;
        for(auto v = sm_vTrade.begin(); v != sm_vTrade.end(); ++v) {
            if (strcmp(v->first, params[0]) == 0) {
                CustomTradeSpi* tradeSpi = (CustomTradeSpi*)v->second;
                int rt = tradeSpi->reqQryExchange(params[1]);
                write_buf.format("%d", rt);
                quote_vector_flag = true;
                break;
            }
        }
        if (!quote_vector_flag) {
            logger("InvestorID is invalid, The corresponding thread could not be found!, InvestorID= %s", params[0]);
            write_buf.format("%d", -19001);
        }
    }
    res.setContentLength(write_buf.size());
    return res.write(write_buf);
}

// 请求查询产品
bool TradeHttp::ReqQryProduct(HttpRequest& req, HttpResponse& res)
{
    logger("查询产品");
    acl::string write_buf;
    const char* params[3];
    bool params_flag = true;
    params[0] = req.getHeader("InvestorID");
    if (NULL == params[0]) {
        params_flag = false;
        logger_error("InvestorID is null");
        write_buf.format("InvestorID is null");
    }

    params[1] = req.getHeader("ProductID");
    params[2] = req.getHeader("ExchangeID");

    if (params_flag) {
        bool quote_vector_flag = false;
        for(auto v = sm_vTrade.begin(); v != sm_vTrade.end(); ++v) {
            if (strcmp(v->first, params[0]) == 0) {
                CustomTradeSpi* tradeSpi = (CustomTradeSpi*)v->second;
                int rt = tradeSpi->reqQryProduct(params[1], params[2]);
                write_buf.format("%d", rt);
                quote_vector_flag = true;
                break;
            }
        }
        if (!quote_vector_flag) {
            logger("InvestorID is invalid, The corresponding thread could not be found!, InvestorID= %s", params[0]);
            write_buf.format("%d", -19001);
        }
    }
    res.setContentLength(write_buf.size());
    return res.write(write_buf);
}


// 请求查询合约
bool TradeHttp::ReqQryInstrument(HttpRequest& req, HttpResponse& res)
{
    logger("查询合约");
    acl::string write_buf;
    const char* params[3];
    bool params_flag = true;
    params[0] = req.getHeader("InvestorID");
    if (NULL == params[0]) {
        params_flag = false;
        logger_error("InvestorID is null");
        write_buf.format("InvestorID is null");
    }
    params[1] = req.getHeader("InstrumentID");
    params[2] = req.getHeader("ExchangeID");

    if (params_flag) {
        bool quote_vector_flag = false;
        for(auto v = sm_vTrade.begin(); v != sm_vTrade.end(); ++v) {
            if (strcmp(v->first, params[0]) == 0) {
                CustomTradeSpi* tradeSpi = (CustomTradeSpi*)v->second;
                int rt = tradeSpi->reqQryInstrument(params[1], params[2]);
                write_buf.format("%d", rt);
                quote_vector_flag = true;
                break;
            }
        }
        if (!quote_vector_flag) {
            logger("InvestorID is invalid, The corresponding thread could not be found!, InvestorID= %s", params[0]);
            write_buf.format("%d", -19001);
        }
    }
    res.setContentLength(write_buf.size());
    return res.write(write_buf);
}

// 请求查询资金帐户
bool TradeHttp::ReqQryTradingAccount(HttpRequest& req, HttpResponse& res)
{
    logger("查询资金账户");
    acl::string write_buf;
    const char* param;
    bool params_flag = true;
    param = req.getHeader("InvestorID");
    if (NULL == param) {
        params_flag = false;
        logger_error("InvestorID is null");
        write_buf.format("InvestorID is null");
    }

    if (params_flag) {
        bool quote_vector_flag = false;
        for(auto v = sm_vTrade.begin(); v != sm_vTrade.end(); ++v) {
            if (strcmp(v->first, param) == 0) {
                CustomTradeSpi* tradeSpi = (CustomTradeSpi*)v->second;
                int rt = tradeSpi->reqQryTradingAccount();
                write_buf.format("%d", rt);
                quote_vector_flag = true;
                break;
            }
        }
        if (!quote_vector_flag) {
            logger("InvestorID is invalid, The corresponding thread could not be found!, InvestorID= %s", param);
            write_buf.format("%d", -19001);
        }
    }
    res.setContentLength(write_buf.size());
    return res.write(write_buf);
}

// 请求查询投资者
bool TradeHttp::ReqQryInvestor(HttpRequest& req, HttpResponse& res)
{
    logger("查询投资者");
    acl::string write_buf;
    const char* param;
    bool params_flag = true;
    param = req.getHeader("InvestorID");
    if (NULL == param) {
        params_flag = false;
        logger_error("InvestorID is null");
        write_buf.format("InvestorID is null");
    }

    if (params_flag) {
        bool quote_vector_flag = false;
        for(auto v = sm_vTrade.begin(); v != sm_vTrade.end(); ++v) {
            if (strcmp(v->first, param) == 0) {
                CustomTradeSpi* tradeSpi = (CustomTradeSpi*)v->second;
                int rt = tradeSpi->reqQryInvestor();
                write_buf.format("%d", rt);
                quote_vector_flag = true;
                break;
            }
        }
        if (!quote_vector_flag) {
            logger("InvestorID is invalid, The corresponding thread could not be found!, InvestorID= %s", param);
            write_buf.format("%d", -19001);
        }
    }
    res.setContentLength(write_buf.size());
    return res.write(write_buf);
}

//请求查询交易编号
bool TradeHttp::ReqQryTradingCode(HttpRequest& req, HttpResponse& res)
{
    logger("查询交易编号");
    acl::string write_buf;
    const char* param;
    bool params_flag = true;
    param = req.getHeader("InvestorID");
    if (NULL == param) {
        params_flag = false;
        logger_error("InvestorID is null");
        write_buf.format("InvestorID is null");
    }

    if (params_flag) {
        bool quote_vector_flag = false;
        for(auto v = sm_vTrade.begin(); v != sm_vTrade.end(); ++v) {
            if (strcmp(v->first, param) == 0) {
                CustomTradeSpi* tradeSpi = (CustomTradeSpi*)v->second;
                int rt = tradeSpi->reqQryTradingCode();
                write_buf.format("%d", rt);
                quote_vector_flag = true;
                break;
            }
        }
        if (!quote_vector_flag) {
            logger("InvestorID is invalid, The corresponding thread could not be found!, InvestorID= %s", param);
            write_buf.format("%d", -19001);
        }
    }
    res.setContentLength(write_buf.size());
    return res.write(write_buf);
}


/**
 * 保证金率和手续费率查询
 */

// 请求查询合约保证金金率
bool TradeHttp::ReqQryInstrumentMarginRate(HttpRequest& req, HttpResponse& res)
{
    logger("查询合约保证金金率");
    acl::string write_buf;
    const char* params[3];
    bool params_flag = true;
    params[0] = req.getHeader("InvestorID");
    if (!params[0]) {
        params_flag = false;
        logger_error("InvestorID is null");
        write_buf.format("InvestorID is null");
    }
    params[1] = req.getHeader("HedgeFlag");
    if (NULL == params[1]) {
        params_flag = false;
        logger_error("HedgeFlag is null");
        write_buf.format("HedgeFlag is null");
    }
    params[2] = req.getHeader("InstrumentID");

    if (params_flag) {
        bool quote_vector_flag = false;
        for(auto v = sm_vTrade.begin(); v != sm_vTrade.end(); ++v) {
            if (strcmp(v->first, params[0]) == 0) {
                CustomTradeSpi* tradeSpi = (CustomTradeSpi*)v->second;
                int rt = tradeSpi->reqQryInstrumentMarginRate(params[1], params[2]);
                write_buf.format("%d", rt);
                quote_vector_flag = true;
                break;
            }
        }
        if (!quote_vector_flag) {
            logger("InvestorID is invalid, The corresponding thread could not be found!, InvestorID= %s", params[0]);
            write_buf.format("%d", -19001);
        }
    }
    res.setContentLength(write_buf.size());
    return res.write(write_buf);
}

// 请求查询合约手续费率
bool TradeHttp::ReqQryInstrumentCommissionRate(HttpRequest& req, HttpResponse& res)
{
    logger("查询合约手续费率");
    acl::string write_buf;
    const char* params[3];
    bool params_flag = true;
    params[0] = req.getHeader("InvestorID");
    if (NULL == params[0]) {
        params_flag = false;
        logger_error("InvestorID is null");
        write_buf.format("InvestorID is null");
    }
    params[1] = req.getHeader("InstrumentID");
    params[2] = req.getHeader("ExchangeID");

    if (params_flag) {
        bool quote_vector_flag = false;
        for(auto v = sm_vTrade.begin(); v != sm_vTrade.end(); ++v) {
            if (strcmp(v->first, params[0]) == 0) {
                CustomTradeSpi* tradeSpi = (CustomTradeSpi*)v->second;
                int rt = tradeSpi->reqQryInstrumentCommissionRate(params[1], params[2]);
                write_buf.format("%d", rt);
                quote_vector_flag = true;
                break;
            }
        }
        if (!quote_vector_flag) {
            logger("InvestorID is invalid, The corresponding thread could not be found!, InvestorID= %s", params[0]);
            write_buf.format("%d", -19001);
        }
    }
    res.setContentLength(write_buf.size());
    return res.write(write_buf);
}

// 查询报单手续费率 中金所持有
bool TradeHttp::ReqQryInstrumentOrderCommRate(HttpRequest& req, HttpResponse& res)
{
    logger("查询报单手续费率 中金所持有");
    acl::string write_buf;
    const char* params[2];
    bool params_flag = true;
    params[0] = req.getHeader("InvestorID");
    if (NULL == params[0]) {
        params_flag = false;
        logger_error("InvestorID is null");
        write_buf.format("InvestorID is null");
    }
    params[1] = req.getHeader("InstrumentID");

    if (params_flag) {
        bool quote_vector_flag = false;
        for(auto v = sm_vTrade.begin(); v != sm_vTrade.end(); ++v) {
            if (strcmp(v->first, params[0]) == 0) {
                CustomTradeSpi* tradeSpi = (CustomTradeSpi*)v->second;
                int rt = tradeSpi->reqQryInstrumentOrderCommRate(params[1]);
                write_buf.format("%d", rt);
                quote_vector_flag = true;
                break;
            }
        }
        if (!quote_vector_flag) {
            logger("InvestorID is invalid, The corresponding thread could not be found!, InvestorID= %s", params[0]);
            write_buf.format("%d", -19001);
        }
    }
    res.setContentLength(write_buf.size());
    return res.write(write_buf);
}

// 请求查询交易所保证金率
bool TradeHttp::ReqQryExchangeMarginRate(HttpRequest& req, HttpResponse& res)
{}

// 请求查询交易所调整保证金率
bool TradeHttp::ReqQryExchangeMarginRateAdjust(HttpRequest& req, HttpResponse& res)
{}

// 请求查询经纪公司交易参数
bool TradeHttp::ReqQryBrokerTradingParams(HttpRequest& req, HttpResponse& res)
{
    logger("查询经纪公司交易参数");
    acl::string write_buf;
    const char* params[2];
    bool params_flag = true;
    params[0] = req.getHeader("InvestorID");
    if (NULL == params[0]) {
        params_flag = false;
        logger_error("InvestorID is null");
        write_buf.format("InvestorID is null");
    }

    if (params_flag) {
        bool quote_vector_flag = false;
        for(auto v = sm_vTrade.begin(); v != sm_vTrade.end(); ++v) {
            if (strcmp(v->first, params[0]) == 0) {
                CustomTradeSpi* tradeSpi = (CustomTradeSpi*)v->second;
                int rt = tradeSpi->reqQryBrokerTradingParams();
                write_buf.format("%d", rt);
                quote_vector_flag = true;
                break;
            }
        }
        if (!quote_vector_flag) {
            logger("InvestorID is invalid, The corresponding thread could not be found!, InvestorID= %s", params[0]);
            write_buf.format("%d", -19001);
        }
    }
    res.setContentLength(write_buf.size());
    return res.write(write_buf);
}


// 请求查询报单
bool TradeHttp::ReqQryOrder(HttpRequest& req, HttpResponse& res)
{
    logger("查询报单");
    acl::string write_buf;
    const char* param;
    bool params_flag = true;
    param = req.getHeader("InvestorID");
    if (NULL == param) {
        params_flag = false;
        logger_error("InvestorID is null");
        write_buf.format("InvestorID is null");
    }

    if (params_flag) {
        bool quote_vector_flag = false;
        for(auto v = sm_vTrade.begin(); v != sm_vTrade.end(); ++v) {
            if (strcmp(v->first, param) == 0) {
                CustomTradeSpi* tradeSpi = (CustomTradeSpi*)v->second;
                int rt = tradeSpi->reqQryOrder();
                write_buf.format("%d", rt);
                quote_vector_flag = true;
                break;
            }
        }
        if (!quote_vector_flag) {
            logger("InvestorID is invalid, The corresponding thread could not be found!, InvestorID= %s", param);
            write_buf.format("%d", -19001);
        }
    }
    res.setContentLength(write_buf.size());
    return res.write(write_buf);
}

// 请求查询成交
bool TradeHttp::ReqQryTrade(HttpRequest& req, HttpResponse& res)
{
    logger("查询成交");
    acl::string write_buf;
    const char* param;
    bool params_flag = true;
    param = req.getHeader("InvestorID");
    if (NULL == param) {
        params_flag = false;
        logger_error("InvestorID is null");
        write_buf.format("InvestorID is null");
    }

    if (params_flag) {
        bool quote_vector_flag = false;
        for(auto v = sm_vTrade.begin(); v != sm_vTrade.end(); ++v) {
            if (strcmp(v->first, param) == 0) {
                CustomTradeSpi* tradeSpi = (CustomTradeSpi*)v->second;
                int rt = tradeSpi->reqQryTrade();
                write_buf.format("%d", rt);
                quote_vector_flag = true;
                break;
            }
        }
        if (!quote_vector_flag) {
            logger("InvestorID is invalid, The corresponding thread could not be found!, InvestorID= %s", param);
            write_buf.format("%d", -19001);
        }
    }
    res.setContentLength(write_buf.size());
    return res.write(write_buf);
}

// 请求查询投资者持仓
bool TradeHttp::ReqQryInvestorPosition(HttpRequest& req, HttpResponse& res)
{
    logger("查询投资者持仓");
    acl::string write_buf;
    const char* param;
    bool params_flag = true;
    param = req.getHeader("InvestorID");
    if (NULL == param) {
        params_flag = false;
        logger_error("InvestorID is null");
        write_buf.format("InvestorID is null");
    }

    if (params_flag) {
        bool quote_vector_flag = false;
        for(auto v = sm_vTrade.begin(); v != sm_vTrade.end(); ++v) {
            if (strcmp(v->first, param) == 0) {
                CustomTradeSpi* tradeSpi = (CustomTradeSpi*)v->second;
                int rt = tradeSpi->reqQryInvestorPosition();
                write_buf.format("%d", rt);
                quote_vector_flag = true;
                break;
            }
        }
        if (!quote_vector_flag) {
            logger("InvestorID is invalid, The corresponding thread could not be found!, InvestorID= %s", param);
            write_buf.format("%d", -19001);
        }
    }
    res.setContentLength(write_buf.size());
    return res.write(write_buf);
}

// 请求查询投资者持仓明细
bool TradeHttp::ReqQryInvestorPositionDetail(HttpRequest& req, HttpResponse& res)
{
    logger("查询投资者持仓明细");
    acl::string write_buf;
    const char* param = NULL;
    bool params_flag = true;
    param = req.getHeader("InvestorID");
    if (NULL == param) {
        params_flag = false;
        logger_error("InvestorID is null");
        write_buf.format("InvestorID is null");
    }
    const char *ExchangeID = NULL;
    const char *InstrumentID = NULL;
    ExchangeID = req.getHeader("ExchangeID");
    InstrumentID = req.getHeader("InstrumentID");

    if (params_flag) {
        bool quote_vector_flag = false;
        for(auto v = sm_vTrade.begin(); v != sm_vTrade.end(); ++v) {
            if (strcmp(v->first, param) == 0) {
                CustomTradeSpi* tradeSpi = (CustomTradeSpi*)v->second;
                int rt = tradeSpi->reqQryInvestorPositionDetail(ExchangeID, InstrumentID);
                write_buf.format("%d", rt);
                quote_vector_flag = true;
                break;
            }
        }
        if (!quote_vector_flag) {
            logger("InvestorID is invalid, The corresponding thread could not be found!, InvestorID= %s", param);
            write_buf.format("%d", -19001);
        }
    }
    res.setContentLength(write_buf.size());
    return res.write(write_buf);
}


// 请求查询行情
bool TradeHttp::ReqQryDepthMarketData(HttpRequest& req, HttpResponse& res)
{
    logger("查询行情");
    acl::string write_buf;
    const char* params[2];
    bool params_flag = true;
    params[0] = req.getHeader("InvestorID");
    if (NULL == params[0]) {
        params_flag = false;
        logger_error("InvestorID is null");
        write_buf.format("InvestorID is null");
    }

    params[1] = req.getHeader("InstrumentID");
    if (NULL == params[1]) {
        params_flag = false;
        logger_error("InstrumentID is null");
        write_buf.format("InstrumentID is null");
    } else { logger("InstrumentID=%s", params[1]); }


    if (params_flag) {
        bool quote_vector_flag = false;
        for(auto v = sm_vTrade.begin(); v != sm_vTrade.end(); ++v) {
            if (strcmp(v->first, params[0]) == 0) {
                CustomTradeSpi* tradeSpi = (CustomTradeSpi*)v->second;
                int rt = tradeSpi->reqQryDepthMarketData(params[1]);
                write_buf.format("%d", rt);
                quote_vector_flag = true;
                break;
            }
        }
        if (!quote_vector_flag) {
            logger("InvestorID is invalid, The corresponding thread could not be found!, InvestorID= %s", params[0]);
            write_buf.format("%d", -19001);
        }
    }
    res.setContentLength(write_buf.size());
    return res.write(write_buf);
}

// 请求查询投资者结算结果
bool TradeHttp::ReqQrySettlementInfo(HttpRequest& req, HttpResponse& res)
{
    logger("查询投资者结算结果");
    acl::string write_buf;
    const char* params[2];
    bool params_flag = true;
    params[0] = req.getHeader("InvestorID");
    if (NULL == params[0]) {
        params_flag = false;
        logger_error("InvestorID is null");
        write_buf.format("InvestorID is null");
    }
    params[1] = req.getHeader("TradingDay");
    if (params[1] != NULL) {
        logger("TradingDay=%s", params[1]);
    }

    if (params_flag) {
        bool quote_vector_flag = false;
        for(auto v = sm_vTrade.begin(); v != sm_vTrade.end(); ++v) {
            if (strcmp(v->first, params[0]) == 0) {
                CustomTradeSpi* tradeSpi = (CustomTradeSpi*)v->second;
                int rt = tradeSpi->reqQrySettlementInfo(params[1]);
                write_buf.format("%d", rt);
                quote_vector_flag = true;
                break;
            }
        }
        if (!quote_vector_flag) {
            logger("InvestorID is invalid, The corresponding thread could not be found!, InvestorID= %s", params[0]);
            write_buf.format("%d", -19001);
        }
    }
    res.setContentLength(write_buf.size());
    return res.write(write_buf);
}

// 投资者结果确认
bool TradeHttp::ReqSettlementInfoConfirm(HttpRequest& req, HttpResponse& res)
{
    logger("投资者结果确认");
    acl::string write_buf;
    const char* param;
    bool params_flag = true;
    param = req.getHeader("InvestorID");
    if (NULL == param) {
        params_flag = false;
        logger_error("InvestorID is null");
        write_buf.format("InvestorID is null");
    }

    if (params_flag) {
        bool quote_vector_flag = false;
        for(auto v = sm_vTrade.begin(); v != sm_vTrade.end(); ++v) {
            if (strcmp(v->first, param) == 0) {
                CustomTradeSpi* tradeSpi = (CustomTradeSpi*)v->second;
                int rt = tradeSpi->reqSettlementInfoConfirm();
                write_buf.format("%d", rt);
                quote_vector_flag = true;
                break;
            }
        }
        if (!quote_vector_flag) {
            logger("InvestorID is invalid, The corresponding thread could not be found!, InvestorID= %s", param);
            write_buf.format("%d", -19001);
        }
    }
    res.setContentLength(write_buf.size());
    return res.write(write_buf);
}

// 查询结算信息确认
bool TradeHttp::ReqQrySettlementInfoConfirm(HttpRequest& req, HttpResponse& res)
{
    logger("查询结算信息确认");
    acl::string write_buf;
    const char* param;
    bool params_flag = true;
    param = req.getHeader("InvestorID");
    if (NULL == param) {
        params_flag = false;
        logger_error("InvestorID is null");
        write_buf.format("InvestorID is null");
    }

    if (params_flag) {
        bool quote_vector_flag = false;
        for(auto v = sm_vTrade.begin(); v != sm_vTrade.end(); ++v) {
            if (strcmp(v->first, param) == 0) {
                CustomTradeSpi* tradeSpi = (CustomTradeSpi*)v->second;
                int rt = tradeSpi->reqQrySettlementInfoConfirm();
                write_buf.format("%d", rt);
                quote_vector_flag = true;
                break;
            }
        }
        if (!quote_vector_flag) {
            logger("InvestorID is invalid, The corresponding thread could not be found!, InvestorID= %s", param);
            write_buf.format("%d", -19001);
        }
    }
    res.setContentLength(write_buf.size());
    return res.write(write_buf);
}



// 请求报单录入
bool TradeHttp::ReqOrderInsert(HttpRequest& req, HttpResponse& res)
{
    logger("报单录入");
    acl::string write_buf;
    const char* params[8]{NULL};
    bool params_flag = true;
    acl::json* json = req.getJson();
    if (NULL == json) {
        acl::string data("{ \"err\": \"no json\"}");
        res.setContentLength(data.size());
        return res.write(data);
    }

    ACL_ARGV *argv = acl_argv_split("InvestorID,ExchangeID,"
                                    "InstrumentID,Direction,OrderPriceType,"
                                    "VolumeTotalOriginal,CombOffsetFlag,CombHedgeFlag", ",");
    ACL_ITER iter;  // 遍历指针
    unsigned int i=0 ;
    // 遍历分割后的结果
            acl_foreach(iter, argv) {
        // 从遍历指针中取出字符串型数据
        const char *iter_ptr =  (const char*) iter.data;
        acl::json_node* jsonNode = json->getFirstElementByTagName(iter_ptr);
        if (NULL == jsonNode) {
            params_flag = false;
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
    if (params[4] != NULL && strcmp(params[4], "1") != 0) {
        acl::json_node* jsonNode = json->getFirstElementByTagName("LimitPrice");
        if (NULL == jsonNode) {
            params_flag = false;
            logger_error("LimitPrice is null");
            write_buf.format("LimitPrice is null");
        } else {
            LimitPrice = jsonNode->get_text();
        }
    }

    if (params_flag) {
        bool quote_vector_flag = false;
        for(auto v = sm_vTrade.begin(); v != sm_vTrade.end(); ++v) {
            if (strcmp(v->first, params[0]) == 0) {
                CustomTradeSpi* tradeSpi = (CustomTradeSpi*)v->second;
                int rt = tradeSpi->
                        reqOrderInsert(params[1], params[2],params[3], params[4],
                                                  LimitPrice, params[5], params[6], params[7], OrderRef);
                write_buf.format("%d", rt);
                quote_vector_flag = true;
                break;
            }
        }
        if (!quote_vector_flag) {
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
bool TradeHttp::ReqOrderAction(HttpRequest& req, HttpResponse& res)
{
    logger("撤单");
    acl::string write_buf;
    const char* params[5]{NULL};
    bool params_flag = true;
    acl::json* json = req.getJson();
    if (NULL == json) {
        acl::string data("{ \"err\": \"no json\"}");
        res.setContentLength(data.size());
        return res.write(data);
    }

    ACL_ARGV *argv = acl_argv_split("InvestorID,OrderRef,SessionID,InstrumentID,FrontID", ",");
    ACL_ITER iter;  // 遍历指针
    unsigned int i=0 ;
    // 遍历分割后的结果
            acl_foreach(iter, argv) {
        // 从遍历指针中取出字符串型数据
        const char *iter_ptr =  (const char*) iter.data;
        acl::json_node* jsonNode = json->getFirstElementByTagName(iter_ptr);
        if (NULL == jsonNode) {
            params_flag = false;
            logger_error("%s is null", iter_ptr);
            write_buf.format_append("%s is null ", iter_ptr);
            break;
        } else {
            params[i] = jsonNode->get_text();
        }
        ++i;
    }

    const char* ExchangeID = NULL;
#ifdef STP
    acl::json_node* jsonNode = json->getFirstElementByTagName("ExchangeID");
    if (NULL == jsonNode) {
        params_flag = false;
        logger_error("%s is null", "ExchangeID");
        write_buf.format_append("%s is null ", "ExchangeID");
    } else {
        ExchangeID = jsonNode->get_text();
    }
#endif
    if (params_flag) {
        bool quote_vector_flag = false;
        for(auto v = sm_vTrade.begin(); v != sm_vTrade.end(); ++v) {
            if (strcmp(v->first, params[0]) == 0) {
                CustomTradeSpi* tradeSpi = (CustomTradeSpi*)v->second;
                int rt = tradeSpi->reqOrderAction(params[4],params[1], params[2],params[3],ExchangeID);
                write_buf.format("%d", rt);
                quote_vector_flag = true;
                break;
            }
        }
        if (!quote_vector_flag) {
            logger("InvestorID is invalid, The corresponding thread could not be found!, InvestorID= %s", params[0]);
            write_buf.format("%d", -19001);
        }
    }

    // 释放内存
    acl_argv_free(argv);
    res.setContentLength(write_buf.size());
    return res.write(write_buf);
}

// 请求登出
bool TradeHttp::ReqUserLogout(HttpRequest& req, HttpResponse& res)
{
    logger("登出");
    acl::string write_buf;
    const char* param;
    bool params_flag = true;
    param = req.getHeader("InvestorID");
    if (NULL == param) {
        params_flag = false;
        logger_error("InvestorID is null");
        write_buf.format("InvestorID is null");
    }

    if (params_flag) {
        bool quote_vector_flag = false;
        for(auto v = sm_vTrade.begin(); v != sm_vTrade.end(); ++v) {
            if (strcmp(v->first, param) == 0) {
                CustomTradeSpi* tradeSpi = (CustomTradeSpi*)v->second;
                int rt = tradeSpi->reqUserLogout();
                write_buf.format("%d", rt);
                quote_vector_flag = true;
                break;
            }
        }
        if (!quote_vector_flag) {
            logger("InvestorID is invalid, The corresponding thread could not be found!, InvestorID= %s", param);
            write_buf.format("%d", -19001);
        }
    }
    res.setContentLength(write_buf.size());
    return res.write(write_buf);
}
