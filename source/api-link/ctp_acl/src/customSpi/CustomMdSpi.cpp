#include <iostream>
#include <cstring>
#include <unordered_map>
#include <Account.h>
#include <memory>
#include "../include/customSpi/CustomMdSpi.h"
#include <acl_cpp/stdlib/log.hpp>
#include <json/acl_json.h>
#include <thread>
#include <stdlib/acl_argv.h>
#include "../include/utils/CtpUtil.h"

//// ---- 全局参数声明 ---- //
//extern char gMdFrontAddr[];                      // 模拟行情前置地址
char *g_pInstrumentID[] = {"IF2106", "rb2107", "a2107", "CF107", "sc2107"}; // 行情合约代码列表，中、上、大、郑交易所各选一种
int instrumentNum = 5;                        // 行情合约订阅数量

#ifdef CTP
static char *TOPIC_SUBSCRIBE_MARKET_DATA = "TopicSubscribeMarketData";
static char *TOPIC_UNSUBSCRIBE_MARKET_DATA = "TopicUnSubscribeMarketData";
static char *TOPIC_DEPTH_MARKET_DATA = "TopicDepthMarketData";
#endif
#ifdef STP
static char *TOPIC_SUBSCRIBE_MARKET_DATA = "Ctp2StpTopicSubscribeMarketData";
static char *TOPIC_UNSUBSCRIBE_MARKET_DATA = "Ctp2StpTopicUnSubscribeMarketData";
static char *TOPIC_DEPTH_MARKET_DATA = "Ctp2StpTopicDepthMarketData";
#endif
#ifdef OPENCTP
static char *TOPIC_SUBSCRIBE_MARKET_DATA = "OpenCtpTopicSubscribeMarketData";
static char *TOPIC_UNSUBSCRIBE_MARKET_DATA = "OpenCtpTopicUnSubscribeMarketData";
static char *TOPIC_DEPTH_MARKET_DATA = "OpenCtpTopicDepthMarketData";
#endif
extern char *md_list;

CustomMdSpi::CustomMdSpi(void):m_pMdUserApi(NULL),m_bLoginFlag(false)
{
}
CustomMdSpi::~CustomMdSpi(void)
{
}


void CustomMdSpi::SetMdApi(CThostFtdcMdApi *mdApi)
{
    m_pMdUserApi = mdApi;
}

void CustomMdSpi::SetAccount(shared_ptr<Account> account)
{
    m_pAccount = account;
}

void CustomMdSpi::loopCmd()
{
    this->printHelp();
    while(1)
    {
        char cmd;
        cin >> cmd;
        switch (cmd)
        {
//            case '1': this->subscribeMarketData(g_pInstrumentID, instrumentNum); break;
//            case '2': this->unSubscribeMarketData(g_pInstrumentID, instrumentNum); break;
//            case '3': this->subscribeForQuoteRsp(); break;
//            case '4': this->unSubscribeForQuoteRsp(); break;
//            case '5': this->reqQryMulticastInstrument(); break;
            case '6': this->reqUserLogout(); break;
            case 'H': this->printHelp(); break;
            default:
                break;
        }
    }
}

void CustomMdSpi::printHelp()
{
    cout << "--------------------------------------------\n"
              << "CustomMdSpi_Demo CMD\n"
              << "--->1: 订阅行情\n"
              << "--->2: 退订行情\n"
              //            << "--->3: 订阅询价\n"
              //            << "--->4: 退订询价\n"
              //            << "--->5: 发送组播合约\n"
              << "--->6: logout\n"
              << "--->H: help\n"
              << "--------------------------------------------\n"
              << endl;
}

