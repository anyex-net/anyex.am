//
// Created by root on 8/17/21.
//

#include <thread>
#include <cstring>
#include <acl_cpp/stdlib/log.hpp>
#include <json/acl_json.h>
#include <iostream>
#include "trade/TraderSpi.h"
#include "common/StpUtil.h"

static char *TOPIC_INPUT_ORDER_ACTION = "StpTopicInputOrderAction";
static char *TOPIC_ORDER = "StpTopicOrder";
static char *TOPIC_INPUT_ORDER = "StpTopicInputOrder";
static char *TOPIC_POSITION = "StpTopicPosition";
static char *TOPIC_TRADING_ACCOUNT = "StpTopicTradingAccount";
static char *TOPIC_EXCHANGE = "StpTopicExchange";
static char *TOPIC_TRADE = "StpTopicTrade";
static char *TOPIC_SECURITY = "StpTopicSecurity";
static char *TOPIC_SHAREHOLDER_ACCOUNT = "StpTopicShareholderAccount";
static char *TOPIC_MARKET = "StpTopicMarket";
static char *TOPIC_INVESTOR_ACCOUNT = "StpTopicInvestorAccount";
static char *TOPIC_INVESTOR_TRADING_FEE = "StpTopicInvestorTradingFee";
static char *TOPIC_TRADING_FEE = "StpTopicTradingFee";

TraderSpi::TraderSpi(CTORATstpTraderApi *api,std::shared_ptr<Account> account)
:m_pTraderApi(api),m_pAccount(account)
{
//    memset(&DataTypeConst, 0, sizeof(DataTypeConst));
    InitDataTypeConst();
}

TraderSpi::~TraderSpi()
{

}

//void TraderSpi::setAccount(std::shared_ptr<Account> account)
//{
//    m_pAccount = account;
//}

void TraderSpi::reqUserLogin() {
    CTORATstpReqUserLoginField req;
    memset(&req, 0, sizeof(req));
    strcpy(req.LogInAccount, m_pAccount->getInvestorId().c_str());
    // TORA_TSTP_LACT_UserID
    // TORA_TSTP_LACT_SZAStock
    req.LogInAccountType = TORA_TSTP_LACT_UserID;
    strcpy(req.Password, m_pAccount->getPassword().c_str());
//    req.AuthMode = TORA_TSTP_AM_Password;
    strcpy(req.UserProductInfo, "apidemo");
    strcpy(req.TerminalInfo, this->TerminalInfo.c_str());
//    strcpy(req.DepartmentID, "0001");

    int reqId = 0;
    int ret = m_pTraderApi->ReqUserLogin(&req, reqId);
    std::cout << "ret=" << ret <<std::endl;
    (ret==0)?logger("发送登录请求成功"):((ret==-1)?logger_error("未连接或未登录, 错误码:%d", ret):logger_error("超出流控限制, 错误码:%d", ret));
}

void TraderSpi::TraderThreadReConnFn()
{
    if (NULL == m_pTraderApi) {
        logger_error("m_pTradeUserApi is NULL");
        return;
    }
    m_pTraderApi->ReqGetConnectionInfo(0);
    reqUserLogin();
}

void TraderSpi::OnFrontConnected() {
    logger("建立网络连接成功");
    std::thread thread(&TraderSpi::TraderThreadReConnFn, this);
    thread.detach();
}

void TraderSpi::OnFrontDisconnected(int nReason) {
    logger_error("网络连接断开, 错误码:%d", nReason);
}

void TraderSpi::OnRspError(CTORATstpRspInfoField *pRspInfo, int nRequestID, bool bIsLast) {
    bool bResult = pRspInfo && (pRspInfo->ErrorID != 0);
    if (bResult) {
        char *err_buf = StpUtil::GB18030ToUTF8(pRspInfo->ErrorMsg, sizeof(pRspInfo->ErrorMsg));
        logger_error("ErrorID=%d, ErrorMsg=%s, nRequestID=%d", pRspInfo->ErrorID, err_buf, nRequestID);
        delete[] err_buf;
    }
}

void TraderSpi::OnRspGetConnectionInfo(CTORATstpConnectionInfoField *pConnectionInfoField, CTORATstpRspInfoField *pRspInfoField, int nRequestID) {
    if (pConnectionInfoField != NULL)
    {
        std::cout << pConnectionInfoField->InnerIPAddress << std::endl;
        std::cout << pConnectionInfoField->InnerPort << std::endl;
        std::cout << pConnectionInfoField->OuterIPAddress << std::endl;
        std::cout << pConnectionInfoField->OuterPort << std::endl;
        std::cout << pConnectionInfoField->MacAddress << std::endl;
        this->TerminalInfo.append("IIP=").append(pConnectionInfoField->InnerIPAddress)
                          .append(";IPORT=").append(std::to_string(pConnectionInfoField->InnerPort))
                          .append("OIP=").append(pConnectionInfoField->OuterIPAddress)
                          .append(";OPORT=").append(std::to_string(pConnectionInfoField->OuterPort))
                          .append(";MAC=").append(pConnectionInfoField->MacAddress);
    }
}

void TraderSpi::OnRspUserLogin(CTORATstpRspUserLoginField *pRspUserLoginField, CTORATstpRspInfoField *pRspInfo,
                               int nRequestID) {
    if (!isErrorRspInfo(pRspInfo))
    {
        logger("账户登录成功");
        logger("交易日:%s, 登录时间:%s, 用户代码:%s, 用户类型:%c, 登录账户:%s, 报单流控:%d, 撤单流控:%d",
                pRspUserLoginField->TradingDay,pRspUserLoginField->LoginTime, pRspUserLoginField->UserID,
                pRspUserLoginField->UserType,pRspUserLoginField->LogInAccount, pRspUserLoginField->OrderInsertCommFlux,
                pRspUserLoginField->OrderActionCommFlux);

//        reqQryUser();
//        reqQryInvestor();
//        m_pLoginUserField = *pRspUserLoginField;
//        strcpy(m_pLoginUserField->UserID, pRspUserLoginField->UserID);
        // 保存会话参数

        reqQryOrderFundDetail();
//        reqQryTradingFee(NULL);
    }
}

/// 报单录入
int TraderSpi::reqOrderInsert(const char *SecurityID,const char *ShareholderID,const char *ExchangeID,const char *OrderRef,
                                   const char *Direction,const char *OrderPriceType,const char *LimitPrice,const char* Volume,
                                   const char *SInfo, const char *TimeCondition, const char *VolumeCondition)
{
    logger_debug(DEBUG_TEST2, 1, "ShareholderID=%s,SecurityID=%s,OrderRef=%s,Direction=%s,OrderPriceType=%s,"
                                 "LimitPrice=%s,Volume=%s",
                 ShareholderID,SecurityID,OrderRef,Direction,OrderPriceType,LimitPrice,Volume);
    CTORATstpInputOrderField req;
    memset(&req, 0, sizeof(req));
//    InvestorID 为投资者代码,开发者可填可不填,若填写则必须填写正确,若不填,则交易系统会根据股东账号自动关联投资者
//    strcpy(req.InvestorID, "00318289");
    strcpy(req.SecurityID, SecurityID);
    strcpy(req.ShareholderID, ShareholderID);
    if (OrderRef != NULL)
    {
        req.OrderRef = atoi(OrderRef);
    }
    req.ExchangeID = ExchangeID[0];
    req.OrderPriceType = OrderPriceType[0];
    req.Direction = Direction[0];
    if (LimitPrice != NULL)
    {
        req.LimitPrice = atof(LimitPrice);
    }
    req.VolumeTotalOriginal = atoi(Volume);
    req.TimeCondition = TimeCondition[0];
    req.VolumeCondition = VolumeCondition[0];

    if (SInfo != NULL)
    {
        strcpy(req.SInfo, SInfo);
    }
//    set_null(req.IInfo);
    int rt = m_pTraderApi->ReqOrderInsert(&req, 0);
    if (!rt)
        logger("发送报单录入请求成功");
    else
        logger_error("发送报单录入请求失败, errorCode= %d", rt);
    return rt;
}

// 报单响应
void TraderSpi::OnRspOrderInsert(CTORATstpInputOrderField *pInputOrderField, CTORATstpRspInfoField *pRspInfo, int nRequestID)
{
    logger("报单响应");
    bool bResult = pRspInfo && (pRspInfo->ErrorID != 0);
    // 只返回错误信息
    if (bResult) {
        ACL_JSON* json = acl_json_alloc();
        acl_json_node_add_child(json->root,
                                acl_json_create_int64(json, "ErrorID", pRspInfo->ErrorID));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "ErrorMsg", pRspInfo->ErrorMsg));

        if (pInputOrderField != NULL) {
            std::string OrderPriceType(1, pInputOrderField->OrderPriceType);
            std::string Direction(1, pInputOrderField->Direction);
            std::string TimeCondition(1, pInputOrderField->TimeCondition);
            std::string VolumeCondition(1, pInputOrderField->VolumeCondition);
            std::string ForceCloseReason(1, pInputOrderField->ForceCloseReason);
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "InvestorID", pInputOrderField->InvestorID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "SecurityID", pInputOrderField->SecurityID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "OrderRef", pInputOrderField->OrderRef));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "OrderPriceType", OrderPriceType.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "Direction", Direction.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "LimitPrice", pInputOrderField->LimitPrice));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "VolumeTotalOriginal", pInputOrderField->VolumeTotalOriginal));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "TimeCondition", TimeCondition.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "VolumeCondition", VolumeCondition.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ForceCloseReason", ForceCloseReason.c_str()));
            std::string ExchangeID(1, pInputOrderField->ExchangeID);
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ExchangeID", ExchangeID.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ShareholderID", pInputOrderField->ShareholderID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "BusinessUnitID", pInputOrderField->BusinessUnitID));
            std::string LotType(0, pInputOrderField->LotType);
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "LotType", LotType.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "OrderSysID", pInputOrderField->OrderSysID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "SInfo", pInputOrderField->SInfo));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "IInfo", pInputOrderField->IInfo));
            std::string Operway(0, pInputOrderField->Operway);
            std::string CreditQuotaType(0, pInputOrderField->CreditQuotaType);
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "Operway", Operway.c_str()));
            std::string CondCheck(0, pInputOrderField->CondCheck);
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "CondCheck", CondCheck.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "GTDate", pInputOrderField->GTDate));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "CreditDebtID", pInputOrderField->CreditDebtID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "CreditQuotaType", CreditQuotaType.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "DiscountCouponID", pInputOrderField->DiscountCouponID));
        }

        ACL_VSTRING* buf = acl_json_build(json, NULL);
        char *outbuf = StpUtil::GB18030ToUTF8(acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
        logger("%s", outbuf);
        StpUtil::KafkaOrRedis(TOPIC_INPUT_ORDER, outbuf, strlen(outbuf));
        delete[] outbuf;
        acl_vstring_free(buf);
        acl_json_free(json);
    }
}

