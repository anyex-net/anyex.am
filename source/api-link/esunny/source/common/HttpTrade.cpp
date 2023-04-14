//
// Created by root on 2/24/21.
//

#include "../../include/common/Http.h"

#include "../../include/trade/Trade.h"
#include "../../include/spdlog/spdlog.h"
#include <vector>

extern std::vector<std::pair<std::string, Trade *>> trade_vector;

Http::Http() {

}
Http::~Http() {
}

void Http::initTradeServer(const char* host, int port) {
    Server svr;
    svr.set_base_dir("/");

    svr.Get("/stop", [&](const Request& req, Response& res) {
        res.set_content("200", "text/html");
        svr.stop();
    });


    // GET
    // 查询所有品种信息   参数:AccountNo
    svr.Get("/QryCommodity", this->QryCommodity);

    // 查询所有币种信息   参数:AccountNo
    svr.Get("/QryCurrencyInfo", this->QryCurrencyInfo);

    // 查询所有交易所信息   参数:AccountNo
    svr.Get("/QryExchangeInfo", this->QryExchangeInfo);

    // 查询客户信息   参数:AccountNo
    svr.Get("/QryAccountInfo", this->QryAccountInfo);

    // 查询交易所合约信息 参数：AccountNo、ExchangeNo
    svr.Get("/QryExchangeContract", this->QryExchangeContract);

    // 查询客户资金 参数：AccountNo
    svr.Get("/QryFundData", this->QryFundData);

    // 查询账户持仓 参数：AccountNo
    svr.Get("/QryPositionInfo", this->QryPositionInfo);

    // 查询订单 参数：AccountNo
    svr.Get("/QryOrderInfo", this->QryOrderInfo);

    // 查询成交 参数：AccountNo
    svr.Get("/QryFillInfo", this->QryFillInfo);

    // 根据订单号查订单 参数：AccountNo, OrderNo
    svr.Get("/QryOrderInfoByOrderNo", this->QryOrderInfoByOrderNo);

    // 根据订单号查成交订单 参数：AccountNo, OrderNo
    svr.Get("/QryFillInfoByOrderNo", this->QryFillInfoByOrderNo);

    // POST
    // 下单   参数：AccountNo,ExchangeNo,CommodityNo,ContractNo,OrderType
    //            TimeInForce, OrderSide, OrderPrice, OrderQty
    svr.Post("/InsertOrder", this->InsertOrder);

    // 撤单   参数：AccountNo, OrderNo
    svr.Post("/CancelOrder", this->CancelOrder);

    svr.Get("/ConnectTrade", this->ConnectTrade);

    svr.Get("/DisConnectTrade", this->DisConnectTrade);


    if (svr.listen(host, port)) {
        std::cout << "http listen sucess!" << endl;
    } else {
        std::cout << "http listen failed!" << endl;
    }
}

void Http::QryCurrencyInfo(const Request &req, Response &res) {
    spdlog::info("QryCurrencyInfo");
    std::string AccountNo;

    bool param_flag = true;
    validateParameter(req, res, param_flag, "AccountNo", AccountNo);

    if (param_flag) {
        bool trade_vector_flag = true;
        for(auto v = trade_vector.begin(); v != trade_vector.end(); v++) {
            if (v->first == AccountNo) {
                Trade* t = (Trade*)v->second;
                int rt = t->t_qryCurrency();
                res.set_content(std::to_string(rt),"text/html");
                trade_vector_flag = true;
                break;
            }
        }
        if (!trade_vector_flag) {
            spdlog::error("AccountNo is invalid, The corresponding thread could not be found!, AccountNo={}", AccountNo);
            res.set_content("-19001", "text/html");
        }
    }
}

void Http::QryExchangeInfo(const Request &req, Response &res) {
    spdlog::info("QryExchangeInfo");
    std::string AccountNo;

    bool param_flag = true;
    validateParameter(req, res, param_flag, "AccountNo", AccountNo);

    if (param_flag) {
        bool trade_vector_flag = false;
        for (auto v = trade_vector.begin(); v != trade_vector.end(); v++) {
            if (v->first == AccountNo) {
                Trade *t = (Trade *) v->second;
                int rt = t->t_qryExchange();
                res.set_content(std::to_string(rt), "text/html");
                trade_vector_flag = true;
                break;
            }
        }
        if (!trade_vector_flag) {
            spdlog::error("AccountNo is invalid, The corresponding thread could not be found!, AccountNo={}", AccountNo);
            res.set_content("-19001", "text/html");
        }
    }
}