void CustomMdSpi::MdThreadReConnFn() {
    if (m_pMdUserApi == NULL) return;
    // 开始登录
    CThostFtdcReqUserLoginField loginReq;
    memset(&loginReq, 0, sizeof(loginReq));
    strcpy(loginReq.BrokerID, m_pAccount->getBrokerID());
    strcpy(loginReq.UserID, m_pAccount->getInvesterID());
    strcpy(loginReq.Password, m_pAccount->getInvesterPwd());

    static int requestID = 0; // 请求编号
    int rt = m_pMdUserApi->ReqUserLogin(&loginReq, ++requestID);
    if (!rt)
        logger(">>>>>>发送登录请求成功");
    else
        logger_error(">>>>>>发送登录请求失败");
    m_Event.WaitEvent();
    if (m_bLoginFlag) {
        logger(">>>>>>登录失败!");
    }
}

// 连接成功应答
void CustomMdSpi::OnFrontConnected()
{

    logger("=====建立网络连接成功=====");
    thread thread(&CustomMdSpi::MdThreadReConnFn, this);
    thread.detach();

}

// 登录应答
void CustomMdSpi::OnRspUserLogin(
        CThostFtdcRspUserLoginField *pRspUserLogin,
        CThostFtdcRspInfoField *pRspInfo,
        int nRequestID,
        bool bIsLast)
{

    bool bResult = pRspInfo && (pRspInfo->ErrorID != 0);
    if (!bResult)
    {
        logger("=====账户登录成功=====");
        logger("交易日: %s, 登录时间: %s, 经纪商: %s, 帐户名: %s", pRspUserLogin->TradingDay,
               pRspUserLogin->LoginTime, pRspUserLogin->BrokerID, pRspUserLogin->UserID);
        // 开始订阅行情
//        subscribeMarketData("AAPL", 0);
        if (strcmp(md_list, "") && md_list != NULL)
        {
            logger("订阅配置文件中的行情");
            logger("md_list=%s", md_list);
            subscribeMarketData(md_list, 0);
        }
    }
    else
    {
        logger_error("返回错误--->>> ErrorID=%d, ErrorMsg=%s", pRspInfo->ErrorID, pRspInfo->ErrorMsg);
    }
}

// 断开连接通知
void CustomMdSpi::OnFrontDisconnected(int nReason)
{
    logger_error("=====网络连接断开=====, 错误码: %d", nReason);
}

// 心跳超时警告
void CustomMdSpi::OnHeartBeatWarning(int nTimeLapse)
{
    logger_error("=====网络心跳超时=====, 距上次连接时间: %d", nTimeLapse);
}


int CustomMdSpi::reqUserLogout()
{
    CThostFtdcUserLogoutField logoutReq = {0};
    strcpy(logoutReq.BrokerID, m_pAccount->getBrokerID());
    strcpy(logoutReq.UserID, m_pAccount->getInvesterID());
    int requestID = 0;
    int rt = m_pMdUserApi->ReqUserLogout(&logoutReq, requestID);
    if(rt == 0) {
        logger(">>>>>>发送登出请求成功");
    } else if(rt == -1) {
        logger_error(">>>>>>网络连接失败");
    } else if(rt == -2) {
        logger_error(">>>>>>未处理请求超过许可数");
    } else if(rt == -3) {
        logger_error(">>>>>>每秒发送请求数超过许可数");
    }
    m_Event.WaitEvent();
    m_pMdUserApi->Release();
//    m_pMdUserApi = NULL;
    return rt;
}

// 登出应答
void CustomMdSpi::OnRspUserLogout(
        CThostFtdcUserLogoutField *pUserLogout,
        CThostFtdcRspInfoField *pRspInfo,
        int nRequestID,
        bool bIsLast)
{

    logger("=====OnRspUserLogout=====");
    m_Event.SignalEvent();

}

