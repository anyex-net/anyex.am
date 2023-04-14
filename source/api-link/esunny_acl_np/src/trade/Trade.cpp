//
// Created by root on 8/4/21.
//

#include "trade/Trade.h"
#include "TapAPIError.h"
#include <iostream>
#include <string.h>
#include <json/acl_json.h>
#include <sstream>
#include "common/EsunnyUtil.h"

using namespace std;

const char* TOPIC_QRYEXCHANGE = "NpTopicQryExchangeInfo";
const char* TOPIC_QRYACCOUNT = "NpTopicQryAccountInfo";
const char* TOPIC_QRYCOMMODITY = "NpTopicQryCommodityInfo";
const char* TOPIC_QRYCONTRACT = "NpTopicQryContractInfo";
const char* TOPIC_QRYFUND = "NpTopicFundData";
const char* TOPIC_ORDER = "NpTopicOrderInfo";
const char* TOPIC_POSITION = "NpTopicPositionInfo";
const char* TOPIC_CLOSE = "NpTopicCloseInfo";
const char* TOPIC_FILL = "NpTopicFillInfo";
const char* TOPIC_QRYACCOUNTRENT = "NpTopicQryAccountRentInfo";

Trade::Trade(void):
        m_pAPI(NULL),
        m_bIsAPIReady(false),
        m_reasonCode(0)
{
}

Trade::~Trade(void)
{
}

void Trade::SetAPI(ITapTradeAPI *pAPI)
{
    m_pAPI = pAPI;
}

void Trade::setAccount(std::shared_ptr<Account> account)
{
    m_pAccount = account;
}

int Trade:: RunTrade()
{
    logger("AccountNo(%s) RunTrade start", m_pAccount->getAccountNo());
    if(NULL == m_pAPI) {
        logger_error("Error: m_pAPI i s NULL.");
        return -19002;
    }

    TAPIINT32 iErr = TAPIERROR_SUCCEED;
    //设定服务器IP、端口
    if (this->m_reasonCode == 0) {
        iErr = m_pAPI->SetHostAddress(m_pAccount->getIp(), m_pAccount->getPort());
        if(TAPIERROR_SUCCEED != iErr) {
            logger_error("SetHostAddress Error: %d", iErr);
            return iErr;
        }
    }

    //登录服务器
    logger("登录服务器");
    TapAPITradeLoginAuth stLoginAuth;
    // 定义结构体之后建议进行初始化，以免内存乱数据影响结果
    memset(&stLoginAuth, 0, sizeof(stLoginAuth));
    strcpy(stLoginAuth.UserNo, m_pAccount->getAccountNo());
    strcpy(stLoginAuth.Password, m_pAccount->getPassword());
    strcpy(stLoginAuth.AuthCode, m_pAccount->getAuthCode());
    strcpy(stLoginAuth.AppID, m_pAccount->getAppID());
    stLoginAuth.ISModifyPassword = APIYNFLAG_NO;
    stLoginAuth.ISDDA = APIYNFLAG_NO;
    iErr = m_pAPI->Login(&stLoginAuth);
    if(TAPIERROR_SUCCEED != iErr) {
        logger_error("Login Error: %d", iErr);
        return iErr;
    }

    //等待APIReady
    // 先执行WaitEvent()，锁定；API准备就绪或登录为成功执行SignalEvent()接触锁定，最后while(true)锁定
    m_Event.WaitEvent();
    if(!m_bIsAPIReady){
        logger_error("%s'API is not ready", m_pAccount->getAccountNo());
        return -1;
    }

//    this->t_qryFund();
//    this->t_qryOrder("A");
//    this->t_qryFill();
//    this->t_qryPosition();
//    this->t_qryClose();
//    this->t_qryAccountRent()

    while (true)
    {
        m_Event.WaitEvent();
        return 0;
    }
}

void TAP_CDECL Trade::OnConnect()
{
    logger("网络连接成功");
}

void TAP_CDECL Trade::OnRspLogin( TAPIINT32 errorCode, const TapAPITradeLoginRspInfo *loginRspInfo )
{
    if(TAPIERROR_SUCCEED == errorCode) {
        logger("%s 登录成功，等待API初始化...", m_pAccount->getAccountNo());
    } else if(TAPIERROR_LOGIN_DDA == errorCode) {
        logger_error("需要进行二次验证");
    } else {
        logger_error("%s 登录失败，错误码:: %d", m_pAccount->getAccountNo(), errorCode);
        m_Event.SignalEvent();
    }
}

void TAP_CDECL Trade::OnAPIReady()
{
    // 在APIReady中，API自动进行基础数据查询和缓存，缓存的有权限、品种、合约、委托、成交、持仓等等
    logger("%s API初始化完成", m_pAccount->getAccountNo());
    m_bIsAPIReady = true;
    m_Event.SignalEvent();
}

void TAP_CDECL Trade::OnDisconnect( TAPIINT32 reasonCode )
{
    logger_error("%s API断开,断开原因: %d", m_pAccount->getAccountNo(), reasonCode);
    // 解除锁定，TradeThread.cpp 中while(true) 进入循环，重新执行RunTrade，保证重连线程一致
    this->m_reasonCode = reasonCode;
    m_bIsAPIReady = false;
    m_Event.SignalEvent();
}


/// 交易
// 下单
int Trade::t_insertOrder(const char* ExchangeNo,const char* CommodityNo,const char* ContractNo,
                            const char* OrderType,const char* TimeInForce,const char* ExpireTime,
                            const char* OrderSide,const char* PositionEffect,const char* OrderPrice,
                            const char* OrderQty, const char* RefString)
{
    TapAPINewOrder stNewOrder;
    memset(&stNewOrder, 0, sizeof(stNewOrder));

    strcpy(stNewOrder.AccountNo, m_pAccount->getAccountNo());
    strcpy(stNewOrder.ExchangeNo, ExchangeNo);
    stNewOrder.CommodityType = TAPI_COMMODITY_TYPE_FUTURES;
    strcpy(stNewOrder.CommodityNo, CommodityNo);
    strcpy(stNewOrder.ContractNo, ContractNo);
    strcpy(stNewOrder.StrikePrice, "");
    stNewOrder.CallOrPutFlag = TAPI_CALLPUT_FLAG_NONE;
    strcpy(stNewOrder.ContractNo2, "");
    strcpy(stNewOrder.StrikePrice2, "");
    stNewOrder.CallOrPutFlag2 = TAPI_CALLPUT_FLAG_NONE;
    stNewOrder.OrderType = OrderType[0];
    stNewOrder.OrderSource = TAPI_ORDER_SOURCE_ESUNNY_API;
    stNewOrder.TimeInForce = TimeInForce[0];
    strcpy(stNewOrder.ExpireTime, "");
    if (ExpireTime != NULL)
    {
        strcpy(stNewOrder.ExpireTime, ExpireTime);
    }
    stNewOrder.IsRiskOrder = APIYNFLAG_NO;
    stNewOrder.OrderSide = OrderSide[0];
    stNewOrder.PositionEffect = PositionEffect[0];
    stNewOrder.PositionEffect2 = TAPI_PositionEffect_NONE;
    strcpy(stNewOrder.InquiryNo,"");
    stNewOrder.HedgeFlag = TAPI_HEDGEFLAG_T;
    if (OrderPrice != NULL)
    {
        stNewOrder.OrderPrice = atof(OrderPrice);
    }
    stNewOrder.OrderPrice2;
    stNewOrder.StopPrice;
    stNewOrder.OrderQty = atoi(OrderQty);
    stNewOrder.OrderMinQty ;
    stNewOrder.MinClipSize;
    stNewOrder.MaxClipSize;
    stNewOrder.RefInt;
    if (RefString != NULL)
    {
        strcpy(stNewOrder.RefString, RefString);
    }
    stNewOrder.TacticsType = TAPI_TACTICS_TYPE_NONE;
    stNewOrder.TriggerCondition = TAPI_TRIGGER_CONDITION_NONE;
    stNewOrder.TriggerPriceType = TAPI_TRIGGER_PRICE_NONE;
    stNewOrder.AddOneIsValid = APIYNFLAG_NO;
    stNewOrder.OrderQty2;
    stNewOrder.HedgeFlag2 = TAPI_HEDGEFLAG_NONE;
    stNewOrder.MarketLevel = TAPI_MARKET_LEVEL_0;
    stNewOrder.FutureAutoCloseFlag = APIYNFLAG_NO; // V9.0.2.0 20150520

    TAPIINT32 iErr = TAPIERROR_SUCCEED;
    m_uiSessionID = 0;
    iErr = m_pAPI->InsertOrder(&m_uiSessionID, &stNewOrder);
    if(TAPIERROR_SUCCEED != iErr) {
        logger_error("InsertOrder Error: %d", iErr);
    }
    return iErr;
}

// 撤单
int Trade::t_cancelOrder(const char* OrderNo)
{
    logger_debug(DEBUG_TEST2, 2, "*************** t_cancelOrder **************");

    TapAPIOrderCancelReq req;
    memset(&req,0,sizeof(req));
    strncpy(req.OrderNo, OrderNo, strlen(OrderNo));

    TAPIINT32 iErr = TAPIERROR_SUCCEED;
    TAPIUINT32 reqid = 0;
    iErr = m_pAPI->CancelOrder(&reqid,&req);
    if(iErr!= TAPIERROR_SUCCEED){
        logger_error("CancelOrder errorCode: %d", iErr);
    }
    return iErr;
}

