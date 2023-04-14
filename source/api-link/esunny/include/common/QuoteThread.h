//
// Created by root on 3/2/21.
//

#ifndef ESUNNYSERVER_QUOTETHREAD_H
#define ESUNNYSERVER_QUOTETHREAD_H


#include "Thread.h"
#include "../quote/Quote.h"

class QuoteThread : public Thread{
public:
    QuoteThread();
    virtual ~QuoteThread();

    virtual void run() override;

    ITapQuoteAPI *quoteAPI;
    Quote objQuote;
};


#endif //ESUNNYSERVER_QUOTETHREAD_H
