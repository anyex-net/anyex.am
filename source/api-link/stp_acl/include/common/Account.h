#pragma once
#include <acl_cpp/stdlib/string.hpp>
#include "istream"

class Account {
public:
    Account() = default;
    Account(const Account&) = delete;
    Account& operator=(const Account&) = delete;

public:
    const std::string &getInvestorId() const;

    void setInvestorId(const std::string &investorId);

    const std::string &getUserId() const;

    void setUserId(const std::string &userId);

    const std::string &getAccountId() const;

    void setAccountId(const std::string &accountId);

    const std::string &getShareholderId() const;

    void setShareholderId(const std::string &shareholderId);

    const std::string &getPassword() const;

    void setPassword(const std::string &password);

    const std::string &getLoginInAccountType() const;

    void setLoginInAccountType(const std::string &loginInAccountType);

    const std::string &getDepartmentId() const;

    void setDepartmentId(const std::string &departmentId);

    std::string getMdFrontAddr();

    void setMdFrontAddr(const std::string &mdFrontAddr);

    std::string getTraderFrontAddr();

    void setTraderFrontAddr(const std::string &traderFrontId);

private:
    std::string InvestorID;  // 投资者代码
    std::string UserID;  // 用户代码
    std::string AccountID;  // 资金账号
    std::string ShareholderID;  // 股东账户代码
    std::string Password;
    std::string LoginInAccountType;  // 登录账户类型
    std::string DepartmentID;  // 一级机构代码（以资金账号方式登录时必填）
    std::string MdFrontAddr;
    std::string TraderFrontAddr;
};