void TAP_CDECL Trade::OnRspOrderAction( TAPIUINT32 sessionID, TAPIUINT32 errorCode, const TapAPIOrderActionRsp *info )
{
    if (errorCode != TAPIERROR_SUCCEED)
    {
        logger_error("OnRspOrderAction failed, errorCode: %d", errorCode);
    }

    if (NULL != info) {
        if (NULL != info->OrderInfo) {
            logger("操作类型 = %c", info->ActionType);
            std::string CommodityType(1, info->OrderInfo->CommodityType);
            std::string CallOrPutFlag(1, info->OrderInfo->CallOrPutFlag);
            std::string CallOrPutFlag2(1, info->OrderInfo->CallOrPutFlag2);
            std::string OrderType(1, info->OrderInfo->OrderType);
            std::string OrderSource(1, info->OrderInfo->OrderSource);
            std::string TimeInForce(1, info->OrderInfo->TimeInForce);
            std::string IsRiskOrder(1, info->OrderInfo->IsRiskOrder);
            std::string OrderSide(1, info->OrderInfo->OrderSide);
            std::string PositionEffect(1, info->OrderInfo->PositionEffect);
            std::string PositionEffect2(1, info->OrderInfo->PositionEffect2);
            std::string HedgeFlag(1, info->OrderInfo->HedgeFlag);
            std::string IsBackInput(1, info->OrderInfo->IsBackInput);
            std::string IsDeleted(1, info->OrderInfo->IsDeleted);
            std::string IsAddOne(1, info->OrderInfo->IsAddOne);
            std::string OrderState(1, info->OrderInfo->OrderState);
            std::string TriggerPriceType(1, info->OrderInfo->TriggerPriceType);
            std::string TriggerCondition(1, info->OrderInfo->TriggerCondition);
            std::string TacticsType(1, info->OrderInfo->TacticsType);
            std::string AddOneIsValid(1, info->OrderInfo->AddOneIsValid);
            std::string ServerFlag(1, info->OrderInfo->ServerFlag);
            ACL_JSON* json = acl_json_alloc();
            acl_json_node_add_child(json->root, acl_json_create_text(json, "AccountNo", info->OrderInfo->AccountNo));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "ExchangeNo", info->OrderInfo->ExchangeNo));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityType", CommodityType.c_str()));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityNo", info->OrderInfo->CommodityNo));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "ContractNo", info->OrderInfo->ContractNo));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "StrikePrice", info->OrderInfo->StrikePrice));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "CallOrPutFlag", CallOrPutFlag.c_str()));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "ContractNo2", info->OrderInfo->ContractNo2));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "StrikePrice2", info->OrderInfo->StrikePrice2));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "CallOrPutFlag2", CallOrPutFlag2.c_str()));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderType", OrderType.c_str()));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderSource", OrderSource.c_str()));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "TimeInForce", TimeInForce.c_str()));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "ExpireTime", info->OrderInfo->ExpireTime));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "IsRiskOrder", IsRiskOrder.c_str()));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderSide", OrderSide.c_str()));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "PositionEffect", PositionEffect.c_str()));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "PositionEffect2", PositionEffect2.c_str()));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "HedgeFlag", HedgeFlag.c_str()));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "InquiryNo", info->OrderInfo->InquiryNo));
            acl_json_node_add_child(json->root, acl_json_create_double(json, "OrderPrice", info->OrderInfo->OrderPrice));
            acl_json_node_add_child(json->root, acl_json_create_double(json, "OrderPrice2", info->OrderInfo->OrderPrice2));
            acl_json_node_add_child(json->root, acl_json_create_double(json, "StopPrice", info->OrderInfo->StopPrice));
            acl_json_node_add_child(json->root, acl_json_create_int64(json, "OrderQty", info->OrderInfo->OrderQty));
            acl_json_node_add_child(json->root, acl_json_create_int64(json, "OrderMinQty", info->OrderInfo->OrderMinQty));
            acl_json_node_add_child(json->root, acl_json_create_int64(json, "OrderCanceledQty", info->OrderInfo->OrderCanceledQty));
            acl_json_node_add_child(json->root, acl_json_create_int64(json, "RefInt", info->OrderInfo->RefInt));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "RefString", info->OrderInfo->RefString));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "ParentAccountNo", info->OrderInfo->ParentAccountNo));
            acl_json_node_add_child(json->root, acl_json_create_int64(json, "MinClipSize", info->OrderInfo->MinClipSize));
            acl_json_node_add_child(json->root, acl_json_create_int64(json, "MaxClipSize", info->OrderInfo->MaxClipSize));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "LicenseNo", info->OrderInfo->LicenseNo));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "ServerFlag", ServerFlag.c_str()));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderNo", info->OrderInfo->OrderNo));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "ClientOrderNo", info->OrderInfo->ClientOrderNo));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderParentNo", info->OrderInfo->OrderParentNo));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "TradeNo", info->OrderInfo->TradeNo));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "TacticsType", TacticsType.c_str()));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "TriggerCondition", TriggerCondition.c_str()));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "TriggerPriceType", TriggerPriceType.c_str()));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "AddOneIsValid", AddOneIsValid.c_str()));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "ClientLocalIP", info->OrderInfo->UpperSettleNo));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "ClientMac", info->OrderInfo->UpperUserNo));
            acl_json_node_add_child(json->root, acl_json_create_int64(json, "OrderStreamID", info->OrderInfo->OrderStreamID));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "UpperNo", info->OrderInfo->UpperNo));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "UpperChannelNo", info->OrderInfo->UpperChannelNo));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderLocalNo", info->OrderInfo->OrderLocalNo));
            acl_json_node_add_child(json->root, acl_json_create_int64(json, "UpperStreamID", info->OrderInfo->UpperStreamID));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderSystemNo", info->OrderInfo->OrderSystemNo));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderExchangeSystemNo", info->OrderInfo->OrderExchangeSystemNo));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderParentSystemNo", info->OrderInfo->OrderParentSystemNo));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderInsertUserNo", info->OrderInfo->OrderInsertUserNo));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderInsertTime", info->OrderInfo->OrderInsertTime));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderCommandUserNo", info->OrderInfo->OrderCommandUserNo));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderUpdateUserNo", info->OrderInfo->OrderUpdateUserNo));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderUpdateTime", info->OrderInfo->OrderUpdateTime));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderState", OrderState.c_str()));
            acl_json_node_add_child(json->root, acl_json_create_double(json, "OrderMatchPrice", info->OrderInfo->OrderMatchPrice));
            acl_json_node_add_child(json->root, acl_json_create_double(json, "OrderMatchPrice2", info->OrderInfo->OrderMatchPrice2));
            acl_json_node_add_child(json->root, acl_json_create_int64(json, "OrderMatchQty", info->OrderInfo->OrderMatchQty));
            acl_json_node_add_child(json->root, acl_json_create_int64(json, "OrderMatchQty2", info->OrderInfo->OrderMatchQty2));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "IsBackInput", IsBackInput.c_str()));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "IsDeleted", IsDeleted.c_str()));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "IsAddOne", IsAddOne.c_str()));
            acl_json_node_add_child(json->root, acl_json_create_int64(json, "ErrorCode", info->OrderInfo->ErrorCode));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "ErrorText", info->OrderInfo->ErrorText));
            std::string FeeMode(1, info->OrderInfo->FeeMode);
            std::string FeeMode2(1, info->OrderInfo->FeeMode2);
            std::string MarginMode(1, info->OrderInfo->MarginMode);
            std::string MarginMode2(1, info->OrderInfo->MarginMode2);
            std::string HedgeFlag2(1, info->OrderInfo->HedgeFlag2);
            std::string MarketLevel(1, info->OrderInfo->MarketLevel);
            std::string OrderDeleteByDisConnFlag(1, info->OrderInfo->OrderDeleteByDisConnFlag);
            acl_json_node_add_child(json->root, acl_json_create_double(json, "ContractSize", info->OrderInfo->ContractSize));
            acl_json_node_add_child(json->root, acl_json_create_double(json, "ContractSize2", info->OrderInfo->ContractSize2));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityCurrencyGroup", info->OrderInfo->CommodityCurrencyGroup));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityCurrency", info->OrderInfo->CommodityCurrency));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "FeeMode", FeeMode.c_str()));
            acl_json_node_add_child(json->root, acl_json_create_double(json, "FeeParam", info->OrderInfo->FeeParam));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "FeeCurrencyGroup", info->OrderInfo->FeeCurrencyGroup));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "FeeCurrency", info->OrderInfo->FeeCurrency));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "FeeMode2", FeeMode2.c_str()));
            acl_json_node_add_child(json->root, acl_json_create_double(json, "FeeParam2", info->OrderInfo->FeeParam2));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "FeeCurrencyGroup2", info->OrderInfo->FeeCurrencyGroup2));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "FeeCurrency2", info->OrderInfo->FeeCurrency2));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "MarginMode", MarginMode.c_str()));
            acl_json_node_add_child(json->root, acl_json_create_double(json, "MarginParam", info->OrderInfo->MarginParam));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "MarginMode2", MarginMode2.c_str()));
            acl_json_node_add_child(json->root, acl_json_create_double(json, "MarginParam2", info->OrderInfo->MarginParam2));
            acl_json_node_add_child(json->root, acl_json_create_double(json, "PreSettlePrice", info->OrderInfo->PreSettlePrice));
            acl_json_node_add_child(json->root, acl_json_create_double(json, "PreSettlePrice2", info->OrderInfo->PreSettlePrice2));
            acl_json_node_add_child(json->root, acl_json_create_int64(json, "OpenVol", info->OrderInfo->OpenVol));
            acl_json_node_add_child(json->root, acl_json_create_int64(json, "CoverVol", info->OrderInfo->CoverVol));
            acl_json_node_add_child(json->root, acl_json_create_int64(json, "OpenVol2", info->OrderInfo->OpenVol2));
            acl_json_node_add_child(json->root, acl_json_create_int64(json, "CoverVol2", info->OrderInfo->CoverVol2));
            acl_json_node_add_child(json->root, acl_json_create_double(json, "FeeValue", info->OrderInfo->FeeValue));
            acl_json_node_add_child(json->root, acl_json_create_double(json, "MarginValue", info->OrderInfo->MarginValue));
            acl_json_node_add_child(json->root, acl_json_create_int64(json, "OrderQty2", info->OrderInfo->OrderQty2));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "HedgeFlag2", HedgeFlag2.c_str()));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "MarketLevel", MarketLevel.c_str()));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderDeleteByDisConnFlag", OrderDeleteByDisConnFlag.c_str()));
            ACL_VSTRING *buf = acl_json_build(json, NULL);
            char *outbuf = EsunnyUtil::EsunnyConvert(acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
            logger_debug(DEBUG_TEST3, 2, "%s", outbuf);
            EsunnyUtil::KafkaOrRedis(TOPIC_ORDER, outbuf, strlen(outbuf));
            delete[] outbuf;
            acl_vstring_free(buf);
            acl_json_free(json);
        } else {
            logger_error("OrderInfo 为空");
            // 订单信息指针部分情况下可能为空，如果为空，可以通过sessionID找到对应请求获取请求类型
            logger("sessionID = %d", sessionID);
        }
    } else {
        logger_error("info 为空");
    }
}

