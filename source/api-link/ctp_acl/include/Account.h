#pragma once
#include <acl_cpp/stdlib/string.hpp>

class Account {
public:
    Account() = default;
    Account(const Account&) = delete;
    Account& operator=(const Account&) = delete;
    void setBrokerID(const char* BrokerID);
    void setInvesterID(const char* BrokerID);
    void setInvesterPwd(const char* BrokerID);
    void setAuthCode(const char* AuthCode);
    void setAppId(const char *AppId);
    void setFrontMdAddewss(const char *FrontMdAddress);
    void setFrontTradeAddress(const char* FrontTradeAddress);
    const char* getBrokerID() const ;
    const char* getInvesterID() const ;
    const char* getInvesterPwd() const ;
    const char* getAuthCode() const;
    const char* getAppId() const;
    acl::string getFrontMdAddress();
    acl::string getFrontTradeAddress();

private:
    acl::string BrokerID;  // 模拟经纪商代码
    acl::string InvesterID;    // 投资者账户名
    acl::string InvesterPwd;  // 投资者密码
    acl::string AuthCode;   // 认证码
    acl::string AppId;  // App代码
    acl::string FrontTradeAddress;    // 交易前置机地址
    acl::string FrontMdAddress;    // 行情前置机地址
};

