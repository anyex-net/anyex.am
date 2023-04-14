# 最低cmake最低版本
cmake_minimum_required(VERSION 3.16)

option(QUOTE_NAME "quote name" OFF)
option(TRADE_NAME "trade name" OFF)
# 项目名
if (QUOTE_NAME)
    project(esunnyServer-quote)
elseif(TRADE_NAME)
    project(esunnyServer-trade)
else()
    project(esunnyServer)
endif()

message(${PROJECT_SOURCE_DIR})
# 所有版本的可运行文件放在 bin目录下
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG ${PROJECT_SOURCE_DIR}/bin)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE ${PROJECT_SOURCE_DIR}/bin)
set(CMAKE_CXX_FLAGS_DEBUG  "-w -Wextra -std=c++11 -ggdb -g -pthread -DLINUX2")
set(CMAKE_CXX_FLAGS_RELEASE   "-w -Wextra -std=c++11 -pthread -DLINUX2")

# 头文件目录
set(common_include ${PROJECT_SOURCE_DIR}/include/common )
set(http_include ${PROJECT_SOURCE_DIR}/include/http)
set(quote_include ${PROJECT_SOURCE_DIR}/include/quote)
set(trade_include ${PROJECT_SOURCE_DIR}/include/trade)
set(thread_include ${PROJECT_SOURCE_DIR}/include/thread)
include_directories(
        ${common_include}
        ${http_include}
        ${quote_include}
        ${trade_include}
        ${thread_include}
)
#FILE(GLOB INCLUDE include/quote/*.h include/trade/*.h include/thread/*.h)
# 源文件
set(src ${PROJECT_SOURCE_DIR}/src)
set(sources
        ${src}/trade ${src}/quote ${src}/thread ${src}/common ${src}/http ${src}/common/utils)

foreach(iter ${sources})
    aux_source_directory(${iter} dir_src)
endforeach()

# 第三方头文件目录
include_directories(thirdparty/acl/lib_acl_cpp/include)
include_directories(thirdparty/acl/lib_acl/include)
include_directories(thirdparty/esunny/trade/v9.3.5.1)
include_directories(thirdparty/esunny/quote/v9.3.1.4)
include_directories(thirdparty/librdkafka)

# 动态库链接目录
link_directories(
        /usr/local/esunny/lib/esunny/trade/v9.3.5.1
        /usr/local/esunny/lib/esunny/quote/v9.3.1.4
        /usr/local/esunny/lib/acl
        /usr/local/esunny/lib/mysql
        /usr/local/esunny/lib/librdkafka
)

# 生成可执行文件
add_executable(${PROJECT_NAME} src/main.cpp ${dir_src})

# 链接
target_link_libraries(${PROJECT_NAME}
        crypto ssl TapQuoteAPI iTapTradeAPI
        acl_cpp protocol acl
        mysqlclient_r
        rdkafka++ rdkafka
)