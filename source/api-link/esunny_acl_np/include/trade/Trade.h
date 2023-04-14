#pragma once
#include <TapTradeAPI.h>
#include "common/SimpleEvent.h"
#include "common/InitParams.h"

class Trade : public ITapTradeAPINotify{
public:
    Trade(void);
    ~Trade(void);

    void SetAPI(ITapTradeAPI *pAPI);
    void setAccount(std::shared_ptr<Account> account);
    int RunTrade();

    /// 交易相关操作
    // 下单
    int t_insertOrder(const char* ExchangeNo,const char* CommodityNo,const char* ContractNo,
                      const char* OrderType,const char* TimeInForce,const char* ExpireTime,
                      const char* OrderSide,const char* PositionEffect,const char* OrderPrice,
                      const char* OrderQty, const char* RefString);
    // 撤单
    int t_cancelOrder(const char* OrderNo);

    /// 查询用户交易信息
    int t_qryOrder(const char *OrderQryType); // 查询委托信息
    int t_qryFill(); // 查询成交信息
    int t_qryPosition(); // 查询用户持仓
    int t_qryClose(); // 查询平仓

    /// 查询用户资金账号
    int t_qryAccount();    // 返回用户信息
    int t_qryFund();   // 返回资金账户的资金信息

    /// 公共查询
    int t_qryExchange();
    int t_qryCommodity();
    int t_qryContract(const char *ExchangeNo, const char *CommodityNo, const char* CommodityType);

    // 查询客户最终费率
    int t_qryAccountRent(const char *CommodityType,const char *ExchangeNo,const char *CommodityNo,const char *ContractNo);

public:
    //对ITapTradeAPINotify的实现
    virtual void TAP_CDECL OnConnect();
    virtual void TAP_CDECL OnRspLogin(TAPIINT32 errorCode, const TapAPITradeLoginRspInfo *loginRspInfo);
    virtual void TAP_CDECL OnAPIReady();
    virtual void TAP_CDECL OnDisconnect(TAPIINT32 reasonCode);
    virtual void TAP_CDECL OnRspChangePassword(TAPIUINT32 sessionID, TAPIINT32 errorCode);
    virtual void TAP_CDECL OnRspSetReservedInfo(TAPIUINT32 sessionID, TAPIINT32 errorCode, const TAPISTR_50 info);
    virtual void TAP_CDECL OnRspQryAccount(TAPIUINT32 sessionID, TAPIUINT32 errorCode, TAPIYNFLAG isLast, const TapAPIAccountInfo *info);
    virtual void TAP_CDECL OnRspQryFund(TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPIFundData *info);
    virtual void TAP_CDECL OnRtnFund(const TapAPIFundData *info);
    virtual void TAP_CDECL OnRspQryExchange(TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPIExchangeInfo *info);
    virtual void TAP_CDECL OnRspQryCommodity(TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPICommodityInfo *info);
    virtual void TAP_CDECL OnRspQryContract(TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPITradeContractInfo *info);
    virtual void TAP_CDECL OnRtnContract(const TapAPITradeContractInfo *info);
    virtual void TAP_CDECL OnRtnOrder(const TapAPIOrderInfoNotice *info);
    virtual void TAP_CDECL OnRspOrderAction(TAPIUINT32 sessionID, TAPIUINT32 errorCode, const TapAPIOrderActionRsp *info);
    virtual void TAP_CDECL OnRspQryOrder(TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPIOrderInfo *info);
    virtual void TAP_CDECL OnRspQryOrderProcess(TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPIOrderInfo *info);
    virtual void TAP_CDECL OnRspQryFill(TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPIFillInfo *info);
    virtual void TAP_CDECL OnRtnFill(const TapAPIFillInfo *info);
    virtual void TAP_CDECL OnRspQryPosition(TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPIPositionInfo *info);
    virtual void TAP_CDECL OnRtnPosition(const TapAPIPositionInfo *info);
    virtual void TAP_CDECL OnRspQryClose(TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPICloseInfo *info);
    virtual void TAP_CDECL OnRtnClose(const TapAPICloseInfo *info);
    virtual void TAP_CDECL OnRtnPositionProfit(const TapAPIPositionProfitNotice *info);
    virtual void TAP_CDECL OnRspQryDeepQuote(TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPIDeepQuoteQryRsp *info);
    virtual void TAP_CDECL OnRspQryExchangeStateInfo(TAPIUINT32 sessionID,TAPIINT32 errorCode, TAPIYNFLAG isLast,const TapAPIExchangeStateInfo * info);
    virtual void TAP_CDECL OnRtnExchangeStateInfo(const TapAPIExchangeStateInfoNotice * info);
    virtual void TAP_CDECL OnRtnReqQuoteNotice(const TapAPIReqQuoteNotice *info); //V9.0.2.0 20150520
    virtual void TAP_CDECL OnRspUpperChannelInfo(TAPIUINT32 sessionID,TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPIUpperChannelInfo * info);
    virtual void TAP_CDECL OnRspAccountRentInfo(TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPIAccountRentInfo * info);
    virtual void TAP_CDECL OnRspSubmitUserLoginInfo(TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPISubmitUserLoginRspInfo * info);
    virtual void TAP_CDECL OnRspQryBill(TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPIBillQryRsp *info);
    virtual void TAP_CDECL OnRspQryAccountStorage(TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPIAccountStorageInfo* info);
    virtual void TAP_CDECL OnRtnAccountStorage(const TapAPIAccountStorageInfo* info);

public:
    TAPIINT32   m_reasonCode; // 连接断开错误码
    SimpleEvent m_Event;

private:
    ITapTradeAPI *m_pAPI;
    std::shared_ptr<Account> m_pAccount;
    TAPIUINT32	m_uiSessionID;
//    SimpleEvent m_Event;
    bool		m_bIsAPIReady;
};

