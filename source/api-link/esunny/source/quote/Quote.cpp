#include "../../include/quote/Quote.h"
#include "../../include/esunny/TapAPIError.h"
#include "../../include/quote/QuoteConfig.h"
#include <iostream>
#include <string.h>
#include "unistd.h"
#include "../../include/json/json.h"
#include "../../include/spdlog/spdlog.h"
#include "../../include/common/config.h"
#include "../../include/tool/sw/redis++/redis++.h"
using namespace sw::redis;
using namespace std;
extern Redis *m_redis;
extern std::string ConfigFile;

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


void Quote::RunQuote()
{
	if(NULL == m_pAPI) {
        spdlog::error("Error: m_pAPI is NULL.");
		return;
	}

	TAPIINT32 iErr = TAPIERROR_SUCCEED;


    std::string value;
    Config configSettings(ConfigFile);
    std::string quote_default_ip = configSettings.Read("quote_default_ip", value);
    int quote_default_port = configSettings.Read("quote_default_port", 0);
    spdlog::info("quote_default_ip: {}", quote_default_ip);
    spdlog::info("quote_default_port: {}", quote_default_port);
	//设定服务器IP、端口
	if (this->m_reasonCode == 0) {
        iErr = m_pAPI->SetHostAddress(quote_default_ip.c_str(), quote_default_port);
        if(TAPIERROR_SUCCEED != iErr) {
            spdlog::error("SetHostAddress Error: {}", iErr);
            return;
        }
	}


    std::string quote_default_username = configSettings.Read("quote_default_username", value);
    std::string quote_default_password = configSettings.Read("quote_default_password", value);
    spdlog::info("quote_default_username: {}", quote_default_username);
    spdlog::info("quote_default_password: {}", quote_default_password);
    //登录服务器
    TapAPIQuoteLoginAuth stLoginAuth;
    memset(&stLoginAuth, 0, sizeof(stLoginAuth));
    strcpy(stLoginAuth.UserNo, quote_default_username.c_str());
    strcpy(stLoginAuth.Password, quote_default_password.c_str());
    stLoginAuth.ISModifyPassword = APIYNFLAG_NO;
    stLoginAuth.ISDDA = APIYNFLAG_NO;
    iErr = m_pAPI->Login(&stLoginAuth);
    if(TAPIERROR_SUCCEED != iErr) {
        spdlog::error("Quote Login Error: {}", iErr);
        return;
    }

	//等待APIReady
	m_Event.WaitEvent();
	if (!m_bIsAPIReady){
		return;
	}


   while(true) {
       m_Event.WaitEvent();
       return;
   }
}

void Quote::loopCmd()
{
    this->printHelp();
    while(1)
    {
        char cmd;
        cin>>cmd;
        switch (cmd)
        {
            case '1': this->q_qryCommodity(); break;
            case '2': this->q_qryContract("");break;
            case '3': this->q_subscribeQuote(QUOTE_DEFAULT_EXCHANGE_NO, QUOTE_DEFAULT_COMMODITY_NO, QUOTE_DEFAULT_CONTRACT_NO);break;
            case '4': this->q_unSubscribeQuote(QUOTE_DEFAULT_EXCHANGE_NO, QUOTE_DEFAULT_COMMODITY_NO, QUOTE_DEFAULT_CONTRACT_NO);break;
            case '5': this->q_disConnect();break;
            case 'H': this->printHelp();break;
            default:
                break;
        }
    }
}

void Quote::printHelp()
{
    cout<<"---------------------------------\n"
        <<"iTapQuoteAPI_Demo CMD\n"
        <<"--->1 : qryCommodity \n"
        <<"--->2 : qryContract \n"
        <<"--->3 : subscribeQuote \n"
        <<"--->4 : unSubscribeQuote \n"
        <<"--->5 : exit\n"
        <<"--->H : help\n"
        <<"----------------------------------\n"
        <<endl;
}

