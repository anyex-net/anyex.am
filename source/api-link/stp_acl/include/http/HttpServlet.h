#pragma once
#include <acl_cpp/http/HttpServlet.hpp>

class HttpService;

class HttpServlet : public acl::HttpServlet
{
public:
    HttpServlet(HttpService& service, acl::socket_stream* conn,
                 acl::session* session);
    ~HttpServlet(void);

protected:
    // @override
    bool doGet(HttpRequest& req, HttpResponse& res);

    // @override
    bool doPost(HttpRequest& req, HttpResponse& res);

    // @override
    bool doHead(HttpRequest& req, HttpResponse& res);

    // @override
    bool doPut(HttpRequest& req, HttpResponse& res);

    // @override
    bool doPatch(HttpRequest& req, HttpResponse& res);

    // @override
    bool doConnect(HttpRequest& req, HttpResponse& res);

    // @override
    bool doPurge(HttpRequest& req, HttpResponse& res);

    // @override
    bool doDelete(HttpRequest& req, HttpResponse& res);

    // @override
    bool doOptions(HttpRequest& req, HttpResponse& res);

    // @override
    bool doProfind(HttpRequest& req, HttpResponse& res);

    // @override
    bool doWebsocket(HttpRequest& req, HttpResponse& res);

    // @override
    bool doUnknown(HttpRequest& req, HttpResponse& res);

    // @override
    bool doError(HttpRequest& req, HttpResponse& res);

    // @override
    bool doOther(HttpRequest&, HttpResponse& res, const char* method);

private:
    HttpService& service_;

    bool doService(int type, HttpRequest& req, HttpResponse& res);
};
