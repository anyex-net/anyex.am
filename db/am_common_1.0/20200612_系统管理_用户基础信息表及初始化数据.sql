drop table if exists UserInfo;
create table UserInfo
(
    id         bigint(18)   not null comment '主键' primary key,
    orgId      bigint(18)   not null comment '机构ID',
    userName   varchar(32)  not null comment '用户名',
    trueName   varchar(64)  null comment '真实姓名',
    passWord   varchar(64)  not null comment '密码',
    gender     bit          null comment '性别',
    active     bit          null comment '激活状态',
    idCard     varchar(18)  null comment '身份证号',
    sign       varchar(50)  not null comment '签名',
    randomKey  varchar(8)   not null comment 'key',
    authKey    varchar(32)  null comment 'google验证器私钥',
    userLogo   varchar(256) null comment '头像',
    userDest   varchar(256) null comment '描述',
    jobTitle   varchar(64)  null comment '职称',
    address    varchar(128) null comment '所在地址',
    createDate bigint(13)   null comment '创建时间',
    updateDate bigint(13)   null comment '修改时间',
    delFlag    bit          null comment '删除标记',
    constraint index_username unique (userName)
)
comment '用户基础信息表';

INSERT INTO amcommon.UserInfo (id, orgId, userName, trueName, passWord, gender, active, idCard, sign, randomKey, authKey, userLogo, userDest, jobTitle, address, createDate, updateDate, delFlag) 
VALUES (200000000000, 200000000000, 'admin', '管理员', '9bccc26b7d1b661bd2a320026d9de5ec999ad57cc991ded24ed778b4', true, true, '513022198712121677', '2e2f1b61629c12b4014ca15cb8f28ea11ca8b6c6', 'xKspcW', null, null, null, null, null, null, null, false);
INSERT INTO amcommon.UserInfo (id, orgId, userName, trueName, passWord, gender, active, idCard, sign, randomKey, authKey, userLogo, userDest, jobTitle, address, createDate, updateDate, delFlag) 
VALUES (200000000001, 200000000000, 'test', '测试员', 'c7ddf13287933ff56b3a83e42a4f52d9129471c9c66706126f077a20', true, true, null, '2f43c74b527f7263b6e39e6c26bb038b28a85d2e', 'lFsVrV', null, null, null, null, null, null, null, false);

commit;