int CustomMdSpi::subscribeMarketData(const char *ppInstrumentID, int nCount)
{
    char **pInstrumentID = new char*[50];
//    pInstrumentID[0] = "a2109";
//    pInstrumentID[1] = "sc2107";
    ACL_ARGV *argv = acl_argv_split(ppInstrumentID, ",");
    ACL_ITER iter;  // 遍历指针
    // 遍历分割后的结果
    acl_foreach(iter, argv) {
        nCount = iter.size;
        // 从遍历指针中取出字符串型数据
        char *iter_ptr = (char *) iter.data;
        // 打印单词
        pInstrumentID[iter.i] = iter_ptr;
        logger_debug(DEBUG_TEST2, 1, "%s", pInstrumentID[iter.i]);
    }
    // 释放内存
    acl_argv_free(argv);
    int rt = m_pMdUserApi->SubscribeMarketData(pInstrumentID, nCount);
    if(rt == 0) {
        logger(">>>>>>发送行情订阅请求成功");
    } else if(rt == -1) {
        logger_error(">>>>>>网络连接失败");
    } else if(rt == -2) {
        logger_error(">>>>>>未处理请求超过许可数");
    } else if(rt == -3) {
        logger_error(">>>>>>每秒发送请求数超过许可数");
    }
    delete[] pInstrumentID;
    return rt;
}

// 订阅行情应答
void CustomMdSpi::OnRspSubMarketData(
        CThostFtdcSpecificInstrumentField *pSpecificInstrument,
        CThostFtdcRspInfoField *pRspInfo,
        int nRequestID,
        bool bIsLast)
{
    logger("订阅行情应答");
    if (pSpecificInstrument != NULL) {
        bool bResult = pRspInfo && (pRspInfo->ErrorID != 0);
        if (!bResult)
        {
            logger("=====行情订阅成功=====");
            ACL_JSON* json = acl_json_alloc();
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "InstrumentID", pSpecificInstrument->InstrumentID));
            ACL_VSTRING* buf = acl_json_build(json, NULL);
            logger("%s", acl_vstring_str(buf));
//            CtpUtil::KafkaOrRedis(TOPIC_SUBSCRIBE_MARKET_DATA, acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
            acl_vstring_free(buf);
            acl_json_free(json);
        }
        else
        {
            logger_error("=====行情订阅失败=====");
            ACL_JSON* json = acl_json_alloc();
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "ErrorID", pRspInfo->ErrorID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ErrorMsg", pRspInfo->ErrorMsg));
            ACL_VSTRING* buf = acl_json_build(json, NULL);
            char *outbuf = CtpUtil::CtpConvert(acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
            logger_error("%s", outbuf);
//            CtpUtil::KafkaOrRedis(TOPIC_RSP_INFO, outbuf, strlen(outbuf));
            delete[] outbuf;
            acl_vstring_free(buf);
            acl_json_free(json);
        }
    } else {
        logger("行情为空");
    }

    if(bIsLast) {
        logger("订阅结束");
    }
}

int CustomMdSpi::unSubscribeMarketData(const char *ppInstrumentID, int nCount)
{
    char **pInstrumentID = new char*[50];
//    pInstrumentID[0] = "a2109";
//    pInstrumentID[1] = "sc2107";
    ACL_ARGV *argv = acl_argv_split(ppInstrumentID, ",");
    ACL_ITER iter;  // 遍历指针
    int i = 0;
    // 遍历分割后的结果
            acl_foreach(iter, argv) {
        // 从遍历指针中取出字符串型数据
        char *iter_ptr = (char *) iter.data;
        pInstrumentID[i] = iter_ptr;
        logger_debug(DEBUG_TEST2, 1, "%s\r\n", pInstrumentID[i]);
        ++i;
    }
    // 释放内存
    acl_argv_free(argv);
    nCount = i;
    int rt = m_pMdUserApi->UnSubscribeMarketData(pInstrumentID, nCount);
    if(rt == 0) {
        logger(">>>>>>发送退订行情请求成功");
    } else if(rt == -1) {
        logger_error(">>>>>>网络连接失败");
    } else if(rt == -2) {
        logger_error(">>>>>>未处理请求超过许可数");
    } else if(rt == -3) {
        logger_error(">>>>>>每秒发送请求数超过许可数");
    }
    delete[] pInstrumentID;
    return rt;
}

