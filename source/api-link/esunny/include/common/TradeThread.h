//
// Created by root on 3/2/21.
//

#ifndef ESUNNYSERVER_TRADETHREAD_H
#define ESUNNYSERVER_TRADETHREAD_H


#include "Thread.h"
#include "../trade/Trade.h"

class TradeThread : public Thread {
public:
    TradeThread();
    virtual ~TradeThread();

    virtual void run() override;

    ITapTradeAPI *tradeApi;
    Trade objTrade;
    std::string AccountNo;
};


#endif //ESUNNYSERVER_TRADETHREAD_H
