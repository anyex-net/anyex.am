#pragma once


namespace StpUtil {
    // 获取本地地址与主机名

    bool GetHostInfo(std::string& hostName, std::string& Ip);

    // 创建目录
    bool CreateDirs(const std::string& dirName);

    // 编码转换 GB18030 转 UTF-8//IGNORE
    char* GB18030ToUTF8(char *value, size_t len);

    // kafka或redis 生产者推送
    void KafkaOrRedis(const char *TOPIC_NAME, char* value, size_t len);

    // 编码转换
    int CodeConvert(char *fromCode, char *toCode, char *inbuf, size_t inlen, char *outbuf, size_t *outlen);
}


