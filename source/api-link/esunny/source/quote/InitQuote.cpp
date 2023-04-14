//
// Created by root on 3/6/21.
//
#include "../../include/quote/initQuote.h"

#include <iostream>
#include <vector>
#include "cstring"
#include <unistd.h>
#include <netdb.h>
#include <arpa/inet.h>

#include "../../include/esunny/TapQuoteAPI.h"
#include "../../include/esunny/TapAPIError.h"
#include "../../include/quote/Quote.h"
#include "../../include/quote/QuoteConfig.h"
#include "../../include/common/Init.h"
#include "../../include/common/config.h"
#include "../../include/spdlog/spdlog.h"
#include "../../include/common/QuoteThread.h"

std::vector<std::pair<std::string, Quote *>> quote_vector;
extern std::string ConfigFile;

bool GetIP(std::string& hostName, std::string& Ip) {
    char name[256];
    gethostname(name, sizeof(name));
    hostName = name;

    struct hostent* host = gethostbyname(name);
    char ipStr[32];
    const char* ret = inet_ntop(host->h_addrtype, host->h_addr_list[0], ipStr, sizeof(ipStr));
    if (NULL==ret) {
        spdlog::error("hostname transform to ip failed");
        return false;
    }
    Ip = ipStr;
    return true;
}

int initQuote::initQuoteProcess(){
    //取得API的版本信息
    spdlog::info("QuoteAPPIVersion: {}", GetTapQuoteAPIVersion());

    std::string value;
    Config configSettings(ConfigFile);
    int http_quote_port = configSettings.Read("http_quote_port", 0);
//    std::string quote_default_authCode = configSettings.Read("quote_default_authCode", value);
    std::string quote_default_username = configSettings.Read("quote_default_username", value);
//    spdlog::info("quote_default_username: {}", quote_default_username);
//    spdlog::info("http_quote_port: {}", http_quote_port);
//    spdlog::info("quote_default_authCode: {}", quote_default_authCode);
//    //创建API实例
//    TAPIINT32 iResult = TAPIERROR_SUCCEED;
//    TapAPIApplicationInfo stAppInfo;
//    strcpy(stAppInfo.AuthCode, quote_default_authCode.c_str());
//    strcpy(stAppInfo.KeyOperationLogPath, "logs/KeyOperationLog");
//    ITapQuoteAPI *pAPI = CreateTapQuoteAPI(&stAppInfo, iResult);
//    if (NULL == pAPI) {
//        spdlog::error("创建API实例失败，错误码: {}", iResult);
//        spdlog::error("Failed to create API instance, error code: {}", iResult);
//        return -1;
//    }
//    // 日志设置
//    TAPIINT32 iErr = TAPIERROR_SUCCEED;
//    iErr = SetTapQuoteAPIDataPath("logs/TapQuoteAPILog");
//    if (iErr != TAPIERROR_SUCCEED) {
//        spdlog::error("SetTapQuoteAPIDataPath failed: {}", iErr);
//        return -1;
//    }
//    iErr = SetTapQuoteAPILogLevel(APILOGLEVEL_ERROR);
//    if (iErr != TAPIERROR_SUCCEED) {
//        spdlog::error("SetTapQuoteAPILogLevel failed: {}", iErr);
//        return -1;
//    }
//
//    //设定ITapQuoteAPINotify的实现类，用于异步消息的接收
//    Quote objQuote;
//    pAPI->SetAPINotify(&objQuote);
//
//
//    //启动测试，订阅行情
//    objQuote.SetAPI(pAPI);
//    objQuote.RunQuote();

    QuoteThread quoteThread;
    quoteThread.start();
    quote_vector.push_back(std::make_pair(quote_default_username, &quoteThread.objQuote));

    std::string hostName;
    std::string IP;
    bool ret = GetIP(hostName, IP);
    if (true == ret) {
        spdlog::info("hostname: {}", hostName);
        spdlog::info("IP: {}", IP);
    } else {
        spdlog::info("failed");
    }

    init::initHttpQuote(IP.c_str(), http_quote_port);

}