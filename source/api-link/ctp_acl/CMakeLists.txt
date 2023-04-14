# 最低cmake最低版本
cmake_minimum_required(VERSION 3.16)

option(STP "start ctp2stpServer" OFF)
option(OPENCTP "start openCtpServer" OFF)
# 项目名
if (STP)
    add_definitions(-DSTP)
    project(ctp2StpServer)
elseif(OPENCTP)
    add_definitions(-DOPENCTP)
    project(openCtpServer)
else()
    add_definitions(-DCTP)
    project(ctpServer)
endif()

message(${PROJECT_SOURCE_DIR})
# 所有版本的可运行文件放在 bin目录下
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG ${PROJECT_SOURCE_DIR}/bin)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE ${PROJECT_SOURCE_DIR}/bin)
set(CMAKE_CXX_FLAGS_DEBUG  "-w -Wextra -std=c++11 -ggdb -g -pthread -DLINUX2")
set(CMAKE_CXX_FLAGS_RELEASE   "-w -Wextra -std=c++11 -pthread -DLINUX2")

# 头文件目录
set(include ${PROJECT_SOURCE_DIR}/include)
set(spi_include ${PROJECT_SOURCE_DIR}/include/customSpi)
set(http_include ${PROJECT_SOURCE_DIR}/include/http)
set(utils_include ${PROJECT_SOURCE_DIR}/include/utils)
include_directories(
        ${include}
        ${spi_include}
        ${http_include}
        ${utils_include}
)

# 源文件
set(src ${CMAKE_CURRENT_SOURCE_DIR}/src)
set(sources
        ${src} ${src}/customSpi ${src}/http ${src}/utils)

foreach(iter ${sources})
    aux_source_directory(${iter} dir_src)
endforeach()

# 第三方头文件目录
include_directories(thirdparty/acl/lib_acl_cpp/include)
include_directories(thirdparty/acl/lib_acl/include)
include_directories(thirdparty/ctp/6.3.19)
include_directories(thirdparty/librdkafka)

# 动态库链接目录
link_directories(
        /usr/local/ctp/lib/acl
        /usr/local/ctp/lib/mysql
        /usr/local/ctp/lib/librdkafka
)
if (STP)
    link_directories(/usr/local/ctp/lib/stp/6.3.19)
elseif(OPENCTP)
    link_directories(/usr/local/ctp/lib/openctp/6.3.19)
else()
    message(ctp lib)
    link_directories(/usr/local/ctp/lib/ctp/6.3.19)
endif()

# 生成可执行文件
add_executable(${PROJECT_NAME} src/main.cpp ${dir_src})

# 链接
target_link_libraries(${PROJECT_NAME}
        acl_cpp protocol acl
        mysqlclient_r
        rdkafka++ rdkafka
        )
if (STP)
    target_link_libraries(${PROJECT_NAME} thostmduserapi_se thosttraderapi_se xfastmdapi fasttraderapi)
elseif(OPENCTP)
    target_link_libraries(${PROJECT_NAME} thostmduserapi_se thosttraderapi_se)
else()
    target_link_libraries(${PROJECT_NAME} thostmduserapi_se thosttraderapi_se)
endif()