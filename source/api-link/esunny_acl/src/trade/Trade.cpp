#include "../../include/trade/Trade.h"
#include <iTapAPIError.h>
#include <iostream>
#include <string.h>
#include <time.h>
#include <acl_cpp/stdlib/string.hpp>
#include <json/acl_json.h>
#include <sstream>
#include "utils/EsunnyUtil.h"

static const char* TOPIC_QRYCURRENCY = "TopicQryCurrencyInfo";
static const char* TOPIC_QRYEXCHANGE = "TopicQryExchangeInfo";
static const char* TOPIC_QRYACCOUNT = "TopicQryAccountInfo";
static const char* TOPIC_QRYCOMMODITY = "TopicQryExchangeCommodity";
static const char* TOPIC_QRYCONTRACT = "TopicQryExchangeContract";
static const char* TOPIC_QRYFUND = "TopicFundData";
static const char* TOPIC_ORDER = "TopicOrderInfo";
static const char* TOPIC_POSITION = "TopicPositionInfo";
static const char* TOPIC_POSITION_SUMMARY = "TopicPositionSummaryInfo";
static const char* TOPIC_FILL = "TopicFillInfo";
static const char* TOPIC_ACCOUNT_MARGIN_RENT = "TopicAccountMarginRent";
static const char* TOPIC_ACCOUNT_FEE_RENT = "TopicAccountFeeRent";


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

void Trade::loopCmd()
{
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
            case 35: this->t_qryContract(NULL, NULL);break;

            case 41: this->t_qryAccount();break;
            case 42: this->t_qryFund();break;
            case 43: this->t_qryTradeMessage();break;

            case 51: this->t_qryOrder();break;
            case 52: this->t_qryOrderProcess();break;
            case 53: this->t_qryFill();break;
            case 54: this->t_qryPosition();break;
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

int Trade::t_login()
{
    TAPIINT32 iErr = TAPIERROR_SUCCEED;
    //登录服务器
    TapAPITradeLoginAuth stLoginAuth;
    // 定义结构体之后建议进行初始化，以免内存乱数据影响结果
    memset(&stLoginAuth, 0, sizeof(stLoginAuth));
    strcpy(stLoginAuth.UserNo, m_pAccount->getAccountNo());
    strcpy(stLoginAuth.Password, m_pAccount->getPassword());
    stLoginAuth.ISModifyPassword = APIYNFLAG_NO;
    iErr = m_pAPI->Login(&stLoginAuth);
    if(TAPIERROR_SUCCEED != iErr) {
        logger_error("Login Error: %d", iErr);
    }
    return iErr;
}

int Trade::RunTrade()
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
    TapAPITradeLoginAuth stLoginAuth;
    // 定义结构体之后建议进行初始化，以免内存乱数据影响结果
    memset(&stLoginAuth, 0, sizeof(stLoginAuth));
    strcpy(stLoginAuth.UserNo, m_pAccount->getAccountNo());
    strcpy(stLoginAuth.Password, m_pAccount->getPassword());
    stLoginAuth.ISModifyPassword = APIYNFLAG_NO;
    logger("登录服务器");
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

    this->t_qryFund();
    this->t_qryOrder();
    this->t_qryPosition();
    this->t_qryPositionSummary();
    this->t_qryFill();
//    this->t_qryAccountFeeRent();
//    this->t_qryAccountMarginRent();

    while (true)
    {
        m_Event.WaitEvent();
        return 0;
    }
}


// Rent
int Trade::t_qryAccountFeeRent()
{
    logger_debug(DEBUG_TEST2, 2, "*************** t_qryAccountFeeRent **************");

    TapAPIAccountFeeRentQryReq qryReq;
    memset(&qryReq, 0, sizeof(qryReq));
    strncpy(qryReq.AccountNo, m_pAccount->getAccountNo(), strlen(m_pAccount->getAccountNo()));

    TAPIINT32 iErr = TAPIERROR_SUCCEED;
    TAPIUINT32 reqid = 0;
    iErr = m_pAPI->QryAccountFeeRent(&reqid, &qryReq);
    if (iErr != TAPIERROR_SUCCEED) {
        logger_error("QryAccountFeeRent failed, errorCode: %d", iErr);
    }
    return iErr;
}

int Trade::t_qryAccountMarginRent()
{
    logger_debug(DEBUG_TEST2, 2, "*************** t_qryAccountMarginRent **************");

    TapAPIAccountMarginRentQryReq qryReq;
    memset(&qryReq, 0, sizeof(qryReq));
    strncpy(qryReq.AccountNo, m_pAccount->getAccountNo(), strlen(m_pAccount->getAccountNo()));
    qryReq.CommodityType = TAPI_COMMODITY_TYPE_FUTURES;
//    strcpy(qryReq.ExchangeNo, "NYMEX");
//    strcpy(qryReq.CommodityNo, "CL");

    TAPIINT32 iErr = TAPIERROR_SUCCEED;
    TAPIUINT32 reqid = 0;
    iErr = m_pAPI->QryAccountMarginRent(&reqid, &qryReq);
    if (iErr != TAPIERROR_SUCCEED) {
        logger_error("QryAccountMarginRent failed, errorCode: %d", iErr);
    }
    return iErr;
}


// Auth
void Trade::t_changePassword()
{
    logger_debug(DEBUG_TEST2, 2, "*************** t_changePassword **************");

    TAPISTR_20 oldPassword;
    TAPISTR_20 newPassword;
    cout << "please input oldPassword\n";
    cin >> oldPassword;
    cout << "please input newPassword\n";
    cin >> newPassword;

    TapAPIChangePasswordReq req;
    memset(&req, 0, sizeof(req));
    strncpy(req.AccountNo, m_pAccount->getAccountNo(), strlen(m_pAccount->getAccountNo()));
    req.PasswordType = APIPASSWORD_TRADE;
    strncpy(req.OldPassword, oldPassword, strlen(oldPassword));
    strncpy(req.NewPassword, newPassword, strlen(newPassword));
    TAPIUINT32 reqid = 0;
    TAPIINT32 iErr = m_pAPI->ChangePassword(&reqid, &req);
    if (iErr != TAPIERROR_SUCCEED) {
        logger_error("ChangePassword failed, errorCode: %d", iErr);
    }

}

void Trade::t_authPassword()
{
    logger_debug(DEBUG_TEST2, 2, "*************** t_authPassword **************");

    TAPISTR_20 password;
    cout << "please input password\n";
    cin >> password;

    TapAPIAuthPasswordReq req;
    memset(&req, 0, sizeof(req));
    strncpy(req.AccountNo, m_pAccount->getAccountNo(), strlen(m_pAccount->getAccountNo()));
    req.PasswordType = APIPASSWORD_TRADE;
    strncpy(req.Password, password, strlen(password));
    TAPIUINT32 reqid = 0;
    TAPIINT32 iErr = m_pAPI->AuthPassword(&reqid, &req);
    if (iErr != TAPIERROR_SUCCEED) {
        logger_error("AuthPassword failed, errorCode: %d", iErr);
    }
}

// 该接口暂未实现
void Trade::t_setReservedInfo()
{
    logger_debug(DEBUG_TEST2, 2, "*************** t_setReservedInfo **************");

    // 用户可以设置一个长度为50以内的字符信息，下次登录后可以得到这个信息
    // 这个功能主要是用来让用户确认是自己的帐号，主要是用来防伪
    TAPISTR_50 info;
    cout << "please input reservedInfo(<50 characters)\n";
    cin >> info;
    TAPIUINT32 reqid = 0;
    TAPIINT32 iErr = m_pAPI->SetReservedInfo(&reqid, info);
    if (iErr != TAPIERROR_SUCCEED) {
        logger_error("SetReservedInfo failed, errorCode: %d", iErr);
    }
}

void Trade::t_haveCertainRight()
{
    logger_debug(DEBUG_TEST2, 2, "*************** t_haveCertainRight **************");

    TAPIINT32 iErr = TAPIERROR_SUCCEED;
    TAPIRightIDType rightID;
    cout << "please input rightID(30001 30002 31000 31001 31002)\n";
    cin >> rightID;
    iErr = m_pAPI->HaveCertainRight(rightID);
    if (iErr == 0) {
        logger_error("Do not have this permission, errorCode: %d", iErr);
    } else {
        logger_error("Have this permission: %d", rightID);
    }

}

