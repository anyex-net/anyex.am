#include "../../include/quote/Quote.h"
#include "TapAPIError.h"
#include <iostream>
#include <string.h>
#include <json/acl_json.h>
#include <stdlib/acl_argv.h>
#include "utils/EsunnyUtil.h"

extern char *quote_list;

const char* TOPIC_SUBQUOTE = "TopicSubscribeQuoteWhole";
const char* TOPIC_UNSUBQUOTE = "TopicUnSubscribeQuoteWhole";

Quote::Quote(void):
        m_pAPI(NULL),
        m_bIsAPIReady(false),
        m_reasonCode(0)
{
}


Quote::~Quote(void)
{
}


void Quote::SetAPI(ITapQuoteAPI *pAPI)
{
    m_pAPI = pAPI;
}

void Quote::setAccount(std::shared_ptr<Account> account)
{
    m_pAccount = account;
}


int Quote::RunQuote()
{
    logger("AccountNo(%s) quote start", m_pAccount->getAccountNo());
    if(NULL == m_pAPI) {
        logger_error("Error: m_pAPI is NULL.");
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
    TapAPIQuoteLoginAuth stLoginAuth;
    memset(&stLoginAuth, 0, sizeof(stLoginAuth));
    strcpy(stLoginAuth.UserNo, m_pAccount->getAccountNo());
    strcpy(stLoginAuth.Password, m_pAccount->getPassword());
    stLoginAuth.ISModifyPassword = APIYNFLAG_NO;
    stLoginAuth.ISDDA = APIYNFLAG_NO;
//    logger("%s,%s", stLoginAuth.UserNo, stLoginAuth.Password);
    iErr = m_pAPI->Login(&stLoginAuth);
    if(TAPIERROR_SUCCEED != iErr) {
        logger_error("Quote Login Error: %d", iErr);
        return iErr;
    }
    //等待APIReady
    m_Event.WaitEvent();
    if (!m_bIsAPIReady){
        logger_error("%s'API is not ready", m_pAccount->getAccountNo());
        return -1;
    }

//    q_qryCommodity();
//    q_qryContract("HKEX");

    if (strcmp(quote_list, "") != 0) {
        ACL_ARGV *argv = acl_argv_split(quote_list, ",");
        ACL_ITER iter;
                acl_foreach(iter, argv) {
            ACL_ARGV *s_argv = acl_argv_split((const char*)iter.data, ".");
            ACL_ITER s_iter;
            const char *params[3];
                    acl_foreach(s_iter, s_argv) {
                params[s_iter.i] = (const char*)s_iter.data;
            }
            q_subscribeQuote(params[0], params[1], params[2]);
            acl_argv_free(s_argv);
        }
        acl_argv_free(argv);
    }

    while(true) {
        m_Event.WaitEvent();
        return 0;
    }
}

void Quote::loopCmd()
{
    this->printHelp();
    while(1)
    {
        char cmd;
        std::cin >>cmd;
        switch (cmd)
        {
            case '1': this->q_qryCommodity(); break;
            case '2': this->q_qryContract("");break;
            case '3': this->q_subscribeQuote("COMEX", "GC", "2107");break;
            case '4': this->q_unSubscribeQuote("COMEX", "GC", "2107");break;
            case '5': this->q_disConnect();break;
            case 'H': this->printHelp();break;
            default:
                break;
        }
    }
}

void Quote::printHelp()
{
    std::cout<<"---------------------------------\n"
        <<"iTapQuoteAPI_Demo CMD\n"
        <<"--->1 : qryCommodity \n"
        <<"--->2 : qryContract \n"
        <<"--->3 : subscribeQuote \n"
        <<"--->4 : unSubscribeQuote \n"
        <<"--->5 : exit\n"
        <<"--->H : help\n"
        <<"----------------------------------\n"
        <<std::endl;
}

int Quote::q_login()
{
    TAPIINT32 iErr = TAPIERROR_SUCCEED;
  
    //登录服务器
    TapAPIQuoteLoginAuth stLoginAuth;
    memset(&stLoginAuth, 0, sizeof(stLoginAuth));
    strcpy(stLoginAuth.UserNo, m_pAccount->getAccountNo());
    strcpy(stLoginAuth.Password, m_pAccount->getPassword());
    stLoginAuth.ISModifyPassword = APIYNFLAG_NO;
    stLoginAuth.ISDDA = APIYNFLAG_NO;
    iErr = m_pAPI->Login(&stLoginAuth);
    if(TAPIERROR_SUCCEED != iErr) {
        logger_error("Quote Login Error: %d", iErr);
    }
    return iErr;
}

int Quote::q_qryCommodity()
{
    // 得到所有品种
    m_uiSessionID = 0;
    int iErr = m_pAPI->QryCommodity(&m_uiSessionID);
    return iErr;
}

int Quote::q_qryContract(const char* ExchangeNo)
{
    m_uiSessionID = 0;
    TapAPICommodity com;
    memset(&com, 0, sizeof(com));
    strcpy(com.ExchangeNo, "HKEX");
	strcpy(com.CommodityNo, "HSI");
    com.CommodityType =TAPI_COMMODITY_TYPE_FUTURES;
    m_pAPI->QryContract(&m_uiSessionID,&com);

}

int Quote::q_subscribeQuote(const char* ExchangeNo, const char* CommodityNo, const char* ContractNo)
{
    logger_debug(DEBUG_TEST2, 2, "*********************** q_subscribeQuote ******************");
    logger_debug(DEBUG_TEST2, 1, "ExchangeNo=%s, CommodityNo=%s, ContractNo=%s", ExchangeNo,CommodityNo,ContractNo);
    //订阅行情
    TapAPIContract stContract;
    memset(&stContract, 0, sizeof(stContract));
    strcpy(stContract.Commodity.ExchangeNo, ExchangeNo);
    stContract.Commodity.CommodityType = TAPI_COMMODITY_TYPE_FUTURES;
    strcpy(stContract.Commodity.CommodityNo, CommodityNo);
    strcpy(stContract.ContractNo1, ContractNo);
    stContract.CallOrPutFlag1 = TAPI_CALLPUT_FLAG_NONE;
    stContract.CallOrPutFlag2 = TAPI_CALLPUT_FLAG_NONE;
    m_uiSessionID = 0;
    TAPIINT32 iErr = TAPIERROR_SUCCEED;
    iErr = m_pAPI->SubscribeQuote(&m_uiSessionID, &stContract);
    if(TAPIERROR_SUCCEED != iErr) {
        logger_error("SubscribeQuote Error: %d", iErr);
    }
    return iErr;
}

int Quote::q_unSubscribeQuote(const char* ExchangeNo, const char* CommodityNo, const char* ContractNo)
{
    logger_debug(DEBUG_TEST2, 2, "*********************** q_unSubscribeQuote ******************");
    logger_debug(DEBUG_TEST2, 1, "ExchangeNo=%s, CommodityNo=%s, ContractNo=%s", ExchangeNo,CommodityNo,ContractNo);
    // 取消行情订阅
    TapAPIContract sContract;
    memset(&sContract, 0, sizeof(sContract));
    strcpy(sContract.Commodity.ExchangeNo, ExchangeNo);
    sContract.Commodity.CommodityType = TAPI_COMMODITY_TYPE_FUTURES;
    strcpy(sContract.Commodity.CommodityNo, CommodityNo);
    strcpy(sContract.ContractNo1, ContractNo);
    sContract.CallOrPutFlag1 = TAPI_CALLPUT_FLAG_NONE;
    sContract.CallOrPutFlag2 = TAPI_CALLPUT_FLAG_NONE;
    m_uiSessionID = 0;
    TAPIINT32 iErr = TAPIERROR_SUCCEED;
    iErr = m_pAPI->UnSubscribeQuote(&m_uiSessionID, &sContract);
    if (TAPIERROR_SUCCEED != iErr) {
        logger_error("UnSubscribeQuote Error: %d", iErr);
    }
    return iErr;
}

int Quote::q_disConnect()
{
    // 主动断开服务器链路连接
    TAPIINT32 iErr = TAPIERROR_SUCCEED;
    iErr = m_pAPI->Disconnect();
    if (TAPIERROR_SUCCEED != iErr) {
        logger_error("Disconnect Error: %d", iErr);
    } else {
        logger_error("connect is broken");
    }
    return iErr;
}




void TAP_CDECL Quote::OnRspLogin(TAPIINT32 errorCode, const TapAPIQuotLoginRspInfo *info)
{
    if(TAPIERROR_SUCCEED == errorCode) {
//		std::cout << "登录成功，等待API初始化..." << std::endl;
        logger("%s Log in successfully, wait for API initialization...", m_pAccount->getAccountNo());
        m_bIsAPIReady = true;

    } else {
//		std::cout << "登录失败，错误码:" << errorCode << std::endl;
        logger_error("%s Login failed, error code: %d", m_pAccount->getAccountNo(), errorCode);
        m_Event.SignalEvent();
    }
}

void TAP_CDECL Quote::OnAPIReady()
{
//	std::cout << "API初始化完成" << std::endl;
    logger("The API initialization is complete, %s", m_pAccount->getAccountNo());
    m_Event.SignalEvent();
}

void TAP_CDECL Quote::OnDisconnect(TAPIINT32 reasonCode)
{
//    std::cout << "API断开,断开原因:"<<reasonCode << std::endl;
    logger_error("API disconnect, disconnect reason: %d, AccountNo %s", reasonCode, m_pAccount->getAccountNo());
//    if (reasonCode == 1 || reasonCode == 2 || reasonCode == 8 || reasonCode == 13) {
        this->m_reasonCode = reasonCode;
        m_bIsAPIReady = false;
        m_Event.SignalEvent();
//    }
}

void TAP_CDECL Quote::OnRspQryCommodity(TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPIQuoteCommodityInfo *info)
{
    if(TAPIERROR_SUCCEED == errorCode)
    {
        logger("%s is called.",  __FUNCTION__);
        if (NULL != info) {
            logger("%s is called.",  __FUNCTION__);
            std::cout << "commodity:" << "{"
                 << "ExchangeNo:" << info->Commodity.ExchangeNo << ", "
                 << "CommodityType:" << info->Commodity.CommodityType << ", "
                 << "CommodityNo:" << info->Commodity.CommodityNo << ", "
                 << "CommodityName:" << info->CommodityName << ", "
                 << "CommodityEngName:" << info->CommodityEngName << ", "
                 //                << "ContractSize:" << info->ContractSize << ", "
                 //                << "CommodityTickSize:" << info->CommodityTickSize << ", "
                 //                << "CommodityDenominator:" << info->CommodityDenominator << ", "
                 //                << "CmbDirect:" << info->CmbDirect << ", "
                 //                << "CommodityContractLen:" << info->CommodityContractLen << ", "
                 //                << "IsDST:" << info->IsDST << ", "
                 << "RelateCommodity1:" << info->RelateCommodity1.ExchangeNo << ", "
                 << "RelateCommodity1:" << info->RelateCommodity1.CommodityNo << ", "
                 << "RelateCommodity2:" << info->RelateCommodity2.ExchangeNo << ", "
                 << "RelateCommodity2:" << info->RelateCommodity2.CommodityNo
                 << "}" << std::endl;
        }

        if(isLast=='Y')
        {
            logger("%s is Last",  __FUNCTION__);
            return;
        }
    } else
    {
//        std::cout << "品种信息获取失败, 错误码: " << errorCode << std::endl;
        logger_error("commodities retrieval failed, errorCode: %d", errorCode);
    }
}

void TAP_CDECL Quote::OnRspQryContract(TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPIQuoteContractInfo *info)
{
    logger("%s is called.",  __FUNCTION__);

//	std::cout << "合约:" << info->Contract.Commodity.CommodityNo << info->Contract.ContractNo1 << std::endl;
    if (NULL != info) {
        std::cout << "contract: " << "{"
                  << "ExchangeNo:" << info->Contract.Commodity.ExchangeNo << ", "
                  << "CommodityType:" << info->Contract.Commodity.CommodityType << ", "
                  << "CommodityNo:" << info->Contract.Commodity.CommodityNo << ", "
                  << "ContractNo1:" << info->Contract.ContractNo1 << ", "
                  << "StrikePrice1:" << info->Contract.StrikePrice1 << ", "
                  << "CallOrPutFlag1:" << info->Contract.CallOrPutFlag1 << ", "
                  << "ContractNo2:" << info->Contract.ContractNo2 << ", "
                  << "StrikePrice2:" << info->Contract.StrikePrice2 << ", "
                  << "ContractType:" << info->ContractType << ", "
                  << "QuoteUnderlyingContract:" << info->QuoteUnderlyingContract << ", "
                  << "ContractName:" << info->ContractName << ", "
                  << "ContractExpDate:" << info->ContractExpDate << ", "
                  << "LastTradeDate:" << info->LastTradeDate << ", "
                  << "FirstNoticeDate:" << info->FirstNoticeDate
                  << "}" << std::endl;
    }

    if(isLast=='Y')
    {
        logger("%s is last", __FUNCTION__);
        return ;
    }
}

void TAP_CDECL Quote::OnRspSubscribeQuote(TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPIQuoteWhole *info)
{
    if (TAPIERROR_SUCCEED == errorCode)
    {
        logger("%s %s%s Market Subscription Successfully", info->Contract.Commodity.ExchangeNo,
                info->Contract.Commodity.CommodityNo,info->Contract.ContractNo1);
        if (NULL != info)
        {
            std::string CommodityType(1, info->Contract.Commodity.CommodityType);
            std::string UnderlyContract_CommodityType(1, info->UnderlyContract.Commodity.CommodityType);
            std::string CallOrPutFlag1(1, info->Contract.CallOrPutFlag1);
            std::string UnderlyContract_CallOrPutFlag1(1, info->UnderlyContract.CallOrPutFlag1);
            std::string CallOrPutFlag2(1, info->Contract.CallOrPutFlag2);
            std::string TradingState(1, info->TradingState);
            std::string UnderlyContract_CallOrPutFlag2(1, info->UnderlyContract.CallOrPutFlag2);
            ACL_JSON* json = acl_json_alloc();
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ExchangeNo", info->Contract.Commodity.ExchangeNo));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "CommodityType", CommodityType.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "CommodityNo", info->Contract.Commodity.CommodityNo));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ContractNo1", info->Contract.ContractNo1));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "StrikePrice1", info->Contract.StrikePrice1));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "CallOrPutFlag1", CallOrPutFlag1.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ContractNo2", info->Contract.ContractNo2));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "StrikePrice2", info->Contract.StrikePrice2));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "CallOrPutFlag2", CallOrPutFlag2.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "CurrencyNo", info->CurrencyNo));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "TradingState", TradingState.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "DateTimeStamp", info->DateTimeStamp));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "QPreClosingPrice", info->QPreClosingPrice));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "QPreSettlePrice", info->QPreSettlePrice));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "QPrePositionQty", info->QPrePositionQty));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "QOpeningPrice", info->QOpeningPrice));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "QLastPrice", info->QLastPrice));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "QHighPrice", info->QHighPrice));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "QLowPrice", info->QLowPrice));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "QHisHighPrice", info->QHisHighPrice));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "QHisLowPrice", info->QHisLowPrice));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "QLimitUpPrice", info->QLimitUpPrice));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "QLimitDownPrice", info->QLimitDownPrice));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "QTotalQty", info->QTotalQty));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "QTotalTurnover", info->QTotalTurnover));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "QPositionQty", info->QPositionQty));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "QAveragePrice", info->QAveragePrice));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "QClosingPrice", info->QClosingPrice));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "QSettlePrice", info->QSettlePrice));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "QLastQty", info->QLastQty));
            if (info->QBidPrice[1] != 0) {
                std::string QBidPrice = std::to_string(info->QBidPrice[0]) + "," + std::to_string(info->QBidPrice[1]) + "," +
                                        std::to_string(info->QBidPrice[2]) + "," + std::to_string(info->QBidPrice[3]) + "," +
                                        std::to_string(info->QBidPrice[4]);
                std::string QBidQty = std::to_string(info->QBidQty[0]) + "," + std::to_string(info->QBidQty[1]) + "," +
                                      std::to_string(info->QBidQty[2]) + "," + std::to_string(info->QBidQty[3]) + "," +
                                      std::to_string(info->QBidQty[4]);
                acl_json_node_add_child(json->root,
                                        acl_json_create_text(json, "QBidPrice", QBidPrice.c_str()));
                acl_json_node_add_child(json->root,
                                        acl_json_create_text(json, "QBidQty", QBidQty.c_str()));
            } else {
                acl_json_node_add_child(json->root,
                                        acl_json_create_text(json, "QBidPrice", std::to_string(info->QBidPrice[0]).c_str()));
                acl_json_node_add_child(json->root,
                                        acl_json_create_text(json, "QBidQty", std::to_string(info->QBidQty[0]).c_str()));
            }
            if (info->QAskPrice[1] != 0) {
                std::string QAskPrice = std::to_string(info->QAskPrice[0]) + "," + std::to_string(info->QAskPrice[1]) + "," +
                                        std::to_string(info->QAskPrice[2]) + "," + std::to_string(info->QAskPrice[3]) + "," +
                                        std::to_string(info->QAskPrice[4]);
                std::string QAskQty = std::to_string(info->QAskQty[0]) + "," + std::to_string(info->QAskQty[1]) + "," +
                                      std::to_string(info->QAskQty[2]) + "," + std::to_string(info->QAskQty[3]) + "," +
                                      std::to_string(info->QAskQty[4]);
                acl_json_node_add_child(json->root,
                                        acl_json_create_text(json, "QAskPrice", QAskPrice.c_str()));
                acl_json_node_add_child(json->root,
                                        acl_json_create_text(json, "QAskQty", QAskQty.c_str()));
            } else {
                acl_json_node_add_child(json->root,
                                        acl_json_create_text(json, "QAskPrice", std::to_string(info->QAskPrice[0]).c_str()));
                acl_json_node_add_child(json->root,
                                        acl_json_create_text(json, "QAskQty", std::to_string(info->QAskQty[0]).c_str()));
            }
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "QImpliedBidPrice", info->QImpliedBidPrice));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "QImpliedBidQty", info->QImpliedBidQty));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "QImpliedAskPrice", info->QImpliedAskPrice));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "QImpliedAskQty", info->QImpliedAskQty));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "QPreDelta", info->QPreDelta));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "QCurrDelta", info->QCurrDelta));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "QInsideQty", info->QInsideQty));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "QOutsideQty", info->QOutsideQty));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "QTurnoverRate", info->QTurnoverRate));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "Q5DAvgQty", info->Q5DAvgQty));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "QPERatio", info->QPERatio));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "QTotalValue", info->QTotalValue));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "QNegotiableValue", info->QNegotiableValue));
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "QPositionTrend", info->QPositionTrend));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "QChangeSpeed", info->QChangeSpeed));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "QChangeRate", info->QChangeRate));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "QChangeValue", info->QChangeValue));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "QSwing", info->QSwing));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "QTotalBidQty", info->QTotalBidQty));
            acl_json_node_add_child(json->root,
                                    acl_json_create_double(json, "QTotalAskQty", info->QTotalAskQty));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "UnderlyContract_ExchangeNo", info->UnderlyContract.Commodity.ExchangeNo));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "UnderlyContract_CommodityType", UnderlyContract_CommodityType.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "UnderlyContract_CommodityNo", info->UnderlyContract.Commodity.CommodityNo));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "UnderlyContract_ContractNo1", info->UnderlyContract.ContractNo1));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "UnderlyContract_StrikePrice1", info->UnderlyContract.StrikePrice1));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "UnderlyContract_CallOrPutFlag1", UnderlyContract_CallOrPutFlag1.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "UnderlyContract_ContractNo2", info->UnderlyContract.ContractNo2));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "UnderlyContract_StrikePrice2", info->UnderlyContract.StrikePrice2));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "UnderlyContract_CallOrPutFlag2", UnderlyContract_CallOrPutFlag2.c_str()));

            ACL_VSTRING* buf = acl_json_build(json, NULL);
            logger_debug(DEBUG_TEST3, 2, "%s", acl_vstring_str(buf));
            EsunnyUtil::KafkaOrRedis(TOPIC_SUBQUOTE, acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
            acl_vstring_free(buf);
            acl_json_free(json);
        }

    } else{
        if (info != NULL)
        {
            logger("Quotation %s.%s%s subscription failed, error code: %d", info->Contract.Commodity.ExchangeNo,
                   info->Contract.Commodity.CommodityNo,info->Contract.ContractNo1,errorCode);
        } else {
            logger_error("Quotation subscription failed, error code: %d", errorCode);
        }
    }
}

