#include "../../include/trade/Trade.h"
#include "../../include/esunny/iTapAPIError.h"
#include <iostream>
#include <string.h>
#include <time.h>
#include <lib_acl_cpp/include/acl_cpp/redis/redis_pubsub.hpp>
#include "../../include/trade/TradeConfig.h"
#include "../../include/json/value.h"
#include "../../include/spdlog/spdlog.h"
#include "../../include/tool/sw/redis++/redis++.h"
#include "../../include/common/Account.h"
using namespace sw::redis;

extern std::map<std::string, std::shared_ptr<Account>> ACCOUNTS;
extern std::string ConfigFile;
extern Redis       *m_redis;
extern acl::redis_pubsub acl_redis;

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

void Trade::loopCmd()
{
//    this->printHelp();
    while(1)
    {
        TAPIINT32 cmd;
        cin >> cmd;

        if (cin.fail()) {
            cout << "It's not an integer" << endl;
            cout << "Please enter a correct number\n";
            cin.clear();
            cin.ignore();
            continue;
        }

        switch (cmd)
        {
//            case 11: this->t_insertOrder();break;
//            case 12: this->t_canncelOrder();break;
            case 13: this->t_activeOrder();break;
            case 14: this->t_modify();break;

            case 21: this->t_qryAccountCashAdjust();break;
            case 22: this->t_qryHisOrder();break;
            case 23: this->t_qryHisOrderProcess();break;
            case 24: this->t_qryHisMatch();break;
            case 25: this->t_qryHisPosition();break;
            case 26: this->t_qryHisDelivery();break;

            case 31: this->t_qryTradingDate();break;
            case 32: this->t_qryExchange();break;
            case 33: this->t_qryCurrency();break;
            case 34: this->t_qryCommodity();break;
            case 35: this->t_qryContract("");break;

            case 41: this->t_qryAccount();break;
            case 42: this->t_qryFund("RDGJ05");break;
            case 43: this->t_qryTradeMessage();break;

            case 51: this->t_qryOrder("RDGJ06");break;
            case 52: this->t_qryOrderProcess();break;
            case 53: this->t_qryFill("RDGJ06");break;
            case 54: this->t_qryPosition("RDGJ06");break;
            case 55: this->t_qryPositionSummary();break;

            case 61: this->t_changePassword();break;
            case 62: this->t_authPassword();break;
//            case 63: this->t_setReservedInfo();break;
            case 64: this->t_haveCertainRight();break;

            case 71: this->t_qryAccountFeeRent();break;
            case 72: this->t_qryAccountMarginRent();break;
            case 0: this->printHelp();break;
            default:
                break;
        }

    }
}


void Trade::printHelp()
{
	cout<<"---------------------------------\n"
		<< "iTapTradeAPI_Demo CMD\n"
		<< "--->1 : Orders \n"
		    << "\t --->11 : insert order\n"
		    << "\t --->12 : cancle order\n"
		    << "\t --->13 : active order\n"
		    << "\t --->14 : modify order\n"
		<< "--->2 : HisOrder \n"
            << "\t --->21 : qry accountCashAdjust\n"
            << "\t --->22 : qry hisOrder\n"
            << "\t --->23 : qry hisOrderProcess\n"
            << "\t --->24 : qry hisMatch\n"
            << "\t --->25 : qry hisPosition\n"
            << "\t --->26 : qry hisDelivery\n"
		<< "--->3 : Common \n"
            << "\t --->31 : qry TradingDate\n"
            << "\t --->32 : qry ExchangeInfo\n"
            << "\t --->33 : qry CurrencyInfo\n"
            << "\t --->34 : qry commodity\n"
            << "\t --->35 : qry contract\n"
        << "--->4 : UserFund Message \n"
            << "\t --->41 : qry Account\n"
            << "\t --->42 : qry Fund\n"
            << "\t --->43 : qry TradeMessage\n"
        << "--->5 : UserTrade \n"
            << "\t --->51 : qry Order\n"
            << "\t --->52 : qry OrderProcess\n"
            << "\t --->53 : qry Fill\n"
            << "\t --->54 : qry Position\n"
            << "\t --->55 : qry PositionSummary\n"
        << "--->6 : Auth \n"
            << "\t --->61 : changePassword\n"
            << "\t --->62 : authPassword\n"
//            << "\t --->63 : setReservedInfo\n"
            << "\t --->64 : qry CertainRight\n"
        << "--->7 : Rent \n"
            << "\t --->71 : qry accountFeeRent\n"
            << "\t --->72 : qry accountMarginRent\n"

        << "--->0 : help\n"
		<< "----------------------------------\n"
		<< endl;
}


// Rent
void Trade::t_qryAccountFeeRent()
{
    spdlog::info("*************** t_qryAccountFeeRent **************");

    TapAPIAccountFeeRentQryReq qryReq;
    memset(&qryReq, 0, sizeof(qryReq));
    strncpy(qryReq.AccountNo, TRADE_DEFAULT_ACCOUNT_NO, strlen(TRADE_DEFAULT_ACCOUNT_NO));

    TAPIINT32 iErr = TAPIERROR_SUCCEED;
    iErr = m_pAPI->QryAccountFeeRent(&m_uiSessionID, &qryReq);
    if (iErr != TAPIERROR_SUCCEED) {
        spdlog::error("QryAccountFeeRent failed, errorCode:{}", iErr);
    }
}

void Trade::t_qryAccountMarginRent()
{
    spdlog::info("*************** t_qryAccountMarginRent **************");

    TapAPIAccountMarginRentQryReq qryReq;
    memset(&qryReq, 0, sizeof(qryReq));
    strncpy(qryReq.AccountNo, TRADE_DEFAULT_ACCOUNT_NO, strlen(TRADE_DEFAULT_ACCOUNT_NO));
//    strncpy(qryReq.ExchangeNo, TRADE_DEFAULT_EXCHANGE_NO, strlen(TRADE_DEFAULT_EXCHANGE_NO));
    qryReq.CommodityType = TRADE_DEFAULT_COMMODITY_TYPE;
//    strncpy(qryReq.CommodityNo, TRADE_DEFAULT_COMMODITY_NO, strlen(TRADE_DEFAULT_COMMODITY_NO));

    TAPIINT32 iErr = TAPIERROR_SUCCEED;
    m_uiSessionID = 0;
    iErr = m_pAPI->QryAccountMarginRent(&m_uiSessionID, &qryReq);
    if (iErr != TAPIERROR_SUCCEED) {
        spdlog::error("QryAccountMarginRent failed, errorCode: {}", iErr);
    }

}


// Auth
void Trade::t_changePassword()
{
    spdlog::info("*************** t_changePassword **************");

    TAPISTR_20 oldPassword;
    TAPISTR_20 newPassword;
    cout << "please input oldPassword\n";
    cin >> oldPassword;
    cout << "please input newPassword\n";
    cin >> newPassword;

    TapAPIChangePasswordReq req;
    memset(&req, 0, sizeof(req));
    strncpy(req.AccountNo, TRADE_DEFAULT_ACCOUNT_NO, strlen(TRADE_DEFAULT_ACCOUNT_NO));
    req.PasswordType = APIPASSWORD_TRADE;
    strncpy(req.OldPassword, oldPassword, strlen(oldPassword));
    strncpy(req.NewPassword, newPassword, strlen(newPassword));

    TAPIINT32 iErr = m_pAPI->ChangePassword(&m_uiSessionID, &req);
    if (iErr != TAPIERROR_SUCCEED) {
        spdlog::error("ChangePassword failed, errorCode: {}", iErr);
    }

}

void Trade::t_authPassword()
{
    spdlog::info("*************** t_authPassword **************");

    TAPISTR_20 password;
    cout << "please input password\n";
    cin >> password;

    TapAPIAuthPasswordReq req;
    memset(&req, 0, sizeof(req));
    strncpy(req.AccountNo, TRADE_DEFAULT_ACCOUNT_NO, strlen(TRADE_DEFAULT_ACCOUNT_NO));
    req.PasswordType = APIPASSWORD_TRADE;
    strncpy(req.Password, password, strlen(password));

    TAPIINT32 iErr = m_pAPI->AuthPassword(&m_uiSessionID, &req);
    if (iErr != TAPIERROR_SUCCEED) {
        spdlog::error("AuthPassword failed, errorCode: {}", iErr);
    }
}

// 该接口暂未实现
void Trade::t_setReservedInfo()
{
    spdlog::info("*************** t_setReservedInfo **************");

    // 用户可以设置一个长度为50以内的字符信息，下次登录后可以得到这个信息
    // 这个功能主要是用来让用户确认是自己的帐号，主要是用来防伪
    TAPISTR_50 info;
    cout << "please input reservedInfo(<50 characters)\n";
    cin >> info;

    TAPIINT32 iErr = m_pAPI->SetReservedInfo(&m_uiSessionID, info);
    if (iErr != TAPIERROR_SUCCEED) {
        spdlog::error("SetReservedInfo failed, errorCode: {}", iErr);
    }
}

void Trade::t_haveCertainRight()
{
    spdlog::info("*************** t_haveCertainRight **************");

    TAPIINT32 iErr = TAPIERROR_SUCCEED;
    TAPIRightIDType rightID;
    cout << "please input rightID(30001 30002 31000 31001 31002)\n";
    cin >> rightID;
    iErr = m_pAPI->HaveCertainRight(rightID);
    if (iErr == 0) {
        spdlog::error("Do not have this permission, errorCode: {}", iErr);
    } else {
        spdlog::error("Have this permission: {}", rightID);
    }

}

// HisOrder
void Trade::t_qryAccountCashAdjust()
{
    spdlog::info("*************** t_qryAccountCashAdjust **************");

    TAPIDATE beginDate;
    TAPIDATE endDate;
    time_t t = time(0);
    time_t t2 = t - 30*60*60*24;
    strftime(beginDate, sizeof(beginDate), "%Y-%m-%d", localtime(&t2));
    strftime(endDate, sizeof(endDate), "%Y-%m-%d", localtime(&t));

    TapAPIAccountCashAdjustQryReq qryReq;
    memset(&qryReq, 0, sizeof(qryReq));
    strncpy(qryReq.AccountNo, TRADE_DEFAULT_ACCOUNT_NO, strlen(TRADE_DEFAULT_ACCOUNT_NO));
    strncpy(qryReq.BeginDate, beginDate, strlen(beginDate));
    strncpy(qryReq.EndDate, endDate, strlen(endDate));

    TAPIINT32 iErr = TAPIERROR_SUCCEED;
    iErr = m_pAPI->QryAccountCashAdjust(&m_uiSessionID, &qryReq);
    if (iErr != TAPIERROR_SUCCEED) {
        spdlog::error("QryAccountCashAdjust failed, errorCode:{}", iErr);
        return;
    }
}

void Trade::t_qryHisOrder()
{
    spdlog::info("*************** t_qryHisOrder **************");

    TAPIDATE beginDate;
    TAPIDATE endDate;
    time_t t = time(0);
    time_t t2 = t - 60*60*24;
    strftime(beginDate, sizeof(beginDate), "%Y-%m-%d", localtime(&t2));
    strftime(endDate, sizeof(endDate), "%Y-%m-%d", localtime(&t));

    TapAPIHisOrderQryReq qryReq;
    memset(&qryReq, 0, sizeof(qryReq));
    strncpy(qryReq.AccountNo, TRADE_DEFAULT_ACCOUNT_NO, strlen(TRADE_DEFAULT_ACCOUNT_NO));
    strncpy(qryReq.BeginDate, beginDate, strlen(beginDate));
    strncpy(qryReq.EndDate, endDate, strlen(endDate));

    TAPIINT32 iErr = TAPIERROR_SUCCEED;
    iErr = m_pAPI->QryHisOrder(&m_uiSessionID, &qryReq);
    if (iErr != TAPIERROR_SUCCEED) {
        spdlog::error("QryHisOrder failed, errorCode:{}", iErr);
        return;
    }
}

void Trade::t_qryHisOrderProcess()
{
    spdlog::info("*************** t_qryHisOrderProcess **************");

    TapAPIHisOrderProcessQryReq qryReq;
    memset(&qryReq, 0, sizeof(qryReq));
//    TAPISTR_20 orderNo = "OA202101150000000059";
//    TAPIDATE date = "2021-01-15";
    time_t t = time(0);
    TAPIDATE date;
    strftime(date, sizeof(date), "%Y-%m-%d", localtime(&t));
//    strncpy(qryReq.OrderNo, orderNo, strlen(orderNo));
    strncpy(qryReq.Date, date, strlen(date));

    TAPIINT32 iErr = TAPIERROR_SUCCEED;
    iErr = m_pAPI->QryHisOrderProcess(&m_uiSessionID, &qryReq);
    if (iErr != TAPIERROR_SUCCEED) {
        spdlog::error("QryHisOrderProcess failed, errorCode:{}", iErr);
        return;
    }
}

void Trade::t_qryHisMatch()
{
    spdlog::info("*************** t_qryHisMatch **************");

    TAPIDATE beginDate;
    TAPIDATE endDate;
    time_t t = time(0);
    time_t t2 = t - 60*60*24;
    strftime(beginDate, sizeof(beginDate), "%Y-%m-%d", localtime(&t2));
    strftime(endDate, sizeof(endDate), "%Y-%m-%d", localtime(&t));

    TapAPIHisMatchQryReq qryReq;
    memset(&qryReq, 0, sizeof(qryReq));
    strncpy(qryReq.AccountNo, TRADE_DEFAULT_ACCOUNT_NO, strlen(TRADE_DEFAULT_ACCOUNT_NO));
    strncpy(qryReq.BeginDate, beginDate, strlen(beginDate));
    strncpy(qryReq.EndDate, endDate, strlen(endDate));

    TAPIINT32 iErr = TAPIERROR_SUCCEED;
    iErr = m_pAPI->QryHisMatch(&m_uiSessionID, &qryReq);
    if (iErr != TAPIERROR_SUCCEED) {
        spdlog::error("QryHisMatch failed, errorCode:{}", iErr);
        return;
    }
}