// HisOrder
void Trade::t_qryAccountCashAdjust()
{
    logger_debug(DEBUG_TEST2, 2, "*************** t_qryAccountCashAdjust **************");

    TAPIDATE beginDate;
    TAPIDATE endDate;
    time_t t = time(0);
    time_t t2 = t - 30*60*60*24;
    strftime(beginDate, sizeof(beginDate), "%Y-%m-%d", localtime(&t2));
    strftime(endDate, sizeof(endDate), "%Y-%m-%d", localtime(&t));

    TapAPIAccountCashAdjustQryReq qryReq;
    memset(&qryReq, 0, sizeof(qryReq));
    strncpy(qryReq.AccountNo, m_pAccount->getAccountNo(), strlen(m_pAccount->getAccountNo()));
    strncpy(qryReq.BeginDate, beginDate, strlen(beginDate));
    strncpy(qryReq.EndDate, endDate, strlen(endDate));

    TAPIINT32 iErr = TAPIERROR_SUCCEED;
    TAPIUINT32 reqid = 0;
    iErr = m_pAPI->QryAccountCashAdjust(&reqid, &qryReq);
    if (iErr != TAPIERROR_SUCCEED) {
        logger_error("QryAccountCashAdjust failed, errorCode: %d", iErr);
        return;
    }
}

void Trade::t_qryHisOrder()
{
    logger_debug(DEBUG_TEST2, 2, "*************** t_qryHisOrder **************");

    TAPIDATE beginDate;
    TAPIDATE endDate;
    time_t t = time(0);
    time_t t2 = t - 60*60*24;
    strftime(beginDate, sizeof(beginDate), "%Y-%m-%d", localtime(&t2));
    strftime(endDate, sizeof(endDate), "%Y-%m-%d", localtime(&t));

    TapAPIHisOrderQryReq qryReq;
    memset(&qryReq, 0, sizeof(qryReq));
    strncpy(qryReq.AccountNo, m_pAccount->getAccountNo(), strlen(m_pAccount->getAccountNo()));
    strncpy(qryReq.BeginDate, beginDate, strlen(beginDate));
    strncpy(qryReq.EndDate, endDate, strlen(endDate));

    TAPIINT32 iErr = TAPIERROR_SUCCEED;
    TAPIUINT32 reqid = 0;
    iErr = m_pAPI->QryHisOrder(&reqid, &qryReq);
    if (iErr != TAPIERROR_SUCCEED) {
        logger_error("QryHisOrder failed, errorCode: %d", iErr);
        return;
    }
}

void Trade::t_qryHisOrderProcess()
{
    logger_debug(DEBUG_TEST2, 2, "*************** t_qryHisOrderProcess **************");

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
    TAPIUINT32 reqid = 0;
    iErr = m_pAPI->QryHisOrderProcess(&reqid, &qryReq);
    if (iErr != TAPIERROR_SUCCEED) {
        logger_error("QryHisOrderProcess failed, errorCode: %d", iErr);
        return;
    }
}

void Trade::t_qryHisMatch()
{
    logger_debug(DEBUG_TEST2, 2, "*************** t_qryHisMatch **************");

    TAPIDATE beginDate;
    TAPIDATE endDate;
    time_t t = time(0);
    time_t t2 = t - 60*60*24;
    strftime(beginDate, sizeof(beginDate), "%Y-%m-%d", localtime(&t2));
    strftime(endDate, sizeof(endDate), "%Y-%m-%d", localtime(&t));

    TapAPIHisMatchQryReq qryReq;
    memset(&qryReq, 0, sizeof(qryReq));
    strncpy(qryReq.AccountNo, m_pAccount->getAccountNo(), strlen(m_pAccount->getAccountNo()));
    strncpy(qryReq.BeginDate, beginDate, strlen(beginDate));
    strncpy(qryReq.EndDate, endDate, strlen(endDate));

    TAPIINT32 iErr = TAPIERROR_SUCCEED;
    TAPIUINT32 reqid = 0;
    iErr = m_pAPI->QryHisMatch(&reqid, &qryReq);
    if (iErr != TAPIERROR_SUCCEED) {
        logger_error("QryHisMatch failed, errorCode: %d", iErr);
        return;
    }
}

void Trade::t_qryHisPosition()
{
    logger_debug(DEBUG_TEST2, 2, "*************** t_qryHisPosition **************");

    TapAPIHisPositionQryReq qryReq;
    memset(&qryReq, 0, sizeof(qryReq));
//    TAPIDATE date = "2021-01-15";
    time_t t = time(0);
    time_t t2 = t - 60*60*24;
    TAPIDATE date;
    strftime(date, sizeof(date), "%Y-%m-%d", localtime(&t2));
    strncpy(qryReq.AccountNo, m_pAccount->getAccountNo(), strlen(m_pAccount->getAccountNo()));
    strncpy(qryReq.Date, date, strlen(date));
    qryReq.SettleFlag = SettleFlag_AutoSettle;

    TAPIINT32 iErr = TAPIERROR_SUCCEED;
    TAPIUINT32 reqid = 0;
    iErr = m_pAPI->QryHisPosition(&reqid, &qryReq);
    if (iErr != TAPIERROR_SUCCEED) {
        logger_error("QryHisPosition failed, errorCode: %d", iErr);
        return;
    }
}

void Trade::t_qryHisDelivery()
{
    logger_debug(DEBUG_TEST2, 2, "*************** t_qryHisDelivery **************");

    TAPIDATE beginDate;
    TAPIDATE endDate;
    time_t t = time(0);
    time_t t2 = t - 60*60*24;
    strftime(beginDate, sizeof(beginDate), "%Y-%m-%d", localtime(&t2));
    strftime(endDate, sizeof(endDate), "%Y-%m-%d", localtime(&t));

    TapAPIHisDeliveryQryReq qryReq;
    memset(&qryReq, 0, sizeof(qryReq));
    strncpy(qryReq.AccountNo, m_pAccount->getAccountNo(), strlen(m_pAccount->getAccountNo()));
    strncpy(qryReq.BeginDate, beginDate, strlen(beginDate));
    strncpy(qryReq.EndDate, endDate, strlen(endDate));

    TAPIINT32 iErr = TAPIERROR_SUCCEED;
    TAPIUINT32 reqid = 0;
    iErr = m_pAPI->QryHisDelivery(&reqid, &qryReq);
    if (iErr != TAPIERROR_SUCCEED) {
        logger_error("QryHisDelivery failed, errorCode: %d", iErr);
        return;
    }
}



int Trade::t_qryOrder()
{
    logger_debug(DEBUG_TEST2, 2, "*************** t_qryOrder **************");

    TapAPIOrderQryReq qryReq;
    memset(&qryReq, 0, sizeof(qryReq));
    strncpy(qryReq.AccountNo, m_pAccount->getAccountNo(), strlen(m_pAccount->getAccountNo()));

    TAPIINT32 iErr = TAPIERROR_SUCCEED;
    TAPIUINT32 reqid = 0;
    iErr = m_pAPI->QryOrder(&reqid, &qryReq);
    if (iErr != TAPIERROR_SUCCEED) {
        logger_error("QryOrder failed, errorCode: %d", iErr);
    }
    return iErr;
}

int Trade::t_qryOrderByOrderNo(const char* OrderNo)
{
    logger_debug(DEBUG_TEST2, 2, "*************** t_qryOrderByOrderNo **************");

    TapAPIOrderQryReq qryReq;
    memset(&qryReq, 0, sizeof(qryReq));

    strncpy(qryReq.AccountNo, m_pAccount->getAccountNo(), strlen(m_pAccount->getAccountNo()));
    strncpy(qryReq.OrderNo, OrderNo, strlen(OrderNo));

    TAPIINT32 iErr = TAPIERROR_SUCCEED;
    TAPIUINT32 reqid = 0;
    iErr = m_pAPI->QryOrder(&reqid, &qryReq);
    if (iErr != TAPIERROR_SUCCEED) {
        logger_error("t_qryOrderByOrderNo failed, errorCode: %d", iErr);
    }
    return iErr;
}