// 取消订阅行情应答
void CustomMdSpi::OnRspUnSubMarketData(
        CThostFtdcSpecificInstrumentField *pSpecificInstrument,
        CThostFtdcRspInfoField *pRspInfo,
        int nRequestID,
        bool bIsLast)
{
    logger("取消订阅行情应答");
    if (pSpecificInstrument != NULL) {
        bool bResult = pRspInfo && (pRspInfo->ErrorID != 0);
        if (!bResult) {
            logger("=====取消订阅行情成功=====");
            ACL_JSON *json = acl_json_alloc();
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "InstrumentID", pSpecificInstrument->InstrumentID));
            ACL_VSTRING *buf = acl_json_build(json, NULL);
            logger("%s", acl_vstring_str(buf));
//            CtpUtil::KafkaOrRedis(TOPIC_UNSUBSCRIBE_MARKET_DATA, acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
            acl_vstring_free(buf);
            acl_json_free(json);
        } else {
            logger("=====取消订阅行情失败=====");
            ACL_JSON *json = acl_json_alloc();
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "ErrorID", pRspInfo->ErrorID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ErrorMsg", pRspInfo->ErrorMsg));
            ACL_VSTRING *buf = acl_json_build(json, NULL);
            char *outbuf = CtpUtil::CtpConvert(acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
            logger("%s", outbuf);
//            CtpUtil::KafkaOrRedis(TOPIC_RSP_INFO, outbuf, strlen(outbuf));
            delete[] outbuf;
            acl_vstring_free(buf);
            acl_json_free(json);
        }
    } else {
        logger("取消订阅为空");
    }

    if(bIsLast) {
        logger("取消订阅结束");
    }
}