void Trade::t_qryHisPosition()
{
    spdlog::info("*************** t_qryHisPosition **************");

    TapAPIHisPositionQryReq qryReq;
    memset(&qryReq, 0, sizeof(qryReq));
//    TAPIDATE date = "2021-01-15";
    time_t t = time(0);
    time_t t2 = t - 60*60*24;
    TAPIDATE date;
    strftime(date, sizeof(date), "%Y-%m-%d", localtime(&t2));
    strncpy(qryReq.AccountNo, TRADE_DEFAULT_ACCOUNT_NO, strlen(TRADE_DEFAULT_ACCOUNT_NO));
    strncpy(qryReq.Date, date, strlen(date));
    qryReq.SettleFlag = SettleFlag_AutoSettle;

    TAPIINT32 iErr = TAPIERROR_SUCCEED;
    iErr = m_pAPI->QryHisPosition(&m_uiSessionID, &qryReq);
    if (iErr != TAPIERROR_SUCCEED) {
        spdlog::error("QryHisPosition failed, errorCode:{}", iErr);
        return;
    }
}

void Trade::t_qryHisDelivery()
{
    spdlog::info("*************** t_qryHisDelivery **************");

    TAPIDATE beginDate;
    TAPIDATE endDate;
    time_t t = time(0);
    time_t t2 = t - 60*60*24;
    strftime(beginDate, sizeof(beginDate), "%Y-%m-%d", localtime(&t2));
    strftime(endDate, sizeof(endDate), "%Y-%m-%d", localtime(&t));

    TapAPIHisDeliveryQryReq qryReq;
    memset(&qryReq, 0, sizeof(qryReq));
    strncpy(qryReq.AccountNo, TRADE_DEFAULT_ACCOUNT_NO, strlen(TRADE_DEFAULT_ACCOUNT_NO));
    strncpy(qryReq.BeginDate, beginDate, strlen(beginDate));
    strncpy(qryReq.EndDate, endDate, strlen(endDate));

    TAPIINT32 iErr = TAPIERROR_SUCCEED;
    iErr = m_pAPI->QryHisDelivery(&m_uiSessionID, &qryReq);
    if (iErr != TAPIERROR_SUCCEED) {
        spdlog::error("QryHisDelivery failed, errorCode:{}", iErr);
        return;
    }
}



int Trade::t_qryOrder(std::string AccountNo)
{
    spdlog::info("*************** t_qryOrder **************");

    TapAPIOrderQryReq qryReq;
    memset(&qryReq, 0, sizeof(qryReq));

    strncpy(qryReq.AccountNo, AccountNo.c_str(), strlen(AccountNo.c_str()));

    TAPIINT32 iErr = TAPIERROR_SUCCEED;
    iErr = m_pAPI->QryOrder(&m_uiSessionID, &qryReq);
    if (iErr != TAPIERROR_SUCCEED) {
        spdlog::error("QryOrder failed, errorCode:{}", iErr);
    }
    return iErr;
}

int Trade::t_qryOrderByOrderNo(std::string AccountNo, std::string OrderNo)
{
    spdlog::info("*************** t_qryOrderByOrderNo **************");

    TapAPIOrderQryReq qryReq;
    memset(&qryReq, 0, sizeof(qryReq));

    strncpy(qryReq.AccountNo, AccountNo.c_str(), strlen(AccountNo.c_str()));
    strncpy(qryReq.OrderNo, OrderNo.c_str(), strlen(OrderNo.c_str()));

    TAPIINT32 iErr = TAPIERROR_SUCCEED;
    iErr = m_pAPI->QryOrder(&m_uiSessionID, &qryReq);
    if (iErr != TAPIERROR_SUCCEED) {
        spdlog::error("t_qryOrderByOrderNo failed, errorCode:{}", iErr);
    }
    return iErr;
}

void Trade::t_qryOrderProcess()
{
    spdlog::info("*************** t_qryOrderProcess **************");

    TapAPIOrderProcessQryReq qryReq;
    memset(&qryReq, 0, sizeof(qryReq));
    TAPISTR_20 orderNo = "OA202101180000000938";
    strncpy(qryReq.OrderNo, orderNo, strlen(orderNo));

    TAPIINT32 iErr = TAPIERROR_SUCCEED;
    iErr = m_pAPI->QryOrderProcess(&m_uiSessionID, &qryReq);
    if (iErr != TAPIERROR_SUCCEED) {
        spdlog::error("QryOrderProcess failed, errorCode:{}", iErr);
        return;
    }
}

int Trade::t_qryFill(std::string AccountNo)
{
    spdlog::info("*************** t_qryFill **************");

    TapAPIFillQryReq qryReq;
    memset(&qryReq, 0, sizeof(qryReq));
//    TAPISTR_20 orderNo = "OA202101150000000059";
//    strncpy(qryReq.OrderNo, orderNo, strlen(orderNo));
    strncpy(qryReq.AccountNo, AccountNo.c_str(), strlen(AccountNo.c_str()));

    TAPIINT32 iErr = TAPIERROR_SUCCEED;
    iErr = m_pAPI->QryFill(&m_uiSessionID, &qryReq);
    if (iErr != TAPIERROR_SUCCEED) {
        spdlog::error("QryFill failed, errorCode:{}", iErr);
    }
    return iErr;
}

int Trade::t_qryFillByOrderNo(std::string AccountNo, std::string OrderNo)
{
    spdlog::info("*************** t_qryFill **************");

    TapAPIFillQryReq qryReq;
    memset(&qryReq, 0, sizeof(qryReq));
    strncpy(qryReq.AccountNo, AccountNo.c_str(), strlen(AccountNo.c_str()));
    strncpy(qryReq.OrderNo, OrderNo.c_str(), strlen(OrderNo.c_str()));
    TAPIINT32 iErr = TAPIERROR_SUCCEED;
    iErr = m_pAPI->QryFill(&m_uiSessionID, &qryReq);
    if (iErr != TAPIERROR_SUCCEED) {
        spdlog::error("t_qryFillByOrderNo failed, errorCode:{}", iErr);
    }
    return iErr;
}

int Trade::t_qryPosition(std::string AccountNo)
{
    spdlog::info("*************** t_qryPosition **************");

    TapAPIPositionQryReq qryReq;
    memset(&qryReq, 0, sizeof(qryReq));
    strncpy(qryReq.AccountNo, AccountNo.c_str(), strlen(AccountNo.c_str()));

    TAPIINT32 iErr = TAPIERROR_SUCCEED;
    iErr = m_pAPI->QryPosition(&m_uiSessionID, &qryReq);
    if (iErr != TAPIERROR_SUCCEED) {
        spdlog::error("QryPosition failed, errorCode:{}", iErr);
    }
    return iErr;
}

void Trade::t_qryPositionSummary()
{
    spdlog::info("*************** t_qryPositionSummary **************");

    TapAPIPositionQryReq qryReq;
    memset(&qryReq, 0, sizeof(qryReq));
    strncpy(qryReq.AccountNo, TRADE_DEFAULT_ACCOUNT_NO, strlen(TRADE_DEFAULT_ACCOUNT_NO));

    TAPIINT32 iErr = TAPIERROR_SUCCEED;
    iErr = m_pAPI->QryPositionSummary(&m_uiSessionID, &qryReq);
    if (iErr != TAPIERROR_SUCCEED) {
        spdlog::error("QryPositionSummary failed, errorCode:{}", iErr);
        return;
    }
}




// UserFund Message
int Trade::t_qryAccount()
{
    spdlog::info("*************** t_qryAccount **************");
    TapAPIAccQryReq *req = new TapAPIAccQryReq();
    TAPIINT32 iErr = TAPIERROR_SUCCEED;
    iErr = m_pAPI->QryAccount(&m_uiSessionID, req);
    if(iErr != TAPIERROR_SUCCEED) {
        spdlog::error("QryAccount failed, errorCode:{}", iErr);
    }
    delete req;
    return iErr;
}

int Trade::t_qryFund(std::string AccountNo)
{
    spdlog::info("*************** t_qryFund **************");

    TAPIINT32 iErr = TAPIERROR_SUCCEED;
    TapAPIFundReq qryReq;
    memset(&qryReq, 0, sizeof(qryReq));

    strncpy(qryReq.AccountNo, AccountNo.c_str(), strlen(AccountNo.c_str()));
    iErr = m_pAPI->QryFund(&m_uiSessionID, &qryReq);
    if(iErr != TAPIERROR_SUCCEED) {
        spdlog::error("QryFund failed, errorCode:{}", iErr);
    }
    return iErr;
}

void Trade::t_qryTradeMessage()
{
    spdlog::info("*************** t_qryTradeMessage **************");

    TapAPITradeMessageReq qryReq;
    TAPIDATETIME beginTime;
    TAPIDATETIME endTime;
    time_t t = time(0);
    time_t t2 = t + 7*60*60*24;
    strftime(beginTime, sizeof(beginTime), "%Y-%m-%d %H:%M;%S", localtime(&t));
    strftime(endTime, sizeof(endTime), "%Y-%m-%d %H:%M;%S", localtime(&t2));

    memset(&qryReq, 0, sizeof(qryReq));
    strncpy(qryReq.AccountNo, TRADE_DEFAULT_ACCOUNT_NO, strlen(TRADE_DEFAULT_ACCOUNT_NO));
//    strncpy(qryReq.AccountAttributeNo, TRADE_DEFAULT_ACCOUNT_NO, strlen(TRADE_DEFAULT_ACCOUNT_NO));
    strncpy(qryReq.BenginSendDateTime, beginTime, strlen(beginTime));
    strncpy(qryReq.EndSendDateTime, endTime, strlen(endTime));


    TAPIINT32 iErr = TAPIERROR_SUCCEED;
    iErr = m_pAPI->QryTradeMessage(&m_uiSessionID, &qryReq);
    if(iErr != TAPIERROR_SUCCEED) {
        spdlog::error("QryTradeMessage, errorCode:{}", iErr);
    }
}



// Common
void Trade::t_qryTradingDate()
{
    spdlog::info("*************** t_qryTradingDate **************");

    TAPIINT32 iErr = TAPIERROR_SUCCEED;
    iErr = m_pAPI->QryTradingDate(&m_uiSessionID);
    if(iErr != TAPIERROR_SUCCEED) {
        spdlog::error("QryTradingDate failed, errorCode:{}", iErr);
        return;
    }
}

int Trade::t_qryExchange()
{
    spdlog::info("*************** t_qryExchange **************");

    TAPIINT32 iErr = TAPIERROR_SUCCEED;
    iErr = m_pAPI->QryExchange(&m_uiSessionID);
    if(iErr != TAPIERROR_SUCCEED) {
        spdlog::error("QryExchange failed, errorCode:{}", iErr);
    }
    return iErr;
}

int Trade::t_qryCurrency()
{
    spdlog::info("*************** t_qryCurrency **************");

    TAPIINT32 iErr = TAPIERROR_SUCCEED;
    iErr = m_pAPI->QryCurrency(&m_uiSessionID);
    if(iErr != TAPIERROR_SUCCEED) {
        spdlog::error("QryCurrency failed, errorCode:{}", iErr);
    }
    return iErr;
}

int Trade::t_qryCommodity()
{
    spdlog::info("*************** t_qryCommodity **************");

    TAPIINT32 iErr = TAPIERROR_SUCCEED;
    iErr = m_pAPI->QryCommodity(&m_uiSessionID);
    return iErr;
}

int Trade::t_qryContract(std::string ExchangeNo)
{
    spdlog::info("*************** t_qryContract **************");

    TAPIINT32 iErr = TAPIERROR_SUCCEED;
    m_uiSessionID = 0;
    TapAPICommodity com;
    memset(&com, 0, sizeof(com));
    if (ExchangeNo == "") {
        ExchangeNo = TRADE_DEFAULT_EXCHANGE_NO;
    }
    strcpy(com.ExchangeNo, ExchangeNo.c_str());
//	strcpy(com.CommodityNo,TRADE_DEFAULT_COMMODITY_NO);
    com.CommodityType =TRADE_DEFAULT_COMMODITY_TYPE;
    iErr = m_pAPI->QryContract(&m_uiSessionID,&com);
    return iErr;
}


int Trade::t_insertOrder(std::string AccountNo, std::string ExchangeNo, std::string CommodityNo,
                         std::string ContractNo, std::string OrderType, std::string TimeInForce,
                         std::string OrderSide, std::string OrderPrice, std::string OrderQty)
{
    spdlog::info("*************** t_insertOrder **************");
    //下单
    TapAPINewOrder stNewOrder;
    strcpy(stNewOrder.AccountNo, AccountNo.c_str());
    strcpy(stNewOrder.ExchangeNo, ExchangeNo.c_str());
    stNewOrder.CommodityType = TAPI_COMMODITY_TYPE_FUTURES;
    strcpy(stNewOrder.CommodityNo, CommodityNo.c_str());
    strcpy(stNewOrder.ContractNo, ContractNo.c_str());
    // 委托类型
    stNewOrder.OrderType = OrderType[0];
    // 委托来源，默认程序单
    stNewOrder.OrderSource = TAPI_ORDER_SOURCE_PROGRAM;
    // 委托有效类型,默认当日有效
    stNewOrder.TimeInForce = TimeInForce[0];
    // 买入卖出
    stNewOrder.OrderSide = OrderSide[0];
    // 委托价格1
    stNewOrder.OrderPrice = atof(OrderPrice.c_str());
    // 委托数量
    stNewOrder.OrderQty = atoi(OrderQty.c_str());

	TAPISTR_50 stClientOrderNo ;
	memset(&stClientOrderNo,0,sizeof(stClientOrderNo));

    TAPIINT32 iErr = TAPIERROR_SUCCEED;
	m_uiSessionID = 0;
	iErr = m_pAPI->InsertOrder(&m_uiSessionID, &stClientOrderNo, &stNewOrder);
	if(TAPIERROR_SUCCEED != iErr) {
        spdlog::error("InsertOrder errorCode: {}", iErr);
	}
	return iErr;
}

int Trade::t_canncelOrder(std::string OrderNo)
{
    spdlog::info("*************** t_canncelOrder **************");

	TapAPIOrderCancelReq req;
	memset(&req,0,sizeof(req));
	strncpy(req.OrderNo, OrderNo.c_str(), strlen(OrderNo.c_str()));

	TAPIUINT32 reqid = 0;
	TAPIINT32 iErr = TAPIERROR_SUCCEED;

	iErr = m_pAPI->CancelOrder(&reqid,&req);
	if(iErr!= TAPIERROR_SUCCEED){
        spdlog::error("CancelOrder errorCode: {}", iErr);
	}
	return iErr;
}

