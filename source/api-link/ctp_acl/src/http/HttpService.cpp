#include "HttpService.h"

static bool http_not_found(const char* path, HttpRequest& req, HttpResponse& res)
{
    bool keep = req.isKeepAlive();

    res.setStatus(404);
    acl::string buf  = "404 ";
    buf += path;
    buf += " not found\r\n";
    res.setContentLength(buf.size());
    return res.write(buf.c_str(), buf.size()) && keep;
}

HttpService::HttpService(void) : handler_default_(http_not_found) {}
HttpService::~HttpService(void) {}

HttpService& HttpService::Default(http_default_handler_t fn)
{
    handler_default_ = fn;
    return *this;
}

HttpService& HttpService::Get(const char* path, http_handler_t fn)
{
    Service(http_handler_get, path, fn);
    return *this;
}

HttpService& HttpService::Post(const char* path, http_handler_t fn)
{
    Service(http_handler_post, path, fn);
    return *this;
}

HttpService& HttpService::Head(const char* path, http_handler_t fn)
{
    Service(http_handler_head, path, fn);
    return *this;
}

HttpService& HttpService::Put(const char* path, http_handler_t fn)
{
    Service(http_handler_put, path, fn);
    return *this;
}

HttpService& HttpService::Patch(const char* path, http_handler_t fn)
{
    Service(http_handler_patch, path, fn);
    return *this;
}

HttpService& HttpService::Connect(const char* path, http_handler_t fn)
{
    Service(http_handler_connect, path, fn);
    return *this;
}

HttpService& HttpService::Purge(const char* path, http_handler_t fn)
{
    Service(http_handler_purge, path, fn);
    return *this;
}

HttpService& HttpService::Delete(const char* path, http_handler_t fn)
{
    Service(http_handler_delete, path, fn);
    return *this;
}

HttpService& HttpService::Options(const char* path, http_handler_t fn)
{
    Service(http_handler_options, path, fn);
    return *this;
}

HttpService& HttpService::Propfind(const char* path, http_handler_t fn)
{
    Service(http_handler_profind, path, fn);
    return *this;
}

HttpService& HttpService::Websocket(const char* path, http_handler_t fn)
{
    Service(http_handler_websocket, path, fn);
    return *this;
}

HttpService& HttpService::Unknown(const char* path, http_handler_t fn)
{
    Service(http_handler_unknown, path, fn);
    return *this;
}

HttpService& HttpService::Error(const char* path, http_handler_t fn)
{
    Service(http_handler_error, path, fn);
    return *this;
}

void HttpService::Service(int type, const char* path, http_handler_t fn)
{
    if (type >= http_handler_get && type < http_handler_max && path && *path) {
        // The path should lookup like as "/xxx/" with
        // lower charactors.

        acl::string buf(path);
        if (buf[buf.size() - 1] != '/') {
            buf += '/';
        }
        buf.lower();
        handlers_[type][buf] = fn;
    }
}

bool HttpService::doService(int type, HttpRequest& req, HttpResponse& res)
{
    if (type < http_handler_get || type >= http_handler_max) {
        logger_error("invalid type=%d", type);
        return false;
    }

    res.setKeepAlive(req.isKeepAlive());
    bool keep = req.isKeepAlive();
//    std::cout << "" << << std::endl;
    const char* path = req.getPathInfo();
    if (path == NULL || *path == 0) {
        res.setStatus(400);
        acl::string buf("400 bad request\r\n");
        res.setContentLength(buf.size());
        return res.write(buf.c_str(), buf.size()) && keep;
    }

    size_t len = strlen(path);
    acl::string buf(path);
    if (path[len - 1] != '/') {
        buf += '/';
    }
    buf.lower();

    std::map<acl::string, http_handler_t>::iterator it
            = handlers_[type].find(buf);

    if (it != handlers_[type].end()) {
        return it->second(req, res) && keep;
    }

    return handler_default_(buf, req, res) && keep;
}