void TAP_CDECL Trade::OnRtnOrder( const TapAPIOrderInfoNotice *info )
{
    if(NULL == info)
    {
        logger_error("info is NULL");
        return;
    }

    if (info->ErrorCode != 0)
    {
        logger_error("服务器返回了一个关于委托信息的错误: %d", info->ErrorCode);
    }
    else
    {
        if (info->OrderInfo != NULL)
        {
            logger("SessionID=%d; m_uiSessionID=%d", info->SessionID, m_uiSessionID);
//            if (info->SessionID == m_uiSessionID)
//            {
                if (0!= info->OrderInfo->ErrorCode)
                {
                    logger_error("报单失败, 错误码: %d, 委托编号: %s", info->OrderInfo->ErrorCode, info->OrderInfo->OrderNo);
                }
                else
                {
                    logger("报单成功, 状态: %c, 委托编号: %s", info->OrderInfo->OrderState, info->OrderInfo->OrderNo);
                }
//                m_Event.SignalEvent();
//            }
        }
    }

    if (info->OrderInfo != NULL)
    {
        std::string CommodityType(1, info->OrderInfo->CommodityType);
        std::string CallOrPutFlag(1, info->OrderInfo->CallOrPutFlag);
        std::string CallOrPutFlag2(1, info->OrderInfo->CallOrPutFlag2);
        std::string OrderType(1, info->OrderInfo->OrderType);
        std::string OrderSource(1, info->OrderInfo->OrderSource);
        std::string TimeInForce(1, info->OrderInfo->TimeInForce);
        std::string IsRiskOrder(1, info->OrderInfo->IsRiskOrder);
        std::string OrderSide(1, info->OrderInfo->OrderSide);
        std::string PositionEffect(1, info->OrderInfo->PositionEffect);
        std::string PositionEffect2(1, info->OrderInfo->PositionEffect2);
        std::string HedgeFlag(1, info->OrderInfo->HedgeFlag);
        std::string IsBackInput(1, info->OrderInfo->IsBackInput);
        std::string IsDeleted(1, info->OrderInfo->IsDeleted);
        std::string IsAddOne(1, info->OrderInfo->IsAddOne);
        std::string OrderState(1, info->OrderInfo->OrderState);
        std::string TriggerPriceType(1, info->OrderInfo->TriggerPriceType);
        std::string TriggerCondition(1, info->OrderInfo->TriggerCondition);
        std::string TacticsType(1, info->OrderInfo->TacticsType);
        std::string AddOneIsValid(1, info->OrderInfo->AddOneIsValid);
        std::string ServerFlag(1, info->OrderInfo->ServerFlag);
        ACL_JSON* json = acl_json_alloc();
        acl_json_node_add_child(json->root, acl_json_create_int64(json, "SessionID", info->SessionID));
        acl_json_node_add_child(json->root, acl_json_create_int64(json, "ErrorCode", info->ErrorCode));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "AccountNo", info->OrderInfo->AccountNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "ExchangeNo", info->OrderInfo->ExchangeNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityType", CommodityType.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityNo", info->OrderInfo->CommodityNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "ContractNo", info->OrderInfo->ContractNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "StrikePrice", info->OrderInfo->StrikePrice));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "CallOrPutFlag", CallOrPutFlag.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "ContractNo2", info->OrderInfo->ContractNo2));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "StrikePrice2", info->OrderInfo->StrikePrice2));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "CallOrPutFlag2", CallOrPutFlag2.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderType", OrderType.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderSource", OrderSource.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "TimeInForce", TimeInForce.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "ExpireTime", info->OrderInfo->ExpireTime));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "IsRiskOrder", IsRiskOrder.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderSide", OrderSide.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "PositionEffect", PositionEffect.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "PositionEffect2", PositionEffect2.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "HedgeFlag", HedgeFlag.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "InquiryNo", info->OrderInfo->InquiryNo));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "OrderPrice", info->OrderInfo->OrderPrice));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "OrderPrice2", info->OrderInfo->OrderPrice2));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "StopPrice", info->OrderInfo->StopPrice));
        acl_json_node_add_child(json->root, acl_json_create_int64(json, "OrderQty", info->OrderInfo->OrderQty));
        acl_json_node_add_child(json->root, acl_json_create_int64(json, "OrderMinQty", info->OrderInfo->OrderMinQty));
        acl_json_node_add_child(json->root, acl_json_create_int64(json, "OrderCanceledQty", info->OrderInfo->OrderCanceledQty));
        acl_json_node_add_child(json->root, acl_json_create_int64(json, "RefInt", info->OrderInfo->RefInt));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "RefString", info->OrderInfo->RefString));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "ParentAccountNo", info->OrderInfo->ParentAccountNo));
        acl_json_node_add_child(json->root, acl_json_create_int64(json, "MinClipSize", info->OrderInfo->MinClipSize));
        acl_json_node_add_child(json->root, acl_json_create_int64(json, "MaxClipSize", info->OrderInfo->MaxClipSize));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "LicenseNo", info->OrderInfo->LicenseNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "ServerFlag", ServerFlag.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderNo", info->OrderInfo->OrderNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "ClientOrderNo", info->OrderInfo->ClientOrderNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderParentNo", info->OrderInfo->OrderParentNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "TradeNo", info->OrderInfo->TradeNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "TacticsType", TacticsType.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "TriggerCondition", TriggerCondition.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "TriggerPriceType", TriggerPriceType.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "AddOneIsValid", AddOneIsValid.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "UpperSettleNo", info->OrderInfo->UpperSettleNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "UpperUserNo", info->OrderInfo->UpperUserNo));
        acl_json_node_add_child(json->root, acl_json_create_int64(json, "OrderStreamID", info->OrderInfo->OrderStreamID));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "UpperNo", info->OrderInfo->UpperNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "UpperChannelNo", info->OrderInfo->UpperChannelNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderLocalNo", info->OrderInfo->OrderLocalNo));
        acl_json_node_add_child(json->root, acl_json_create_int64(json, "UpperStreamID", info->OrderInfo->UpperStreamID));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderSystemNo", info->OrderInfo->OrderSystemNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderExchangeSystemNo", info->OrderInfo->OrderExchangeSystemNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderParentSystemNo", info->OrderInfo->OrderParentSystemNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderInsertUserNo", info->OrderInfo->OrderInsertUserNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderInsertTime", info->OrderInfo->OrderInsertTime));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderCommandUserNo", info->OrderInfo->OrderCommandUserNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderUpdateUserNo", info->OrderInfo->OrderUpdateUserNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderUpdateTime", info->OrderInfo->OrderUpdateTime));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderState", OrderState.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "OrderMatchPrice", info->OrderInfo->OrderMatchPrice));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "OrderMatchPrice2", info->OrderInfo->OrderMatchPrice2));
        acl_json_node_add_child(json->root, acl_json_create_int64(json, "OrderMatchQty", info->OrderInfo->OrderMatchQty));
        acl_json_node_add_child(json->root, acl_json_create_int64(json, "OrderMatchQty2", info->OrderInfo->OrderMatchQty2));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "IsBackInput", IsBackInput.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "IsDeleted", IsDeleted.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "IsAddOne", IsAddOne.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_int64(json, "ErrorCode", info->OrderInfo->ErrorCode));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "ErrorText", info->OrderInfo->ErrorText));

        std::string FeeMode(1, info->OrderInfo->FeeMode);
        std::string FeeMode2(1, info->OrderInfo->FeeMode2);
        std::string MarginMode(1, info->OrderInfo->MarginMode);
        std::string MarginMode2(1, info->OrderInfo->MarginMode2);
        std::string HedgeFlag2(1, info->OrderInfo->HedgeFlag2);
        std::string MarketLevel(1, info->OrderInfo->MarketLevel);
        std::string OrderDeleteByDisConnFlag(1, info->OrderInfo->OrderDeleteByDisConnFlag);
        acl_json_node_add_child(json->root, acl_json_create_double(json, "ContractSize", info->OrderInfo->ContractSize));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "ContractSize2", info->OrderInfo->ContractSize2));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityCurrencyGroup", info->OrderInfo->CommodityCurrencyGroup));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityCurrency", info->OrderInfo->CommodityCurrency));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "FeeMode", FeeMode.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "FeeParam", info->OrderInfo->FeeParam));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "FeeCurrencyGroup", info->OrderInfo->FeeCurrencyGroup));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "FeeCurrency", info->OrderInfo->FeeCurrency));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "FeeMode2", FeeMode2.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "FeeParam2", info->OrderInfo->FeeParam2));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "FeeCurrencyGroup2", info->OrderInfo->FeeCurrencyGroup2));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "FeeCurrency2", info->OrderInfo->FeeCurrency2));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "MarginMode", MarginMode.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "MarginParam", info->OrderInfo->MarginParam));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "MarginMode2", MarginMode2.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "MarginParam2", info->OrderInfo->MarginParam2));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "PreSettlePrice", info->OrderInfo->PreSettlePrice));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "PreSettlePrice2", info->OrderInfo->PreSettlePrice2));
        acl_json_node_add_child(json->root, acl_json_create_int64(json, "OpenVol", info->OrderInfo->OpenVol));
        acl_json_node_add_child(json->root, acl_json_create_int64(json, "CoverVol", info->OrderInfo->CoverVol));
        acl_json_node_add_child(json->root, acl_json_create_int64(json, "OpenVol2", info->OrderInfo->OpenVol2));
        acl_json_node_add_child(json->root, acl_json_create_int64(json, "CoverVol2", info->OrderInfo->CoverVol2));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "FeeValue", info->OrderInfo->FeeValue));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "MarginValue", info->OrderInfo->MarginValue));
        acl_json_node_add_child(json->root, acl_json_create_int64(json, "OrderQty2", info->OrderInfo->OrderQty2));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "HedgeFlag2", HedgeFlag2.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "MarketLevel", MarketLevel.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderDeleteByDisConnFlag", OrderDeleteByDisConnFlag.c_str()));

        std::cout << "RefString=" << info->OrderInfo->RefString << std::endl;

        ACL_VSTRING* buf = acl_json_build(json, NULL);
        char *outbuf = EsunnyUtil::EsunnyConvert(acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
        logger_debug(DEBUG_TEST3, 2, "%s", outbuf);
        EsunnyUtil::KafkaOrRedis(TOPIC_ORDER, outbuf, strlen(outbuf));
        delete[] outbuf;
        acl_vstring_free(buf);
        acl_json_free(json);
    }
}

void TAP_CDECL Trade::OnRtnFill( const TapAPIFillInfo *info )
{
    if(NULL == info)
    {
        logger_error("info is NULL");
        return;
    }

    std::string CommodityType(1, info->CommodityType);
    std::string CallOrPutFlag(1, info->CallOrPutFlag);
    std::string MatchSide(1, info->MatchSide);
    std::string ServerFlag(1, info->ServerFlag);
    std::string MatchSource(1, info->MatchSource);
    std::string PositionEffect(1, info->PositionEffect);
    std::string IsDeleted(1, info->IsDeleted);
    std::string IsAddOne(1, info->IsAddOne);
    std::string IsManualFee(1, info->IsManualFee);
    ACL_JSON* json = acl_json_alloc();
    acl_json_node_add_child(json->root, acl_json_create_text(json, "AccountNo", info->AccountNo));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "ExchangeNo", info->ExchangeNo));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityType", CommodityType.c_str()));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityNo", info->CommodityNo));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "ContractNo", info->ContractNo));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "StrikePrice", info->StrikePrice));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "CallOrPutFlag", CallOrPutFlag.c_str()));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "MatchSource", MatchSource.c_str()));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "MatchSide", MatchSide.c_str()));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "PositionEffect", PositionEffect.c_str()));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "ServerFlag", ServerFlag.c_str()));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderNo", info->OrderNo));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "MatchNo", info->MatchNo));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "ExchangeMatchNo", info->ExchangeMatchNo));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "MatchDateTime", info->MatchDateTime));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "UpperMatchDateTime", info->UpperMatchDateTime));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "UpperNo", info->UpperNo));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "MatchPrice", info->MatchPrice));
    acl_json_node_add_child(json->root, acl_json_create_int64(json, "MatchQty", info->MatchQty));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "IsDeleted", IsDeleted.c_str()));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "IsAddOne", IsAddOne.c_str()));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "FeeCurrencyGroup", info->FeeCurrencyGroup));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "FeeCurrency", info->FeeCurrency));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "FeeValue", info->FeeValue));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "IsManualFee", IsManualFee.c_str()));
    std::string CommodityTypeRef(1, info->CommodityTypeRef);
    std::string CallOrPutFlagRef(1, info->CallOrPutFlagRef);
    std::string OrderCommodityType(1, info->OrderCommodityType);
    std::string OrderType(1, info->OrderType);
    std::string TimeInForce(1, info->TimeInForce);
    std::string IsRiskOrder(1, info->IsRiskOrder);
    std::string PositionEffectRef(1, info->PositionEffectRef);
    std::string IsBackInput(1, info->IsBackInput);
    std::string OpenCloseMode(1, info->OpenCloseMode);
    std::string FeeMode(1, info->FeeMode);
    std::string HedgeFlag(1, info->HedgeFlag);
    acl_json_node_add_child(json->root, acl_json_create_text(json, "ParentAccountNo", info->ParentAccountNo));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "ExchangeNoRef", info->ExchangeNoRef));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityTypeRef", CommodityTypeRef.c_str()));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityNoRef", info->CommodityNoRef));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "ContractNoRef", info->ContractNoRef));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "StrikePriceRef", info->StrikePriceRef));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "CallOrPutFlagRef", CallOrPutFlagRef.c_str()));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderExchangeNo", info->OrderExchangeNo));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderCommodityType", OrderCommodityType.c_str()));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderCommodityNo", info->OrderCommodityNo));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderType", OrderType.c_str()));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "TimeInForce", TimeInForce.c_str()));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "ExpireTime", info->ExpireTime));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "IsRiskOrder", IsRiskOrder.c_str()));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "PositionEffectRef", PositionEffectRef.c_str()));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "HedgeFlag", HedgeFlag.c_str()));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderLocalNo", info->OrderLocalNo));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "UpperChannelNo", info->UpperChannelNo));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "UpperSettleNo", info->UpperSettleNo));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "UpperUserNo", info->UpperUserNo));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "TradeNo", info->TradeNo));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "IsBackInput", IsBackInput.c_str()));
    acl_json_node_add_child(json->root, acl_json_create_int64(json, "MatchStreamID", info->MatchStreamID));
    acl_json_node_add_child(json->root, acl_json_create_int64(json, "UpperStreamID", info->UpperStreamID));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "OpenCloseMode", OpenCloseMode.c_str()));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "ContractSize", info->ContractSize));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityCurrencyGroup", info->CommodityCurrencyGroup));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityCurrency", info->CommodityCurrency));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "FeeMode", FeeMode.c_str()));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "FeeParam", info->FeeParam));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "PreSettlePrice", info->PreSettlePrice));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "Turnover", info->Turnover));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "PremiumIncome", info->PremiumIncome));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "PremiumPay", info->PremiumPay));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "OppoMatchNo", info->OppoMatchNo));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "CloseProfit", info->CloseProfit));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "UnExpProfit", info->UnExpProfit));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "UpperMatchPrice", info->UpperMatchPrice));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "QuotePrice", info->QuotePrice));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "ClosePL", info->ClosePL));
    ACL_VSTRING* buf = acl_json_build(json, NULL);
    logger_debug(DEBUG_TEST3, 2, "%s", acl_vstring_str(buf));
    EsunnyUtil::KafkaOrRedis(TOPIC_FILL, acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
    acl_vstring_free(buf);
    acl_json_free(json);
}