void Http::QryAccountInfo(const Request &req, Response &res) {
    spdlog::info("QryAccountInfo");
    std::string AccountNo;

    bool param_flag = true;
    validateParameter(req, res, param_flag, "AccountNo", AccountNo);

    if (param_flag) {
        bool trade_vector_flag = false;
        for(auto v = trade_vector.begin(); v != trade_vector.end(); v++) {
            if (v->first == AccountNo) {
                Trade* trade = (Trade*)v->second;
                int rt = trade->t_qryAccount();
                res.set_content(std::to_string(rt),"text/html");
                trade_vector_flag = true;
                break;
            }
        }
        if (!trade_vector_flag) {
            spdlog::error("AccountNo is invalid, The corresponding thread could not be found!, AccountNo={}", AccountNo);
            res.set_content("-19001","text/html");
        }
    }
}

void Http::QryCommodity(const Request &req, Response &res) {
    spdlog::info("QryCommodity");
    std::string AccountNo;

    bool param_flag = true;
    validateParameter(req, res, param_flag, "AccountNo", AccountNo);

    if (param_flag) {
        bool trade_vector_flag = false;
        for(auto v = trade_vector.begin(); v != trade_vector.end(); v++) {
            if (v->first == AccountNo) {
                Trade* t = (Trade*)v->second;
                int rt = t->t_qryCommodity();
                res.set_content(std::to_string(rt),"text/html");
                trade_vector_flag = true;
                break;
            }
        }
        if (!trade_vector_flag) {
            spdlog::error("AccountNo is invalid, The corresponding thread could not be found!, AccountNo={}", AccountNo);
            res.set_content("-19001","text/html");
        }
    }
}

void Http::QryExchangeContract(const Request &req, Response &res) {

    spdlog::info("QryExchangeContract");
    std::string AccountNo, ExchangeNo;

    bool param_flag = true;
    validateParameter(req, res, param_flag, "AccountNo", AccountNo);
    validateParameter(req, res, param_flag, "ExchangeNo", ExchangeNo);

    if (param_flag) {
        bool trade_vector_flag = false;
        for(auto v = trade_vector.begin(); v != trade_vector.end(); v++) {
            if (v->first == AccountNo) {
                Trade* t = (Trade*)v->second;
                int rt = t->t_qryContract(ExchangeNo);
                res.set_content(std::to_string(rt),"text/html");
                trade_vector_flag = true;
                break;
            }
        }
        if (!trade_vector_flag) {
            spdlog::error("AccountNo is invalid, The corresponding thread could not be found!, AccountNo={}", AccountNo);
            res.set_content("-19001","text/html");
        }
    }
}

void Http::QryFundData(const Request &req, Response &res) {
    spdlog::info("QryFundData");
    std::string AccountNo;

    bool param_flag = true;
    validateParameter(req, res, param_flag, "AccountNo", AccountNo);

    if (param_flag) {
        bool trade_vector_flag = false;
        for(auto v = trade_vector.begin(); v != trade_vector.end(); v++) {
            if (v->first == AccountNo) {
                Trade* t = (Trade*)v->second;
                int rt = t->t_qryFund(AccountNo);
                res.set_content(std::to_string(rt),"text/html");
                trade_vector_flag = true;
                break;
            }
        }
        if (!trade_vector_flag) {
            spdlog::error("AccountNo is invalid, The corresponding thread could not be found!, AccountNo={}", AccountNo);
            res.set_content("-19001","text/html");
        }
    }
}

void Http::QryPositionInfo(const Request &req, Response &res) {
    spdlog::info("QryPositionInfo");
    std::string AccountNo;

    bool param_flag = true;
    validateParameter(req, res, param_flag, "AccountNo", AccountNo);

    if (param_flag) {
        bool trade_vector_flag = false;
        for(auto v = trade_vector.begin(); v != trade_vector.end(); v++) {
            if (v->first == AccountNo) {
                Trade* t = (Trade*)v->second;
                int rt = t->t_qryPosition(AccountNo);
                res.set_content(std::to_string(rt),"text/html");
                trade_vector_flag = true;
                break;
            }
        }
        if (!trade_vector_flag) {
            spdlog::error("AccountNo is invalid, The corresponding thread could not be found!, AccountNo={}", AccountNo);
            res.set_content("-19001","text/html");
        }
    }
}

void Http::QryOrderInfo(const Request &req, Response &res) {
    spdlog::info("QryOrderInfo");
    std::string AccountNo;

    bool param_flag = true;
    validateParameter(req, res, param_flag, "AccountNo", AccountNo);

    if (param_flag) {
        bool trade_vector_flag = false;
        for(auto v = trade_vector.begin(); v != trade_vector.end(); v++) {
            if (v->first == AccountNo) {
                Trade* t = (Trade*)v->second;
                int rt = t->t_qryOrder(AccountNo);
                res.set_content(std::to_string(rt),"text/html");
                trade_vector_flag = true;
                break;
            }
        }
        if (!trade_vector_flag) {
            spdlog::error("AccountNo is invalid, The corresponding thread could not be found!, AccountNo={}", AccountNo);
            res.set_content("-19001","text/html");
        }
    }
}

