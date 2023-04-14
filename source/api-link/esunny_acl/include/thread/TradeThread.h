#pragma once

#include <acl_cpp/stdlib/thread.hpp>
#include <acl_cpp/stdlib/string.hpp>
#include <atomic>
#include "Trade.h"

class TradeThread : public acl::thread {
public:
    TradeThread();
    ~TradeThread();

    void interrupt();
    bool isInterrupted();

    ITapTradeAPI *tradeApi;
    Trade objTrade;
    acl::string AccountNo;

protected:
    virtual void init();
    virtual void* run();

private:
    std::atomic_bool isInterript{false};
};
