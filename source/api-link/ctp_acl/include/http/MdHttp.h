#pragma once
#define ACL_UNIX
#include "stdafx.h"
#include "../include/customSpi/CustomMdSpi.h"

class MdHttp {
public:
    MdHttp();
    ~MdHttp();

//    void SetMdSpi(CustomMdSpi *);
    void SetMdVector(std::vector<std::pair<const char *, CustomMdSpi *>> md);
    void start(const char* addrs);

private:
    static bool SubscribeMarketData(HttpRequest&, HttpResponse& res);
    static bool UnSubscribeMarketData(HttpRequest&, HttpResponse& res);
    static bool Logout(HttpRequest&, HttpResponse& res);

private:
//    static CustomMdSpi *sm_pMdSpi;
    static std::vector<std::pair<const char *, CustomMdSpi *>> sm_vMd;
};