void TraderSpi::OnErrRtnOrderInsert(CTORATstpInputOrderField *pInputOrderField, CTORATstpRspInfoField *pRspInfo, int nRequestID) {
//    logger("报单错误响应");
//    bool bResult = pRspInfo && (pRspInfo->ErrorID != 0);
//    ACL_JSON* json = acl_json_alloc();
//    if (bResult) {
//        acl_json_node_add_child(json->root,
//                                acl_json_create_int64(json, "ErrorID", pRspInfo->ErrorID));
//        acl_json_node_add_child(json->root,
//                                acl_json_create_text(json, "ErrorMsg", pRspInfo->ErrorMsg));
//    }
//    if (pInputOrderField != NULL) {
//        std::string OrderPriceType(1, pInputOrderField->OrderPriceType);
//        std::string Direction(1, pInputOrderField->Direction);
//        std::string TimeCondition(1, pInputOrderField->TimeCondition);
//        std::string VolumeCondition(1, pInputOrderField->VolumeCondition);
//        std::string ForceCloseReason(1, pInputOrderField->ForceCloseReason);
//        acl_json_node_add_child(json->root,
//                                acl_json_create_text(json, "InvestorID", pInputOrderField->InvestorID));
//        acl_json_node_add_child(json->root,
//                                acl_json_create_text(json, "SecurityID", pInputOrderField->SecurityID));
//        acl_json_node_add_child(json->root,
//                                acl_json_create_int64(json, "OrderRef", pInputOrderField->OrderRef));
//        acl_json_node_add_child(json->root,
//                                acl_json_create_text(json, "OrderPriceType", OrderPriceType.c_str()));
//        acl_json_node_add_child(json->root,
//                                acl_json_create_text(json, "Direction", Direction.c_str()));
//        acl_json_node_add_child(json->root,
//                                acl_json_create_double(json, "LimitPrice", pInputOrderField->LimitPrice));
//        acl_json_node_add_child(json->root,
//                                acl_json_create_int64(json, "VolumeTotalOriginal", pInputOrderField->VolumeTotalOriginal));
//        acl_json_node_add_child(json->root,
//                                acl_json_create_text(json, "TimeCondition", TimeCondition.c_str()));
//        acl_json_node_add_child(json->root,
//                                acl_json_create_text(json, "VolumeCondition", VolumeCondition.c_str()));
//        acl_json_node_add_child(json->root,
//                                acl_json_create_text(json, "ForceCloseReason", ForceCloseReason.c_str()));
//        std::string ExchangeID(1, pInputOrderField->ExchangeID);
//        acl_json_node_add_child(json->root,
//                                acl_json_create_text(json, "ExchangeID", ExchangeID.c_str()));
//        acl_json_node_add_child(json->root,
//                                acl_json_create_text(json, "ShareholderID", pInputOrderField->ShareholderID));
//        acl_json_node_add_child(json->root,
//                                acl_json_create_text(json, "BusinessUnitID", pInputOrderField->BusinessUnitID));
//        std::string LotType(0, pInputOrderField->LotType);
//        acl_json_node_add_child(json->root,
//                                acl_json_create_text(json, "LotType", LotType.c_str()));
//        acl_json_node_add_child(json->root,
//                                acl_json_create_text(json, "OrderSysID", pInputOrderField->OrderSysID));
//        acl_json_node_add_child(json->root,
//                                acl_json_create_text(json, "SInfo", pInputOrderField->SInfo));
//        acl_json_node_add_child(json->root,
//                                acl_json_create_int64(json, "IInfo", pInputOrderField->IInfo));
//        std::string Operway(0, pInputOrderField->Operway);
//        std::string CreditQuotaType(0, pInputOrderField->CreditQuotaType);
//        acl_json_node_add_child(json->root,
//                                acl_json_create_text(json, "Operway", Operway.c_str()));
//        std::string CondCheck(0, pInputOrderField->CondCheck);
//        acl_json_node_add_child(json->root,
//                                acl_json_create_text(json, "CondCheck", CondCheck.c_str()));
//        acl_json_node_add_child(json->root,
//                                acl_json_create_text(json, "GTDate", pInputOrderField->GTDate));
//        acl_json_node_add_child(json->root,
//                                acl_json_create_text(json, "CreditDebtID", pInputOrderField->CreditDebtID));
//        acl_json_node_add_child(json->root,
//                                acl_json_create_text(json, "CreditQuotaType", CreditQuotaType.c_str()));
//        acl_json_node_add_child(json->root,
//                                acl_json_create_int64(json, "DiscountCouponID", pInputOrderField->DiscountCouponID));
//    }
//
//    ACL_VSTRING* buf = acl_json_build(json, NULL);
//    char *outbuf = StpUtil::GB18030ToUTF8(acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
//    logger("%s", outbuf);
//    StpUtil::KafkaOrRedis(TOPIC_INPUT_ORDER, outbuf, strlen(outbuf));
//    delete[] outbuf;
//    acl_vstring_free(buf);
//    acl_json_free(json);
}

/// 撤单
int TraderSpi::reqOrderAction(const char *ExchangeID,const char *FrontID,const char *SessionID,const char *OrderRef,const char *SInfo)
{
//    logger_debug(DEBUG_TEST2, 1, "");
    CTORATstpInputOrderActionField orderActionReq;
    memset(&orderActionReq, 0, sizeof(orderActionReq));
    orderActionReq.ExchangeID = ExchangeID[0];
    orderActionReq.ActionFlag = TORA_TSTP_AF_Delete;
    orderActionReq.FrontID = atoi(FrontID);
    orderActionReq.SessionID = atoi(SessionID);
    orderActionReq.OrderRef = atoi(OrderRef);
//    strcpy(orderActionReq.OrderSysID, OrderSysID);
    set_null(orderActionReq.IInfo);
    if (SInfo != NULL)
    {
        strcpy(orderActionReq.SInfo, SInfo);
    }
    static int requestID = 0; // 请求编号
    int rt = m_pTraderApi->ReqOrderAction(&orderActionReq, 0);
    if (!rt)
        logger("发送撤单操作请求成功");
    else
        logger_error("发送撤单操作请求失败, errorCode: %d", rt);
    return rt;
}

void TraderSpi::OnRspOrderAction(CTORATstpInputOrderActionField *pInputOrderAction, CTORATstpRspInfoField *pRspInfo, int nRequestID) {
    logger("撤单响应");
    bool bResult = pRspInfo && (pRspInfo->ErrorID != 0);
    // 只返回错误信息
    if (bResult) {
        ACL_JSON* json = acl_json_alloc();
        acl_json_node_add_child(json->root,
                                acl_json_create_int64(json, "ErrorID", pRspInfo->ErrorID));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "ErrorMsg", pRspInfo->ErrorMsg));
        //
        if (pInputOrderAction != NULL)
        {
            std::string ActionFlag(1, pInputOrderAction->ActionFlag);

            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "OrderActionRef", pInputOrderAction->OrderActionRef));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "OrderRef", pInputOrderAction->OrderRef));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "FrontID", pInputOrderAction->FrontID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "SessionID", pInputOrderAction->SessionID));
            std::string ExchangeID(0, pInputOrderAction->ExchangeID);
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ExchangeID", ExchangeID.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "OrderSysID", pInputOrderAction->OrderSysID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "CancelOrderSysID", pInputOrderAction->CancelOrderSysID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ActionFlag", ActionFlag.c_str()));
            std::cout << "SInfo" <<pInputOrderAction->SInfo << std::endl;
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "SInfo", pInputOrderAction->SInfo));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "IInfo", pInputOrderAction->IInfo));
            std::string Operway(0, pInputOrderAction->Operway);
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "Operway", Operway.c_str()));
        }

        ACL_VSTRING* buf = acl_json_build(json, NULL);
        char *outbuf = StpUtil::GB18030ToUTF8(acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
        logger_debug(DEBUG_TEST3, 2, "%s", outbuf);
        StpUtil::KafkaOrRedis(TOPIC_INPUT_ORDER_ACTION, outbuf, strlen(outbuf));
        delete[] outbuf;
        acl_vstring_free(buf);
        acl_json_free(json);
    }
}

void TraderSpi::OnErrRtnOrderAction(CTORATstpInputOrderActionField *pInputOrderAction, CTORATstpRspInfoField *pRspInfo, int nRequestID) {
//    logger("撤单错误回报");
//    bool bResult = pRspInfo && (pRspInfo->ErrorID != 0);
//    ACL_JSON *json = acl_json_alloc();
//    if (bResult) {
//
//        acl_json_node_add_child(json->root,
//                                acl_json_create_int64(json, "ErrorMsg", pRspInfo->ErrorID));
//        acl_json_node_add_child(json->root,
//                                acl_json_create_text(json, "ErrorMsg", pRspInfo->ErrorMsg));
//
//    }
//    if (pInputOrderAction != NULL) {
//        std::string ActionFlag(1, pInputOrderAction->ActionFlag);
//
//        acl_json_node_add_child(json->root,
//                                acl_json_create_int64(json, "OrderActionRef", pInputOrderAction->OrderActionRef));
//        acl_json_node_add_child(json->root,
//                                acl_json_create_int64(json, "OrderRef", pInputOrderAction->OrderRef));
//        acl_json_node_add_child(json->root,
//                                acl_json_create_int64(json, "FrontID", pInputOrderAction->FrontID));
//        acl_json_node_add_child(json->root,
//                                acl_json_create_int64(json, "SessionID", pInputOrderAction->SessionID));
//        std::string ExchangeID(0, pInputOrderAction->ExchangeID);
//        acl_json_node_add_child(json->root,
//                                acl_json_create_text(json, "ExchangeID", ExchangeID.c_str()));
//        acl_json_node_add_child(json->root,
//                                acl_json_create_text(json, "OrderSysID", pInputOrderAction->OrderSysID));
//        acl_json_node_add_child(json->root,
//                                acl_json_create_text(json, "CancelOrderSysID", pInputOrderAction->CancelOrderSysID));
//        acl_json_node_add_child(json->root,
//                                acl_json_create_text(json, "ActionFlag", ActionFlag.c_str()));
//        acl_json_node_add_child(json->root,
//                                acl_json_create_text(json, "SInfo", pInputOrderAction->SInfo));
//        acl_json_node_add_child(json->root,
//                                acl_json_create_int64(json, "IInfo", pInputOrderAction->IInfo));
//        std::string Operway(0, pInputOrderAction->Operway);
//        acl_json_node_add_child(json->root,
//                                acl_json_create_text(json, "Operway", Operway.c_str()));
//    }
//    ACL_VSTRING *buf = acl_json_build(json, NULL);
//    char *outbuf = StpUtil::GB18030ToUTF8(acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
//    logger_debug(DEBUG_TEST3, 2, "%s", outbuf);
//    StpUtil::KafkaOrRedis(TOPIC_INPUT_ORDER_ACTION, outbuf, strlen(outbuf));
//    delete[] outbuf;
//    acl_vstring_free(buf);
//    acl_json_free(json);
}

bool TraderSpi::isTradingOrder(CTORATstpOrderField *pOrder)
{
    return ((pOrder->OrderStatus != TORA_TSTP_OST_AllCanceled) &&
            (pOrder->OrderStatus != TORA_TSTP_OST_AllTraded));
}