void TAP_CDECL Trade::OnRtnPosition( const TapAPIPositionInfo *info )
{
    if (info == NULL)
    {
        logger_error("Position is NULL");
        return;
    }

    std::string CommodityType(1, info->CommodityType);
    std::string CallOrPutFlag(1, info->CallOrPutFlag);
    std::string MatchSide(1, info->MatchSide);
    std::string HedgeFlag(1, info->HedgeFlag);
    std::string ServerFlag(1, info->ServerFlag);
    std::string IsHistory(1, info->IsHistory);
    ACL_JSON* json = acl_json_alloc();
    acl_json_node_add_child(json->root, acl_json_create_text(json, "AccountNo", info->AccountNo));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "ExchangeNo", info->ExchangeNo));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityType", CommodityType.c_str()));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityNo", info->CommodityNo));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "ContractNo", info->ContractNo));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "StrikePrice", info->StrikePrice));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "CallOrPutFlag", CallOrPutFlag.c_str()));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "MatchSide", MatchSide.c_str()));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "HedgeFlag", HedgeFlag.c_str()));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "PositionNo", info->PositionNo));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "ServerFlag", ServerFlag.c_str()));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderNo", info->OrderNo));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "MatchNo", info->MatchNo));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "UpperNo", info->UpperNo));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "PositionPrice", info->PositionPrice));
    acl_json_node_add_child(json->root, acl_json_create_int64(json, "PositionQty", info->PositionQty));
    acl_json_node_add_child(json->root, acl_json_create_int64(json, "PositionStreamId", info->PositionStreamId));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityCurrencyGroup", info->CommodityCurrencyGroup));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityCurrency", info->CommodityCurrency));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "AccountInitialMargin", info->AccountInitialMargin));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "AccountMaintenanceMargin", info->AccountMaintenanceMargin));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "UpperInitialMargin", info->UpperInitialMargin));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "UpperMaintenanceMargin", info->UpperMaintenanceMargin));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "PositionProfit", info->PositionProfit));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "LMEPositionProfit", info->LMEPositionProfit));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "OptionMarketValue", info->OptionMarketValue));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "IsHistory", IsHistory.c_str()));
    std::string CommodityTypeRef(1, info->CommodityTypeRef);
    std::string CallOrPutFlagRef(1, info->CallOrPutFlagRef);
    std::string OrderCommodityType(1, info->OrderCommodityType);
    std::string OrderType(1, info->OrderType);
    std::string TimeInForce(1, info->TimeInForce);
    std::string IsBackInput(1, info->IsBackInput);
    std::string OpenCloseMode(1, info->OpenCloseMode);
    std::string MatchSource(1, info->MatchSource);
    std::string IsAddOne(1, info->IsAddOne);
    std::string AccountMarginMode(1, info->AccountMarginMode);
    std::string UpperMarginMode(1, info->UpperMarginMode);
    acl_json_node_add_child(json->root, acl_json_create_text(json, "ParentAccountNo", info->ParentAccountNo));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "ExchangeNoRef", info->ExchangeNoRef));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityTypeRef", CommodityTypeRef.c_str()));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityNoRef", info->CommodityNoRef));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "ContractNoRef", info->ContractNoRef));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "StrikePriceRef", info->StrikePriceRef));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "CallOrPutFlagRef", CallOrPutFlagRef.c_str()));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderExchangeNo", info->OrderExchangeNo));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderCommodityType", OrderCommodityType.c_str()));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderCommodityNo", info->OrderCommodityNo));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderType", OrderType.c_str()));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "TimeInForce", TimeInForce.c_str()));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "ExpireTime", info->ExpireTime));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "UpperSettleNo", info->UpperSettleNo));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "UpperUserNo", info->UpperUserNo));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "TradeNo", info->TradeNo));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "IsBackInput", IsBackInput.c_str()));
    acl_json_node_add_child(json->root, acl_json_create_int64(json, "MatchStreamID", info->MatchStreamID));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "OpenCloseMode", OpenCloseMode.c_str()));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "ContractSize", info->ContractSize));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityCurrencyGroup", info->CommodityCurrencyGroup));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityCurrency", info->CommodityCurrency));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "PreSettlePrice", info->PreSettlePrice));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "Turnover", info->Turnover));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "MatchSource", MatchSource.c_str()));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "ExchangeMatchNo", info->ExchangeMatchNo));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "MatchDate", info->MatchDate));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "MatchTime", info->MatchTime));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "UpperMatchTime", info->UpperMatchTime));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "IsAddOne", IsAddOne.c_str()));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "SettlePrice", info->SettlePrice));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "AccountMarginMode", AccountMarginMode.c_str()));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "AccountMarginParam", info->AccountMarginParam));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "UpperMarginMode", UpperMarginMode.c_str()));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "UpperMarginParam", info->UpperMarginParam));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "QuotePrice", info->MatchCmbNo));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "FloatingPL", info->FloatingPL));
    ACL_VSTRING* buf = acl_json_build(json, NULL);
    logger_debug(DEBUG_TEST3, 2, "%s", acl_vstring_str(buf));
    EsunnyUtil::KafkaOrRedis(TOPIC_POSITION, acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
    acl_vstring_free(buf);
    acl_json_free(json);
}

void TAP_CDECL Trade::OnRtnClose( const TapAPICloseInfo *info )
{
    if (info == NULL)
    {
        logger_error("Position is NULL");
        return;
    }

    std::string CommodityType(1, info->CommodityType);
    std::string CallOrPutFlag(1, info->CallOrPutFlag);
    std::string OpenOrderCommodityType(1, info->OpenOrderCommodityType);
    std::string CloseOrderCommodityType(1, info->CloseOrderCommodityType);
    std::string OpenMatchSource(1, info->OpenMatchSource);
    std::string CloseMatchSource(1, info->CloseMatchSource);
    std::string CloseSide(1, info->CloseSide);
    std::string OpenServerFlag(1, info->OpenServerFlag);
    std::string CloseServerFlag(1, info->CloseServerFlag);
    ACL_JSON* json = acl_json_alloc();
    acl_json_node_add_child(json->root, acl_json_create_text(json, "AccountNo", info->AccountNo));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "ExchangeNo", info->ExchangeNo));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityType", CommodityType.c_str()));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityNo", info->CommodityNo));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "ContractNo", info->ContractNo));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "StrikePrice", info->StrikePrice));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "CallOrPutFlag", CallOrPutFlag.c_str()));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "OpenOrderExchangeNo", info->OpenOrderExchangeNo));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "OpenOrderCommodityType", OpenOrderCommodityType.c_str()));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "OpenOrderCommodityNo", info->OpenOrderCommodityNo));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "CloseOrderExchangeNo", info->CloseOrderExchangeNo));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "CloseOrderCommodityType", CloseOrderCommodityType.c_str()));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "CloseOrderCommodityNo", info->CloseOrderCommodityNo));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "OpenMatchSource", OpenMatchSource.c_str()));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "CloseMatchSource", CloseMatchSource.c_str()));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "CloseSide", CloseSide.c_str()));
    acl_json_node_add_child(json->root, acl_json_create_int64(json, "CloseQty", info->CloseQty));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "OpenPrice", info->OpenPrice));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "ClosePrice", info->ClosePrice));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "OpenServerFlag", OpenServerFlag.c_str()));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "OpenOrderNo", info->OpenOrderNo));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "OpenMatchNo", info->OpenMatchNo));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "OpenExchangeMatchNo", info->OpenExchangeMatchNo));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "OpenMatchDateTime", info->OpenMatchDateTime));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "CloseServerFlag", CloseServerFlag.c_str()));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "CloseOrderNo", info->CloseOrderNo));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "CloseMatchNo", info->CloseMatchNo));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "CloseExchangeMatchNo", info->CloseExchangeMatchNo));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "CloseMatchDateTime", info->CloseMatchDateTime));
    acl_json_node_add_child(json->root, acl_json_create_int64(json, "CloseStreamId", info->CloseStreamId));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityCurrencyGroup", info->CommodityCurrencyGroup));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityCurrency", info->CommodityCurrency));
    std::string OpenCloseMode(1, info->OpenCloseMode);
    acl_json_node_add_child(json->root, acl_json_create_text(json, "ParentAccountNo", info->ParentAccountNo));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "OpenCloseMode", OpenCloseMode.c_str()));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "ContractSize", info->ContractSize));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityCurrencyGroup", info->CommodityCurrencyGroup));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityCurrency", info->CommodityCurrency));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "PreSettlePrice", info->PreSettlePrice));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "PremiumIncome", info->PremiumIncome));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "PremiumPay", info->PremiumPay));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "CloseProfit", info->CloseProfit));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "UnExpProfit", info->UnExpProfit));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "ClosePL", info->ClosePL));
    ACL_VSTRING* buf = acl_json_build(json, NULL);
    logger_debug(DEBUG_TEST3, 2, "%s", acl_vstring_str(buf));
    EsunnyUtil::KafkaOrRedis(TOPIC_CLOSE, acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
    acl_vstring_free(buf);
    acl_json_free(json);
}

void TAP_CDECL Trade::OnRtnFund( const TapAPIFundData *info )
{
    if(NULL == info){
        logger_error("info is NULL");
        return;
    }

    std::string FutureAlg(1, info->FutureAlg);
    std::string OptionAlg(1, info->OptionAlg);
    ACL_JSON* json = acl_json_alloc();
    acl_json_node_add_child(json->root, acl_json_create_text(json, "AccountNo", info->AccountNo));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "CurrencyGroupNo", info->CurrencyGroupNo));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "CurrencyNo", info->CurrencyNo));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "TradeRate", info->TradeRate));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "FutureAlg", FutureAlg.c_str()));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "OptionAlg", OptionAlg.c_str()));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "PreBalance", info->PreBalance));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "PreUnExpProfit", info->PreUnExpProfit));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "PreLMEPositionProfit", info->PreLMEPositionProfit));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "PreEquity", info->PreEquity));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "PreAvailable1", info->PreAvailable1));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "PreMarketEquity", info->PreMarketEquity));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "CashInValue", info->CashInValue));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "CashOutValue", info->CashOutValue));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "CashAdjustValue", info->CashAdjustValue));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "CashPledged", info->CashPledged));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "FrozenFee", info->FrozenFee));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "FrozenDeposit", info->FrozenDeposit));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "AccountFee", info->AccountFee));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "PremiumIncome", info->PremiumIncome));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "PremiumPay", info->PremiumPay));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "CloseProfit", info->CloseProfit));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "UnExpProfit", info->UnExpProfit));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "ExpProfit", info->ExpProfit));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "PositionProfit", info->PositionProfit));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "LmePositionProfit", info->LmePositionProfit));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "OptionMarketValue", info->OptionMarketValue));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "AccountIntialMargin", info->AccountIntialMargin));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "AccountMaintenanceMargin", info->AccountMaintenanceMargin));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "UpperInitalMargin", info->UpperInitalMargin));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "UpperMaintenanceMargin", info->UpperMaintenanceMargin));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "Discount", info->Discount));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "Balance", info->Balance));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "Equity", info->Equity));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "Available", info->Available));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "CanDraw", info->CanDraw));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "MarketEquity", info->MarketEquity));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "ParentAccountNo", info->ParentAccountNo));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "ExchangeFee", info->ExchangeFee));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "AccountDeliveryFee", info->AccountDeliveryFee));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "DeliveryProfit", info->DeliveryProfit));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "OriginalCashInOut", info->OriginalCashInOut));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "FloatingPL", info->FloatingPL));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "FrozenRiskFundValue", info->FrozenRiskFundValue));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "ClosePL", info->ClosePL));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "NoCurrencyPledgeValue", info->NoCurrencyPledgeValue));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "PrePledgeValue", info->PrePledgeValue));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "PledgeIn", info->PledgeIn));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "PledgeOut", info->PledgeOut));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "PledgeValue", info->PledgeValue));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "BorrowValue", info->BorrowValue));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "SpecialAccountFrozenMargin", info->SpecialAccountFrozenMargin));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "SpecialAccountMargin", info->SpecialAccountMargin));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "SpecialAccountFrozenFee", info->SpecialAccountFrozenFee));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "SpecialAccountFee", info->SpecialAccountFee));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "SpecialFloatProfit", info->SpecialFloatProfit));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "SpecialCloseProfit", info->SpecialCloseProfit));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "SpecialFloatPL", info->SpecialFloatPL));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "SpecialClosePL", info->SpecialClosePL));
    ACL_VSTRING* buf = acl_json_build(json, NULL);
//    logger_debug(DEBUG_TEST3, 2, "%s", acl_vstring_str(buf));
    EsunnyUtil::KafkaOrRedis(TOPIC_QRYFUND, acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
    acl_vstring_free(buf);
    acl_json_free(json);
}

