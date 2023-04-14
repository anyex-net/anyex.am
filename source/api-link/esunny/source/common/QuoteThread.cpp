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
    /// ��ʼ������
    //ȡ��API�İ汾��Ϣ
    spdlog::info("QuoteAPPIVersion: {}", GetTapQuoteAPIVersion());

    std::string value;
    Config configSettings(ConfigFile);
    std::string quote_default_authCode = configSettings.Read("quote_default_authCode", value);
    spdlog::info("quote_default_authCode: {}", quote_default_authCode);

    //����APIʵ��
    TAPIINT32 iResult = TAPIERROR_SUCCEED;
    TapAPIApplicationInfo stAppInfo;
    strcpy(stAppInfo.AuthCode, quote_default_authCode.c_str());
    strcpy(stAppInfo.KeyOperationLogPath, "logs/KeyOperationLog");
    quoteAPI = CreateTapQuoteAPI(&stAppInfo, iResult);
    if (NULL == quoteAPI) {
        spdlog::error("����APIʵ��ʧ�ܣ�������: {}", iResult);
        spdlog::error("Failed to create API instance, error code: {}", iResult);
    }
    // ��־����
    TAPIINT32 iErr = TAPIERROR_SUCCEED;
    iErr = SetTapQuoteAPIDataPath("logs/TapQuoteAPILog");
    if (iErr != TAPIERROR_SUCCEED) {
        spdlog::error("SetTapQuoteAPIDataPath failed: {}", iErr);
    }
    iErr = SetTapQuoteAPILogLevel(APILOGLEVEL_ERROR);
    if (iErr != TAPIERROR_SUCCEED) {
        spdlog::error("SetTapQuoteAPILogLevel failed: {}", iErr);
    }

    //�趨ITapQuoteAPINotify��ʵ���࣬�����첽��Ϣ�Ľ���
    quoteAPI->SetAPINotify(&objQuote);
    //�������ԣ���������
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