// 行情详情通知
void CustomMdSpi::OnRtnDepthMarketData(CThostFtdcDepthMarketDataField *pDepthMarketData) {
    ACL_JSON* json = acl_json_alloc();
    acl_json_node_add_child(json->root,
                            acl_json_create_text(json, "TradingDay", pDepthMarketData->TradingDay));
    acl_json_node_add_child(json->root,
                            acl_json_create_text(json, "InstrumentID", pDepthMarketData->InstrumentID));
    acl_json_node_add_child(json->root,
                            acl_json_create_text(json, "ExchangeID", pDepthMarketData->ExchangeID));
    acl_json_node_add_child(json->root,
                            acl_json_create_text(json, "ExchangeInstID", pDepthMarketData->ExchangeInstID));
    // 今开盘
    if (pDepthMarketData->OpenPrice > DOUBLE_MAX_VALUE) // 如果服务器传过来的数据无效，数值为 1.79769e+308
    {
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "OpenPrice", NULL)); // 填 NULL
    }
    else // 否则，正常处理
    {
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "OpenPrice", pDepthMarketData->OpenPrice));
    }
    // 最高价
    if (pDepthMarketData->HighestPrice > DOUBLE_MAX_VALUE) {
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "HighestPrice", NULL));
    } else {
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "HighestPrice", pDepthMarketData->HighestPrice));
    }
    // 最低价
    if (pDepthMarketData->LowestPrice > DOUBLE_MAX_VALUE) {
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "LowestPrice", NULL));
    } else {
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "LowestPrice", pDepthMarketData->LowestPrice));
    }
    // 上次结算价
    if (pDepthMarketData->PreSettlementPrice > DOUBLE_MAX_VALUE) {
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "PreSettlementPrice", NULL));
    } else {
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "PreSettlementPrice", pDepthMarketData->PreSettlementPrice));
    }
    // 昨收盘
    if (pDepthMarketData->PreClosePrice > DOUBLE_MAX_VALUE) {
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "PreClosePrice", NULL));
    } else {
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "PreClosePrice", pDepthMarketData->PreClosePrice));
    }
    // 涨停板价
    if (pDepthMarketData->UpperLimitPrice > DOUBLE_MAX_VALUE) {
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "UpperLimitPrice", NULL));
    } else {
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "UpperLimitPrice", pDepthMarketData->UpperLimitPrice));
    }
    // 跌停板价
    if (pDepthMarketData->LowerLimitPrice > DOUBLE_MAX_VALUE) {
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "LowerLimitPrice", NULL));
    } else {
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "LowerLimitPrice", pDepthMarketData->LowerLimitPrice));
    }
    // 申买价一
    if (pDepthMarketData->BidPrice1 > DOUBLE_MAX_VALUE) {
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "BidPrice1", NULL));
    } else {
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "BidPrice1", pDepthMarketData->BidPrice1));
    }
    // 申卖价一
    if (pDepthMarketData->AskPrice1 > DOUBLE_MAX_VALUE) {
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "AskPrice1", NULL));
    } else {
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "AskPrice1", pDepthMarketData->AskPrice1));
    }
    // 今虚实度
    if (pDepthMarketData->CurrDelta > DOUBLE_MAX_VALUE) {
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "CurrDelta", NULL));
    } else {
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "CurrDelta", pDepthMarketData->CurrDelta));
    }
    // 昨虚实度
    if (pDepthMarketData->PreDelta > DOUBLE_MAX_VALUE) {
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "PreDelta", NULL));
    } else {
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "PreDelta", pDepthMarketData->PreDelta));
    }
    // 申买价二
    if (pDepthMarketData->BidPrice2 > DOUBLE_MAX_VALUE) {
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "BidPrice2", NULL));
    } else {
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "BidPrice2", pDepthMarketData->BidPrice2));
    }
    // 申卖价二
    if (pDepthMarketData->AskPrice2 > DOUBLE_MAX_VALUE) {
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "AskPrice2", NULL));
    } else {
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "AskPrice2", pDepthMarketData->AskPrice2));
    }
    // 申卖价三
    if (pDepthMarketData->BidPrice3 > DOUBLE_MAX_VALUE) {
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "BidPrice3", NULL));
    } else {
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "BidPrice3", pDepthMarketData->BidPrice3));
    }
    // 申卖价三
    if (pDepthMarketData->AskPrice3 > DOUBLE_MAX_VALUE) {
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "AskPrice3", NULL));
    } else {
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "AskPrice3", pDepthMarketData->AskPrice3));
    }
    // 申买价四
    if (pDepthMarketData->BidPrice4 > DOUBLE_MAX_VALUE) {
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "BidPrice4", NULL));
    } else {
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "BidPrice4", pDepthMarketData->BidPrice4));
    }
    // 申卖价四
    if (pDepthMarketData->AskPrice4 > DOUBLE_MAX_VALUE) {
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "AskPrice4", NULL));
    } else {
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "AskPrice4", pDepthMarketData->AskPrice4));
    }
    // 申买价五
    if (pDepthMarketData->BidPrice5 > DOUBLE_MAX_VALUE) {
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "BidPrice5", NULL));
    } else {
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "BidPrice5", pDepthMarketData->BidPrice5));
    }
    // 申卖价五
    if (pDepthMarketData->AskPrice5 > DOUBLE_MAX_VALUE) {
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "AskPrice5", NULL));
    } else {
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "AskPrice5", pDepthMarketData->AskPrice5));
    }
    // 今收盘
    if (pDepthMarketData->ClosePrice > DOUBLE_MAX_VALUE) {
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "ClosePrice", NULL));
    } else {
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "ClosePrice", pDepthMarketData->ClosePrice));
    }
    // 本次结算价
    if (pDepthMarketData->SettlementPrice > DOUBLE_MAX_VALUE) {
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "SettlementPrice", NULL));
    } else {
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "SettlementPrice", pDepthMarketData->SettlementPrice));
    }

    acl_json_node_add_child(json->root,
                            acl_json_create_double(json, "LastPrice", pDepthMarketData->LastPrice));
    acl_json_node_add_child(json->root,
                            acl_json_create_double(json, "PreOpenInterest", pDepthMarketData->PreOpenInterest));
    acl_json_node_add_child(json->root,
                            acl_json_create_int64(json, "Volume", pDepthMarketData->Volume));
    acl_json_node_add_child(json->root,
                            acl_json_create_double(json, "Turnover", pDepthMarketData->Turnover));
    acl_json_node_add_child(json->root,
                            acl_json_create_double(json, "OpenInterest", pDepthMarketData->OpenInterest));
    acl_json_node_add_child(json->root,
                            acl_json_create_text(json, "UpdateTime", pDepthMarketData->UpdateTime));
    acl_json_node_add_child(json->root,
                            acl_json_create_int64(json, "UpdateMillisec", pDepthMarketData->UpdateMillisec));
    acl_json_node_add_child(json->root,
                            acl_json_create_int64(json, "BidVolume1", pDepthMarketData->BidVolume1));
    acl_json_node_add_child(json->root,
                            acl_json_create_int64(json, "AskVolume1", pDepthMarketData->AskVolume1));
    acl_json_node_add_child(json->root,
                            acl_json_create_int64(json, "BidVolume2", pDepthMarketData->BidVolume2));
    acl_json_node_add_child(json->root,
                            acl_json_create_int64(json, "AskVolume2", pDepthMarketData->AskVolume2));
    acl_json_node_add_child(json->root,
                            acl_json_create_int64(json, "BidVolume3", pDepthMarketData->BidVolume3));
    acl_json_node_add_child(json->root,
                            acl_json_create_int64(json, "AskVolume3", pDepthMarketData->AskVolume3));
    acl_json_node_add_child(json->root,
                            acl_json_create_int64(json, "BidVolume4", pDepthMarketData->BidVolume4));
    acl_json_node_add_child(json->root,
                            acl_json_create_int64(json, "AskVolume4", pDepthMarketData->AskVolume4));
    acl_json_node_add_child(json->root,
                            acl_json_create_int64(json, "BidVolume5", pDepthMarketData->BidVolume5));
    acl_json_node_add_child(json->root,
                            acl_json_create_int64(json, "AskVolume5", pDepthMarketData->AskVolume5));
    acl_json_node_add_child(json->root,
                            acl_json_create_double(json, "AveragePrice", pDepthMarketData->AveragePrice));
    acl_json_node_add_child(json->root,
                            acl_json_create_text(json, "ActionDay", pDepthMarketData->ActionDay));

    ACL_VSTRING* buf = acl_json_build(json, NULL);
    logger_debug(DEBUG_TEST3, 2, "%s", acl_vstring_str(buf));
    CtpUtil::KafkaOrRedis(TOPIC_DEPTH_MARKET_DATA, acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
    acl_vstring_free(buf);
    acl_json_free(json);
}