void Trade::t_modify()
{
    spdlog::info("*************** t_modify **************");

    TapAPIAmendOrder req;
	TAPISTR_20	orderNo;
	TAPIREAL64 orderPrice;
	TAPIUINT32 orderQty;
	cout<<"t_modify test"<<endl;
	cout<<"insert orderno"<<endl;
	cin>>orderNo;
	cout<<"insert price"<<endl;
	cin>>orderPrice;
	cout<<"insert qty"<<endl;
	cin>>orderQty;

	strncpy(req.OrderNo,orderNo,strlen(orderNo));
	strncpy(req.ReqData.AccountNo,TRADE_DEFAULT_ACCOUNT_NO,strlen(TRADE_DEFAULT_ACCOUNT_NO));
	req.ReqData.OrderPrice = orderPrice;
	req.ReqData.OrderQty = orderQty;

	TAPIINT32  iErr = TAPIERROR_SUCCEED;
	iErr=m_pAPI->AmendOrder(&m_uiSessionID,&req);
	if(iErr!=TAPIERROR_SUCCEED){
		spdlog::error("AmendOrder errorCode: {}", iErr);
	}
}

void Trade::t_activeOrder()
{
    spdlog::info("*************** t_activeOrder **************");

    TAPISTR_20 orderno;
    cout << "active operator :insert orderno" << endl;
    cin >> orderno;
    TapAPIOrderActivateReq order;

    TapAPIOrderCancelReq req;
    memset(&req,0,sizeof(req));
    strncpy(req.OrderNo,orderno,strlen(orderno));

    TAPIINT32 iErr = TAPIERROR_SUCCEED;
    iErr=m_pAPI->ActivateOrder(&m_uiSessionID,&req);
    if(iErr!=TAPIERROR_SUCCEED){
        spdlog::error("ActivateOrder errorCode: {}", iErr);
    }
}

int Trade::t_disConnect()
{
    // 主动断开服务器链路连接
    TAPIINT32 iErr = TAPIERROR_SUCCEED;
    iErr = m_pAPI->Disconnect();
    if (TAPIERROR_SUCCEED != iErr) {
        spdlog::error("Disconnect Error: {}", iErr);
    } else {
        spdlog::error("connect is broken;");
    }
    return iErr;
}

int Trade::t_login(std::string userNo)
{
    std::cout << "t_login:" << syscall(SYS_gettid) << std::endl;
    TAPIINT32 iErr = TAPIERROR_SUCCEED;
    //登录服务器
    TapAPITradeLoginAuth stLoginAuth;
    // 定义结构体之后建议进行初始化，以免内存乱数据影响结果
    memset(&stLoginAuth, 0, sizeof(stLoginAuth));
    spdlog::info("userNo{}", userNo);
    strcpy(stLoginAuth.UserNo, userNo.c_str());
    strcpy(stLoginAuth.Password, (ACCOUNTS[userNo]->getPassword()).c_str());
    stLoginAuth.ISModifyPassword = APIYNFLAG_NO;
    iErr = m_pAPI->Login(&stLoginAuth);
    if(TAPIERROR_SUCCEED != iErr) {
        spdlog::error("Login Error: {}", iErr);
    }
    return iErr;
}

void Trade::RunTrade(std::string userNo)
{
	if(NULL == m_pAPI) {
        spdlog::error("Error: m_pAPI is NULL.");
		return;
	}

	TAPIINT32 iErr = TAPIERROR_SUCCEED;

    spdlog::info("++++++++++++++++++++++++++++++");

	//设定服务器IP、端口
	if (this->m_reasonCode == 0) {
        iErr = m_pAPI->SetHostAddress(TRADE_DEFAULT_IP, TRADE_DEFAULT_PORT);
        if(TAPIERROR_SUCCEED != iErr) {
            spdlog::error("SetHostAddress Error: {}", iErr);
            return;
        }
	}


    spdlog::info("+*******@@@@@@@@@@@@@@@@@@@@@**************+");

    //登录服务器
    TapAPITradeLoginAuth stLoginAuth;
    // 定义结构体之后建议进行初始化，以免内存乱数据影响结果
    memset(&stLoginAuth, 0, sizeof(stLoginAuth));
    strcpy(stLoginAuth.UserNo, userNo.c_str());
    strcpy(stLoginAuth.Password, (ACCOUNTS[userNo]->getPassword()).c_str());

    spdlog::info("{},{}", stLoginAuth.UserNo, stLoginAuth.Password);

    stLoginAuth.ISModifyPassword = APIYNFLAG_NO;
    iErr = m_pAPI->Login(&stLoginAuth);
    if(TAPIERROR_SUCCEED != iErr) {
        spdlog::error("Login Error: {}", iErr);
        return;
    }



    spdlog::info("+++++++++^^^^^^^^^^^^^^^^^^^^++++++++++");


	//等待APIReady
	// 先执行WaitEvent()，锁定；API准备就绪或登录为成功执行SignalEvent()接触锁定，最后while(true)锁定
	m_Event.WaitEvent();
    cout << "---------------------------------------------------m_bIsAPIReady" << userNo << endl;
	if(!m_bIsAPIReady){
		cout << "API is not ready" << endl;
		return;
	}

    spdlog::info("++++*****************************+++");

	this->t_qryFund(userNo);


	while (true)
	{
	    cout << "---------------------------------------------------recly" << userNo <<  endl;
		m_Event.WaitEvent();
        cout << "---------------------------------------------------m_Event" << userNo << endl;
        return;
	}
}

void TAP_CDECL Trade::OnConnect(const TAPISTR_40 HostAddress)
{
	spdlog::info("{} is called. HostAddress: {}",  __FUNCTION__, HostAddress);
}

void TAP_CDECL Trade::OnRspLogin( TAPIINT32 errorCode, const TapAPITradeLoginRspInfo *loginRspInfo )
{
	if(TAPIERROR_SUCCEED == errorCode) {
//		cout << "登录成功，等待API初始化..." << endl;
        spdlog::info("Log in successfully, wait for API initialization...");
	} else if(TAPIERROR_LOGIN_DDA == errorCode) {
//	    cout << "需要进行二次验证" << endl;
        spdlog::info("A second validation is required");
	} else {
//		cout << "登录失败，错误码:" << errorCode << endl;
        spdlog::info("Login failed, error code: {}, errorCode");
		m_Event.SignalEvent();
	}
}

void TAP_CDECL Trade::OnAPIReady(ITapTrade::TAPIINT32 errorCode)
{
    // 在APIReady中，API自动进行基础数据查询和缓存，缓存的有权限、品种、合约、委托、成交、持仓等等
    spdlog::info("The API initialization is complete");
	m_bIsAPIReady = true;
	m_Event.SignalEvent();
}

void TAP_CDECL Trade::OnDisconnect( TAPIINT32 reasonCode )
{
    spdlog::error("API disconnect, disconnect reason: {}", reasonCode);
    // 解除锁定，TradeThread.cpp 中while(true) 进入循环，重新执行RunTrade，保证重连线程一致
    if (reasonCode == 1 || reasonCode == 2 || reasonCode == 8) {
        this->m_reasonCode = reasonCode;
        m_bIsAPIReady = false;
        m_Event.SignalEvent();
    }
}

void TAP_CDECL Trade::OnRspChangePassword( TAPIUINT32 sessionID, TAPIINT32 errorCode )
{
	spdlog::info("{} is called.",  __FUNCTION__);
	if (errorCode == TAPIERROR_SUCCEED) {
	    cout << "Password changed successfully!" << endl;
	} else {
        cout << "Password changed failed, errorCode: " << errorCode << endl;
	}
}

// 该接口暂未实现
void TAP_CDECL Trade::OnRspSetReservedInfo( TAPIUINT32 sessionID, TAPIINT32 errorCode, const TAPISTR_50 info )
{
	spdlog::info("{} is called.",  __FUNCTION__);

    if (errorCode == TAPIERROR_SUCCEED) {
        cout << "Success to set ReservedInfo! info=" << info << endl;
    } else {
        cout << "Failed to set ReservedInfo, errorCode: " << errorCode << endl;
    }
}

void TAP_CDECL Trade::OnRspQryAccount( TAPIUINT32 sessionID, TAPIUINT32 errorCode, TAPIYNFLAG isLast, const TapAPIAccountInfo *info )
{
	spdlog::info("{} is called.",  __FUNCTION__);

	if(errorCode == TAPIERROR_SUCCEED) {

//        std::string value;
//        Config configSettings(ConfigFile);
//        std::string http_client_host = configSettings.Read("http_client_host", value);
//        std::string http_client_port = configSettings.Read("http_client_port", value);
//        const char* clientHostPort = ("http://" + http_client_host + ":" + http_client_port).c_str();
//        const char* path = configSettings.Read("http_client_path", value).c_str();
//        cout << clientHostPort << "-" << path << endl;
//
//        Client cli(clientHostPort);
//        std::multimap<string, string> params;
//        params.insert({
//                              {"AccountNo", info->AccountNo}
//                      });
//        auto res = cli.Post(clientHostPort, params);
//
//        if (res) {
//            cout << res->status << endl;
//            cout << res->reason << endl;
//            cout << res->body << endl;
//        }




        Json::Value jObject;
        std::string AccountType(1, info->AccountType);
        std::string AccountState(1, info->AccountState);
        std::string AccountTradeRight(1, info->AccountTradeRight);
        jObject["AccountNo"] = info->AccountNo;
        jObject["AccountType"] = AccountType;
        jObject["AccountState"] = AccountState;
        jObject["AccountTradeRight"] = AccountTradeRight;
        jObject["CommodityGroupNo"] = info->CommodityGroupNo;
        jObject["AccountShortName"] = info->AccountShortName;
        jObject["AccountEnShortName"] = info->AccountEnShortName;

        std::string str = jObject.toStyledString();
//        try {
//            m_redis->publish("TopicQryAccountInfo", str);
//        } catch (const sw::redis::Error &err) {
//            // other errors
//            spdlog::error("RedisError: {}", err.what());
//        }
        spdlog::info("OnRspQryAccount: {}", str);

	    if(isLast == 'Y') {
	        cout << __FUNCTION__ << " is Last." << endl;
	    }
	} else {
	    cout << "OnRspQryAccount failed, errorCode: " << errorCode << endl;
	}
}

void TAP_CDECL Trade::OnRspQryFund( TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPIFundData *info )
{
	if(TAPIERROR_SUCCEED == errorCode) {
	    if (info != NULL) {
        spdlog::info("{} is called.",  __FUNCTION__);

//            std::string value;
//            Config configSettings(ConfigFile);
//            std::string http_client_host = configSettings.Read("http_client_host", value);
//            std::string http_client_port = configSettings.Read("http_client_port", value);
//            const char* clientHostPort = ("http://" + http_client_host + ":" + http_client_port).c_str();
//            const char* path = configSettings.Read("http_client_path", value).c_str();
//            cout << clientHostPort << "-" << path << endl;
//
//            Client cli(clientHostPort);
//            std::multimap<string, string> params;
//            params.insert({
//                                  {"AccountNo", info->AccountNo},
//                                  {"CurrencyNo", info->CurrencyNo},
//                                  {"Equity", to_string(info->Equity)},
//                                  {"Available", to_string(info->Available)},
//                                  {"CloseProfit", to_string(info->CloseProfit)}
//                          });
//            auto res = cli.Post(path, params);
//
//            if (res) {
//                cout << res->status << endl;
//                cout << res->reason << endl;
//                cout << res->body << endl;
//            }

            Json::Value jObject;
            std::string FutureAlg(1, info->FutureAlg);
            std::string OptionAlg(1, info->OptionAlg);
            jObject["AccountNo"] = info->AccountNo;
            jObject["CurrencyGroupNo"] = info->CurrencyGroupNo;
            jObject["CurrencyNo"] = info->CurrencyNo;
            jObject["TradeRate"] = info->TradeRate;
            jObject["FutureAlg"] = FutureAlg;
            jObject["OptionAlg"] = OptionAlg;
            jObject["PreBalance"] = info->PreBalance;
            jObject["PreUnExpProfit"] = info->PreUnExpProfit;
            jObject["PreLMEPositionProfit"] = info->PreLMEPositionProfit;
            jObject["PreEquity"] = info->PreEquity;
            jObject["PreAvailable1"] = info->PreAvailable1;
            jObject["PreMarketEquity"] = info->PreMarketEquity;
            jObject["CashInValue"] = info->CashInValue;
            jObject["CashOutValue"] = info->CashOutValue;
            jObject["CashAdjustValue"] = info->CashAdjustValue;
            jObject["CashPledged"] = info->CashPledged;
            jObject["FrozenFee"] = info->FrozenFee;
            jObject["FrozenDeposit"] = info->FrozenDeposit;
            jObject["AccountFee"] = info->AccountFee;
            jObject["SwapInValue"] = info->SwapInValue;
            jObject["SwapOutValue"] = info->SwapOutValue;
            jObject["PremiumIncome"] = info->PremiumIncome;
            jObject["PremiumPay"] = info->PremiumPay;
            jObject["CloseProfit"] = info->CloseProfit;
            jObject["FrozenFund"] = info->FrozenFund;
            jObject["UnExpProfit"] = info->UnExpProfit;
            jObject["ExpProfit"] = info->ExpProfit;
            jObject["PositionProfit"] = info->PositionProfit;
            jObject["LmePositionProfit"] = info->LmePositionProfit;
            jObject["OptionMarketValue"] = info->OptionMarketValue;
            jObject["AccountIntialMargin"] = info->AccountIntialMargin;
            jObject["AccountMaintenanceMargin"] = info->AccountMaintenanceMargin;
            jObject["UpperInitalMargin"] = info->UpperInitalMargin;
            jObject["UpperMaintenanceMargin"] = info->UpperMaintenanceMargin;
            jObject["Discount"] = info->Discount;
            jObject["Balance"] = info->Balance;
            jObject["Equity"] = info->Equity;
            jObject["Available"] = info->Available;
            jObject["CanDraw"] = info->CanDraw;
            jObject["MarketEquity"] = info->MarketEquity;
            jObject["AuthMoney"] = info->AuthMoney;

            std::string str = jObject.toStyledString();
//            try {
//                m_redis->publish("TopicFundData", str);
//            } catch (const sw::redis::Error &err) {
//                // other errors
//                spdlog::error("RedisError: {}", err.what());
//            }
            spdlog::info("OnRspQryFund: {}", str);

            if(isLast == 'Y') return;
        } else {
            cout << "Fund is  NULL" << endl;
        }
	} else {
	    cout << "OnRspQryFund Failed, errorCode: " << errorCode << endl;
	}
}