void Trade::t_qryOrderProcess()
{
    logger_debug(DEBUG_TEST2, 2, "*************** t_qryOrderProcess **************");

    TapAPIOrderProcessQryReq qryReq;
    memset(&qryReq, 0, sizeof(qryReq));
    TAPISTR_20 orderNo = "OA202101180000000938";
    strncpy(qryReq.OrderNo, orderNo, strlen(orderNo));

    TAPIINT32 iErr = TAPIERROR_SUCCEED;
    TAPIUINT32 reqid = 0;
    iErr = m_pAPI->QryOrderProcess(&reqid, &qryReq);
    if (iErr != TAPIERROR_SUCCEED) {
        logger_error("QryOrderProcess failed, errorCode: %d", iErr);
        return;
    }
}

int Trade::t_qryFill()
{
    logger_debug(DEBUG_TEST2, 2, "*************** t_qryFill **************");

    TapAPIFillQryReq qryReq;
    memset(&qryReq, 0, sizeof(qryReq));
//    strncpy(qryReq.OrderNo, orderNo, strlen(orderNo));
    strncpy(qryReq.AccountNo, m_pAccount->getAccountNo(), strlen(m_pAccount->getAccountNo()));

    TAPIINT32 iErr = TAPIERROR_SUCCEED;
    TAPIUINT32 reqid = 0;
    iErr = m_pAPI->QryFill(&reqid, &qryReq);
    if (iErr != TAPIERROR_SUCCEED) {
        logger_error("QryFill failed, errorCode: %d", iErr);
    }
    return iErr;
}

int Trade::t_qryFillByOrderNo(const char* OrderNo)
{
    logger_debug(DEBUG_TEST2, 2, "*************** t_qryFill **************");

    TapAPIFillQryReq qryReq;
    memset(&qryReq, 0, sizeof(qryReq));
    strncpy(qryReq.AccountNo, m_pAccount->getAccountNo(), strlen(m_pAccount->getAccountNo()));
    strncpy(qryReq.OrderNo, OrderNo, strlen(OrderNo));
    TAPIINT32 iErr = TAPIERROR_SUCCEED;
    TAPIUINT32 reqid = 0;
    iErr = m_pAPI->QryFill(&reqid, &qryReq);
    if (iErr != TAPIERROR_SUCCEED) {
        logger_error("t_qryFillByOrderNo failed, errorCode: %d", iErr);
    }
    return iErr;
}

int Trade::t_qryPosition()
{
    logger_debug(DEBUG_TEST2, 2, "*************** t_qryPosition **************");

    TapAPIPositionQryReq qryReq;
    memset(&qryReq, 0, sizeof(qryReq));
    strncpy(qryReq.AccountNo, m_pAccount->getAccountNo(), strlen(m_pAccount->getAccountNo()));

    TAPIINT32 iErr = TAPIERROR_SUCCEED;
    TAPIUINT32 reqid = 0;
    iErr = m_pAPI->QryPosition(&reqid, &qryReq);
    if (iErr != TAPIERROR_SUCCEED) {
        logger_error("QryPosition failed, errorCode: %d", iErr);
    }
    return iErr;
}

int Trade::t_qryPositionSummary()
{
    logger_debug(DEBUG_TEST2, 2, "*************** t_qryPositionSummary **************");

    TapAPIPositionQryReq qryReq;
    memset(&qryReq, 0, sizeof(qryReq));
    strncpy(qryReq.AccountNo, m_pAccount->getAccountNo(), strlen(m_pAccount->getAccountNo()));

    TAPIINT32 iErr = TAPIERROR_SUCCEED;
    TAPIUINT32 reqid = 0;
    iErr = m_pAPI->QryPositionSummary(&reqid, &qryReq);
    if (iErr != TAPIERROR_SUCCEED) {
        logger_error("QryPositionSummary failed, errorCode: %d", iErr);
    }
    return iErr;
}




