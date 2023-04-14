#ifndef TRADE_H
#define TRADE_H

#include "../esunny/iTapTradeAPI.h"
#include "../common/SimpleEvent.h"
#include "../../include/common/httplib.h"


using namespace std;
using namespace httplib;
using namespace ITapTrade;


class Trade : public ITapTradeAPINotify
{
public:
	Trade(void);
	~Trade(void);

	void SetAPI(ITapTradeAPI *pAPI);
	void RunTrade(std::string userNo);

	void loopCmd();
	void printHelp();

	// order
	int t_insertOrder(std::string AccountNo, std::string ExchangeNo, std::string CommodityNo,
                       std::string ContractNo, std::string OrderType, std::string TimeInForce,
                       std::string OrderSide, std::string OrderPrice, std::string OrderQty);
	int t_canncelOrder(std::string OrderNo);
	void t_modify();
    void t_activeOrder();

	// HisOrder
	void t_qryAccountCashAdjust(); // 客户资金调整委托查询请求
	void t_qryHisOrder(); // 历史委托查询请求
	void t_qryHisOrderProcess(); // 历史委托流程查询请求
	void t_qryHisMatch(); // 历史成交查询请求
	void t_qryHisPosition(); // 历史持仓查询请求
	void t_qryHisDelivery(); // 历史交割查询请求

	// Common
	void t_qryTradingDate();
	int t_qryExchange();
	int t_qryCurrency();
    int t_disConnect();
    int t_login(std::string);

	// UserFund Message
	int t_qryAccount();    // 查询用户下属的资金帐号
	int t_qryFund(std::string Account);   // 查询客户资金
	void t_qryTradeMessage();    // 获取交易或风控消息

	// Commodity、Contract
    int t_qryCommodity();
    int t_qryContract(std::string ExchangeNo);

    // UserTrade
    int t_qryOrder(std::string AccountNo); // 查询委托信息
    int t_qryOrderByOrderNo(std::string AccountNo, std::string OrderNo);
    void t_qryOrderProcess(); // 查询委托变化流程
    int t_qryFill(std::string AccountNo); // 查询成交信息
    int t_qryFillByOrderNo(std::string AccountNo, std::string OrderNo);
    int  t_qryPosition(std::string AccountNo); // 查询用户持仓
    void t_qryPositionSummary(); // 查询用户持仓汇总

    // Auth
    void t_changePassword(); // 修改密码
    void t_authPassword(); // 认证密码
    void t_setReservedInfo(); // 设置用户预留信息
    void t_haveCertainRight(); // 判断用户是否具有权限

    // Rent
    void t_qryAccountFeeRent(); // 客户手续费计算参数查询
    void t_qryAccountMarginRent(); // 客户保证金计算参数查询


public:
	virtual void TAP_CDECL OnConnect(const TAPISTR_40 HostAddress);

	virtual void TAP_CDECL OnRspLogin(TAPIINT32 errorCode, const TapAPITradeLoginRspInfo *loginRspInfo);

	virtual void TAP_CDECL OnDisconnect(TAPIINT32 reasonCode);

	virtual void TAP_CDECL OnRspChangePassword(TAPIUINT32 sessionID, TAPIINT32 errorCode);

	virtual void TAP_CDECL OnRspSetReservedInfo(TAPIUINT32 sessionID, TAPIINT32 errorCode, const TAPISTR_50 info);

	virtual void TAP_CDECL OnRspQryAccount(TAPIUINT32 sessionID, TAPIUINT32 errorCode, TAPIYNFLAG isLast, const TapAPIAccountInfo *info);

	virtual void TAP_CDECL OnRspQryFund(TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPIFundData *info);

	virtual void TAP_CDECL OnRtnFund(const ITapTrade::TapAPIFundData *info);

	virtual void TAP_CDECL OnRspQryExchange(TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const ITapTrade::TapAPIExchangeInfo *info);

	virtual void TAP_CDECL OnRspQryCommodity(TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPICommodityInfo *info);

	virtual void TAP_CDECL OnRspQryContract(TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPITradeContractInfo *info);

	virtual void TAP_CDECL OnRtnContract(const TapAPITradeContractInfo *info);

	virtual void TAP_CDECL OnRtnOrder(const TapAPIOrderInfoNotice *info);

    virtual void TAP_CDECL OnRspQryTradingDate(ITapTrade::TAPIUINT32 sessionID, ITapTrade::TAPIINT32 errorCode, const ITapTrade::TapAPITradingCalendarQryRsp *info);

