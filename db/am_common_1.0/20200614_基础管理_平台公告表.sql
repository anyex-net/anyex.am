drop table if exists Notice;
create table Notice
(
    id            bigint(20)               not null comment '主键id' primary key,
    langType      varchar(20)              not null comment '语言类型(zh_CN简体、zh_HK繁体、en_US英文)',
    title         varchar(128)             not null comment '标题',
    content       varchar(4000)            not null comment '内容',
    remark        varchar(128)                      comment '备注',
    status        bit                      not null comment '状态(0未发布、1已发布)',
    createBy      bigint(20)               not null comment '创建人',
    createDate    bigint(13)               not null comment '创建时间',
    updateBy      bigint(20)                        comment '更新人',
    updateDate    bigint(13)                        comment '更新时间',
    publicBy      bigint(20)                        comment '发布人',
    publicDate    bigint(13)                        comment '发布时间'
)
comment '平台公告表';
