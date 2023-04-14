#ifndef QUOTE_H
#define QUOTE_H

#include <string>
#include "../esunny/TapQuoteAPI.h"
#include "../common/SimpleEvent.h"

class Quote : public ITapQuoteAPINotify
{
public:
	Quote(void);
	~Quote(void);


	void SetAPI(ITapQuoteAPI* pAPI);
	void RunQuote();

    void loopCmd();
    void printHelp();
    int q_qryCommodity();
    int q_qryContract(std::string ExchangeNo);
    int q_subscribeQuote(std::string ExchangeNo, std::string CommodityNo, std::string ContractNo1);
    int q_unSubscribeQuote(std::string ExchangeNo, std::string CommodityNo, std::string ContractNo);
    int q_disConnect();
    int q_login();

public:
	//对ITapQuoteAPINotify的实现
	virtual void TAP_CDECL OnRspLogin(TAPIINT32 errorCode, const TapAPIQuotLoginRspInfo *info);
	virtual void TAP_CDECL OnAPIReady();
	virtual void TAP_CDECL OnDisconnect(TAPIINT32 reasonCode);
	virtual void TAP_CDECL OnRspQryCommodity(TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPIQuoteCommodityInfo *info);
	virtual void TAP_CDECL OnRspQryContract(TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPIQuoteContractInfo *info);
	virtual void TAP_CDECL OnRspSubscribeQuote(TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPIQuoteWhole *info);
	virtual void TAP_CDECL OnRspUnSubscribeQuote(TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPIContract *info);
	virtual void TAP_CDECL OnRtnQuote(const TapAPIQuoteWhole *info);

private:
	ITapQuoteAPI* m_pAPI;
	TAPIUINT32	m_uiSessionID;
	SimpleEvent m_Event;
	bool		m_bIsAPIReady;

public:
    TAPIUINT32  m_reasonCode;
};

#endif // QUOTE_H
