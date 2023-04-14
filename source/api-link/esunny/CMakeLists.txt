# ���cmake��Ͱ汾
CMAKE_MINIMUM_REQUIRED(VERSION 3.16)

SET(CMAKE_CXX_FLAGS "-w -Wextra -std=c++11 -ggdb -g -pthread -DLINUX2")

# ��Ŀ��
PROJECT(esunnyServer)

#�������ļ������../bin
SET(CMAKE_RUNTIME_OUTPUT_DIRECTORY ../bin
        CACHE PATH "Single directory for all executable.")

FILE(GLOB SRC source/common/*cpp source/json/*inl
        source/json/*.cpp source/quote/*cpp source/trade/*.cpp)
FILE(GLOB INCLUDE include/common/*.h include/json/*.h
        include/quote/*.h include/trade/*.h include/esunny/*.h)

# ͷ�ļ�Ŀ¼
INCLUDE_DIRECTORIES(
        include/tool
        include/spdlog
)

#��̬������Ŀ¼
LINK_DIRECTORIES(/usr/local/esunny/lib/redis++ /usr/local/esunny/lib/hiredis
        /usr/local/esunny/lib/mysql /usr/local/esunny/lib/esunny
        /usr/local/esunny/lib/gtest /usr/local/esunny/lib/acl)

ADD_SUBDIRECTORY(test)
ADD_EXECUTABLE(${PROJECT_NAME} source/main.cpp ${SRC} ${INCLUDE})

#����
TARGET_LINK_LIBRARIES(${PROJECT_NAME}
        crypto ssl TapQuoteAPI iTapTradeAPI
        mysqlclient redis++ hiredis
        acl_cpp protocol acl)