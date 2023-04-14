#pragma once

#include <cstring>
#include <memory>
#include <acl_cpp/stdlib/log.hpp>
#include <acl_cpp/stdlib/string.hpp>
#include <TapQuoteAPI.h>
#include "common/Account.h"
#include "common/SimpleEvent.h"


class Quote : public ITapQuoteAPINotify
{
public:
    Quote(void);
    ~Quote(void);

    void SetAPI(ITapQuoteAPI* pAPI);
    void setAccount(std::shared_ptr<Account> account);
    int RunQuote();
    void loopCmd();
    void printHelp();

    int q_qryCommodity();
    int q_qryContract(const char* ExchangeNo);
    int q_subscribeQuote(const char* ExchangeNo, const char* CommodityNo, const char* ContractNo1);
    int q_unSubscribeQuote(const char* ExchangeNo, const char* CommodityNo, const char* ContractNo);
    int q_disConnect();
    int q_login();

public:
    //对ITapQuoteAPINotify的实现
    virtual void TAP_CDECL OnRspLogin(TAPIINT32 errorCode, const TapAPIQuotLoginRspInfo *info);
    virtual void TAP_CDECL OnAPIReady();
    virtual void TAP_CDECL OnDisconnect(TAPIINT32 reasonCode);
    virtual void TAP_CDECL OnRspChangePassword(TAPIUINT32 sessionID, TAPIINT32 errorCode);
    virtual void TAP_CDECL OnRspQryExchange(TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPIExchangeInfo *info);
    virtual void TAP_CDECL OnRspQryCommodity(TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPIQuoteCommodityInfo *info);
    virtual void TAP_CDECL OnRspQryContract(TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPIQuoteContractInfo *info);
    virtual void TAP_CDECL OnRtnContract(const TapAPIQuoteContractInfo *info);
    virtual void TAP_CDECL OnRspSubscribeQuote(TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPIQuoteWhole *info);
    virtual void TAP_CDECL OnRspUnSubscribeQuote(TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPIContract *info);
    virtual void TAP_CDECL OnRtnQuote(const TapAPIQuoteWhole *info);

public:
    SimpleEvent m_Event;
    TAPIUINT32  m_reasonCode;

private:
    ITapQuoteAPI* m_pAPI;
    TAPIUINT32	m_uiSessionID;
    bool		m_bIsAPIReady;
    std::shared_ptr<Account> m_pAccount;
};
