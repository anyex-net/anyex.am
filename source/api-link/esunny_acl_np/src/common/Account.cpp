//
// Created by root on 3/2/21.
//

#include "../../include/common/Account.h"

/// set
void Account::setAccountNo(const char* accountNo) {
    this->m_szAccountNo = accountNo;
}

void Account::setPassword(const char* password) {
    this->m_szPassword = password;
}

void Account::setAuthCode(const char* m_szAuthCode) {
    this->m_szAuthCode = m_szAuthCode;
}

void Account::setAppID(const char* m_szAppID) {
    this->m_szAppID = m_szAppID;
}

void Account::setIp(const char* m_szIp) {
    this->m_szIp = m_szIp;
}

void Account::setPort(unsigned short m_unPort) {
    this->m_unPort = m_unPort;
}

void Account::setQuoteIp(const char* m_szQuoteIp) {
    this->m_szQuoteIp = m_szQuoteIp;
}

void Account::setQuotePort(unsigned short m_unQuotePort) {
    this->m_unQuotePort = m_unQuotePort;
}


const char* Account::getAccountNo() const {
    return this->m_szAccountNo;
}

/// get
const char* Account::getPassword() const {
    return this->m_szPassword;
}

const char* Account::getAuthCode() const {
    return this->m_szAuthCode;
}

const char* Account::getAppID() const {
    return this->m_szAppID;
}

const char* Account::getIp() const {
    return this->m_szIp;
}

unsigned short Account::getPort() const {
    return this->m_unPort;
}

const char* Account::getQuoteIp() const {
    return this->m_szQuoteIp;
}

unsigned short Account::getQuotePort() const {
    return this->m_unQuotePort;
}