    virtual void TAP_CDECL OnRspOrderAction(ITapTrade::TAPIUINT32 sessionID, ITapTrade::TAPIINT32 errorCode, const ITapTrade::TapAPIOrderActionRsp *info);

	virtual void TAP_CDECL OnRspQryOrder(TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPIOrderInfo *info);

	virtual void TAP_CDECL OnRspQryOrderProcess(TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPIOrderInfo *info);

	virtual void TAP_CDECL OnRspQryFill(TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPIFillInfo *info);

	virtual void TAP_CDECL OnRtnFill(const TapAPIFillInfo *info);

	virtual void TAP_CDECL OnRspQryPosition(TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPIPositionInfo *info);

	virtual void TAP_CDECL OnRtnPosition(const TapAPIPositionInfo *info);

	virtual void TAP_CDECL OnRspQryClose(TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPICloseInfo *info);

	virtual void TAP_CDECL OnRtnClose(const TapAPICloseInfo *info);

	virtual void TAP_CDECL OnRtnPositionProfit(const TapAPIPositionProfitNotice *info);

	virtual void TAP_CDECL OnRspQryCurrency(TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPICurrencyInfo *info);

	virtual void TAP_CDECL OnRspQryTradeMessage(TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPITradeMessage *info);

	virtual void TAP_CDECL OnRtnTradeMessage(const TapAPITradeMessage *info);

	virtual void TAP_CDECL OnRspQryHisOrder(TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPIHisOrderQryRsp *info);

	virtual void TAP_CDECL OnRspQryHisOrderProcess(TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPIHisOrderProcessQryRsp *info);

	virtual void TAP_CDECL OnRspQryHisMatch(TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPIHisMatchQryRsp *info);

	virtual void TAP_CDECL OnRspQryHisPosition(TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPIHisPositionQryRsp *info);

	virtual void TAP_CDECL OnRspQryHisDelivery(TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPIHisDeliveryQryRsp *info);

	virtual void TAP_CDECL OnRspQryAccountCashAdjust(TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPIAccountCashAdjustQryRsp *info);

	virtual void TAP_CDECL OnRspQryBill(TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPIBillQryRsp *info);

	virtual void TAP_CDECL OnExpriationDate(ITapTrade::TAPIDATE date, int days);

	virtual void TAP_CDECL OnRspQryAccountFeeRent(ITapTrade::TAPIUINT32 sessionID, ITapTrade::TAPIINT32 errorCode, ITapTrade::TAPIYNFLAG isLast, const ITapTrade::TapAPIAccountFeeRentQryRsp *info);

	virtual void TAP_CDECL OnRspQryAccountMarginRent(ITapTrade::TAPIUINT32 sessionID, ITapTrade::TAPIINT32 errorCode, ITapTrade::TAPIYNFLAG isLast, const ITapTrade::TapAPIAccountMarginRentQryRsp *info);
	virtual void TAP_CDECL OnRtnContactInfo(ITapTrade::TAPIINT32 errorCode, ITapTrade::TAPIYNFLAG isLast, const ITapTrade::TAPISTR_40 ContactInfo);
	virtual void TAP_CDECL OnRspRequestVertificateCode(ITapTrade::TAPIUINT32 sessionID,ITapTrade::TAPIINT32 errorCode, const TapAPIRequestVertificateCodeRsp *rsp);
	virtual void TAP_CDECL OnRspAuthPassword(ITapTrade::TAPIUINT32 sessionID, ITapTrade::TAPIINT32 errorCode);