void TAP_CDECL Trade::OnRtnPositionProfit( const TapAPIPositionProfitNotice *info )
{
    if (info->IsLast == 'Y') return;
    if (info != NULL) {
        std::string IsLast(1, info->IsLast);
        ACL_JSON* json = acl_json_alloc();
        acl_json_node_add_child(json->root, acl_json_create_text(json, "IsLast", IsLast.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "PositionNo", info->Data->PositionNo));
        acl_json_node_add_child(json->root, acl_json_create_int64(json, "PositionStreamId", info->Data->PositionStreamId));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "PositionProfit", info->Data->PositionProfit));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "LMEPositionProfit", info->Data->LMEPositionProfit));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "OptionMarketValue", info->Data->OptionMarketValue));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "CalculatePrice", info->Data->CalculatePrice));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "FloatingPL", info->Data->FloatingPL));
        ACL_VSTRING* buf = acl_json_build(json, NULL);
        char *outbuf = EsunnyUtil::EsunnyConvert(acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
//        logger("%s", outbuf);
        EsunnyUtil::KafkaOrRedis(TOPIC_POSITION, outbuf, strlen(outbuf));
        delete[] outbuf;
        acl_vstring_free(buf);
        acl_json_free(json);
    }
}

/// 交易查询

int Trade::t_qryOrder(const char *OrderQryType)
{
    logger_debug(DEBUG_TEST2, 2, "*************** t_qryOrder **************");

    TapAPIOrderQryReq qryReq;
    memset(&qryReq, 0, sizeof(qryReq));
    if (OrderQryType != NULL)
    qryReq.OrderQryType = OrderQryType[0];

    TAPIINT32 iErr = TAPIERROR_SUCCEED;
    TAPIUINT32 reqid = 0;
    iErr = m_pAPI->QryOrder(&reqid, &qryReq);

    if (iErr != TAPIERROR_SUCCEED) {
        logger_error("QryOrder failed, errorCode: %d", iErr);
    }
    std::cout << "m_uiSessionID= " << m_uiSessionID << std::endl;
    return iErr;
}

void TAP_CDECL Trade::OnRspQryOrder( TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPIOrderInfo *info )
{
    std::cout << "sessionID= " << sessionID << std::endl;
    if (errorCode != TAPIERROR_SUCCEED)
    {
        logger_error("OnRspQryOrder, errorCode: %d", errorCode);
    }

    if (NULL != info) {
        std::string CommodityType(1, info->CommodityType);
        std::string CallOrPutFlag(1, info->CallOrPutFlag);
        std::string CallOrPutFlag2(1, info->CallOrPutFlag2);
        std::string OrderType(1, info->OrderType);
        std::string OrderSource(1, info->OrderSource);
        std::string TimeInForce(1, info->TimeInForce);
        std::string IsRiskOrder(1, info->IsRiskOrder);
        std::string OrderSide(1, info->OrderSide);
        std::string PositionEffect(1, info->PositionEffect);
        std::string PositionEffect2(1, info->PositionEffect2);
        std::string HedgeFlag(1, info->HedgeFlag);
        std::string IsBackInput(1, info->IsBackInput);
        std::string IsDeleted(1, info->IsDeleted);
        std::string IsAddOne(1, info->IsAddOne);
        std::string OrderState(1, info->OrderState);
        std::string TriggerPriceType(1, info->TriggerPriceType);
        std::string TriggerCondition(1, info->TriggerCondition);
        std::string TacticsType(1, info->TacticsType);
        std::string AddOneIsValid(1, info->AddOneIsValid);
        std::string ServerFlag(1, info->ServerFlag);
        ACL_JSON* json = acl_json_alloc();
        acl_json_node_add_child(json->root, acl_json_create_text(json, "AccountNo", info->AccountNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "ExchangeNo", info->ExchangeNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityType", CommodityType.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityNo", info->CommodityNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "ContractNo", info->ContractNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "StrikePrice", info->StrikePrice));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "CallOrPutFlag", CallOrPutFlag.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "ContractNo2", info->ContractNo2));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "StrikePrice2", info->StrikePrice2));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "CallOrPutFlag2", CallOrPutFlag2.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderType", OrderType.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderSource", OrderSource.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "TimeInForce", TimeInForce.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "ExpireTime", info->ExpireTime));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "IsRiskOrder", IsRiskOrder.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderSide", OrderSide.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "PositionEffect", PositionEffect.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "PositionEffect2", PositionEffect2.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "HedgeFlag", HedgeFlag.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "InquiryNo", info->InquiryNo));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "OrderPrice", info->OrderPrice));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "OrderPrice2", info->OrderPrice2));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "StopPrice", info->StopPrice));
        acl_json_node_add_child(json->root, acl_json_create_int64(json, "OrderQty", info->OrderQty));
        acl_json_node_add_child(json->root, acl_json_create_int64(json, "OrderMinQty", info->OrderMinQty));
        acl_json_node_add_child(json->root, acl_json_create_int64(json, "OrderCanceledQty", info->OrderCanceledQty));
        acl_json_node_add_child(json->root, acl_json_create_int64(json, "RefInt", info->RefInt));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "RefString", info->RefString));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "ParentAccountNo", info->ParentAccountNo));
        acl_json_node_add_child(json->root, acl_json_create_int64(json, "MinClipSize", info->MinClipSize));
        acl_json_node_add_child(json->root, acl_json_create_int64(json, "MaxClipSize", info->MaxClipSize));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "LicenseNo", info->LicenseNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "ServerFlag", ServerFlag.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderNo", info->OrderNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "ClientOrderNo", info->ClientOrderNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderParentNo", info->OrderParentNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "TradeNo", info->TradeNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "TacticsType", TacticsType.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "TriggerCondition", TriggerCondition.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "TriggerPriceType", TriggerPriceType.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "AddOneIsValid", AddOneIsValid.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "UpperSettleNo", info->UpperSettleNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "UpperUserNo", info->UpperUserNo));
        acl_json_node_add_child(json->root, acl_json_create_int64(json, "OrderStreamID", info->OrderStreamID));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "UpperNo", info->UpperNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "UpperChannelNo", info->UpperChannelNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderLocalNo", info->OrderLocalNo));
        acl_json_node_add_child(json->root, acl_json_create_int64(json, "UpperStreamID", info->UpperStreamID));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderSystemNo", info->OrderSystemNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderExchangeSystemNo", info->OrderExchangeSystemNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderParentSystemNo", info->OrderParentSystemNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderInsertUserNo", info->OrderInsertUserNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderInsertTime", info->OrderInsertTime));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderCommandUserNo", info->OrderCommandUserNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderUpdateUserNo", info->OrderUpdateUserNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderUpdateTime", info->OrderUpdateTime));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderState", OrderState.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "OrderMatchPrice", info->OrderMatchPrice));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "OrderMatchPrice2", info->OrderMatchPrice2));
        acl_json_node_add_child(json->root, acl_json_create_int64(json, "OrderMatchQty", info->OrderMatchQty));
        acl_json_node_add_child(json->root, acl_json_create_int64(json, "OrderMatchQty2", info->OrderMatchQty2));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "IsBackInput", IsBackInput.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "IsDeleted", IsDeleted.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "IsAddOne", IsAddOne.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_int64(json, "ErrorCode", info->ErrorCode));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "ErrorText", info->ErrorText));
        std::string FeeMode(1, info->FeeMode);
        std::string FeeMode2(1, info->FeeMode2);
        std::string MarginMode(1, info->MarginMode);
        std::string MarginMode2(1, info->MarginMode2);
        std::string HedgeFlag2(1, info->HedgeFlag2);
        std::string MarketLevel(1, info->MarketLevel);
        std::string OrderDeleteByDisConnFlag(1, info->OrderDeleteByDisConnFlag);
        acl_json_node_add_child(json->root, acl_json_create_double(json, "ContractSize", info->ContractSize));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "ContractSize2", info->ContractSize2));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityCurrencyGroup", info->CommodityCurrencyGroup));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityCurrency", info->CommodityCurrency));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "FeeMode", FeeMode.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "FeeParam", info->FeeParam));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "FeeCurrencyGroup", info->FeeCurrencyGroup));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "FeeCurrency", info->FeeCurrency));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "FeeMode2", FeeMode2.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "FeeParam2", info->FeeParam2));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "FeeCurrencyGroup2", info->FeeCurrencyGroup2));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "FeeCurrency2", info->FeeCurrency2));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "MarginMode", MarginMode.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "MarginParam", info->MarginParam));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "MarginMode2", MarginMode2.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "MarginParam2", info->MarginParam2));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "PreSettlePrice", info->PreSettlePrice));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "PreSettlePrice2", info->PreSettlePrice2));
        acl_json_node_add_child(json->root, acl_json_create_int64(json, "OpenVol", info->OpenVol));
        acl_json_node_add_child(json->root, acl_json_create_int64(json, "CoverVol", info->CoverVol));
        acl_json_node_add_child(json->root, acl_json_create_int64(json, "OpenVol2", info->OpenVol2));
        acl_json_node_add_child(json->root, acl_json_create_int64(json, "CoverVol2", info->CoverVol2));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "FeeValue", info->FeeValue));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "MarginValue", info->MarginValue));
        acl_json_node_add_child(json->root, acl_json_create_int64(json, "OrderQty2", info->OrderQty2));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "HedgeFlag2", HedgeFlag2.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "MarketLevel", MarketLevel.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderDeleteByDisConnFlag", OrderDeleteByDisConnFlag.c_str()));

        std::cout << "RefString=" << info->RefString << std::endl;
        ACL_VSTRING *buf = acl_json_build(json, NULL);
        char *outbuf = EsunnyUtil::EsunnyConvert(acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
        logger_debug(DEBUG_TEST3, 2, "%s", outbuf);
//        logger_debug(DEBUG_TEST3, 2, "%s", acl_vstring_str(buf));
        EsunnyUtil::KafkaOrRedis(TOPIC_ORDER, outbuf, strlen(outbuf));
//        EsunnyUtil::KafkaOrRedis(TOPIC_FILL, acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
//        delete[] outbuf;
        acl_vstring_free(buf);
        acl_json_free(json);
    } else {
        logger_error("info 为空");
    }
    if (isLast == 'Y')
    {
        logger("数据推送结束");
        return;
    }
}

int Trade::t_qryFill()
{
    logger_debug(DEBUG_TEST2, 2, "*************** t_qryFill **************");

    TapAPIFillQryReq qryReq;
    memset(&qryReq, 0, sizeof(qryReq));

    TAPIINT32 iErr = TAPIERROR_SUCCEED;
    TAPIUINT32 reqid = 0;
    iErr = m_pAPI->QryFill(&reqid, &qryReq);
    if (iErr != TAPIERROR_SUCCEED) {
        logger_error("QryFill failed, errorCode: %d", iErr);
    }
    return iErr;
}

