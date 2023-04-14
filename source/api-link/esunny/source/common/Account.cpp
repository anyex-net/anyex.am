//
// Created by root on 3/2/21.
//

#include "../../include/common/Account.h"
#include "cstring"

void Account::setUserNo(char* userNo) {
    std::strcpy(this->UserNo, userNo);
}

void Account::setPassword(char* password) {
    std::strcpy(this->Password, password);
}

std::string Account::getUserNo() const {
    return this->UserNo;
}

std::string Account::getPassword() const {
    return this->Password;
}