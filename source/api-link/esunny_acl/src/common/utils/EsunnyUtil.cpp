//
// Created by root on 4/12/21.
//

#include "utils/EsunnyUtil.h"
#include <stdlib/acl_hash.h>
#include <sys/stat.h>
#include <iconv.h>

extern char *kafka_enable;
extern rd_kafka_t *rk;
extern acl::redis_pubsub redis_pubsub;

bool EsunnyUtil::GetHostInfo(acl::string& hostName, acl::string& Ip) {
    char name[256];
    gethostname(name, sizeof(name));
    hostName = name;

    struct hostent* host = gethostbyname(name);
    char ipStr[32];
    const char* ret = inet_ntop(host->h_addrtype, host->h_addr_list[0], ipStr, sizeof(ipStr));
    if (NULL==ret) {
        logger_error("hostname transform to ip failed");
        return false;
    }
    Ip = ipStr;
    return true;
}

bool EsunnyUtil::CreateDirs(const std::string& dirName)
{
    uint32_t beginCmpPath = 0;
    uint32_t endCmpPath = 0;

    std::string fullPath = "";

    if('/' != dirName[0])
    {
        fullPath = getcwd(nullptr, 0);
        beginCmpPath = fullPath.size();
        fullPath = fullPath + "/" + dirName;
        printf("current Path: %s\n", fullPath.c_str());
    }
    else
    {
        //Absolute path
        fullPath = dirName;
        beginCmpPath = 1;
    }

    if (fullPath[fullPath.size() - 1] != '/')
    {
        fullPath += "/";
    }

    endCmpPath = fullPath.size();

    //create dirs;
    for(uint32_t i = beginCmpPath; i < endCmpPath ; i++ )
    {
        if('/' == fullPath[i])
        {
            std::string curPath = fullPath.substr(0, i);
            if(access(curPath.c_str(), F_OK) != 0)
            {
                if(mkdir(curPath.c_str(), S_IRUSR|S_IRGRP|S_IROTH|S_IWUSR|S_IWGRP|S_IWOTH) == -1)
                {
                    logger_error("mkdir(%s) failed(%s)", curPath.c_str(), errno);
                    return false;
                }
            }
        }
    }

    return true;
}

bool isGBK(char* data, int len)  {
    int i  = 0;
    while (i < len)  {
        if (data[i] <= 0x7f) {
            //编码小于等于127,只有一个字节的编码，兼容ASCII
            i++;
            continue;
        } else {
            //大于127的使用双字节编码
            if  (data[i] >= 0x81 &&
                 data[i] <= 0xfe &&
                 data[i + 1] >= 0x40 &&
                 data[i + 1] <= 0xfe &&
                 data[i + 1] != 0xf7) {
                i += 2;
                continue;
            } else {
                return false;
            }
        }
    }
    return true;
}

char* EsunnyUtil::EsunnyConvert(char *value, size_t len) {
    /* 目的编码, TRANSLIT：遇到无法转换的字符就找相近字符替换
  *           IGNORE ：遇到无法转换字符跳过*/
    char *encTo = "UTF-8//IGNORE";
    /* 源编码 */
    char *encFrom = "GB18030";

    /* 存放转换后的字符串 */
    size_t outlen = len * 2;
    char *outbuf = new char[outlen];
//    char outbuf[outlen];
    memset(outbuf, 0, outlen);
    EsunnyUtil::CodeConvert(encFrom, encTo, value, len, outbuf, &outlen);
    return outbuf;
}

int EsunnyUtil::CodeConvert(char *fromCode, char *toCode, char *inbuf, size_t len, char *outbuf, size_t *outlen) {
    iconv_t cd = iconv_open(toCode, fromCode);

    if (cd == (iconv_t)-1)
    {
        logger_error("iconv_open");
        return -1;
    }

    /* 由于iconv()函数会修改指针，所以要保存源指针 */
    size_t inlen = len;
    char *tmpin = inbuf;
    char *tmpout = outbuf;

    /* 进行转换
     *@param cd iconv_open()产生的句柄
     *@param tmpin 需要转换的字符串
     *@param inlen 存放还有多少字符没有转换
     *@param tmpout 存放转换后的字符串
     *@param outlen 存放转换后,tempoutbuf剩余的空间
     *
     * */
//    iconv(cd, pin, &inlen, &outbuf, &outlen);
    if (iconv(cd, &tmpin, &inlen, &tmpout, outlen) == -1) {
        switch(errno)
        {
            case  E2BIG:
                logger_error("CodeConvert failed, E2BiG");
                break;
            case  EILSEQ:
                logger_error("CodeConvert failed, EILSEQ");
                break;
            case  EINVAL:
                logger_error("CodeConvert failed, EINVAL");
                break;
            default:
                logger("odeConvert failed, %s", errno);
        }
        iconv_close(cd);
        return -1;
    }

    iconv_close(cd);

    return 0;
}

void EsunnyUtil::KafkaOrRedis(const char *TOPIC_NAME, char *value, size_t len) {

    if (strcmp(kafka_enable, "true") == 0) {
        if (len == 0) {
            /*轮询用于事件的kafka handle，
            事件将导致应用程序提供的回调函数被调用
            第二个参数是最大阻塞时间，如果设为0，将会是非阻塞的调用*/
            rd_kafka_poll(rk, 0);
        }
        // 若 Topic 不存在，会自动创建
        retry:
        rd_kafka_resp_err_t err = rd_kafka_producev(
                /* Producer handle */
                rk,
                /* Topic name */
                RD_KAFKA_V_TOPIC(TOPIC_NAME),
                /* Make a copy of the payload. */
                RD_KAFKA_V_MSGFLAGS(RD_KAFKA_MSG_F_COPY),
                /* Message value and length */
                RD_KAFKA_V_VALUE(value, len),
                /* Per-Message opaque, provided in
                 * delivery report callback as
                 * msg_opaque. */
                RD_KAFKA_V_OPAQUE(NULL),
                /* End sentinel */
                RD_KAFKA_V_END);

        if (err) {
            /*
             * Failed to *enqueue* message for producing.
             */
            logger_error("Failed to  produce to topic %s: %s", TOPIC_NAME, rd_kafka_err2str(err));

            if (err == RD_KAFKA_RESP_ERR__QUEUE_FULL) {
                rd_kafka_poll(rk, 1000/*block for max 1000ms*/);
                goto retry;
            }
        } else {
            logger_debug(DEBUG_TEST3, 3, " Enqueued message (%zd bytes) for topic %s", len, TOPIC_NAME);
        }

        rd_kafka_poll(rk, 0/*non-blocking*/);
    } else {
        redis_pubsub.clear();
        int ret = redis_pubsub.publish(TOPIC_NAME, value, len);
        if (ret < 0) {
            logger_error("publish to %s error(%s), errorCode: %s", TOPIC_NAME, redis_pubsub.result_error(),
                         ret);
        }
    }
}