#include <iostream>
#include <thread>
#include <chrono>
#include <cstring>
#include "../include/customSpi/CustomTradeSpi.h"
#include "iconv.h"
#include <memory>
#include <acl_cpp/stdlib/log.hpp>
#include <json/acl_json.h>
#include <sstream>
#include <http/TradeHttp.h>
#include "../include/utils/CtpUtil.h"

// ---- 参数声明 ---- //
#ifdef CTP
static char *TOPIC_ORDER_ACTION = "TopicOrderAction";
static char *TOPIC_INPUT_ORDER_ACTION = "TopicInputOrderAction";
static char *TOPIC_ORDER = "TopicOrder";
static char *TOPIC_INPUT_ORDER = "TopicInputOrder";
static char *TOPIC_INVESTOR_POSITION = "TopicInvestorPosition";
static char *TOPIC_TRADING_ACCOUNT = "TopicTradingAccount";
static char *TOPIC_INSTRUMENT = "TopicInstrument";
static char *TOPIC_PRODUCT = "TopicProduct";
static char *TOPIC_EXCHANGE = "TopicExchange";
static char *TOPIC_TRADE = "TopicTrade";
static char *TOPIC_INVESTOR_POSITION_DETAIL = "TopicInvestorPositionDetail";
static char *TOPIC_INSTRUMENT_MARGIN_RATE = "TopicInstrumentMarginRate";
static char *TOPIC_INSTRUMENT_COMMISSION_RATE = "TopicInstrumentCommissionRate";
static char *TOPIC_INSTRUMENT_ORDER_COMMRATE = "TopicInstrumentOrderCommRate";
static char *TOPIC_TRADE_DEPTH_MARKET_DATA = "TopicTradeDepthMarketData";
static char *TOPIC_SETTLEMENT_INFO = "TopicSettlementInfo";
static char *TOPIC_SETTLEMENT_INFO_CONFIRM = "TopicSettlementInfoConfirm";
static char *TOPIC_BROKER_TRADING_PARAMS = "TopicBrokerTradingParams";
#endif
#ifdef STP
static char *TOPIC_ORDER_ACTION = "Ctp2StpTopicOrderAction";
static char *TOPIC_INPUT_ORDER_ACTION = "Ctp2StpTopicInputOrderAction";
static char *TOPIC_ORDER = "Ctp2StpTopicOrder";
static char *TOPIC_INPUT_ORDER = "Ctp2StpTopicInputOrder";
static char *TOPIC_INVESTOR_POSITION = "Ctp2StpTopicInvestorPosition";
static char *TOPIC_TRADING_ACCOUNT = "Ctp2StpTopicTradingAccount";
static char *TOPIC_INSTRUMENT = "Ctp2StpTopicInstrument";
static char *TOPIC_PRODUCT = "Ctp2StpTopicProduct";
static char *TOPIC_EXCHANGE = "Ctp2StpTopicExchange";
static char *TOPIC_TRADE = "Ctp2StpTopicTrade";
static char *TOPIC_INVESTOR_POSITION_DETAIL = "Ctp2StpTopicInvestorPositionDetail";
static char *TOPIC_INSTRUMENT_MARGIN_RATE = "Ctp2StpTopicInstrumentMarginRate";
static char *TOPIC_INSTRUMENT_COMMISSION_RATE = "Ctp2StpTopicInstrumentCommissionRate";
static char *TOPIC_INSTRUMENT_ORDER_COMMRATE = "Ctp2StpTopicInstrumentOrderCommRate";
static char *TOPIC_TRADE_DEPTH_MARKET_DATA = "Ctp2StpTopicTradeDepthMarketData";
static char *TOPIC_SETTLEMENT_INFO = "Ctp2StpTopicSettlementInfo";
static char *TOPIC_SETTLEMENT_INFO_CONFIRM = "Ctp2StpTopicSettlementInfoConfirm";
static char *TOPIC_BROKER_TRADING_PARAMS = "Ctp2StpTopicBrokerTradingParams";
#endif
#ifdef OPENCTP
static char *TOPIC_ORDER_ACTION = "OpenCtpTopicOrderAction";
static char *TOPIC_INPUT_ORDER_ACTION = "OpenCtpTopicInputOrderAction";
static char *TOPIC_ORDER = "OpenCtpTopicOrder";
static char *TOPIC_INPUT_ORDER = "OpenCtpTopicInputOrder";
static char *TOPIC_INVESTOR_POSITION = "OpenCtpTopicInvestorPosition";
static char *TOPIC_TRADING_ACCOUNT = "OpenCtpTopicTradingAccount";
static char *TOPIC_INSTRUMENT = "OpenCtpTopicInstrument";
static char *TOPIC_PRODUCT = "OpenCtpTopicProduct";
static char *TOPIC_EXCHANGE = "OpenCtpTopicExchange";
static char *TOPIC_TRADE = "OpenCtpTopicTrade";
static char *TOPIC_INVESTOR_POSITION_DETAIL = "OpenCtpTopicInvestorPositionDetail";
static char *TOPIC_INSTRUMENT_MARGIN_RATE = "OpenCtpTopicInstrumentMarginRate";
static char *TOPIC_INSTRUMENT_COMMISSION_RATE = "OpenCtpTopicInstrumentCommissionRate";
static char *TOPIC_INSTRUMENT_ORDER_COMMRATE = "OpenCtpTopicInstrumentOrderCommRate";
static char *TOPIC_TRADE_DEPTH_MARKET_DATA = "OpenCtpTopicTradeDepthMarketData";
static char *TOPIC_SETTLEMENT_INFO = "OpenCtpTopicSettlementInfo";
static char *TOPIC_SETTLEMENT_INFO_CONFIRM = "OpenCtpTopicSettlementInfoConfirm";
static char *TOPIC_BROKER_TRADING_PARAMS = "OpenCtpTopicBrokerTradingParams";
#endif

// 会话参数
TThostFtdcFrontIDType	trade_front_id;	//前置编号
TThostFtdcSessionIDType	session_id;	//会话编号
TThostFtdcOrderRefType	order_ref;	//报单引用 是本地会话全局唯一编号，必须保持递增；可由用户维护，也可由系统自动填写。一定为数字
time_t lOrderTime;
time_t lOrderOkTime;

CustomTradeSpi::CustomTradeSpi(void):
        m_pTradeUserApi(NULL),
        m_bLoginFlag(false),
        m_bAuthFlag(false),
        m_bLogoutFlag(false)
{
}
CustomTradeSpi::~CustomTradeSpi(void)
{
}

void CustomTradeSpi::SetTradeApi(CThostFtdcTraderApi* tradeApi) {
    m_pTradeUserApi = tradeApi;
}

void CustomTradeSpi::SetAccount(shared_ptr<Account> account) {
    m_pAccount = account;
}

void CustomTradeSpi::loopCmd()
{
    this->printHelp();
    while(1)
    {
        int cmd;
        cin >> cmd;
        switch (cmd)
        {
//            case 1: this->reqOrderInsert(); break;
//            case 2: this->reqOrderAction(); break;
            case 3: this->reqQryOrder(); break;
            case 4: this->reqQryTrade(); break;
//            case 5: this->reqQryInvestorPosition(); break;
            case 6: this->reqQryInstrumentMarginRate("1", "rb2017"); break;
//            case 7: this->reqQryInstrument(); break;
            case 8: this->reqQryInstrumentCommissionRate("rb2017", ""); break;
            case 9: this->reqQryInstrumentOrderCommRate("rb2017"); break;
//            case 10: this->reqQryTradingAccount("183110"); break;
//            case 11: this->reqQryExchange(); break;
//            case 12: this->reqQryInvestorPositionDetail(); break;
            case 13: this->reqQueryMaxOrderVolume(); break;
            case 14: this->reqQryInvestor(); break;
            case 15: this->reqQryTradingCode(); break;
            case 16: this->reqQryDepthMarketData("rb2107"); break;
            case 17: this->reqQrySettlementInfo(NULL); break;
            case 18: this->reqQryProduct(NULL, NULL); break;
//            case 19: this->reqQryParkedOrder(); break;
//            case 20: this->reqQryParkedOrderAction(); break;
//            case 21: this->reqParkedOrderInsert(); break;
//            case 22: this->reqParkedOrderAction(); break;
//            case 23: this->reqRemoveParkedOrder(); break;
//            case 24: this->reqRemoveParkedOrderAction(); break;
            case 25: this->reqUserLogout(); break;
            case 26: this->reqSettlementInfoConfirm(); break;
            case 27: this->reqQrySettlementInfoConfirm(); break;
            case 0: this->printHelp(); break;
            default:
                break;
        }
    }
}

void CustomTradeSpi::printHelp()
{
    cout <<"--------------------------------------------\n"
              << "CustomTradeSpi_Demo CMD\n"
              << "--->1: 报单\n"
              << "--->2: 撤单\n"
              << "--->3: 查询报单\n"
              << "--->4: 查询成交\n"
              << "--->5: 查询持仓\n"
              << "--->6: 查询合约保证金率\n"
              << "--->7: 查询合约的返回中会带每条合约的保证金率\n"
              << "--->8: 查询合约手续费率\n"
              << "--->9: 查询报单手续费率 中金所持有\n"
              << "--->10: 请求查询资金帐户\n"
              << "--->11: 请求查询交易所\n"
              << "--->12: 请求查询投资者持仓明细\n"
              //         << "--->13: 查询最大保报单数量\n"
              << "--->14: 请求查询投资者\n"
              << "--->15: 请求查询交易编号\n"
              << "--->16: 请求查询行情\n"
              << "--->17: 请求查询投资者结算结果\n"
              << "--->18: 请求查询产品\n"
              //         << "--->19: 请求查询预埋单\n"
              //         << "--->20: 请求查询预埋单撤单\n"
              //         << "--->21: 预埋单录入请求\n"
              //         << "--->22: 预埋撤单录入请求\n"
              //         << "--->23: 请求删除预埋单\n"
              //         << "--->24: 请求删除预埋撤单\n"
              << "--->25: logout\n"
              << "--->0: help\n"
              << "--------------------------------------------\n"
              << endl;
}


void CustomTradeSpi::TradeThreadReConnFn()
{
    if (m_pTradeUserApi == NULL) {
        logger_error("m_pTradeUserApi is NULL");
        return;
    }
    // 客户端认证
    if (reqAuthenticate() != 0)
    {
        return;
    }
    // Wait for the client authentication callback
    m_Event.WaitEvent();
    if (!m_bAuthFlag)
    {
        logger_error("客户端认证失败!");
        return;
    }

    // 开始登录
    if (reqUserLogin() != 0)
    {
        return;
    }
    // Wait for a login request callback
    m_Event.WaitEvent();
    if (!m_bLoginFlag)
    {
        logger_error("登录失败!");
        return;
    }
//    m_pTradeUserApi->Release();
//    logger_error("logout!");
}

void CustomTradeSpi::OnFrontConnected()
{
    logger("=====建立网络连接成功=====");
    if (!m_bLogoutFlag) {
        thread thread(&CustomTradeSpi::TradeThreadReConnFn, this);
        thread.detach();
    }
}

// 请求客户端认证
int CustomTradeSpi::reqAuthenticate()
{
    CThostFtdcReqAuthenticateField authenticateReq;
    memset(&authenticateReq, 0, sizeof(authenticateReq));
    strcpy(authenticateReq.BrokerID, m_pAccount->getBrokerID());
    strcpy(authenticateReq.UserID, m_pAccount->getInvesterID());
    strcpy(authenticateReq.AuthCode, m_pAccount->getAuthCode());
    strcpy(authenticateReq.AppID, m_pAccount->getAppId());
    int rt = m_pTradeUserApi->ReqAuthenticate(&authenticateReq, 0);
    if (!rt) {
        logger(">>>>>>发送客户端认证请求成功");
    } else if(rt == -1) {
        logger_error(">>>>>>网络连接失败");
    } else if(rt == -2) {
        logger_error(">>>>>>未处理请求超过许可数");
    } else if(rt == -3) {
        logger_error(">>>>>>每秒发送请求数超过许可数");
    }
    return rt;
}

// 客户端认证响应
void CustomTradeSpi::OnRspAuthenticate(CThostFtdcRspAuthenticateField *pRspAuthenticateField,
                                       CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast) {
    if (!isErrorRspInfo(pRspInfo)) {
        m_bAuthFlag = true;
        logger("=====客户端认证响应成功=====");
        logger("经纪商: %s, 帐户名: %s, 用户端产品信息: %s, App代码: %s, App类型: %c", pRspAuthenticateField->BrokerID,
               pRspAuthenticateField->UserID, pRspAuthenticateField->UserProductInfo, pRspAuthenticateField->AppID,
               pRspAuthenticateField->AppType);
    }
    m_Event.SignalEvent();
}

int CustomTradeSpi::reqUserLogin()
{
    CThostFtdcReqUserLoginField loginReq;
    memset(&loginReq, 0, sizeof(loginReq));
    strcpy(loginReq.BrokerID, m_pAccount->getBrokerID());
    strcpy(loginReq.UserID, m_pAccount->getInvesterID());
    strcpy(loginReq.Password, m_pAccount->getInvesterPwd());
    static int nRequestID = 0; // 请求编号
    int rt = m_pTradeUserApi->ReqUserLogin(&loginReq, nRequestID);
    if (!rt) {
        logger(">>>>>>发送登录请求成功");
    } else if(rt == -1) {
        logger_error(">>>>>>网络连接失败");
    } else if(rt == -2) {
        logger_error(">>>>>>未处理请求超过许可数");
    } else if(rt == -3) {
        logger_error(">>>>>>每秒发送请求数超过许可数");
    }
    return rt;
}

void CustomTradeSpi::OnRspUserLogin(
        CThostFtdcRspUserLoginField *pRspUserLogin,
        CThostFtdcRspInfoField *pRspInfo,
        int nRequestID,
        bool bIsLast)
{
    if (!isErrorRspInfo(pRspInfo))
    {
        logger("=====账户登录成功=====");
        m_bLoginFlag = true;
        logger("交易日: %s, 登录时间: %s, 经纪商: %s, 帐户名: %s", pRspUserLogin->TradingDay,
               pRspUserLogin->LoginTime, pRspUserLogin->BrokerID, pRspUserLogin->UserID);
        // 保存会话参数
        trade_front_id = pRspUserLogin->FrontID;
        session_id = pRspUserLogin->SessionID;
        strcpy(order_ref, pRspUserLogin->MaxOrderRef);
#ifdef CTP
        // 投资者结算结果确认
        reqSettlementInfoConfirm();
//        reqQryBrokerTradingParams();
#endif
    }
    m_Event.SignalEvent();
}

void CustomTradeSpi::OnRspError(CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast)
{
    logger_error("错误应答");
    isErrorRspInfo(pRspInfo);
}

void CustomTradeSpi::OnFrontDisconnected(int nReason)
{
    logger_error("=====网络连接断开=====, 错误码: %d", nReason);
    m_bAuthFlag = false;
    m_bLoginFlag = false;
}

void CustomTradeSpi::OnHeartBeatWarning(int nTimeLapse)
{
    logger_error("=====网络心跳超时=====, 距上次连接时间: %d", nTimeLapse);
}