void TAP_CDECL Trade::OnRtnFund( const ITapTrade::TapAPIFundData *info )
{
	spdlog::info("{} is called.",  __FUNCTION__);

	if (info == NULL) return;

    Json::Value jObject;
    std::string FutureAlg(1, info->FutureAlg);
    std::string OptionAlg(1, info->OptionAlg);
    jObject["AccountNo"] = info->AccountNo;
    jObject["CurrencyGroupNo"] = info->CurrencyGroupNo;
    jObject["CurrencyNo"] = info->CurrencyNo;
    jObject["TradeRate"] = info->TradeRate;
    jObject["FutureAlg"] = FutureAlg;
    jObject["OptionAlg"] = OptionAlg;
    jObject["PreBalance"] = info->PreBalance;
    jObject["PreUnExpProfit"] = info->PreUnExpProfit;
    jObject["PreLMEPositionProfit"] = info->PreLMEPositionProfit;
    jObject["PreEquity"] = info->PreEquity;
    jObject["PreAvailable1"] = info->PreAvailable1;
    jObject["PreMarketEquity"] = info->PreMarketEquity;
    jObject["CashInValue"] = info->CashInValue;
    jObject["CashOutValue"] = info->CashOutValue;
    jObject["CashAdjustValue"] = info->CashAdjustValue;
    jObject["CashPledged"] = info->CashPledged;
    jObject["FrozenFee"] = info->FrozenFee;
    jObject["FrozenDeposit"] = info->FrozenDeposit;
    jObject["AccountFee"] = info->AccountFee;
    jObject["SwapInValue"] = info->SwapInValue;
    jObject["SwapOutValue"] = info->SwapOutValue;
    jObject["PremiumIncome"] = info->PremiumIncome;
    jObject["PremiumPay"] = info->PremiumPay;
    jObject["CloseProfit"] = info->CloseProfit;
    jObject["FrozenFund"] = info->FrozenFund;
    jObject["UnExpProfit"] = info->UnExpProfit;
    jObject["ExpProfit"] = info->ExpProfit;
    jObject["PositionProfit"] = info->PositionProfit;
    jObject["LmePositionProfit"] = info->LmePositionProfit;
    jObject["OptionMarketValue"] = info->OptionMarketValue;
    jObject["AccountIntialMargin"] = info->AccountIntialMargin;
    jObject["AccountMaintenanceMargin"] = info->AccountMaintenanceMargin;
    jObject["UpperInitalMargin"] = info->UpperInitalMargin;
    jObject["UpperMaintenanceMargin"] = info->UpperMaintenanceMargin;
    jObject["Discount"] = info->Discount;
    jObject["Balance"] = info->Balance;
    jObject["Equity"] = info->Equity;
    jObject["Available"] = info->Available;
    jObject["CanDraw"] = info->CanDraw;
    jObject["MarketEquity"] = info->MarketEquity;
    jObject["AuthMoney"] = info->AuthMoney;

    std::string str = jObject.toStyledString();
//    try {
//        m_redis->publish("TopicFundData", str);
//    } catch (const sw::redis::Error &err) {
//        // other errors
//        spdlog::error("RedisError: {}", err.what());
//    }
    spdlog::info("OnRtnFund: {}", str);
}

void TAP_CDECL Trade::OnRspQryExchange( TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const ITapTrade::TapAPIExchangeInfo *info )
{
    spdlog::info("{} is called.",  __FUNCTION__);
    std::map<std::string, std::string> map_info;
    map_info.insert({
                            {"ExchangeNo", info->ExchangeNo},
                            {"ExchangeName", info->ExchangeName}
                    });

    Json::Value jObject;
    for (std::map<std::string, std::string>::const_iterator iter = map_info.begin( ); iter != map_info.end( ); ++iter)
    {
        jObject[iter->first] = iter->second;
    }
    std::string str = jObject.toStyledString();
//    try {
//        m_redis->publish("TopicQryExchangeInfo", str);
//    } catch (const sw::redis::Error &err) {
//        // other errors
//        spdlog::error("RedisError: {}", err.what());
//    }
    spdlog::info("OnRspQryExchange: {}", str);

    if(isLast == 'Y')
    {
        cout << __FUNCTION__ << " is Last" << endl;
        return;
    }
}

void TAP_CDECL Trade::OnRspQryCommodity( TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPICommodityInfo *info )
{


    if(TAPIERROR_SUCCEED == errorCode)
    {
        if (info == NULL) return;

//        if ((strcmp(info->ExchangeNo, "NYMEX")) || (strcmp(info->ExchangeNo, "COMEX"))) {
//        }
        spdlog::info("{} is called.",  __FUNCTION__);
        std::map<std::string, std::string> map_info;
        std::string CommodityType(1, info->CommodityType);
        std::string RelateCommodityType(1, info->RelateCommodityType);
        std::string RelateCommodityType2(1, info->RelateCommodityType2);
        std::string OpenCloseMode(1, info->OpenCloseMode);
        std::string CmbDirect(1, info->CmbDirect);
        std::string DeliveryMode(1, info->DeliveryMode);
        std::string IsAddOne(1,info->IsAddOne);
        map_info.insert({
                                {"ExchangeNo", info->ExchangeNo},
                                {"CommodityType", CommodityType},
                                {"CommodityNo", info->CommodityNo},
                                {"CommodityName", info->CommodityName},
                                {"CommodityEngName", info->CommodityEngName},
                                {"RelateExchangeNo", info->RelateExchangeNo},
                                {"RelateCommodityType", RelateCommodityType},
                                {"RelateCommodityNo", info->RelateCommodityNo},
                                {"RelateExchangeNo2", info->RelateExchangeNo2},
                                {"RelateCommodityType2", RelateCommodityType2},
                                {"RelateCommodityNo2", info->RelateCommodityNo2},
                                {"CurrencyGroupNo", info->CurrencyGroupNo},
                                {"TradeCurrency", info->TradeCurrency},
                                {"ContractSize", to_string(info->ContractSize)},
                                {"OpenCloseMode", OpenCloseMode},
                                {"StrikePriceTimes", to_string(info->StrikePriceTimes)},
                                {"CommodityTickSize", to_string(info->CommodityTickSize)},
                                {"CommodityDenominator", to_string(info->CommodityDenominator)},
                                {"CmbDirect", CmbDirect},
                                {"DeliveryMode", DeliveryMode},
                                {"DeliveryDays", to_string(info->DeliveryDays)},
                                {"AddOneTime", info->AddOneTime},
                                {"CommodityTimeZone", to_string(info->CommodityTimeZone)},
                                {"IsAddOne", IsAddOne}
                        });

        Json::Value jObject;
        for (std::map<std::string, std::string>::const_iterator iter = map_info.begin( ); iter != map_info.end( ); ++iter)
        {
            jObject[iter->first] = iter->second;
        }
        std::string str = jObject.toStyledString();
//        try {
//            m_redis->publish("TopicQryExchangeCommodity", str);
//        } catch (const sw::redis::Error &err) {
//            // other errors
//            spdlog::error("RedisError: {}", err.what());
//        }
        spdlog::info("OnRspQryCommodity: {}", str);

        if(isLast=='Y')
        {
            cout << __FUNCTION__ << " is Last." << endl;
            return;
        }
    } else
    {
        cout << "品种信息获取失败, 错误码: " << errorCode << endl;
        cout << "commodities retrieval failed, errorCode" << errorCode << endl;
    }
}

void TAP_CDECL Trade::OnRspQryContract( TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPITradeContractInfo *info )
{

//    if ((strcmp(info->ExchangeNo, "NYMEX")) || (strcmp(info->ExchangeNo, "COMEX"))) {
//    }
    spdlog::info("{} is called.",  __FUNCTION__);
    if (info == NULL) return;

    std::map<std::string, std::string> map_info;
    std::string CommodityType(1, info->CommodityType);
    std::string CallOrPutFlag1(1, info->CallOrPutFlag1);
    std::string CallOrPutFlag2(1, info->CallOrPutFlag2);
    std::string ContractType(1, info->ContractType);
    map_info.insert({
                            {"ExchangeNo", info->ExchangeNo},
                            {"CommodityType", CommodityType},
                            {"CommodityNo", info->CommodityNo},
                            {"ContractNo1", info->ContractNo1},
                            {"StrikePrice1", info->StrikePrice1},
                            {"CallOrPutFlag1", CallOrPutFlag1},
                            {"ContractNo2", info->ContractNo2},
                            {"StrikePrice2", info->StrikePrice2},
                            {"CallOrPutFlag2", CallOrPutFlag2},
                            {"ContractType", ContractType},
                            {"QuoteUnderlyingContract", info->QuoteUnderlyingContract},
                            {"ContractName", info->ContractName},
                            {"ContractExpDate", info->ContractExpDate},
                            {"LastTradeDate", info->LastTradeDate},
                            {"FirstNoticeDate", info->FirstNoticeDate}
                    });

    Json::Value jObject;
    for (std::map<std::string, std::string>::const_iterator iter = map_info.begin( ); iter != map_info.end( ); ++iter)
    {
        jObject[iter->first] = iter->second;
    }
    std::string str = jObject.toStyledString();
//    try {
//        m_redis->publish("TopicQryExchangeContract", str);
//    } catch (const sw::redis::Error &err) {
//        // other errors
//        spdlog::error("RedisError: {}", err.what());
//    }
    spdlog::info("OnRspQryContract: {}", str);

    if(isLast == 'Y')
    {
        cout<< __FUNCTION__<<" is last" << endl;
        return ;
    }
}

void TAP_CDECL Trade::OnRtnContract( const TapAPITradeContractInfo *info )
{
	spdlog::info("{} is called.",  __FUNCTION__);

	if (NULL != info) {
        cout << "contract: " << "{"
             << "ExchangeNo:" << info->ExchangeNo << ","
             << "CommodityType:" << info->CommodityType << ","
             << "CommodityNo:" << info->CommodityNo << ","
             << "ContractNo1:" << info->ContractNo1 << ","
             << "StrikePrice1:" << info->StrikePrice1 << ","
             << "CallOrPutFlag1:" << info->CallOrPutFlag1 << ","
             << "ContractNo2:" << info->ContractNo2 << ","
             << "StrikePrice2:" << info->StrikePrice2 << ","
             << "ContractType:" << info->ContractType << ","
             << "QuoteUnderlyingContract:" << info->QuoteUnderlyingContract << ","
             << "ContractName:" << info->ContractName << ","
             << "ContractExpDate:" << info->ContractExpDate << ","
             << "LastTradeDate:" << info->LastTradeDate << ","
             << "FirstNoticeDate:" << info->FirstNoticeDate
             << "}" << endl;
	}



}

void TAP_CDECL Trade::OnRtnOrder( const TapAPIOrderInfoNotice *info )
{
	spdlog::info("{} is called.",  __FUNCTION__);

	if(NULL == info){
		return;
	}

	if(info->ErrorCode != 0) {
//		cout << "服务器返回了一个关于委托信息的错误：" << info->ErrorCode << endl;
        cout << "The server returned an error about delegate information:" << info->ErrorCode << endl;
	} else {
		if (info->OrderInfo) {
			if(0!= info->OrderInfo->ErrorCode){
                cout << "Declaration for failure: "
                            << "errorCode:"<<info->OrderInfo->ErrorCode << ","
                            << "orderNo:"<<info->OrderInfo->OrderNo
                            << endl;
			} else {

                Json::Value jObject;
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

                jObject["AccountNo"] = info->OrderInfo->AccountNo;
                jObject["ExchangeNo"] = info->OrderInfo->ExchangeNo;
                jObject["CommodityType"] = CommodityType;
                jObject["CommodityNo"] = info->OrderInfo->CommodityNo;
                jObject["ContractNo"] = info->OrderInfo->ContractNo;
                jObject["StrikePrice"] = info->OrderInfo->StrikePrice;
                jObject["CallOrPutFlag"] = CallOrPutFlag;
                jObject["ContractNo2"] = info->OrderInfo->ContractNo2;
                jObject["StrikePrice2"] = info->OrderInfo->StrikePrice2;
                jObject["CallOrPutFlag2"] = CallOrPutFlag2;
                jObject["OrderType"] = OrderType;
                jObject["OrderSource"] = OrderSource;
                jObject["TimeInForce"] = TimeInForce;
                jObject["ExpireTime"] = info->OrderInfo->ExpireTime;
                jObject["IsRiskOrder"] = IsRiskOrder;
                jObject["OrderSide"] = OrderSide;
                jObject["PositionEffect"] = PositionEffect;
                jObject["PositionEffect2"] = PositionEffect2;
                jObject["HedgeFlag"] = HedgeFlag;
                jObject["OrderPrice"] = info->OrderInfo->OrderPrice;
                jObject["OrderPrice2"] = info->OrderInfo->OrderPrice2;
                jObject["StopPrice"] = info->OrderInfo->StopPrice;
                jObject["OrderQty"] = info->OrderInfo->OrderQty;
                jObject["OrderMinQty"] = info->OrderInfo->OrderMinQty;
                jObject["RefInt"] = info->OrderInfo->RefInt;
                jObject["RefDouble"] = info->OrderInfo->RefDouble;
                jObject["RefString"] = info->OrderInfo->RefString;
                jObject["MinClipSize"] = info->OrderInfo->MinClipSize;
                jObject["MaxClipSize"] = info->OrderInfo->MaxClipSize;
                jObject["LicenseNo"] = info->OrderInfo->LicenseNo;
                jObject["ServerFlag"] = ServerFlag;
                jObject["OrderNo"] = info->OrderInfo->OrderNo;
                jObject["ClientOrderNo"] = info->OrderInfo->ClientOrderNo;
                jObject["ClientID"] = info->OrderInfo->ClientID;
                jObject["TacticsType"] = TacticsType;
                jObject["TriggerCondition"] = TriggerCondition;
                jObject["TriggerPriceType"] = TriggerPriceType;
                jObject["AddOneIsValid"] = AddOneIsValid;
                jObject["ClientLocalIP"] = info->OrderInfo->ClientLocalIP;
                jObject["ClientMac"] = info->OrderInfo->ClientMac;
                jObject["ClientIP"] = info->OrderInfo->ClientIP;
                jObject["OrderStreamID"] = info->OrderInfo->OrderStreamID;
                jObject["UpperNo"] = info->OrderInfo->UpperNo;
                jObject["UpperChannelNo"] = info->OrderInfo->UpperChannelNo;
                jObject["OrderLocalNo"] = info->OrderInfo->OrderLocalNo;
                jObject["UpperStreamID"] = info->OrderInfo->UpperStreamID;
                jObject["OrderSystemNo"] = info->OrderInfo->OrderSystemNo;
                jObject["OrderExchangeSystemNo"] = info->OrderInfo->OrderExchangeSystemNo;
                jObject["OrderParentSystemNo"] = info->OrderInfo->OrderParentSystemNo;
                jObject["OrderInsertUserNo"] = info->OrderInfo->OrderInsertUserNo;
                jObject["OrderInsertTime"] = info->OrderInfo->OrderInsertTime;
                jObject["OrderCommandUserNo"] = info->OrderInfo->OrderCommandUserNo;
                jObject["OrderUpdateUserNo"] = info->OrderInfo->OrderUpdateUserNo;
                jObject["OrderUpdateTime"] = info->OrderInfo->OrderUpdateTime;
                jObject["OrderState"] = OrderState;
                jObject["OrderMatchPrice"] = info->OrderInfo->OrderMatchPrice;
                jObject["OrderMatchPrice2"] = info->OrderInfo->OrderMatchPrice2;
                jObject["OrderMatchQty"] = info->OrderInfo->OrderMatchQty;
                jObject["OrderMatchQty2"] = info->OrderInfo->OrderMatchQty2;
                jObject["IsBackInput"] = IsBackInput;
                jObject["IsDeleted"] = IsDeleted;
                jObject["IsAddOne"] = IsAddOne;
                jObject["ErrorCode"] = info->ErrorCode;
                jObject["ErrorText"] = info->OrderInfo->ErrorText;
                jObject["SessionID"] = info->SessionID;
                jObject["InquiryNo"] = info->OrderInfo->InquiryNo;

                std::string str = jObject.toStyledString();
//                try {
//                    m_redis->publish("TopicOrderInfo", str);
//                } catch (const sw::redis::Error &err) {
//                    // other errors
//                    spdlog::error("RedisError: {}", err.what());
//                }
                spdlog::info("OnRtnOrder: {}", str);
			}
		}
	}

}