void TraderSpi::OnRtnOrder(CTORATstpOrderField *pOrder) {
    if (pOrder != NULL)
    {
        if (isTradingOrder(pOrder)) {
            logger("%s等待成交中,ExchangeID(%c),SecurityID(%s),OrderStatus(%s)",
                    pOrder->InvestorID,pOrder->ExchangeID,pOrder->SecurityID,GetValue(pOrder->OrderStatus));
        } else if ((pOrder->OrderStatus == TORA_TSTP_OST_AllCanceled) &&
                   (pOrder->OrderSubmitStatus == TORA_TSTP_OSS_CancelSubmitted)) {
            logger("%s 撤单成功,ExchangeID(%c)SecurityID(%s),OrderStatus(%s)",
                    pOrder->InvestorID,pOrder->ExchangeID,pOrder->SecurityID, GetValue(pOrder->OrderStatus));
        } else if ((pOrder->OrderStatus == TORA_TSTP_OST_Rejected) &&
                   (pOrder->OrderSubmitStatus == TORA_TSTP_OSS_InsertSubmitted)) {
            logger("%s 交易所拒单,ExchangeID(%c)SecurityID(%s),",
                   pOrder->InvestorID,pOrder->ExchangeID,pOrder->SecurityID);
        }
        std::string OrderPriceType(1, pOrder->OrderPriceType);
        std::string Direction(1, pOrder->Direction);
        std::string TimeCondition(1, pOrder->TimeCondition);
        std::string VolumeCondition(1, pOrder->VolumeCondition);
        std::string ForceCloseReason(1, pOrder->ForceCloseReason);
        std::string OrderSubmitStatus(1, pOrder->OrderSubmitStatus);
        std::string OrderStatus(1, pOrder->OrderStatus);
        std::string OrderType(1, pOrder->OrderType);
        ACL_JSON* json = acl_json_alloc();
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "InvestorID", pOrder->InvestorID));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "SecurityID", pOrder->SecurityID));
        std::string ExchangeID(1, pOrder->ExchangeID);
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "ExchangeID", ExchangeID.c_str()));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "ShareholderID", pOrder->ShareholderID));
        acl_json_node_add_child(json->root,
                                acl_json_create_int64(json, "OrderRef", pOrder->OrderRef));
        acl_json_node_add_child(json->root,
                                acl_json_create_int64(json, "FrontID", pOrder->FrontID));
        acl_json_node_add_child(json->root,
                                acl_json_create_int64(json, "SessionID", pOrder->SessionID));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "OrderSysID", pOrder->OrderSysID));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "OrderPriceType", OrderPriceType.c_str()));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "Direction", Direction.c_str()));
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "LimitPrice", pOrder->LimitPrice));
        acl_json_node_add_child(json->root,
                                acl_json_create_int64(json, "VolumeTotalOriginal", pOrder->VolumeTotalOriginal));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "TimeCondition", TimeCondition.c_str()));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "VolumeCondition", VolumeCondition.c_str()));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "ForceCloseReason", ForceCloseReason.c_str()));
        acl_json_node_add_child(json->root,
                                acl_json_create_int64(json, "RequestID", pOrder->RequestID));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "OrderLocalID", pOrder->OrderLocalID));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "OrderSubmitStatus", OrderSubmitStatus.c_str()));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "TradingDay", pOrder->TradingDay));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "OrderStatus", OrderStatus.c_str()));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "OrderType", OrderType.c_str()));
        acl_json_node_add_child(json->root,
                                acl_json_create_int64(json, "VolumeTraded", pOrder->VolumeTraded));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "InsertDate", pOrder->InsertDate));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "InsertTime", pOrder->InsertTime));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "CancelTime", pOrder->CancelTime));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "UserProductInfo", pOrder->UserProductInfo));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "StatusMsg", pOrder->StatusMsg));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "BusinessUnitID", pOrder->BusinessUnitID));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "AccountID", pOrder->AccountID));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "IPAddress", pOrder->IPAddress));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "MacAddress", pOrder->MacAddress));
        std::string LotType(0, pOrder->LotType);
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "LotType", LotType.c_str()));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "SInfo", pOrder->SInfo));
        acl_json_node_add_child(json->root,
                                acl_json_create_int64(json, "IInfo", pOrder->IInfo));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "DepartmentID", pOrder->DepartmentID));
        std::string Operway(0, pOrder->Operway);
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "Operway", Operway.c_str()));
        std::string CondCheck(0, pOrder->CondCheck);
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "CondCheck", CondCheck.c_str()));
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "Turnover", pOrder->Turnover));
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "RtnFloatInfo", pOrder->RtnFloatInfo));
        acl_json_node_add_child(json->root,
                                acl_json_create_int64(json, "RtnIntInfo", pOrder->RtnIntInfo));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "GTDate", pOrder->GTDate));
        acl_json_node_add_child(json->root,
                                acl_json_create_int64(json, "VolumeCanceled", pOrder->VolumeCanceled));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "InsertUser", pOrder->InsertUser));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "AcceptTime", pOrder->AcceptTime));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "CancelUser", pOrder->CancelUser));
        std::string CurrencyID(1, pOrder->CurrencyID);
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "CurrencyID", CurrencyID.c_str()));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "PbuID", pOrder->PbuID));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "CreditQuotaID", pOrder->CreditQuotaID));
        std::string CreditQuotaType(0, pOrder->CreditQuotaType);
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "CreditQuotaType", CreditQuotaType.c_str()));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "CreditDebtID", pOrder->CreditDebtID));

        ACL_VSTRING* buf = acl_json_build(json, NULL);
        char *outbuf = StpUtil::GB18030ToUTF8(acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
        logger_debug(DEBUG_TEST3, 2, "%s", outbuf);
        StpUtil::KafkaOrRedis(TOPIC_ORDER, outbuf, strlen(outbuf));
        delete[] outbuf;
        acl_vstring_free(buf);
        acl_json_free(json);
    }
}

void TraderSpi::OnRtnTrade(CTORATstpTradeField *pTrade) {
    if (pTrade != NULL)
    {
        logger("%s %s =====报单成交=====", pTrade->InvestorID, pTrade->SecurityID);
        std::string Direction(1, pTrade->Direction);
        std::string ExchangeID(1, pTrade->ExchangeID);
        ACL_JSON* json = acl_json_alloc();
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "InvestorID", pTrade->InvestorID));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "SecurityID", pTrade->SecurityID));
        acl_json_node_add_child(json->root,
                                acl_json_create_int64(json, "OrderRef", pTrade->OrderRef));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "ExchangeID", ExchangeID.c_str()));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "TradeID", pTrade->TradeID));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "Direction", Direction.c_str()));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "OrderSysID", pTrade->OrderSysID));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "ShareholderID", pTrade->ShareholderID));
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "Price", pTrade->Price));
        acl_json_node_add_child(json->root,
                                acl_json_create_int64(json, "Volume", pTrade->Volume));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "TradeDate", pTrade->TradeDate));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "TradeTime", pTrade->TradeTime));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "OrderLocalID", pTrade->OrderLocalID));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "TradingDay", pTrade->TradingDay));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "BusinessUnitID", pTrade->BusinessUnitID));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "AccountID", pTrade->AccountID));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "DepartmentID", pTrade->DepartmentID));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "PbuID", pTrade->PbuID));
        std::string CurrencyID(1, pTrade->CurrencyID);
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "CurrencyID", CurrencyID.c_str()));

        ACL_VSTRING* buf = acl_json_build(json, NULL);
        char *outbuf = StpUtil::GB18030ToUTF8(acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
        logger_debug(DEBUG_TEST3, 2, "%s", outbuf);
        StpUtil::KafkaOrRedis(TOPIC_TRADE, outbuf, strlen(outbuf));
        delete[] outbuf;
        acl_vstring_free(buf);
        acl_json_free(json);
    }
}


// 请求查询报单
int TraderSpi::reqQryOrder()
{
    CTORATstpQryOrderField orderReq;
    memset(&orderReq, 0, sizeof(orderReq));
    // 交易所
    int rt = m_pTraderApi->ReqQryOrder(&orderReq, 0);
    if(rt == 0) {
        logger("发送查询报单请求成功");
    } else if(rt == -1) {
        logger_error("网络连接失败或未登陆");
    } else if(rt == -2) {
        logger_error("超出流控限制");
    } else if(rt == -3 || rt == -5) {
        logger_error("网络写失败");
    }
    return rt;
}

void TraderSpi::OnRspQryOrder(CTORATstpOrderField *pOrder, CTORATstpRspInfoField *pRspInfo, int nRequestID, bool bIsLast) {
    if (bIsLast)
    {
        logger("查询结束");
        return;
    }
    if (!isErrorRspInfo(pRspInfo)) {
        if (pOrder != NULL)
        {
            std::string OrderPriceType(1, pOrder->OrderPriceType);
            std::string Direction(1, pOrder->Direction);
            std::string TimeCondition(1, pOrder->TimeCondition);
            std::string VolumeCondition(1, pOrder->VolumeCondition);
            std::string ForceCloseReason(1, pOrder->ForceCloseReason);
            std::string OrderSubmitStatus(1, pOrder->OrderSubmitStatus);
            std::string OrderStatus(1, pOrder->OrderStatus);
            std::string OrderType(1, pOrder->OrderType);
            ACL_JSON* json = acl_json_alloc();
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "InvestorID", pOrder->InvestorID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "SecurityID", pOrder->SecurityID));
            std::string ExchangeID(1, pOrder->ExchangeID);
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ExchangeID", ExchangeID.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ShareholderID", pOrder->ShareholderID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "OrderRef", pOrder->OrderRef));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "FrontID", pOrder->FrontID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "SessionID", pOrder->SessionID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "OrderSysID", pOrder->OrderSysID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "OrderPriceType", OrderPriceType.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "Direction", Direction.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "LimitPrice", pOrder->LimitPrice));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "VolumeTotalOriginal", pOrder->VolumeTotalOriginal));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "TimeCondition", TimeCondition.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "VolumeCondition", VolumeCondition.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ForceCloseReason", ForceCloseReason.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "RequestID", pOrder->RequestID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "OrderLocalID", pOrder->OrderLocalID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "OrderSubmitStatus", OrderSubmitStatus.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "TradingDay", pOrder->TradingDay));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "OrderStatus", OrderStatus.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "OrderType", OrderType.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "VolumeTraded", pOrder->VolumeTraded));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "InsertDate", pOrder->InsertDate));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "InsertTime", pOrder->InsertTime));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "CancelTime", pOrder->CancelTime));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "UserProductInfo", pOrder->UserProductInfo));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "StatusMsg", pOrder->StatusMsg));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "BusinessUnitID", pOrder->BusinessUnitID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "AccountID", pOrder->AccountID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "IPAddress", pOrder->IPAddress));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "MacAddress", pOrder->MacAddress));
            std::string LotType(0, pOrder->LotType);
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "LotType", LotType.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "SInfo", pOrder->SInfo));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "IInfo", pOrder->IInfo));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "DepartmentID", pOrder->DepartmentID));
            std::string Operway(0, pOrder->Operway);
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "Operway", Operway.c_str()));
            std::string CondCheck(0, pOrder->CondCheck);
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "CondCheck", CondCheck.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "Turnover", pOrder->Turnover));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "RtnFloatInfo", pOrder->RtnFloatInfo));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "RtnIntInfo", pOrder->RtnIntInfo));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "GTDate", pOrder->GTDate));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "VolumeCanceled", pOrder->VolumeCanceled));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "InsertUser", pOrder->InsertUser));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "AcceptTime", pOrder->AcceptTime));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "CancelUser", pOrder->CancelUser));
            std::string CurrencyID(0, pOrder->CurrencyID);
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "CurrencyID", CurrencyID.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "PbuID", pOrder->PbuID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "CreditQuotaID", pOrder->CreditQuotaID));
            std::string CreditQuotaType(0, pOrder->CreditQuotaType);
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "CreditQuotaType", CreditQuotaType.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "CreditDebtID", pOrder->CreditDebtID));

            ACL_VSTRING* buf = acl_json_build(json, NULL);
            char *outbuf = StpUtil::GB18030ToUTF8(acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
            logger_debug(DEBUG_TEST3, 2, "%s", outbuf);
            StpUtil::KafkaOrRedis(TOPIC_ORDER, outbuf, strlen(outbuf));
            delete[] outbuf;
            acl_vstring_free(buf);
            acl_json_free(json);
        }
    }
}