void TAP_CDECL Trade::OnRspQryFill( TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPIFillInfo *info )
{
    if (info != NULL)
    {
        std::string CommodityType(1, info->CommodityType);
        std::string CallOrPutFlag(1, info->CallOrPutFlag);
        std::string MatchSide(1, info->MatchSide);
        std::string ServerFlag(1, info->ServerFlag);
        std::string MatchSource(1, info->MatchSource);
        std::string PositionEffect(1, info->PositionEffect);
        std::string IsDeleted(1, info->IsDeleted);
        std::string IsAddOne(1, info->IsAddOne);
        std::string IsManualFee(1, info->IsManualFee);
        ACL_JSON* json = acl_json_alloc();
        acl_json_node_add_child(json->root, acl_json_create_text(json, "AccountNo", info->AccountNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "ExchangeNo", info->ExchangeNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityType", CommodityType.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityNo", info->CommodityNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "ContractNo", info->ContractNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "StrikePrice", info->StrikePrice));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "CallOrPutFlag", CallOrPutFlag.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "MatchSource", MatchSource.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "MatchSide", MatchSide.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "PositionEffect", PositionEffect.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "ServerFlag", ServerFlag.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderNo", info->OrderNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "MatchNo", info->MatchNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "ExchangeMatchNo", info->ExchangeMatchNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "MatchDateTime", info->MatchDateTime));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "UpperMatchDateTime", info->UpperMatchDateTime));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "UpperNo", info->UpperNo));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "MatchPrice", info->MatchPrice));
        acl_json_node_add_child(json->root, acl_json_create_int64(json, "MatchQty", info->MatchQty));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "IsDeleted", IsDeleted.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "IsAddOne", IsAddOne.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "FeeCurrencyGroup", info->FeeCurrencyGroup));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "FeeCurrency", info->FeeCurrency));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "FeeValue", info->FeeValue));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "IsManualFee", IsManualFee.c_str()));
        std::string CommodityTypeRef(1, info->CommodityTypeRef);
        std::string CallOrPutFlagRef(1, info->CallOrPutFlagRef);
        std::string OrderCommodityType(1, info->OrderCommodityType);
        std::string OrderType(1, info->OrderType);
        std::string TimeInForce(1, info->TimeInForce);
        std::string IsRiskOrder(1, info->IsRiskOrder);
        std::string PositionEffectRef(1, info->PositionEffectRef);
        std::string IsBackInput(1, info->IsBackInput);
        std::string OpenCloseMode(1, info->OpenCloseMode);
        std::string FeeMode(1, info->FeeMode);
        std::string HedgeFlag(1, info->HedgeFlag);
        acl_json_node_add_child(json->root, acl_json_create_text(json, "ParentAccountNo", info->ParentAccountNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "ExchangeNoRef", info->ExchangeNoRef));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityTypeRef", CommodityTypeRef.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityNoRef", info->CommodityNoRef));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "ContractNoRef", info->ContractNoRef));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "StrikePriceRef", info->StrikePriceRef));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "CallOrPutFlagRef", CallOrPutFlagRef.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderExchangeNo", info->OrderExchangeNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderCommodityType", OrderCommodityType.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderCommodityNo", info->OrderCommodityNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderType", OrderType.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "TimeInForce", TimeInForce.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "ExpireTime", info->ExpireTime));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "IsRiskOrder", IsRiskOrder.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "PositionEffectRef", PositionEffectRef.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "HedgeFlag", HedgeFlag.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderLocalNo", info->OrderLocalNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "UpperChannelNo", info->UpperChannelNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "UpperSettleNo", info->UpperSettleNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "UpperUserNo", info->UpperUserNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "TradeNo", info->TradeNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "IsBackInput", IsBackInput.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_int64(json, "MatchStreamID", info->MatchStreamID));
        acl_json_node_add_child(json->root, acl_json_create_int64(json, "UpperStreamID", info->UpperStreamID));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "OpenCloseMode", OpenCloseMode.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "ContractSize", info->ContractSize));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityCurrencyGroup", info->CommodityCurrencyGroup));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityCurrency", info->CommodityCurrency));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "FeeMode", FeeMode.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "FeeParam", info->FeeParam));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "PreSettlePrice", info->PreSettlePrice));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "Turnover", info->Turnover));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "PremiumIncome", info->PremiumIncome));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "PremiumPay", info->PremiumPay));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "OppoMatchNo", info->OppoMatchNo));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "CloseProfit", info->CloseProfit));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "UnExpProfit", info->UnExpProfit));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "UpperMatchPrice", info->UpperMatchPrice));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "QuotePrice", info->QuotePrice));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "ClosePL", info->ClosePL));
        ACL_VSTRING* buf = acl_json_build(json, NULL);
        logger_debug(DEBUG_TEST3, 2, "%s", acl_vstring_str(buf));
        EsunnyUtil::KafkaOrRedis(TOPIC_FILL, acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
        acl_vstring_free(buf);
        acl_json_free(json);
    }
    if (isLast == 'Y')
    {
        logger("数据推送结束");
        return;
    }
}

int Trade::t_qryPosition()
{
    logger_debug(DEBUG_TEST2, 2, "*************** t_qryPosition **************");

    TapAPIPositionQryReq qryReq;
    memset(&qryReq, 0, sizeof(qryReq));
    TAPIINT32 iErr = TAPIERROR_SUCCEED;
    TAPIUINT32 reqid = 0;
    iErr = m_pAPI->QryPosition(&reqid, &qryReq);
    if (iErr != TAPIERROR_SUCCEED) {
        logger_error("QryPosition failed, errorCode: %d", iErr);
    }
    return iErr;
}

void TAP_CDECL Trade::OnRspQryPosition( TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPIPositionInfo *info )
{
    if (info != NULL)
    {
        std::string CommodityType(1, info->CommodityType);
        std::string CallOrPutFlag(1, info->CallOrPutFlag);
        std::string MatchSide(1, info->MatchSide);
        std::string HedgeFlag(1, info->HedgeFlag);
        std::string ServerFlag(1, info->ServerFlag);
        std::string IsHistory(1, info->IsHistory);
        ACL_JSON* json = acl_json_alloc();
        acl_json_node_add_child(json->root, acl_json_create_text(json, "AccountNo", info->AccountNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "ExchangeNo", info->ExchangeNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityType", CommodityType.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityNo", info->CommodityNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "ContractNo", info->ContractNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "StrikePrice", info->StrikePrice));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "CallOrPutFlag", CallOrPutFlag.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "MatchSide", MatchSide.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "HedgeFlag", HedgeFlag.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "PositionNo", info->PositionNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "ServerFlag", ServerFlag.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderNo", info->OrderNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "MatchNo", info->MatchNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "UpperNo", info->UpperNo));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "PositionPrice", info->PositionPrice));
        acl_json_node_add_child(json->root, acl_json_create_int64(json, "PositionQty", info->PositionQty));
        acl_json_node_add_child(json->root, acl_json_create_int64(json, "PositionStreamId", info->PositionStreamId));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityCurrencyGroup", info->CommodityCurrencyGroup));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityCurrency", info->CommodityCurrency));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "AccountInitialMargin", info->AccountInitialMargin));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "AccountMaintenanceMargin", info->AccountMaintenanceMargin));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "UpperInitialMargin", info->UpperInitialMargin));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "UpperMaintenanceMargin", info->UpperMaintenanceMargin));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "PositionProfit", info->PositionProfit));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "LMEPositionProfit", info->LMEPositionProfit));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "OptionMarketValue", info->OptionMarketValue));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "IsHistory", IsHistory.c_str()));
        std::string CommodityTypeRef(1, info->CommodityTypeRef);
        std::string CallOrPutFlagRef(1, info->CallOrPutFlagRef);
        std::string OrderCommodityType(1, info->OrderCommodityType);
        std::string OrderType(1, info->OrderType);
        std::string TimeInForce(1, info->TimeInForce);
        std::string IsBackInput(1, info->IsBackInput);
        std::string OpenCloseMode(1, info->OpenCloseMode);
        std::string MatchSource(1, info->MatchSource);
        std::string IsAddOne(1, info->IsAddOne);
        std::string AccountMarginMode(1, info->AccountMarginMode);
        std::string UpperMarginMode(1, info->UpperMarginMode);
        acl_json_node_add_child(json->root, acl_json_create_text(json, "ParentAccountNo", info->ParentAccountNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "ExchangeNoRef", info->ExchangeNoRef));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityTypeRef", CommodityTypeRef.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityNoRef", info->CommodityNoRef));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "ContractNoRef", info->ContractNoRef));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "StrikePriceRef", info->StrikePriceRef));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "CallOrPutFlagRef", CallOrPutFlagRef.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderExchangeNo", info->OrderExchangeNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderCommodityType", OrderCommodityType.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderCommodityNo", info->OrderCommodityNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderType", OrderType.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "TimeInForce", TimeInForce.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "ExpireTime", info->ExpireTime));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "UpperSettleNo", info->UpperSettleNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "UpperUserNo", info->UpperUserNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "TradeNo", info->TradeNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "IsBackInput", IsBackInput.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_int64(json, "MatchStreamID", info->MatchStreamID));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "OpenCloseMode", OpenCloseMode.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "ContractSize", info->ContractSize));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityCurrencyGroup", info->CommodityCurrencyGroup));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityCurrency", info->CommodityCurrency));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "PreSettlePrice", info->PreSettlePrice));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "Turnover", info->Turnover));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "MatchSource", MatchSource.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "ExchangeMatchNo", info->ExchangeMatchNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "MatchDate", info->MatchDate));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "MatchTime", info->MatchTime));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "UpperMatchTime", info->UpperMatchTime));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "IsAddOne", IsAddOne.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "SettlePrice", info->SettlePrice));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "AccountMarginMode", AccountMarginMode.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "AccountMarginParam", info->AccountMarginParam));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "UpperMarginMode", UpperMarginMode.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "UpperMarginParam", info->UpperMarginParam));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "MatchCmbNo", info->MatchCmbNo));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "FloatingPL", info->FloatingPL));
        ACL_VSTRING* buf = acl_json_build(json, NULL);
        logger_debug(DEBUG_TEST3, 2, "%s", acl_vstring_str(buf));
        EsunnyUtil::KafkaOrRedis(TOPIC_POSITION, acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
        acl_vstring_free(buf);
        acl_json_free(json);
    }
    if (isLast == 'Y')
    {
        logger("数据推送结束");
        return;
    }
}

int Trade::t_qryClose()
{
    logger_debug(DEBUG_TEST2, 2, "*************** t_qryPosition **************");

    TapAPICloseQryReq qryReq;
    memset(&qryReq, 0, sizeof(qryReq));

    TAPIINT32 iErr = TAPIERROR_SUCCEED;
    TAPIUINT32 reqid = 0;
    iErr = m_pAPI->QryClose(&reqid, &qryReq);
    if (iErr != TAPIERROR_SUCCEED) {
        logger_error("QryClose failed, errorCode: %d", iErr);
    }
    return iErr;
}

void TAP_CDECL Trade::OnRspQryClose( TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPICloseInfo *info )
{
    if (info != NULL)
    {
        std::string CommodityType(1, info->CommodityType);
        std::string CallOrPutFlag(1, info->CallOrPutFlag);
        std::string OpenOrderCommodityType(1, info->OpenOrderCommodityType);
        std::string CloseOrderCommodityType(1, info->CloseOrderCommodityType);
        std::string OpenMatchSource(1, info->OpenMatchSource);
        std::string CloseMatchSource(1, info->CloseMatchSource);
        std::string CloseSide(1, info->CloseSide);
        std::string OpenServerFlag(1, info->OpenServerFlag);
        std::string CloseServerFlag(1, info->CloseServerFlag);
        ACL_JSON* json = acl_json_alloc();
        acl_json_node_add_child(json->root, acl_json_create_text(json, "AccountNo", info->AccountNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "ExchangeNo", info->ExchangeNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityType", CommodityType.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityNo", info->CommodityNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "ContractNo", info->ContractNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "StrikePrice", info->StrikePrice));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "CallOrPutFlag", CallOrPutFlag.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "OpenOrderExchangeNo", info->OpenOrderExchangeNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "OpenOrderCommodityType", OpenOrderCommodityType.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "OpenOrderCommodityNo", info->OpenOrderCommodityNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "CloseOrderExchangeNo", info->CloseOrderExchangeNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "CloseOrderCommodityType", CloseOrderCommodityType.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "CloseOrderCommodityNo", info->CloseOrderCommodityNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "OpenMatchSource", OpenMatchSource.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "CloseMatchSource", CloseMatchSource.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "CloseSide", CloseSide.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_int64(json, "CloseQty", info->CloseQty));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "OpenPrice", info->OpenPrice));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "ClosePrice", info->ClosePrice));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "OpenServerFlag", OpenServerFlag.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "OpenOrderNo", info->OpenOrderNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "OpenMatchNo", info->OpenMatchNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "OpenExchangeMatchNo", info->OpenExchangeMatchNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "OpenMatchDateTime", info->OpenMatchDateTime));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "CloseServerFlag", CloseServerFlag.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "CloseOrderNo", info->CloseOrderNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "CloseMatchNo", info->CloseMatchNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "CloseExchangeMatchNo", info->CloseExchangeMatchNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "CloseMatchDateTime", info->CloseMatchDateTime));
        acl_json_node_add_child(json->root, acl_json_create_int64(json, "CloseStreamId", info->CloseStreamId));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityCurrencyGroup", info->CommodityCurrencyGroup));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityCurrency", info->CommodityCurrency));
        std::string OpenCloseMode(1, info->OpenCloseMode);
        acl_json_node_add_child(json->root, acl_json_create_text(json, "ParentAccountNo", info->ParentAccountNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "OpenCloseMode", OpenCloseMode.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "ContractSize", info->ContractSize));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityCurrencyGroup", info->CommodityCurrencyGroup));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityCurrency", info->CommodityCurrency));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "PreSettlePrice", info->PreSettlePrice));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "PremiumIncome", info->PremiumIncome));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "PremiumPay", info->PremiumPay));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "CloseProfit", info->CloseProfit));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "UnExpProfit", info->UnExpProfit));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "ClosePL", info->ClosePL));
        ACL_VSTRING* buf = acl_json_build(json, NULL);
        logger_debug(DEBUG_TEST3, 2, "%s", acl_vstring_str(buf));
        EsunnyUtil::KafkaOrRedis(TOPIC_CLOSE, acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
        acl_vstring_free(buf);
        acl_json_free(json);
    }
    if (isLast == 'Y')
    {
        logger("数据推送结束");
        return;
    }
}