void Http::QryFillInfo(const Request &req, Response &res) {
    spdlog::info("QryFillInfo");
    std::string AccountNo;
    
    bool param_flag = true;
    validateParameter(req, res, param_flag, "AccountNo", AccountNo);
    
    if (param_flag) {
        int trade_vector_flag = false;
        for(auto v = trade_vector.begin(); v != trade_vector.end(); v++) {
            if (v->first == AccountNo) {
                Trade* t = (Trade*)v->second;
                int rt = t->t_qryFill(AccountNo);
                res.set_content(std::to_string(rt),"text/html");
                trade_vector_flag = true;
                break;
            }
        }
        if (!trade_vector_flag) {
            spdlog::error("AccountNo is invalid, The corresponding thread could not be found!, AccountNo={}", AccountNo);
            res.set_content("-19001","text/html");
        }
    }
}

void Http::QryOrderInfoByOrderNo(const Request &req, Response &res) {
    spdlog::info("QryOrderInfo");
    std::string AccountNo, OrderNo;

    bool param_flag = true;
    validateParameter(req, res, param_flag, "AccountNo", AccountNo);
    validateParameter(req, res, param_flag, "OrderNo", OrderNo);
    if (param_flag) {
        int trade_vector_flag = false;
        for(auto v = trade_vector.begin(); v != trade_vector.end(); v++) {
            if (v->first == AccountNo) {
                Trade* t = (Trade*)v->second;
                int rt = t->t_qryOrderByOrderNo(AccountNo, OrderNo);
                res.set_content(std::to_string(rt),"text/html");
                trade_vector_flag = true;
                break;
            }
        }
        if (!trade_vector_flag) {
            spdlog::error("AccountNo is invalid, The corresponding thread could not be found!, AccountNo={}", AccountNo);
            res.set_content("-19001","text/html");
        }
    }


}

void Http::QryFillInfoByOrderNo(const Request &req, Response &res) {
    spdlog::info("QryFillInfo");
    std::string AccountNo, OrderNo;

    bool param_flag = true;
    validateParameter(req, res, param_flag, "AccountNo", AccountNo);
    validateParameter(req, res, param_flag, "OrderNo", OrderNo);

    if (param_flag) {
        int trade_vector_flag = false;
        for(auto v = trade_vector.begin(); v != trade_vector.end(); v++) {
            if (v->first == AccountNo) {
                Trade* t = (Trade*)v->second;
                int rt = t->t_qryFillByOrderNo(AccountNo, OrderNo);
                res.set_content(std::to_string(rt),"text/html");
                trade_vector_flag = true;
                break;
            }
        }
        if (!trade_vector_flag) {
            spdlog::error("AccountNo is invalid, The corresponding thread could not be found!, AccountNo={}", AccountNo);
            res.set_content("-19001","text/html");
            res.set_content("-19001","text/html");
        }
    }
}

void Http::InsertOrder(const Request &req, Response &res) {
    spdlog::info("InsertOrder");
    std::string AccountNo, ExchangeNo, CommodityNo, ContractNo, OrderType, TimeInForce;
    std::string OrderSide, OrderPrice, OrderQty;

    bool param_flag = true;
    validateParameter(req, res, param_flag, "AccountNo", AccountNo);
    validateParameter(req, res, param_flag, "ExchangeNo", ExchangeNo);
    validateParameter(req, res, param_flag, "CommodityNo", CommodityNo);
    validateParameter(req, res, param_flag, "ContractNo", ContractNo);
    validateParameter(req, res, param_flag, "OrderType", OrderType);
    validateParameter(req, res, param_flag, "TimeInForce", TimeInForce);
    validateParameter(req, res, param_flag, "OrderSide", OrderSide);
    validateParameter(req, res, param_flag, "OrderPrice", OrderPrice);
    validateParameter(req, res, param_flag, "OrderQty", OrderQty);

    if (param_flag) {
        int trade_vector_flag = false;
        for(auto v = trade_vector.begin(); v != trade_vector.end(); v++) {
            if (v->first == AccountNo) {
                Trade* t = (Trade*)v->second;
                int rt = t->t_insertOrder(AccountNo, ExchangeNo, CommodityNo, ContractNo, OrderType,
                        TimeInForce, OrderSide, OrderPrice, OrderQty);
                res.set_content(std::to_string(rt),"text/html");
                trade_vector_flag = true;
                break;
            }
        }
        if (!trade_vector_flag) {
            spdlog::error("AccountNo is invalid, The corresponding thread could not be found!, AccountNo={}", AccountNo);
            res.set_content("-19001","text/html");
        }
    }
}