void TAP_CDECL Quote::OnRspUnSubscribeQuote(TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPIContract *info)
{
    if (TAPIERROR_SUCCEED == errorCode) {
        logger("%s %s%s Market UnSubscription Successfully", info->Commodity.ExchangeNo,
                info->Commodity.CommodityNo,info->ContractNo1);

        if (NULL != info)
        {
            std::string CommodityType(1, info->Commodity.CommodityType);
            std::string CallOrPutFlag1(1, info->CallOrPutFlag1);
            std::string CallOrPutFlag2(1, info->CallOrPutFlag2);
            ACL_JSON* json = acl_json_alloc();
            acl_json_node_add_child(json->root, acl_json_create_text(json, "ExchangeNo", info->Commodity.ExchangeNo));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityType", CommodityType.c_str()));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "CommodityNo", info->Commodity.CommodityNo));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "ContractNo1", info->ContractNo1));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "StrikePrice1", info->StrikePrice1));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "CallOrPutFlag1", CallOrPutFlag1.c_str()));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "ContractNo2", info->ContractNo2));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "StrikePrice2", info->StrikePrice2));
            acl_json_node_add_child(json->root, acl_json_create_text(json, "CallOrPutFlag2", CallOrPutFlag2.c_str()));

            ACL_VSTRING* buf = acl_json_build(json, NULL);
            logger_debug(DEBUG_TEST3, 2, "%s", acl_vstring_str(buf));
            EsunnyUtil::KafkaOrRedis(TOPIC_UNSUBQUOTE, acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
            acl_vstring_free(buf);
            acl_json_free(json);
        }

    }else{
        if (info != NULL)
        {
            logger("Quotation %s.%s%s UnSubscription failed, error code: %d", info->Commodity.ExchangeNo,
                   info->Commodity.CommodityNo,info->ContractNo1,errorCode);
        } else {
            logger_error("Quotation UnSubscription failed, error code: %d", errorCode);
        }
    }
}

void TAP_CDECL Quote::OnRtnQuote(const TapAPIQuoteWhole *info)
{
    logger_debug(DEBUG_TEST3, 2, "行情更新");
    if (NULL != info)
    {
        std::string CommodityType(1, info->Contract.Commodity.CommodityType);
        std::string UnderlyContract_CommodityType(1, info->UnderlyContract.Commodity.CommodityType);
        std::string CallOrPutFlag1(1, info->Contract.CallOrPutFlag1);
        std::string UnderlyContract_CallOrPutFlag1(1, info->UnderlyContract.CallOrPutFlag1);
        std::string CallOrPutFlag2(1, info->Contract.CallOrPutFlag2);
        std::string TradingState(1, info->TradingState);
        std::string UnderlyContract_CallOrPutFlag2(1, info->UnderlyContract.CallOrPutFlag2);
        ACL_JSON* json = acl_json_alloc();
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "ExchangeNo", info->Contract.Commodity.ExchangeNo));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "CommodityType", CommodityType.c_str()));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "CommodityNo", info->Contract.Commodity.CommodityNo));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "ContractNo1", info->Contract.ContractNo1));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "StrikePrice1", info->Contract.StrikePrice1));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "CallOrPutFlag1", CallOrPutFlag1.c_str()));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "ContractNo2", info->Contract.ContractNo2));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "StrikePrice2", info->Contract.StrikePrice2));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "CallOrPutFlag2", CallOrPutFlag2.c_str()));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "CurrencyNo", info->CurrencyNo));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "TradingState", TradingState.c_str()));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "DateTimeStamp", info->DateTimeStamp));
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "QPreClosingPrice", info->QPreClosingPrice));
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "QPreSettlePrice", info->QPreSettlePrice));
        acl_json_node_add_child(json->root,
                                acl_json_create_int64(json, "QPrePositionQty", info->QPrePositionQty));
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "QOpeningPrice", info->QOpeningPrice));
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "QLastPrice", info->QLastPrice));
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "QHighPrice", info->QHighPrice));
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "QLowPrice", info->QLowPrice));
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "QHisHighPrice", info->QHisHighPrice));
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "QHisLowPrice", info->QHisLowPrice));
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "QLimitUpPrice", info->QLimitUpPrice));
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "QLimitDownPrice", info->QLimitDownPrice));
        acl_json_node_add_child(json->root,
                                acl_json_create_int64(json, "QTotalQty", info->QTotalQty));
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "QTotalTurnover", info->QTotalTurnover));
        acl_json_node_add_child(json->root,
                                acl_json_create_int64(json, "QPositionQty", info->QPositionQty));
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "QAveragePrice", info->QAveragePrice));
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "QClosingPrice", info->QClosingPrice));
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "QSettlePrice", info->QSettlePrice));
        acl_json_node_add_child(json->root,
                                acl_json_create_int64(json, "QLastQty", info->QLastQty));
        if (info->QBidPrice[1] != 0) {
            std::string QBidPrice = std::to_string(info->QBidPrice[0]) + "," + std::to_string(info->QBidPrice[1]) + "," +
                                    std::to_string(info->QBidPrice[2]) + "," + std::to_string(info->QBidPrice[3]) + "," +
                                    std::to_string(info->QBidPrice[4]);
            std::string QBidQty = std::to_string(info->QBidQty[0]) + "," + std::to_string(info->QBidQty[1]) + "," +
                                  std::to_string(info->QBidQty[2]) + "," + std::to_string(info->QBidQty[3]) + "," +
                                  std::to_string(info->QBidQty[4]);
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "QBidPrice", QBidPrice.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "QBidQty", QBidQty.c_str()));
        } else {
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "QBidPrice", std::to_string(info->QBidPrice[0]).c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "QBidQty", std::to_string(info->QBidQty[0]).c_str()));
        }
        if (info->QAskPrice[1] != 0) {
            std::string QAskPrice = std::to_string(info->QAskPrice[0]) + "," + std::to_string(info->QAskPrice[1]) + "," +
                                    std::to_string(info->QAskPrice[2]) + "," + std::to_string(info->QAskPrice[3]) + "," +
                                    std::to_string(info->QAskPrice[4]);
            std::string QAskQty = std::to_string(info->QAskQty[0]) + "," + std::to_string(info->QAskQty[1]) + "," +
                                  std::to_string(info->QAskQty[2]) + "," + std::to_string(info->QAskQty[3]) + "," +
                                  std::to_string(info->QAskQty[4]);
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "QAskPrice", QAskPrice.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "QAskQty", QAskQty.c_str()));
        } else {
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "QAskPrice", std::to_string(info->QAskPrice[0]).c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "QAskQty", std::to_string(info->QAskQty[0]).c_str()));
        }
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "QImpliedBidPrice", info->QImpliedBidPrice));
        acl_json_node_add_child(json->root,
                                acl_json_create_int64(json, "QImpliedBidQty", info->QImpliedBidQty));
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "QImpliedAskPrice", info->QImpliedAskPrice));
        acl_json_node_add_child(json->root,
                                acl_json_create_int64(json, "QImpliedAskQty", info->QImpliedAskQty));
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "QPreDelta", info->QPreDelta));
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "QCurrDelta", info->QCurrDelta));
        acl_json_node_add_child(json->root,
                                acl_json_create_int64(json, "QInsideQty", info->QInsideQty));
        acl_json_node_add_child(json->root,
                                acl_json_create_int64(json, "QOutsideQty", info->QOutsideQty));
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "QTurnoverRate", info->QTurnoverRate));
        acl_json_node_add_child(json->root,
                                acl_json_create_int64(json, "Q5DAvgQty", info->Q5DAvgQty));
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "QPERatio", info->QPERatio));
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "QTotalValue", info->QTotalValue));
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "QNegotiableValue", info->QNegotiableValue));
        acl_json_node_add_child(json->root,
                                acl_json_create_int64(json, "QPositionTrend", info->QPositionTrend));
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "QChangeSpeed", info->QChangeSpeed));
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "QChangeRate", info->QChangeRate));
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "QChangeValue", info->QChangeValue));
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "QSwing", info->QSwing));
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "QTotalBidQty", info->QTotalBidQty));
        acl_json_node_add_child(json->root,
                                acl_json_create_double(json, "QTotalAskQty", info->QTotalAskQty));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "UnderlyContract_ExchangeNo", info->UnderlyContract.Commodity.ExchangeNo));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "UnderlyContract_CommodityType", UnderlyContract_CommodityType.c_str()));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "UnderlyContract_CommodityNo", info->UnderlyContract.Commodity.CommodityNo));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "UnderlyContract_ContractNo1", info->UnderlyContract.ContractNo1));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "UnderlyContract_StrikePrice1", info->UnderlyContract.StrikePrice1));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "UnderlyContract_CallOrPutFlag1", UnderlyContract_CallOrPutFlag1.c_str()));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "UnderlyContract_ContractNo2", info->UnderlyContract.ContractNo2));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "UnderlyContract_StrikePrice2", info->UnderlyContract.StrikePrice2));
        acl_json_node_add_child(json->root,
                                acl_json_create_text(json, "UnderlyContract_CallOrPutFlag2", UnderlyContract_CallOrPutFlag2.c_str()));

        ACL_VSTRING* buf = acl_json_build(json, NULL);
        logger_debug(DEBUG_TEST3, 2, "%s", acl_vstring_str(buf));
        EsunnyUtil::KafkaOrRedis(TOPIC_SUBQUOTE, acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
        acl_vstring_free(buf);
        acl_json_free(json);

    }
}