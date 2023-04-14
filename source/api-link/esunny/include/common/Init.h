//
// Created by root on 3/1/21.
//

#ifndef ESUNNY_INIT_H
#define ESUNNY_INIT_H

#endif //ESUNNY_INIT_H

#include "istream"
#include "../../include/tool/mysql/mysql.h"


namespace init
{
//    ITapQuoteAPI *pAPI;

    // ��ʼ����־
    void initLog();

    // ���� mysql ���ݿ�
    void connectToDatabase();

    // ��ʼ���������飬����������
    void initQoute();

    // ��ʼ���˻�
    void initAccounts();

    // ��ʼ�� redis++
    void initRedisPlusPlus();

    // ��ʼ��httpTrade
    void initHttpTrade(const char* host, int port);

    // ��ʼ��httpQuote
    void initHttpQuote(const char* host, int port);
}