// UserFund Message
int Trade::t_qryAccount()
{
    logger_debug(DEBUG_TEST2, 2, "*************** t_qryAccount **************");
    TapAPIAccQryReq *req = new TapAPIAccQryReq();
    TAPIINT32 iErr = TAPIERROR_SUCCEED;
    TAPIUINT32 reqid = 0;
    iErr = m_pAPI->QryAccount(&reqid, req);
    if(iErr != TAPIERROR_SUCCEED) {
        logger_error("QryAccount failed, errorCode: %d", iErr);
    }
    delete req;
    return iErr;
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

void Trade::t_qryTradeMessage()
{
    logger_debug(DEBUG_TEST2, 2, "*************** t_qryTradeMessage **************");

    TapAPITradeMessageReq qryReq;
    TAPIDATETIME beginTime;
    TAPIDATETIME endTime;
    time_t t = time(0);
    time_t t2 = t + 7*60*60*24;
    strftime(beginTime, sizeof(beginTime), "%Y-%m-%d %H:%M;%S", localtime(&t));
    strftime(endTime, sizeof(endTime), "%Y-%m-%d %H:%M;%S", localtime(&t2));

    memset(&qryReq, 0, sizeof(qryReq));
    strncpy(qryReq.AccountNo, m_pAccount->getAccountNo(), strlen(m_pAccount->getAccountNo()));
//    strncpy(qryReq.AccountAttributeNo, m_pAccount->getAccountNo(), strlen(m_pAccount->getAccountNo()));
    strncpy(qryReq.BenginSendDateTime, beginTime, strlen(beginTime));
    strncpy(qryReq.EndSendDateTime, endTime, strlen(endTime));


    TAPIINT32 iErr = TAPIERROR_SUCCEED;
    TAPIUINT32 reqid = 0;
    iErr = m_pAPI->QryTradeMessage(&reqid, &qryReq);
    if(iErr != TAPIERROR_SUCCEED) {
        logger_error("QryTradeMessage, errorCode: %d", iErr);
    }
}



// Common
void Trade::t_qryTradingDate()
{
    logger_debug(DEBUG_TEST2, 2, "*************** t_qryTradingDate **************");

    TAPIINT32 iErr = TAPIERROR_SUCCEED;
    TAPIUINT32 reqid = 0;
    iErr = m_pAPI->QryTradingDate(&reqid);
    if(iErr != TAPIERROR_SUCCEED) {
        logger_error("QryTradingDate failed, errorCode: %d", iErr);
        return;
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

int Trade::t_qryCurrency()
{
    logger_debug(DEBUG_TEST2, 2, "*************** t_qryCurrency **************");

    TAPIINT32 iErr = TAPIERROR_SUCCEED;
    TAPIUINT32 reqid = 0;
    iErr = m_pAPI->QryCurrency(&reqid);
    if(iErr != TAPIERROR_SUCCEED) {
        logger_error("QryCurrency failed, errorCode: %d", iErr);
    }
    return iErr;
}

int Trade::t_qryCommodity()
{
    logger_debug(DEBUG_TEST2, 2, "*************** t_qryCommodity **************");

    TAPIINT32 iErr = TAPIERROR_SUCCEED;
    TAPIUINT32 reqid = 0;
    iErr = m_pAPI->QryCommodity(&reqid);
    return iErr;
}

int Trade::t_qryContract(const char* ExchangeNo, const char *CommodityNo)
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
    com.CommodityType =TAPI_COMMODITY_TYPE_FUTURES;
    TAPIUINT32 reqid = 0;
    iErr = m_pAPI->QryContract(&reqid,&com);
    if (iErr != TAPIERROR_SUCCEED) {
        logger_error("t_qryContract failed, errorCode: %d", iErr);
    }
    return iErr;
}


int Trade::t_insertOrder(const char* ExchangeNo, const char* CommodityNo,
                         const char* ContractNo, const char* OrderType, const char* TimeInForce,
                         const char* OrderSide, const char* OrderPrice, const char* OrderQty, const char* RefString)
{
    logger_debug(DEBUG_TEST2, 2, "*************** t_insertOrder **************");
    //下单
    TapAPINewOrder stNewOrder;
    strcpy(stNewOrder.AccountNo, m_pAccount->getAccountNo());
    strcpy(stNewOrder.ExchangeNo, ExchangeNo);
    stNewOrder.CommodityType = TAPI_COMMODITY_TYPE_FUTURES;
    strcpy(stNewOrder.CommodityNo, CommodityNo);
    strcpy(stNewOrder.ContractNo, ContractNo);
    // 委托类型
    stNewOrder.OrderType = OrderType[0];
    // 委托来源，默认程序单
    stNewOrder.OrderSource = TAPI_ORDER_SOURCE_PROGRAM;
    // 委托有效类型,默认当日有效
    stNewOrder.TimeInForce = TimeInForce[0];
    // 买入卖出
    stNewOrder.OrderSide = OrderSide[0];
    if (OrderPrice != NULL)
    {
        // 委托价格1
        stNewOrder.OrderPrice = atof(OrderPrice);
    }
    // 委托数量
    stNewOrder.OrderQty = atoi(OrderQty);
    // 触发价格
//    if (NULL != StopPrice) {
//        stNewOrder.StopPrice = atof(StopPrice);
//    }
    if (RefString != NULL)
    {
        strcpy(stNewOrder.RefString, RefString);
    }
    TAPISTR_50 stClientOrderNo ;
    memset(&stClientOrderNo,0,sizeof(stClientOrderNo));

    TAPIINT32 iErr = TAPIERROR_SUCCEED;
    m_uiSessionID = 0;
    iErr = m_pAPI->InsertOrder(&m_uiSessionID, &stClientOrderNo, &stNewOrder);
    if(TAPIERROR_SUCCEED != iErr) {
        logger_error("InsertOrder errorCode: %d", iErr);
    }
    return iErr;
}

int Trade::t_canncelOrder(const char* OrderNo)
{
    logger_debug(DEBUG_TEST2, 2, "*************** t_canncelOrder **************");

    TapAPIOrderCancelReq req;
    memset(&req,0,sizeof(req));
    strncpy(req.OrderNo, OrderNo, strlen(OrderNo));

    TAPIUINT32 reqid = 0;
    TAPIINT32 iErr = TAPIERROR_SUCCEED;

    iErr = m_pAPI->CancelOrder(&reqid,&req);
    if(iErr!= TAPIERROR_SUCCEED){
        logger_error("CancelOrder errorCode: %d", iErr);
    }
    return iErr;
}

void Trade::t_modify()
{
    logger_debug(DEBUG_TEST2, 2, "*************** t_modify **************");

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
    strncpy(req.ReqData.AccountNo,m_pAccount->getAccountNo(),strlen(m_pAccount->getAccountNo()));
    req.ReqData.OrderPrice = orderPrice;
    req.ReqData.OrderQty = orderQty;

    TAPIINT32  iErr = TAPIERROR_SUCCEED;
    iErr=m_pAPI->AmendOrder(&m_uiSessionID,&req);
    if(iErr!=TAPIERROR_SUCCEED){
        logger_error("AmendOrder errorCode: %d", iErr);
    }
}

void Trade::t_activeOrder()
{
    logger_debug(DEBUG_TEST2, 2, "*************** t_activeOrder **************");

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
        logger_error("ActivateOrder errorCode: %d", iErr);
    }
}

int Trade::t_disConnect()
{
    // 主动断开服务器链路连接
    TAPIINT32 iErr = TAPIERROR_SUCCEED;
    iErr = m_pAPI->Disconnect();
    if (TAPIERROR_SUCCEED != iErr) {
        logger_error("Disconnect Error: %d", iErr);
    } else {
        logger_error("connect is broken;");
    }
    return iErr;
}

void TAP_CDECL Trade::OnConnect(const TAPISTR_40 HostAddress)
{
    logger("HostAddress: %s", HostAddress);
}

void TAP_CDECL Trade::OnRspLogin( TAPIINT32 errorCode, const TapAPITradeLoginRspInfo *loginRspInfo )
{
    if(TAPIERROR_SUCCEED == errorCode) {
//		cout << "登录成功，等待API初始化..." << endl;
        logger("%s Log in successfully, wait for API initialization...", m_pAccount->getAccountNo());
    } else if(TAPIERROR_LOGIN_DDA == errorCode) {
//	    cout << "需要进行二次验证" << endl;
        logger_error("A second validation is required");
    } else {
//		cout << "登录失败，错误码:" << errorCode << endl;
        logger_error("%s Login failed, error code: %d", m_pAccount->getAccountNo(), errorCode);
        m_Event.SignalEvent();
    }
}

void TAP_CDECL Trade::OnAPIReady(ITapTrade::TAPIINT32 errorCode)
{
    // 在APIReady中，API自动进行基础数据查询和缓存，缓存的有权限、品种、合约、委托、成交、持仓等等
    logger("The API initialization is complete, %s", m_pAccount->getAccountNo());
    m_bIsAPIReady = true;
    m_Event.SignalEvent();
}

void TAP_CDECL Trade::OnDisconnect( TAPIINT32 reasonCode )
{
    logger_error("API disconnect, disconnect reason: %d, %s", reasonCode, m_pAccount->getAccountNo());
    // 解除锁定，TradeThread.cpp 中while(true) 进入循环，重新执行RunTrade，保证重连线程一致
//    if (reasonCode == 1 || reasonCode == 2 || reasonCode == 8) {
        this->m_reasonCode = reasonCode;
        m_bIsAPIReady = false;
        m_Event.SignalEvent();
//    }
}

void TAP_CDECL Trade::OnRspChangePassword( TAPIUINT32 sessionID, TAPIINT32 errorCode )
{
    logger_debug(DEBUG_TEST3, 1, "%s is called.",  __FUNCTION__);
    if (errorCode == TAPIERROR_SUCCEED) {
        cout << "Password changed successfully!" << endl;
    } else {
        cout << "Password changed failed, errorCode: " << errorCode << endl;
    }
}

// 该接口暂未实现
void TAP_CDECL Trade::OnRspSetReservedInfo( TAPIUINT32 sessionID, TAPIINT32 errorCode, const TAPISTR_50 info )
{
    logger_debug(DEBUG_TEST3, 1, "%s is called.",  __FUNCTION__);

    if (errorCode == TAPIERROR_SUCCEED) {
        cout << "Success to set ReservedInfo! info=" << info << endl;
    } else {
        cout << "Failed to set ReservedInfo, errorCode: " << errorCode << endl;
    }
}

void TAP_CDECL Trade::OnRspQryAccount( TAPIUINT32 sessionID, TAPIUINT32 errorCode, TAPIYNFLAG isLast, const TapAPIAccountInfo *info )
{
    logger_debug(DEBUG_TEST3, 1, "%s is called.",  __FUNCTION__);

    if(errorCode == TAPIERROR_SUCCEED) {
        std::string AccountType(1, info->AccountType);
        std::string AccountState(1, info->AccountState);
        std::string AccountTradeRight(1, info->AccountTradeRight);
        ACL_JSON* json = acl_json_alloc();
        acl_json_node_add_child(json->root, acl_json_create_text(json, "AccountNo", info->AccountNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "AccountType", AccountType.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "AccountState", AccountState.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "AccountTradeRight", AccountTradeRight.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityGroupNo", info->CommodityGroupNo));

        acl_json_node_add_child(json->root, acl_json_create_text(json, "AccountShortName", info->AccountShortName));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "AccountEnShortName", info->AccountEnShortName));

        ACL_VSTRING* buf = acl_json_build(json, NULL);
        char *outbuf = EsunnyUtil::EsunnyConvert(acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
        logger_debug(DEBUG_TEST3, 2, "%s", outbuf);
        EsunnyUtil::KafkaOrRedis(TOPIC_QRYACCOUNT, outbuf, strlen(outbuf));
        delete[] outbuf;
        acl_vstring_free(buf);
        acl_json_free(json);

        if(isLast == 'Y') {
            logger_debug(DEBUG_TEST3, 1, "%s is Last.", __FUNCTION__);
        }
    } else {
        logger_error("OnRspQryAccount failed, errorCode: %d", errorCode);
    }
}

void TAP_CDECL Trade::OnRspQryFund( TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPIFundData *info )
{
    logger_debug(DEBUG_TEST3, 1, "%s is called.",  __FUNCTION__);
    if(TAPIERROR_SUCCEED == errorCode) {
        if (info != NULL) {
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
            acl_json_node_add_child(json->root, acl_json_create_double(json, "SwapInValue", info->SwapInValue));
            acl_json_node_add_child(json->root, acl_json_create_double(json, "SwapOutValue", info->SwapOutValue));
            acl_json_node_add_child(json->root, acl_json_create_double(json, "PremiumIncome", info->PremiumIncome));
            acl_json_node_add_child(json->root, acl_json_create_double(json, "PremiumPay", info->PremiumPay));
            acl_json_node_add_child(json->root, acl_json_create_double(json, "CloseProfit", info->CloseProfit));
            acl_json_node_add_child(json->root, acl_json_create_double(json, "FrozenFund", info->FrozenFund));
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
            acl_json_node_add_child(json->root, acl_json_create_double(json, "AuthMoney", info->AuthMoney));


            ACL_VSTRING* buf = acl_json_build(json, NULL);
            logger_debug(DEBUG_TEST3, 2, "%s", acl_vstring_str(buf));
            EsunnyUtil::KafkaOrRedis(TOPIC_QRYFUND, acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
            acl_vstring_free(buf);
            acl_json_free(json);

            if(isLast == 'Y') {
                logger("数据推送结束");
            }

        } else {
            logger("Fund is  NULL");
        }
    } else {
        logger_error("OnRspQryFund Failed, errorCode: %d", errorCode);
    }
}

void TAP_CDECL Trade::OnRtnFund( const ITapTrade::TapAPIFundData *info )
{
//    logger_debug(DEBUG_TEST3, 1, "%s is called.",  __FUNCTION__);

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
    acl_json_node_add_child(json->root, acl_json_create_double(json, "SwapInValue", info->SwapInValue));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "SwapOutValue", info->SwapOutValue));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "PremiumIncome", info->PremiumIncome));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "PremiumPay", info->PremiumPay));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "CloseProfit", info->CloseProfit));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "FrozenFund", info->FrozenFund));
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
    acl_json_node_add_child(json->root, acl_json_create_double(json, "AuthMoney", info->AuthMoney));


    ACL_VSTRING* buf = acl_json_build(json, NULL);