/// 报单录入
int CustomTradeSpi::reqOrderInsert(const char *exchangeId, const char *instrumentID,
        const char *direction, const char *orderPriceType, const char *limitPrice, const char* volume,
        const char *combOffsetFlag, const char *CombHedgeFlag, const char *OrderRef)
{
    logger_debug(DEBUG_TEST2, 1, "exchangeId=%s,instrumentID=%s,direction=%s,orderPriceType=%s,limitPrice=%s,volume=%s,combOffsetFlag=%s,CombHedgeFlag=%s",
                exchangeId,instrumentID,direction,orderPriceType,limitPrice,volume,combOffsetFlag,CombHedgeFlag);
    CThostFtdcInputOrderField orderInsertReq;
    memset(&orderInsertReq, 0, sizeof(orderInsertReq));
    ///经纪公司代码
    strcpy(orderInsertReq.BrokerID, m_pAccount->getBrokerID());
    ///投资者代码OrderInsert
    strcpy(orderInsertReq.InvestorID, m_pAccount->getInvesterID());
    ///用户代码 报单时需填UserID，否则收不到 OnErrRtnOrderInsert 报错，一般客户和InvestorID填写一样就可以
//    strcpy(orderInsertReq.UserID, m_pAccount->getInvesterID());
    ///交易所代码 全部大写 CFFEX、CZCE、DCE、INE、SHFE
    strcpy(orderInsertReq.ExchangeID, exchangeId);
    ///合约代码
    strcpy(orderInsertReq.InstrumentID, instrumentID);
    ///报单引用
    if (OrderRef != NULL)
    {
        strcpy(orderInsertReq.OrderRef, OrderRef);
    }
    ///报单价格条件: 限价
    orderInsertReq.OrderPriceType = orderPriceType[0];
    ///买卖方向: (0->buy 1->sell)
    orderInsertReq.Direction = direction[0];
    ///组合开平标志: 开平(0->开仓 1->平仓/平昨 3->平今)
    orderInsertReq.CombOffsetFlag[0] = combOffsetFlag[0];
    ///组合投机套保标志
    orderInsertReq.CombHedgeFlag[0] = CombHedgeFlag[0];
    if (NULL != limitPrice) {
        ///价格 只有OrderPriceType是限价单的时候需要填写，填写的时候注意价格要是最小变动价位（查询合约可得）的整数倍，否则会被拒单
        orderInsertReq.LimitPrice = atof(limitPrice);
    }
    ///数量：1
    orderInsertReq.VolumeTotalOriginal = atoi(volume);
    ///有效期类型: 当日有效
    orderInsertReq.TimeCondition = THOST_FTDC_TC_GFD;
    ///成交量类型: 任何数量
    orderInsertReq.VolumeCondition = THOST_FTDC_VC_AV;
    ///最小成交量: 1
//    orderInsertReq.MinVolume = 1;
    ///触发条件: 立即
    orderInsertReq.ContingentCondition = THOST_FTDC_CC_Immediately;
//    ///触发条件: 止损
//    orderInsertReq.ContingentCondition = THOST_FTDC_CC_Touch;
//    ///触发条件: 止赢
//    orderInsertReq.ContingentCondition = THOST_FTDC_CC_TouchProfit;

//    orderInsertReq.ContingentCondition = THOST_FTDC_CC_LastPriceGreaterThanStopPrice;
//    orderInsertReq.StopPrice = 5680.2;
    ///强平原因: 非强平
    orderInsertReq.ForceCloseReason = THOST_FTDC_FCC_NotForceClose;

    ///以下字段为选填
    ///自动挂起标志: 否
    orderInsertReq.IsAutoSuspend = 0;
    ///用户强评标志: 否
    orderInsertReq.UserForceClose = 0;
    strcpy(orderInsertReq.MacAddress, "123456");
    strcpy(orderInsertReq.CurrencyID, "RMB");

    static int nRequestID = 0; // 请求编号
    int rt = m_pTradeUserApi->ReqOrderInsert(&orderInsertReq, ++nRequestID);
    if (!rt)
        logger(">>>>>>发送报单录入请求成功");
    else
        logger_error("--->>>发送报单录入请求失败, errorCode= %d", rt);
    return rt;
}

// 报单录入请求响应 ReqOrderInsert有字段填写不对
void CustomTradeSpi::OnRspOrderInsert(
        CThostFtdcInputOrderField *pInputOrder,
        CThostFtdcRspInfoField *pRspInfo,
        int nRequestID,
        bool bIsLast)
{
//    cout << "nRequestID=" << nRequestID << endl;
    bool bResult = pRspInfo && (pRspInfo->ErrorID != 0);
    if (bResult) {
        ACL_JSON* json = acl_json_alloc();
        acl_json_node_add_child(json->root,
                                acl_json_create_int64(json, "ErrorID", pRspInfo->ErrorID));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "ErrorMsg", pRspInfo->ErrorMsg));

        if (pInputOrder != NULL) {
            string OrderPriceType(1, pInputOrder->OrderPriceType);
            string Direction(1, pInputOrder->Direction);
            string TimeCondition(1, pInputOrder->TimeCondition);
            string VolumeCondition(1, pInputOrder->VolumeCondition);
            string ContingentCondition(1, pInputOrder->ContingentCondition);
            string ForceCloseReason(1, pInputOrder->ForceCloseReason);
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "BrokerID", pInputOrder->BrokerID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "InvestorID", pInputOrder->InvestorID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "InstrumentID", pInputOrder->InstrumentID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "OrderRef", pInputOrder->OrderRef));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "UserID", pInputOrder->UserID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "OrderPriceType", OrderPriceType.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "Direction", Direction.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "CombOffsetFlag", pInputOrder->CombOffsetFlag));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "CombHedgeFlag", pInputOrder->CombHedgeFlag));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "LimitPrice", pInputOrder->LimitPrice));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "VolumeTotalOriginal", pInputOrder->VolumeTotalOriginal));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "TimeCondition", TimeCondition.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "GTDDate", pInputOrder->GTDDate));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "VolumeCondition", VolumeCondition.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "MinVolume", pInputOrder->MinVolume));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ContingentCondition", ContingentCondition.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "StopPrice", pInputOrder->StopPrice));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ForceCloseReason", ForceCloseReason.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "IsAutoSuspend", pInputOrder->IsAutoSuspend));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "BusinessUnit", pInputOrder->BusinessUnit));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "RequestID", pInputOrder->RequestID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "UserForceClose", pInputOrder->UserForceClose));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "IsSwapOrder", pInputOrder->IsSwapOrder));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ExchangeID", pInputOrder->ExchangeID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "InvestUnitID", pInputOrder->InvestUnitID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "AccountID", pInputOrder->AccountID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "CurrencyID", pInputOrder->CurrencyID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ClientID", pInputOrder->ClientID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "IPAddress", pInputOrder->IPAddress));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "MacAddress", pInputOrder->MacAddress));
        }
//        char *errorMsg =  pRspInfo->ErrorMsg;
//        char *msg = CtpUtil::CtpConvert(errorMsg, sizeof(errorMsg));
//        logger_error("OnRspOrderInsert 错误响应; ErrorID=%d, ErrorMsg=%s", pRspInfo->ErrorID, msg);
//
        ACL_VSTRING* buf = acl_json_build(json, NULL);
        char *outbuf = CtpUtil::CtpConvert(acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
//        logger_debug(DEBUG_TEST3, 2, "%s", outbuf);
        logger_error("%s", outbuf);
        CtpUtil::KafkaOrRedis(TOPIC_INPUT_ORDER, outbuf, strlen(outbuf));
        delete[] outbuf;
        acl_vstring_free(buf);
        acl_json_free(json);
    }
}

// 报单录入错误回报
void CustomTradeSpi::OnErrRtnOrderInsert(CThostFtdcInputOrderField *pInputOrder, CThostFtdcRspInfoField *pRspInfo)
{

}

// 报单通知
void CustomTradeSpi::OnRtnOrder(CThostFtdcOrderField *pOrder)
{
    if (pOrder != NULL)
    {
        if (isTradingOrder(pOrder)) {
            logger("--->>> %s, %s 等待成交中！, 状态: %c", pOrder->InvestorID, pOrder->InstrumentID, pOrder->OrderStatus);
            //reqOrderAction(pOrder); // 这里可以撤单
            //reqUserLogout(); // 登出测试
        } else if ((pOrder->OrderStatus == THOST_FTDC_OST_Canceled) &&
                   (pOrder->OrderSubmitStatus == THOST_FTDC_OSS_Accepted)) {
            logger("--->>> %s, %s 撤单成功！, 状态: %c", pOrder->InvestorID, pOrder->InstrumentID, pOrder->OrderStatus);
        } else if ((pOrder->OrderStatus == THOST_FTDC_OST_Canceled) &&
                   (pOrder->OrderSubmitStatus == THOST_FTDC_OSS_InsertRejected)) {
            logger("%s, %s 交易所拒单", pOrder->InvestorID, pOrder->InstrumentID);
        }

//    logger("=====请求查询交易所响应=====");
        string OrderPriceType(1, pOrder->OrderPriceType);
        string Direction(1, pOrder->Direction);
        string TimeCondition(1, pOrder->TimeCondition);
        string VolumeCondition(1, pOrder->VolumeCondition);
        string ContingentCondition(1, pOrder->ContingentCondition);
        string ForceCloseReason(1, pOrder->ForceCloseReason);
        string OrderSubmitStatus(1, pOrder->OrderSubmitStatus);
        string OrderSource(1, pOrder->OrderSource);
        string OrderStatus(1, pOrder->OrderStatus);
        string OrderType(1, pOrder->OrderType);
        ACL_JSON* json = acl_json_alloc();
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "BrokerID", pOrder->BrokerID));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "InvestorID", pOrder->InvestorID));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "InstrumentID", pOrder->InstrumentID));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "OrderRef", pOrder->OrderRef));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "UserID", pOrder->UserID));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "OrderPriceType", OrderPriceType.c_str()));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "Direction", Direction.c_str()));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "CombOffsetFlag", pOrder->CombOffsetFlag));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "CombHedgeFlag", pOrder->CombHedgeFlag));
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "LimitPrice", pOrder->LimitPrice));
        acl_json_node_add_child(json->root,
                                acl_json_create_int64(json, "VolumeTotalOriginal", pOrder->VolumeTotalOriginal));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "TimeCondition", TimeCondition.c_str()));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "GTDDate", pOrder->GTDDate));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "VolumeCondition", VolumeCondition.c_str()));
        acl_json_node_add_child(json->root,
                                acl_json_create_int64(json, "MinVolume", pOrder->MinVolume));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "ContingentCondition", ContingentCondition.c_str()));
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "StopPrice", pOrder->StopPrice));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "ForceCloseReason", ForceCloseReason.c_str()));
        acl_json_node_add_child(json->root,
                                acl_json_create_int64(json, "IsAutoSuspend", pOrder->IsAutoSuspend));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "BusinessUnit", pOrder->BusinessUnit));
        acl_json_node_add_child(json->root,
                                acl_json_create_int64(json, "RequestID", pOrder->RequestID));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "OrderLocalID", pOrder->OrderLocalID));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "ExchangeID", pOrder->ExchangeID));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "ParticipantID", pOrder->ParticipantID));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "ClientID", pOrder->ClientID));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "ExchangeInstID", pOrder->ExchangeInstID));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "TraderID", pOrder->TraderID));
        acl_json_node_add_child(json->root,
                                acl_json_create_int64(json, "InstallID", pOrder->InstallID));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "OrderSubmitStatus", OrderSubmitStatus.c_str()));
        acl_json_node_add_child(json->root,
                                acl_json_create_int64(json, "NotifySequence", pOrder->NotifySequence));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "TradingDay", pOrder->TradingDay));
        acl_json_node_add_child(json->root,
                                acl_json_create_int64(json, "SettlementID", pOrder->SettlementID));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "OrderSysID", pOrder->OrderSysID));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "OrderSource", OrderSource.c_str()));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "OrderStatus", OrderStatus.c_str()));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "OrderType", OrderType.c_str()));
        acl_json_node_add_child(json->root,
                                acl_json_create_int64(json, "VolumeTraded", pOrder->VolumeTraded));
        acl_json_node_add_child(json->root,
                                acl_json_create_int64(json, "VolumeTotal", pOrder->VolumeTotal));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "InsertDate", pOrder->InsertDate));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "InsertTime", pOrder->InsertTime));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "ActiveTime", pOrder->ActiveTime));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "SuspendTime", pOrder->SuspendTime));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "UpdateTime", pOrder->UpdateTime));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "CancelTime", pOrder->CancelTime));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "ActiveTraderID", pOrder->ActiveTraderID));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "ClearingPartID", pOrder->ClearingPartID));
        acl_json_node_add_child(json->root,
                                acl_json_create_int64(json, "SequenceNo", pOrder->SequenceNo));
        acl_json_node_add_child(json->root,
                                acl_json_create_int64(json, "FrontID", pOrder->FrontID));
        acl_json_node_add_child(json->root,
                                acl_json_create_int64(json, "SessionID", pOrder->SessionID));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "UserProductInfo", pOrder->UserProductInfo));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "StatusMsg", pOrder->StatusMsg));
        acl_json_node_add_child(json->root,
                                acl_json_create_int64(json, "UserForceClose", pOrder->UserForceClose));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "ActiveUserID", pOrder->ActiveUserID));
        acl_json_node_add_child(json->root,
                                acl_json_create_int64(json, "BrokerOrderSeq", pOrder->BrokerOrderSeq));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "RelativeOrderSysID", pOrder->RelativeOrderSysID));
        acl_json_node_add_child(json->root,
                                acl_json_create_int64(json, "ZCETotalTradedVolume", pOrder->ZCETotalTradedVolume));
        acl_json_node_add_child(json->root,
                                acl_json_create_int64(json, "IsSwapOrder", pOrder->IsSwapOrder));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "BranchID", pOrder->BranchID));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "InvestUnitID", pOrder->InvestUnitID));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "AccountID", pOrder->AccountID));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "CurrencyID", pOrder->CurrencyID));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "IPAddress", pOrder->IPAddress));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "MacAddress", pOrder->MacAddress));
        ACL_VSTRING* buf = acl_json_build(json, NULL);
        char *outbuf = CtpUtil::CtpConvert(acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
        logger_debug(DEBUG_TEST3, 2, "%s", outbuf);
        CtpUtil::KafkaOrRedis(TOPIC_ORDER, outbuf, strlen(outbuf));
        delete[] outbuf;
        acl_vstring_free(buf);
        acl_json_free(json);
    }
}

///成交通知
void CustomTradeSpi::OnRtnTrade(CThostFtdcTradeField *pTrade)
{
    if (pTrade != NULL)
    {
        logger("%s %s =====报单成交=====", pTrade->InvestorID, pTrade->InstrumentID);
        string Direction(1, pTrade->Direction);
        string TradingRole(1, pTrade->TradingRole);
        string OffsetFlag(1, pTrade->OffsetFlag);
        string HedgeFlag(1, pTrade->HedgeFlag);
        string TradeType(1, pTrade->TradeType);
        string PriceSource(1, pTrade->PriceSource);
        string TradeSource(1, pTrade->TradeSource);
        ACL_JSON* json = acl_json_alloc();
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "BrokerID", pTrade->BrokerID));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "InvestorID", pTrade->InvestorID));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "InstrumentID", pTrade->InstrumentID));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "OrderRef", pTrade->OrderRef));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "UserID", pTrade->UserID));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "ExchangeID", pTrade->ExchangeID));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "TradeID", pTrade->TradeID));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "Direction", Direction.c_str()));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "OrderSysID", pTrade->OrderSysID));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "ParticipantID", pTrade->ParticipantID));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "ClientID", pTrade->ClientID));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "TradingRole", TradingRole.c_str()));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "ExchangeInstID", pTrade->ExchangeInstID));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "OffsetFlag", OffsetFlag.c_str()));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "HedgeFlag", HedgeFlag.c_str()));
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "Price", pTrade->Price));
        acl_json_node_add_child(json->root,
                                acl_json_create_int64(json, "Volume", pTrade->Volume));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "TradeDate", pTrade->TradeDate));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "TradeTime", pTrade->TradeTime));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "TradeType", TradeType.c_str()));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "PriceSource", PriceSource.c_str()));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "TraderID", pTrade->TraderID));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "OrderLocalID", pTrade->OrderLocalID));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "ClearingPartID", pTrade->ClearingPartID));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "BusinessUnit", pTrade->BusinessUnit));
        acl_json_node_add_child(json->root,
                                acl_json_create_int64(json, "SequenceNo", pTrade->SequenceNo));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "TradingDay", pTrade->TradingDay));
        acl_json_node_add_child(json->root,
                                acl_json_create_int64(json, "SettlementID", pTrade->SettlementID));
        acl_json_node_add_child(json->root,
                                acl_json_create_int64(json, "BrokerOrderSeq", pTrade->BrokerOrderSeq));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "TradeSource", TradeSource.c_str()));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "InvestUnitID", pTrade->InvestUnitID));

        ACL_VSTRING* buf = acl_json_build(json, NULL);
        char *outbuf = CtpUtil::CtpConvert(acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
        logger_debug(DEBUG_TEST3, 2, "%s", outbuf);
        CtpUtil::KafkaOrRedis(TOPIC_TRADE, outbuf, strlen(outbuf));
        delete[] outbuf;
        acl_vstring_free(buf);
        acl_json_free(json);

        //
//#if defined(OPENCTP) || CTP
//        this->reqQryInvestorPositionDetail(pTrade->InstrumentID, pTrade->ExchangeID);
//#endif
    }
}


