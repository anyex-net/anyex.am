
drop table if exists Account;
create table Account
(
    id                bigint(20)               not null comment '账户ID',
    uid               bigint(20)               not null comment 'UID' AUTO_INCREMENT,
    accountName       varchar(32)              not null comment '账户名',
    loginPwd          varchar(64)              not null comment '登录密码',
    cashPwd           varchar(64)                       comment '资金密码',
    email             varchar(32)                       comment '邮箱',
    country           varchar(32)                       comment '国家地区',
    mobNo             varchar(12)                       comment '手机',
    gaauthKey         varchar(64)                       comment 'Google验证器私钥',
    lang              varchar(32)                       comment '语言',
    location          varchar(64)                       comment '注册所在地或IP',
    status            varchar(16)              not null comment '状态(0:正常、1:冻结、2:注销)',
    thawTime          bigint(13)                        comment '解冻时间',
    securityPolicy    int                     default 0 comment '安全验证策略',
    tradePolicy       int                     default 0 comment '交易验证策略',
    inviteCode        varchar(32)                       comment '邀请码',
    riskEvaluation    varchar(8)              default 0 comment '是否风测',
    remark            varchar(64)                       comment '备注',
    sign              varchar(64)              not null comment 'sign',
    randomKey         varchar(128)             not null comment 'randomKey',
    createDate        bigint(13)               not null comment '创建时间',
    updateDate        bigint(13)                        comment '更新时间',
    primary key (`id`),
    KEY (`uid`)
) AUTO_INCREMENT=100000 comment '账户表';

drop table if exists AccountKyc;
create table AccountKyc
(
    id                bigint(20)               not null comment '账户ID' primary key,
    accountId         bigint(20)               not null comment '本平台账户ID',
    surName           varchar(32)              not null comment '姓氏',
    realName          varchar(32)              not null comment '名字',
    region            varchar(32)              not null comment '国家地区',
    passportNo        varchar(64)              not null comment '证件号',
    attachments       varchar(2048)            not null comment '附件信息',
    status            varchar(16)              not null comment '状态(0未审核 1：已审核通过 2:审核失败)',
    remark            varchar(64)                       comment '备注'
) comment '账户Kyc表';