//    logger_debug(DEBUG_TEST3, 2, "%s", acl_vstring_str(buf));
    EsunnyUtil::KafkaOrRedis(TOPIC_QRYFUND, acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
    acl_vstring_free(buf);
    acl_json_free(json);
}

void TAP_CDECL Trade::OnRspQryExchange( TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const ITapTrade::TapAPIExchangeInfo *info )
{
    logger_debug(DEBUG_TEST3, 1, "%s is called.",  __FUNCTION__);

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

void TAP_CDECL Trade::OnRspQryCommodity( TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPICommodityInfo *info )
{
    logger_debug(DEBUG_TEST3, 1, "%s is called.",  __FUNCTION__);
    if(TAPIERROR_SUCCEED == errorCode)
    {
        if (NULL != info)
        {
            std::string CommodityType(1, info->CommodityType);
            std::string RelateCommodityType(1, info->RelateCommodityType);
            std::string RelateCommodityType2(1, info->RelateCommodityType2);
            std::string OpenCloseMode(1, info->OpenCloseMode);
            std::string CmbDirect(1, info->CmbDirect);
            std::string DeliveryMode(1, info->DeliveryMode);
            std::string IsAddOne(1,info->IsAddOne);
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
            acl_json_node_add_child(json->root, acl_json_create_text(json, "CurrencyGroupNo", info->CurrencyGroupNo));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "TradeCurrency", info->TradeCurrency));
            acl_json_node_add_child(json->root, acl_json_create_double(json, "ContractSize", info->ContractSize));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "OpenCloseMode", OpenCloseMode.c_str()));
            acl_json_node_add_child(json->root, acl_json_create_double(json, "StrikePriceTimes", info->StrikePriceTimes));
            std::ostringstream oss;
            // 设置精度为10
            oss.precision(10);
            oss << info->CommodityTickSize;
            std::string CommodityTickSize_Str = oss.str();
//            std::cout << CommodityTickSize_Str << std::endl;
            acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityTickSize", CommodityTickSize_Str.c_str()));
            acl_json_node_add_child(json->root, acl_json_create_double(json, "CommodityDenominator", info->CommodityDenominator));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "CmbDirect", CmbDirect.c_str()));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "DeliveryMode", DeliveryMode.c_str()));
            acl_json_node_add_child(json->root, acl_json_create_int64(json, "DeliveryDays", info->DeliveryDays));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "AddOneTime", info->AddOneTime));
            acl_json_node_add_child(json->root, acl_json_create_int64(json, "CommodityTimeZone", info->CommodityTimeZone));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "IsAddOne", IsAddOne.c_str()));

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
//        cout << "品种信息获取失败, 错误码: " << errorCode << endl;
        logger_error("commodities retrieval failed, errorCode %d", errorCode);
    }
}

void TAP_CDECL Trade::OnRspQryContract( TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPITradeContractInfo *info )
{
    logger_debug(DEBUG_TEST3, 1, "%s is called.",  __FUNCTION__);

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
    logger_debug(DEBUG_TEST3, 1, "%s is called.",  __FUNCTION__);

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
    logger_debug(DEBUG_TEST3, 1, "%s is called.",  __FUNCTION__);

    if(NULL == info){
        logger_error("info is NULL");
        return;
    }

    if(info->ErrorCode != 0) {
		logger_error("服务器返回了一个关于委托信息的错误: %d", info->ErrorCode);
    } else {
        if (info->OrderInfo) {
            if(0 != info->OrderInfo->ErrorCode){
                logger_error("报单失败, errorCode: %d", info->OrderInfo->ErrorCode);
            } else {
                logger("报单成功, OrderState: %c", info->OrderInfo->OrderState);
            }
        }
    }
    if (info->OrderInfo != NULL) {
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
        acl_json_node_add_child(json->root, acl_json_create_int64(json, "RefInt", info->OrderInfo->RefInt));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "RefDouble", info->OrderInfo->RefDouble));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "RefString", info->OrderInfo->RefString));
        acl_json_node_add_child(json->root, acl_json_create_int64(json, "MinClipSize", info->OrderInfo->MinClipSize));
        acl_json_node_add_child(json->root, acl_json_create_int64(json, "MaxClipSize", info->OrderInfo->MaxClipSize));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "LicenseNo", info->OrderInfo->LicenseNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "ServerFlag", ServerFlag.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderNo", info->OrderInfo->OrderNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "ClientOrderNo", info->OrderInfo->ClientOrderNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "ClientID", info->OrderInfo->ClientID));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "TacticsType", TacticsType.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "TriggerCondition", TriggerCondition.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "TriggerPriceType", TriggerPriceType.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "AddOneIsValid", AddOneIsValid.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "ClientLocalIP", info->OrderInfo->ClientLocalIP));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "ClientMac", info->OrderInfo->ClientMac));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "ClientIP", info->OrderInfo->ClientIP));
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
        ACL_VSTRING* buf = acl_json_build(json, NULL);
        char *outbuf = EsunnyUtil::EsunnyConvert(acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
        logger_debug(DEBUG_TEST3, 2, "%s", outbuf);
        EsunnyUtil::KafkaOrRedis(TOPIC_ORDER, outbuf, strlen(outbuf));
        delete[] outbuf;
        acl_vstring_free(buf);
        acl_json_free(json);
    }

}