void TAP_CDECL Trade::OnRspOrderAction( TAPIUINT32 sessionID, TAPIINT32 errorCode, const TapAPIOrderActionRsp *info)
{
    spdlog::info("{} is called.",  __FUNCTION__);

    cout << "sessionID=" << sessionID << endl;
    if (errorCode == TAPIERROR_SUCCEED) {
        cout << "ActionType:" << info->ActionType << endl;
        if (NULL != info->OrderInfo) {
            if (info->OrderInfo->ErrorCode == TAPIERROR_SUCCEED) {
                Json::Value jObject;
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
                std::string ActionType(1, info->ActionType);
                jObject["ActionType"] = ActionType;
                jObject["AccountNo"] = info->OrderInfo->AccountNo;
                jObject["ExchangeNo"] = info->OrderInfo->ExchangeNo;
                jObject["CommodityType"] = CommodityType;
                jObject["CommodityNo"] = info->OrderInfo->CommodityNo;
                jObject["ContractNo"] = info->OrderInfo->ContractNo;
                jObject["StrikePrice"] = info->OrderInfo->StrikePrice;
                jObject["CallOrPutFlag"] = CallOrPutFlag;
                jObject["ContractNo2"] = info->OrderInfo->ContractNo2;
                jObject["StrikePrice2"] = info->OrderInfo->StrikePrice2;
                jObject["CallOrPutFlag2"] = CallOrPutFlag2;
                jObject["OrderType"] = OrderType;
                jObject["OrderSource"] = OrderSource;
                jObject["TimeInForce"] = TimeInForce;
                jObject["ExpireTime"] = info->OrderInfo->ExpireTime;
                jObject["IsRiskOrder"] = IsRiskOrder;
                jObject["OrderSide"] = OrderSide;
                jObject["PositionEffect"] = PositionEffect;
                jObject["PositionEffect2"] = PositionEffect2;
                jObject["HedgeFlag"] = HedgeFlag;
                jObject["InquiryNo"] = info->OrderInfo->InquiryNo;
                jObject["OrderPrice"] = info->OrderInfo->OrderPrice;
                jObject["OrderPrice2"] = info->OrderInfo->OrderPrice2;
                jObject["StopPrice"] = info->OrderInfo->StopPrice;
                jObject["OrderQty"] = info->OrderInfo->OrderQty;
                jObject["OrderMinQty"] = info->OrderInfo->OrderMinQty;
                jObject["RefInt"] = info->OrderInfo->RefInt;
                jObject["RefDouble"] = info->OrderInfo->RefDouble;
                jObject["RefString"] = info->OrderInfo->RefString;
                jObject["MinClipSize"] = info->OrderInfo->MinClipSize;
                jObject["MaxClipSize"] = info->OrderInfo->MaxClipSize;
                jObject["LicenseNo"] = info->OrderInfo->LicenseNo;
                jObject["ServerFlag"] = ServerFlag;
                jObject["OrderNo"] = info->OrderInfo->OrderNo;
                jObject["ClientOrderNo"] = info->OrderInfo->ClientOrderNo;
                jObject["ClientID"] = info->OrderInfo->ClientID;
                jObject["TacticsType"] = TacticsType;
                jObject["TriggerCondition"] = TriggerCondition;
                jObject["TriggerPriceType"] = TriggerPriceType;
                jObject["AddOneIsValid"] = AddOneIsValid;
                jObject["ClientLocalIP"] = info->OrderInfo->ClientLocalIP;
                jObject["ClientMac"] = info->OrderInfo->ClientMac;
                jObject["ClientIP"] = info->OrderInfo->ClientIP;
                jObject["OrderStreamID"] = info->OrderInfo->OrderStreamID;
                jObject["UpperNo"] = info->OrderInfo->UpperNo;
                jObject["UpperChannelNo"] = info->OrderInfo->UpperChannelNo;
                jObject["OrderLocalNo"] = info->OrderInfo->OrderLocalNo;
                jObject["UpperStreamID"] = info->OrderInfo->UpperStreamID;
                jObject["OrderSystemNo"] = info->OrderInfo->OrderSystemNo;
                jObject["OrderExchangeSystemNo"] = info->OrderInfo->OrderExchangeSystemNo;
                jObject["OrderParentSystemNo"] = info->OrderInfo->OrderParentSystemNo;
                jObject["OrderInsertUserNo"] = info->OrderInfo->OrderInsertUserNo;
                jObject["OrderInsertTime"] = info->OrderInfo->OrderInsertTime;
                jObject["OrderCommandUserNo"] = info->OrderInfo->OrderCommandUserNo;
                jObject["OrderUpdateUserNo"] = info->OrderInfo->OrderUpdateUserNo;
                jObject["OrderUpdateTime"] = info->OrderInfo->OrderUpdateTime;
                jObject["OrderState"] = OrderState;
                jObject["OrderMatchPrice"] = info->OrderInfo->OrderMatchPrice;
                jObject["OrderMatchPrice2"] = info->OrderInfo->OrderMatchPrice2;
                jObject["OrderMatchQty"] = info->OrderInfo->OrderMatchQty;
                jObject["OrderMatchQty2"] = info->OrderInfo->OrderMatchQty2;
                jObject["IsBackInput"] = IsBackInput;
                jObject["IsDeleted"] = IsDeleted;
                jObject["IsAddOne"] = IsAddOne;
                jObject["ErrorCode"] = info->OrderInfo->ErrorCode;
                jObject["ErrorText"] = info->OrderInfo->ErrorText;

                std::string str = jObject.toStyledString();
//                try {
//                    m_redis->publish("TopicOrderInfo", str);
//                } catch (const sw::redis::Error &err) {
//                    // other errors
//                    spdlog::error("RedisError: {}", err.what());
//                }
                spdlog::info("OnRspOrderAction: {}", str);

            } else {
                cout << "OrderInfo failed, errorCode:" << errorCode << endl;
            }
        } else {
            // 订单信息指针部分情况下可能为空，如果为空，可以通过sessionID找到对应请求获取请求类型
        }

    } else {
        cout << "OnRspOrderAction failed, errorCode: " << errorCode << endl;
    }
}


void TAP_CDECL Trade::OnRspQryOrder( TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPIOrderInfo *info )
{

    spdlog::info("{} is called.",  __FUNCTION__);

    if (errorCode == TAPIERROR_SUCCEED) {

        if (NULL != info) {
             if (info->ErrorCode != 0 && info->OrderState != '6') {
                cout << "The server returned an error about delegate information:" << info->ErrorCode  << endl;
//                 Json::Value jObject;
//                 jObject["ErrorCode"] = info->ErrorText;
//                 jObject["ErrorText"] = info->ErrorText;
//                 std::string str = jObject.toStyledString();
//                 spdlog::info("OnRspQryOrder= {}", str);
//                 m_redis->publish("TopicOrderInfo", str);
            } else {

                 Json::Value jObject;
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

                 jObject["AccountNo"] = info->AccountNo;
                 jObject["ExchangeNo"] = info->ExchangeNo;
                 jObject["CommodityType"] = CommodityType;
                 jObject["CommodityNo"] = info->CommodityNo;
                 jObject["ContractNo"] = info->ContractNo;
                 jObject["StrikePrice"] = info->StrikePrice;
                 jObject["CallOrPutFlag"] = CallOrPutFlag;
                 jObject["ContractNo2"] = info->ContractNo2;
                 jObject["StrikePrice2"] = info->StrikePrice2;
                 jObject["CallOrPutFlag2"] = CallOrPutFlag2;
                 jObject["OrderType"] = OrderType;
                 jObject["OrderSource"] = OrderSource;
                 jObject["TimeInForce"] = TimeInForce;
                 jObject["ExpireTime"] = info->ExpireTime;
                 jObject["IsRiskOrder"] = IsRiskOrder;
                 jObject["OrderSide"] = OrderSide;
                 jObject["PositionEffect"] = PositionEffect;
                 jObject["PositionEffect2"] = PositionEffect2;
                 jObject["HedgeFlag"] = HedgeFlag;
                 jObject["InquiryNo"] = info->InquiryNo;
                 jObject["OrderPrice"] = info->OrderPrice;
                 jObject["OrderPrice2"] = info->OrderPrice2;
                 jObject["StopPrice"] = info->StopPrice;
                 jObject["OrderQty"] = info->OrderQty;
                 jObject["OrderMinQty"] = info->OrderMinQty;
                 jObject["RefInt"] = info->RefInt;
                 jObject["RefDouble"] = info->RefDouble;
                 jObject["RefString"] = info->RefString;
                 jObject["MinClipSize"] = info->MinClipSize;
                 jObject["MaxClipSize"] = info->MaxClipSize;
                 jObject["LicenseNo"] = info->LicenseNo;
                 jObject["ServerFlag"] = ServerFlag;
                 jObject["OrderNo"] = info->OrderNo;
                 jObject["ClientOrderNo"] = info->ClientOrderNo;
                 jObject["ClientID"] = info->ClientID;
                 jObject["TacticsType"] = TacticsType;
                 jObject["TriggerCondition"] = TriggerCondition;
                 jObject["TriggerPriceType"] = TriggerPriceType;
                 jObject["AddOneIsValid"] = AddOneIsValid;
                 jObject["ClientLocalIP"] = info->ClientLocalIP;
                 jObject["ClientMac"] = info->ClientMac;
                 jObject["ClientIP"] = info->ClientIP;
                 jObject["OrderStreamID"] = info->OrderStreamID;
                 jObject["UpperNo"] = info->UpperNo;
                 jObject["UpperChannelNo"] = info->UpperChannelNo;
                 jObject["OrderLocalNo"] = info->OrderLocalNo;
                 jObject["UpperStreamID"] = info->UpperStreamID;
                 jObject["OrderSystemNo"] = info->OrderSystemNo;
                 jObject["OrderExchangeSystemNo"] = info->OrderExchangeSystemNo;
                 jObject["OrderParentSystemNo"] = info->OrderParentSystemNo;
                 jObject["OrderInsertUserNo"] = info->OrderInsertUserNo;
                 jObject["OrderInsertTime"] = info->OrderInsertTime;
                 jObject["OrderCommandUserNo"] = info->OrderCommandUserNo;
                 jObject["OrderUpdateUserNo"] = info->OrderUpdateUserNo;
                 jObject["OrderUpdateTime"] = info->OrderUpdateTime;
                 jObject["OrderState"] = OrderState;
                 jObject["OrderMatchPrice"] = info->OrderMatchPrice;
                 jObject["OrderMatchPrice2"] = info->OrderMatchPrice2;
                 jObject["OrderMatchQty"] = info->OrderMatchQty;
                 jObject["OrderMatchQty2"] = info->OrderMatchQty2;
                 jObject["IsBackInput"] = IsBackInput;
                 jObject["IsDeleted"] = IsDeleted;
                 jObject["IsAddOne"] = IsAddOne;
                 jObject["ErrorCode"] = info->ErrorCode;
                 jObject["ErrorText"] = info->ErrorText;

                 std::string str = jObject.toStyledString();
                 spdlog::info("OnRspQryOrder: {}", str);
//                 acl_redis.clear();
//                 int ret = acl_redis.publish("TopicOrderInfo", str.c_str(), strlen(str.c_str()));
//                 if (ret < 0)
//                 {
//                     std::string top = "TopicOrderInfo";
//                     spdlog::error("publish to {} error({}), errorCode: {}", top, acl_redis.result_error(), ret);
//                 }
                 try {
                     m_redis->publish("TopicOrderInfo", str);
                 } catch (const sw::redis::Error &err) {
                     // other errors
                     spdlog::error("RedisError: {}", err.what());
                 }

            }
        }

        if (isLast == 'Y') {
            cout << __FUNCTION__ << " is Last." << endl;
            return;
        }

    } else {
        cout << "OnRspQryOrder, errorCode: " << errorCode << endl;
    }

}

