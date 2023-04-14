//
// Created by root on 8/18/21.
//

#include <iostream>
#include <md/MdSpi.h>
#include <common/InitParams.h>
#include <common/StpUtil.h>
#include <thread>
#include <stdlib/acl_argv.h>
#include <json/acl_json.h>

static char *TOPIC_MARKET_DATA = "StpTopicMarketData";
//extern char *md_list;

MdSpi::MdSpi(CTORATstpXMdApi *api,std::shared_ptr<Account> account)
:m_pMdApi(api),m_pAccount(account){}

MdSpi::~MdSpi() {}

void MdSpi::MdThreadReConnFn() {
    if (m_pMdApi == NULL) return;
    // 开始登录
    CTORATstpReqUserLoginField loginReq;
    memset(&loginReq, 0, sizeof(loginReq));
//    strcpy(loginReq.LogInAccount, "");
//    strcpy(loginReq.Password, "");
//    loginReq.LogInAccountType = TORA_TSTP_LACT_UserID;
    // 一级机构代码（以资金账号方式登录时必填）
//    strcpy(loginReq.DepartmentID, "");

    static int requestID = 0; // 请求编号
    int rt = m_pMdApi->ReqUserLogin(&loginReq, ++requestID);
    if (!rt)
        logger(">>>>>>发送登录请求成功");
    else
        logger_error(">>>>>>发送登录请求失败");
}

void MdSpi::OnFrontConnected() {
    logger("网络连接成功");
    std::thread thread(&MdSpi::MdThreadReConnFn, this);
    thread.detach();
}

void MdSpi::OnFrontDisconnected(int nReason) {
    logger("网络连接断开, nReason=%d", nReason);
}

void MdSpi::OnRspGetConnectionInfo(CTORATstpConnectionInfoField *pConnectionInfoField, CTORATstpRspInfoField *pRspInfo,
                                   int nRequestID) {
    std::cout << __FUNCTION__ << std::endl;
}

void MdSpi::OnRspUserLogin(CTORATstpRspUserLoginField *pRspUserLogin, CTORATstpRspInfoField *pRspInfo, int nRequestID) {
    if (!isErrorRspInfo(pRspInfo)) {
        logger("登录成功");
        logger("交易日:%s, 登录时间:%s, 用户代码:%s, 用户类型:%c, 登录账户:%s", pRspUserLogin->TradingDay,
               pRspUserLogin->LoginTime, pRspUserLogin->UserID, pRspUserLogin->UserType,pRspUserLogin->LogInAccount);
        m_pLoginUserField = *pRspUserLogin;
    }
}

int MdSpi::subscribeMarketData(const char *ppSecurityID,int nCount,const char *ExchangeID)
{
    char **pSecurityID = new char*[50];
    ACL_ARGV *argv = acl_argv_split(ppSecurityID, ",");
    ACL_ITER iter;  // 遍历指针
    // 遍历分割后的结果
    acl_foreach(iter, argv) {
        nCount = iter.size;
        // 从遍历指针中取出字符串型数据
        char *iter_ptr = (char *) iter.data;
        pSecurityID[iter.i] = iter_ptr;
    }
    int rt = m_pMdApi->SubscribeMarketData(pSecurityID, nCount, ExchangeID[0]);
    if(rt == 0) {
        logger(">>>>>>发送行情订阅请求成功");
    } else if(rt == -1) {
        logger_error(">>>>>>网络连接失败");
    } else if(rt == -2) {
        logger_error(">>>>>>未处理请求超过许可数");
    } else if(rt == -3) {
        logger_error(">>>>>>每秒发送请求数超过许可数");
    }
    // 释放内存
    acl_argv_free(argv);
    delete[] pSecurityID;
    return rt;
}