void TAP_CDECL Trade::OnRspOrderAction( TAPIUINT32 sessionID, TAPIINT32 errorCode, const TapAPIOrderActionRsp *info)
{
    logger_debug(DEBUG_TEST3, 1, "%s is called.",  __FUNCTION__);
//    std::cout << "sessionId=" << sessionID <<std::endl;

    if (errorCode != TAPIERROR_SUCCEED)
    {
        logger_error("OnRspOrderAction failed, errorCode: %d", errorCode);
    }

    if (NULL != info) {
        if (NULL != info->OrderInfo) {
            logger("ActionType = %c", info->ActionType);
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
            ACL_JSON *json = acl_json_alloc();
//            acl_json_node_add_child(json->root, acl_json_create_text(json, "ActionType", ActionType.c_str()));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "AccountNo", info->OrderInfo->AccountNo));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "ExchangeNo", info->OrderInfo->ExchangeNo));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityType", CommodityType.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "CommodityNo", info->OrderInfo->CommodityNo));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "ContractNo", info->OrderInfo->ContractNo));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "StrikePrice", info->OrderInfo->StrikePrice));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "CallOrPutFlag", CallOrPutFlag.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ContractNo2", info->OrderInfo->ContractNo2));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "StrikePrice2", info->OrderInfo->StrikePrice2));
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
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "OrderPrice", info->OrderInfo->OrderPrice));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "OrderPrice2", info->OrderInfo->OrderPrice2));
            acl_json_node_add_child(json->root, acl_json_create_double(json, "StopPrice", info->OrderInfo->StopPrice));
            acl_json_node_add_child(json->root, acl_json_create_int64(json, "OrderQty", info->OrderInfo->OrderQty));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "OrderMinQty", info->OrderInfo->OrderMinQty));
            acl_json_node_add_child(json->root, acl_json_create_int64(json, "RefInt", info->OrderInfo->RefInt));
            acl_json_node_add_child(json->root, acl_json_create_double(json, "RefDouble", info->OrderInfo->RefDouble));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "RefString", info->OrderInfo->RefString));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "MinClipSize", info->OrderInfo->MinClipSize));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "MaxClipSize", info->OrderInfo->MaxClipSize));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "LicenseNo", info->OrderInfo->LicenseNo));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "ServerFlag", ServerFlag.c_str()));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderNo", info->OrderInfo->OrderNo));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ClientOrderNo", info->OrderInfo->ClientOrderNo));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "ClientID", info->OrderInfo->ClientID));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "TacticsType", TacticsType.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "TriggerCondition", TriggerCondition.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "TriggerPriceType", TriggerPriceType.c_str()));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "AddOneIsValid", AddOneIsValid.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ClientLocalIP", info->OrderInfo->ClientLocalIP));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "ClientMac", info->OrderInfo->ClientMac));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "ClientIP", info->OrderInfo->ClientIP));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "OrderStreamID", info->OrderInfo->OrderStreamID));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "UpperNo", info->OrderInfo->UpperNo));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "UpperChannelNo", info->OrderInfo->UpperChannelNo));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "OrderLocalNo", info->OrderInfo->OrderLocalNo));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "UpperStreamID", info->OrderInfo->UpperStreamID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "OrderSystemNo", info->OrderInfo->OrderSystemNo));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderExchangeSystemNo",
                                                                     info->OrderInfo->OrderExchangeSystemNo));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderParentSystemNo",
                                                                     info->OrderInfo->OrderParentSystemNo));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderInsertUserNo",
                                                                     info->OrderInfo->OrderInsertUserNo));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "OrderInsertTime", info->OrderInfo->OrderInsertTime));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderCommandUserNo",
                                                                     info->OrderInfo->OrderCommandUserNo));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderUpdateUserNo",
                                                                     info->OrderInfo->OrderUpdateUserNo));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "OrderUpdateTime", info->OrderInfo->OrderUpdateTime));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderState", OrderState.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "OrderMatchPrice", info->OrderInfo->OrderMatchPrice));
            acl_json_node_add_child(json->root, acl_json_create_double(json, "OrderMatchPrice2",
                                                                       info->OrderInfo->OrderMatchPrice2));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "OrderMatchQty", info->OrderInfo->OrderMatchQty));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "OrderMatchQty2", info->OrderInfo->OrderMatchQty2));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "IsBackInput", IsBackInput.c_str()));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "IsDeleted", IsDeleted.c_str()));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "IsAddOne", IsAddOne.c_str()));
            acl_json_node_add_child(json->root, acl_json_create_int64(json, "ErrorCode", info->OrderInfo->ErrorCode));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "ErrorText", info->OrderInfo->ErrorText));

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


void TAP_CDECL Trade::OnRspQryOrder( TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPIOrderInfo *info )
{

    logger_debug(DEBUG_TEST3, 1, "%s is called.",  __FUNCTION__);

    if (errorCode != TAPIERROR_SUCCEED)
    {
        logger_error("OnRspQryOrder, errorCode: %d", errorCode);
    }

    if (NULL != info) {
//        if (info->ErrorCode != 0 && info->OrderState != '6') {
//            logger_error("The server returned an error about delegate information: %d", info->ErrorCode);
//        }
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
        acl_json_node_add_child(json->root, acl_json_create_int64(json, "RefInt", info->RefInt));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "RefDouble", info->RefDouble));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "RefString", info->RefString));
        acl_json_node_add_child(json->root, acl_json_create_int64(json, "MinClipSize", info->MinClipSize));
        acl_json_node_add_child(json->root, acl_json_create_int64(json, "MaxClipSize", info->MaxClipSize));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "LicenseNo", info->LicenseNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "ServerFlag", ServerFlag.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderNo", info->OrderNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "ClientOrderNo", info->ClientOrderNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "ClientID", info->ClientID));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "TacticsType", TacticsType.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "TriggerCondition", TriggerCondition.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "TriggerPriceType", TriggerPriceType.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "AddOneIsValid", AddOneIsValid.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "ClientLocalIP", info->ClientLocalIP));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "ClientMac", info->ClientMac));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "ClientIP", info->ClientIP));
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

        ACL_VSTRING* buf = acl_json_build(json, NULL);
        char *outbuf = EsunnyUtil::EsunnyConvert(acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
        logger_debug(DEBUG_TEST3, 2, "%s", outbuf);
        EsunnyUtil::KafkaOrRedis(TOPIC_ORDER, outbuf, strlen(outbuf));
        delete[] outbuf;
        acl_vstring_free(buf);
        acl_json_free(json);

    } else {
        logger("委托信息为空");
        return;
    }
    if (isLast == 'Y') {
        logger("数据推送结束");
        return;
    }
}

void TAP_CDECL Trade::OnRspQryOrderProcess( TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPIOrderInfo *info )
{
    logger_debug(DEBUG_TEST3, 1, "%s is called.",  __FUNCTION__);

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
            logger_debug(DEBUG_TEST3, 1, "%s is Last.", __FUNCTION__);
            return;
        }

    } else {
        logger_error("OnRspQryOrder, errorCode: %d", errorCode);
    }

}

void TAP_CDECL Trade::OnRspQryFill( TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPIFillInfo *info )
{
    logger_debug(DEBUG_TEST3, 1, "%s is called.",  __FUNCTION__);

    if (errorCode == TAPIERROR_SUCCEED) {
        if (NULL != info) {
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
            acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderSystemNo", info->OrderSystemNo));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "MatchNo", info->MatchNo));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "UpperMatchNo", info->UpperMatchNo));
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
            acl_json_node_add_child(json->root, acl_json_create_double(json, "ClosePrositionPrice", info->ClosePrositionPrice));


            ACL_VSTRING* buf = acl_json_build(json, NULL);
            logger_debug(DEBUG_TEST3, 2, "%s", acl_vstring_str(buf));
            EsunnyUtil::KafkaOrRedis(TOPIC_FILL, acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
            acl_vstring_free(buf);
            acl_json_free(json);
        } else {
            logger("成交信息为空");
            return;
        }

        if (isLast == 'Y') {
            logger("数据推送结束");
            return;
        }

    } else {
        logger_error("OnRspQryFill, errorCode: %d", errorCode);
    }
}

void TAP_CDECL Trade::OnRtnFill( const TapAPIFillInfo *info )
{
    logger_debug(DEBUG_TEST3, 1, "%s is called.",  __FUNCTION__);

    if(NULL == info){
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
    acl_json_node_add_child(json->root, acl_json_create_text(json, "OrderSystemNo", info->OrderSystemNo));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "MatchNo", info->MatchNo));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "UpperMatchNo", info->UpperMatchNo));
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
    acl_json_node_add_child(json->root, acl_json_create_double(json, "ClosePrositionPrice", info->ClosePrositionPrice));

    ACL_VSTRING* buf = acl_json_build(json, NULL);
    logger_debug(DEBUG_TEST3, 2, "%s", acl_vstring_str(buf));
    EsunnyUtil::KafkaOrRedis(TOPIC_FILL, acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
    acl_vstring_free(buf);
    acl_json_free(json);
}