void TAP_CDECL Trade::OnRspQryOrderProcess( TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPIOrderInfo *info )
{
    spdlog::info("{} is called.",  __FUNCTION__);

    if (errorCode == TAPIERROR_SUCCEED) {
        if (info->ErrorCode != 0 && info->OrderState != '6') {
            cout << "The server returned an error about delegate information:" << info->ErrorCode << endl;
        } else {
            if (NULL != info) {
                cout << "orderInfo{"
                        << "OrderInsertTime:" << info->OrderInsertTime << "," // 下单时间
                        << "OrderUpdateTime:" << info->OrderUpdateTime << "," // 委托更新时间
                        << "ExchangeNo:" << info->ExchangeNo << "," // 交易所编号
                        << "Contract:" << info->CommodityNo << info->ContractNo << "," // 合约
                        << "OrderState:" << info->OrderState << "," // 委托状态
                        << "OrderSide:" << info->OrderSide << "," // 买入卖出
                        << "OrderPrice:" << info->OrderPrice << "," // 委托价格1
                        << "OrderQty:" << info->OrderQty << "," // 委托数量
                        << "OrderMatchQty:" << info->OrderMatchQty << "," // 成交量1
                        << "OrderNo:" << info->OrderNo << "," // 订单号
                        << "}" << endl;
            }
        }

        if (isLast == 'Y') {
            cout << __FUNCTION__ << " is Last." << endl;
            return;
        }

    } else {
        cout << "OnRspQryOrder, errorCode: " << errorCode << endl;
    }

}

void TAP_CDECL Trade::OnRspQryFill( TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPIFillInfo *info )
{
	spdlog::info("{} is called.",  __FUNCTION__);

	if (errorCode == TAPIERROR_SUCCEED) {
	    if (NULL != info) {

            Json::Value jObject;
            std::string CommodityType(1, info->CommodityType);
            std::string CallOrPutFlag(1, info->CallOrPutFlag);
            std::string MatchSide(1, info->MatchSide);
            std::string ServerFlag(1, info->ServerFlag);
            std::string MatchSource(1, info->MatchSource);
            std::string PositionEffect(1, info->PositionEffect);
            std::string IsDeleted(1, info->IsDeleted);
            std::string IsAddOne(1, info->IsAddOne);
            std::string IsManualFee(1, info->IsManualFee);
            jObject["AccountNo"] = info->AccountNo;
            jObject["ExchangeNo"] = info->ExchangeNo;
            jObject["CommodityType"] = CommodityType;
            jObject["CommodityNo"] = info->CommodityNo;
            jObject["ContractNo"] = info->ContractNo;
            jObject["StrikePrice"] = info->StrikePrice;
            jObject["CallOrPutFlag"] = CallOrPutFlag;
            jObject["MatchSource"] = MatchSource;
            jObject["MatchSide"] = MatchSide;
            jObject["PositionEffect"] = PositionEffect;
            jObject["ServerFlag"] = ServerFlag;
            jObject["OrderNo"] = info->OrderNo;
            jObject["OrderSystemNo"] = info->OrderSystemNo;
            jObject["MatchNo"] = info->MatchNo;
            jObject["UpperMatchNo"] = info->UpperMatchNo;
            jObject["ExchangeMatchNo"] = info->ExchangeMatchNo;
            jObject["MatchDateTime"] = info->MatchDateTime;
            jObject["UpperMatchDateTime"] = info->UpperMatchDateTime;
            jObject["UpperNo"] = info->UpperNo;
            jObject["MatchPrice"] = info->MatchPrice;
            jObject["MatchQty"] = info->MatchQty;
            jObject["IsDeleted"] = IsDeleted;
            jObject["IsAddOne"] = IsAddOne;
            jObject["FeeCurrencyGroup"] = info->FeeCurrencyGroup;
            jObject["FeeCurrency"] = info->FeeCurrency;
            jObject["FeeValue"] = info->FeeValue;
            jObject["IsManualFee"] = info->IsManualFee;
            jObject["IsManualFee"] = IsManualFee;
            jObject["ClosePrositionPrice"] = info->ClosePrositionPrice;

            std::string str = jObject.toStyledString();
            spdlog::info("OnRspQryFill: {}", str);
//            acl_redis.clear();
//            int ret = acl_redis.publish("TopicFillInfo", str.c_str(), strlen(str.c_str()));
//            if (ret < 0)
//            {
//                std::string top = "TopicFillInfo";
//                spdlog::error("publish to {} error({}), errorCode: {}", top, acl_redis.result_error(), ret);
//            }
            try {
                m_redis->publish("TopicFillInfo", str);
            } catch (const sw::redis::Error &err) {
                // other errors
                spdlog::error("RedisError: {}", err.what());
            }

	    }

        if (isLast == 'Y') {
            cout << __FUNCTION__ << " is Last." << endl;
            return;
        }

	} else {
	    cout << "OnRspQryFill, errorCode: " << errorCode << endl;
	}
}

void TAP_CDECL Trade::OnRtnFill( const TapAPIFillInfo *info )
{
	spdlog::info("{} is called.",  __FUNCTION__);

    if (info == NULL) return;


    Json::Value jObject;
    std::string CommodityType(1, info->CommodityType);
    std::string CallOrPutFlag(1, info->CallOrPutFlag);
    std::string MatchSide(1, info->MatchSide);
    std::string ServerFlag(1, info->ServerFlag);
    std::string MatchSource(1, info->MatchSource);
    std::string PositionEffect(1, info->PositionEffect);
    std::string IsDeleted(1, info->IsDeleted);
    std::string IsAddOne(1, info->IsAddOne);
    std::string IsManualFee(1, info->IsManualFee);
    jObject["AccountNo"] = info->AccountNo;
    jObject["ExchangeNo"] = info->ExchangeNo;
    jObject["CommodityType"] = CommodityType;
    jObject["CommodityNo"] = info->CommodityNo;
    jObject["ContractNo"] = info->ContractNo;
    jObject["StrikePrice"] = info->StrikePrice;
    jObject["CallOrPutFlag"] = CallOrPutFlag;
    jObject["MatchSource"] = MatchSource;
    jObject["MatchSide"] = MatchSide;
    jObject["PositionEffect"] = PositionEffect;
    jObject["ServerFlag"] = ServerFlag;
    jObject["OrderNo"] = info->OrderNo;
    jObject["OrderSystemNo"] = info->OrderSystemNo;
    jObject["MatchNo"] = info->MatchNo;
    jObject["UpperMatchNo"] = info->UpperMatchNo;
    jObject["ExchangeMatchNo"] = info->ExchangeMatchNo;
    jObject["MatchDateTime"] = info->MatchDateTime;
    jObject["UpperMatchDateTime"] = info->UpperMatchDateTime;
    jObject["UpperNo"] = info->UpperNo;
    jObject["MatchPrice"] = info->MatchPrice;
    jObject["MatchQty"] = info->MatchQty;
    jObject["IsDeleted"] = IsDeleted;
    jObject["IsAddOne"] = IsAddOne;
    jObject["FeeCurrencyGroup"] = info->FeeCurrencyGroup;
    jObject["FeeCurrency"] = info->FeeCurrency;
    jObject["FeeValue"] = info->FeeValue;
    jObject["IsManualFee"] = info->IsManualFee;
    jObject["IsManualFee"] = IsManualFee;
    jObject["ClosePrositionPrice"] = info->ClosePrositionPrice;

    std::string str = jObject.toStyledString();
//    try {
//        m_redis->publish("TopicFillInfo", str);
//    } catch (const sw::redis::Error &err) {
//        // other errors
//        spdlog::error("RedisError: {}", err.what());
//    }
    spdlog::info("OnRtnFill: {}", str);
}

void TAP_CDECL Trade::OnRspQryPosition( TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPIPositionInfo *info )
{
	spdlog::info("{} is called.",  __FUNCTION__);

	if (errorCode == TAPIERROR_SUCCEED) {

	    if (info != NULL) {

            Json::Value jObject;
            std::string CommodityType(1, info->CommodityType);
            std::string CallOrPutFlag(1, info->CallOrPutFlag);
            std::string MatchSide(1, info->MatchSide);
            std::string HedgeFlag(1, info->HedgeFlag);
            std::string ServerFlag(1, info->ServerFlag);
            std::string IsHistory(1, info->IsHistory);
            jObject["AccountNo"] = info->AccountNo;
            jObject["ExchangeNo"] = info->ExchangeNo;
            jObject["CommodityType"] = CommodityType;
            jObject["CommodityNo"] = info->CommodityNo;
            jObject["ContractNo"] = info->ContractNo;
            jObject["StrikePrice"] = info->StrikePrice;
            jObject["CallOrPutFlag"] = CallOrPutFlag;
            jObject["MatchSide"] = MatchSide;
            jObject["HedgeFlag"] = HedgeFlag;
            jObject["PositionNo"] = info->PositionNo;
            jObject["ServerFlag"] = ServerFlag;
            jObject["OrderNo"] = info->OrderNo;
            jObject["MatchNo"] = info->MatchNo;
            jObject["UpperNo"] = info->UpperNo;
            jObject["PositionPrice"] = info->PositionPrice;
            jObject["PositionQty"] = info->PositionQty;
            jObject["PositionStreamId"] = info->PositionStreamId;
            jObject["CommodityCurrencyGroup"] = info->CommodityCurrencyGroup;
            jObject["CommodityCurrency"] = info->CommodityCurrency;
            jObject["CalculatePrice"] = info->CalculatePrice;
            jObject["AccountInitialMargin"] = info->AccountInitialMargin;
            jObject["AccountMaintenanceMargin"] = info->AccountMaintenanceMargin;
            jObject["UpperInitialMargin"] = info->UpperInitialMargin;
            jObject["UpperMaintenanceMargin"] = info->UpperMaintenanceMargin;
            jObject["PositionProfit"] = info->PositionProfit;
            jObject["LMEPositionProfit"] = info->LMEPositionProfit;
            jObject["OptionMarketValue"] = info->OptionMarketValue;
            jObject["IsHistory"] = IsHistory;

            std::string str = jObject.toStyledString();
            spdlog::info("OnRspQryPosition: {}", str);
//            acl_redis.clear();
//            int ret = acl_redis.publish("TopicPositionInfo", str.c_str(), strlen(str.c_str()));
//            if (ret < 0)
//            {
//                std::string top = "TopicPositionInfo";
//                spdlog::error("publish to {} error({}), errorCode: {}", top, acl_redis.result_error(), ret);
//            }
            try {
                m_redis->publish("TopicPositionInfo", str);
            } catch (const sw::redis::Error &err) {
                // other errors
                spdlog::error("RedisError: {}", err.what());
            }

	    }

        if(isLast=='Y') return;

	} else {
	    cout << "OnRspQryPosition failed, errorCode:" << errorCode << endl;
	}

}

void TAP_CDECL Trade::OnRtnPosition( const TapAPIPositionInfo *info )
{
	spdlog::info("{} is called.",  __FUNCTION__);

	if (info == NULL) return;

    Json::Value jObject;
    std::string CommodityType(1, info->CommodityType);
    std::string CallOrPutFlag(1, info->CallOrPutFlag);
    std::string MatchSide(1, info->MatchSide);
    std::string HedgeFlag(1, info->HedgeFlag);
    std::string ServerFlag(1, info->ServerFlag);
    std::string IsHistory(1, info->IsHistory);
    jObject["AccountNo"] = info->AccountNo;
    jObject["ExchangeNo"] = info->ExchangeNo;
    jObject["CommodityType"] = CommodityType;
    jObject["CommodityNo"] = info->CommodityNo;
    jObject["ContractNo"] = info->ContractNo;
    jObject["StrikePrice"] = info->StrikePrice;
    jObject["CallOrPutFlag"] = CallOrPutFlag;
    jObject["MatchSide"] = MatchSide;
    jObject["HedgeFlag"] = HedgeFlag;
    jObject["PositionNo"] = info->PositionNo;
    jObject["ServerFlag"] = ServerFlag;
    jObject["OrderNo"] = info->OrderNo;
    jObject["MatchNo"] = info->MatchNo;
    jObject["UpperNo"] = info->UpperNo;
    jObject["PositionPrice"] = info->PositionPrice;
    jObject["PositionQty"] = info->PositionQty;
    jObject["PositionStreamId"] = info->PositionStreamId;
    jObject["CommodityCurrencyGroup"] = info->CommodityCurrencyGroup;
    jObject["CommodityCurrency"] = info->CommodityCurrency;
    jObject["CalculatePrice"] = info->CalculatePrice;
    jObject["AccountInitialMargin"] = info->AccountInitialMargin;
    jObject["AccountMaintenanceMargin"] = info->AccountMaintenanceMargin;
    jObject["UpperInitialMargin"] = info->UpperInitialMargin;
    jObject["UpperMaintenanceMargin"] = info->UpperMaintenanceMargin;
    jObject["PositionProfit"] = info->PositionProfit;
    jObject["LMEPositionProfit"] = info->LMEPositionProfit;
    jObject["OptionMarketValue"] = info->OptionMarketValue;
    jObject["IsHistory"] = IsHistory;

    std::string str = jObject.toStyledString();
//    try {
//        m_redis->publish("TopicPositionInfo", str);
//    } catch (const sw::redis::Error &err) {
//        // other errors
//        spdlog::error("RedisError: {}", err.what());
//    }
    spdlog::info("OnRtnPosition: {}", str);
}

void TAP_CDECL Trade::OnRspQryClose( TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPICloseInfo *info )
{
	spdlog::info("{} is called.",  __FUNCTION__);
}

void TAP_CDECL Trade::OnRtnClose( const TapAPICloseInfo *info )
{
	spdlog::info("{} is called.",  __FUNCTION__);
}