void MdSpi::OnRspSubMarketData(CTORATstpSpecificSecurityField *pSpecificSecurity, CTORATstpRspInfoField *pRspInfo) {

    if (pSpecificSecurity != NULL) {
        bool bResult = pRspInfo && (pRspInfo->ErrorID != 0);
        if (!bResult)
        {
//            std::cout << "行情订阅成功 " << pSpecificSecurity->SecurityID << pSpecificSecurity->ExchangeID << std::endl;
            logger("=====行情订阅成功=====");
            ACL_JSON* json = acl_json_alloc();
            std::string ExchangeID(1, pSpecificSecurity->ExchangeID);
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ExchangeID", ExchangeID.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "SecurityID", pSpecificSecurity->SecurityID));
            ACL_VSTRING *buf = acl_json_build(json, NULL);
            logger("%s", acl_vstring_str(buf));
            acl_vstring_free(buf);
            acl_json_free(json);
        }
        else
        {
            logger_error("=====行情订阅失败=====");
            ACL_JSON* json = acl_json_alloc();
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "ErrorID", pRspInfo->ErrorID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ErrorMsg", pRspInfo->ErrorMsg));
            ACL_VSTRING* buf = acl_json_build(json, NULL);
            char *outbuf = StpUtil::GB18030ToUTF8(acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
            logger_error("%s", outbuf);
            delete[] outbuf;
            acl_vstring_free(buf);
            acl_json_free(json);
        }
    } else {
        logger("行情为空");
    }
}

int MdSpi::unSubscribeMarketData(const char *ppSecurityID,int nCount,const char *ExchangeID)
{
    char **pSecurityID = new char*[50];
    ACL_ARGV *argv = acl_argv_split(ppSecurityID, ",");
    ACL_ITER iter;  // 遍历指针
    // 遍历分割后的结果
            acl_foreach(iter, argv) {
        nCount = iter.size;
        // 从遍历指针中取出字符串型数据
        char *iter_ptr = (char *) iter.data;
        pSecurityID[iter.i] = iter_ptr;
    }
    int rt = m_pMdApi->UnSubscribeMarketData(pSecurityID, nCount, ExchangeID[0]);
    if(rt == 0) {
        logger(">>>>>>发送退订行情请求成功");
    } else if(rt == -1) {
        logger_error(">>>>>>网络连接失败");
    } else if(rt == -2) {
        logger_error(">>>>>>未处理请求超过许可数");
    } else if(rt == -3) {
        logger_error(">>>>>>每秒发送请求数超过许可数");
    }
    // 释放内存
    acl_argv_free(argv);
    delete[] pSecurityID;
    return rt;
}

void MdSpi::OnRspUnSubMarketData(CTORATstpSpecificSecurityField *pSpecificSecurity, CTORATstpRspInfoField *pRspInfo) {
    if (pSpecificSecurity != NULL) {
        bool bResult = pRspInfo && (pRspInfo->ErrorID != 0);
        if (!bResult) {
            logger("=====取消订阅行情成功=====");
            ACL_JSON *json = acl_json_alloc();
            std::string ExchangeID(1, pSpecificSecurity->ExchangeID);
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ExchangeID", ExchangeID.c_str()));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "SecurityID", pSpecificSecurity->SecurityID));
            ACL_VSTRING *buf = acl_json_build(json, NULL);
            logger("%s", acl_vstring_str(buf));
            acl_vstring_free(buf);
            acl_json_free(json);
        } else {
            logger("=====取消订阅行情失败=====");
            ACL_JSON *json = acl_json_alloc();
            acl_json_node_add_child(json->root,
                                    acl_json_create_int64(json, "ErrorID", pRspInfo->ErrorID));
            acl_json_node_add_child(json->root,
                                    acl_json_create_text(json, "ErrorMsg", pRspInfo->ErrorMsg));
            ACL_VSTRING *buf = acl_json_build(json, NULL);
            char *outbuf = StpUtil::GB18030ToUTF8(acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
            logger("%s", outbuf);
            delete[] outbuf;
            acl_vstring_free(buf);
            acl_json_free(json);
        }
    } else {
        logger("取消订阅为空");
    }
}

void MdSpi::OnRtnMarketData(CTORATstpMarketDataField *pMarketDataField) 
{
    ACL_JSON* json = acl_json_alloc();
    std::string ExchangeID(1, pMarketDataField->ExchangeID);
    acl_json_node_add_child(json->root,
                            acl_json_create_text(json, "TradingDay", pMarketDataField->TradingDay));
    acl_json_node_add_child(json->root,
                            acl_json_create_text(json, "SecurityID", pMarketDataField->SecurityID));
    acl_json_node_add_child(json->root,
                            acl_json_create_text(json, "ExchangeID", ExchangeID.c_str()));
    acl_json_node_add_child(json->root,
                            acl_json_create_text(json, "SecurityName", pMarketDataField->SecurityName));
    acl_json_node_add_child(json->root,
                            acl_json_create_double(json, "PreClosePrice", pMarketDataField->PreClosePrice));
    acl_json_node_add_child(json->root,
                            acl_json_create_double(json, "OpenPrice", pMarketDataField->OpenPrice));
    acl_json_node_add_child(json->root,
                            acl_json_create_int64(json, "Volume", pMarketDataField->Volume));
    acl_json_node_add_child(json->root,
                            acl_json_create_double(json, "Turnover", pMarketDataField->Turnover));
    acl_json_node_add_child(json->root,
                            acl_json_create_int64(json, "TradingCount", pMarketDataField->TradingCount));
    acl_json_node_add_child(json->root,
                            acl_json_create_double(json, "LastPrice", pMarketDataField->LastPrice));
    acl_json_node_add_child(json->root,
                            acl_json_create_double(json, "HighestPrice", pMarketDataField->HighestPrice));
    acl_json_node_add_child(json->root,
                            acl_json_create_double(json, "LowestPrice", pMarketDataField->LowestPrice));
    acl_json_node_add_child(json->root,
                            acl_json_create_double(json, "BidPrice1", pMarketDataField->BidPrice1));
    acl_json_node_add_child(json->root,
                            acl_json_create_double(json, "AskPrice1", pMarketDataField->AskPrice1));
    acl_json_node_add_child(json->root,
                            acl_json_create_double(json, "UpperLimitPrice", pMarketDataField->UpperLimitPrice));
    acl_json_node_add_child(json->root,
                            acl_json_create_double(json, "LowerLimitPrice", pMarketDataField->LowerLimitPrice));
    acl_json_node_add_child(json->root,
                            acl_json_create_double(json, "PERatio1", pMarketDataField->PERatio1));
    acl_json_node_add_child(json->root,
                            acl_json_create_double(json, "PERatio2", pMarketDataField->PERatio2));
    acl_json_node_add_child(json->root,
                            acl_json_create_double(json, "PriceUpDown1", pMarketDataField->PriceUpDown1));
    acl_json_node_add_child(json->root,
                            acl_json_create_double(json, "PriceUpDown2", pMarketDataField->PriceUpDown2));
    acl_json_node_add_child(json->root,
                            acl_json_create_int64(json, "OpenInterest", pMarketDataField->OpenInterest));
    acl_json_node_add_child(json->root,
                            acl_json_create_int64(json, "BidVolume1", pMarketDataField->BidVolume1));
    acl_json_node_add_child(json->root,
                            acl_json_create_int64(json, "AskVolume1", pMarketDataField->AskVolume1));
    acl_json_node_add_child(json->root,
                            acl_json_create_int64(json, "BidVolume2", pMarketDataField->BidVolume2));
    acl_json_node_add_child(json->root,
                            acl_json_create_int64(json, "AskVolume2", pMarketDataField->AskVolume2));
    acl_json_node_add_child(json->root,
                            acl_json_create_int64(json, "BidVolume3", pMarketDataField->BidVolume3));
    acl_json_node_add_child(json->root,
                            acl_json_create_int64(json, "AskVolume3", pMarketDataField->AskVolume3));
    acl_json_node_add_child(json->root,
                            acl_json_create_int64(json, "BidVolume4", pMarketDataField->BidVolume4));
    acl_json_node_add_child(json->root,
                            acl_json_create_int64(json, "AskVolume4", pMarketDataField->AskVolume4));
    acl_json_node_add_child(json->root,
                            acl_json_create_int64(json, "BidVolume5", pMarketDataField->BidVolume5));
    acl_json_node_add_child(json->root,
                            acl_json_create_int64(json, "AskVolume5", pMarketDataField->AskVolume5));
    acl_json_node_add_child(json->root,
                            acl_json_create_double(json, "BidPrice2", pMarketDataField->BidPrice2));
    acl_json_node_add_child(json->root,
                            acl_json_create_double(json, "AskPrice2", pMarketDataField->AskPrice2));
    acl_json_node_add_child(json->root,
                            acl_json_create_double(json, "BidPrice3", pMarketDataField->BidPrice3));
    acl_json_node_add_child(json->root,
                            acl_json_create_double(json, "AskPrice3", pMarketDataField->AskPrice3));
    acl_json_node_add_child(json->root,
                            acl_json_create_double(json, "BidPrice4", pMarketDataField->BidPrice4));
    acl_json_node_add_child(json->root,
                            acl_json_create_double(json, "AskPrice4", pMarketDataField->AskPrice4));
    acl_json_node_add_child(json->root,
                            acl_json_create_double(json, "BidPrice5", pMarketDataField->BidPrice5));
    acl_json_node_add_child(json->root,
                            acl_json_create_double(json, "AskPrice5", pMarketDataField->AskPrice5));
    acl_json_node_add_child(json->root,
                            acl_json_create_text(json, "UpdateTime", pMarketDataField->UpdateTime));
    acl_json_node_add_child(json->root,
                            acl_json_create_int64(json, "UpdateMillisec", pMarketDataField->UpdateMillisec));
    acl_json_node_add_child(json->root,
                            acl_json_create_double(json, "ClosePrice", pMarketDataField->ClosePrice));
    std::string MDSecurityStat(1, pMarketDataField->MDSecurityStat);
    acl_json_node_add_child(json->root,
                            acl_json_create_text(json, "MDSecurityStat", MDSecurityStat.c_str()));
    acl_json_node_add_child(json->root,
                            acl_json_create_int64(json, "HWFlag", pMarketDataField->HWFlag));
    acl_json_node_add_child(json->root,
                            acl_json_create_double(json, "PreCloseIOPV", pMarketDataField->PreCloseIOPV));
    acl_json_node_add_child(json->root,
                            acl_json_create_double(json, "IOPV", pMarketDataField->IOPV));
    acl_json_node_add_child(json->root,
                            acl_json_create_double(json, "SettlementPrice", pMarketDataField->SettlementPrice));

    ACL_VSTRING* buf = acl_json_build(json, NULL);
    char *outbuf = StpUtil::GB18030ToUTF8(acl_vstring_str(buf), ACL_VSTRING_LEN(buf));
    logger_debug(DEBUG_TEST3, 2, "%s", outbuf);
    StpUtil::KafkaOrRedis(TOPIC_MARKET_DATA, outbuf, strlen(outbuf));
    delete[] outbuf;
    acl_vstring_free(buf);
    acl_json_free(json);
}

bool MdSpi::isErrorRspInfo(CTORATstpRspInfoField *pRspInfo)
{
    bool bResult = pRspInfo && (pRspInfo->ErrorID != 0);
    if (bResult) {
        char *err_buf = StpUtil::GB18030ToUTF8(pRspInfo->ErrorMsg, sizeof(pRspInfo->ErrorMsg));
        logger_error("ErrorID=%d, ErrorMsg=%s", pRspInfo->ErrorID, err_buf);
        delete[] err_buf;
    }
    return bResult;
}


void MdSpi::OnRspUserLogout(CTORATstpUserLogoutField *pUserLogoutField, CTORATstpRspInfoField *pRspInfoField,
                            int nRequestID) {
    
}

void MdSpi::OnRspSubPHMarketData(CTORATstpSpecificSecurityField *pSpecificSecurityField,
                                 CTORATstpRspInfoField *pRspInfoField) {
    
}

void MdSpi::OnRspUnSubPHMarketData(CTORATstpSpecificSecurityField *pSpecificSecurityField,
                                   CTORATstpRspInfoField *pRspInfoField) {
    
}

void MdSpi::OnRspSubSpecialMarketData(CTORATstpSpecificSecurityField *pSpecificSecurityField,
                                      CTORATstpRspInfoField *pRspInfoField) {
    
}

void MdSpi::OnRspUnSubSpecialMarketData(CTORATstpSpecificSecurityField *pSpecificSecurityField,
                                        CTORATstpRspInfoField *pRspInfoField) {
    
}

void MdSpi::OnRspSubSimplifyMarketData(CTORATstpSpecificSecurityField *pSpecificSecurityField,
                                       CTORATstpRspInfoField *pRspInfoField) {
    
}

void MdSpi::OnRspUnSubSimplifyMarketData(CTORATstpSpecificSecurityField *pSpecificSecurityField,
                                         CTORATstpRspInfoField *pRspInfoField) {
    
}

void MdSpi::OnRspSubSecurityStatus(CTORATstpSpecificSecurityField *pSpecificSecurityField,
                                   CTORATstpRspInfoField *pRspInfoField) {
    
}

void MdSpi::OnRspUnSubSecurityStatus(CTORATstpSpecificSecurityField *pSpecificSecurityField,
                                     CTORATstpRspInfoField *pRspInfoField) {
    
}

void
MdSpi::OnRspSubMarketStatus(CTORATstpSpecificMarketField *pSpecificMarketField, CTORATstpRspInfoField *pRspInfoField) {
    
}

void MdSpi::OnRspUnSubMarketStatus(CTORATstpSpecificMarketField *pSpecificMarketField,
                                   CTORATstpRspInfoField *pRspInfoField) {
    
}

void
MdSpi::OnRspSubImcParams(CTORATstpSpecificMarketField *pSpecificMarketField, CTORATstpRspInfoField *pRspInfoField) {
    
}

void
MdSpi::OnRspUnSubImcParams(CTORATstpSpecificMarketField *pSpecificMarketField, CTORATstpRspInfoField *pRspInfoField) {
    
}

void
MdSpi::OnRspInquiryMarketDataMirror(CTORATstpMarketDataField *pMarketDataField, CTORATstpRspInfoField *pRspInfoField,
                                    int nRequestID, bool bIsLast) {
    
}

void MdSpi::OnRspInquiryPHMarketDataMirror(CTORATstpPHMarketDataField *pPHMarketDataField,
                                           CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast) {
    
}

void MdSpi::OnRspInquirySpecialMarketDataMirror(CTORATstpSpecialMarketDataField *pMarketDataField,
                                                CTORATstpRspInfoField *pRspInfoField, int nRequestID, bool bIsLast) {
    
}

void MdSpi::OnRspSubSPMarketData(CTORATstpSpecificSecurityField *pSpecificSecurityField,
                                 CTORATstpRspInfoField *pRspInfoField) {
    
}

void MdSpi::OnRspUnSubSPMarketData(CTORATstpSpecificSecurityField *pSpecificSecurityField,
                                   CTORATstpRspInfoField *pRspInfoField) {
    
}

void MdSpi::OnRspSubSPSimplifyMarketData(CTORATstpSpecificSecurityField *pSpecificSecurityField,
                                         CTORATstpRspInfoField *pRspInfoField) {
    
}

void MdSpi::OnRspUnSubSPSimplifyMarketData(CTORATstpSpecificSecurityField *pSpecificSecurityField,
                                           CTORATstpRspInfoField *pRspInfoField) {
    
}

void MdSpi::OnRspSubSPSecurityStatus(CTORATstpSpecificSecurityField *pSpecificSecurityField,
                                     CTORATstpRspInfoField *pRspInfoField) {
    
}

void MdSpi::OnRspUnSubSPSecurityStatus(CTORATstpSpecificSecurityField *pSpecificSecurityField,
                                       CTORATstpRspInfoField *pRspInfoField) {
    
}

void MdSpi::OnRspSubSPMarketStatus(CTORATstpSpecificMarketField *pSpecificMarketField,
                                   CTORATstpRspInfoField *pRspInfoField) {
    
}

void MdSpi::OnRspUnSubSPMarketStatus(CTORATstpSpecificMarketField *pSpecificMarketField,
                                     CTORATstpRspInfoField *pRspInfoField) {
    
}

void
MdSpi::OnRspInquirySPMarketDataMirror(CTORATstpMarketDataField *pMarketDataField, CTORATstpRspInfoField *pRspInfoField,
                                      int nRequestID, bool bIsLast) {
    
}

void MdSpi::OnRtnPHMarketData(CTORATstpPHMarketDataField *pPHMarketDataField) {
    
}

void MdSpi::OnRtnSpecialMarketData(CTORATstpSpecialMarketDataField *pSpecialMarketDataField) {
    
}

void MdSpi::OnRtnSimplifyMarketData(CTORATstpSimplifyMarketDataField *pSimplifyMarketDataField) {
    
}

void MdSpi::OnRtnSecurityStatus(CTORATstpSecurityStatusField *pSecurityStatusField) {
    
}

void MdSpi::OnRtnMarketStatus(CTORATstpMarketStatusField *pMarketStatusField) {
    
}

void MdSpi::OnRtnImcParams(CTORATstpImcParamsField *pImcParamsField) {
    
}

void MdSpi::OnRtnSPMarketData(CTORATstpMarketDataField *pMarketDataField) {
    
}

void MdSpi::OnRtnSPSimplifyMarketData(CTORATstpSimplifyMarketDataField *pSimplifyMarketDataField) {
    
}

void MdSpi::OnRtnSPSecurityStatus(CTORATstpSecurityStatusField *pSecurityStatusField) {
    
}

void MdSpi::OnRtnSPMarketStatus(CTORATstpMarketStatusField *pMarketStatusField) {
    
}

void MdSpi::OnRspSubRapidMarketData(CTORATstpSpecificSecurityField *pSpecificSecurityField,
                                    CTORATstpRspInfoField *pRspInfoField) {
    
}

void MdSpi::OnRspUnSubRapidMarketData(CTORATstpSpecificSecurityField *pSpecificSecurityField,
                                      CTORATstpRspInfoField *pRspInfoField) {
    
}

void MdSpi::OnRtnRapidMarketData(CTORATstpRapidMarketDataField *pRapidMarketDataField) {
    
}

void MdSpi::OnRspSubFundsFlowMarketData(CTORATstpSpecificSecurityField *pSpecificSecurityField,
                                        CTORATstpRspInfoField *pRspInfoField) {
    
}

void MdSpi::OnRspUnSubFundsFlowMarketData(CTORATstpSpecificSecurityField *pSpecificSecurityField,
                                          CTORATstpRspInfoField *pRspInfoField) {
    
}

void MdSpi::OnRtnFundsFlowMarketData(CTORATstpFundsFlowMarketDataField *pFundsFlowMarketDataField) {
    
}
