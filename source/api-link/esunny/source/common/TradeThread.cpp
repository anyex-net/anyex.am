//
// Created by root on 3/2/21.
//

#include "../../include/common/TradeThread.h"
#include <iostream>
#include "../../include/trade/TradeConfig.h"
#include "../../include/esunny/iTapAPIError.h"
#include "../../include/spdlog/spdlog.h"

TradeThread::TradeThread()
{
    /// ��ʼ������
    //ȡ��API�İ汾��Ϣ
    cout << GetITapTradeAPIVersion() << endl;
    cout << "----------------------" << endl;

    //����APIʵ��
    TAPIINT32 iResult = TAPIERROR_SUCCEED;
    ITapTrade::TapAPIApplicationInfo tradeAppInfo;
    strcpy(tradeAppInfo.AuthCode, TRADE_DEFAULT_AUTHCODE);
    // �ؼ�������־·�� APIRun��־
    strcpy(tradeAppInfo.KeyOperationLogPath, "logs/TradeAPIRunLog");
    tradeApi = CreateITapTradeAPI(&tradeAppInfo, iResult);
    tradeAppInfo.LogLevel = APILOGLEVEL_NONE;
    tradeAppInfo.ReConnectCount = 0;
    tradeAppInfo.ReConnectSeconds = 0;
    if (NULL == tradeApi){
        cout << "��������APIʵ��ʧ�ܣ������룺" << iResult <<endl;
        cout << "Failed to create API instance, error code:" << iResult <<endl;
    }

    tradeApi->SetAPINotify(&objTrade);

    //�������ԣ��µ�
    objTrade.SetAPI(tradeApi);
//    objTrade.RunTest("RDGJ06");
}

TradeThread::~TradeThread()
{
    std::cout << "~TradeThread" << std::endl;
    FreeITapTradeAPI(this->tradeApi);
    this->objTrade.m_Event.SignalEvent();
}

void TradeThread::run()
{
    if (this->isInterrupted()) {
       spdlog::info("before");
        std::cout << "before run:" << this->isInterrupted() << std::endl;
    }

    while (!this->isInterrupted())
    {
        spdlog::info("TradeThread objTrade.m_reasonCode={}", objTrade.m_reasonCode);
        if (objTrade.m_reasonCode == 1 || objTrade.m_reasonCode == 8) {
            std::this_thread::sleep_for(std::chrono::seconds(1));
        } else if (objTrade.m_reasonCode == 2) {
            std::this_thread::sleep_for(std::chrono::minutes(5));
        }
        spdlog::info("TradeThread AccountNo={}", AccountNo);
        objTrade.RunTrade(AccountNo);
    }

    if (this->isInterrupted()) {
        spdlog::info("after");
        std::cout << "after run:" << this->isInterrupted() << std::endl;
    }
}