void TraderSpi::OnRspQryOrderAction(CTORATstpOrderActionField *pOrderAction, CTORATstpRspInfoField *pRspInfo, int nRequestID,
                                    bool bIsLast) {
//    if (!isErrorRspInfo(pRspInfo)) {
//        if (pOrderAction != NULL)
//        {
//            ACL_JSON* json = acl_json_alloc();
//            std::string ActionFlag(1, pOrderAction->ActionFlag);
//            std::string OrderActionStatus(1, pOrderAction->OrderActionStatus);
//            acl_json_node_add_child(json->root,
//                                    acl_json_create_text(json, "InvestorID", pOrderAction->InvestorID));
//            acl_json_node_add_child(json->root,
//                                    acl_json_create_text(json, "OrderActionRef", pOrderAction->OrderActionRef));
//            acl_json_node_add_child(json->root,
//                                    acl_json_create_text(json, "OrderRef", pOrderAction->OrderRef));
//            acl_json_node_add_child(json->root,
//                                    acl_json_create_int64(json, "RequestID", pOrderAction->RequestID));
//            acl_json_node_add_child(json->root,
//                                    acl_json_create_int64(json, "FrontID", pOrderAction->FrontID));
//            acl_json_node_add_child(json->root,
//                                    acl_json_create_int64(json, "SessionID", pOrderAction->SessionID));
//            std::string ExchangeID(0, pOrderAction->ExchangeID);
//            acl_json_node_add_child(json->root,
//                                    acl_json_create_text(json, "ExchangeID", ExchangeID.c_str()));
//            acl_json_node_add_child(json->root,
//                                    acl_json_create_text(json, "OrderSysID", pOrderAction->OrderSysID));
//            acl_json_node_add_child(json->root,
//                                    acl_json_create_text(json, "ActionFlag", ActionFlag.c_str()));
//            acl_json_node_add_child(json->root,
//                                    acl_json_create_double(json, "Price", pOrderAction->Price));
//            acl_json_node_add_child(json->root,
//                                    acl_json_create_int64(json, "Volume", pOrderAction->Volume));
//            acl_json_node_add_child(json->root,
//                                    acl_json_create_text(json, "ActionDate", pOrderAction->ActionDate));
//            acl_json_node_add_child(json->root,
//                                    acl_json_create_text(json, "ActionTime", pOrderAction->ActionTime));
//            acl_json_node_add_child(json->root,
//                                    acl_json_create_text(json, "TraderID", pOrderAction->TraderID));
//            acl_json_node_add_child(json->root,
//                                    acl_json_create_text(json, "OrderLocalID", pOrderAction->OrderLocalID));
//            acl_json_node_add_child(json->root,
//                                    acl_json_create_text(json, "ActionLocalID", pOrderAction->ActionLocalID));
//            acl_json_node_add_child(json->root,
//                                    acl_json_create_text(json, "ShareholderID", pOrderAction->ShareholderID));
//            acl_json_node_add_child(json->root,
//                                    acl_json_create_text(json, "OrderActionStatus", OrderActionStatus.c_str()));
//            acl_json_node_add_child(json->root,
//                                    acl_json_create_text(json, "UserID", pOrderAction->UserID));
//            acl_json_node_add_child(json->root,
//                                    acl_json_create_text(json, "StatusMsg", pOrderAction->StatusMsg));
//            acl_json_node_add_child(json->root,
//                                    acl_json_create_text(json, "SecurityID", pOrderAction->SecurityID));
//            acl_json_node_add_child(json->root,
//                                    acl_json_create_text(json, "IPAddress", pOrderAction->IPAddress));
//            acl_json_node_add_child(json->root,
//                                    acl_json_create_text(json, "MacAddress", pOrderAction->MacAddress));
//            acl_json_node_add_child(json->root,
//                                    acl_json_create_text(json, "SInfo", pOrderAction->SInfo));
//            acl_json_node_add_child(json->root,
//                                    acl_json_create_int64(json, "IInfo", pOrderAction->IInfo));
//            std::string Operway(0, pOrderAction->Operway);
//            acl_json_node_add_child(json->root,
//                                    acl_json_create_text(json, "Operway", Operway.c_str()));
//            acl_json_node_add_child(json->root,
//                                    acl_json_create_text(json, "HDSerial", pOrderAction->HDSerial));
//            acl_json_node_add_child(json->root,
//                                    acl_json_create_text(json, "Mobile", pOrderAction->Mobile));
//            std::string MarketID(0, pOrderAction->MarketID);
//            std::string Direction(0, pOrderAction->Direction);
//            std::string OrderPriceType(0, pOrderAction->OrderPriceType);
//            std::string TimeCondition(0, pOrderAction->TimeCondition);
//            std::string VolumeCondition(0, pOrderAction->VolumeCondition);
//            acl_json_node_add_child(json->root,
//                                    acl_json_create_text(json, "MarketID", MarketID.c_str()));
//            acl_json_node_add_child(json->root,
//                                    acl_json_create_text(json, "Direction", Direction.c_str()));
//            acl_json_node_add_child(json->root,
//                                    acl_json_create_text(json, "OrderPriceType", OrderPriceType.c_str()));
//            acl_json_node_add_child(json->root,
//                                    acl_json_create_text(json, "TimeCondition", TimeCondition.c_str()));
//            acl_json_node_add_child(json->root,
//                                    acl_json_create_text(json, "VolumeCondition", VolumeCondition.c_str()));
//            ACL_VSTRING *buf = acl_json_build(json, NULL);
//            char *outbuf = StpUtil::GB18030ToUTF8(acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
//            logger_debug(DEBUG_TEST3, 2, "%s", outbuf);
//            StpUtil::KafkaOrRedis(TOPIC_ORDER_ACTION, outbuf, strlen(outbuf));
//            delete[] outbuf;
//            acl_vstring_free(buf);
//            acl_json_free(json);
//        } else {
//            logger("报单为空");
//        }
//    }
//    if (bIsLast)
//    {
//        logger("查询结束");
//    }
}

int TraderSpi::reqQryTrade()
{
    CTORATstpQryTradeField tradeReq;
    memset(&tradeReq, 0, sizeof(tradeReq));
    // 交易所
    int rt = m_pTraderApi->ReqQryTrade(&tradeReq, 0);
    if(rt == 0) {
        logger("发送查询成交请求成功");
    } else if(rt == -1) {
        logger_error("网络连接失败或未登陆");
    } else if(rt == -2) {
        logger_error("超出流控限制");
    } else if(rt == -3 || rt == -5) {
        logger_error("网络写失败");
    }
    return rt;
}

void TraderSpi::OnRspQryTrade(CTORATstpTradeField *pTrade, CTORATstpRspInfoField *pRspInfo, int nRequestID, bool bIsLast) {
    if (bIsLast)
    {
        logger("查询结束");
        return;
    }
    if (!isErrorRspInfo(pRspInfo)) {
        if (pTrade != NULL) {
            std::string Direction(1, pTrade->Direction);
            std::string ExchangeID(1, pTrade->ExchangeID);
            ACL_JSON* json = acl_json_alloc();
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "InvestorID", pTrade->InvestorID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "SecurityID", pTrade->SecurityID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "OrderRef", pTrade->OrderRef));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ExchangeID", ExchangeID.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "TradeID", pTrade->TradeID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "Direction", Direction.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "OrderSysID", pTrade->OrderSysID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ShareholderID", pTrade->ShareholderID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "Price", pTrade->Price));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "Volume", pTrade->Volume));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "TradeDate", pTrade->TradeDate));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "TradeTime", pTrade->TradeTime));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "OrderLocalID", pTrade->OrderLocalID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "TradingDay", pTrade->TradingDay));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "BusinessUnitID", pTrade->BusinessUnitID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "AccountID", pTrade->AccountID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "DepartmentID", pTrade->DepartmentID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "PbuID", pTrade->PbuID));
            std::string CurrencyID(1, pTrade->CurrencyID);
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "CurrencyID", CurrencyID.c_str()));

            ACL_VSTRING* buf = acl_json_build(json, NULL);
            char *outbuf = StpUtil::GB18030ToUTF8(acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
            logger_debug(DEBUG_TEST3, 2, "%s", outbuf);
            StpUtil::KafkaOrRedis(TOPIC_TRADE, outbuf, strlen(outbuf));
            delete[] outbuf;
            acl_vstring_free(buf);
            acl_json_free(json);
        }
    }
}

int TraderSpi::reqQryPosition()
{
    CTORATstpQryPositionField postionReq;
    memset(&postionReq, 0, sizeof(postionReq));
    // 选填
//    strcpy(postionReq.BrokerID, m_pAccount->getBrokerID());
//    strcpy(postionReq.InvestorID, m_pAccount->getInvesterID());
//    strcpy(postionReq.InstrumentID, g_pTradeInstrumentID);
    static int requestID = 0; // 请求编号
//    std::this_thread::sleep_for(std::chrono::milliseconds(700)); // 有时候需要停顿一会才能查询成功
    int rt = m_pTraderApi->ReqQryPosition(&postionReq, requestID);
    if (!rt)
        logger("发送投资者持仓查询请求成功");
    else
        logger_error("--->>>发送投资者持仓查询请求失败, errorCode= %d", rt);
    return rt;
}

void TraderSpi::OnRspQryPosition(CTORATstpPositionField *pPosition, CTORATstpRspInfoField *pRspInfo, int nRequestID,
                                 bool bIsLast) {
    if (bIsLast)
    {
        logger("查询结束");
        return;
    }
    if (!isErrorRspInfo(pRspInfo)) {
        if (pPosition != NULL) {
            std::string ExchangeID(1, pPosition->ExchangeID);
            ACL_JSON* json = acl_json_alloc();
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ExchangeID", ExchangeID.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "InvestorID", pPosition->InvestorID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "SecurityID", pPosition->SecurityID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "BusinessUnitID", pPosition->BusinessUnitID));
            std::string MarketID(1, pPosition->MarketID);
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "MarketID", MarketID.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ShareholderID", pPosition->ShareholderID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "TradingDay", pPosition->TradingDay));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "HistoryPos", pPosition->HistoryPos));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "HistoryPosFrozen", pPosition->HistoryPosFrozen));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "TodayBSPos", pPosition->TodayBSPos));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "TodayBSPosFrozen", pPosition->TodayBSPosFrozen));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "TodayPRPos", pPosition->TodayPRPos));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "TodayPRPosFrozen", pPosition->TodayPRPosFrozen));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "TotalPosCost", pPosition->TotalPosCost));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "TodaySMPos", pPosition->TodaySMPos));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "HistoryPosPrice", pPosition->HistoryPosPrice));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "TodaySMPosFrozen", pPosition->TodaySMPosFrozen));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "PrePosition", pPosition->PrePosition));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "AvailablePosition", pPosition->AvailablePosition));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "CurrentPosition", pPosition->CurrentPosition));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "OpenPosCost", pPosition->OpenPosCost));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "SecurityName", pPosition->SecurityName));

            // 两融专用
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "CreditBuyPos", pPosition->CreditBuyPos));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "CreditSellPos", pPosition->CreditSellPos));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "TodayCreditSellPos", pPosition->TodayCreditSellPos));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "CollateralOutPos", pPosition->CollateralOutPos));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "RepayUntradeVolume", pPosition->RepayUntradeVolume));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "RepayTransferUntradeVolume", pPosition->RepayTransferUntradeVolume));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "CollateralBuyUntradeAmount", pPosition->CollateralBuyUntradeAmount));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "CollateralBuyUntradeVolume", pPosition->CollateralBuyUntradeVolume));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "CreditBuyAmount", pPosition->CreditBuyAmount));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "CreditBuyUntradeAmount", pPosition->CreditBuyUntradeAmount));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "CreditBuyFrozenMargin", pPosition->CreditBuyFrozenMargin));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "CreditBuyInterestFee", pPosition->CreditBuyInterestFee));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "CreditBuyUntradeVolume", pPosition->CreditBuyUntradeVolume));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "CreditSellAmount", pPosition->CreditSellAmount));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "CreditSellUntradeAmount", pPosition->CreditSellUntradeAmount));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "CreditSellFrozenMargin", pPosition->CreditSellFrozenMargin));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "CreditSellInterestFee", pPosition->CreditSellInterestFee));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "CreditSellUntradeVolume", pPosition->CreditSellUntradeVolume));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "CollateralInPos", pPosition->CollateralInPos));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "CreditBuyFrozenCirculateMargin", pPosition->CreditBuyFrozenCirculateMargin));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "CreditSellFrozenCirculateMargin", pPosition->CreditSellFrozenCirculateMargin));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "CreditSellFrozenCirculateMargin", pPosition->CreditSellFrozenCirculateMargin));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "CloseProfit", pPosition->CloseProfit));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "TodayTotalOpenVolume", pPosition->TodayTotalOpenVolume));

            ACL_VSTRING* buf = acl_json_build(json, NULL);
            char *outbuf = StpUtil::GB18030ToUTF8(acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
            logger_debug(DEBUG_TEST3, 2, "%s", outbuf);
            StpUtil::KafkaOrRedis(TOPIC_POSITION, outbuf, strlen(outbuf));
            delete[] outbuf;
            acl_vstring_free(buf);
            acl_json_free(json);
        }
    }
}