/// 撤单
int CustomTradeSpi::reqOrderAction(const char *frontID, const char *orderRef, const char *sessionId,
                                   const char *instrumentID, const char* ExchangeID)
{
//    static bool orderActionSentFlag = false; // 是否发送了报单
//    if (orderActionSentFlag)
//        return;

    logger_debug(DEBUG_TEST2, 1, "frontID=%s,orderRef=%s,sessionId=%s,instrumentID=%s",frontID,orderRef,sessionId,instrumentID);
    CThostFtdcInputOrderActionField orderActionReq;
    memset(&orderActionReq, 0, sizeof(orderActionReq));
    ///经纪公司代码
    const char *BrokerID = m_pAccount->getBrokerID();
    strcpy(orderActionReq.BrokerID, BrokerID);
    ///投资者代码
    strcpy(orderActionReq.InvestorID, m_pAccount->getInvesterID());
    ///报单引用
    strcpy(orderActionReq.OrderRef, orderRef);
    ///前置编号
    orderActionReq.FrontID = atoi(frontID);
    ///会话编号
    orderActionReq.SessionID = atoi(sessionId);
    ///交易所代码
    if (ExchangeID != NULL)
    {
        strcpy(orderActionReq.ExchangeID, ExchangeID);
    }
    ///报单编号
    //	TThostFtdcOrderSysIDType	OrderSysID;
    ///操作标志
    orderActionReq.ActionFlag = THOST_FTDC_AF_Delete;
    ///用户代码
    strcpy(orderActionReq.UserID, m_pAccount->getInvesterID());
    ///合约代码
    strcpy(orderActionReq.InstrumentID, instrumentID);
    static int nRequestID = 0; // 请求编号
    int rt = m_pTradeUserApi->ReqOrderAction(&orderActionReq, ++nRequestID);
    if (!rt)
        logger(">>>>>>发送报单操作请求成功");
    else
        logger_error("--->>>发送报单操作请求失败, errorCode: %d", rt);
//    orderActionSentFlag = true;
    return rt;
}

// 报单操作请求响应
void CustomTradeSpi::OnRspOrderAction(
        CThostFtdcInputOrderActionField *pInputOrderAction,
        CThostFtdcRspInfoField *pRspInfo,
        int nRequestID,
        bool bIsLast)
{
    logger("OnRspOrderAction 错误响应");
    bool bResult = pRspInfo && (pRspInfo->ErrorID != 0);
    if (bResult) {
        ACL_JSON* json = acl_json_alloc();
        acl_json_node_add_child(json->root,
                                acl_json_create_int64(json, "ErrorID", pRspInfo->ErrorID));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "ErrorMsg", pRspInfo->ErrorMsg));

        if (NULL != pInputOrderAction)
        {
            string ActionFlag(1, pInputOrderAction->ActionFlag);
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "BrokerID", pInputOrderAction->BrokerID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "InvestorID", pInputOrderAction->InvestorID));

            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "OrderActionRef", pInputOrderAction->OrderActionRef));
            cout << "orderref=" << pInputOrderAction->OrderRef << endl;
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "OrderRef", pInputOrderAction->OrderRef));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "RequestID", pInputOrderAction->RequestID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "FrontID", pInputOrderAction->FrontID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "SessionID", pInputOrderAction->SessionID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ExchangeID", pInputOrderAction->ExchangeID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "OrderSysID", pInputOrderAction->OrderSysID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ActionFlag", ActionFlag.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "LimitPrice", pInputOrderAction->LimitPrice));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "VolumeChange", pInputOrderAction->VolumeChange));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "UserID", pInputOrderAction->UserID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "InstrumentID", pInputOrderAction->InstrumentID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "InvestUnitID", pInputOrderAction->InvestUnitID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "IPAddress", pInputOrderAction->IPAddress));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "MacAddress", pInputOrderAction->MacAddress));
        }

        ACL_VSTRING* buf = acl_json_build(json, NULL);
        char *outbuf = CtpUtil::CtpConvert(acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
        logger_debug(DEBUG_TEST3, 2, "%s", outbuf);
        CtpUtil::KafkaOrRedis(TOPIC_INPUT_ORDER_ACTION, outbuf, strlen(outbuf));
        delete[] outbuf;
        acl_vstring_free(buf);
        acl_json_free(json);
    }
}

// 报单操作错误回报
void CustomTradeSpi::OnErrRtnOrderAction(CThostFtdcOrderActionField *pOrderAction, CThostFtdcRspInfoField *pRspInfo)
{
    bool bResult = pRspInfo && (pRspInfo->ErrorID != 0);
    if (bResult) {
        ACL_JSON *json = acl_json_alloc();
        acl_json_node_add_child(json->root,
                                acl_json_create_int64(json, "ErrorMsg", pRspInfo->ErrorID));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "ErrorMsg", pRspInfo->ErrorMsg));

        if (pOrderAction != NULL) {
            string ActionFlag(1, pOrderAction->ActionFlag);
            string OrderActionStatus(1, pOrderAction->OrderActionStatus);
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "BrokerID", pOrderAction->BrokerID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "InvestorID", pOrderAction->InvestorID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "OrderActionRef", pOrderAction->OrderActionRef));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "OrderRef", pOrderAction->OrderRef));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "RequestID", pOrderAction->RequestID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "FrontID", pOrderAction->FrontID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "SessionID", pOrderAction->SessionID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ExchangeID", pOrderAction->ExchangeID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "OrderSysID", pOrderAction->OrderSysID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ActionFlag", ActionFlag.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "LimitPrice", pOrderAction->LimitPrice));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "VolumeChange", pOrderAction->VolumeChange));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ActionDate", pOrderAction->ActionDate));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ActionTime", pOrderAction->ActionTime));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "TraderID", pOrderAction->TraderID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "InstallID", pOrderAction->InstallID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "OrderLocalID", pOrderAction->OrderLocalID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ActionLocalID", pOrderAction->ActionLocalID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ParticipantID", pOrderAction->ParticipantID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ClientID", pOrderAction->ClientID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "BusinessUnit", pOrderAction->BusinessUnit));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "OrderActionStatus", OrderActionStatus.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "UserID", pOrderAction->UserID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "StatusMsg", pOrderAction->StatusMsg));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "InstrumentID", pOrderAction->InstrumentID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "BranchID", pOrderAction->BranchID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "InvestUnitID", pOrderAction->InvestUnitID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "IPAddress", pOrderAction->IPAddress));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "MacAddress", pOrderAction->MacAddress));
        }
        ACL_VSTRING *buf = acl_json_build(json, NULL);
        char *outbuf = CtpUtil::CtpConvert(acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
        logger_debug(DEBUG_TEST3, 2, "%s", outbuf);
        CtpUtil::KafkaOrRedis(TOPIC_ORDER_ACTION, outbuf, strlen(outbuf));
        delete[] outbuf;
        acl_vstring_free(buf);
        acl_json_free(json);
    }
}

///保证金率和手续费率查询

// 查询合约保证金率
int CustomTradeSpi::reqQryInstrumentMarginRate(const char *HedgeFlag, const char *InstrumentID)
{
    logger_debug(DEBUG_TEST2, 1, "HedgeFlag=%s", HedgeFlag);
    CThostFtdcQryInstrumentMarginRateField instrumentMarginRateReq;
    memset(&instrumentMarginRateReq, 0, sizeof(instrumentMarginRateReq));
    strcpy(instrumentMarginRateReq.BrokerID, m_pAccount->getBrokerID());
    strcpy(instrumentMarginRateReq.InvestorID, m_pAccount->getInvesterID());
    instrumentMarginRateReq.HedgeFlag = HedgeFlag[0];
    if (InstrumentID != NULL) {
        logger_debug(DEBUG_TEST2, 1, "InstrumentID=%s", InstrumentID);
        strcpy(instrumentMarginRateReq.InstrumentID, InstrumentID);
    }

    int rt = m_pTradeUserApi->ReqQryInstrumentMarginRate(&instrumentMarginRateReq, 0);
    if(rt == 0) {
        logger(">>>>>>查询合约保证金率请求成功");
    } else if(rt == -1) {
        logger_error(">>>>>>网络连接失败");
    } else if(rt == -2) {
        logger_error(">>>>>>未处理请求超过许可数");
    } else if(rt == -3) {
        logger_error(">>>>>>每秒发送请求数超过许可数");
    }
    return rt;
}

// 请求查询合约保证金率响应
void CustomTradeSpi::OnRspQryInstrumentMarginRate(CThostFtdcInstrumentMarginRateField *pInstrumentMarginRate, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast)
{
    logger_debug(DEBUG_TEST3, 1, "=====查询合约保证金率响应=====");
    if (bIsLast)
    {
        logger("查询结束");
//        return;
    }

    if (!isErrorRspInfo(pRspInfo)) {
        if (NULL != pInstrumentMarginRate) {
            ACL_JSON* json = acl_json_alloc();
            string InvestorRange(1, pInstrumentMarginRate->InvestorRange);
            string HedgeFlag(1, pInstrumentMarginRate->HedgeFlag);
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "InstrumentID", pInstrumentMarginRate->InstrumentID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "InvestorRange", InvestorRange.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "BrokerID", pInstrumentMarginRate->BrokerID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "InvestorID", pInstrumentMarginRate->InvestorID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "HedgeFlag", HedgeFlag.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "LongMarginRatioByMoney", pInstrumentMarginRate->LongMarginRatioByMoney));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "LongMarginRatioByVolume", pInstrumentMarginRate->LongMarginRatioByVolume));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "ShortMarginRatioByMoney", pInstrumentMarginRate->ShortMarginRatioByMoney));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "ShortMarginRatioByVolume", pInstrumentMarginRate->ShortMarginRatioByVolume));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "IsRelative", pInstrumentMarginRate->IsRelative));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ExchangeID", pInstrumentMarginRate->ExchangeID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "InvestUnitID", pInstrumentMarginRate->InvestUnitID));
            ACL_VSTRING* buf = acl_json_build(json, NULL);
            logger_debug(DEBUG_TEST3, 2, "%s", acl_vstring_str(buf));
            CtpUtil::KafkaOrRedis(TOPIC_INSTRUMENT_MARGIN_RATE, acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
            acl_vstring_free(buf);
            acl_json_free(json);
        }
    }
}

// 查询手续费率
// 查询合约手续费率
int CustomTradeSpi::reqQryInstrumentCommissionRate(const char *InstrumentID, const char *ExchangeID)
{
    CThostFtdcQryInstrumentCommissionRateField commissionRateReq;
    memset(&commissionRateReq, 0, sizeof(commissionRateReq));
    strcpy(commissionRateReq.BrokerID, m_pAccount->getBrokerID());
    strcpy(commissionRateReq.InvestorID, m_pAccount->getInvesterID());
    if (InstrumentID != NULL) {
        strcpy(commissionRateReq.InstrumentID, InstrumentID);
        logger_debug(DEBUG_TEST2, 1, "InstrumentID=%s", InstrumentID);
    }
    if (ExchangeID != NULL) {
        strcpy(commissionRateReq.ExchangeID, ExchangeID);
        logger_debug(DEBUG_TEST2, 1, "ExchangeID=%s", ExchangeID);
    }
    int rt = m_pTradeUserApi->ReqQryInstrumentCommissionRate(&commissionRateReq, 0);
    if(rt == 0) {
        logger(">>>>>>查询合约手续费率请求成功");
    } else if(rt == -1) {
        logger_error(">>>>>>网络连接失败");
    } else if(rt == -2) {
        logger_error(">>>>>>未处理请求超过许可数");
    } else if(rt == -3) {
        logger_error(">>>>>>每秒发送请求数超过许可数");
    }
    return rt;
}

// 请求查询合约手续费率响应
void CustomTradeSpi::OnRspQryInstrumentCommissionRate(CThostFtdcInstrumentCommissionRateField *pInstrumentCommissionRate, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast)
{
    logger_debug(DEBUG_TEST3, 1, "=====请求查询合约手续费率响应=====");
    if (bIsLast) {
        logger("查询结束");
//        return;
    }
    if (!isErrorRspInfo(pRspInfo)) {
        if (pInstrumentCommissionRate != NULL) {
            // 开仓手续费 手续费 = 成交数量*（成交价*合约乘数*OpenRatioByMoney+OpenRatioByVolume）
            ACL_JSON* json = acl_json_alloc();
            string InvestorRange(1, pInstrumentCommissionRate->InvestorRange);
            string BizType(1, pInstrumentCommissionRate->BizType);
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "InstrumentID", pInstrumentCommissionRate->InstrumentID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "InvestorRange", InvestorRange.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "BrokerID", pInstrumentCommissionRate->BrokerID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "InvestorID", pInstrumentCommissionRate->InvestorID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "OpenRatioByMoney", pInstrumentCommissionRate->OpenRatioByMoney));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "OpenRatioByVolume", pInstrumentCommissionRate->OpenRatioByVolume));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "CloseRatioByMoney", pInstrumentCommissionRate->CloseRatioByMoney));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "CloseRatioByVolume", pInstrumentCommissionRate->CloseRatioByVolume));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "CloseTodayRatioByMoney", pInstrumentCommissionRate->CloseTodayRatioByMoney));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "CloseTodayRatioByVolume", pInstrumentCommissionRate->CloseTodayRatioByVolume));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "BizType", BizType.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ExchangeID", pInstrumentCommissionRate->ExchangeID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "InvestUnitID", pInstrumentCommissionRate->InvestUnitID));
            ACL_VSTRING* buf = acl_json_build(json, NULL);
            logger_debug(DEBUG_TEST3, 2, "%s", acl_vstring_str(buf));
            CtpUtil::KafkaOrRedis(TOPIC_INSTRUMENT_COMMISSION_RATE, acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
            acl_vstring_free(buf);
            acl_json_free(json);
        }
    }
}

// 查询报单申报手续费（就是每报撤一次单子都会收一笔费用），目前来说这是中金所特有的
int CustomTradeSpi::reqQryInstrumentOrderCommRate(const char *InstrumentID)
{
    CThostFtdcQryInstrumentOrderCommRateField orderCommRateReq;
    memset(&orderCommRateReq, 0, sizeof(orderCommRateReq));
    strcpy(orderCommRateReq.BrokerID, m_pAccount->getBrokerID());
    strcpy(orderCommRateReq.InvestorID, m_pAccount->getInvesterID());
    if (InstrumentID != NULL) {
        strcpy(orderCommRateReq.InstrumentID, InstrumentID);
        logger_debug(DEBUG_TEST2, 1, "InstrumentID=%s", InstrumentID);
    }

    int rt = m_pTradeUserApi->ReqQryInstrumentOrderCommRate(&orderCommRateReq, 0);
    if(rt == 0) {
        logger(">>>>>>发送查询报单手续费率(中金所持有)请求成功");
    } else if(rt == -1) {
        logger_error(">>>>>>网络连接失败");
    } else if(rt == -2) {
        logger_error(">>>>>>未处理请求超过许可数");
    } else if(rt == -3) {
        logger_error(">>>>>>每秒发送请求数超过许可数");
    }
    return rt;
}