void Http::CancelOrder(const Request &req, Response &res) {
    spdlog::info("CancelOrder");
    std::string AccountNo, OrderNo;

    bool param_flag = true;
    validateParameter(req, res, param_flag, "AccountNo", AccountNo);
    validateParameter(req, res, param_flag, "OrderNo", OrderNo);

    if (param_flag) {
        int trade_vector_flag = false;
        for(auto v = trade_vector.begin(); v != trade_vector.end(); v++) {
            if (v->first == AccountNo) {
                Trade* t = (Trade*)v->second;
                int rt = t->t_canncelOrder(OrderNo);
                res.set_content(std::to_string(rt),"text/html");
                trade_vector_flag = true;
                break;
            }
        }
        if (!trade_vector_flag) {
            spdlog::error("AccountNo is invalid, The corresponding thread could not be found!, AccountNo={}", AccountNo);
            res.set_content("-19001","text/html");
        }
    }
}

void Http::ConnectTrade(const Request &req, Response &res) {
    spdlog::info("Connect");
    std::string AccountNo;

    bool param_flag = true;
    validateParameter(req, res, param_flag, "AccountNo", AccountNo);

    if (param_flag) {
        int quote_vector_flag = false;
        for(auto v = trade_vector.begin(); v != trade_vector.end(); v++) {
            if (v->first == AccountNo) {
                Trade* t = (Trade*)v->second;
                int rt = t->t_login(AccountNo);
                std::cout << std::to_string(rt) << std::endl;
                res.set_content(std::to_string(rt),"text/html");
                quote_vector_flag = true;
                break;
            }
        }
        if (!quote_vector_flag) {
            spdlog::error("AccountNo is invalid, The corresponding thread could not be found!, AccountNo={}", AccountNo);
            res.set_content("-19001","text/html");
        }
    }
}

void Http::DisConnectTrade(const Request &req, Response &res) {
    spdlog::info("DisConnect");
    std::string AccountNo;

    bool param_flag = true;
    validateParameter(req, res, param_flag, "AccountNo", AccountNo);

    if (param_flag) {
        int quote_vector_flag = false;
        for(auto v = trade_vector.begin(); v != trade_vector.end(); v++) {
            if (v->first == AccountNo) {
                Trade* t = (Trade*)v->second;
                int rt = t->t_disConnect();
                std::cout << std::to_string(rt) << std::endl;
                res.set_content(std::to_string(rt),"text/html");
                quote_vector_flag = true;
                break;
            }
        }
        if (!quote_vector_flag) {
            spdlog::error("AccountNo is invalid, The corresponding thread could not be found!, AccountNo={}", AccountNo);
            res.set_content("-19001","text/html");
        }
    }
}

void Http::testHttp(const Request &req, Response &res) {
    printf("httplib server recv a req: %s\n ", req.path.c_str() );
    std::cout << "req.body=" << req.body << std::endl;
    for(auto k=req.headers.begin(); k!=req.headers.end(); k++) {
        std::cout << k->first << ":" << k->second;
    }


    std::cout << "\n\n*************** Http t_qryFund **************\n";

    std::string AccoutNo;
    if (req.has_param("id")) {
        AccoutNo = req.get_param_value("id");
        std::cout << AccoutNo << std::endl;
    }

    for(auto v = trade_vector.begin(); v != trade_vector.end(); v++) {
        if (v->first == AccoutNo) {
            Trade* t = (Trade*)v->second;
            t->t_qryFund(AccoutNo);
            sleep(1);
            t->t_qryAccount();
        }
    }

    res.set_content(" testHttp !",
                    "text/html");
    res.status = 200;
}



std::string Http::getParams(const Request &req, std::string key) {
    std::string value;
    if (req.has_param(key.c_str())) {
        value = req.get_param_value("AccountNo");
        std::cout << value << std::endl;
    }
    return value;
}

std::string Http::validateParameter(const Request &req, Response &res, bool &param_flag, std::string key, std::string &value) {
    if (req.has_header(key.c_str())) {
        value = req.get_header_value(key.c_str());
        spdlog::info("{}: {}", key, value);
    }else {
        param_flag = false;
        spdlog::error("{} is null", key);
        std::string message = key + " is null";
        res.set_content(message,
                        "text/html");
    }
    return value;
}