// 请求查询交易所
int TraderSpi::reqQryExchange(const char *ExchangeID) {
    CTORATstpQryExchangeField exchangeID = {0};
    if (NULL != ExchangeID) {
        exchangeID.ExchangeID = ExchangeID[0];
    }

    int requestID = 0;
    int rt = m_pTraderApi->ReqQryExchange(&exchangeID, requestID);
    if(rt == 0) {
        logger("发送查询交易所请求成功");
    } else if(rt == -1) {
        logger_error("网络连接失败或未登陆");
    } else if(rt == -2) {
        logger_error("超出流控限制");
    } else if(rt == -3 || rt == -5) {
        logger_error("网络写失败");
    }
    return rt;
}

void TraderSpi::OnRspQryExchange(CTORATstpExchangeField *pExchange, CTORATstpRspInfoField *pRspInfo, int nRequestID,
                                 bool bIsLast) {
    if (bIsLast)
    {
        logger("查询交易所结束");
        return;
    }
    if (!isErrorRspInfo(pRspInfo)) {
        if (pExchange != NULL) {
//            logger_debug(DEBUG_TEST2, 1, "请求查询交易所响应");
            std::string ExchangeID(1, pExchange->ExchangeID);
            std::string DataSyncStatus(1, pExchange->DataSyncStatus);
            ACL_JSON *json = acl_json_alloc();
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ExchangeID", ExchangeID.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ExchangeName", pExchange->ExchangeName));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "TradingDay", pExchange->TradingDay));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "DataSyncStatus", DataSyncStatus.c_str()));
            ACL_VSTRING *buf = acl_json_build(json, NULL);
            char *outbuf = StpUtil::GB18030ToUTF8(acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
            logger_debug(DEBUG_TEST3, 1, "%s", outbuf);
            StpUtil::KafkaOrRedis(TOPIC_EXCHANGE, outbuf, strlen(outbuf));
            delete[] outbuf;
            acl_vstring_free(buf);
            acl_json_free(json);
        }
    }
}

// 查询证券信息
int TraderSpi::reqQrySecurity(const char* SecurityID,const char* ExchangeID,const char* ProductID) {
    CTORATstpQrySecurityField req;
    memset(&req, 0, sizeof(req));
    if (SecurityID != NULL)
    {
        strcpy(req.SecurityID, SecurityID);
    }
    if (ExchangeID != NULL)
    {
        req.ExchangeID = ExchangeID[0];
    }
    if (ProductID != NULL)
    {
        req.ProductID = ProductID[0];
    }

    int rt = m_pTraderApi->ReqQrySecurity(&req, 0);
    if(rt == 0) {
        logger("发送查询证券信息请求成功");
    } else if(rt == -1) {
        logger_error("网络连接失败或未登陆");
    } else if(rt == -2) {
        logger_error("超出流控限制");
    } else if(rt == -3 || rt == -5) {
        logger_error("网络写失败");
    }
    return rt;
}

void TraderSpi::OnRspQrySecurity(CTORATstpSecurityField *pSecurity, CTORATstpRspInfoField *pRspInfo, int nRequestID,
                                 bool bIsLast) {
    if (bIsLast)
    {
        logger("查询结束");
        return;
    }
    if (!isErrorRspInfo(pRspInfo)) {
        if (pSecurity != NULL) {
//            logger_debug(DEBUG_TEST2, 1, "请求查询证券信息响应");
            std::string ExchangeID(1, pSecurity->ExchangeID);
            ACL_JSON *json = acl_json_alloc();

            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ExchangeID", ExchangeID.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "SecurityID", pSecurity->SecurityID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "SecurityName", pSecurity->SecurityName));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "UnderlyingSecurityID", pSecurity->UnderlyingSecurityID));
            std::string MarketID(1, pSecurity->MarketID);
            std::string ProductID(1, pSecurity->ProductID);
            std::string SecurityType(1, pSecurity->SecurityType);
            std::string OrderUnit(1, pSecurity->OrderUnit);
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "MarketID", MarketID.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ProductID", ProductID.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "SecurityType", SecurityType.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "OrderUnit", OrderUnit.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "LimitBuyTradingUnit", pSecurity->LimitBuyTradingUnit));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "LimitSellTradingUnit", pSecurity->LimitSellTradingUnit));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "MaxMarketOrderBuyVolume", pSecurity->MaxMarketOrderBuyVolume));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "MinMarketOrderBuyVolume", pSecurity->MinMarketOrderBuyVolume));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "MaxLimitOrderBuyVolume", pSecurity->MaxLimitOrderBuyVolume));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "MinLimitOrderBuyVolume", pSecurity->MinLimitOrderBuyVolume));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "MaxMarketOrderSellVolume", pSecurity->MaxMarketOrderSellVolume));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "MinMarketOrderSellVolume", pSecurity->MinMarketOrderSellVolume));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "MaxLimitOrderSellVolume", pSecurity->MaxLimitOrderSellVolume));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "MinLimitOrderSellVolume", pSecurity->MinLimitOrderSellVolume));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "VolumeMultiple", pSecurity->VolumeMultiple));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "PriceTick", pSecurity->PriceTick));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "OpenDate", pSecurity->OpenDate));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "ParValue", pSecurity->ParValue));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "SecurityStatus", pSecurity->SecurityStatus));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "BondInterest", pSecurity->BondInterest));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "ConversionRate", pSecurity->ConversionRate));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "PreClosePrice", pSecurity->PreClosePrice));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "UpperLimitPrice", pSecurity->UpperLimitPrice));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "LowerLimitPrice", pSecurity->LowerLimitPrice));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "TradingDay", pSecurity->TradingDay));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ShortSecurityName", pSecurity->ShortSecurityName));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "MarketBuyTradingUnit", pSecurity->MarketBuyTradingUnit));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "MarketSellTradingUnit", pSecurity->MarketSellTradingUnit));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "FixPriceBuyTradingUnit", pSecurity->FixPriceBuyTradingUnit));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "FixPriceSellTradingUnit", pSecurity->FixPriceSellTradingUnit));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "MaxFixPriceOrderBuyVolume", pSecurity->MaxFixPriceOrderBuyVolume));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "MinFixPriceOrderBuyVolume", pSecurity->MinFixPriceOrderBuyVolume));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "MaxFixPriceOrderSellVolume", pSecurity->MaxFixPriceOrderSellVolume));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "MinFixPriceOrderSellVolume", pSecurity->MinFixPriceOrderSellVolume));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "TotalEquity", pSecurity->TotalEquity));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "CirculationEquity", pSecurity->CirculationEquity));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "bPriceLimit", pSecurity->bPriceLimit));
            ACL_VSTRING *buf = acl_json_build(json, NULL);
            char *outbuf = StpUtil::GB18030ToUTF8(acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
            logger_debug(DEBUG_TEST3, 1, "%s", outbuf);
            StpUtil::KafkaOrRedis(TOPIC_SECURITY, outbuf, strlen(outbuf));
            delete[] outbuf;
            acl_vstring_free(buf);
            acl_json_free(json);
        }
    }
}

// 查询市场
int TraderSpi::reqQryMarket(const char *ExchangeID,const char *MarketID) {
    CTORATstpQryMarketField req;
    memset(&req, 0, sizeof(req));
    if (MarketID != NULL)
    {
        req.MarketID = MarketID[0];
    }
    if (ExchangeID != NULL)
    {
        req.ExchangeID = ExchangeID[0];
    }
    int rt = m_pTraderApi->ReqQryMarket(&req, 0);
    if(rt == 0) {
        logger("发送查询市场信息请求成功");
    } else if(rt == -1) {
        logger_error("网络连接失败或未登陆");
    } else if(rt == -2) {
        logger_error("超出流控限制");
    } else if(rt == -3 || rt == -5) {
        logger_error("网络写失败");
    }
    return rt;
}

void TraderSpi::OnRspQryMarket(CTORATstpMarketField *pMarket, CTORATstpRspInfoField *pRspInfo, int nRequestID, bool bIsLast) {
    if (bIsLast)
    {
        logger("查询结束");
        return;
    }
    if (!isErrorRspInfo(pRspInfo)) {
        if (pMarket != NULL) {
            std::string MarketID(1, pMarket->MarketID);
            std::string ExchangeID(1, pMarket->ExchangeID);
            ACL_JSON *json = acl_json_alloc();
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ExchangeID", ExchangeID.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "MarketID", MarketID.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "MarketName", pMarket->MarketName));
            std::string MarketStatus(1, pMarket->MarketStatus);
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "MarketStatus", MarketStatus.c_str()));
            ACL_VSTRING *buf = acl_json_build(json, NULL);
            char *outbuf = StpUtil::GB18030ToUTF8(acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
            logger_debug(DEBUG_TEST3, 1, "%s", outbuf);
            StpUtil::KafkaOrRedis(TOPIC_MARKET, outbuf, strlen(outbuf));
            delete[] outbuf;
            acl_vstring_free(buf);
            acl_json_free(json);
        }
    }
}

// 查询股东账户
int TraderSpi::reqQryShareholderAccount(const char* ExchangeID,const char* MarketID,const char* ShareholderID,const char* TradingCodeClass) {
    CTORATstpQryShareholderAccountField req;
    memset(&req, 0, sizeof(req));
    if (ExchangeID != NULL)
    {
        req.ExchangeID = ExchangeID[0];
    }
    if (MarketID != NULL)
    {
        req.MarketID = MarketID[0];
    }
    if (ShareholderID != NULL)
    {
        strcpy(req.ShareholderID, ShareholderID);
    }

    int rt = m_pTraderApi->ReqQryShareholderAccount(&req, 0);
    if(rt == 0) {
        logger("发送查询股东账户请求成功");
      } else if(rt == -1) {
          logger_error("网络连接失败或未登陆");
      } else if(rt == -2) {
          logger_error("超出流控限制");
      } else if(rt == -3 || rt == -5) {
          logger_error("网络写失败");
      }
    return rt;
}

void TraderSpi::OnRspQryShareholderAccount(CTORATstpShareholderAccountField *pShareholderAccount,
                                           CTORATstpRspInfoField *pRspInfo, int nRequestID, bool bIsLast) {
    if (bIsLast)
    {
        logger("查询结束");
        return;
    }
    if (!isErrorRspInfo(pRspInfo)) {
        if (pShareholderAccount != NULL) {
//            logger_debug(DEBUG_TEST2, 1, "请求查询股东账户");
            std::string ExchangeID(1, pShareholderAccount->ExchangeID);
            ACL_JSON *json = acl_json_alloc();
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ExchangeID", ExchangeID.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "InvestorID", pShareholderAccount->InvestorID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ShareholderID", pShareholderAccount->ShareholderID));
            std::string MarketID(1, pShareholderAccount->MarketID);
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "MarketID", MarketID.c_str()));
            std::string ShareholderIDType(1, pShareholderAccount->ShareholderIDType);
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ShareholderIDType", ShareholderIDType.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "BSWhiteListCtl", pShareholderAccount->BSWhiteListCtl));

            ACL_VSTRING *buf = acl_json_build(json, NULL);
            logger_debug(DEBUG_TEST3, 1, "%s", acl_vstring_str(buf));
            StpUtil::KafkaOrRedis(TOPIC_SHAREHOLDER_ACCOUNT, acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
            acl_vstring_free(buf);
            acl_json_free(json);
        }
    }
}

// 查询资金账户
int TraderSpi::reqQryTradingAccount(const char *InvestorID,const char *CurrencyID,const char *AccountID,const char *AccountType,const char *DepartmentID)
{
    CTORATstpQryTradingAccountField req;
    memset(&req, 0, sizeof(req));
//    if (InvestorID != NULL)
//    {
//        strcpy(req.InvestorID, m_pAccount->getInvestorId().c_str());
//    }
    if (CurrencyID != NULL)
    {
        req.CurrencyID = atof(CurrencyID);
    }
    if (AccountID != NULL)
    {
        strcpy(req.AccountID, AccountID);
    }
    if (AccountType != NULL)
    {
        req.AccountType = AccountType[0];
    }
    if (DepartmentID != NULL)
    {
        strcpy(req.DepartmentID, DepartmentID);
    }
    int rt = m_pTraderApi->ReqQryTradingAccount(&req, 0);
    if(rt == 0) {
        logger("发送查询资金账户请求成功");
    } else if(rt == -1) {
        logger_error("网络连接失败或未登陆");
    } else if(rt == -2) {
        logger_error("超出流控限制");
    } else if(rt == -3 || rt == -5) {
        logger_error("网络写失败");
    }
    return rt;
}