// 请求查询报单手续费响应
void CustomTradeSpi::OnRspQryInstrumentOrderCommRate(CThostFtdcInstrumentOrderCommRateField *pInstrumentOrderCommRate, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast)
{
    logger_debug(DEBUG_TEST3, 1, "=====查询报单手续费响应=====");
    if (bIsLast) {
        logger("查询结束");
//        return;
    }
    if (!isErrorRspInfo(pRspInfo)) {
        if (pInstrumentOrderCommRate != NULL) {
            ACL_JSON* json = acl_json_alloc();
            string InvestorRange(1, pInstrumentOrderCommRate->InvestorRange);
            string HedgeFlag(1, pInstrumentOrderCommRate->HedgeFlag);
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "InstrumentID", pInstrumentOrderCommRate->InstrumentID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "InvestorRange", InvestorRange.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "BrokerID", pInstrumentOrderCommRate->BrokerID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "InvestorID", pInstrumentOrderCommRate->InvestorID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "HedgeFlag", HedgeFlag.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "OrderCommByVolume", pInstrumentOrderCommRate->OrderCommByVolume));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "OrderActionCommByVolume", pInstrumentOrderCommRate->OrderActionCommByVolume));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ExchangeID", pInstrumentOrderCommRate->ExchangeID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "InvestUnitID", pInstrumentOrderCommRate->InvestUnitID));
            ACL_VSTRING* buf = acl_json_build(json, NULL);
            logger_debug(DEBUG_TEST3, 2, "%s", acl_vstring_str(buf));
            CtpUtil::KafkaOrRedis(TOPIC_INSTRUMENT_ORDER_COMMRATE, acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
            acl_vstring_free(buf);
            acl_json_free(json);
        }
    }
}

// 请求查询交易所保证金率
void CustomTradeSpi::reqQryExchangeMarginRate()
{

}

// 请求查询交易所调整保证金率
void CustomTradeSpi::reqQryExchangeMarginRateAdjust()
{

}

// 请求查询经纪公司交易参数
int CustomTradeSpi::reqQryBrokerTradingParams()
{
    CThostFtdcQryBrokerTradingParamsField req;
    memset(&req, 0, sizeof(req));
    strcpy(req.BrokerID, m_pAccount->getBrokerID());
    strcpy(req.InvestorID, m_pAccount->getInvesterID());
//    strcpy(req.CurrencyID, "CNY");

    int rt = m_pTradeUserApi->ReqQryBrokerTradingParams(&req, 0);
    if(rt == 0) {
        logger(">>>>>>发送查询经纪公司交易参数请求成功");
    } else if(rt == -1) {
        logger_error(">>>>>>网络连接失败");
    } else if(rt == -2) {
        logger_error(">>>>>>未处理请求超过许可数");
    } else if(rt == -3) {
        logger_error(">>>>>>每秒发送请求数超过许可数");
    }
    return rt;
}

///请求查询经纪公司交易参数响应
void CustomTradeSpi::OnRspQryBrokerTradingParams(CThostFtdcBrokerTradingParamsField *pBrokerTradingParams,
        CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast)
{
    if (pBrokerTradingParams != NULL) {
        if (!isErrorRspInfo(pRspInfo)) {
            logger_debug(DEBUG_TEST3, 1,"=====请求查询经纪公司交易参数响应=====");
            string MarginPriceType(1, pBrokerTradingParams->MarginPriceType);
            string Algorithm(1, pBrokerTradingParams->Algorithm);
            string AvailIncludeCloseProfit(1, pBrokerTradingParams->AvailIncludeCloseProfit);
            string OptionRoyaltyPriceType(1, pBrokerTradingParams->OptionRoyaltyPriceType);
            ACL_JSON *json = acl_json_alloc();
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "BrokerID", pBrokerTradingParams->BrokerID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "InvestorID", pBrokerTradingParams->InvestorID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "MarginPriceType", MarginPriceType.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "AvailIncludeCloseProfit", AvailIncludeCloseProfit.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "Algorithm", Algorithm.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "OptionRoyaltyPriceType", OptionRoyaltyPriceType.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "AccountID", pBrokerTradingParams->AccountID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "CurrencyID", pBrokerTradingParams->CurrencyID));
            ACL_VSTRING *buf = acl_json_build(json, NULL);
            logger_debug(DEBUG_TEST3, 2, "%s", acl_vstring_str(buf));
            CtpUtil::KafkaOrRedis(TOPIC_BROKER_TRADING_PARAMS, acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
            acl_vstring_free(buf);
            acl_json_free(json);
        }
    }
}


// 请求查询合约
int CustomTradeSpi::reqQryInstrument(const char *InstrumentID, const char *ExchangeID)
{
    CThostFtdcQryInstrumentField instrumentReq;
    memset(&instrumentReq, 0, sizeof(instrumentReq));
    if (InstrumentID != NULL) {
        strcpy(instrumentReq.InstrumentID, InstrumentID);
    }
    if (ExchangeID != NULL) {
        strcpy(instrumentReq.ExchangeID, ExchangeID);
    }
    static int nRequestID = 0; // 请求编号
    int rt = m_pTradeUserApi->ReqQryInstrument(&instrumentReq, nRequestID);
    if (!rt)
        logger(">>>>>>发送合约查询请求成功");
    else
        logger_error("--->>>发送合约查询请求失败. errorCode= %d", rt);

    return rt;
}

// 请求查询合约响应
void CustomTradeSpi::OnRspQryInstrument(
        CThostFtdcInstrumentField *pInstrument,
        CThostFtdcRspInfoField *pRspInfo,
        int nRequestID,
        bool bIsLast)
{
    if (bIsLast)
    {
        logger("查询结束");
//        return;
    }

    if (pInstrument != NULL) {
        if (!isErrorRspInfo(pRspInfo)) {
            logger_debug(DEBUG_TEST3, 1,"=====请求查询合约响应=====");
            string PositionType(1, pInstrument->PositionType);
            string PositionDateType(1, pInstrument->PositionDateType);
            string CombinationType(1, pInstrument->CombinationType);
            string OptionsType(1, pInstrument->OptionsType);
            string MaxMarginSideAlgorithm(1, pInstrument->MaxMarginSideAlgorithm);
            string InstLifePhase(1, pInstrument->InstLifePhase);
            string ProductClass(1, pInstrument->ProductClass);
            ACL_JSON *json = acl_json_alloc();

            // 多头保证金率
            if (pInstrument->LongMarginRatio > DOUBLE_MAX_VALUE) // 如果服务器传过来的数据无效，数值为 1.79769e+308
            {
                acl_json_node_add_child(json->root,
                                        acl_json_create_double(json, "LongMarginRatio", NULL)); // 填 NULL
            }
            else // 否则，正常处理
            {
                acl_json_node_add_child(json->root,
                                        acl_json_create_double(json, "LongMarginRatio", pInstrument->LongMarginRatio));
            }
            // 空头保证金率
            if (pInstrument->ShortMarginRatio > DOUBLE_MAX_VALUE) // 如果服务器传过来的数据无效，数值为 1.79769e+308
            {
                acl_json_node_add_child(json->root,
                                        acl_json_create_double(json, "ShortMarginRatio", NULL)); // 填 NULL
            }
            else // 否则，正常处理
            {
                acl_json_node_add_child(json->root,
                                        acl_json_create_double(json, "ShortMarginRatio", pInstrument->ShortMarginRatio));
            }
            // 合约基础商品乘数
            if (pInstrument->UnderlyingMultiple > DOUBLE_MAX_VALUE) // 如果服务器传过来的数据无效，数值为 1.79769e+308
            {
                acl_json_node_add_child(json->root,
                                        acl_json_create_double(json, "UnderlyingMultiple", NULL)); // 填 0
            }
            else // 否则，正常处理
            {
                acl_json_node_add_child(json->root,
                                        acl_json_create_double(json, "UnderlyingMultiple", pInstrument->UnderlyingMultiple));
            }
            // 执行价
            if (pInstrument->StrikePrice > DOUBLE_MAX_VALUE) // 如果服务器传过来的数据无效，数值为 1.79769e+308
            {
                acl_json_node_add_child(json->root,
                                        acl_json_create_double(json, "StrikePrice", NULL)); // 填 0
            }
            else // 否则，正常处理
            {
                acl_json_node_add_child(json->root,
                                        acl_json_create_double(json, "StrikePrice", pInstrument->StrikePrice));
            }
            // 合约基础商品乘数
            if (pInstrument->UnderlyingMultiple > DOUBLE_MAX_VALUE) // 如果服务器传过来的数据无效，数值为 1.79769e+308
            {
                acl_json_node_add_child(json->root,
                                        acl_json_create_double(json, "UnderlyingMultiple", NULL)); // 填 0
            }
            else // 否则，正常处理
            {
                acl_json_node_add_child(json->root,
                                        acl_json_create_double(json, "UnderlyingMultiple", pInstrument->UnderlyingMultiple));
            }
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "InstrumentID", pInstrument->InstrumentID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ExchangeID", pInstrument->ExchangeID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "InstrumentName", pInstrument->InstrumentName));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ExchangeInstID", pInstrument->ExchangeInstID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ProductID", pInstrument->ProductID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ProductClass", ProductClass.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "DeliveryYear", pInstrument->DeliveryYear));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "DeliveryMonth", pInstrument->DeliveryMonth));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "MaxMarketOrderVolume",
                                                          pInstrument->MaxMarketOrderVolume));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "MinMarketOrderVolume",
                                                          pInstrument->MinMarketOrderVolume));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "MaxLimitOrderVolume",
                                                          pInstrument->MaxLimitOrderVolume));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "MinLimitOrderVolume",
                                                          pInstrument->MinLimitOrderVolume));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "VolumeMultiple", pInstrument->VolumeMultiple));
            ostringstream oss;
            // 设置精度为10
            oss.precision(10);
            oss << pInstrument->PriceTick;
            string PriceTick_Str = oss.str();
//            cout << PriceTick_Str << endl;
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "PriceTick", PriceTick_Str.c_str()));
//            acl_json_node_add_child(json->root,
//                                    acl_json_create_int64(json, "PriceTick", pInstrument->PriceTick));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "CreateDate", pInstrument->CreateDate));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "OpenDate", pInstrument->OpenDate));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ExpireDate", pInstrument->ExpireDate));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "StartDelivDate", pInstrument->StartDelivDate));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "EndDelivDate", pInstrument->EndDelivDate));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "InstLifePhase", InstLifePhase.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "IsTrading", pInstrument->IsTrading));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "PositionType", PositionType.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "PositionDateType", PositionDateType.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "MaxMarginSideAlgorithm",
                                                         MaxMarginSideAlgorithm.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "UnderlyingInstrID", pInstrument->UnderlyingInstrID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "OptionsType", OptionsType.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "CombinationType", CombinationType.c_str()));
            ACL_VSTRING *buf = acl_json_build(json, NULL);
            char *outbuf = CtpUtil::CtpConvert(acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
            logger_debug(DEBUG_TEST3, 2, "%s", outbuf);
            CtpUtil::KafkaOrRedis(TOPIC_INSTRUMENT, outbuf, strlen(outbuf));
            delete[] outbuf;
            acl_vstring_free(buf);
            acl_json_free(json);
        }
    }
}


///持仓的查询与更新
// 请求查询投资者持仓, 对于非上期/能源的交易所，合约的昨仓YdPosition和今仓TodayPosition在一条记录里面，而上期/能源是分成了两条记录
int CustomTradeSpi::reqQryInvestorPosition()
{
    CThostFtdcQryInvestorPositionField postionReq;
    memset(&postionReq, 0, sizeof(postionReq));
    // 选填
    strcpy(postionReq.BrokerID, m_pAccount->getBrokerID());
    strcpy(postionReq.InvestorID, m_pAccount->getInvesterID());
//    strcpy(postionReq.InstrumentID, g_pTradeInstrumentID);
    static int nRequestID = 0; // 请求编号
//    this_thread::sleep_for(chrono::milliseconds(700)); // 有时候需要停顿一会才能查询成功
    int rt = m_pTradeUserApi->ReqQryInvestorPosition(&postionReq, nRequestID);
    if (!rt)
        logger(">>>>>>发送投资者持仓查询请求成功");
    else
        logger_error("--->>>发送投资者持仓查询请求失败, errorCode= %d", rt);
    return rt;
}

