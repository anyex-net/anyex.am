//
// Created by root on 3/2/21.
//

#ifndef ESUNNYSERVER_ACCOUNT_H
#define ESUNNYSERVER_ACCOUNT_H


#include "istream"

class Account {
public:
    Account() = default;
    Account(const Account&) = delete;
    Account& operator=(const Account&) = delete;
    void setUserNo(char* userNo);
    void setPassword(char* password);
    std::string getUserNo() const;
    std::string getPassword() const;

private:
    char UserNo[21];
    char Password[21];
};


#endif //ESUNNYSERVER_ACCOUNT_H
