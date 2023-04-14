//
// Created by root on 3/2/21.
//

#include "../../include/common/QuoteThread.h"
#include <iostream>
#include <spdlog.h>
#include "cstring"
#include "../../include/esunny/TapAPIError.h"
#include "../../include/common/config.h"

extern std::string ConfigFile;

QuoteThread::QuoteThread()
{
    /// 初始化行情
    //取得API的版本信息
    spdlog::info("QuoteAPPIVersion: {}", GetTapQuoteAPIVersion());

    std::string value;
    Config configSettings(ConfigFile);
    std::string quote_default_authCode = configSettings.Read("quote_default_authCode", value);
    spdlog::info("quote_default_authCode: {}", quote_default_authCode);

    //创建API实例
    TAPIINT32 iResult = TAPIERROR_SUCCEED;
    TapAPIApplicationInfo stAppInfo;
    strcpy(stAppInfo.AuthCode, quote_default_authCode.c_str());
    strcpy(stAppInfo.KeyOperationLogPath, "logs/KeyOperationLog");
    quoteAPI = CreateTapQuoteAPI(&stAppInfo, iResult);
    if (NULL == quoteAPI) {
        spdlog::error("创建API实例失败，错误码: {}", iResult);
        spdlog::error("Failed to create API instance, error code: {}", iResult);
    }
    // 日志设置
    TAPIINT32 iErr = TAPIERROR_SUCCEED;
    iErr = SetTapQuoteAPIDataPath("logs/TapQuoteAPILog");
    if (iErr != TAPIERROR_SUCCEED) {
        spdlog::error("SetTapQuoteAPIDataPath failed: {}", iErr);
    }
    iErr = SetTapQuoteAPILogLevel(APILOGLEVEL_ERROR);
    if (iErr != TAPIERROR_SUCCEED) {
        spdlog::error("SetTapQuoteAPILogLevel failed: {}", iErr);
    }

    //设定ITapQuoteAPINotify的实现类，用于异步消息的接收
    quoteAPI->SetAPINotify(&objQuote);
    //启动测试，订阅行情
    objQuote.SetAPI(quoteAPI);
}

QuoteThread::~QuoteThread()
{
}

void QuoteThread::run()
{
    while (!this->isInterrupted())
    {
        spdlog::info("TradeThread objTrade.m_reasonCode={}", objQuote.m_reasonCode);
        if ((objQuote.m_reasonCode == 1) ||
            (objQuote.m_reasonCode == 8) ||
            (objQuote.m_reasonCode == 13)) {
            std::this_thread::sleep_for(std::chrono::seconds(1));
        } else if (objQuote.m_reasonCode == 2) {
            std::this_thread::sleep_for(std::chrono::minutes(5));
        }
        objQuote.RunQuote();
    }
}
