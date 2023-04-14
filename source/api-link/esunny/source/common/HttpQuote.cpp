//
// Created by root on 3/9/21.
//

#include "../../include/common/Http.h"
#include "../../include/quote/Quote.h"
#include "../../include/spdlog/spdlog.h"
#include "string"

extern std::vector<std::pair<std::string, Quote *>> quote_vector;

void Http::initQuoteServer(const char* host, int port) {
    Server svr;
    svr.set_base_dir("/");

    // test
    svr.Get(R"(/numbers/(\d+))", this->testHttp);
    svr.Get("/get", this->testHttp);
    svr.Post("/post", this->testHttp);
    svr.Get("/stop", [&](const Request& req, Response& res) {
        svr.stop();
    });

    // quote
    // 订阅行情 参数: AccountNo, ExchangeNo, CommodityNo, ContractNo
    svr.Get("/SubscribeQuoteWhole", this->SubscribeQuote);

    // 取消订阅行情   参数: AccountNo, ExchangeNo, CommodityNo, ContractNo
    svr.Get("/UnSubscribeQuoteWhole", this->UnSubscribeQuote);

    svr.Get("/ConnectQuote", this->ConnectQuote);

    svr.Get("/DisConnectQuote", this->DisConnectQuote);

    if (svr.listen(host, port)) {
        std::cout << "http listen sucess!" << std::endl;
    } else {
        std::cout << "http listen failed!" << std::endl;
    }
}

void Http::SubscribeQuote(const Request &req, Response &res) {
    spdlog::info("SubscribeQuote");
    std::string AccountNo;
    std::string ExchangeNo;
    std::string CommodityNo;
    std::string ContractNo;

    bool param_flag = true;
    validateParameter(req, res, param_flag, "AccountNo", AccountNo);
    validateParameter(req, res, param_flag, "ExchangeNo", ExchangeNo);
    validateParameter(req, res, param_flag, "CommodityNo", CommodityNo);
    validateParameter(req, res, param_flag, "ContractNo", ContractNo);

    if (param_flag) {
        int quote_vector_flag = false;
        for(auto v = quote_vector.begin(); v != quote_vector.end(); v++) {
            spdlog::info("v->first= {}", v->first);
//            spdlog::info("v->second= {}", v->second);
            std::cout << "v->second=" << v->second << std::endl;
            if (v->first == AccountNo) {
                Quote* q = (Quote*)v->second;
                int rt = q->q_subscribeQuote(ExchangeNo, CommodityNo, ContractNo);
                spdlog::info("rt: {}", rt);
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

void Http::UnSubscribeQuote(const Request &req, Response &res) {
    spdlog::info("UnSubscribeQuote");
    std::string AccountNo;
    std::string ExchangeNo;
    std::string CommodityNo;
    std::string ContractNo;

    bool param_flag = true;
    validateParameter(req, res, param_flag, "AccountNo", AccountNo);
    validateParameter(req, res, param_flag, "ExchangeNo", ExchangeNo);
    validateParameter(req, res, param_flag, "CommodityNo", CommodityNo);
    validateParameter(req, res, param_flag, "ContractNo", ContractNo);

    if (param_flag) {
        int quote_vector_flag = false;
        for(auto v = quote_vector.begin(); v != quote_vector.end(); v++) {
            spdlog::info("v->first= {}", v->first);
            if (v->first == AccountNo) {
                Quote* q = (Quote*)v->second;
                int rt = q->q_unSubscribeQuote(ExchangeNo, CommodityNo, ContractNo);
                spdlog::info("rt: {}", rt);
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

void Http::ConnectQuote(const Request &req, Response &res) {
    spdlog::info("Connect");
    std::string AccountNo;

    bool param_flag = true;
    validateParameter(req, res, param_flag, "AccountNo", AccountNo);

    if (param_flag) {
        int quote_vector_flag = false;
        for(auto v = quote_vector.begin(); v != quote_vector.end(); v++) {
            spdlog::info("v->first= {}", v->first);
            if (v->first == AccountNo) {
                Quote* q = (Quote*)v->second;
                int rt = q->q_login();
                spdlog::info("rt: {}", rt);
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

void Http::DisConnectQuote(const Request &req, Response &res) {
    spdlog::info("DisConnect");
    std::string AccountNo;

    bool param_flag = true;
    validateParameter(req, res, param_flag, "AccountNo", AccountNo);

    if (param_flag) {
        int quote_vector_flag = false;
        for(auto v = quote_vector.begin(); v != quote_vector.end(); v++) {
            spdlog::info("v->first= {}", v->first);
            if (v->first == AccountNo) {
                Quote* q = (Quote*)v->second;
                int rt = q->q_disConnect();
                spdlog::info("rt: {}", rt);
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