// 请求查询投资者持仓响应
void CustomTradeSpi::OnRspQryInvestorPosition(
        CThostFtdcInvestorPositionField *pInvestorPosition,
        CThostFtdcRspInfoField *pRspInfo,
        int nRequestID,
        bool bIsLast)
{
    if (bIsLast)
    {
        logger("查询结束");
//        return;
    }
    if (!isErrorRspInfo(pRspInfo))
    {
        if (pInvestorPosition != NULL)
        {
             logger_debug(DEBUG_TEST3, 1, "=====查询投资者持仓成功=====");
             string PosiDirection(1, pInvestorPosition->PosiDirection);
             string HedgeFlag(1, pInvestorPosition->HedgeFlag);
             string PositionDate(1, pInvestorPosition->PositionDate);
             ACL_JSON* json = acl_json_alloc();
             acl_json_node_add_child(json->root,
                                     acl_json_create_text(json, "InstrumentID", pInvestorPosition->InstrumentID));
             acl_json_node_add_child(json->root,
                                     acl_json_create_text(json, "BrokerID", pInvestorPosition->BrokerID));
             acl_json_node_add_child(json->root,
                                     acl_json_create_text(json, "InvestorID", pInvestorPosition->InvestorID));
             acl_json_node_add_child(json->root,
                                     acl_json_create_text(json, "PosiDirection", PosiDirection.c_str()));
             acl_json_node_add_child(json->root,
                                     acl_json_create_text(json, "HedgeFlag", HedgeFlag.c_str()));
             acl_json_node_add_child(json->root,
                                     acl_json_create_text(json, "PositionDate", PositionDate.c_str()));
             acl_json_node_add_child(json->root,
                                     acl_json_create_int64(json, "YdPosition", pInvestorPosition->YdPosition));
             acl_json_node_add_child(json->root,
                                     acl_json_create_int64(json, "Position", pInvestorPosition->Position));
             acl_json_node_add_child(json->root,
                                     acl_json_create_int64(json, "LongFrozen", pInvestorPosition->LongFrozen));
             acl_json_node_add_child(json->root,
                                     acl_json_create_int64(json, "ShortFrozen", pInvestorPosition->ShortFrozen));
             acl_json_node_add_child(json->root,
                                     acl_json_create_double(json, "LongFrozenAmount", pInvestorPosition->LongFrozenAmount));
             acl_json_node_add_child(json->root,
                                     acl_json_create_double(json, "ShortFrozenAmount", pInvestorPosition->ShortFrozenAmount));
             acl_json_node_add_child(json->root,
                                     acl_json_create_double(json, "OpenVolume", pInvestorPosition->OpenVolume));
             acl_json_node_add_child(json->root,
                                     acl_json_create_double(json, "CloseVolume", pInvestorPosition->CloseVolume));
             acl_json_node_add_child(json->root,
                                     acl_json_create_int64(json, "OpenAmount", pInvestorPosition->OpenAmount));
             acl_json_node_add_child(json->root,
                                     acl_json_create_int64(json, "CloseAmount", pInvestorPosition->CloseAmount));
             acl_json_node_add_child(json->root,
                                     acl_json_create_double(json, "PositionCost", pInvestorPosition->PositionCost));
             acl_json_node_add_child(json->root,
                                     acl_json_create_double(json, "PreMargin", pInvestorPosition->PreMargin));
             acl_json_node_add_child(json->root,
                                     acl_json_create_double(json, "UseMargin", pInvestorPosition->UseMargin));
             acl_json_node_add_child(json->root,
                                     acl_json_create_double(json, "FrozenMargin", pInvestorPosition->FrozenMargin));
             acl_json_node_add_child(json->root,
                                     acl_json_create_double(json, "FrozenCash", pInvestorPosition->FrozenCash));
             acl_json_node_add_child(json->root,
                                     acl_json_create_double(json, "FrozenCommission", pInvestorPosition->FrozenCommission));
             acl_json_node_add_child(json->root,
                                     acl_json_create_double(json, "CashIn", pInvestorPosition->CashIn));
             acl_json_node_add_child(json->root,
                                     acl_json_create_double(json, "Commission", pInvestorPosition->Commission));
             acl_json_node_add_child(json->root,
                                     acl_json_create_double(json, "CloseProfit", pInvestorPosition->CloseProfit));
             acl_json_node_add_child(json->root,
                                     acl_json_create_double(json, "PositionProfit", pInvestorPosition->PositionProfit));
             acl_json_node_add_child(json->root,
                                     acl_json_create_double(json, "PreSettlementPrice", pInvestorPosition->PreSettlementPrice));
             acl_json_node_add_child(json->root,
                                     acl_json_create_double(json, "SettlementPrice", pInvestorPosition->SettlementPrice));
             acl_json_node_add_child(json->root,
                                     acl_json_create_text(json, "TradingDay", pInvestorPosition->TradingDay));
             acl_json_node_add_child(json->root,
                                     acl_json_create_int64(json, "SettlementID", pInvestorPosition->SettlementID));
             acl_json_node_add_child(json->root,
                                     acl_json_create_double(json, "OpenCost", pInvestorPosition->OpenCost));
             acl_json_node_add_child(json->root,
                                     acl_json_create_double(json, "ExchangeMargin", pInvestorPosition->ExchangeMargin));
             acl_json_node_add_child(json->root,
                                     acl_json_create_int64(json, "CombPosition", pInvestorPosition->CombPosition));
             acl_json_node_add_child(json->root,
                                     acl_json_create_int64(json, "CombLongFrozen", pInvestorPosition->CombLongFrozen));
             acl_json_node_add_child(json->root,
                                     acl_json_create_int64(json, "CombShortFrozen", pInvestorPosition->CombShortFrozen));
             acl_json_node_add_child(json->root,
                                     acl_json_create_double(json, "CloseProfitByDate", pInvestorPosition->CloseProfitByDate));
             acl_json_node_add_child(json->root,
                                     acl_json_create_double(json, "CloseProfitByTrade", pInvestorPosition->CloseProfitByTrade));
             acl_json_node_add_child(json->root,
                                     acl_json_create_int64(json, "TodayPosition", pInvestorPosition->TodayPosition));
             acl_json_node_add_child(json->root,
                                     acl_json_create_double(json, "MarginRateByMoney", pInvestorPosition->MarginRateByMoney));
             acl_json_node_add_child(json->root,
                                     acl_json_create_double(json, "MarginRateByVolume", pInvestorPosition->MarginRateByVolume));
             acl_json_node_add_child(json->root,
                                     acl_json_create_double(json, "StrikeFrozen", pInvestorPosition->StrikeFrozen));
             acl_json_node_add_child(json->root,
                                     acl_json_create_double(json, "StrikeFrozenAmount", pInvestorPosition->StrikeFrozenAmount));
             acl_json_node_add_child(json->root,
                                     acl_json_create_int64(json, "AbandonFrozen", pInvestorPosition->AbandonFrozen));
             acl_json_node_add_child(json->root,
                                     acl_json_create_text(json, "ExchangeID", pInvestorPosition->ExchangeID));
             acl_json_node_add_child(json->root,
                                     acl_json_create_int64(json, "YdStrikeFrozen", pInvestorPosition->YdStrikeFrozen));
             acl_json_node_add_child(json->root,
                                     acl_json_create_text(json, "InvestUnitID", pInvestorPosition->InvestUnitID));
             acl_json_node_add_child(json->root,
                                     acl_json_create_double(json, "PositionCostOffset", pInvestorPosition->PositionCostOffset));
             acl_json_node_add_child(json->root,
                                     acl_json_create_int64(json, "TasPosition", pInvestorPosition->TasPosition));
             acl_json_node_add_child(json->root,
                                     acl_json_create_double(json, "TasPositionCost", pInvestorPosition->TasPositionCost));
             ACL_VSTRING* buf = acl_json_build(json, NULL);
             logger_debug(DEBUG_TEST3, 2, "%s", acl_vstring_str(buf));
             CtpUtil::KafkaOrRedis(TOPIC_INVESTOR_POSITION, acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
             acl_vstring_free(buf);
             acl_json_free(json);
        }
    }
}

// 请求查询投资者持仓明细
int CustomTradeSpi::reqQryInvestorPositionDetail(const char *ExchangeID, const char *InstrumentID)
{
    CThostFtdcQryInvestorPositionDetailField positionDetailReq;
    memset(&positionDetailReq, 0, sizeof(positionDetailReq));
    strcpy(positionDetailReq.BrokerID, m_pAccount->getBrokerID());
    strcpy(positionDetailReq.InvestorID, m_pAccount->getInvesterID());
    if (ExchangeID != NULL)
    {
        logger_debug(DEBUG_TEST2, 1, "ExchangeID=%s", ExchangeID);
        strcpy(positionDetailReq.ExchangeID, ExchangeID);
    }
    if (InstrumentID != NULL)
    {
        logger_debug(DEBUG_TEST2, 1, "InstrumentID=%s", InstrumentID);
        strcpy(positionDetailReq.InstrumentID, InstrumentID);
    }
    int rt = m_pTradeUserApi->ReqQryInvestorPositionDetail(&positionDetailReq, 0);
    if (!rt)
        logger(">>>>>>发送投资者持仓明细查询请求成功");
    else
        logger_error("--->>>发送投资者持仓明细查询请求失败, errorCode= %d", rt);
    return rt;
}

void CustomTradeSpi::OnRspQryInvestorPositionDetail(
        CThostFtdcInvestorPositionDetailField *pInvestorPositionDetail,
        CThostFtdcRspInfoField *pRspInfo,
        int nRequestID,
        bool bIsLast)
{
    if (bIsLast)
    {
        logger("查询结束");
//        return;
    }

    if (!isErrorRspInfo(pRspInfo)) {
        if (pInvestorPositionDetail != NULL) {
            if (pInvestorPositionDetail->CloseVolume > 0) {
                logger_debug(DEBUG_TEST3, 1, "=====平仓记录=====");
            }

            logger_debug(DEBUG_TEST3, 1, "=====持仓明细=====");
            string HedgeFlag(1, pInvestorPositionDetail->HedgeFlag);
            string Direction(1, pInvestorPositionDetail->Direction);
            string TradeType(1, pInvestorPositionDetail->TradeType);
            string SpecPosiType(1, pInvestorPositionDetail->SpecPosiType);
            ACL_JSON* json = acl_json_alloc();
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "InstrumentID", pInvestorPositionDetail->InstrumentID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "BrokerID", pInvestorPositionDetail->BrokerID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "InvestorID", pInvestorPositionDetail->InvestorID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "HedgeFlag", HedgeFlag.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "Direction",Direction.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "OpenDate",pInvestorPositionDetail->OpenDate));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "TradeID", pInvestorPositionDetail->TradeID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "Volume", pInvestorPositionDetail->Volume));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "OpenPrice", pInvestorPositionDetail->OpenPrice));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "TradingDay", pInvestorPositionDetail->TradingDay));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "SettlementID", pInvestorPositionDetail->SettlementID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "TradeType", TradeType.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "CombInstrumentID", pInvestorPositionDetail->CombInstrumentID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ExchangeID", pInvestorPositionDetail->ExchangeID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "CloseProfitByDate", pInvestorPositionDetail->CloseProfitByDate));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "CloseProfitByTrade", pInvestorPositionDetail->CloseProfitByTrade));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "PositionProfitByDate", pInvestorPositionDetail->PositionProfitByDate));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "PositionProfitByTrade", pInvestorPositionDetail->PositionProfitByTrade));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "Margin", pInvestorPositionDetail->Margin));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "ExchMargin", pInvestorPositionDetail->ExchMargin));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "MarginRateByMoney", pInvestorPositionDetail->MarginRateByMoney));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "MarginRateByVolume", pInvestorPositionDetail->MarginRateByVolume));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "LastSettlementPrice", pInvestorPositionDetail->LastSettlementPrice));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "SettlementPrice", pInvestorPositionDetail->SettlementPrice));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "CloseVolume", pInvestorPositionDetail->CloseVolume));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "CloseAmount", pInvestorPositionDetail->CloseAmount));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "TimeFirstVolume", pInvestorPositionDetail->TimeFirstVolume));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "InvestUnitID", pInvestorPositionDetail->InvestUnitID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "SpecPosiType", SpecPosiType.c_str()));
            ACL_VSTRING* buf = acl_json_build(json, NULL);
            logger_debug(DEBUG_TEST3, 2, "%s", acl_vstring_str(buf));
            CtpUtil::KafkaOrRedis(TOPIC_INVESTOR_POSITION_DETAIL, acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
            acl_vstring_free(buf);
            acl_json_free(json);
        }
    }
}



// 请求查询资金帐户
int CustomTradeSpi::reqQryTradingAccount()
{
    CThostFtdcQryTradingAccountField tradingAccountReq;
    memset(&tradingAccountReq, 0, sizeof(tradingAccountReq));
    strcpy(tradingAccountReq.BrokerID, m_pAccount->getBrokerID());
    strcpy(tradingAccountReq.InvestorID, m_pAccount->getInvesterID());

    static int nRequestID = 0; // 请求编号
//    this_thread::sleep_for(chrono::milliseconds(700)); // 有时候需要停顿一会才能查询成功
    int rt = m_pTradeUserApi->ReqQryTradingAccount(&tradingAccountReq, nRequestID);
    if (!rt) {
        logger(">>>>>>发送投资者资金账户查询请求成功");
    } else if(rt == -1) {
        logger_error(">>>>>>网络连接失败");
    } else if(rt == -2) {
        logger_error(">>>>>>未处理请求超过许可数");
    } else if(rt == -3) {
        logger_error(">>>>>>每秒发送请求数超过许可数");
    }
    return rt;

}


void CustomTradeSpi::OnRspQryTradingAccount(
        CThostFtdcTradingAccountField *pTradingAccount,
        CThostFtdcRspInfoField *pRspInfo,
        int nRequestID,
        bool bIsLast)
{
    if (bIsLast)
    {
        logger("查询结束");
//        return;
    }

    if (pTradingAccount != NULL) {
        if (!isErrorRspInfo(pRspInfo)) {
            logger_debug(DEBUG_TEST3, 1, "%s =====查询投资者资金账户成功=====", pTradingAccount->AccountID);
            string BizType(1, pTradingAccount->BizType);
            ACL_JSON *json = acl_json_alloc();
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "BrokerID", pTradingAccount->BrokerID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "AccountID", pTradingAccount->AccountID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "PreMortgage", pTradingAccount->PreMortgage));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "PreCredit", pTradingAccount->PreCredit));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "PreDeposit", pTradingAccount->PreDeposit));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "PreBalance", pTradingAccount->PreBalance));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "PreMargin", pTradingAccount->PreMargin));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "InterestBase", pTradingAccount->InterestBase));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "Interest", pTradingAccount->Interest));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "Deposit", pTradingAccount->Deposit));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "Withdraw", pTradingAccount->Withdraw));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "FrozenMargin", pTradingAccount->FrozenMargin));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "FrozenCash", pTradingAccount->FrozenCash));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "FrozenCommission",
                                                           pTradingAccount->FrozenCommission));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "CurrMargin", pTradingAccount->CurrMargin));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "CashIn", pTradingAccount->CashIn));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "Commission", pTradingAccount->Commission));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "CloseProfit", pTradingAccount->CloseProfit));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "PositionProfit", pTradingAccount->PositionProfit));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "Balance", pTradingAccount->Balance));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "Available", pTradingAccount->Available));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "WithdrawQuota", pTradingAccount->WithdrawQuota));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "Reserve", pTradingAccount->Reserve));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "TradingDay", pTradingAccount->TradingDay));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "SettlementID", pTradingAccount->SettlementID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "Credit", pTradingAccount->Credit));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "Mortgage", pTradingAccount->Mortgage));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "ExchangeMargin", pTradingAccount->ExchangeMargin));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "DeliveryMargin", pTradingAccount->DeliveryMargin));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "ExchangeDeliveryMargin",
                                                           pTradingAccount->ExchangeDeliveryMargin));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "ReserveBalance", pTradingAccount->ReserveBalance));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "CurrencyID", pTradingAccount->CurrencyID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "PreFundMortgageIn",
                                                           pTradingAccount->PreFundMortgageIn));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "PreFundMortgageOut",
                                                           pTradingAccount->PreFundMortgageOut));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "FundMortgageIn", pTradingAccount->FundMortgageIn));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "FundMortgageOut", pTradingAccount->FundMortgageOut));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "FundMortgageAvailable",
                                                           pTradingAccount->FundMortgageAvailable));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "MortgageableFund",
                                                           pTradingAccount->MortgageableFund));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "SpecProductMargin",
                                                           pTradingAccount->SpecProductMargin));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "SpecProductFrozenMargin",
                                                           pTradingAccount->SpecProductFrozenMargin));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "SpecProductCommission",
                                                           pTradingAccount->SpecProductCommission));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "SpecProductFrozenCommission",
                                                           pTradingAccount->SpecProductFrozenCommission));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "SpecProductPositionProfit",
                                                           pTradingAccount->SpecProductPositionProfit));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "SpecProductCloseProfit",
                                                           pTradingAccount->SpecProductCloseProfit));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "SpecProductPositionProfitByAlg",
                                                           pTradingAccount->SpecProductPositionProfitByAlg));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "SpecProductExchangeMargin",
                                                           pTradingAccount->SpecProductExchangeMargin));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "BizType", BizType.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "FrozenSwap", pTradingAccount->FrozenSwap));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "RemainSwap", pTradingAccount->RemainSwap));
            ACL_VSTRING *buf = acl_json_build(json, NULL);
            logger_debug(DEBUG_TEST3, 2, "%s", acl_vstring_str(buf));
            CtpUtil::KafkaOrRedis(TOPIC_TRADING_ACCOUNT, acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
            acl_vstring_free(buf);
            acl_json_free(json);
        }
    }
}



///请求查询报单与成交
// 请求查询报单
int CustomTradeSpi::reqQryOrder()
{
    CThostFtdcQryOrderField orderReq;
    memset(&orderReq, 0, sizeof(orderReq));
    strcpy(orderReq.BrokerID, m_pAccount->getBrokerID());
    strcpy(orderReq.InvestorID, m_pAccount->getInvesterID());
    // 交易所
    int rt = m_pTradeUserApi->ReqQryOrder(&orderReq, 0);
    if(rt == 0) {
        logger(">>>>>>发送查询报单请求成功");
    } else if(rt == -1) {
        logger_error(">>>>>>网络连接失败");
    } else if(rt == -2) {
        logger_error(">>>>>>未处理请求超过许可数");
    } else if(rt == -3) {
        logger_error(">>>>>>每秒发送请求数超过许可数");
    }
    return rt;
}

