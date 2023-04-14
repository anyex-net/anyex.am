#pragma once

#define ACL_UNIX
#include "http/stdafx.h"

class QuoteHttp {
public:
    QuoteHttp();
    ~QuoteHttp();

    void start(const char* addrs);

private:
    static bool SubscribeQuoteWhole(HttpRequest&, HttpResponse& res);
    static bool UnSubscribeQuoteWhole(HttpRequest&, HttpResponse& res);
    static bool ConnectQuote(HttpRequest&, HttpResponse& res);
    static bool DisConnectQuote(HttpRequest&, HttpResponse& res);

//    static bool ValidateParameter(ACL_JSON *json, const char *tag, acl::string& value);
};