void TraderSpi::OnRspQryTradingAccount(CTORATstpTradingAccountField *pTradingAccount, CTORATstpRspInfoField *pRspInfo,
                                       int nRequestID, bool bIsLast) {
    if (bIsLast)
    {
        logger("查询结束");
        return;
    }
    if (!isErrorRspInfo(pRspInfo)) {
        if (pTradingAccount != NULL) {
            logger_debug(DEBUG_TEST3, 1, "%s =====查询投资者资金账户成功=====", pTradingAccount->AccountID);
            std::string AccountType(1, pTradingAccount->AccountType);
            std::string CurrencyID(1, pTradingAccount->CurrencyID);
            ACL_JSON *json = acl_json_alloc();
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "InvestorID", pTradingAccount->InvestorID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "AccountID", pTradingAccount->AccountID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "AccountType", AccountType.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "CurrencyID", CurrencyID.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "PreDeposit", pTradingAccount->PreDeposit));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "UsefulMoney", pTradingAccount->UsefulMoney));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "FetchLimit", pTradingAccount->FetchLimit));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "Deposit", pTradingAccount->Deposit));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "Withdraw", pTradingAccount->Withdraw));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "UnDeliveredMoney",
                                                           pTradingAccount->UnDeliveredMoney));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "FrozenCash", pTradingAccount->FrozenCash));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "FrozenCommission",
                                                           pTradingAccount->FrozenCommission));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "PreUnDeliveredMoney",
                                                           pTradingAccount->PreUnDeliveredMoney));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "Commission", pTradingAccount->Commission));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "DepartmentID", pTradingAccount->DepartmentID));
            std::string BankID(1, pTradingAccount->BankID);
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "BankID", BankID.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "BankAccountID", pTradingAccount->BankAccountID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "UnDeliveredFrozenCash",
                                                           pTradingAccount->UnDeliveredFrozenCash));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "UnDeliveredFrozenCommission",
                                                           pTradingAccount->UnDeliveredFrozenCommission));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "UnDeliveredCommission",
                                                           pTradingAccount->UnDeliveredCommission));
            // 两融专用
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "RoyaltyIn",
                                                           pTradingAccount->RoyaltyIn));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "RoyaltyOut",
                                                           pTradingAccount->RoyaltyOut));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "CreditSellAmount",
                                                           pTradingAccount->CreditSellAmount));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "CreditSellUseAmount",
                                                           pTradingAccount->CreditSellUseAmount));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "VirtualAssets",
                                                           pTradingAccount->VirtualAssets));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "CreditSellFrozenAmount",
                                                           pTradingAccount->CreditSellFrozenAmount));

            ACL_VSTRING *buf = acl_json_build(json, NULL);
            logger_debug(DEBUG_TEST3, 2, "%s", acl_vstring_str(buf));
            StpUtil::KafkaOrRedis(TOPIC_TRADING_ACCOUNT, acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
            acl_vstring_free(buf);
            acl_json_free(json);
        }
    }
}

// LOF基金信息查询
int TraderSpi::reqQryLofFundInfo(const char *ExchangeID,const char *FundID,const char *MainFundID)
{
    CTORATstpQryLofFundInfoField req;
    memset(&req, 0, sizeof(req));
    if (ExchangeID != NULL)
    {
        req.ExchangeID = ExchangeID[0];
    }
    if (FundID != NULL)
    {
        strcpy(req.FundID, FundID);
    }
    if (MainFundID != NULL)
    {
        strcpy(req.MainFundID, MainFundID);
    }
    int rt = m_pTraderApi->ReqQryLofFundInfo(&req, 0);
    if(rt == 0) {
        logger("发送查询资金账户请求成功");
    } else if(rt == -1) {
        logger_error("网络连接失败或未登陆");
    } else if(rt == -2) {
        logger_error("超出流控限制");
    } else if(rt == -3 || rt == -5) {
        logger_error("网络写失败");
    }
    return rt;
}

void TraderSpi::OnRspQryLofFundInfo(CTORATstpLofFundInfoField *pLofFundInfo, CTORATstpRspInfoField *pRspInfo, int nRequestID,
                                    bool bIsLast) {
}

int TraderSpi::reqQryUser()
{
    CTORATstpQryUserField req;
    memset(&req, 0, sizeof(req));
//    strcpy(req.UserID, "00318289");
    int rt = m_pTraderApi->ReqQryUser(&req, 0);
    if(rt == 0) {
        logger("发送查询用户请求成功");
    } else if(rt == -1) {
        logger_error("网络连接失败或未登陆");
    } else if(rt == -2) {
        logger_error("超出流控限制");
    } else if(rt == -3 || rt == -5) {
        logger_error("网络写失败");
    }
}

void TraderSpi::OnRspQryUser(CTORATstpUserField *pUserField, CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast) {
    if (bIsLast)
    {
        logger("查询用户结束");
        return;
    }
    if (!isErrorRspInfo(pRspInfoField))
    {
        if (pUserField != NULL)
        {
            std::string UserType(1, pUserField->UserType);
            std::string LoginStatus(1, pUserField->LoginStatus);
            ACL_JSON *json = acl_json_alloc();
            acl_json_node_add_child(json->root, acl_json_create_text(json, "UserID", pUserField->UserID));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "UserName", pUserField->UserName));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "UserType", UserType.c_str()));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "DepartmentID", pUserField->DepartmentID));
            acl_json_node_add_child(json->root, acl_json_create_int64(json, "LoginLimit", pUserField->LoginLimit));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "LoginStatus", LoginStatus.c_str()));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "OpenDate", pUserField->OpenDate));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "CloseDate", pUserField->CloseDate));
            acl_json_node_add_child(json->root, acl_json_create_int64(json, "OrderInsertCommFlux", pUserField->OrderInsertCommFlux));
            acl_json_node_add_child(json->root, acl_json_create_int64(json, "OrderActionCommFlux", pUserField->OrderActionCommFlux));
            ACL_VSTRING *buf = acl_json_build(json, NULL);
            logger_debug(DEBUG_TEST3, 2, "%s", acl_vstring_str(buf));
            acl_vstring_free(buf);
            acl_json_free(json);
        }
    }
}

int TraderSpi::reqQryInvestor()
{
    CTORATstpQryInvestorField req;
    memset(&req, 0, sizeof(req));
//    strcpy(req.InvestorID, "00318289");

    int rt = m_pTraderApi->ReqQryInvestor(&req, 0);
    if(rt == 0) {
        logger("发送查询投资者请求成功");
    } else if(rt == -1) {
        logger_error("网络连接失败或未登陆");
    } else if(rt == -2) {
        logger_error("超出流控限制");
    } else if(rt == -3 || rt == -5) {
        logger_error("网络写失败");
    }
}

void TraderSpi::OnRspQryInvestor(CTORATstpInvestorField *pInvestorField, CTORATstpRspInfoField *pRspInfoField,
                                 int nRequestID, bool bIsLast) {

    if (bIsLast)
    {
        logger("查询投资者结束");
        return;
    }
    if (!isErrorRspInfo(pRspInfoField))
    {
        if (pInvestorField != NULL)
        {
            std::string InvestorType(1, pInvestorField->InvestorType);
            std::string IdCardType(1, pInvestorField->IdCardType);
            std::string TradingStatus(1, pInvestorField->TradingStatus);
            std::string ProfInvestorType(1, pInvestorField->ProfInvestorType);
            std::string PlanType(1, pInvestorField->PlanType);
            ACL_JSON *json = acl_json_alloc();
            acl_json_node_add_child(json->root, acl_json_create_text(json, "InvestorID", pInvestorField->InvestorID));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "InvestorName", pInvestorField->InvestorName));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "InvestorType", InvestorType.c_str()));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "IdCardNo", pInvestorField->IdCardNo));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "IdCardType", IdCardType.c_str()));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "OpenDate", pInvestorField->OpenDate));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "CloseDate", pInvestorField->CloseDate));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "TradingStatus", TradingStatus.c_str()));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "Operways", pInvestorField->Operways));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "Mobile", pInvestorField->Mobile));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "Telephone", pInvestorField->Telephone));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "Email", pInvestorField->Email));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "Fax", pInvestorField->Fax));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "Address", pInvestorField->Address));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "ZipCode", pInvestorField->ZipCode));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "ProfInvestorType", ProfInvestorType.c_str()));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "PlanType", PlanType.c_str()));
            acl_json_node_add_child(json->root, acl_json_create_int64(json, "AllowSelfSwitchPlan", pInvestorField->AllowSelfSwitchPlan));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "Remark", pInvestorField->Remark));
            ACL_VSTRING *buf = acl_json_build(json, NULL);
            logger_debug(DEBUG_TEST3, 2, "%s", acl_vstring_str(buf));
            StpUtil::KafkaOrRedis(TOPIC_INVESTOR_ACCOUNT, acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
            acl_vstring_free(buf);
            acl_json_free(json);
        }
    }
}

// 查询基础交易费率响应
int TraderSpi::reqQryTradingFee(const char *ExchangeID)
{
    CTORATstpQryTradingFeeField req;
    memset(&req, 0, sizeof(req));
    if (ExchangeID != NULL)
    {
        req.ExchangeID = ExchangeID[0];
    }
    int rt = m_pTraderApi->ReqQryTradingFee(&req, 0);
    if(rt == 0) {
        logger("发送查询基础交易费率响应请求成功");
    } else if(rt == -1) {
        logger_error("网络连接失败或未登陆");
    } else if(rt == -2) {
        logger_error("超出流控限制");
    } else if(rt == -3 || rt == -5) {
        logger_error("网络写失败");
    }
}