// 请求查询报单响应
void CustomTradeSpi::OnRspQryOrder(CThostFtdcOrderField *pOrder, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast)
{
    if (bIsLast)
    {
        logger("查询结束");
//        return;
    }

    if (pOrder != NULL) {
        if (!isErrorRspInfo(pRspInfo)) {
            logger_debug(DEBUG_TEST3, 1, "%s =====请求查询报单响应=====", pOrder->InvestorID);
            string OrderPriceType(1, pOrder->OrderPriceType);
            string Direction(1, pOrder->Direction);
            string TimeCondition(1, pOrder->TimeCondition);
            string VolumeCondition(1, pOrder->VolumeCondition);
            string ContingentCondition(1, pOrder->ContingentCondition);
            string ForceCloseReason(1, pOrder->ForceCloseReason);
            string OrderSubmitStatus(1, pOrder->OrderSubmitStatus);
            string OrderSource(1, pOrder->OrderSource);
            string OrderStatus(1, pOrder->OrderStatus);
            string OrderType(1, pOrder->OrderType);
            ACL_JSON* json = acl_json_alloc();
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "BrokerID", pOrder->BrokerID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "InvestorID", pOrder->InvestorID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "InstrumentID", pOrder->InstrumentID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "OrderRef", pOrder->OrderRef));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "UserID", pOrder->UserID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "OrderPriceType", OrderPriceType.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "Direction", Direction.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "CombOffsetFlag", pOrder->CombOffsetFlag));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "CombHedgeFlag", pOrder->CombHedgeFlag));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "LimitPrice", pOrder->LimitPrice));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "VolumeTotalOriginal", pOrder->VolumeTotalOriginal));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "TimeCondition", TimeCondition.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "GTDDate", pOrder->GTDDate));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "VolumeCondition", VolumeCondition.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "MinVolume", pOrder->MinVolume));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ContingentCondition", ContingentCondition.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "StopPrice", pOrder->StopPrice));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ForceCloseReason", ForceCloseReason.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "IsAutoSuspend", pOrder->IsAutoSuspend));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "BusinessUnit", pOrder->BusinessUnit));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "RequestID", pOrder->RequestID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "OrderLocalID", pOrder->OrderLocalID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ExchangeID", pOrder->ExchangeID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ParticipantID", pOrder->ParticipantID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ClientID", pOrder->ClientID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ExchangeInstID", pOrder->ExchangeInstID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "TraderID", pOrder->TraderID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "InstallID", pOrder->InstallID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "OrderSubmitStatus", OrderSubmitStatus.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "NotifySequence", pOrder->NotifySequence));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "TradingDay", pOrder->TradingDay));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "SettlementID", pOrder->SettlementID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "OrderSysID", pOrder->OrderSysID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "OrderSource", OrderSource.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "OrderStatus", OrderStatus.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "OrderType", OrderType.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "VolumeTraded", pOrder->VolumeTraded));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "VolumeTotal", pOrder->VolumeTotal));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "InsertDate", pOrder->InsertDate));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "InsertTime", pOrder->InsertTime));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ActiveTime", pOrder->ActiveTime));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "SuspendTime", pOrder->SuspendTime));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "UpdateTime", pOrder->UpdateTime));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "CancelTime", pOrder->CancelTime));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ActiveTraderID", pOrder->ActiveTraderID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ClearingPartID", pOrder->ClearingPartID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "SequenceNo", pOrder->SequenceNo));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "FrontID", pOrder->FrontID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "SessionID", pOrder->SessionID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "UserProductInfo", pOrder->UserProductInfo));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "StatusMsg", pOrder->StatusMsg));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "UserForceClose", pOrder->UserForceClose));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ActiveUserID", pOrder->ActiveUserID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "BrokerOrderSeq", pOrder->BrokerOrderSeq));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "RelativeOrderSysID", pOrder->RelativeOrderSysID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "ZCETotalTradedVolume", pOrder->ZCETotalTradedVolume));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "IsSwapOrder", pOrder->IsSwapOrder));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "BranchID", pOrder->BranchID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "InvestUnitID", pOrder->InvestUnitID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "AccountID", pOrder->AccountID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "CurrencyID", pOrder->CurrencyID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "IPAddress", pOrder->IPAddress));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "MacAddress", pOrder->MacAddress));
            ACL_VSTRING* buf = acl_json_build(json, NULL);
            char *outbuf = CtpUtil::CtpConvert(acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
            logger_debug(DEBUG_TEST3, 2, "%s", outbuf);
            CtpUtil::KafkaOrRedis(TOPIC_ORDER, outbuf, strlen(outbuf));
            delete[] outbuf;
            acl_vstring_free(buf);
            acl_json_free(json);
        }
    }
}

// 请求查询成交
int CustomTradeSpi::reqQryTrade()
{
    CThostFtdcQryTradeField tradeReq;
    memset(&tradeReq, 0, sizeof(tradeReq));
    strcpy(tradeReq.BrokerID, m_pAccount->getBrokerID());
    strcpy(tradeReq.InvestorID, m_pAccount->getInvesterID());
    // 交易所
    int rt = m_pTradeUserApi->ReqQryTrade(&tradeReq, 0);
    if(rt == 0) {
        logger(">>>>>>发送查询成交请求成功");
    } else if(rt == -1) {
        logger_error(">>>>>>网络连接失败");
    } else if(rt == -2) {
        logger_error(">>>>>>未处理请求超过许可数");
    } else if(rt == -3) {
        logger_error(">>>>>>每秒发送请求数超过许可数");
    }
    return rt;
}

// 请求查询成交响应
void CustomTradeSpi::OnRspQryTrade(CThostFtdcTradeField *pTrade, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast)
{
    if (bIsLast)
    {
        logger("查询结束");
//        return;
    }

    if (!isErrorRspInfo(pRspInfo)) {
        if (pTrade != NULL) {
            //  开仓手续费 = 成交数量*（成交价*合约乘数*OpenRatioByMoney+OpenRatioByVolume）
            logger_debug(DEBUG_TEST3, 1, "%s =====请求查询成交响应=====", pTrade->InvestorID);
            string Direction(1, pTrade->Direction);
            string TradingRole(1, pTrade->TradingRole);
            string OffsetFlag(1, pTrade->OffsetFlag);
            string HedgeFlag(1, pTrade->HedgeFlag);
            string TradeType(1, pTrade->TradeType);
            string PriceSource(1, pTrade->PriceSource);
            string TradeSource(1, pTrade->TradeSource);
            ACL_JSON* json = acl_json_alloc();
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "BrokerID", pTrade->BrokerID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "InvestorID", pTrade->InvestorID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "InstrumentID", pTrade->InstrumentID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "OrderRef", pTrade->OrderRef));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "UserID", pTrade->UserID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ExchangeID", pTrade->ExchangeID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "TradeID", pTrade->TradeID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "Direction", Direction.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "OrderSysID", pTrade->OrderSysID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ParticipantID", pTrade->ParticipantID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ClientID", pTrade->ClientID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "TradingRole", TradingRole.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ExchangeInstID", pTrade->ExchangeInstID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "OffsetFlag", OffsetFlag.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "HedgeFlag", HedgeFlag.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "Price", pTrade->Price));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "Volume", pTrade->Volume));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "TradeDate", pTrade->TradeDate));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "TradeTime", pTrade->TradeTime));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "TradeType", TradeType.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "PriceSource", PriceSource.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "TraderID", pTrade->TraderID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "OrderLocalID", pTrade->OrderLocalID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ClearingPartID", pTrade->ClearingPartID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "BusinessUnit", pTrade->BusinessUnit));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "SequenceNo", pTrade->SequenceNo));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "TradingDay", pTrade->TradingDay));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "SettlementID", pTrade->SettlementID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "BrokerOrderSeq", pTrade->BrokerOrderSeq));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "TradeSource", TradeSource.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "InvestUnitID", pTrade->InvestUnitID));
            ACL_VSTRING* buf = acl_json_build(json, NULL);
            logger_debug(DEBUG_TEST3, 2, "%s", acl_vstring_str(buf));
            CtpUtil::KafkaOrRedis(TOPIC_TRADE, acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
            acl_vstring_free(buf);
            acl_json_free(json);
        }
    }
}


// 查询最大保报单数量
void CustomTradeSpi::reqQueryMaxOrderVolume()
{
//    CThostFtdcQueryMaxOrderVolumeField maxOrderVolumeReq;
//    memset(&maxOrderVolumeReq, 0, sizeof(maxOrderVolumeReq));
//    strcpy(maxOrderVolumeReq.BrokerID, m_pAccount->getBrokerID());
//    strcpy(maxOrderVolumeReq.InvestorID, m_pAccount->getInvesterID());
//    int rt = m_pTradeUserApi->ReqQueryMaxOrderVolume(&maxOrderVolumeReq, 0);
//    if(rt == 0) {
//        logger(">>>>>>发送查询交易所请求成功");
//    } else if(rt == -1) {
//        logger(">>>>>>网络连接失败");
//    } else if(rt == -2) {
//        logger(">>>>>>未处理请求超过许可数");
//    } else if(rt == -3) {
//        logger(">>>>>>每秒发送请求数超过许可数");
//    }
}

// 请求查询行情
int CustomTradeSpi::reqQryDepthMarketData(const char *InstrumentID)
{
    CThostFtdcQryDepthMarketDataField depthMarketDataReq;
    memset(&depthMarketDataReq, 0, sizeof(depthMarketDataReq));
    strcpy(depthMarketDataReq.InstrumentID, InstrumentID);

    int rt = m_pTradeUserApi->ReqQryDepthMarketData(&depthMarketDataReq, 0);
    if(rt == 0) {
        logger(">>>>>>发送查询行情请求成功");
    } else if(rt == -1) {
        logger_error(">>>>>>网络连接失败");
    } else if(rt == -2) {
        logger_error(">>>>>>未处理请求超过许可数");
    } else if(rt == -3) {
        logger_error(">>>>>>每秒发送请求数超过许可数");
    }
    return rt;
}

void CustomTradeSpi::OnRspQryDepthMarketData(CThostFtdcDepthMarketDataField *pDepthMarketData,
                                             CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast)
{
    if (!isErrorRspInfo(pRspInfo)) {
        if (NULL != pDepthMarketData) {
            ACL_JSON *json = acl_json_alloc();
            // 今开盘
            if (pDepthMarketData->OpenPrice > DOUBLE_MAX_VALUE) // 如果服务器传过来的数据无效，数值为 1.79769e+308
            {
                acl_json_node_add_child(json->root,
                                        acl_json_create_double(json, "OpenPrice", NULL)); // 填 NULL
            } else // 否则，正常处理
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
                                        acl_json_create_double(json, "PreSettlementPrice",
                                                               pDepthMarketData->PreSettlementPrice));
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
                                        acl_json_create_double(json, "UpperLimitPrice",
                                                               pDepthMarketData->UpperLimitPrice));
            }
            // 跌停板价
            if (pDepthMarketData->LowerLimitPrice > DOUBLE_MAX_VALUE) {
                acl_json_node_add_child(json->root,
                                        acl_json_create_double(json, "LowerLimitPrice", NULL));
            } else {
                acl_json_node_add_child(json->root,
                                        acl_json_create_double(json, "LowerLimitPrice",
                                                               pDepthMarketData->LowerLimitPrice));
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
                                        acl_json_create_double(json, "SettlementPrice",
                                                               pDepthMarketData->SettlementPrice));
            }


            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "TradingDay", pDepthMarketData->TradingDay));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "InstrumentID", pDepthMarketData->InstrumentID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ExchangeID", pDepthMarketData->ExchangeID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ExchangeInstID", pDepthMarketData->ExchangeInstID));
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
                                    acl_json_create_double(json, "UpdateMillisec", pDepthMarketData->UpdateMillisec));
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

            ACL_VSTRING *buf = acl_json_build(json, NULL);
            char *outbuf = CtpUtil::CtpConvert(acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
//            logger("%s", outbuf);
            logger_debug(DEBUG_TEST3, 2, "%s", acl_vstring_str(buf));
//            CtpUtil::KafkaOrRedis(TOPIC_TRADE_DEPTH_MARKET_DATA, outbuf, strlen(outbuf));
            CtpUtil::KafkaOrRedis(TOPIC_TRADE_DEPTH_MARKET_DATA, acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
//            delete[] outbuf;
            acl_vstring_free(buf);
            acl_json_free(json);
        }
    }
}

// 请求查询投资者结算结果（可以按要求查前某天、月的结算单）
int CustomTradeSpi::reqQrySettlementInfo(const char *TradingDay)
{
    CThostFtdcQrySettlementInfoField settlementInfoReq;
    memset(&settlementInfoReq, 0, sizeof(settlementInfoReq));
    strcpy(settlementInfoReq.BrokerID, m_pAccount->getBrokerID());
    strcpy(settlementInfoReq.InvestorID, m_pAccount->getInvesterID());
    if (TradingDay != NULL) {
        /// 查询某一天的结算单，填写格式为"yyyymmdd"，查询某一月的结算单，填写格式为"yyyymm"；前提是系统生成了日（月）结算单，否则返回为空
        strcpy(settlementInfoReq.TradingDay, TradingDay);
    }

    int rt = m_pTradeUserApi->ReqQrySettlementInfo(&settlementInfoReq, 0);
    if(rt == 0) {
        logger(">>>>>>发送查询投资者结算结果成功");
    } else if(rt == -1) {
        logger_error(">>>>>>网络连接失败");
    } else if(rt == -2) {
        logger_error(">>>>>>未处理请求超过许可数");
    } else if(rt == -3) {
        logger_error(">>>>>>每秒发送请求数超过许可数");
    }
    return rt;
}

// 请求查询投资者结算结果响应
void CustomTradeSpi::OnRspQrySettlementInfo(CThostFtdcSettlementInfoField *pSettlementInfo,
                                            CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast) {
    if (bIsLast)
    {
        logger("查询结束");
//        return;
    }

    if (!isErrorRspInfo(pRspInfo)) {
        if (pSettlementInfo != NULL) {
            ACL_JSON *json = acl_json_alloc();
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "BrokerID", pSettlementInfo->BrokerID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "InvestorID", pSettlementInfo->InvestorID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "TradingDay", pSettlementInfo->TradingDay));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "SequenceNo", pSettlementInfo->SequenceNo));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "SettlementID", pSettlementInfo->SettlementID));
            // 消息正文 Content是一个长度为501的数组，显然我们的结算单长度往往不止501，
            // 结算单实际是多次回报分段传输的，且第501个字符为'\0'，仅用于占位，这并不代表字符串结束
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "Content", pSettlementInfo->Content));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "AccountID", pSettlementInfo->AccountID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "CurrencyID", pSettlementInfo->CurrencyID));
            ACL_VSTRING *buf = acl_json_build(json, NULL);
            char *outbuf = CtpUtil::CtpConvert(acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
            logger_debug(DEBUG_TEST3, 2, "%s", outbuf);
//            logger("%s", acl_vstring_str(buf));
//            CtpUtil::KafkaOrRedis(TOPIC_SETTLEMENT_INFO, outbuf, strlen(outbuf));
            delete[] outbuf;
            acl_vstring_free(buf);
            acl_json_free(json);
        }
    }
}

// 投资者结算结果确认（每天登录后交易前必须确认一次）
int CustomTradeSpi::reqSettlementInfoConfirm()
{
    CThostFtdcSettlementInfoConfirmField settlementConfirmReq;
    memset(&settlementConfirmReq, 0, sizeof(settlementConfirmReq));
    strcpy(settlementConfirmReq.BrokerID, m_pAccount->getBrokerID());
    strcpy(settlementConfirmReq.InvestorID, m_pAccount->getInvesterID());
    static int nRequestID = 0; // 请求编号
    int rt = m_pTradeUserApi->ReqSettlementInfoConfirm(&settlementConfirmReq, nRequestID);
    if (!rt)
        logger(">>>>>>发送投资者结算结果确认请求成功");
    else
        logger_error("--->>>发送投资者结算结果确认请求失败, errorCode= %d", rt);
    return rt;
}