void TAP_CDECL Trade::OnRspQryPosition( TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPIPositionInfo *info )
{
    logger_debug(DEBUG_TEST3, 1, "%s is called.",  __FUNCTION__);
    if (errorCode == TAPIERROR_SUCCEED) {
        if (info != NULL) {
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
            acl_json_node_add_child(json->root, acl_json_create_double(json, "CalculatePrice", info->CalculatePrice));
            acl_json_node_add_child(json->root, acl_json_create_double(json, "AccountInitialMargin", info->AccountInitialMargin));
            acl_json_node_add_child(json->root, acl_json_create_double(json, "AccountMaintenanceMargin", info->AccountMaintenanceMargin));
            acl_json_node_add_child(json->root, acl_json_create_double(json, "UpperInitialMargin", info->UpperInitialMargin));
            acl_json_node_add_child(json->root, acl_json_create_double(json, "UpperMaintenanceMargin", info->UpperMaintenanceMargin));
            acl_json_node_add_child(json->root, acl_json_create_double(json, "PositionProfit", info->PositionProfit));
            acl_json_node_add_child(json->root, acl_json_create_double(json, "LMEPositionProfit", info->LMEPositionProfit));
            acl_json_node_add_child(json->root, acl_json_create_double(json, "OptionMarketValue", info->OptionMarketValue));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "IsHistory", IsHistory.c_str()));

            ACL_VSTRING* buf = acl_json_build(json, NULL);
            logger_debug(DEBUG_TEST3, 2, "%s", acl_vstring_str(buf));
            EsunnyUtil::KafkaOrRedis(TOPIC_POSITION, acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
            acl_vstring_free(buf);
            acl_json_free(json);
        } else {
            logger("用户持仓为空");
            return;
        }

        if (isLast == 'Y')
        {
            logger("数据推送结束");
//        return;
        }
    } else {
        logger_error("OnRspQryPosition failed, errorCode: %d", errorCode);
    }

}

void TAP_CDECL Trade::OnRtnPosition( const TapAPIPositionInfo *info )
{
    logger_debug(DEBUG_TEST3, 1, "%s is called.",  __FUNCTION__);

    if (info == NULL) return;

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
    acl_json_node_add_child(json->root, acl_json_create_double(json, "CalculatePrice", info->CalculatePrice));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "AccountInitialMargin", info->AccountInitialMargin));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "AccountMaintenanceMargin", info->AccountMaintenanceMargin));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "UpperInitialMargin", info->UpperInitialMargin));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "UpperMaintenanceMargin", info->UpperMaintenanceMargin));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "PositionProfit", info->PositionProfit));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "LMEPositionProfit", info->LMEPositionProfit));
    acl_json_node_add_child(json->root, acl_json_create_double(json, "OptionMarketValue", info->OptionMarketValue));
    acl_json_node_add_child(json->root, acl_json_create_text(json, "IsHistory", IsHistory.c_str()));

    ACL_VSTRING* buf = acl_json_build(json, NULL);
    logger_debug(DEBUG_TEST3, 2, "%s", acl_vstring_str(buf));
    EsunnyUtil::KafkaOrRedis(TOPIC_POSITION, acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
    acl_vstring_free(buf);
    acl_json_free(json);

}

void TAP_CDECL Trade::OnRspQryClose( TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPICloseInfo *info )
{
    logger("%s is called.",  __FUNCTION__);
}

void TAP_CDECL Trade::OnRtnClose( const TapAPICloseInfo *info )
{
    logger("%s is called.",  __FUNCTION__);
}

void TAP_CDECL Trade::OnRtnPositionProfit( const TapAPIPositionProfitNotice *info )
{
//    if (info->IsLast == 'Y') return;
//
//    logger("%s is called.",  __FUNCTION__);
//
//    if (info != NULL) {
//        std::string IsLast(1, info->IsLast);
//        ACL_JSON* json = acl_json_alloc();
//        acl_json_node_add_child(json->root, acl_json_create_text(json, "IsLast", IsLast.c_str()));
//        acl_json_node_add_child(json->root, acl_json_create_text(json, "PositionNo", info->Data->PositionNo));
//        acl_json_node_add_child(json->root, acl_json_create_int64(json, "PositionStreamId", info->Data->PositionStreamId));
//        acl_json_node_add_child(json->root, acl_json_create_double(json, "PositionProfit", info->Data->PositionProfit));
//        acl_json_node_add_child(json->root, acl_json_create_double(json, "LMEPositionProfit", info->Data->LMEPositionProfit));
//        acl_json_node_add_child(json->root, acl_json_create_double(json, "OptionMarketValue", info->Data->OptionMarketValue));
//        acl_json_node_add_child(json->root, acl_json_create_double(json, "CalculatePrice", info->Data->CalculatePrice));
//
//        ACL_VSTRING* buf = acl_json_build(json, NULL);
//        char *outbuf = EsunnyUtil::EsunnyConvert(acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
//        logger("%s", outbuf);
//        EsunnyUtil::KafkaOrRedis(TOPIC_POSITION, outbuf, strlen(outbuf));
//        delete[] outbuf;
//        acl_vstring_free(buf);
//        acl_json_free(json);
//    }

}

void TAP_CDECL Trade::OnRspQryCurrency(TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPICurrencyInfo *info)
{

    logger_debug(DEBUG_TEST3, 1, "%s is called.",  __FUNCTION__);

    if (NULL != info)
    {
        std::string FutureAlg(1, info->FutureAlg);
        std::string OptionAlg(1, info->OptionAlg);
        ACL_JSON* json = acl_json_alloc();
        acl_json_node_add_child(json->root, acl_json_create_text(json, "CurrencyNo", info->CurrencyNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "CurrencyGroupNo", info->CurrencyGroupNo));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "TradeRate", info->TradeRate));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "TradeRate2", info->TradeRate2));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "FutureAlg", FutureAlg.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "OptionAlg", OptionAlg.c_str()));

        ACL_VSTRING* buf = acl_json_build(json, NULL);
        logger_debug(DEBUG_TEST3, 2, "%s", acl_vstring_str(buf));
        EsunnyUtil::KafkaOrRedis(TOPIC_QRYCURRENCY, acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
        acl_vstring_free(buf);
        acl_json_free(json);
    }

    if (isLast=='Y')
    {
        logger("数据推送结束");
        return;
    }
}

void TAP_CDECL Trade::OnRspQryTradeMessage(TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPITradeMessage *info)
{
    logger("%s is called.",  __FUNCTION__);

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
            logger("%s is called.",  __FUNCTION__);
        }
        if (isLast == 'Y') {
            logger("数据推送结束");
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
        logger_debug(DEBUG_TEST3, 1, "%s is Last.", __FUNCTION__);
        return;
    }

    logger("%s is called.",  __FUNCTION__);
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

    logger("%s is called.",  __FUNCTION__);
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
            logger("数据推送结束");
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
        logger("最后一批数据");
    }

    logger("%s is called.",  __FUNCTION__);
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
        logger_debug(DEBUG_TEST3, 1, "%s is Last.", __FUNCTION__);
        return;
    }

    logger("%s is called.",  __FUNCTION__);
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
    logger_debug(DEBUG_TEST3, 1, "%s is called.",  __FUNCTION__);
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
            logger("数据推送结束");
            return;
        }

    } else {
        cout << "OnRspQryHisDelivery, errorCode: " << errorCode << endl;
    }
}

void TAP_CDECL Trade::OnRspQryAccountCashAdjust(TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPIAccountCashAdjustQryRsp *info)
{

    logger_debug(DEBUG_TEST3, 1, "%s is called.",  __FUNCTION__);
    if (errorCode == TAPIERROR_SUCCEED) {

        if (info != NULL) {
            cout << "accountCashAdjust{"
                 << "Date:" << info->Date << ","
                 << "CurrencyNo:" << info->CurrencyNo << ","
                 << "CashAdjustValue:" << info->CashAdjustValue
                 << "}" << endl;
        }
        if (isLast == 'Y') {
            logger("数据推送结束");
            return;
        }

    } else {
        logger_error("OnRspQryAccountCashAdjust, errorCode: %d", errorCode);
    }
}

void TAP_CDECL Trade::OnRspQryBill(TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPIBillQryRsp *info)
{
}

void TAP_CDECL Trade::OnExpriationDate(ITapTrade::TAPIDATE date, int days)
{
    logger_warn("OnExpriationDate Warning: %s, Left Days: %d", date, days);
}