void TAP_CDECL Trade::OnRtnPositionProfit( const TapAPIPositionProfitNotice *info )
{
    if (info->IsLast == 'Y') return;

	spdlog::info("{} is called.",  __FUNCTION__);

	if (info != NULL) {

        Json::Value jObject;
        std::string IsLast(1, info->IsLast);
        jObject["IsLast"] = IsLast;
        jObject["PositionNo"] = info->Data->PositionNo;
        jObject["PositionStreamId"] = info->Data->PositionStreamId;
        jObject["PositionProfit"] = info->Data->PositionProfit;
        jObject["LMEPositionProfit"] = info->Data->LMEPositionProfit;
        jObject["OptionMarketValue"] = info->Data->OptionMarketValue;
        jObject["CalculatePrice"] = info->Data->CalculatePrice;

        std::string str = jObject.toStyledString();
//        try {
//            m_redis->publish("TopicPositionInfo", str);
//        } catch (const sw::redis::Error &err) {
//            // other errors
//            spdlog::error("RedisError: {}", err.what());
//        }
        spdlog::info("OnRtnPositionProfit: {}", str);
	}

//    Client cli(scheme_host_port);
//    std::multimap<std::string, std::string> params;
//    params.insert({
//                          {"PositionProfit", to_string(info->Data->PositionProfit)}
//                  });
//    auto res = cli.Post(client_path, params);
//
//    if (res) {
//        cout << res->status << endl;
//        cout << res->reason << endl;
//        cout << res->body << endl;
//    }
}

void TAP_CDECL Trade::OnRspQryCurrency(TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPICurrencyInfo *info)
{

    spdlog::info("{} is called.",  __FUNCTION__);

    cout << "CurrencyInfo: " << "{"
         << "CurrencyNo: " << info->CurrencyNo << "," // 币种编号
         << "CurrencyGroupNo: " << info->CurrencyGroupNo << "," // 币种组编号
         << "TradeRate: " << info->TradeRate << "," // 交易汇率
         << "TradeRate2: " << info->TradeRate2 << "," // 交易汇率2
         << "FutureAlg: " << info->FutureAlg << "," // 币种组独立标志
         << "OptionAlg: " << info->OptionAlg // 是否是基币
         << "}" << endl;


    std::map<std::string, std::string> map_info;
    std::string FutureAlg(1, info->FutureAlg);
    std::string OptionAlg(1, info->OptionAlg);
    map_info.insert({
                            {"CurrencyNo", info->CurrencyNo},
                            {"CurrencyGroupNo", info->CurrencyGroupNo},
                            {"TradeRate", to_string(info->TradeRate)},
                            {"TradeRate2", to_string(info->TradeRate2)},
                            {"FutureAlg", FutureAlg},
                            {"OptionAlg", OptionAlg}
                    });
    Json::Value jObject;
    for (std::map<std::string, std::string>::const_iterator iter = map_info.begin( ); iter != map_info.end( ); ++iter)
    {
        jObject[iter->first] = iter->second;
    }
    std::string str = jObject.toStyledString();
//    try {
//        m_redis->publish("TopicQryCurrencyInfo", str);
//    } catch (const sw::redis::Error &err) {
//        // other errors
//        spdlog::error("RedisError: {}", err.what());
//    }
    spdlog::info("OnRspQryCurrency: {}", str);

    if (isLast=='Y')
    {
        cout << __FUNCTION__ << " is Last" << endl;
        return;
    }
}

void TAP_CDECL Trade::OnRspQryTradeMessage(TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPITradeMessage *info)
{
    spdlog::info("{} is called.",  __FUNCTION__);

    if (TAPIERROR_SUCCEED == errorCode) {

        if (info != NULL) {
            cout << "TradeMessage: " << "{"
                 << "SerialID: " << info->SerialID << "," // 流号
                 << "AccountNo: " << info->AccountNo << "," // 客户资金账号
                 << "TMsgValidDateTime: " << info->TMsgValidDateTime << "," // 消息有效时间
                 << "TMsgTitle: " << info->TMsgTitle << "," // 消息标题
                 << "TMsgContent: " << info->TMsgContent << "," // 消息内容
                 << "TMsgType: " << info->TMsgType << "," // 消息类型
                 << "TMsgLevel: " << info->TMsgLevel << "," // 消息级别
                 << "IsSendBySMS: " << info->IsSendBySMS << "," // 是否发送短信
                 << "IsSendByEMail: " << info->IsSendByEMail << "," // 是否发送邮件
                 << "Sender: " << info->Sender << "," // 发送者
                 << "SendDateTime: " << info->SendDateTime // 发送时间
                 << "}" << endl;
            spdlog::info("{} is called.",  __FUNCTION__);
        }
        if (isLast == 'Y') {
            cout << __FUNCTION__ << " is last." << endl;
            return;
        }

    } else {
        cout << "OnRspQryTradeMessage failed, errorCode: " << errorCode;
    }
}

void TAP_CDECL Trade::OnRtnTradeMessage(const TapAPITradeMessage *info)
{
    if (info != NULL) {
        cout << "TradeMessage: " << "{"
             << "SerialID: " << info->SerialID << "," // 流号
             << "AccountNo: " << info->AccountNo << "," // 客户资金账号
             << "TMsgValidDateTime: " << info->TMsgValidDateTime << "," // 消息有效时间
             << "TMsgTitle: " << info->TMsgTitle << "," // 消息标题
             << "TMsgContent: " << info->TMsgContent << "," // 消息内容
             << "TMsgType: " << info->TMsgType << "," // 消息类型
             << "TMsgLevel: " << info->TMsgLevel << "," // 消息级别
             << "IsSendBySMS: " << info->IsSendBySMS << "," // 是否发送短信
             << "IsSendByEMail: " << info->IsSendByEMail << "," // 是否发送邮件
             << "Sender: " << info->Sender << "," // 发送者
             << "SendDateTime: " << info->SendDateTime // 发送时间
             << "}" << endl;
    }
}

void TAP_CDECL Trade::OnRspQryHisOrder(TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPIHisOrderQryRsp *info)
{
    // isLast
    if (isLast == 'Y') {
        cout << __FUNCTION__ << " is last." << endl;
        return;
    }

    spdlog::info("{} is called.",  __FUNCTION__);
    if (errorCode == TAPIERROR_SUCCEED) {

        if (info->ErrorCode != 0 && info->OrderState != '6') {
            cout << "The server returned an error about delegate information：" << info->ErrorCode << endl;
        } else {
            cout << "info=" << info << endl;
            cout << "hisOrder{"
            << "AccountNo:" << info->AccountNo << "," // 客户资金帐号
            << "ExchangeNo:" << info->ExchangeNo << "," // 交易所编号
            << "Contract:" << info->CommodityNo << info->ContractNo << "," // 合约
            << "OrderState:" << info->OrderState << "," // 委托状态
            << "OrderSide:" << info->OrderSide << "," // 买入卖出
            << "OrderPrice:" << info->OrderPrice << "," // 委托价格
            << "OrderQty:" << info->OrderQty << "," // 委托数量
            << "OrderMatchPrice:" << info->OrderMatchPrice << "," // 成交价
            << "OrderMatchQty:" << info->OrderMatchQty << "," // 成交量
            << "OrderInsertUserNo:" << info->OrderInsertUserNo << "," // 下单人
            << "OrderInsertTime:" << info->OrderInsertTime << "," // 下单时间
            << "TriggerCondition:" << info->TriggerCondition << "," // 触发条件
            << "OrderSource:" << info->OrderSource << "," // 委托来源
            << "TimeInForce:" << info->TimeInForce << "," // 委托有效类型
            << "OrderStreamID:" << info->OrderStreamID << "," // 委托流水号
            << "OrderLocalNo:" << info->OrderLocalNo << "," // 本地号
            << "OrderSystemNo:" << info->OrderSystemNo << "," // 系统号
            << "TAPIHedgeFlagType:" << info->HedgeFlag << "," // 投保
            << "OrderNo:" << info->OrderNo // 订单号
            << "}" << endl;
        }
    } else {
        cout << "OnRspQryHisOrder, errorCode: " << errorCode << endl;
    }
}

void TAP_CDECL Trade::OnRspQryHisOrderProcess(TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPIHisOrderProcessQryRsp *info)
{

    spdlog::info("{} is called.",  __FUNCTION__);
    if (errorCode == TAPIERROR_SUCCEED) {

        if (info != NULL) {
            cout << "hisOrderProcess{"
                    << "AccountNo:" << info->AccountNo << "," // 客户资金帐号
                    << "OrderState:" << info->OrderState << "," // 委托状态
                    << "ExchangeNo" << info->ExchangeNo << "," // 交易所编号
                    << "Contract:" << info->CommodityNo << info->ContractNo << "," // 合约
                    << "OrderState:" << info->OrderState << "," // 委托状态
                    << "OrderSide:" << info->OrderSide << "," // 买入卖出
                    << "OrderPrice:" << info->OrderPrice << "," // 委托价格
                    << "OrderQty:" << info->OrderQty << "," // 委托数量
                    << "OrderMatchPrice:" << info->OrderMatchPrice << "," // 成交价
                    << "OrderMatchQty:" << info->OrderMatchQty << "," // 成交量
                    << "OrderNo:" << info->OrderNo // 订单号
                    << "}" << endl;
        }

        if (isLast == 'Y') {
            cout << __FUNCTION__ << " is last." << endl;
            return;
        }

    } else {
        cout << "OnRspQryHisOrderProcess, errorCode: " << errorCode << endl;
    }
}

void TAP_CDECL Trade::OnRspQryHisMatch(TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPIHisMatchQryRsp *info)
{
    // isLast
    if (isLast == 'Y') {
        cout << __FUNCTION__ << " is last." << endl;
        return;
    }

    spdlog::info("{} is called.",  __FUNCTION__);
    if (errorCode == TAPIERROR_SUCCEED) {

        if (info != NULL) {
            cout << "hisOrderMatch{"
                    << "MatchDateTime:" << info->MatchDateTime << "," // 成交时间
                    << "SettleDate:" << info->SettleDate << "," // 结算日期
                    << "TradeDate:" << info->TradeDate << "," // 交易日期
                    << "AccountNo:" << info->AccountNo << "," // 客户资金帐号
                    << "ExchangeNo:" << info->ExchangeNo << "," // 交易所编号
                    << "Contract:" << info->CommodityNo << info->ContractNo << "," // 合约
                    << "OrderSide:" << info->MatchSide << "," // 买入卖出
                    << "OrderMatchPrice:" << info->MatchPrice << "," // 成交价
                    << "OrderMatchQty:" << info->MatchQty << "," // 成交量
                    << "AccountFee:" << info->AccountFee << "," // 客户手续费
                    << "CloseProfit:" << info->CloseProfit << "," // 平仓盈亏
                    << "TAPIHedgeFlagType:" << info->HedgeFlag << "," // 投保
                    << "MatchNo" << info->MatchNo << ","
                    << "OrderNo:" << info->OrderNo // 订单号
                   << "}" << endl;
        }

    } else {
        cout << "OnRspQryHisMatch, errorCode: " << errorCode << endl;
    }
}

void TAP_CDECL Trade::OnRspQryHisPosition(TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPIHisPositionQryRsp *info)
{
    // isLast
    if (isLast == 'Y') {
        cout << __FUNCTION__ << " is last." << endl;
        return;
    }

    spdlog::info("{} is called.",  __FUNCTION__);
    if (errorCode == TAPIERROR_SUCCEED) {

        if (info != NULL) {
            cout << "hisOrderPosition{"
                    << "SettleDate:" << info->SettleDate << ","
                    << "CommodityType:" << info->CommodityType << ","
                    << "Contract:" << info->CommodityNo << info->ContractNo << ","
                    << "MatchSide:" << info->MatchSide << ","
                    << "holdings:" << info->PositionQty << ","
                    << "PositionPrice:"<< info->PositionPrice << ","
                    << "PositionProfit:" << info->PositionDProfit << ","
                    << "PreSettlePrice:" << info->PreSettlePrice << ","
                    << "SettlePrice:" << info->SettlePrice << ","
                    << "OrderNo:" << info->OrderNo << ","
                    << "PositionNo:" << info->PositionNo << ","
                    << "HedgeFlag:" << info->HedgeFlag
                    << "}" << endl;
        }

    } else {
        cout << "OnRspQryHisPosition, errorCode: " << errorCode << endl;
    }
}

void TAP_CDECL Trade::OnRspQryHisDelivery(TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPIHisDeliveryQryRsp *info)
{
    // isLast
    spdlog::info("{} is called.",  __FUNCTION__);
    if (errorCode == TAPIERROR_SUCCEED) {

        if (info != NULL) {
            cout << "hisOrderDelivery{"
                    << "DeliveryDate: " << info->DeliveryDate << "," //
                    << "ExchangeNo: " << info->ExchangeNo << "," // 交易所编号
                    << "AccountNo: " << info->AccountNo << "," // 客户资金帐号
                    << "CommodityType: " << info->CommodityType << "," // 品种类型
                    << "CommodityNo: " << info->CommodityNo << "," // 品种编码类型
                    << "ContractNo: " << info->ContractNo << "," // 合约1
                    << "OpenSide: " << info->OpenSide << "," // 买入卖出
                    << "OpenPrice:" << info->OpenPrice << ","
                    << "DeliveryQty:" << info->DeliveryQty << ","
                    << "DeliveryPrice:" << info->DeliveryPrice << ","
                    << "FrozenQty" << info->FrozenQty << ","
                    << "OpenNo:" << info->OpenNo
                    << "}" << endl;
        }
        if (isLast == 'Y') {
            cout << __FUNCTION__ << "is last." << endl;
            return;
        }

    } else {
        cout << "OnRspQryHisDelivery, errorCode: " << errorCode << endl;
    }
}

void TAP_CDECL Trade::OnRspQryAccountCashAdjust(TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPIAccountCashAdjustQryRsp *info)
{

    spdlog::info("{} is called.",  __FUNCTION__);
    if (errorCode == TAPIERROR_SUCCEED) {

        if (info != NULL) {
            cout << "accountCashAdjust{"
                 << "Date:" << info->Date << ","
                 << "CurrencyNo:" << info->CurrencyNo << ","
                 << "CashAdjustValue:" << info->CashAdjustValue
                 << "}" << endl;
        }
        if (isLast == 'Y') {
            cout << __FUNCTION__ << " is last." << endl;
            return;
        }

    } else {
        cout << "OnRspQryAccountCashAdjust, errorCode: " << errorCode << endl;
    }
}

