use amdigitalcurrency;

drop table if exists ExchangeApiConfig;
create table ExchangeApiConfig
(
    id                     bigint     not null comment '主键' primary key,
    accountId              bigint(20) not null comment '平台账户id',
    exchange               varchar(128) comment '交易所',
    exchangeAccount        varchar(128) comment '交易所账号',
    apiKey                 varchar(255) comment 'APIKEY',
    apiSecret              varchar(255) comment 'APISECRET',
    passPhrase             varchar(30) comment 'PASSPHRASE',
    authorigty             varchar(30) comment '权限',
    ip                     varchar(255) comment 'ip地址',
    spotAccountId          varchar(30) comment '现货账户ID(火币),okex为空',
    remark                 varchar(255) comment '备注',
    createdate             bigint(20) comment '创建时间',
    purpose                varchar(30) comment '用途',
    mainNet                int(1) default 1 not null comment '网络 1主网 0测试网 默认1',
    relatedExchangeAccount varchar(30) comment '关联只读api',
    unique index (accountId, apiKey)
) comment '用户交易所api配置';