// 投资者结算结果确认响应
void CustomTradeSpi::OnRspSettlementInfoConfirm(
        CThostFtdcSettlementInfoConfirmField *pSettlementInfoConfirm,
        CThostFtdcRspInfoField *pRspInfo,
        int nRequestID,
        bool bIsLast)
{
    if (!isErrorRspInfo(pRspInfo))
    {
        if (pSettlementInfoConfirm != NULL)
        {
            ACL_JSON *json = acl_json_alloc();
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "BrokerID", pSettlementInfoConfirm->BrokerID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "InvestorID", pSettlementInfoConfirm->InvestorID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ConfirmDate", pSettlementInfoConfirm->ConfirmDate));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ConfirmTime", pSettlementInfoConfirm->ConfirmTime));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "SettlementID", pSettlementInfoConfirm->SettlementID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "AccountID", pSettlementInfoConfirm->AccountID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "CurrencyID", pSettlementInfoConfirm->CurrencyID));
            ACL_VSTRING *buf = acl_json_build(json, NULL);
            logger("%s", acl_vstring_str(buf));
            acl_vstring_free(buf);
            acl_json_free(json);
        }
    }
}

// 查询结算信息确认 （查询当天是否确认了）
int CustomTradeSpi::reqQrySettlementInfoConfirm()
{
    CThostFtdcQrySettlementInfoConfirmField settlementInfoConfirmReq;
    memset(&settlementInfoConfirmReq, 0, sizeof(settlementInfoConfirmReq));
    strcpy(settlementInfoConfirmReq.BrokerID, m_pAccount->getBrokerID());
    strcpy(settlementInfoConfirmReq.InvestorID, m_pAccount->getInvesterID());
    static int nRequestID = 0; // 请求编号
    int rt = m_pTradeUserApi->ReqQrySettlementInfoConfirm(&settlementInfoConfirmReq, nRequestID);
    if (!rt)
        logger(">>>>>>发送结算信息确认请求成功");
    else
        logger_error("--->>>发送结算信息确认请求失败, errorCode = %d", rt);
    return rt;
}

// 请求查询结算信息确认响应
void CustomTradeSpi::OnRspQrySettlementInfoConfirm(CThostFtdcSettlementInfoConfirmField *pSettlementInfoConfirm,
        CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast) {
    if (!isErrorRspInfo(pRspInfo))
    {
        if (pSettlementInfoConfirm != NULL) {
            ACL_JSON *json = acl_json_alloc();
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "BrokerID", pSettlementInfoConfirm->BrokerID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "InvestorID", pSettlementInfoConfirm->InvestorID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ConfirmDate", pSettlementInfoConfirm->ConfirmDate));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ConfirmTime", pSettlementInfoConfirm->ConfirmTime));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "SettlementID", pSettlementInfoConfirm->SettlementID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "AccountID", pSettlementInfoConfirm->AccountID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "CurrencyID", pSettlementInfoConfirm->CurrencyID));
            ACL_VSTRING *buf = acl_json_build(json, NULL);
//            char *outbuf = CtpUtil::CtpConvert(acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
//            logger("%s", outbuf);
            logger_debug(DEBUG_TEST3, 2, "%s", acl_vstring_str(buf));
//            CtpUtil::KafkaOrRedis(TOPIC_SETTLEMENT_INFO_CONFIRM, outbuf, strlen(outbuf));
//            CtpUtil::KafkaOrRedis(TOPIC_SETTLEMENT_INFO_CONFIRM, acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
//            delete[] outbuf;
            acl_vstring_free(buf);
            acl_json_free(json);

        } else {
            logger_error("未确认前一个交易日的结算信息");
        }
    }
}



// 请求查询投资者
int CustomTradeSpi::reqQryInvestor()
{
    CThostFtdcQryInvestorField investorReq;
    memset(&investorReq, 0, sizeof(investorReq));
    strcpy(investorReq.BrokerID, m_pAccount->getBrokerID());
    strcpy(investorReq.InvestorID, m_pAccount->getInvesterID());
    int rt = m_pTradeUserApi->ReqQryInvestor(&investorReq, 0);
    if(rt == 0) {
        logger(">>>>>>发送查询投资者请求成功");
    } else if(rt == -1) {
        logger_error(">>>>>>网络连接失败");
    } else if(rt == -2) {
        logger_error(">>>>>>未处理请求超过许可数");
    } else if(rt == -3) {
        logger_error(">>>>>>每秒发送请求数超过许可数");
    }
    return rt;
}

// 请求查询投资者响应
void CustomTradeSpi::OnRspQryInvestor(CThostFtdcInvestorField *pInvestor, CThostFtdcRspInfoField *pRspInfo,
                                      int nRequestID, bool bIsLast) {
    if (!isErrorRspInfo(pRspInfo)) {
        if (pInvestor) {
            cout << "投资者代码: " << pInvestor->InvestorID << endl;
            cout << "经纪公司代码: " << pInvestor->BrokerID << endl;
            cout << "投资者名称: " << pInvestor->InvestorName << endl;
            cout << "证件类型: " << pInvestor->IdentifiedCardType << endl;
            cout << "证件号码: " << pInvestor->IdentifiedCardNo << endl;
            cout << "是否活跃: " << pInvestor->IsActive << endl;
            cout << "联系电话: " << pInvestor->Telephone << endl;
            cout << "通讯地址: " << pInvestor->Address << endl;
            cout << "开户日期: " << pInvestor->OpenDate << endl;
            cout << "手机: " << pInvestor->Mobile << endl;
        }
    }
}


// 请求查询交易编号
int CustomTradeSpi::reqQryTradingCode()
{
    CThostFtdcQryTradingCodeField tradingCodeReq;
    memset(&tradingCodeReq, 0, sizeof(tradingCodeReq));
    strcpy(tradingCodeReq.BrokerID, m_pAccount->getBrokerID());
    strcpy(tradingCodeReq.InvestorID, m_pAccount->getInvesterID());
    int rt = m_pTradeUserApi->ReqQryTradingCode(&tradingCodeReq, 0);
    if(rt == 0) {
        logger(">>>>>>发送查询交易编号请求成功");
    } else if(rt == -1) {
        logger_error(">>>>>>网络连接失败");
    } else if(rt == -2) {
        logger_error(">>>>>>未处理请求超过许可数");
    } else if(rt == -3) {
        logger_error(">>>>>>每秒发送请求数超过许可数");
    }
    return rt;
}

// 请求查询交易编码响应
void CustomTradeSpi::OnRspQryTradingCode(CThostFtdcTradingCodeField *pTradingCode, CThostFtdcRspInfoField *pRspInfo,
                                         int nRequestID, bool bIsLast) {
    if (!isErrorRspInfo(pRspInfo)) {
        if (pTradingCode) {

            cout << "=====请求查询交易编码响应======" << endl;
            cout << "投资者代码: " << pTradingCode->InvestorID << endl;
            cout << "经纪公司代码: " << pTradingCode->BrokerID << endl;
            cout << "交易所代码: " << pTradingCode->ExchangeID << endl;
            cout << "客户代码: " << pTradingCode->ClientID << endl;
            cout << "是否活跃: " << pTradingCode->IsActive << endl;
            cout << "交易编码类型: " << pTradingCode->ClientIDType << endl;
            cout << "营业部编号: " << pTradingCode->BranchID << endl;
            cout << "业务类型: " << pTradingCode->BizType << endl;
            cout << "投资单元代码: " << pTradingCode->InvestUnitID << endl;
        }
    }
}

// 请求查询产品
int CustomTradeSpi::reqQryProduct(const char *ProductID, const char *ExchangeID)
{
    CThostFtdcQryProductField productReq;
    memset(&productReq, 0, sizeof(productReq));
    if (ProductID != NULL) {
        strcpy(productReq.ProductID, ProductID);
    }
    if (ExchangeID != NULL) {
        strcpy(productReq.ExchangeID, ExchangeID);
    }
    productReq.ProductClass = THOST_FTDC_PC_Futures;
    int rt = m_pTradeUserApi->ReqQryProduct(&productReq, 0);
    if(rt == 0) {
        logger(">>>>>>发送查询产品请求成功");
    } else if(rt == -1) {
        logger_error(">>>>>>网络连接失败");
    } else if(rt == -2) {
        logger_error(">>>>>>未处理请求超过许可数");
    } else if(rt == -3) {
        logger_error(">>>>>>每秒发送请求数超过许可数");
    }
    return rt;
}

// 请求查询产品响应
void CustomTradeSpi::OnRspQryProduct(CThostFtdcProductField *pProduct, CThostFtdcRspInfoField *pRspInfo, int nRequestID,
                                     bool bIsLast) {
    if (bIsLast)
    {
        logger("查询结束");
//        return;
    }

    if (pProduct != NULL) {
        if (!isErrorRspInfo(pRspInfo)) {
            logger_debug(DEBUG_TEST3, 1, "=====查询产品响应=====");
            string PositionType(1, pProduct->PositionType);
            string PositionDateType(1, pProduct->PositionDateType);
            string CloseDealType(1, pProduct->CloseDealType);
            string MortgageFundUseRange(1, pProduct->MortgageFundUseRange);
            string ProductClass(1, pProduct->ProductClass);
            ACL_JSON *json = acl_json_alloc();
            // 合约基础商品乘数
            if (pProduct->UnderlyingMultiple > DOUBLE_MAX_VALUE) // 如果服务器传过来的数据无效，数值为 1.79769e+308
            {
                acl_json_node_add_child(json->root,
                                        acl_json_create_double(json, "UnderlyingMultiple", NULL)); // 填 NULL
            }
            else // 否则，正常处理
            {
                acl_json_node_add_child(json->root,
                                        acl_json_create_double(json, "UnderlyingMultiple", pProduct->UnderlyingMultiple));
            }
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ProductID", pProduct->ProductID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ProductName", pProduct->ProductName));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ExchangeID", pProduct->ExchangeID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ProductClass", ProductClass.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "VolumeMultiple", pProduct->VolumeMultiple));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "PriceTick", pProduct->PriceTick));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "MaxMarketOrderVolume",
                                                          pProduct->MaxMarketOrderVolume));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "MinMarketOrderVolume",
                                                          pProduct->MinMarketOrderVolume));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "MaxLimitOrderVolume", pProduct->MaxLimitOrderVolume));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "MinLimitOrderVolume", pProduct->MinLimitOrderVolume));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "PositionType", PositionType.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "PositionDateType", PositionDateType.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "CloseDealType", CloseDealType.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "TradeCurrencyID", pProduct->TradeCurrencyID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "MortgageFundUseRange", MortgageFundUseRange.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ExchangeProductID", pProduct->ExchangeProductID));

            ACL_VSTRING *buf = acl_json_build(json, NULL);
            char *outbuf = CtpUtil::CtpConvert(acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
            logger_debug(DEBUG_TEST3, 2, "%s", outbuf);
            CtpUtil::KafkaOrRedis(TOPIC_PRODUCT, outbuf, strlen(outbuf));
            delete[] outbuf;
            acl_vstring_free(buf);
            acl_json_free(json);
        }
    }
}



int CustomTradeSpi::reqUserLogout()
{
    CThostFtdcUserLogoutField logoutReq;
    memset(&logoutReq, 0, sizeof(logoutReq));
    strcpy(logoutReq.BrokerID, m_pAccount->getBrokerID());
    strcpy(logoutReq.UserID, m_pAccount->getInvesterID());
    static int nRequestID = 0; // 请求编号
    int rt = m_pTradeUserApi->ReqUserLogout(&logoutReq, nRequestID);
    if (!rt)
        logger(">>>>>>发送登出请求成功");
    else
        logger_error("--->>>发送登出请求失败");
    m_Event.WaitEvent();
    // 登出就不能再交易了
    m_pTradeUserApi->Release();
//    m_pTradeUserApi = NULL;
    return rt;
}

void CustomTradeSpi::OnRspUserLogout(
        CThostFtdcUserLogoutField *pUserLogout,
        CThostFtdcRspInfoField *pRspInfo,
        int nRequestID,
        bool bIsLast)
{
    if (!isErrorRspInfo(pRspInfo))
    {
        m_bAuthFlag = false;
        m_bLoginFlag = false;
        m_bLogoutFlag = true;
        logger("=====账户登出成功=====");
        logger("经纪商： %s", pUserLogout->BrokerID);
        logger("帐户名： %s", pUserLogout->UserID);
    }
    m_Event.SignalEvent();
}


// 请求查询交易所
int CustomTradeSpi::reqQryExchange(const char *ExchangeID) {
    CThostFtdcQryExchangeField exchangeID = {0};
    if (NULL != ExchangeID) {
        strcpy(exchangeID.ExchangeID, ExchangeID);
    }

    int requestID = 0;
    int rt = m_pTradeUserApi->ReqQryExchange(&exchangeID, requestID);
    if(rt == 0) {
        logger(">>>>>>发送查询交易所请求成功");
    } else if(rt == -1) {
        logger_error(">>>>>>网络连接失败");
    } else if(rt == -2) {
        logger_error(">>>>>>未处理请求超过许可数");
    } else if(rt == -3) {
        logger_error(">>>>>>每秒发送请求数超过许可数");
    }
    return rt;
}

// 请求查询交易所响应
void CustomTradeSpi::OnRspQryExchange(CThostFtdcExchangeField *pExchange, CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast)
{
    if (bIsLast)
    {
        logger("查询结束");
//        return;
    }

    if (pExchange != NULL) {
        if (!isErrorRspInfo(pRspInfo)) {
            logger_debug(DEBUG_TEST2, 1, "=====请求查询交易所响应=====");
            string ExchangeProperty(1, pExchange->ExchangeProperty);
            ACL_JSON *json = acl_json_alloc();
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ExchangeID", pExchange->ExchangeID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ExchangeName", pExchange->ExchangeName));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ExchangeProperty", ExchangeProperty.c_str()));
            ACL_VSTRING *buf = acl_json_build(json, NULL);
            char *outbuf = CtpUtil::CtpConvert(acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
            logger_debug(DEBUG_TEST3, 1, "%s", outbuf);
            CtpUtil::KafkaOrRedis(TOPIC_EXCHANGE, outbuf, strlen(outbuf));
            delete[] outbuf;
            acl_vstring_free(buf);
            acl_json_free(json);
        }
    }
}

// 请求查询预埋单
void CustomTradeSpi::reqQryParkedOrder()
{
    CThostFtdcQryParkedOrderField orderReq;
    memset(&orderReq, 0, sizeof(orderReq));
    strcpy(orderReq.BrokerID, m_pAccount->getBrokerID());
    strcpy(orderReq.InvestorID, m_pAccount->getInvesterID());
    int rt = m_pTradeUserApi->ReqQryParkedOrder(&orderReq, 0);
    if(rt == 0) {
        logger(">>>>>>发送查询预埋单请求成功");
    } else if(rt == -1) {
        logger_error(">>>>>>网络连接失败");
    } else if(rt == -2) {
        logger_error(">>>>>>未处理请求超过许可数");
    } else if(rt == -3) {
        logger_error(">>>>>>每秒发送请求数超过许可数");
    }
}

void CustomTradeSpi::OnRspQryParkedOrder(CThostFtdcParkedOrderField *pParkedOrder, CThostFtdcRspInfoField *pRspInfo,
                                         int nRequestID, bool bIsLast) {
    if (pParkedOrder != NULL) {
        if (!isErrorRspInfo(pRspInfo)) {
            cout << "=====请求查询预埋单响应=====" << endl;
            cout << "合约代码: " << pParkedOrder->InstrumentID << endl;
            cout << "买卖方向: " << pParkedOrder->Direction << endl;
            cout << "开平: " << pParkedOrder->CombOffsetFlag << endl;
            cout << "手数: " << pParkedOrder->VolumeTotalOriginal << endl;
            cout << "报单价: " << pParkedOrder->LimitPrice << endl;
            cout << "GTD日期: " << pParkedOrder->GTDDate << endl;
            cout << "触发条件: " << pParkedOrder->ContingentCondition << endl;
            cout << "报单引用:" << pParkedOrder->OrderRef << endl;
            cout << "预埋报单编号:" << pParkedOrder->ParkedOrderID << endl;
            cout << "预埋单状态:" << pParkedOrder->Status << endl;
        }
    } else {
        logger("预埋单为空");
    }
}

