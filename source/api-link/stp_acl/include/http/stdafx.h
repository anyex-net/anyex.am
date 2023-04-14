// stdafx.h : 标准系统包含文件的包含文件，
// 或是常用但不常更改的项目特定的包含文件
//

#pragma once

// TODO: 在此处引用程序要求的附加头文件

//#include "acl_cpp/lib_acl.hpp"

#include <acl_cpp/stdlib/log.hpp>
#include <acl_cpp/http/HttpServletRequest.hpp>
#include <acl_cpp/http/HttpServletResponse.hpp>
#include <acl_cpp/stdlib/string.hpp>
#include <acl_cpp/stdlib/bitmap.hpp>
#include <acl_cpp/session/redis_session.hpp>
#include <acl_cpp/master/master_threads.hpp>
#include <acl_cpp/stream/server_socket.hpp>
#include <acl_cpp/session/memcache_session.hpp>
#include <acl_cpp/stream/socket_stream.hpp>
#include <acl_cpp/redis/redis_client.hpp>
#include <acl_cpp/redis/redis_client_cluster.hpp>
#include <acl_cpp/redis/redis_pubsub.hpp>
#include <acl_cpp/stdlib/json.hpp>

typedef acl::HttpServletRequest  HttpRequest;
typedef acl::HttpServletResponse HttpResponse;

// __cplusplus show c++ version as below:
// 199711L: c++98, 201103L: c++11, 201402L: c++14, 201703L: c++17

#if defined(__cplusplus) && __cplusplus >= 201103L
#include <functional>
#include <acl_cpp/master/master_conf.hpp>

typedef std::function<bool(HttpRequest&, HttpResponse&)> http_handler_t;
typedef std::function<bool(const char*, HttpRequest&, HttpResponse&)>
        http_default_handler_t;
#else
typedef bool (*http_handler_t)(HttpRequest&, HttpResponse&);
typedef bool (*http_default_handler_t)(const char*, HttpRequest&, HttpResponse&);
#endif

typedef std::map<acl::string, http_handler_t> http_handlers_t;

enum {
    http_handler_get = 0,
    http_handler_post,
    http_handler_head,
    http_handler_put,
    http_handler_patch,
    http_handler_connect,
    http_handler_purge,
    http_handler_delete,
    http_handler_options,
    http_handler_profind,
    http_handler_websocket,
    http_handler_error,
    http_handler_unknown,
    http_handler_max,
};


extern char *var_cfg_str;
extern acl::master_str_tbl var_conf_str_tab[];

extern int  var_cfg_bool;
extern acl::master_bool_tbl var_conf_bool_tab[];

extern acl::master_int_tbl var_conf_int_tab[];

extern long long int  var_cfg_int64;
extern acl::master_int64_tbl var_conf_int64_tab[];
