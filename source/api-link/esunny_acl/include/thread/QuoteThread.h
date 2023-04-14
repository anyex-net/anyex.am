#pragma once

#include <acl_cpp/stdlib/thread.hpp>
#include <atomic>
#include "Quote.h"

class QuoteThread : public acl::thread{
public:
    QuoteThread();
    virtual ~QuoteThread();

    void interrupt();
    bool isInterrupted();

    ITapQuoteAPI *quoteAPI;
    Quote objQuote;
    TAPIINT32 iErr;
    acl::string AccountNo;

protected:
    virtual void init();
    virtual void* run();

private:
    std::atomic_bool isInterript{false};
};