// 请求查询预埋单撤单
void CustomTradeSpi::reqQryParkedOrderAction()
{
    CThostFtdcQryParkedOrderActionField orderReq;
    memset(&orderReq, 0, sizeof(orderReq));
    strcpy(orderReq.BrokerID, m_pAccount->getBrokerID());
    strcpy(orderReq.InvestorID, m_pAccount->getInvesterID());
    int rt = m_pTradeUserApi->ReqQryParkedOrderAction(&orderReq, 0);
    if(rt == 0) {
        logger(">>>>>>发送查询预埋撤单请求成功");
    } else if(rt == -1) {
        logger_error(">>>>>>网络连接失败");
    } else if(rt == -2) {
        logger_error(">>>>>>未处理请求超过许可数");
    } else if(rt == -3) {
        logger_error(">>>>>>每秒发送请求数超过许可数");
    }
}

void CustomTradeSpi::OnRspQryParkedOrderAction(CThostFtdcParkedOrderActionField *pParkedOrderAction,
                                               CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast) {
    if (pParkedOrderAction != NULL) {
        if (!isErrorRspInfo(pRspInfo)) {
            cout << "=====请求查询预埋单撤单响应=====" << endl;
            cout << "合约代码: " << pParkedOrderAction->InstrumentID << endl;
            cout << "报单价: " << pParkedOrderAction->LimitPrice << endl;
            cout << "报单引用:" << pParkedOrderAction->OrderRef << "," << endl;
            cout << "会话编号:" << pParkedOrderAction->SessionID << endl;
            cout << "报单编号:" << pParkedOrderAction->OrderSysID << endl;
        }
    } else {
        logger("预埋单撤单为空");
    }
}

// 预埋单录入请求
void CustomTradeSpi::reqParkedOrderInsert()
{
    TThostFtdcExchangeIDType exchangeId;
    TThostFtdcInstrumentIDType instrumentID;
    TThostFtdcDirectionType side;
    TThostFtdcPriceType limitPrice;
    TThostFtdcCombOffsetFlagType flagType;
    TThostFtdcOrderRefType orderRef;
    logger("请输入要报单的交易所代码(CFFEX、CZCE、DCE、INE、SHFE)");
    cin >> exchangeId;
    logger("请输入要报单的合约代码");
    cin >> instrumentID;
    logger("请输入买卖方向(0->buy 1->sell)");
    cin >> side;
    logger("请输入限价");
    cin >> limitPrice;
    logger("开平(0->开仓 1->平仓/平昨 3->平今)");
    cin >> flagType;
    logger("报单引用(保持递增)");
    cin >> orderRef;

    CThostFtdcParkedOrderField parkedOrderReq;
    memset(&parkedOrderReq, 0, sizeof(parkedOrderReq));
    ///经纪公司代码
    strcpy(parkedOrderReq.BrokerID, m_pAccount->getBrokerID());
    ///投资者代码
    strcpy(parkedOrderReq.InvestorID, m_pAccount->getInvesterID());
    ///用户代码 报单时需填UserID，否则收不到 OnErrRtnOrderInsert 报错，一般客户和InvestorID填写一样就可以
//    strcpy(parkedOrderReq.UserID, m_pAccount->getInvesterID());
    ///交易所代码 全部大写 CFFEX、CZCE、DCE、INE、SHFE
    strcpy(parkedOrderReq.ExchangeID, exchangeId);
    ///合约代码
    strcpy(parkedOrderReq.InstrumentID, instrumentID);
    ///报单引用
    strcpy(parkedOrderReq.OrderRef, orderRef);
    ///报单价格条件: 限价（只有OrderPriceType是限价单的时候需要填写，填写的时候注意价格要是最小报价单位（查询合约可得）的整数倍，否则会被拒单）
    parkedOrderReq.OrderPriceType = THOST_FTDC_OPT_LimitPrice;
    ///买卖方向:
    parkedOrderReq.Direction = side;
    ///组合开平标志: 开仓
    parkedOrderReq.CombOffsetFlag[0] = flagType[0];
    ///组合投机套保标志
    parkedOrderReq.CombHedgeFlag[0] = THOST_FTDC_HF_Speculation;
    ///价格 只有OrderPriceType是限价单的时候需要填写，填写的时候注意价格要是最小变动价位（查询合约可得）的整数倍，否则会被拒单
    parkedOrderReq.LimitPrice = limitPrice;
    ///数量：1
    parkedOrderReq.VolumeTotalOriginal = 1;
    ///有效期类型: 当日有效
    parkedOrderReq.TimeCondition = THOST_FTDC_TC_GFD;
    ///成交量类型: 任何数量
    parkedOrderReq.VolumeCondition = THOST_FTDC_VC_AV;
    ///最小成交量: 1
//    parkedOrderReq.MinVolume = 1;
    ///触发条件: 预埋单
    parkedOrderReq.ContingentCondition = THOST_FTDC_CC_Immediately;
    ///强平原因: 非强平
    parkedOrderReq.ForceCloseReason = THOST_FTDC_FCC_NotForceClose;

    ///以下字段为选填
    ///自动挂起标志: 否
    parkedOrderReq.IsAutoSuspend = 0;
    ///用户强评标志: 否
    parkedOrderReq.UserForceClose = 0;

    static int nRequestID = 0; // 请求编号
    int rt = m_pTradeUserApi->ReqParkedOrderInsert(&parkedOrderReq, ++nRequestID);
    if (!rt)
        logger(">>>>>>发送预埋单录入请求成功");
    else
        logger_error("--->>>发送预埋单录入请求失败");
}


void CustomTradeSpi::OnRspParkedOrderInsert(CThostFtdcParkedOrderField *pParkedOrder, CThostFtdcRspInfoField *pRspInfo,
                                             int nRequestID, bool bIsLast)
{
    if (!isErrorRspInfo(pRspInfo)) {
        if (pParkedOrder != NULL) {
            cout << "=====预埋单录入成功=====" << endl;
            cout << "合约代码:" << pParkedOrder->InstrumentID << endl;
            cout << "预埋报单编号:" << pParkedOrder->ParkedOrderID << endl;
            cout << "预埋单状态:" << pParkedOrder->Status << endl;
        }
    }
}

// 预埋撤单录入请求
void CustomTradeSpi::reqParkedOrderAction()
{
    TThostFtdcExchangeIDType exchangeId;
    TThostFtdcOrderSysIDType orderSysID;
    TThostFtdcInstrumentIDType instrumentID;

    logger("请输入要报单的交易所代码(CFFEX、CZCE、DCE、INE、SHFE)");
    cin >> exchangeId;
    logger("请输入要撤单的报单编号");
    cin >> orderSysID;
    logger("请输入要撤单的合约代码");
    cin >> instrumentID;


    CThostFtdcParkedOrderActionField parkedOrderActionReq;
    memset(&parkedOrderActionReq, 0, sizeof(parkedOrderActionReq));
    ///经纪公司代码
    strcpy(parkedOrderActionReq.BrokerID, m_pAccount->getBrokerID());
    ///投资者代码
    strcpy(parkedOrderActionReq.InvestorID, m_pAccount->getInvesterID());
    ///交易所代码 全部大写 CFFEX、CZCE、DCE、INE、SHFE
    strcpy(parkedOrderActionReq.ExchangeID, exchangeId);
    ///报单操作引用
    //	TThostFtdcOrderActionRefType	OrderActionRef;
    ///报单引用
//    strcpy(parkedOrderActionReq.OrderRef, orderRef);
    ///请求编号
    //	TThostFtdcRequestIDType	RequestID;
    ///前置编号
    parkedOrderActionReq.FrontID = trade_front_id;
    ///会话编号
//    parkedOrderActionReq.SessionID = sessionId;
    ///交易所代码
    //	TThostFtdcExchangeIDType	ExchangeID;
    ///报单编号
    //	TThostFtdcOrderSysIDType	OrderSysID;
    strcpy(parkedOrderActionReq.OrderSysID, orderSysID);
    ///操作标志
    parkedOrderActionReq.ActionFlag = THOST_FTDC_AF_Delete;

    strcpy(parkedOrderActionReq.InstrumentID, instrumentID);
    static int nRequestID = 0; // 请求编号
    int rt = m_pTradeUserApi->ReqParkedOrderAction(&parkedOrderActionReq, ++nRequestID);
    if (!rt)
        logger(">>>>>>发送预埋撤单录入请求成功");
    else
        logger_error("--->>>发送预埋撤单录入请求失败");
}

void  CustomTradeSpi::OnRspParkedOrderAction(CThostFtdcParkedOrderActionField *pParkedOrderAction,
                                             CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast) {
    if (!isErrorRspInfo(pRspInfo)) {
        if (pParkedOrderAction != NULL) {
            cout << "=====预埋撤单操作成功=====" << endl;
            cout << "合约代码:" << pParkedOrderAction->InstrumentID << endl;
            cout << "预埋撤单单编号:" << pParkedOrderAction->ParkedOrderActionID << endl;
            cout << "操作标志:" << pParkedOrderAction->ActionFlag << endl;
        }
    }
}

// 请求删除预埋单
void CustomTradeSpi::reqRemoveParkedOrder()
{
    CThostFtdcRemoveParkedOrderField removeParkedOrderReq;
    memset(&removeParkedOrderReq, 0, sizeof(removeParkedOrderReq));
    ///经纪公司代码
    strcpy(removeParkedOrderReq.BrokerID, m_pAccount->getBrokerID());
    ///投资者代码
    strcpy(removeParkedOrderReq.InvestorID, m_pAccount->getInvesterID());
    strcpy(removeParkedOrderReq.ParkedOrderID, "         178");
    static int nRequestID = 0; // 请求编号
    int rt = m_pTradeUserApi->ReqRemoveParkedOrder(&removeParkedOrderReq, ++nRequestID);
    if (!rt)
        logger(">>>>>>发送删除预埋单操作请求成功");
    else
        logger_error("--->>>发送删除预埋单操作请求失败");
}

void CustomTradeSpi::OnRspRemoveParkedOrder(CThostFtdcRemoveParkedOrderField *pRemoveParkedOrder,
                                            CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast) {
    if (!isErrorRspInfo(pRspInfo)) {
        if (pRemoveParkedOrder != NULL) {
            logger("=====删除预埋单操作成功=====");
            cout << "预埋报单编号： " << pRemoveParkedOrder->ParkedOrderID << endl;
        }
    }
}

// 请求删除预埋撤单
void CustomTradeSpi::reqRemoveParkedOrderAction()
{
    CThostFtdcRemoveParkedOrderActionField removeParkedOrderActionReq;
    memset(&removeParkedOrderActionReq, 0, sizeof(removeParkedOrderActionReq));
    ///经纪公司代码
    strcpy(removeParkedOrderActionReq.BrokerID, m_pAccount->getBrokerID());
    ///投资者代码
    strcpy(removeParkedOrderActionReq.InvestorID, m_pAccount->getInvesterID());
    strcpy(removeParkedOrderActionReq.ParkedOrderActionID, "");
    static int nRequestID = 0; // 请求编号
    int rt = m_pTradeUserApi->ReqRemoveParkedOrderAction(&removeParkedOrderActionReq, ++nRequestID);
    if (!rt)
        logger(">>>>>>发送删除预埋撤单操作请求成功");
    else
        logger_error("--->>>发送删除预埋撤单操作请求失败");
}

void CustomTradeSpi::OnRspRemoveParkedOrderAction(CThostFtdcRemoveParkedOrderActionField *pRemoveParkedOrderAction,
                                                  CThostFtdcRspInfoField *pRspInfo, int nRequestID, bool bIsLast) {
    if (!isErrorRspInfo(pRspInfo)) {
        if (pRemoveParkedOrderAction != NULL) {
            logger("=====删除预埋单操作成功=====");
            cout << "预埋撤单编号： " << pRemoveParkedOrderAction->ParkedOrderActionID << endl;
        }
    }
}

// FrontID + SessionID + OrderRef 确定唯一报单
bool CustomTradeSpi::isMyOrder(CThostFtdcOrderField *pOrder)
{
    cout << "FrontID=" << pOrder->FrontID << "," << trade_front_id << endl;
    cout << "SessionID=" << pOrder->SessionID << "," << session_id << endl;
    cout << "OrderRef=" << pOrder->OrderRef << "," << order_ref << endl;

    return ((pOrder->FrontID == trade_front_id) &&
            (pOrder->SessionID == session_id) &&
            (strcmp(pOrder->OrderRef, order_ref) == 0));
}

bool CustomTradeSpi::isTradingOrder(CThostFtdcOrderField *pOrder)
{
    return ((pOrder->OrderStatus != THOST_FTDC_OST_PartTradedNotQueueing) &&
            (pOrder->OrderStatus != THOST_FTDC_OST_Canceled) &&
            (pOrder->OrderStatus != THOST_FTDC_OST_AllTraded));
}

bool CustomTradeSpi::isErrorRspInfo(CThostFtdcRspInfoField *pRspInfo)
{
    bool bResult = pRspInfo && (pRspInfo->ErrorID != 0);
    if (bResult) {
        ACL_JSON* json = acl_json_alloc();
        acl_json_node_add_child(json->root,
                                acl_json_create_int64(json, "ErrorID", pRspInfo->ErrorID));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "ErrorMsg", pRspInfo->ErrorMsg));
        ACL_VSTRING* buf = acl_json_build(json, NULL);
        char *outbuf = CtpUtil::CtpConvert(acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
        logger("%s", outbuf);
//        CtpUtil::KafkaOrRedis(TOPIC_RSP_INFO, outbuf, strlen(outbuf));
        delete[] outbuf;
        acl_vstring_free(buf);
        acl_json_free(json);
    }
    return bResult;
}

///询价
void CustomTradeSpi::reqQryForQuote() {
    CThostFtdcQryForQuoteField quoteField;
    TThostFtdcTimeType beginDate;
    TThostFtdcTimeType endDate;
//    time_t t = time(0);
//    time_t t2 = t - 30*60*60*24;
//    strftime(beginDate, sizeof(beginDate), "%Y-%m-%d", localtime(&t2));
//    strftime(endDate, sizeof(endDate), "%Y-%m-%d", localtime(&t));
    memset(&quoteField, 0, sizeof(quoteField));
//    strcpy(quoteField.BrokerID, m_pAccount->getBrokerID());
//    strcpy(quoteField.InvestorID, m_pAccount->getInvesterID());
//    strcpy(quoteField.InstrumentID, "ag2016");
//    strcpy(quoteField.ExchangeID, "SHFE");

    strcpy(quoteField.InsertTimeStart, "9:23:23");
    strcpy(quoteField.InsertTimeEnd, "15:46:36");

    int requestID = 0;
    int rt = m_pTradeUserApi->ReqQryForQuote(&quoteField, requestID);
    if(rt == 0) {
        logger(">>>>>>发送查询询价请求成功");
    } else if(rt == -1) {
        logger_error(">>>>>>网络连接失败");
    } else if(rt == -2) {
        logger_error(">>>>>>未处理请求超过许可数");
    } else if(rt == -3) {
        logger_error(">>>>>>每秒发送请求数超过许可数");
    }
}

void CustomTradeSpi::OnRspQryForQuote(CThostFtdcForQuoteField *pForQuote, CThostFtdcRspInfoField *pRspInfo,
                                      int nRequestID, bool bIsLast)
{
    bool bResult = pRspInfo && (pRspInfo->ErrorID != 0);
    if (!bResult) {
        if (pForQuote == NULL) {
            logger("is NULL");
            return;
        }
        cout << "=======请求查询询价响应======" << endl;
        cout << "合约代码: " << pForQuote->InstrumentID << endl;
        cout << "报单日期: " <<pForQuote->InsertDate << endl;
        cout << "插入时间: " <<pForQuote->InsertTime << endl;
    }
}