void TAP_CDECL Trade::OnRspQryBill(TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPIBillQryRsp *info)
{
}

void TAP_CDECL Trade::OnExpriationDate(ITapTrade::TAPIDATE date, int days)
{
    spdlog::warn("OnExpriationDate Warning: {}, Left Days: {}", date, days);
}

void TAP_CDECL Trade::OnRspQryAccountFeeRent(ITapTrade::TAPIUINT32 sessionID, ITapTrade::TAPIINT32 errorCode, ITapTrade::TAPIYNFLAG isLast, const ITapTrade::TapAPIAccountFeeRentQryRsp *info)
{
    if (errorCode == TAPIERROR_SUCCEED) {
        if ((strcmp(info->ExchangeNo, "NYMEX") == 0) || (strcmp(info->ExchangeNo, "COMEX") == 0)) {
            spdlog::info("{} is called.",  __FUNCTION__);

             cout << "accountFeeRent{"
                 << "AccountNo:" << info->AccountNo << ","
                 << "ExchangeNo:" << info->ExchangeNo << ","
                 << "CommodityType:" << info->CommodityType << ","
                 << "CommodityNo:" << info->CommodityNo << ","
                 << "MatchSource:" << info->MatchSource << ","
                 << "CalculateMode:" << info->CalculateMode << ","
                 << "CurrencyGroupNo:" << info->CurrencyGroupNo << ","
                 << "CurrencyNo:" << info->CurrencyNo << ","
                 << "OpenCloseFee:" << info->OpenCloseFee << ","
                 << "CloseTodayFee:" << info->CloseTodayFee
                 << "}" << endl;
        }

        if (isLast == 'Y') {
            cout << __FUNCTION__ << " is last." << endl;
            return;
        }

    } else {
        cout << "OnRspQryAccountFeeRent failed, errorCode: " << errorCode << endl;
    }
}

void TAP_CDECL Trade::OnRspQryAccountMarginRent(ITapTrade::TAPIUINT32 sessionID, ITapTrade::TAPIINT32 errorCode, ITapTrade::TAPIYNFLAG isLast, const ITapTrade::TapAPIAccountMarginRentQryRsp *info)
{
    if (errorCode == TAPIERROR_SUCCEED) {

        if ((strcmp(info->ExchangeNo, "NYMEX") == 0) || (strcmp(info->ExchangeNo, "COMEX") == 0)) {
            spdlog::info("{} is called.",  __FUNCTION__);

            cout << "accountMarginRent{"
                 << "AccountNo:" << info->AccountNo << ","
                 << "ExchangeNo:" << info->ExchangeNo << ","
                 << "CommodityType:" << info->CommodityType << ","
                 << "CommodityNo:" << info->CommodityNo << ","
                 << "ContractNo:" << info->ContractNo << ","
                 << "StrikePrice:" << info->StrikePrice << ","
                 << "CallOrPutFlag:" << info->CallOrPutFlag << ","
                 << "CalculateMode:" << info->CalculateMode << ","
                 << "CurrencyGroupNo:" << info->CurrencyGroupNo << ","
                 << "CurrencyNo:" << info->CurrencyNo << ","
                 << "InitialMargin:" << info->InitialMargin << ","
                 << "MaintenanceMargin:" << info->MaintenanceMargin << ","
                 << "SellInitialMargin:" << info->SellInitialMargin << ","
                 << "SellMaintenanceMargin:" << info->SellMaintenanceMargin << ","
                 << "LockMargin:" << info->LockMargin
                 << "}" << endl;
        }
        if (isLast == 'Y') {
            cout << __FUNCTION__ << " is last." << endl;
            return;
        }
    } else {
        cout << "OnRspQryAccountFeeRent failed, errorCode: " << errorCode << endl;
    }
}

void TAP_CDECL Trade::OnRtnContactInfo(ITapTrade::TAPIINT32 errorCode, ITapTrade::TAPIYNFLAG isLast, const ITapTrade::TAPISTR_40 ContactInfo)
{
//    if (TAPIERROR_SUCCEED == errorCode) {
//
//        spdlog::info("{} is called.",  __FUNCTION__);
//
//        out << "ContactInfo" << ContactInfo << endl;
//
//        TAPIINT32 iErr = TAPIERROR_SUCCEED;
//        iErr = m_pAPI->RequestVertificateCode(&m_uiSessionID, ContactInfo);
//        if (iErr != TAPIERROR_SUCCEED) {
//            cout << "RequestVertificateCode failed, errorCode:{}", iErr);
//        }
//
//    } else if (TAPIERROR_LOGIN_NOSECONDSET == errorCode) {
//        cout << "该账户未绑定二次认证联系方式, errorCode" << errorCode << endl;
//        cout << "The second authentication contact information is not bound to the changed account, errorCode" << errorCode << endl;
//    } else {
//        cout << "OnRtnContactInfo Failed, errorCode: " << errorCode;
//    }
}

void TAP_CDECL Trade::OnRspRequestVertificateCode(ITapTrade::TAPIUINT32 sessionID, ITapTrade::TAPIINT32 errorCode, const TapAPIRequestVertificateCodeRsp *rsp)
{
//    if (TAPIERROR_SUCCEED == errorCode) {
//
//        spdlog::info("{} is called.",  __FUNCTION__);
//
//        // info inval
//        TapAPISecondCertificationReq req;
//        TAPISTR_10  VertificateCode;
//        TAPILoginTypeType   LoginType;
//        cout << "please input VertificateCode: ";
//        cin >> VertificateCode;
//        strncpy(req.VertificateCode, VertificateCode, strlen(VertificateCode));
//        req.LoginType = TAPILoginTypeType;
//
//        TAPIINT32 iErr = TAPIERROR_SUCCEED;
//        iErr = m_pAPI->SetVertificateCode(&m_uiSessionID, &req)
//        if (iErr != TAPIERROR_SUCCEED) {
//            cout << "SetVertificateCode failed, errorCode:{}", iErr);
//        }
//
//    } else if (TAPIERROR_LOGIN_NOSECONDSET == errorCode) {
//        cout << "该账户未绑定二次认证联系方式, errorCode" << errorCode << endl;
//        cout << "The second authentication contact information is not bound to the changed account, errorCode" << errorCode << endl;
//    } else {
//        cout << "OnRspRequestVertificateCode Failed, errorCode: " << errorCode;
//    }
}

void TAP_CDECL Trade::OnRspAuthPassword(ITapTrade::TAPIUINT32 sessionID, ITapTrade::TAPIINT32 errorCode)
{
    spdlog::info("{} is called.",  __FUNCTION__);

    if (errorCode == TAPIERROR_SUCCEED) {
        cout << "The account password is correct!" << endl;
    } else {
        cout << "The account password is error, errorCode: " << errorCode << endl;
    }
}

void TAP_CDECL Trade::OnRspQryTradingDate(ITapTrade::TAPIUINT32 sessionID, ITapTrade::TAPIINT32 errorCode, const ITapTrade::TapAPITradingCalendarQryRsp *info)
{
    cout << __FUNCTION__ << " is called" << endl;
    cout << "TradingDate{"
            << "CurrTradeDate: " << info->CurrTradeDate << ","  // 当前交易日
            << "LastSettlementDate: " << info->LastSettlementDate << "," // 上次结算日
            << "PromptDate: " << info->PromptDate << "," // LME到期日
            << "LastPromptDate: " << info->LastPromptDate // 上日LME到期日
            << "}" << endl;

}


void TAP_CDECL Trade::OnRspHKMarketOrderInsert(ITapTrade::TAPIUINT32 sessionID, ITapTrade::TAPIINT32 errorCode, const ITapTrade::TapAPIOrderMarketInsertRsp *info)
{}
void TAP_CDECL Trade::OnRspHKMarketOrderDelete(ITapTrade::TAPIUINT32 sessionID, ITapTrade::TAPIINT32 errorCode, const ITapTrade::TapAPIOrderMarketDeleteRsp *info)
{}
void TAP_CDECL Trade::OnHKMarketQuoteNotice(const ITapTrade::TapAPIOrderQuoteMarketNotice *info)
{}
void TAP_CDECL Trade::OnRspOrderLocalRemove(ITapTrade::TAPIUINT32 sessionID, ITapTrade::TAPIINT32 errorCode, const ITapTrade::TapAPIOrderLocalRemoveRsp *info)
{}
void TAP_CDECL Trade::OnRspOrderLocalInput(ITapTrade::TAPIUINT32 sessionID, ITapTrade::TAPIINT32 errorCode, const ITapTrade::TapAPIOrderLocalInputRsp *info)
{}
void TAP_CDECL Trade::OnRspOrderLocalModify(ITapTrade::TAPIUINT32 sessionID, ITapTrade::TAPIINT32 errorCode, const ITapTrade::TapAPIOrderLocalModifyRsp *info)
{}
void TAP_CDECL Trade::OnRspOrderLocalTransfer(ITapTrade::TAPIUINT32 sessionID, ITapTrade::TAPIINT32 errorCode, const ITapTrade::TapAPIOrderLocalTransferRsp *info)
{}
void TAP_CDECL Trade::OnRspFillLocalInput(ITapTrade::TAPIUINT32 sessionID, ITapTrade::TAPIINT32 errorCode, const ITapTrade::TapAPIFillLocalInputRsp *info)
{}
void TAP_CDECL Trade::OnRspFillLocalRemove(ITapTrade::TAPIUINT32 sessionID, ITapTrade::TAPIINT32 errorCode, const ITapTrade::TapAPIFillLocalRemoveRsp *info)
{}
void TAP_CDECL Trade::OnRspQrySpotLock(ITapTrade::TAPIUINT32 sessionID, ITapTrade::TAPIINT32 errorCode, ITapTrade::TAPIYNFLAG isLast, const ITapTrade::TapAPISpotLockDataRsp *info)
{}
void TAP_CDECL Trade::OnRtnSpotLock(const ITapTrade::TapAPISpotLockDataRsp *info)
{}
void TAP_CDECL Trade::OnRspQryPositionSummary(TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPIPositionSummary *info)
{
    spdlog::info("{} is called.",  __FUNCTION__);

    cout << "PositionSummaryInfo: " << "{"
            << "AccountNo: " << info->AccountNo << "," // 客户资金帐号
            << "ExchangeNo: " << info->ExchangeNo << "," // 交易所编号
            << "Contract:" << info->CommodityNo << info->ContractNo << ","
            << "MatchSide: " << info->MatchSide << "," // 买入卖出
            << "PositionPrice: " << info->PositionPrice << "," // 持仓均价
            << "PositionQty: " << info->PositionQty << "," // 持仓量
            << "}" << endl;

    if (isLast == 'Y') {
        spdlog::info("{} is Lasted.",  __FUNCTION__);
        return;
    }
}

void TAP_CDECL Trade::OnRtnPositionSummary(const TapAPIPositionSummary *info)
{
    spdlog::info("{} is called.",  __FUNCTION__);

    if (info != NULL) {
//
//        Json::Value jObject;
//        std::string CommodityType(1, info->CommodityType);
//        std::string CallOrPutFlag(1, info->CallOrPutFlag);
//        std::string MatchSide(1, info->MatchSide);
//        jObject["AccountNo"] = info->AccountNo;
//        jObject["ExchangeNo"] = info->ExchangeNo;
//        jObject["CommodityType"] = CommodityType;
//        jObject["CommodityNo"] = info->CommodityNo;
//        jObject["ContractNo"] = info->ContractNo;
//        jObject["StrikePrice"] = info->StrikePrice;
//        jObject["CallOrPutFlag"] = CallOrPutFlag;
//        jObject["MatchSide"] = MatchSide;
//        jObject["PositionPrice"] = info->PositionPrice;
//        jObject["PositionQty"] = info->PositionQty;
//        jObject["HisPositionQty"] = info->HisPositionQty;
//
//        std::string str = jObject.toStyledString();
//        spdlog::info("OnRtnPositionSummary: {}", str);
//        m_redis->publish("TopicPositionInfo", str);
    }

}

void TAP_CDECL Trade::OnRspSubmitUserLoginInfo(TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPISubmitUserLoginRspInfo * info)
{}
void TAP_CDECL Trade::OnRspSpecialOrderAction(ITapTrade::TAPIUINT32 sessionID, ITapTrade::TAPIINT32 errorCode, const ITapTrade::TapAPISpecialOrderInfo *info)
{}
void TAP_CDECL Trade::OnRtnSpecialOrder(const ITapTrade::TapAPISpecialOrderInfo *info)
{}
void TAP_CDECL Trade::OnRspQrySpecialOrder(ITapTrade::TAPIUINT32 sessionID, ITapTrade::TAPIINT32 errorCode, ITapTrade::TAPIYNFLAG isLast, const ITapTrade::TapAPISpecialOrderInfo *info)
{}
void TAP_CDECL Trade::OnRspQryCombinePosition(ITapTrade::TAPIUINT32 sessionID, ITapTrade::TAPIINT32 errorCode, ITapTrade::TAPIYNFLAG isLast, const  ITapTrade::TapAPICombinePositionInfo *info)
{}
void TAP_CDECL Trade::OnRtnCombinePosition(const ITapTrade::TapAPICombinePositionInfo *info)
{}
void TAP_CDECL Trade::OnRspQryUserTrustDevice(ITapTrade::TAPIUINT32 sessionID, ITapTrade::TAPIINT32 errorCode, ITapTrade::TAPIYNFLAG isLast, const  ITapTrade::TapAPIUserTrustDeviceQryRsp *info)
{}
void TAP_CDECL Trade::OnRspAddUserTrustDevice(ITapTrade::TAPIUINT32 sessionID, ITapTrade::TAPIINT32 errorCode, const ITapTrade::TapAPIUserTrustDeviceAddRsp *info)
{}
void TAP_CDECL Trade::OnRspDelUserTrustDevice(ITapTrade::TAPIUINT32 sessionID, ITapTrade::TAPIINT32 errorCode, const ITapTrade::TapAPIUserTrustDeviceDelRsp *info)
{}
void TAP_CDECL Trade::OnRtnAddUserTrustDevice(const ITapTrade::TapAPIUserTrustDeviceAddRsp *info)
{}
void TAP_CDECL Trade::OnRtnDelUserTrustDevice(const ITapTrade::TapAPIUserTrustDeviceDelRsp *info)
{}