void TraderSpi::OnRspQryTradingFee(CTORATstpTradingFeeField *pTradingFeeField, CTORATstpRspInfoField *pRspInfoField,
                                   int nRequestID, bool bIsLast) {
    if (bIsLast)
    {
        logger("查询基础交易费率结束");
        return;
    }
    if (!isErrorRspInfo(pRspInfoField))
    {
        if (pTradingFeeField != NULL) {
            std::string ExchangeID(1, pTradingFeeField->ExchangeID);
            std::string ProductID(1, pTradingFeeField->ProductID);
            std::string SecurityType(1, pTradingFeeField->SecurityType);
            std::string BizClass(1, pTradingFeeField->BizClass);
            ACL_JSON *json = acl_json_alloc();
            acl_json_node_add_child(json->root, acl_json_create_text(json, "ExchangeID", ExchangeID.c_str()));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "ProductID", ProductID.c_str()));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "SecurityType", SecurityType.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "SecurityID", pTradingFeeField->SecurityID));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "BizClass", BizClass.c_str()));
            acl_json_node_add_child(json->root, acl_json_create_double(json, "StampTaxRatioByAmt", pTradingFeeField->StampTaxRatioByAmt));
            acl_json_node_add_child(json->root, acl_json_create_double(json, "StampTaxRatioByPar", pTradingFeeField->StampTaxRatioByPar));
            acl_json_node_add_child(json->root, acl_json_create_double(json, "StampTaxFeePerOrder", pTradingFeeField->StampTaxFeePerOrder));
            acl_json_node_add_child(json->root, acl_json_create_double(json, "StampTaxFeeByVolume", pTradingFeeField->StampTaxFeeByVolume));
            acl_json_node_add_child(json->root, acl_json_create_double(json, "StampTaxFeeMin", pTradingFeeField->StampTaxFeeMin));
            acl_json_node_add_child(json->root, acl_json_create_double(json, "StampTaxFeeMax", pTradingFeeField->StampTaxFeeMax));
            acl_json_node_add_child(json->root, acl_json_create_double(json, "TransferRatioByAmt", pTradingFeeField->TransferRatioByAmt));
            acl_json_node_add_child(json->root, acl_json_create_double(json, "TransferRatioByPar", pTradingFeeField->TransferRatioByPar));
            acl_json_node_add_child(json->root, acl_json_create_double(json, "TransferFeePerOrder", pTradingFeeField->TransferFeePerOrder));
            acl_json_node_add_child(json->root, acl_json_create_double(json, "TransferFeeByVolume", pTradingFeeField->TransferFeeByVolume));
            acl_json_node_add_child(json->root, acl_json_create_double(json, "TransferFeeMin", pTradingFeeField->TransferFeeMin));
            acl_json_node_add_child(json->root, acl_json_create_double(json, "TransferFeeMax", pTradingFeeField->TransferFeeMax));
            acl_json_node_add_child(json->root, acl_json_create_double(json, "HandlingRatioByAmt", pTradingFeeField->HandlingRatioByAmt));
            acl_json_node_add_child(json->root, acl_json_create_double(json, "HandlingRatioByPar", pTradingFeeField->HandlingRatioByPar));
            acl_json_node_add_child(json->root, acl_json_create_double(json, "HandlingFeePerOrder", pTradingFeeField->HandlingFeePerOrder));
            acl_json_node_add_child(json->root, acl_json_create_double(json, "HandlingFeeByVolume", pTradingFeeField->HandlingFeeByVolume));
            acl_json_node_add_child(json->root, acl_json_create_double(json, "HandlingFeeMin", pTradingFeeField->HandlingFeeMin));
            acl_json_node_add_child(json->root, acl_json_create_double(json, "HandlingFeeMax", pTradingFeeField->HandlingFeeMax));
            acl_json_node_add_child(json->root, acl_json_create_double(json, "RegulateRatioByAmt", pTradingFeeField->RegulateRatioByAmt));
            acl_json_node_add_child(json->root, acl_json_create_double(json, "RegulateRatioByPar", pTradingFeeField->RegulateRatioByPar));
            acl_json_node_add_child(json->root, acl_json_create_double(json, "RegulateFeePerOrder", pTradingFeeField->RegulateFeePerOrder));
            acl_json_node_add_child(json->root, acl_json_create_double(json, "RegulateFeeByVolume", pTradingFeeField->RegulateFeeByVolume));
            acl_json_node_add_child(json->root, acl_json_create_double(json, "RegulateFeeMin", pTradingFeeField->RegulateFeeMin));
            acl_json_node_add_child(json->root, acl_json_create_double(json, "RegulateFeeMax", pTradingFeeField->RegulateFeeMax));
            acl_json_node_add_child(json->root, acl_json_create_double(json, "SettlementRatioByAmt", pTradingFeeField->SettlementRatioByAmt));
            acl_json_node_add_child(json->root, acl_json_create_double(json, "SettlementRatioByPar", pTradingFeeField->SettlementRatioByPar));
            acl_json_node_add_child(json->root, acl_json_create_double(json, "SettlementFeePerOrder", pTradingFeeField->SettlementFeePerOrder));
            acl_json_node_add_child(json->root, acl_json_create_double(json, "SettlementFeeByVolume", pTradingFeeField->SettlementFeeByVolume));
            acl_json_node_add_child(json->root, acl_json_create_double(json, "SettlementFeeMin", pTradingFeeField->SettlementFeeMin));
            acl_json_node_add_child(json->root, acl_json_create_double(json, "SettlementFeeMax", pTradingFeeField->SettlementFeeMax));
            ACL_VSTRING *buf = acl_json_build(json, NULL);
            logger_debug(DEBUG_TEST3, 2, acl_vstring_str(buf));
            StpUtil::KafkaOrRedis(TOPIC_TRADING_FEE, acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
            acl_vstring_free(buf);
            acl_json_free(json);
        }
    }
}

// 查询佣金费率
int TraderSpi::reqQryInvestorTradingFee(const char *ExchangeID,const char *DepartmentID)
{
    CTORATstpQryInvestorTradingFeeField req;
    memset(&req, 0, sizeof(req));
    strcpy(req.InvestorID, m_pAccount->getInvestorId().c_str());
    if (ExchangeID != NULL)
    {
        req.ExchangeID = ExchangeID[0];
    }
    if (DepartmentID != NULL)
    {
        strcpy(req.DepartmentID, DepartmentID);
    }

    int rt = m_pTraderApi->ReqQryInvestorTradingFee(&req, 0);
    if(rt == 0) {
        logger("发送查询佣金费率请求成功");
    } else if(rt == -1) {
        logger_error("网络连接失败或未登陆");
    } else if(rt == -2) {
        logger_error("超出流控限制");
    } else if(rt == -3 || rt == -5) {
        logger_error("网络写失败");
    }
}

void TraderSpi::OnRspQryInvestorTradingFee(CTORATstpInvestorTradingFeeField *pInvestorTradingFeeField,
                                           CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast)
{
    if (bIsLast)
    {
        logger("查询佣金费率结束");
        return;
    }
    if (!isErrorRspInfo(pRspInfoField))
    {
        if (pInvestorTradingFeeField != NULL) {
            std::string ExchangeID(1, pInvestorTradingFeeField->ExchangeID);
            std::string ProductID(1, pInvestorTradingFeeField->ProductID);
            std::string SecurityType(1, pInvestorTradingFeeField->SecurityType);
            std::string BizClass(1, pInvestorTradingFeeField->BizClass);
            std::string BrokerageType(1, pInvestorTradingFeeField->BrokerageType);
            std::string OrderType(1, pInvestorTradingFeeField->OrderType);
            ACL_JSON *json = acl_json_alloc();
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "InvestorID", pInvestorTradingFeeField->InvestorID));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "ExchangeID", ExchangeID.c_str()));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "ProductID", ProductID.c_str()));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "SecurityType", SecurityType.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "SecurityID", pInvestorTradingFeeField->SecurityID));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "BizClass", BizClass.c_str()));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "BrokerageType", BrokerageType.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "RatioByAmt", pInvestorTradingFeeField->RatioByAmt));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "RatioByPar", pInvestorTradingFeeField->RatioByPar));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "FeePerOrder", pInvestorTradingFeeField->FeePerOrder));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "FeeMin", pInvestorTradingFeeField->FeeMin));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "FeeMax", pInvestorTradingFeeField->FeeMax));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "FeeByVolume", pInvestorTradingFeeField->FeeByVolume));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "DepartmentID", pInvestorTradingFeeField->DepartmentID));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderType", OrderType.c_str()));
            ACL_VSTRING *buf = acl_json_build(json, NULL);
            logger_debug(DEBUG_TEST3, 2, acl_vstring_str(buf));
            StpUtil::KafkaOrRedis(TOPIC_INVESTOR_TRADING_FEE, acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
            acl_vstring_free(buf);
            acl_json_free(json);
        }
    }
}

// 查询报单明细资金
int TraderSpi::reqQryOrderFundDetail()
{
    CTORATstpQryOrderFundDetailField req;
    memset(&req, 0, sizeof(req));
    strcpy(req.InvestorID, m_pAccount->getInvestorId().c_str());
    std::cout << "m_pAccount->getInvestorId().c_str()" << m_pAccount->getInvestorId().c_str() << std::endl;
    int rt = m_pTraderApi->ReqQryOrderFundDetail(&req, 0);
    if(rt == 0) {
        logger("发送查询报单明细资金请求成功");
    } else if(rt == -1) {
        logger_error("网络连接失败或未登陆");
    } else if(rt == -2) {
        logger_error("超出流控限制");
    } else if(rt == -3 || rt == -5) {
        logger_error("网络写失败");
    }
}

void TraderSpi::OnRspQryOrderFundDetail(CTORATstpOrderFundDetailField *pOrderFundDetailField,
                                                        CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast) {
    if (bIsLast)
    {
        logger("查询结束");
        return;
    }
    if (!isErrorRspInfo(pRspInfoField)) {
        if (pOrderFundDetailField != NULL) {
            std::cout << "InvestorID:" << pOrderFundDetailField->InvestorID << ","
             << "SecurityID:" << pOrderFundDetailField->SecurityID << ","
             << "ExchangeID:" << pOrderFundDetailField->ExchangeID << ","
             << "TradingDay:" << pOrderFundDetailField->TradingDay << ","
             << "OrderSysID:" << pOrderFundDetailField->OrderSysID << ","
             << "PbuID:" << pOrderFundDetailField->PbuID << ","
             << "OrderLocalID:" << pOrderFundDetailField->OrderLocalID << ","
             << "BusinessUnitID:" << pOrderFundDetailField->BusinessUnitID << ","
             << "AccountID:" << pOrderFundDetailField->AccountID << ","
             << "OrderAmount:" << pOrderFundDetailField->OrderAmount << ","
             << "Turnover:" << pOrderFundDetailField->Turnover << ","
             << "StampTaxFee:" << pOrderFundDetailField->StampTaxFee << ","
             << "HandlingFee:" << pOrderFundDetailField->HandlingFee << ","
             << "TransferFee:" << pOrderFundDetailField->TransferFee << ","
             << "RegulateFee:" << pOrderFundDetailField->RegulateFee << ","
             << "SettlementFee:" << pOrderFundDetailField->SettlementFee << ","
             << "BrokerageFee:" << pOrderFundDetailField->BrokerageFee << ","
             << "TotalFee:" << pOrderFundDetailField->TotalFee << ","
             << "OrderCashFrozen:" << pOrderFundDetailField->OrderCashFrozen << ","
             << "EstimateCashFrozen:" << pOrderFundDetailField->EstimateCashFrozen << ","
             << "TotalFeeFrozen:" << pOrderFundDetailField->TotalFeeFrozen << ","
             << "TotalFrozen:" << pOrderFundDetailField->TotalFrozen << ","
             << "Margin:" << pOrderFundDetailField->Margin << ","
             << "RepayAmount:" << pOrderFundDetailField->RepayAmount << ","
             << "RepayVolume:" << pOrderFundDetailField-> RepayVolume<< ","
             << "MarginFrozen:" << pOrderFundDetailField->MarginFrozen << ","
             << "CirculateMarginFrozen:" << pOrderFundDetailField->CirculateMarginFrozen << std::endl;
        }
    }
}

bool TraderSpi::isErrorRspInfo(CTORATstpRspInfoField *pRspInfo)
{
    bool bResult = pRspInfo && (pRspInfo->ErrorID != 0);
    if (bResult) {
//        char *err_buf = StpUtil::GB18030ToUTF8(pRspInfo->ErrorMsg, sizeof(pRspInfo->ErrorMsg));
//        logger_error("ErrorID=%d, ErrorMsg=%s", pRspInfo->ErrorID, pRspInfo->ErrorMsg);
//        delete[] err_buf;

        ACL_JSON *json = acl_json_alloc();
        acl_json_node_add_child(json->root,
                                acl_json_create_int64(json, "ErrorMsg", pRspInfo->ErrorID));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "ErrorMsg", pRspInfo->ErrorMsg));
        ACL_VSTRING *buf = acl_json_build(json, NULL);
        char *outbuf = StpUtil::GB18030ToUTF8(acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
        logger_error("%s", outbuf);
        delete[] outbuf;
    }
    return bResult;
}


void TraderSpi::InitDataTypeConst()
{
    // OrderStatus
    DataTypeConst.insert(std::make_pair('0', "预埋"));
    DataTypeConst.insert(std::make_pair('1', "未知"));
    DataTypeConst.insert(std::make_pair('2', "交易所已接收"));
    DataTypeConst.insert(std::make_pair('3', "部分成交"));
    DataTypeConst.insert(std::make_pair('4', "全部成交"));
    DataTypeConst.insert(std::make_pair('5', "部成部撤"));
    DataTypeConst.insert(std::make_pair('6', "全部撤单"));
    DataTypeConst.insert(std::make_pair('7', "交易所已拒绝"));
    DataTypeConst.insert(std::make_pair('#', "发往交易核心"));
}

