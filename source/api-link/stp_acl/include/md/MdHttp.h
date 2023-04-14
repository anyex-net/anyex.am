#pragma once
#include <vector>
#include <http/stdafx.h>

#define ACL_UNIX

class MdHttp {
public:
    MdHttp();
    ~MdHttp();

//    void SetMdSpi(CustomMdSpi *);
    void setMdVector(std::vector<std::pair<const char *, MdSpi *>> md);
    void start(const char* addrs);

private:
    static bool SubscribeMarketData(HttpRequest&, HttpResponse& res);
    static bool UnSubscribeMarketData(HttpRequest&, HttpResponse& res);
    static bool Logout(HttpRequest&, HttpResponse& res);

private:
//    static CustomMdSpi *sm_pMdSpi;
    static std::vector<std::pair<const char *, MdSpi *>> sm_vMd;
};