void TAP_CDECL Trade::OnRtnReqQuoteNotice(const TapAPIReqQuoteNotice *info)
{
    std::cout << __FUNCTION__ << " is called." << std::endl;
}


/// 公共查询

int Trade::t_qryAccount()
{
    logger_debug(DEBUG_TEST2, 2, "*************** t_qryAccount **************");
    TapAPIAccQryReq qryReq;
    memset(&qryReq, 0, sizeof(qryReq));
    strncpy(qryReq.AccountNo, m_pAccount->getAccountNo(), strlen(m_pAccount->getAccountNo()));
    TAPIINT32 iErr = TAPIERROR_SUCCEED;
    TAPIUINT32 reqid = 0;
    iErr = m_pAPI->QryAccount(&reqid, &qryReq);
    if(iErr != TAPIERROR_SUCCEED) {
        logger_error("QryAccount failed, errorCode: %d", iErr);
    }
    return iErr;
}

void TAP_CDECL Trade::OnRspQryAccount( TAPIUINT32 sessionID, TAPIUINT32 errorCode, TAPIYNFLAG isLast, const TapAPIAccountInfo *info )
{
    if(errorCode == TAPIERROR_SUCCEED) {
        if (NULL == info)
        {
            logger_error("info is NULL");
            return;
        }
        std::string AccountType(1, info->AccountType);
        std::string AccountState(1, info->AccountState);
        std::string AccountIsDocHolder(1, info->AccountIsDocHolder);
        std::string IsMarketMaker(1, info->IsMarketMaker);
        std::string AccountFamilyType(1, info->AccountFamilyType);
        ACL_JSON* json = acl_json_alloc();
        acl_json_node_add_child(json->root, acl_json_create_text(json, "AccountNo", info->AccountNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "AccountType", AccountType.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "AccountState", AccountState.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "AccountShortName", info->AccountShortName));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "AccountIsDocHolder", AccountIsDocHolder.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "IsMarketMaker", IsMarketMaker.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "AccountFamilyType", AccountFamilyType.c_str()));
        ACL_VSTRING* buf = acl_json_build(json, NULL);
        char *outbuf = EsunnyUtil::EsunnyConvert(acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
        logger_debug(DEBUG_TEST3, 2, "%s", outbuf);
        EsunnyUtil::KafkaOrRedis(TOPIC_QRYACCOUNT, outbuf, strlen(outbuf));
        delete[] outbuf;
        acl_vstring_free(buf);
        acl_json_free(json);
        if(isLast == 'Y') {
            logger("数据推送结束");
        }
    }
    else
    {
        logger_error("OnRspQryAccount failed, errorCode: %d", errorCode);
    }
}

int Trade::t_qryFund()
{
    logger_debug(DEBUG_TEST2, 2, "*************** t_qryFund **************");

    TAPIINT32 iErr = TAPIERROR_SUCCEED;
    TapAPIFundReq qryReq;
    memset(&qryReq, 0, sizeof(qryReq));
    strncpy(qryReq.AccountNo, m_pAccount->getAccountNo(), strlen(m_pAccount->getAccountNo()));
    TAPIUINT32 reqid = 0;
    iErr = m_pAPI->QryFund(&reqid, &qryReq);
    if(iErr != TAPIERROR_SUCCEED) {
        logger_error("QryFund failed, errorCode: %d", iErr);
    }
    return iErr;
}

void TAP_CDECL Trade::OnRspQryFund( TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPIFundData *info )
{
    if(errorCode == TAPIERROR_SUCCEED) {
        if (NULL == info)
        {
            logger_error("info is NULL");
            return;
        }
        std::string FutureAlg(1, info->FutureAlg);
        std::string OptionAlg(1, info->OptionAlg);
        ACL_JSON* json = acl_json_alloc();
        acl_json_node_add_child(json->root, acl_json_create_text(json, "AccountNo", info->AccountNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "CurrencyGroupNo", info->CurrencyGroupNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "CurrencyNo", info->CurrencyNo));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "TradeRate", info->TradeRate));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "FutureAlg", FutureAlg.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "OptionAlg", OptionAlg.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "PreBalance", info->PreBalance));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "PreUnExpProfit", info->PreUnExpProfit));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "PreLMEPositionProfit", info->PreLMEPositionProfit));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "PreEquity", info->PreEquity));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "PreAvailable1", info->PreAvailable1));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "PreMarketEquity", info->PreMarketEquity));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "CashInValue", info->CashInValue));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "CashOutValue", info->CashOutValue));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "CashAdjustValue", info->CashAdjustValue));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "CashPledged", info->CashPledged));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "FrozenFee", info->FrozenFee));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "FrozenDeposit", info->FrozenDeposit));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "AccountFee", info->AccountFee));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "PremiumIncome", info->PremiumIncome));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "PremiumPay", info->PremiumPay));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "CloseProfit", info->CloseProfit));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "UnExpProfit", info->UnExpProfit));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "ExpProfit", info->ExpProfit));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "PositionProfit", info->PositionProfit));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "LmePositionProfit", info->LmePositionProfit));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "OptionMarketValue", info->OptionMarketValue));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "AccountIntialMargin", info->AccountIntialMargin));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "AccountMaintenanceMargin", info->AccountMaintenanceMargin));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "UpperInitalMargin", info->UpperInitalMargin));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "UpperMaintenanceMargin", info->UpperMaintenanceMargin));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "Discount", info->Discount));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "Balance", info->Balance));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "Equity", info->Equity));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "Available", info->Available));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "CanDraw", info->CanDraw));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "MarketEquity", info->MarketEquity));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "ParentAccountNo", info->ParentAccountNo));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "ExchangeFee", info->ExchangeFee));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "AccountDeliveryFee", info->AccountDeliveryFee));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "DeliveryProfit", info->DeliveryProfit));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "OriginalCashInOut", info->OriginalCashInOut));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "FloatingPL", info->FloatingPL));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "FrozenRiskFundValue", info->FrozenRiskFundValue));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "ClosePL", info->ClosePL));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "NoCurrencyPledgeValue", info->NoCurrencyPledgeValue));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "PrePledgeValue", info->PrePledgeValue));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "PledgeIn", info->PledgeIn));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "PledgeOut", info->PledgeOut));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "PledgeValue", info->PledgeValue));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "BorrowValue", info->BorrowValue));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "SpecialAccountFrozenMargin", info->SpecialAccountFrozenMargin));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "SpecialAccountMargin", info->SpecialAccountMargin));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "SpecialAccountFrozenFee", info->SpecialAccountFrozenFee));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "SpecialAccountFee", info->SpecialAccountFee));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "SpecialFloatProfit", info->SpecialFloatProfit));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "SpecialCloseProfit", info->SpecialCloseProfit));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "SpecialFloatPL", info->SpecialFloatPL));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "SpecialClosePL", info->SpecialClosePL));
        ACL_VSTRING* buf = acl_json_build(json, NULL);
        logger_debug(DEBUG_TEST3, 2, "%s", acl_vstring_str(buf));
        EsunnyUtil::KafkaOrRedis(TOPIC_QRYFUND, acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
        acl_vstring_free(buf);
        acl_json_free(json);
    }
    else
    {
        logger_error("OnRspQryFund failed, errorCode: %d", errorCode);
    }
}

int Trade::t_qryExchange()
{
    logger_debug(DEBUG_TEST2, 2, "*************** t_qryExchange **************");

    TAPIINT32 iErr = TAPIERROR_SUCCEED;
    TAPIUINT32 reqid = 0;
    iErr = m_pAPI->QryExchange(&reqid);
    if(iErr != TAPIERROR_SUCCEED) {
        logger_error("QryExchange failed, errorCode: %d", iErr);
    }
    return iErr;
}

void TAP_CDECL Trade::OnRspQryExchange( TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPIExchangeInfo *info )
{
    if (errorCode != TAPIERROR_SUCCEED) {
        logger_error("查询交易所信息失败, errorCode: %d", errorCode);
    }
    if (NULL != info)
    {
        ACL_JSON* json = acl_json_alloc();
        acl_json_node_add_child(json->root, acl_json_create_text(json, "ExchangeNo", info->ExchangeNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "ExchangeName", info->ExchangeName));
        ACL_VSTRING* buf = acl_json_build(json, NULL);
        char *outbuf = EsunnyUtil::EsunnyConvert(acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
        logger_debug(DEBUG_TEST3, 2, "%s", outbuf);
        EsunnyUtil::KafkaOrRedis(TOPIC_QRYEXCHANGE, outbuf, strlen(outbuf));
        delete[] outbuf;
        acl_vstring_free(buf);
        acl_json_free(json);
    }
    if(isLast == 'Y')
    {
        logger("数据推送结束");
        return;
    }
}

int Trade::t_qryCommodity()
{
    logger_debug(DEBUG_TEST2, 2, "*************** t_qryCommodity **************");

    TAPIINT32 iErr = TAPIERROR_SUCCEED;
    TAPIUINT32 reqid = 0;
    iErr = m_pAPI->QryCommodity(&reqid);
    return iErr;
}

void TAP_CDECL Trade::OnRspQryCommodity( TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPICommodityInfo *info )
{
    if(TAPIERROR_SUCCEED == errorCode)
    {
        if (info != NULL)
        {
            std::string CommodityType(1, info->CommodityType);
            std::string RelateCommodityType(1, info->RelateCommodityType);
            std::string RelateCommodityType2(1, info->RelateCommodityType2);
            std::string OpenCloseMode(1, info->OpenCloseMode);
            std::string CmbDirect(1, info->CmbDirect);
            std::string DeliveryMode(1, info->DeliveryMode);
            ACL_JSON* json = acl_json_alloc();
            acl_json_node_add_child(json->root, acl_json_create_text(json, "ExchangeNo", info->ExchangeNo));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityType", CommodityType.c_str()));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityNo", info->CommodityNo));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityName", info->CommodityName));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityEngName", info->CommodityEngName));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "RelateExchangeNo", info->RelateExchangeNo));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "RelateCommodityType", RelateCommodityType.c_str()));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "RelateCommodityNo", info->RelateCommodityNo));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "RelateExchangeNo2", info->RelateExchangeNo2));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "RelateCommodityType2", RelateCommodityType2.c_str()));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "RelateCommodityNo2", info->RelateCommodityNo2));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "TradeCurrency", info->TradeCurrency));
            acl_json_node_add_child(json->root, acl_json_create_double(json, "ContractSize", info->ContractSize));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "OpenCloseMode", OpenCloseMode.c_str()));
            acl_json_node_add_child(json->root, acl_json_create_double(json, "StrikePriceTimes", info->StrikePriceTimes));
            std::ostringstream oss;
            // 设置精度为10
            oss.precision(10);
            oss << info->CommodityTickSize;
            std::string CommodityTickSize_Str = oss.str();
            acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityTickSize", CommodityTickSize_Str.c_str()));
            acl_json_node_add_child(json->root, acl_json_create_double(json, "CommodityDenominator", info->CommodityDenominator));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "CmbDirect", CmbDirect.c_str()));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "DeliveryMode", DeliveryMode.c_str()));
            acl_json_node_add_child(json->root, acl_json_create_int64(json, "DeliveryDays", info->DeliveryDays));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "AddOneTime", info->AddOneTime));
            acl_json_node_add_child(json->root, acl_json_create_int64(json, "CommodityTimeZone", info->CommodityTimeZone));
            std::string MarginCalculateMode(1, info->MarginCalculateMode);
            std::string OptionMarginCalculateMode(1, info->OptionMarginCalculateMode);
            std::string IsOnlyQuoteCommodity(1, info->IsOnlyQuoteCommodity);
            acl_json_node_add_child(json->root, acl_json_create_text(json, "SettleCurrency", info->SettleCurrency));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "MarginCalculateMode", MarginCalculateMode.c_str()));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "OptionMarginCalculateMode", OptionMarginCalculateMode.c_str()));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "IsOnlyQuoteCommodity", IsOnlyQuoteCommodity.c_str()));
            acl_json_node_add_child(json->root, acl_json_create_int64(json, "OnlyCanCloseDays", info->OnlyCanCloseDays));
            ACL_VSTRING* buf = acl_json_build(json, NULL);
            char *outbuf = EsunnyUtil::EsunnyConvert(acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
            logger_debug(DEBUG_TEST3, 2, "%s", outbuf);
            EsunnyUtil::KafkaOrRedis(TOPIC_QRYCOMMODITY, outbuf, strlen(outbuf));
            delete[] outbuf;
            acl_vstring_free(buf);
            acl_json_free(json);
        }
        if(isLast=='Y')
        {
            logger("数据推送结束");
            return;
        }
    } else
    {
        logger_error("品种信息获取失败, 错误码 %d", errorCode);
    }
}

