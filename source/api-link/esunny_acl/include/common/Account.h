#pragma once
#include <acl_cpp/stdlib/string.hpp>
#include "istream"

class Account {
public:
    Account() = default;
    Account(const Account&) = delete;
    Account& operator=(const Account&) = delete;
    /// set
    void setAccountNo(const char* m_szAccountNo);
    void setPassword(const char* m_szPassword);
    void setAuthCode(const char* m_szAuthCode);
    void setIp(const char* m_szIp);
    void setPort(unsigned short m_szPort);

    // get
    const char* getAccountNo() const;
    const char* getPassword() const;
    const char* getAuthCode() const;
    const char* getIp() const;
    unsigned short getPort() const;


private:
    acl::string m_szAccountNo;
    acl::string m_szPassword;
    acl::string m_szAuthCode;
    acl::string m_szIp;
    unsigned short m_unPort;
};
