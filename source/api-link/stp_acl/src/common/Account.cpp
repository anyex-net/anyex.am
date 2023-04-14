//
// Created by root on 3/2/21.


#include "common/Account.h"

const std::string &Account::getInvestorId() const {
    return InvestorID;
}

void Account::setInvestorId(const std::string &investorId) {
    InvestorID = investorId;
}

const std::string &Account::getUserId() const {
    return UserID;
}

void Account::setUserId(const std::string &userId) {
    UserID = userId;
}

const std::string &Account::getAccountId() const {
    return AccountID;
}

void Account::setAccountId(const std::string &accountId) {
    AccountID = accountId;
}

const std::string &Account::getShareholderId() const {
    return ShareholderID;
}

void Account::setShareholderId(const std::string &shareholderId) {
    ShareholderID = shareholderId;
}

const std::string &Account::getPassword() const {
    return Password;
}

void Account::setPassword(const std::string &password) {
    Password = password;
}

const std::string &Account::getLoginInAccountType() const {
    return LoginInAccountType;
}

void Account::setLoginInAccountType(const std::string &loginInAccountType) {
    LoginInAccountType = loginInAccountType;
}

const std::string &Account::getDepartmentId() const {
    return DepartmentID;
}

void Account::setDepartmentId(const std::string &departmentId) {
    DepartmentID = departmentId;
}

std::string Account::getMdFrontAddr() {
    return MdFrontAddr;
}

void Account::setMdFrontAddr(const std::string &mdFrontAddr) {
    MdFrontAddr = mdFrontAddr;
}

std::string Account::getTraderFrontAddr() {
    return TraderFrontAddr;
}

void Account::setTraderFrontAddr(const std::string &traderFrontAddr) {
    TraderFrontAddr = traderFrontAddr;
}
