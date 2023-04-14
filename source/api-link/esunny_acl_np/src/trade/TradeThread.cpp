//
// Created by root on 4/9/21.
//

#include "trade/TradeThread.h"
#include "common/InitParams.h"
#include <TapAPIError.h>
#include <thread>

TradeThread::TradeThread():tradeApi(NULL)
{
}

TradeThread::~TradeThread()
{
    logger("~TradeThread");
    FreeTapTradeAPI(this->tradeApi);
    this->objTrade.m_Event.SignalEvent();
}

void TradeThread::interrupt()
{
    this->isInterript = true;
}

bool TradeThread::isInterrupted()
{
    return this->isInterript;
}

void TradeThread::init()
{
    /// 初始化交易
    //取得API的版本信息
    logger("TradeApi的版本信息: %s", GetTapTradeAPIVersion());

    //创建API实例
    TAPIINT32 iResult = TAPIERROR_SUCCEED;
    TapAPIApplicationInfo tradeAppInfo;
    strcpy(tradeAppInfo.AuthCode, ACCOUNTS[this->AccountNo]->getAuthCode());
    // 关键操作日志路径 APIRun日志
    strcpy(tradeAppInfo.KeyOperationLogPath, "logs/TradeAPIRunLog");
    tradeApi = CreateTapTradeAPI(&tradeAppInfo, iResult);
    if (NULL == tradeApi){
        logger_error("%s 创建交易API实例失败，错误码: %d", this->AccountNo.c_str(), iResult);
    }
    // 设置API的回调接口对象
    tradeApi->SetAPINotify(&objTrade);
    // 设置对外功能接口
    objTrade.SetAPI(tradeApi);
    objTrade.setAccount(ACCOUNTS[this->AccountNo]);
}

void* TradeThread::run()
{
    while (!this->isInterrupted())
    {
        if (NULL == tradeApi) {
            logger_error("%s 初始化交易失败", this->AccountNo.c_str());
            this->interrupt();
        } else {
            if (objTrade.m_reasonCode != 0) {
                if (objTrade.m_reasonCode == 1) {
                    std::this_thread::sleep_for(std::chrono::seconds(1));
                } else if (objTrade.m_reasonCode == 8) {
                    std::this_thread::sleep_for(std::chrono::seconds(15));
                } else if (objTrade.m_reasonCode == 2) {
                    std::this_thread::sleep_for(std::chrono::minutes(3));
                } else {
                    std::this_thread::sleep_for(std::chrono::seconds(20));
                }
            }
            int rt = objTrade.RunTrade();
            if (rt != 0)
            {
                std::this_thread::sleep_for(std::chrono::seconds(1));
            }
        }
    }
    logger_error("%s tradeThread is exited", this->AccountNo.c_str());
}