// 错误通知
void CustomMdSpi::OnRspError(CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast)
{
    ACL_JSON* json = acl_json_alloc();
    acl_json_node_add_child(json->root,
                            acl_json_create_int64(json, "ErrorMsg", pRspInfo->ErrorID));
    acl_json_node_add_child(json->root,
                            acl_json_create_text(json, "ErrorMsg", pRspInfo->ErrorMsg));
    ACL_VSTRING* buf = acl_json_build(json, NULL);
    char *outbuf = CtpUtil::CtpConvert(acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
    logger("%s", outbuf);
//    CtpUtil::KafkaOrRedis(TOPIC_RSP_INFO, outbuf, strlen(outbuf));
    delete[] outbuf;
    acl_vstring_free(buf);
    acl_json_free(json);

    if(bIsLast) {
        logger("The last piece of data");
    }
}




void CustomMdSpi::subscribeForQuoteRsp()
{
    char **ppInstrumentID = new char*[50];
    ppInstrumentID[0] = "sc2103";
    int rt = m_pMdUserApi->SubscribeForQuoteRsp(ppInstrumentID, 1);
    if(rt == 0) {
        logger(">>>>>>发送订阅询价请求成功");
    } else if(rt == -1) {
        logger(">>>>>>网络连接失败");
    } else if(rt == -2) {
        logger(">>>>>>未处理请求超过许可数");
    } else if(rt == -3) {
        logger(">>>>>>每秒发送请求数超过许可数");
    }
}

// 订阅询价应答
void CustomMdSpi::OnRspSubForQuoteRsp(
        CThostFtdcSpecificInstrumentField *pSpecificInstrument,
        CThostFtdcRspInfoField *pRspInfo,
        int nRequestID,
        bool bIsLast)
{
    bool bResult = pRspInfo && (pRspInfo->ErrorID != 0);
    if (!bResult)
    {
        logger("=====订阅询价成功=====");
        logger("合约代码: %s", pSpecificInstrument->InstrumentID);
    }
    else
        logger_error("返回错误--->>> ErrorID=%d", pRspInfo->ErrorID);
}


void CustomMdSpi::unSubscribeForQuoteRsp()
{
    char **ppInstrumentID = new char*[50];
    ppInstrumentID[0] = "sc2103";
    int rt = m_pMdUserApi->UnSubscribeForQuoteRsp(ppInstrumentID, 1);
    if(rt == 0) {
        logger(">>>>>>发送退订询价请求成功");
    } else if(rt == -1) {
        logger(">>>>>>网络连接失败");
    } else if(rt == -2) {
        logger(">>>>>>未处理请求超过许可数");
    } else if(rt == -3) {
        logger(">>>>>>每秒发送请求数超过许可数");
    }
}

// 取消订阅询价应答
void CustomMdSpi::OnRspUnSubForQuoteRsp(CThostFtdcSpecificInstrumentField *pSpecificInstrument, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast)
{
    bool bResult = pRspInfo && (pRspInfo->ErrorID != 0);
    if (!bResult)
    {
        logger("=====取消订阅询价成功=====");
        logger("合约代码: %s", pSpecificInstrument->InstrumentID);
    }
    else
        logger_error("返回错误--->>> ErrorID=%d", pRspInfo->ErrorID);
}



// 询价详情通知
void CustomMdSpi::OnRtnForQuoteRsp(CThostFtdcForQuoteRspField *pForQuoteRsp)
{
    // 部分询价结果
    cout << "=====获得询价结果=====" << endl;
    cout <<"交易日" << pForQuoteRsp->TradingDay << ","
              << "合约代码: " << pForQuoteRsp->InstrumentID << ","
              << "询价编号: " << pForQuoteRsp->ForQuoteSysID << ","
              << "询价时间: " << pForQuoteRsp->ForQuoteTime << ","
              << "业务日期: " << pForQuoteRsp->ActionDay << ","
              << "交易所代码: " << pForQuoteRsp->ExchangeID
              << endl;
}

void CustomMdSpi::reqQryMulticastInstrument()
{
    CThostFtdcQryMulticastInstrumentField a = {0};
    a.TopicID = 1001;
    strcpy(a.InstrumentID, "cu1906");
    int rt = m_pMdUserApi->ReqQryMulticastInstrument(&a, 1);
    if(rt == 0) {
        logger(">>>>>>发送组播合约请求成功");
    } else if(rt == -1) {
        logger(">>>>>>网络连接失败");
    } else if(rt == -2) {
        logger(">>>>>>未处理请求超过许可数");
    } else if(rt == -3) {
        logger(">>>>>>每秒发送请求数超过许可数");
    }
}

// 请求查询组播合约响应
void CustomMdSpi::OnRspQryMulticastInstrument(CThostFtdcMulticastInstrumentField *pMulticastInstrument,
                                              CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast)
{
    bool bResult = pRspInfo && (pRspInfo->ErrorID != 0);
    if (!bResult)
    {
        cout <<"=====获得组播合约响应结果=====\n"
                  << "主题号: " << pMulticastInstrument->TopicID << ","
                  << "合约代码: " << pMulticastInstrument->InstrumentID << ","
                  << "合约编号: " << pMulticastInstrument->InstrumentNo << ","
                  << "基准价: " << pMulticastInstrument->CodePrice << ","
                  << "合约数量乘数: " << pMulticastInstrument->VolumeMultiple << ","
                  << "最小变动价位: " << pMulticastInstrument->PriceTick
                  << endl;
    }
    else
        cerr << "返回错误--->>> ErrorID=" << pRspInfo->ErrorID << endl;
}