int Trade::t_qryContract(const char* ExchangeNo, const char *CommodityNo, const char* CommodityType)
{
    logger_debug(DEBUG_TEST2, 2, "*************** t_qryContract **************");

    TAPIINT32 iErr = TAPIERROR_SUCCEED;
    TapAPICommodity com;
    memset(&com, 0, sizeof(com));
    if (ExchangeNo != NULL) {
        logger_debug(DEBUG_TEST2, 1, "ExchangeNo = %s", ExchangeNo);
        strcpy(com.ExchangeNo, ExchangeNo);
    }
    if (CommodityNo != NULL) {
        logger_debug(DEBUG_TEST2, 1, "CommodityNo = %s", CommodityNo);
        strcpy(com.CommodityNo, CommodityNo);
    }
    if (CommodityType != NULL) {
        logger_debug(DEBUG_TEST2, 1, "CommodityType = %s", CommodityType);
        com.CommodityType = CommodityType[0];
    }
    TAPIUINT32 reqid = 0;
    iErr = m_pAPI->QryContract(&reqid,&com);
    if (iErr != TAPIERROR_SUCCEED) {
        logger_error("t_qryContract failed, errorCode: %d", iErr);
    }
    return iErr;
}

void TAP_CDECL Trade::OnRspQryContract( TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPITradeContractInfo *info )
{
    if (errorCode != TAPIERROR_SUCCEED) {
        logger_error("查询合约信息失败, errorCode: %d", errorCode);
    }

    if (NULL != info)
    {
        std::string CommodityType(1, info->CommodityType);
        std::string CallOrPutFlag1(1, info->CallOrPutFlag1);
        std::string CallOrPutFlag2(1, info->CallOrPutFlag2);
        std::string ContractType(1, info->ContractType);
        ACL_JSON* json = acl_json_alloc();
        acl_json_node_add_child(json->root, acl_json_create_text(json, "ExchangeNo", info->ExchangeNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityType", CommodityType.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityNo", info->CommodityNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "ContractNo1", info->ContractNo1));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "StrikePrice1", info->StrikePrice1));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "CallOrPutFlag1", CallOrPutFlag1.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "ContractNo2", info->ContractNo2));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "StrikePrice2", info->StrikePrice2));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "CallOrPutFlag2", CallOrPutFlag2.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "CallOrPutFlag2", CallOrPutFlag2.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "ContractType", ContractType.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "QuoteUnderlyingContract", info->QuoteUnderlyingContract));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "ContractName", info->ContractName));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "ContractExpDate", info->ContractExpDate));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "LastTradeDate", info->LastTradeDate));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "FirstNoticeDate", info->FirstNoticeDate));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "FutureContractNo", info->FutureContractNo));
        ACL_VSTRING* buf = acl_json_build(json, NULL);
        char *outbuf = EsunnyUtil::EsunnyConvert(acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
        logger_debug(DEBUG_TEST3, 2, "%s", outbuf);
        EsunnyUtil::KafkaOrRedis(TOPIC_QRYCONTRACT, outbuf, strlen(outbuf));
        delete[] outbuf;
        acl_vstring_free(buf);
        acl_json_free(json);
    }
    if(isLast == 'Y')
    {
        logger("数据推送结束");
        return ;
    }
}

void TAP_CDECL Trade::OnRtnContract( const TapAPITradeContractInfo *info )
{
    if (NULL == info)
    {
        logger_error("info is NULL");
        return;
    }
    std::string CommodityType(1, info->CommodityType);
    std::string CallOrPutFlag1(1, info->CallOrPutFlag1);
    std::string CallOrPutFlag2(1, info->CallOrPutFlag2);
    std::string ContractType(1, info->ContractType);
    ACL_JSON* json = acl_json_alloc();
    acl_json_node_add_child(json->root, acl_json_create_text(json, "ExchangeNo", info->ExchangeNo));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityType", CommodityType.c_str()));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityNo", info->CommodityNo));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "ContractNo1", info->ContractNo1));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "StrikePrice1", info->StrikePrice1));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "CallOrPutFlag1", CallOrPutFlag1.c_str()));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "ContractNo2", info->ContractNo2));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "StrikePrice2", info->StrikePrice2));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "CallOrPutFlag2", CallOrPutFlag2.c_str()));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "CallOrPutFlag2", CallOrPutFlag2.c_str()));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "ContractType", ContractType.c_str()));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "QuoteUnderlyingContract", info->QuoteUnderlyingContract));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "ContractName", info->ContractName));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "ContractExpDate", info->ContractExpDate));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "LastTradeDate", info->LastTradeDate));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "FirstNoticeDate", info->FirstNoticeDate));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "FutureContractNo", info->FutureContractNo));
    ACL_VSTRING* buf = acl_json_build(json, NULL);
    char *outbuf = EsunnyUtil::EsunnyConvert(acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
    logger_debug(DEBUG_TEST3, 2, "%s", outbuf);
    EsunnyUtil::KafkaOrRedis(TOPIC_QRYCONTRACT, outbuf, strlen(outbuf));
    delete[] outbuf;
    acl_vstring_free(buf);
    acl_json_free(json);
}

// 查询客户最终费率
int Trade::t_qryAccountRent(const char *CommodityType,const char *ExchangeNo,const char *CommodityNo,const char *ContractNo)
{
    logger_debug(DEBUG_TEST2, 2, "*************** t_qryAccountRent **************");

    TAPIINT32 iErr = TAPIERROR_SUCCEED;
    TapAPIAccountRentQryReq req;
    memset(&req, 0, sizeof(req));
    strcpy(req.AccountNo, m_pAccount->getAccountNo());
    if (CommodityType != NULL) {
        logger_debug(DEBUG_TEST2, 1, "CommodityType = %s", CommodityType);
    req.CommodityType = CommodityType[0];
    }
    if (ExchangeNo != NULL) {
        logger_debug(DEBUG_TEST2, 1, "ExchangeNo = %s", ExchangeNo);
        strcpy(req.ExchangeNo, ExchangeNo);
    }
    if (CommodityNo != NULL) {
        logger_debug(DEBUG_TEST2, 1, "CommodityNo = %s", CommodityNo);
        strcpy(req.CommodityNo, CommodityNo);
    }
    if (ContractNo != NULL) {
        logger_debug(DEBUG_TEST2, 1, "ContractNo = %s", ContractNo);
        strcpy(req.ContractNo, ContractNo);
    }

    TAPIUINT32 reqid = 0;
    iErr = m_pAPI->QryAccountRent(&reqid,&req);
    if (iErr != TAPIERROR_SUCCEED) {
        logger_error("t_qryAccountRent failed, errorCode: %d", iErr);
    }
    return iErr;
}

void TAP_CDECL Trade::OnRspAccountRentInfo(TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPIAccountRentInfo * info)
{
    if (NULL == info)
    {
        logger_error("info is NULL");
        return;
    }
    std::string CommodityType(1, info->CommodityType);
    std::string MatchSource(1, info->MatchSource);
    std::string FeeMode(1, info->FeeMode);
    std::string MarginMode(1, info->MarginMode);
    ACL_JSON* json = acl_json_alloc();
    acl_json_node_add_child(json->root, acl_json_create_text(json, "AccountNo", info->AccountNo));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "ExchangeNo", info->ExchangeNo));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityType", CommodityType.c_str()));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityNo", info->CommodityNo));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "ContractNo", info->ContractNo));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "MatchSource", MatchSource.c_str()));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "CurrencyNo", info->CurrencyNo));

    acl_json_node_add_child(json->root, acl_json_create_text(json, "FeeMode", FeeMode.c_str()));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "OpenTurnover", info->OpenTurnover));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "ClosedTurnover", info->ClosedTurnover));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "CloseNewTurnover", info->CloseNewTurnover));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "OpenVolume", info->OpenVolume));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "ClosedVolume", info->ClosedVolume));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "CloseNewVolume", info->CloseNewVolume));

    acl_json_node_add_child(json->root, acl_json_create_text(json, "MarginMode", MarginMode.c_str()));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "BuyTInitMargin", info->BuyTInitMargin));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "SellTInitMargin", info->SellTInitMargin));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "BuyBInitMargin", info->BuyBInitMargin));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "SellBInitMargin", info->SellBInitMargin));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "BuyLInitMargin", info->BuyLInitMargin));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "SellLInitMargin", info->SellLInitMargin));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "BuyMInitMargin", info->BuyMInitMargin));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "SellMInitMargin", info->SellMInitMargin));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "BuyTMaintMargin", info->BuyTMaintMargin));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "SellTMaintMargin", info->SellTMaintMargin));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "BuyBMaintMargin", info->BuyBMaintMargin));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "SellBMaintMargin", info->SellBMaintMargin));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "BuyLMaintMargin", info->BuyLMaintMargin));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "SellLMaintMargin", info->SellLMaintMargin));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "BuyMMaintMargin", info->BuyMMaintMargin));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "SellMMaintMargin", info->SellMMaintMargin));
    //
    ACL_VSTRING* buf = acl_json_build(json, NULL);
    logger_debug(DEBUG_TEST3, 2, "%s", acl_vstring_str(buf));
    EsunnyUtil::KafkaOrRedis(TOPIC_QRYACCOUNTRENT, acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
    acl_vstring_free(buf);
    acl_json_free(json);

    if (isLast == true)
    {
        logger("查询客户最终费率推送结束");
    }
}


void TAP_CDECL Trade::OnRspChangePassword( TAPIUINT32 sessionID, TAPIINT32 errorCode )
{
    cout << __FUNCTION__ << " is called." << endl;
}

void TAP_CDECL Trade::OnRspSetReservedInfo( TAPIUINT32 sessionID, TAPIINT32 errorCode, const TAPISTR_50 info )
{
    cout << __FUNCTION__ << " is called." << endl;
}

void TAP_CDECL Trade::OnRspQryOrderProcess( TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPIOrderInfo *info )
{
    cout << __FUNCTION__ << " is called." << endl;
}

void TAP_CDECL Trade::OnRspQryDeepQuote(TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPIDeepQuoteQryRsp *info)
{
    //	cout << __FUNCTION__ << " is called." << endl;
}

void TAP_CDECL Trade::OnRspQryExchangeStateInfo(TAPIUINT32 sessionID,TAPIINT32 errorCode, TAPIYNFLAG isLast,const TapAPIExchangeStateInfo * info)
{
    //	cout << __FUNCTION__ << " is called." << endl;
}

void TAP_CDECL Trade::OnRtnExchangeStateInfo(const TapAPIExchangeStateInfoNotice * info)
{
    //	cout << __FUNCTION__ << " is called." << endl;
}

void TAP_CDECL Trade::OnRspUpperChannelInfo(TAPIUINT32 sessionID,TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPIUpperChannelInfo * info)
{

}

void TAP_CDECL Trade::OnRspSubmitUserLoginInfo(TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPISubmitUserLoginRspInfo * info)
{}

void TAP_CDECL Trade::OnRspQryBill(TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPIBillQryRsp *info)
{}

void TAP_CDECL Trade::OnRspQryAccountStorage(TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPIAccountStorageInfo* info)
{}

void TAP_CDECL Trade::OnRtnAccountStorage(const TapAPIAccountStorageInfo* info)
{}
