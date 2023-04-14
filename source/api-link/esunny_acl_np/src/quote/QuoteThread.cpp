//
// Created by root on 4/9/21.
//

#include "quote/QuoteThread.h"
#include "common/InitParams.h"
#include "TapAPIError.h"
#include "cstring"
#include <chrono>
#include <thread>
#include <map>
#include "common/EsunnyUtil.h"

QuoteThread::QuoteThread():quoteAPI(NULL),iErr(0)
{
}

QuoteThread::~QuoteThread()
{
    logger("~QuoteThread");
    FreeTapQuoteAPI(this->quoteAPI);
    this->objQuote.m_Event.SignalEvent();
}

void QuoteThread::interrupt()
{
    this->isInterript = true;
}

bool QuoteThread::isInterrupted()
{
    return this->isInterript;
}

void QuoteThread::init()
{
    /// 初始化行情
    //取得API的版本信息
    logger("QuoteAPPIVersion: %s", GetTapQuoteAPIVersion());

    //创建API实例
    TAPIINT32 iResult = TAPIERROR_SUCCEED;
    TapAPIApplicationInfo stAppInfo;
    strcpy(stAppInfo.AuthCode, ACCOUNTS[this->AccountNo]->getAuthCode());
    std::string keyOperationLogPath = "logs/KeyOperationLog/";
    keyOperationLogPath.append(this->AccountNo.c_str());
    EsunnyUtil::CreateDirs(keyOperationLogPath);
    strcpy(stAppInfo.KeyOperationLogPath, keyOperationLogPath.c_str());
    quoteAPI = CreateTapQuoteAPI(&stAppInfo, iResult);
    if (NULL == quoteAPI) {
        logger_error("%s 创建API实例失败，错误码: %d", this->AccountNo.c_str(), iResult);
        return;
    }
    // 日志设置
    iErr = TAPIERROR_SUCCEED;
    std::string quoteAPIDataPath = "logs/TapQuoteAPILog/";
    quoteAPIDataPath.append(this->AccountNo.c_str());
    EsunnyUtil::CreateDirs(quoteAPIDataPath);
    iErr = SetTapQuoteAPIDataPath(quoteAPIDataPath.c_str());
    if (iErr != TAPIERROR_SUCCEED) {
        logger_error("%s SetTapQuoteAPIDataPath failed: %d", this->AccountNo.c_str(), iErr);
        return;
    }
    iErr = SetTapQuoteAPILogLevel(APILOGLEVEL_ERROR);
    if (iErr != TAPIERROR_SUCCEED) {
        logger_error("%s SetTapQuoteAPILogLevel failed: %d",this->AccountNo.c_str(), iErr);
        return;
    }
    //设定ITapQuoteAPINotify的实现类，用于异步消息的接收
    quoteAPI->SetAPINotify(&objQuote);
    objQuote.SetAPI(quoteAPI);
    objQuote.setAccount(ACCOUNTS[this->AccountNo]);
}

void* QuoteThread::run()
{
    while (!this->isInterrupted())
    {
        if (NULL == quoteAPI || iErr != 0) {
            logger_error("%s 初始化行情失败", this->AccountNo.c_str());
            this->interrupt();
        } else {
            if (objQuote.m_reasonCode != 0) {
                if ((objQuote.m_reasonCode == 1) || (objQuote.m_reasonCode == 13)) {
                    std::this_thread::sleep_for(std::chrono::seconds(1));
                } else if (objQuote.m_reasonCode == 8) {
                    std::this_thread::sleep_for(std::chrono::seconds(15));
                } else if (objQuote.m_reasonCode == 2) {
                    std::this_thread::sleep_for(std::chrono::minutes(3));
                } else {
                    std::this_thread::sleep_for(std::chrono::seconds(20));
                }
            }
            // 一直续连
            int rt = objQuote.RunQuote();
            if (rt != 0)
            {
                std::this_thread::sleep_for(std::chrono::seconds(1));
            }
        }
    }
    logger_error("%s quoteThread is exited", this->AccountNo.c_str());
}