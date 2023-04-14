#pragma once
#include "stdafx.h"
class HttpService
{
public:
    HttpService(void);
    ~HttpService(void);

public:
    // Register all Http handlers with the http url path

    HttpService& Get(const char* path, http_handler_t fn);
    HttpService& Post(const char* path, http_handler_t fn);
    HttpService& Head(const char* path, http_handler_t fn);
    HttpService& Put(const char* path, http_handler_t fn);
    HttpService& Patch(const char* path, http_handler_t fn);
    HttpService& Connect(const char* path, http_handler_t fn);
    HttpService& Purge(const char* path, http_handler_t fn);
    HttpService& Delete(const char* path, http_handler_t fn);
    HttpService& Options(const char* path, http_handler_t fn);
    HttpService& Propfind(const char* path, http_handler_t fn);
    HttpService& Websocket(const char* path, http_handler_t fn);
    HttpService& Unknown(const char* path, http_handler_t fn);
    HttpService& Error(const char* path, http_handler_t fn);
    HttpService& Default(http_default_handler_t fn);

public:
    bool doService(int type, HttpRequest& req, HttpResponse& res);

public:
    http_handlers_t* get_handlers(void)
    {
        return handlers_;
    }

private:
    http_handlers_t handlers_[http_handler_max];
    http_default_handler_t  handler_default_;

    void Service(int type, const char* path, http_handler_t fn);
};