	virtual void TAP_CDECL OnRspQryPositionSummary(TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPIPositionSummary *info);
	virtual void TAP_CDECL OnRspHKMarketOrderInsert(ITapTrade::TAPIUINT32 sessionID, ITapTrade::TAPIINT32 errorCode,  const ITapTrade::TapAPIOrderMarketInsertRsp *info);
	virtual void TAP_CDECL OnRspHKMarketOrderDelete(ITapTrade::TAPIUINT32 sessionID, ITapTrade::TAPIINT32 errorCode, const ITapTrade::TapAPIOrderMarketDeleteRsp *info);
	virtual void TAP_CDECL OnHKMarketQuoteNotice( const ITapTrade::TapAPIOrderQuoteMarketNotice *info);
	virtual void TAP_CDECL OnRspOrderLocalRemove(ITapTrade::TAPIUINT32 sessionID, ITapTrade::TAPIINT32 errorCode, const ITapTrade::TapAPIOrderLocalRemoveRsp *info);
	virtual void TAP_CDECL OnRspOrderLocalInput(ITapTrade::TAPIUINT32 sessionID, ITapTrade::TAPIINT32 errorCode, const ITapTrade::TapAPIOrderLocalInputRsp *info);
	virtual void TAP_CDECL OnRspOrderLocalModify(ITapTrade::TAPIUINT32 sessionID, ITapTrade::TAPIINT32 errorCode, const ITapTrade::TapAPIOrderLocalModifyRsp *info);
	virtual void TAP_CDECL OnRspOrderLocalTransfer(ITapTrade::TAPIUINT32 sessionID, ITapTrade::TAPIINT32 errorCode, const ITapTrade::TapAPIOrderLocalTransferRsp *info);
	virtual void TAP_CDECL OnRspFillLocalInput(ITapTrade::TAPIUINT32 sessionID, ITapTrade::TAPIINT32 errorCode, const ITapTrade::TapAPIFillLocalInputRsp *info);
	virtual void TAP_CDECL OnRspFillLocalRemove(ITapTrade::TAPIUINT32 sessionID, ITapTrade::TAPIINT32 errorCode, const ITapTrade::TapAPIFillLocalRemoveRsp *info);
	virtual void TAP_CDECL OnRspQrySpotLock(ITapTrade::TAPIUINT32 sessionID, ITapTrade::TAPIINT32 errorCode, ITapTrade::TAPIYNFLAG isLast, const ITapTrade::TapAPISpotLockDataRsp *info);
	virtual void TAP_CDECL OnRtnSpotLock(const ITapTrade::TapAPISpotLockDataRsp *info);
	virtual void TAP_CDECL OnRtnPositionSummary(const TapAPIPositionSummary *info);
	virtual void TAP_CDECL OnAPIReady(ITapTrade::TAPIINT32 errorCode);

    virtual void TAP_CDECL OnRspSubmitUserLoginInfo(TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPISubmitUserLoginRspInfo * info);
    virtual void TAP_CDECL OnRspSpecialOrderAction(ITapTrade::TAPIUINT32 sessionID, ITapTrade::TAPIINT32 errorCode, const ITapTrade::TapAPISpecialOrderInfo *info);
    virtual void TAP_CDECL OnRtnSpecialOrder(const ITapTrade::TapAPISpecialOrderInfo *info);
    virtual void TAP_CDECL OnRspQrySpecialOrder(ITapTrade::TAPIUINT32 sessionID, ITapTrade::TAPIINT32 errorCode, ITapTrade::TAPIYNFLAG isLast, const ITapTrade::TapAPISpecialOrderInfo *info);
    virtual void TAP_CDECL OnRspQryCombinePosition(ITapTrade::TAPIUINT32 sessionID, ITapTrade::TAPIINT32 errorCode, ITapTrade::TAPIYNFLAG isLast, const  ITapTrade::TapAPICombinePositionInfo *info);
    virtual void TAP_CDECL OnRtnCombinePosition(const ITapTrade::TapAPICombinePositionInfo *info);
    virtual void TAP_CDECL OnRspQryUserTrustDevice(ITapTrade::TAPIUINT32 sessionID, ITapTrade::TAPIINT32 errorCode, ITapTrade::TAPIYNFLAG isLast, const  ITapTrade::TapAPIUserTrustDeviceQryRsp *info);
    virtual void TAP_CDECL OnRspAddUserTrustDevice(ITapTrade::TAPIUINT32 sessionID, ITapTrade::TAPIINT32 errorCode, const ITapTrade::TapAPIUserTrustDeviceAddRsp *info);
    virtual void TAP_CDECL OnRspDelUserTrustDevice(ITapTrade::TAPIUINT32 sessionID, ITapTrade::TAPIINT32 errorCode, const ITapTrade::TapAPIUserTrustDeviceDelRsp *info);
    virtual void TAP_CDECL OnRtnAddUserTrustDevice(const ITapTrade::TapAPIUserTrustDeviceAddRsp *info);
    virtual void TAP_CDECL OnRtnDelUserTrustDevice(const ITapTrade::TapAPIUserTrustDeviceDelRsp *info);
private:
    ITapTradeAPI *m_pAPI;
	TAPIUINT32	m_uiSessionID;
	bool		m_bIsAPIReady;


public:
    TAPIINT32   m_reasonCode; // 连接断开错误码
    SimpleEvent m_Event;
};

#endif // TRADE_H
