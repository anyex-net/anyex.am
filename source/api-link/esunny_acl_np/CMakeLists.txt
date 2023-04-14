# 最低cmake最低版本
cmake_minimum_required(VERSION 3.16)

option(QUOTE_NAME "quote name" OFF)
option(TRADE_NAME "trade name" OFF)
# 项目名
if (QUOTE_NAME)
    project(esunnyServer_np_quote)
elseif(TRADE_NAME)
    project(esunnyServer_np_trade)
else()
    project(esunnyServer_np)
endif()

message(${PROJECT_SOURCE_DIR})
# 所有版本的可运行文件放在 bin目录下
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG ${PROJECT_SOURCE_DIR}/bin)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE ${PROJECT_SOURCE_DIR}/bin)
set(CMAKE_CXX_FLAGS_DEBUG  "-w -Wextra -std=c++11 -ggdb -g -pthread -DLINUX2")
set(CMAKE_CXX_FLAGS_RELEASE   "-w -Wextra -std=c++11 -pthread -DLINUX2")


# 头文件目录
set(include ${PROJECT_SOURCE_DIR}/include)
include_directories(
        ${include}
)
# 源文件
set(src ${PROJECT_SOURCE_DIR}/src)
set(sources
        ${src}/trade ${src}/quote ${src}/common ${src}/http)
foreach(iter ${sources})
    aux_source_directory(${iter} dir_src)
endforeach()



# 第三方头文件目录
set(quote_include ${PROJECT_SOURCE_DIR}/thirdparty/esunny/quote/v9.3.1.4)
set(trade_include ${PROJECT_SOURCE_DIR}/thirdparty/esunny/trade/v9.0.3.16)
set(acl_include ${PROJECT_SOURCE_DIR}/thirdparty/acl/lib_acl/include)
set(acl_cpp_include ${PROJECT_SOURCE_DIR}/thirdparty/acl/lib_acl_cpp/include)
set(libkafka_include ${PROJECT_SOURCE_DIR}/thirdparty/librdkafka)
include_directories(
        ${quote_include}
        ${trade_include}
        ${acl_include}
        ${acl_cpp_include}
        ${libkafka_include}
)
# 动态库链接目录
set(link_path /usr/local/esunny_np/lib)
set(lib_quote ${link_path}/esunny/quote/v9.3.1.4)
set(lib_trade ${link_path}/esunny/trade/v9.0.3.16)
set(lib_acl ${link_path}/acl)
set(lib_mysql ${link_path}/mysql)
set(lib_librdkafka ${link_path}/librdkafka)
link_directories(
        ${lib_quote}
        ${lib_trade}
        ${lib_acl}
        ${lib_mysql}
        ${lib_librdkafka}
)

# 生成可执行文件
add_executable(${PROJECT_NAME} ${PROJECT_SOURCE_DIR}/src/main.cpp ${dir_src})

# 链接
target_link_libraries(${PROJECT_NAME}
        TapQuoteAPI TapTradeAPI TapDataCollectAPI
        acl_cpp protocol acl
        mysqlclient_r
        rdkafka++ rdkafka
        )