int Quote::q_login()
{
    TAPIINT32 iErr = TAPIERROR_SUCCEED;
    std::string value;
    Config configSettings(ConfigFile);
    std::string quote_default_username = configSettings.Read("quote_default_username", value);
    std::string quote_default_password = configSettings.Read("quote_default_password", value);
    spdlog::info("quote_default_username: {}", quote_default_username);
    spdlog::info("quote_default_password: {}", quote_default_password);
    //登录服务器
    TapAPIQuoteLoginAuth stLoginAuth;
    memset(&stLoginAuth, 0, sizeof(stLoginAuth));
    strcpy(stLoginAuth.UserNo, quote_default_username.c_str());
    strcpy(stLoginAuth.Password, quote_default_password.c_str());
    stLoginAuth.ISModifyPassword = APIYNFLAG_NO;
    stLoginAuth.ISDDA = APIYNFLAG_NO;
    iErr = m_pAPI->Login(&stLoginAuth);
    if(TAPIERROR_SUCCEED != iErr) {
        spdlog::error("Quote Login Error: {}", iErr);
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

int Quote::q_qryContract(std::string ExchangeNo)
{
    m_uiSessionID = 0;
    TapAPICommodity com;
    memset(&com, 0, sizeof(com));
    if (ExchangeNo == "") {
        ExchangeNo = "COMEX";
    }
    strcpy(com.ExchangeNo, ExchangeNo.c_str());
//	strcpy(com.CommodityNo,QUOTE_DEFAULT_COMMODITY_NO);
	com.CommodityType =QUOTE_DEFAULT_COMMODITY_TYPE;
    m_pAPI->QryContract(&m_uiSessionID,&com);

}

int Quote::q_subscribeQuote(std::string ExchangeNo, std::string CommodityNo, std::string ContractNo)
{
    spdlog::info("*********************** q_subscribeQuote ******************");

    //订阅行情
    TapAPIContract stContract;
    memset(&stContract, 0, sizeof(stContract));
    strcpy(stContract.Commodity.ExchangeNo, ExchangeNo.c_str());
    stContract.Commodity.CommodityType = QUOTE_DEFAULT_COMMODITY_TYPE;
    strcpy(stContract.Commodity.CommodityNo, CommodityNo.c_str());
    strcpy(stContract.ContractNo1, ContractNo.c_str());
    stContract.CallOrPutFlag1 = TAPI_CALLPUT_FLAG_NONE;
    stContract.CallOrPutFlag2 = TAPI_CALLPUT_FLAG_NONE;
    m_uiSessionID = 0;
    TAPIINT32 iErr = TAPIERROR_SUCCEED;
    iErr = m_pAPI->SubscribeQuote(&m_uiSessionID, &stContract);
    if(TAPIERROR_SUCCEED != iErr) {
        spdlog::error("SubscribeQuote Error: {}", iErr);
    }
    return iErr;
}

int Quote::q_unSubscribeQuote(std::string ExchangeNo, std::string CommodityNo, std::string ContractNo)
{
    // 取消行情订阅
    TapAPIContract sContract;
    memset(&sContract, 0, sizeof(sContract));
    strcpy(sContract.Commodity.ExchangeNo, ExchangeNo.c_str());
    sContract.Commodity.CommodityType = QUOTE_DEFAULT_COMMODITY_TYPE;
    strcpy(sContract.Commodity.CommodityNo, CommodityNo.c_str());
    strcpy(sContract.ContractNo1, ContractNo.c_str());
    sContract.CallOrPutFlag1 = TAPI_CALLPUT_FLAG_NONE;
    sContract.CallOrPutFlag2 = TAPI_CALLPUT_FLAG_NONE;
    m_uiSessionID = 0;
    TAPIINT32 iErr = TAPIERROR_SUCCEED;
    iErr = m_pAPI->UnSubscribeQuote(&m_uiSessionID, &sContract);
    if (TAPIERROR_SUCCEED != iErr) {
        spdlog::error("UnSubscribeQuote Error: {}", iErr);
    }
    return iErr;
}

int Quote::q_disConnect()
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




void TAP_CDECL Quote::OnRspLogin(TAPIINT32 errorCode, const TapAPIQuotLoginRspInfo *info)
{
	if(TAPIERROR_SUCCEED == errorCode) {
//		cout << "登录成功，等待API初始化..." << endl;
        spdlog::info("Log in successfully, wait for API initialization...");
		m_bIsAPIReady = true;

	} else {
//		cout << "登录失败，错误码:" << errorCode << endl;
        spdlog::error("Login failed, error code: {}", errorCode);
		m_Event.SignalEvent();	
	}
}

void TAP_CDECL Quote::OnAPIReady()
{
//	cout << "API初始化完成" << endl;
    spdlog::info("The API initialization is complete");
	m_Event.SignalEvent();	
}

void TAP_CDECL Quote::OnDisconnect(TAPIINT32 reasonCode)
{
//    cout << "API断开,断开原因:"<<reasonCode << endl;
    spdlog::error("API disconnect, disconnect reason: {}", reasonCode);
    if (reasonCode == 1 || reasonCode == 2 || reasonCode == 8 || reasonCode == 13) {
        this->m_reasonCode = reasonCode;
        m_bIsAPIReady = false;
        m_Event.SignalEvent();
    }
}

void TAP_CDECL Quote::OnRspQryCommodity(TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPIQuoteCommodityInfo *info)
{
	if(TAPIERROR_SUCCEED == errorCode)
	{
        spdlog::info("{} is called.",  __FUNCTION__);
        if (NULL != info) {
            spdlog::info("{} is called.",  __FUNCTION__);
            cout << "commodity:" << "{"
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
                 << "}" << endl;
        }

        if(isLast=='Y')
        {
            spdlog::info("{} is Last",  __FUNCTION__);
            return;
        }
    } else
    {
//        cout << "品种信息获取失败, 错误码: " << errorCode << endl;
        spdlog::error("commodities retrieval failed, errorCode: {}", errorCode);
    }
}

void TAP_CDECL Quote::OnRspQryContract(TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPIQuoteContractInfo *info)
{
	spdlog::info("{} is called.",  __FUNCTION__);

//	cout << "合约:" << info->Contract.Commodity.CommodityNo << info->Contract.ContractNo1 << endl;
    cout << "contract: " << "{"
            << "ExchangeNo:" << info->Contract.Commodity.ExchangeNo << ", "
            << "CommodityType:" << info->Contract.Commodity.CommodityType << ", "
            << "CommodityNo:" << info->Contract.Commodity.CommodityNo << ", "
            << "ContractNo1:" << info->Contract.ContractNo1 << ", "
//            << "StrikePrice1:" << info->Contract.StrikePrice1 << ", "
//            << "CallOrPutFlag1:" << info->Contract.CallOrPutFlag1 << ", "
//            << "ContractNo2:" << info->Contract.ContractNo2 << ", "
//            << "StrikePrice2:" << info->Contract.StrikePrice2 << ", "
//            << "ContractType:" << info->ContractType << ", "
//            << "QuoteUnderlyingContract:" << info->QuoteUnderlyingContract << ", "
//            << "ContractName:" << info->ContractName << ", "
//            << "ContractExpDate:" << info->ContractExpDate << ", "
//            << "LastTradeDate:" << info->LastTradeDate << ", "
//            << "FirstNoticeDate:" << info->FirstNoticeDate
            << "}" << endl;

    if(isLast=='Y')
    {
        spdlog::info("{} is last", __FUNCTION__);
        return ;
    }
}

void TAP_CDECL Quote::OnRspSubscribeQuote(TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPIQuoteWhole *info)
{
	if (TAPIERROR_SUCCEED == errorCode)
	{
//		cout << "行情订阅成功 " << endl;
        spdlog::info("Market Subscription Successfully ");
		if (NULL != info)
		{
//			cout << info->DateTimeStamp << " "
//				<< "ExchangeNo:" << info->Contract.Commodity.ExchangeNo << ", "
//				<< "CommodityType:" << info->Contract.Commodity.CommodityType << ", "
//				<< "CommodityNo:" << info->Contract.Commodity.CommodityNo << ", "
//				<< "ContractNo1:" << info->Contract.ContractNo1 << ", "
//				<< "QLastPrice(最新成交价):" << info->QLastPrice << ", "
//				<< "QLastQty(最新成交量)" << info->QLastQty << ", "
//				<< "QTotalQty(当日总成交量)" << info->QTotalQty << ", "
//                << "QBidPrice[0](买一价):" << info->QBidPrice[0] << ", "
//                << "QAskPrice[0]（卖一价）:" << info->QAskPrice[0] << ", "
//                << "QBidQty[0](买一量):" << info->QBidQty[0] << ", "
//                << "QAskQty[0]（卖一量）:" << info->QAskQty[0] << ", "
//                << "QPreClosingPrice(昨收盘价):" << info->QPreClosingPrice << ", "
//                << "QPositionQty(持仓量):" << info->QPositionQty << ", "
//                << "QChangeRate(涨幅):" << info->QChangeRate << ", "
//                << "QChangeValue(涨跌值):" << info->QChangeValue << ", "
//                << "QHighPrice(最高价):" << info->QHighPrice << ", "
//                << "QLowPrice(最低价):" << info->QLowPrice << ", "
//                << "QInsideQty(内盘量):" << info->QInsideQty << ", "
//                << "QOutsideQty(外盘量):" << info->QOutsideQty << ", "
//                << "QPreSettlePrice(昨结算价):" << info->QPreSettlePrice
//				<< endl;

            Json::Value jObject;
            std::string CommodityType(1, info->Contract.Commodity.CommodityType);
            std::string UnderlyContract_CommodityType(1, info->UnderlyContract.Commodity.CommodityType);
            std::string CallOrPutFlag1(1, info->Contract.CallOrPutFlag1);
            std::string UnderlyContract_CallOrPutFlag1(1, info->UnderlyContract.CallOrPutFlag1);
            std::string CallOrPutFlag2(1, info->Contract.CallOrPutFlag2);
            std::string UnderlyContract_CallOrPutFlag2(1, info->UnderlyContract.CallOrPutFlag2);
            jObject["ExchangeNo"] = info->Contract.Commodity.ExchangeNo;
            jObject["CommodityType"] = CommodityType;
            jObject["CommodityNo"] = info->Contract.Commodity.CommodityNo;
            jObject["ContractNo1"] = info->Contract.ContractNo1;
            jObject["StrikePrice1"] = info->Contract.StrikePrice1;
            jObject["CallOrPutFlag1"] = CallOrPutFlag1;
            jObject["ContractNo2"] = info->Contract.ContractNo2;
            jObject["StrikePrice2"] = info->Contract.StrikePrice2;
            jObject["CallOrPutFlag2"] = CallOrPutFlag2;
            jObject["CurrencyNo"] = info->CurrencyNo;
            jObject["TradingState"] = info->TradingState;
            jObject["DateTimeStamp"] = info->DateTimeStamp;
            jObject["QPreClosingPrice"] = info->QPreClosingPrice;
            jObject["QPreSettlePrice"] = info->QPreSettlePrice;
            jObject["QPrePositionQty"] = to_string(info->QPrePositionQty);
            jObject["QOpeningPrice"] = info->QOpeningPrice;
            jObject["QLastPrice"] = info->QLastPrice;
            jObject["QHighPrice"] = info->QHighPrice;
            jObject["QLowPrice"] = info->QLowPrice;
            jObject["QHisHighPrice"] = info->QHisHighPrice;
            jObject["QHisLowPrice"] = info->QHisLowPrice;
            jObject["QLimitUpPrice"] = info->QLimitUpPrice;
            jObject["QLimitDownPrice"] = info->QLimitDownPrice;
            jObject["QTotalQty"] = to_string(info->QTotalQty);
            jObject["QTotalTurnover"] = info->QTotalTurnover;
            jObject["QPositionQty"] = to_string(info->QPositionQty);
            jObject["QAveragePrice"] = info->QAveragePrice;
            jObject["QClosingPrice"] = info->QClosingPrice;
            jObject["QSettlePrice"] = info->QSettlePrice;
            jObject["QLastQty"] = to_string(info->QLastQty);
            std::string QBidPrice = to_string(info->QBidPrice[0]) + "," + to_string(info->QBidPrice[1]) + "," +
                    to_string(info->QBidPrice[2]) + "," + to_string(info->QBidPrice[3]) + "," +
                    to_string(info->QBidPrice[4]) +  "," + to_string(info->QBidPrice[5]);
            std::string QBidQty = to_string(info->QBidQty[0]) + "," + to_string(info->QBidQty[1]) + "," +
                                    to_string(info->QBidQty[2]) + "," + to_string(info->QBidQty[3]) + "," +
                                    to_string(info->QBidQty[4]) +  "," + to_string(info->QBidQty[5]);
            std::string QAskPrice = to_string(info->QAskPrice[0]) + "," + to_string(info->QAskPrice[1]) + "," +
                                    to_string(info->QAskPrice[2]) + "," + to_string(info->QAskPrice[3]) + "," +
                                    to_string(info->QAskPrice[4]) +  "," + to_string(info->QAskPrice[5]);
            std::string QAskQty = to_string(info->QAskQty[0]) + "," + to_string(info->QAskQty[1]) + "," +
                                    to_string(info->QAskQty[2]) + "," + to_string(info->QAskQty[3]) + "," +
                                    to_string(info->QAskQty[4]) +  "," + to_string(info->QAskQty[5]);
            jObject["QBidPrice"] = QBidPrice;
            jObject["QBidQty"] = QBidQty;
            jObject["QAskPrice"] = QAskPrice;
            jObject["QAskQty"] = QAskQty;
            jObject["QImpliedBidPrice"] = info->QImpliedBidPrice;
            jObject["QImpliedBidQty"] = to_string(info->QImpliedBidQty);
            jObject["QImpliedAskPrice"] = info->QImpliedAskPrice;
            jObject["QImpliedAskQty"] = to_string(info->QImpliedAskQty);
            jObject["QPreDelta"] = info->QPreDelta;
            jObject["QCurrDelta"] = info->QCurrDelta;
            jObject["QInsideQty"] = to_string(info->QInsideQty);
            jObject["QOutsideQty"] = to_string(info->QOutsideQty);
            jObject["QTurnoverRate"] = info->QTurnoverRate;
            jObject["Q5DAvgQty"] = to_string(info->Q5DAvgQty);
            jObject["QPERatio"] = info->QPERatio;
            jObject["QTotalValue"] = info->QTotalValue;
            jObject["QNegotiableValue"] = info->QNegotiableValue;
            jObject["QPositionTrend"] = to_string(info->QPositionTrend);
            jObject["QChangeSpeed"] = info->QChangeSpeed;
            jObject["QChangeRate"] = info->QChangeRate;
            jObject["QChangeValue"] = info->QChangeValue;
            jObject["QSwing"] = info->QSwing;
            jObject["QTotalBidQty"] = to_string(info->QTotalBidQty);
            jObject["QTotalAskQty"] = to_string(info->QTotalAskQty);
            jObject["UnderlyContract_ExchangeNo"] = info->UnderlyContract.Commodity.ExchangeNo;
            jObject["UnderlyContract_CommodityType"] = UnderlyContract_CommodityType;
            jObject["UnderlyContract_CommodityNo"] = info->UnderlyContract.Commodity.CommodityNo;
            jObject["UnderlyContract_ContractNo1"] = info->UnderlyContract.ContractNo1;
            jObject["UnderlyContract_StrikePrice1"] = info->UnderlyContract.StrikePrice1;
            jObject["UnderlyContract_CallOrPutFlag1"] = UnderlyContract_CallOrPutFlag1;
            jObject["UnderlyContract_ContractNo2"] = info->UnderlyContract.ContractNo2;
            jObject["UnderlyContract_StrikePrice2"] = info->UnderlyContract.StrikePrice2;
            jObject["UnderlyContract_CallOrPutFlag2"] = UnderlyContract_CallOrPutFlag2;

            std::string str = jObject.toStyledString();
//            try {
//                m_redis->publish("TopicSubscribeQuoteWhole", str);
//            } catch (const sw::redis::Error &err) {
//                // other errors
//                spdlog::error("RedisError: {}", err.what());
//            }
            spdlog::info("TapAPIQuoteWhole: {}", str);

		}

	} else{
//		cout << "行情订阅失败，错误码：" << errorCode <<endl;
        spdlog::error("Quotation subscription failed, error code: {}", errorCode);
	}
}

void TAP_CDECL Quote::OnRspUnSubscribeQuote(TAPIUINT32 sessionID, TAPIINT32 errorCode, TAPIYNFLAG isLast, const TapAPIContract *info)
{
    if (TAPIERROR_SUCCEED == errorCode) {
        spdlog::info("{} is called.",  __FUNCTION__);
        cout << "Market UnSubscription Successfully " << endl;

        if (NULL != info)
        {
//            cout << "contract: " << "{"
//                 << "ExchangeNo:" << info->Commodity.ExchangeNo << ", "
//                 << "CommodityType:" << info->Commodity.CommodityType << ", "
//                 << "CommodityNo:" << info->Commodity.CommodityNo << ", "
//                 << "StrikePrice1:" << info->StrikePrice1 << ", "
//                 << "CallOrPutFlag1:" << info->CallOrPutFlag1 << ", "
//                 << "ContractNo2:" << info->ContractNo2 << ", "
//                 << "StrikePrice2:" << info->StrikePrice2 << ", "
//                 << "CallOrPutFlag2:" << info->CallOrPutFlag2
//                 << "}" << endl;

            Json::Value jObject;
            std::string CommodityType(1, info->Commodity.CommodityType);
            std::string CallOrPutFlag1(1, info->CallOrPutFlag1);
            std::string CallOrPutFlag2(1, info->CallOrPutFlag2);
            jObject["ExchangeNo"] = info->Commodity.ExchangeNo;
            jObject["CommodityType"] = CommodityType;
            jObject["CommodityNo"] = info->Commodity.CommodityNo;
            jObject["ContractNo1"] = info->ContractNo1;
            jObject["StrikePrice1"] = info->StrikePrice1;
            jObject["CallOrPutFlag1"] = CallOrPutFlag1;
            jObject["ContractNo2"] = info->ContractNo2;
            jObject["StrikePrice2"] = info->StrikePrice2;
            jObject["CallOrPutFlag2"] = CallOrPutFlag2;

            std::string str = jObject.toStyledString();
//            try {
//                m_redis->publish("TopicUnSubscribeQuoteWhole", str);
//            } catch (const sw::redis::Error &err) {
//                // other errors
//                spdlog::error("RedisError: {}", err.what());
//            }
            spdlog::info("OnRspUnSubscribeQuote: {}", str);
        }

    }else{
//        cout << "行情订阅取消失败，错误码：" << errorCode <<endl;
        spdlog::info("Quotation UnSubscription failed, error code: {}", errorCode);
    }
}

void TAP_CDECL Quote::OnRtnQuote(const TapAPIQuoteWhole *info)
{
	if (NULL != info)
	{
//		cout << "行情更新:"
//        cout << "An Quote to update:"
//            << info->DateTimeStamp << " "
//            << "ExchangeNo:" << info->Contract.Commodity.ExchangeNo << ", "
//            << "CommodityType:" << info->Contract.Commodity.CommodityType << ", "
//            << "CommodityNo:" << info->Contract.Commodity.CommodityNo << ", "
//            << "ContractNo1:" << info->Contract.ContractNo1 << ", "
//            << "QLastPrice:" << info->QLastPrice << ", "
//            << "QLastQty" << info->QLastQty << ","
//            << "QTotalQty" << info->QTotalQty << ", "
//            << "QBidPrice[0]:" << info->QBidPrice[0] << ", "
//            << "QAskPrice[0]:" << info->QAskPrice[0] << ", "
//            << "QBidQty[0]:" << info->QBidQty[0] << ", "
//            << "QAskQty[0]:" << info->QAskQty[0] << ", "
//            << "QPreClosingPrice:" << info->QPreClosingPrice << ", "
//            << "QPositionQty:" << info->QPositionQty << ", "
//            << "QChangeRate:" << info->QChangeRate << ", "
//            << "QChangeValue:" << info->QChangeValue << ", "
//            << "QHighPrice:" << info->QHighPrice << ", "
//            << "QLowPrice:" << info->QLowPrice << ", "
//            << "QInsideQty:" << info->QInsideQty << ", "
//            << "QOutsideQty:" << info->QOutsideQty << ", "
//            << "QOutsideQty:" << info->QPreSettlePrice
//            <<endl;
        Json::Value jObject;
        std::string CommodityType(1, info->Contract.Commodity.CommodityType);
        std::string UnderlyContract_CommodityType(1, info->UnderlyContract.Commodity.CommodityType);
        std::string CallOrPutFlag1(1, info->Contract.CallOrPutFlag1);
        std::string UnderlyContract_CallOrPutFlag1(1, info->UnderlyContract.CallOrPutFlag1);
        std::string CallOrPutFlag2(1, info->Contract.CallOrPutFlag2);
        std::string UnderlyContract_CallOrPutFlag2(1, info->UnderlyContract.CallOrPutFlag2);
        jObject["ExchangeNo"] = info->Contract.Commodity.ExchangeNo;
        jObject["CommodityType"] = CommodityType;
        jObject["CommodityNo"] = info->Contract.Commodity.CommodityNo;
        jObject["ContractNo1"] = info->Contract.ContractNo1;
        jObject["StrikePrice1"] = info->Contract.StrikePrice1;
        jObject["CallOrPutFlag1"] = CallOrPutFlag1;
        jObject["ContractNo2"] = info->Contract.ContractNo2;
        jObject["StrikePrice2"] = info->Contract.StrikePrice2;
        jObject["CallOrPutFlag2"] = CallOrPutFlag2;
        jObject["CurrencyNo"] = info->CurrencyNo;
        jObject["TradingState"] = info->TradingState;
        jObject["DateTimeStamp"] = info->DateTimeStamp;
        jObject["QPreClosingPrice"] = info->QPreClosingPrice;
        jObject["QPreSettlePrice"] = info->QPreSettlePrice;
        jObject["QPrePositionQty"] = to_string(info->QPrePositionQty);
        jObject["QOpeningPrice"] = info->QOpeningPrice;
        jObject["QLastPrice"] = info->QLastPrice;
        jObject["QHighPrice"] = info->QHighPrice;
        jObject["QLowPrice"] = info->QLowPrice;
        jObject["QHisHighPrice"] = info->QHisHighPrice;
        jObject["QHisLowPrice"] = info->QHisLowPrice;
        jObject["QLimitUpPrice"] = info->QLimitUpPrice;
        jObject["QLimitDownPrice"] = info->QLimitDownPrice;
        jObject["QTotalQty"] = to_string(info->QTotalQty);
        jObject["QTotalTurnover"] = info->QTotalTurnover;
        jObject["QPositionQty"] = to_string(info->QPositionQty);
        jObject["QAveragePrice"] = info->QAveragePrice;
        jObject["QClosingPrice"] = info->QClosingPrice;
        jObject["QSettlePrice"] = info->QSettlePrice;
        jObject["QLastQty"] = to_string(info->QLastQty);
        std::string QBidPrice = to_string(info->QBidPrice[0]) + "," + to_string(info->QBidPrice[1]) + "," +
                                to_string(info->QBidPrice[2]) + "," + to_string(info->QBidPrice[3]) + "," +
                                to_string(info->QBidPrice[4]) +  "," + to_string(info->QBidPrice[5]);
        std::string QBidQty = to_string(info->QBidQty[0]) + "," + to_string(info->QBidQty[1]) + "," +
                              to_string(info->QBidQty[2]) + "," + to_string(info->QBidQty[3]) + "," +
                              to_string(info->QBidQty[4]) +  "," + to_string(info->QBidQty[5]);
        std::string QAskPrice = to_string(info->QAskPrice[0]) + "," + to_string(info->QAskPrice[1]) + "," +
                                to_string(info->QAskPrice[2]) + "," + to_string(info->QAskPrice[3]) + "," +
                                to_string(info->QAskPrice[4]) +  "," + to_string(info->QAskPrice[5]);
        std::string QAskQty = to_string(info->QAskQty[0]) + "," + to_string(info->QAskQty[1]) + "," +
                              to_string(info->QAskQty[2]) + "," + to_string(info->QAskQty[3]) + "," +
                              to_string(info->QAskQty[4]) +  "," + to_string(info->QAskQty[5]);
        jObject["QBidPrice"] = QBidPrice;
        jObject["QBidQty"] = QBidQty;
        jObject["QAskPrice"] = QAskPrice;
        jObject["QAskQty"] = QAskQty;
        jObject["QImpliedBidPrice"] = info->QImpliedBidPrice;
        jObject["QImpliedBidQty"] = to_string(info->QImpliedBidQty);
        jObject["QImpliedAskPrice"] = info->QImpliedAskPrice;
        jObject["QImpliedAskQty"] = to_string(info->QImpliedAskQty);
        jObject["QPreDelta"] = info->QPreDelta;
        jObject["QCurrDelta"] = info->QCurrDelta;
        jObject["QInsideQty"] = to_string(info->QInsideQty);
        jObject["QOutsideQty"] = to_string(info->QOutsideQty);
        jObject["QTurnoverRate"] = info->QTurnoverRate;
        jObject["Q5DAvgQty"] = to_string(info->Q5DAvgQty);
        jObject["QPERatio"] = info->QPERatio;
        jObject["QTotalValue"] = info->QTotalValue;
        jObject["QNegotiableValue"] = info->QNegotiableValue;
        jObject["QPositionTrend"] = to_string(info->QPositionTrend);
        jObject["QChangeSpeed"] = info->QChangeSpeed;
        jObject["QChangeRate"] = info->QChangeRate;
        jObject["QChangeValue"] = info->QChangeValue;
        jObject["QSwing"] = info->QSwing;
        jObject["QTotalBidQty"] = to_string(info->QTotalBidQty);
        jObject["QTotalAskQty"] = to_string(info->QTotalAskQty);
        jObject["UnderlyContract_ExchangeNo"] = info->UnderlyContract.Commodity.ExchangeNo;
        jObject["UnderlyContract_CommodityType"] = UnderlyContract_CommodityType;
        jObject["UnderlyContract_CommodityNo"] = info->UnderlyContract.Commodity.CommodityNo;
        jObject["UnderlyContract_ContractNo1"] = info->UnderlyContract.ContractNo1;
        jObject["UnderlyContract_StrikePrice1"] = info->UnderlyContract.StrikePrice1;
        jObject["UnderlyContract_CallOrPutFlag1"] = UnderlyContract_CallOrPutFlag1;
        jObject["UnderlyContract_ContractNo2"] = info->UnderlyContract.ContractNo2;
        jObject["UnderlyContract_StrikePrice2"] = info->UnderlyContract.StrikePrice2;
        jObject["UnderlyContract_CallOrPutFlag2"] = UnderlyContract_CallOrPutFlag2;

        std::string str = jObject.toStyledString();
//        try {
//            m_redis->publish("TopicSubscribeQuoteWhole", str);
//        } catch (const sw::redis::Error &err) {
//            // other errors
//            spdlog::error("RedisError: {}", err.what());
//        }
        spdlog::info("An Quote to update: {}", str);
	}
}
