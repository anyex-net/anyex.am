//
// Created by root on 5/10/21.
//

#include "../include/Account.h"


void Account::setBrokerID(const char* BrokerID) {
    this->BrokerID = BrokerID;
}

void Account::setInvesterID(const char* InvesterID) {
    this->InvesterID = InvesterID;
}

void Account::setInvesterPwd(const char* InvesterPwd) {
    this->InvesterPwd = InvesterPwd;
}

void Account::setAuthCode(const char* AuthCode) {
    this->AuthCode = AuthCode;
}

void Account::setAppId(const char *AppId) {
    this->AppId = AppId;
}

void Account::setFrontMdAddewss(const char *FrontMdAddress) {
    this->FrontMdAddress = FrontMdAddress;
}

void Account::setFrontTradeAddress(const char* FrontTradeAddress) {
    this->FrontTradeAddress = FrontTradeAddress;
}




const char* Account::getBrokerID() const {
    return this->BrokerID;
}

const char* Account::getInvesterID() const {
    return this->InvesterID;
}

const char* Account::getInvesterPwd() const {
    return this->InvesterPwd;
}
const char* Account::getAuthCode() const {
    return this->AuthCode;
}

const char* Account::getAppId() const {
    return this->AppId;
}

acl::string Account::getFrontMdAddress() {
    return this->FrontMdAddress;
}

acl::string Account::getFrontTradeAddress(){
    return this->FrontTradeAddress;
}