const char* TraderSpi::GetValue(char key)
{
    auto iter = DataTypeConst.find(key);
    if (iter != DataTypeConst.end()) {
        return (iter->second).c_str();
    } else {
        return "null";
    }
}

void TraderSpi::OnRspUserLogout(CTORATstpUserLogoutField *pUserLogoutField, CTORATstpRspInfoField *pRspInfoField,
                                int nRequestID) {
}

void TraderSpi::OnRspUserPasswordUpdate(CTORATstpUserPasswordUpdateField *pUserPasswordUpdateField,
                                        CTORATstpRspInfoField *pRspInfoField, int nRequestID) {
}

void TraderSpi::OnRspInputDeviceSerial(CTORATstpRspInputDeviceSerialField *pRspInputDeviceSerialField,
                                       CTORATstpRspInfoField *pRspInfoField, int nRequestID) {
}

void TraderSpi::OnRspCondOrderInsert(CTORATstpInputCondOrderField *pInputCondOrderField,
                                     CTORATstpRspInfoField *pRspInfoField, int nRequestID) {
}

void TraderSpi::OnRtnCondOrder(CTORATstpConditionOrderField *pConditionOrderField) {
}

void TraderSpi::OnErrRtnCondOrderInsert(CTORATstpInputCondOrderField *pInputCondOrderField,
                                        CTORATstpRspInfoField *pRspInfoField, int nRequestID) {
}

void TraderSpi::OnRspCondOrderAction(CTORATstpInputCondOrderActionField *pInputCondOrderActionField,
                                     CTORATstpRspInfoField *pRspInfoField, int nRequestID) {
}

void TraderSpi::OnErrRtnCondOrderAction(CTORATstpInputCondOrderActionField *pInputCondOrderActionField,
                                        CTORATstpRspInfoField *pRspInfoField, int nRequestID) {
}

void TraderSpi::OnRspNegoOrderInsert(CTORATstpInputNegoOrderField *pInputNegoOrderField,
                                     CTORATstpRspInfoField *pRspInfoField, int nRequestID) {
}

void TraderSpi::OnRtnNegoOrder(CTORATstpNegoOrderField *pNegoOrderField) {

}

void TraderSpi::OnErrRtnNegoOrderInsert(CTORATstpInputNegoOrderField *pInputNegoOrderField,
                                        CTORATstpRspInfoField *pRspInfoField, int nRequestID) {
}

void TraderSpi::OnRtnNegoTrade(CTORATstpNegoTradeField *pNegoTradeField) {
}

void TraderSpi::OnRspNegoOrderAction(CTORATstpInputNegoOrderActionField *pInputNegoOrderActionField,
                                     CTORATstpRspInfoField *pRspInfoField, int nRequestID) {
}

void TraderSpi::OnErrRtnNegoOrderAction(CTORATstpInputNegoOrderActionField *pInputNegoOrderActionField,
                                        CTORATstpRspInfoField *pRspInfoField, int nRequestID) {
}

void TraderSpi::OnRtnMarketStatus(CTORATstpMarketStatusField *pMarketStatusField) {
}

void TraderSpi::OnRspTransferFund(CTORATstpInputTransferFundField *pInputTransferFundField,
                                  CTORATstpRspInfoField *pRspInfoField, int nRequestID) {
}

void TraderSpi::OnErrRtnTransferFund(CTORATstpInputTransferFundField *pInputTransferFundField,
                                     CTORATstpRspInfoField *pRspInfoField, int nRequestID) {
}

void TraderSpi::OnRtnTransferFund(CTORATstpTransferFundField *pTransferFundField) {
}

void TraderSpi::OnRspTransferPosition(CTORATstpInputTransferPositionField *pInputTransferPositionField,
                                      CTORATstpRspInfoField *pRspInfoField, int nRequestID) {
}

void TraderSpi::OnErrRtnTransferPosition(CTORATstpInputTransferPositionField *pInputTransferPositionField,
                                         CTORATstpRspInfoField *pRspInfoField, int nRequestID) {
}

void TraderSpi::OnRtnTransferPosition(CTORATstpTransferPositionField *pTransferPositionField) {
}

void
TraderSpi::OnRtnPeripheryTransferPosition(CTORATstpPeripheryTransferPositionField *pPeripheryTransferPositionField) {
}

void TraderSpi::OnRtnPeripheryTransferFund(CTORATstpPeripheryTransferFundField *pPeripheryTransferFundField) {
}

void TraderSpi::OnRspInquiryJZFund(CTORATstpRspInquiryJZFundField *pRspInquiryJZFundField,
                                   CTORATstpRspInfoField *pRspInfoField, int nRequestID) {
}

void TraderSpi::OnRspInquiryBankAccountFund(CTORATstpRspInquiryBankAccountFundField *pRspInquiryBankAccountFundField,
                                            CTORATstpRspInfoField *pRspInfoField, int nRequestID) {
}

void TraderSpi::OnRtnTradingNotice(CTORATstpTradingNoticeField *pTradingNoticeField) {
}

void TraderSpi::OnRspInquiryMaxOrderVolume(CTORATstpRspInquiryMaxOrderVolumeField *pRspInquiryMaxOrderVolumeField,
                                           CTORATstpRspInfoField *pRspInfoField, int nRequestID) {
}

void TraderSpi::OnRspInquiryTradeConcentration(CTORATstpInquiryTradeConcentrationField *pInquiryTradeConcentrationField,
                                               CTORATstpRspInfoField *pRspInfoField, int nRequestID) {
}

void TraderSpi::OnRspModifyOpenPosCost(CTORATstpReqModifyOpenPosCostField *pReqModifyOpenPosCostField,
                                       CTORATstpRspInfoField *pRspInfoField, int nRequestID) {
}

void TraderSpi::OnRspInputNodeFundAssignment(CTORATstpInputNodeFundAssignmentField *pInputNodeFundAssignmentField,
                                             CTORATstpRspInfoField *pRspInfoField, int nRequestID) {
    
}

void TraderSpi::OnRspInquiryNodeFundAssignment(
        CTORATstpRspInquiryNodeFundAssignmentField *pRspInquiryNodeFundAssignmentField,
        CTORATstpRspInfoField *pRspInfoField, int nRequestID) {
    
}

void TraderSpi::OnRspQryIPOInfo(CTORATstpIPOInfoField *pIPOInfoField, CTORATstpRspInfoField *pRspInfoField, int nRequestID,
                           bool bIsLast) {
    
}

void TraderSpi::OnRspQryRationalInfo(CTORATstpRationalInfoField *pRationalInfoField, CTORATstpRspInfoField *pRspInfoField,
                                int nRequestID, bool bIsLast) {
    
}

void TraderSpi::OnRspQryIPOQuota(CTORATstpIPOQuotaField *pIPOQuotaField, CTORATstpRspInfoField *pRspInfoField,
                                 int nRequestID, bool bIsLast) {
    
}

void TraderSpi::OnRspQryFundTransferDetail(CTORATstpFundTransferDetailField *pFundTransferDetailField,
                                           CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast) {
    
}

void TraderSpi::OnRspQryPositionTransferDetail(CTORATstpPositionTransferDetailField *pPositionTransferDetailField,
                                               CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast) {
}

void TraderSpi::OnRspQryPeripheryPositionTransferDetail(
        CTORATstpPeripheryPositionTransferDetailField *pPeripheryPositionTransferDetailField,
        CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast) {
}

void TraderSpi::OnRspQryPeripheryFundTransferDetail(
        CTORATstpPeripheryFundTransferDetailField *pPeripheryFundTransferDetailField,
        CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast) {
}

void TraderSpi::OnRspQryBondConversionInfo(CTORATstpBondConversionInfoField *pBondConversionInfoField,
                                           CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast) {
}

void TraderSpi::OnRspQryBondPutbackInfo(CTORATstpBondPutbackInfoField *pBondPutbackInfoField,
                                        CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast) {
}

void TraderSpi::OnRspQryInvestorCondOrderLimitParam(
        CTORATstpInvestorCondOrderLimitParamField *pInvestorCondOrderLimitParamField,
        CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast) {
}

void TraderSpi::OnRspQryConditionOrder(CTORATstpConditionOrderField *pConditionOrderField,
                                       CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast) {
}

void TraderSpi::OnRspQryCondOrderAction(CTORATstpCondOrderActionField *pCondOrderActionField,
                                        CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast) {
}

void
TraderSpi::OnRspQryTradingNotice(CTORATstpTradingNoticeField *pTradingNoticeField, CTORATstpRspInfoField *pRspInfoField,
                                 int nRequestID, bool bIsLast) {
}

void TraderSpi::OnRspQryIPONumberResult(CTORATstpIPONumberResultField *pIPONumberResultField,
                                        CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast) {
    
}

void TraderSpi::OnRspQryIPOMatchNumberResult(CTORATstpIPOMatchNumberResultField *pIPOMatchNumberResultField,
                                             CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast) {
    
}

void TraderSpi::OnRspQryShareholderSpecPrivilege(CTORATstpShareholderSpecPrivilegeField *pShareholderSpecPrivilegeField,
                                                 CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast) {
}

void
TraderSpi::OnRspQryETFFile(CTORATstpETFFileField *pETFFileField, CTORATstpRspInfoField *pRspInfoField, int nRequestID,
                           bool bIsLast) {
    
}

void TraderSpi::OnRspQryETFBasket(CTORATstpETFBasketField *pETFBasketField, CTORATstpRspInfoField *pRspInfoField,
                                  int nRequestID, bool bIsLast) {
    
}

void TraderSpi::OnRspQryInvestorPositionLimit(CTORATstpInvestorPositionLimitField *pInvestorPositionLimitField,
                                              CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast) {
    
}

void
TraderSpi::OnRspQrySZSEImcParams(CTORATstpSZSEImcParamsField *pSZSEImcParamsField, CTORATstpRspInfoField *pRspInfoField,
                                 int nRequestID, bool bIsLast) {
    
}

void TraderSpi::OnRspQrySZSEImcExchangeRate(CTORATstpSZSEImcExchangeRateField *pSZSEImcExchangeRateField,
                                            CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast) {
    
}

void TraderSpi::OnRspQrySZSEHKPriceTickInfo(CTORATstpSZSEHKPriceTickInfoField *pSZSEHKPriceTickInfoField,
                                            CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast) {
    
}

void TraderSpi::OnRspQryPledgePosition(CTORATstpPledgePositionField *pPledgePositionField,
                                       CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast) {
    
}

void TraderSpi::OnRspQryPledgeInfo(CTORATstpPledgeInfoField *pPledgeInfoField, CTORATstpRspInfoField *pRspInfoField,
                                   int nRequestID, bool bIsLast) {
    
}

void TraderSpi::OnRspQrySystemNodeInfo(CTORATstpSystemNodeInfoField *pSystemNodeInfoField,
                                       CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast) {
    
}

void TraderSpi::OnRspQryStandardBondPosition(CTORATstpStandardBondPositionField *pStandardBondPositionField,
                                             CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast) {
    
}

void TraderSpi::OnRspQryPrematurityRepoOrder(CTORATstpPrematurityRepoOrderField *pPrematurityRepoOrderField,
                                             CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast) {
    
}

void TraderSpi::OnRspQryNegoOrder(CTORATstpNegoOrderField *pNegoOrderField, CTORATstpRspInfoField *pRspInfoField,
                                  int nRequestID, bool bIsLast) {
    
}

void TraderSpi::OnRspQryNegoOrderAction(CTORATstpNegoOrderActionField *pNegoOrderActionField,
                                        CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast) {
    
}

void TraderSpi::OnRspQryNegoTrade(CTORATstpNegoTradeField *pNegoTradeField, CTORATstpRspInfoField *pRspInfoField,
                                  int nRequestID, bool bIsLast) {
    
}

void TraderSpi::OnRspQryNegotiationParam(CTORATstpNegotiationParamField *pNegotiationParamField,
                                         CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast) {
    
}