void TAP_CDECL Trade::OnRspQryAccountFeeRent(ITapTrade::TAPIUINT32 sessionID, ITapTrade::TAPIINT32 errorCode, ITapTrade::TAPIYNFLAG isLast, const ITapTrade::TapAPIAccountFeeRentQryRsp *info)
{
    if (errorCode == TAPIERROR_SUCCEED) {
        std::string CommodityType(1, info->CommodityType);
        std::string MatchSource(1, info->MatchSource);
        std::string CalculateMode(1, info->CalculateMode);
        ACL_JSON *json = acl_json_alloc();
        acl_json_node_add_child(json->root, acl_json_create_text(json, "AccountNo", info->AccountNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "ExchangeNo", info->ExchangeNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityType", CommodityType.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityNo", info->CommodityNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "MatchSource", MatchSource.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "CalculateMode", CalculateMode.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "CurrencyGroupNo", info->CurrencyGroupNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "CurrencyNo", info->CurrencyNo));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "OpenCloseFee", info->OpenCloseFee));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "CloseTodayFee", info->CloseTodayFee));
        ACL_VSTRING *buf = acl_json_build(json, NULL);
        logger_debug(DEBUG_TEST3, 2, "%s", acl_vstring_str(buf));
        EsunnyUtil::KafkaOrRedis(TOPIC_ACCOUNT_FEE_RENT, acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
        acl_vstring_free(buf);
        acl_json_free(json);

        if (isLast == 'Y')
        {
            logger("数据推送结束");
//        return;
        }
    } else {
        cout << "OnRspQryAccountFeeRent failed, errorCode: " << errorCode << endl;
    }
}

void TAP_CDECL Trade::OnRspQryAccountMarginRent(ITapTrade::TAPIUINT32 sessionID, ITapTrade::TAPIINT32 errorCode, ITapTrade::TAPIYNFLAG isLast, const ITapTrade::TapAPIAccountMarginRentQryRsp *info)
{
    if (errorCode == TAPIERROR_SUCCEED) {
        logger_debug(DEBUG_TEST3, 1, "%s is called.",  __FUNCTION__);
        if (info != NULL)
        {
            std::string CommodityType(1, info->CommodityType);
            std::string CallOrPutFlag(1, info->CallOrPutFlag);
            std::string CalculateMode(1, info->CalculateMode);
            ACL_JSON* json = acl_json_alloc();
            acl_json_node_add_child(json->root, acl_json_create_text(json, "AccountNo", info->AccountNo));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "ExchangeNo", info->ExchangeNo));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityType", CommodityType.c_str()));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityNo", info->CommodityNo));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "ContractNo", info->ContractNo));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "StrikePrice", info->StrikePrice));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "CallOrPutFlag", CallOrPutFlag.c_str()));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "CalculateMode", CalculateMode.c_str()));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "CurrencyGroupNo", info->CurrencyGroupNo));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "CurrencyNo", info->CurrencyNo));
            acl_json_node_add_child(json->root, acl_json_create_double(json, "InitialMargin", info->InitialMargin));
            acl_json_node_add_child(json->root, acl_json_create_double(json, "MaintenanceMargin", info->MaintenanceMargin));
            acl_json_node_add_child(json->root, acl_json_create_double(json, "SellInitialMargin", info->SellInitialMargin));
            acl_json_node_add_child(json->root, acl_json_create_double(json, "SellMaintenanceMargin", info->SellMaintenanceMargin));
            acl_json_node_add_child(json->root, acl_json_create_double(json, "LockMargin", info->LockMargin));

            ACL_VSTRING* buf = acl_json_build(json, NULL);
            logger_debug(DEBUG_TEST3, 2, "%s", acl_vstring_str(buf));
            EsunnyUtil::KafkaOrRedis(TOPIC_ACCOUNT_MARGIN_RENT, acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
            acl_vstring_free(buf);
            acl_json_free(json);
        }

        if (isLast == 'Y')
        {
            logger("数据推送结束");
//            return;
        }
    } else {
        logger_error("OnRspQryAccountFeeRent failed, errorCode: %d", errorCode);
    }
}

void TAP_CDECL Trade::OnRtnContactInfo(ITapTrade::TAPIINT32 errorCode, ITapTrade::TAPIYNFLAG isLast, const ITapTrade::TAPISTR_40 ContactInfo)
{
//    if (TAPIERROR_SUCCEED == errorCode) {
//
//        logger("%s is called.",  __FUNCTION__);
//
//        out << "ContactInfo" << ContactInfo << endl;
//
//        TAPIINT32 iErr = TAPIERROR_SUCCEED;
//        iErr = m_pAPI->RequestVertificateCode(&m_uiSessionID, ContactInfo);
//        if (iErr != TAPIERROR_SUCCEED) {
//            cout << "RequestVertificateCode failed, errorCode: %d", iErr);
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
//        logger("%s is called.",  __FUNCTION__);
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
//            cout << "SetVertificateCode failed, errorCode: %d", iErr);
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
    logger("%s is called.",  __FUNCTION__);

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
    logger_debug(DEBUG_TEST3, 1, "%s is called.",  __FUNCTION__);
    if (info != NULL) {
        std::string CommodityType(1, info->CommodityType);
        std::string CallOrPutFlag(1, info->CallOrPutFlag);
        std::string MatchSide(1, info->MatchSide);
        ACL_JSON* json = acl_json_alloc();
        acl_json_node_add_child(json->root, acl_json_create_text(json, "AccountNo", info->AccountNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "ExchangeNo", info->ExchangeNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityType", CommodityType.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityNo", info->CommodityNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "ContractNo", info->ContractNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "StrikePrice", info->StrikePrice));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "CallOrPutFlag", CallOrPutFlag.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "MatchSide", MatchSide.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "PositionPrice", info->PositionPrice));
        acl_json_node_add_child(json->root, acl_json_create_int64(json, "PositionQty", info->PositionQty));
        acl_json_node_add_child(json->root, acl_json_create_int64(json, "HisPositionQty", info->HisPositionQty));
        ACL_VSTRING* buf = acl_json_build(json, NULL);
        char *outbuf = EsunnyUtil::EsunnyConvert(acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
        logger_debug(DEBUG_TEST3, 2, "%s", outbuf);
        EsunnyUtil::KafkaOrRedis(TOPIC_POSITION_SUMMARY, outbuf, strlen(outbuf));
        delete[] outbuf;
        acl_vstring_free(buf);
        acl_json_free(json);
    } else {
        logger("用户持仓汇总为空");
        return;
    }

    if (isLast == 'Y') {
        logger("数据推送结束");
        return;
    }
}

void TAP_CDECL Trade::OnRtnPositionSummary(const TapAPIPositionSummary *info)
{
    logger_debug(DEBUG_TEST3, 1, "%s is called.",  __FUNCTION__);

    if (info != NULL) {
        std::string CommodityType(1, info->CommodityType);
        std::string CallOrPutFlag(1, info->CallOrPutFlag);
        std::string MatchSide(1, info->MatchSide);
        ACL_JSON* json = acl_json_alloc();
        acl_json_node_add_child(json->root, acl_json_create_text(json, "AccountNo", info->AccountNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "ExchangeNo", info->ExchangeNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityType", CommodityType.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityNo", info->CommodityNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "ContractNo", info->ContractNo));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "StrikePrice", info->StrikePrice));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "CallOrPutFlag", CallOrPutFlag.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_text(json, "MatchSide", MatchSide.c_str()));
        acl_json_node_add_child(json->root, acl_json_create_double(json, "PositionPrice", info->PositionPrice));
        acl_json_node_add_child(json->root, acl_json_create_int64(json, "PositionQty", info->PositionQty));
        acl_json_node_add_child(json->root, acl_json_create_int64(json, "HisPositionQty", info->HisPositionQty));
        ACL_VSTRING* buf = acl_json_build(json, NULL);
        char *outbuf = EsunnyUtil::EsunnyConvert(acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
        logger_debug(DEBUG_TEST3, 2, "%s", outbuf);
        EsunnyUtil::KafkaOrRedis(TOPIC_POSITION_SUMMARY, outbuf, strlen(outbuf));
        delete[] outbuf;
        acl_vstring_free(buf);
        acl_json_free(json);
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
