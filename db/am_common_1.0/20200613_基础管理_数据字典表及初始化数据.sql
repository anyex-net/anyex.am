drop table if exists Dictionary;
create table Dictionary
(
    id         bigint(18)   not null comment '主键' primary key,
    parentId   varchar(18)  null comment '上级编码',
    code       varchar(64)  not null comment '编码',
    name       varchar(128) not null comment '名称',
    lang       varchar(32)  null comment '语言类型',
    dest       text         null comment '描述',
    sortNum    int(5)       null comment '排序号',
    active     bit          not null comment '启用标识',
    createBy   bigint(18)   null comment '创建人',
    createDate bigint(13)   null comment '创建时间',
    delFlag    bit          not null comment '删除标识',
    constraint index_code unique (code)
)
comment '数据字典表';

INSERT INTO Dictionary (id, parentId, code, name, lang, dest, sortNum, active, createBy, createDate, delFlag) VALUES (200000000028, null, 'noticeType', '公告类型', 'zh_CN', '1', 0, true, 200000000000, 1508470145117, false);
INSERT INTO Dictionary (id, parentId, code, name, lang, dest, sortNum, active, createBy, createDate, delFlag) VALUES (200000000029, '200000000028', 'message', '消息', 'zh_CN', null, 0, true, 200000000000, 1508470145117, false);
INSERT INTO Dictionary (id, parentId, code, name, lang, dest, sortNum, active, createBy, createDate, delFlag) VALUES (200000000030, '200000000028', 'notice', '公告', 'zh_CN', null, 0, true, 200000000000, 1508470145117, false);
INSERT INTO Dictionary (id, parentId, code, name, lang, dest, sortNum, active, createBy, createDate, delFlag) VALUES (200000000031, null, 'langType', '语言类型', null, null, 0, true, 200000000000, 1508470145117, false);
INSERT INTO Dictionary (id, parentId, code, name, lang, dest, sortNum, active, createBy, createDate, delFlag) VALUES (200000000032, '200000000031', 'zh_CN', '简体', 'zh_CN', null, 0, true, 200000000000, 1508470145117, false);
INSERT INTO Dictionary (id, parentId, code, name, lang, dest, sortNum, active, createBy, createDate, delFlag) VALUES (200000000033, '200000000031', 'zh_HK', '繁体', 'zh_CN', null, 0, true, 200000000000, 1508470145117, false);
INSERT INTO Dictionary (id, parentId, code, name, lang, dest, sortNum, active, createBy, createDate, delFlag) VALUES (200000000034, '200000000031', 'en_US', '英文', 'zh_CN', null, 0, true, 200000000000, 1508470145117, false);
INSERT INTO Dictionary (id, parentId, code, name, lang, dest, sortNum, active, createBy, createDate, delFlag) VALUES (200000000035, null, 'noticeStatus', '公告状态', null, null, 0, true, 200000000000, 1508470145117, false);
INSERT INTO Dictionary (id, parentId, code, name, lang, dest, sortNum, active, createBy, createDate, delFlag) VALUES (200000000036, '200000000035', 'published', '已发布', 'zh_CN', null, 0, true, 200000000000, 1508470145117, false);
INSERT INTO Dictionary (id, parentId, code, name, lang, dest, sortNum, active, createBy, createDate, delFlag) VALUES (200000000037, '200000000035', 'unPublished', '未发布', 'zh_CN', null, 0, true, 200000000000, 1508470145117, false);
INSERT INTO Dictionary (id, parentId, code, name, lang, dest, sortNum, active, createBy, createDate, delFlag) VALUES (200000000038, null, 'transferStatus', '汇出状态', null, null, 0, true, 200000000000, 1508470145117, false);
INSERT INTO Dictionary (id, parentId, code, name, lang, dest, sortNum, active, createBy, createDate, delFlag) VALUES (200000000039, '200000000038', 'noTransfer', '无需汇出', 'zh_CN', null, 0, true, 200000000000, 1508470145117, false);
INSERT INTO Dictionary (id, parentId, code, name, lang, dest, sortNum, active, createBy, createDate, delFlag) VALUES (200000000040, '200000000038', 'unTransfer', '未汇出', 'zh_CN', null, 0, true, 200000000000, 1508470145117, false);
INSERT INTO Dictionary (id, parentId, code, name, lang, dest, sortNum, active, createBy, createDate, delFlag) VALUES (200000000041, '200000000038', 'transferPending', '待划拨', 'zh_CN', null, 0, true, 200000000000, 1508470145117, false);
INSERT INTO Dictionary (id, parentId, code, name, lang, dest, sortNum, active, createBy, createDate, delFlag) VALUES (200000000042, '200000000038', 'transfer', '已汇出', 'zh_CN', null, 0, true, 200000000000, 1508470145117, false);
INSERT INTO Dictionary (id, parentId, code, name, lang, dest, sortNum, active, createBy, createDate, delFlag) VALUES (200000000043, null, 'approveStatus', '审批状态', null, null, 0, true, 200000000000, 1508470145117, false);
INSERT INTO Dictionary (id, parentId, code, name, lang, dest, sortNum, active, createBy, createDate, delFlag) VALUES (200000000044, '200000000043', 'noApprove', '无需审批', 'zh_CN', null, 0, true, 200000000000, 1508470145117, false);
INSERT INTO Dictionary (id, parentId, code, name, lang, dest, sortNum, active, createBy, createDate, delFlag) VALUES (200000000045, '200000000043', 'waitingEmailConfirm', '待Email确认', 'zh_CN', null, 0, true, 200000000000, 1508470145117, false);
INSERT INTO Dictionary (id, parentId, code, name, lang, dest, sortNum, active, createBy, createDate, delFlag) VALUES (200000000046, '200000000043', 'auditPending', '待审核', 'zh_CN', null, 0, true, 200000000000, 1508470145117, false);
INSERT INTO Dictionary (id, parentId, code, name, lang, dest, sortNum, active, createBy, createDate, delFlag) VALUES (200000000047, '200000000043', 'checkPending', '待复核', 'zh_CN', null, 0, true, 200000000000, 1508470145117, false);
INSERT INTO Dictionary (id, parentId, code, name, lang, dest, sortNum, active, createBy, createDate, delFlag) VALUES (200000000048, '200000000043', 'auditReject', '审核拒绝', 'zh_CN', null, 0, true, 200000000000, 1508470145117, false);
INSERT INTO Dictionary (id, parentId, code, name, lang, dest, sortNum, active, createBy, createDate, delFlag) VALUES (200000000049, '200000000043', 'checkThrough', '复核通过', 'zh_CN', null, 0, true, 200000000000, 1508470145117, false);
INSERT INTO Dictionary (id, parentId, code, name, lang, dest, sortNum, active, createBy, createDate, delFlag) VALUES (200000000050, '200000000043', 'checkReject', '复核拒绝', 'zh_CN', null, 0, true, 200000000000, 1508470145117, false);
INSERT INTO Dictionary (id, parentId, code, name, lang, dest, sortNum, active, createBy, createDate, delFlag) VALUES (200000000051, '200000000043', 'cancel', '申请取消', 'zh_CN', null, 0, true, 200000000000, 1508470145117, false);
INSERT INTO Dictionary (id, parentId, code, name, lang, dest, sortNum, active, createBy, createDate, delFlag) VALUES (200000000052, null, 'status', '状态', null, null, 0, true, 200000000000, 1508470145117, false);
INSERT INTO Dictionary (id, parentId, code, name, lang, dest, sortNum, active, createBy, createDate, delFlag) VALUES (200000000053, '200000000052', 'effective', '有效', 'zh_CN', null, 0, true, 200000000000, 1508470145117, false);
INSERT INTO Dictionary (id, parentId, code, name, lang, dest, sortNum, active, createBy, createDate, delFlag) VALUES (200000000054, '200000000052', 'invalid', '无效', 'zh_CN', null, 0, true, 200000000000, 1508470145117, false);
INSERT INTO Dictionary (id, parentId, code, name, lang, dest, sortNum, active, createBy, createDate, delFlag) VALUES (200000000055, null, 'entrustStatus', '委托状态', null, null, 0, true, 200000000000, 1508470145117, false);
INSERT INTO Dictionary (id, parentId, code, name, lang, dest, sortNum, active, createBy, createDate, delFlag) VALUES (200000000056, '200000000055', 'pending', '待成交', 'zh_CN', null, 0, true, 200000000000, 1508470145117, false);
INSERT INTO Dictionary (id, parentId, code, name, lang, dest, sortNum, active, createBy, createDate, delFlag) VALUES (200000000057, '200000000055', 'allAccepted', '全部接受', 'zh_CN', null, 0, true, 200000000000, 1508470145117, false);
INSERT INTO Dictionary (id, parentId, code, name, lang, dest, sortNum, active, createBy, createDate, delFlag) VALUES (200000000058, '200000000055', 'partiaAccepted', '部分接受', 'zh_CN', null, 0, true, 200000000000, 1508470145117, false);
INSERT INTO Dictionary (id, parentId, code, name, lang, dest, sortNum, active, createBy, createDate, delFlag) VALUES (200000000059, '200000000055', 'refused', '已拒绝', 'zh_CN', null, 0, true, 200000000000, 1508470145117, false);
INSERT INTO Dictionary (id, parentId, code, name, lang, dest, sortNum, active, createBy, createDate, delFlag) VALUES (200000000060, '200000000055', 'expired', '已过期', 'zh_CN', null, 0, true, 200000000000, 1508470145117, false);
INSERT INTO Dictionary (id, parentId, code, name, lang, dest, sortNum, active, createBy, createDate, delFlag) VALUES (200000000061, '200000000055', 'withdrawed', '已撤单', 'zh_CN', null, 0, true, 200000000000, 1508470145117, false);
INSERT INTO Dictionary (id, parentId, code, name, lang, dest, sortNum, active, createBy, createDate, delFlag) VALUES (200000000062, null, 'yesOrNo', '是否可以', null, null, 0, true, 200000000000, 1508470145117, false);
INSERT INTO Dictionary (id, parentId, code, name, lang, dest, sortNum, active, createBy, createDate, delFlag) VALUES (200000000063, '200000000062', 'yes', '是', 'zh_CN', null, 0, true, 200000000000, 1508470145117, false);
INSERT INTO Dictionary (id, parentId, code, name, lang, dest, sortNum, active, createBy, createDate, delFlag) VALUES (200000000064, '200000000062', 'no', '否', 'zh_CN', null, 0, true, 200000000000, 1508470145117, false);
INSERT INTO Dictionary (id, parentId, code, name, lang, dest, sortNum, active, createBy, createDate, delFlag) VALUES (200000000065, null, 'succeedOrFail', '成功失败', null, null, 0, true, 200000000000, 1508470145117, false);
INSERT INTO Dictionary (id, parentId, code, name, lang, dest, sortNum, active, createBy, createDate, delFlag) VALUES (200000000066, '200000000065', 'succeed', '成功', 'zh_CN', null, 0, true, 200000000000, 1508470145117, false);
INSERT INTO Dictionary (id, parentId, code, name, lang, dest, sortNum, active, createBy, createDate, delFlag) VALUES (200000000067, '200000000065', 'fail', '失败', 'zh_CN', null, 0, true, 200000000000, 1508470145117, false);
INSERT INTO Dictionary (id, parentId, code, name, lang, dest, sortNum, active, createBy, createDate, delFlag) VALUES (200000000068, null, 'active_status', '启用状态', null, null, 0, true, 200000000000, 1508470145117, false);
INSERT INTO Dictionary (id, parentId, code, name, lang, dest, sortNum, active, createBy, createDate, delFlag) VALUES (200000000069, '200000000068', 'active_enable', '启用', 'zh_CN', null, 0, true, 200000000000, 1508470145117, false);
INSERT INTO Dictionary (id, parentId, code, name, lang, dest, sortNum, active, createBy, createDate, delFlag) VALUES (200000000070, '200000000068', 'active_disabe', '停用', 'zh_CN', null, 0, true, 200000000000, 1508470145117, false);
INSERT INTO Dictionary (id, parentId, code, name, lang, dest, sortNum, active, createBy, createDate, delFlag) VALUES (200000000071, null, 'gender_status', '男女性别', null, null, 0, true, 200000000000, 1508470145117, false);
INSERT INTO Dictionary (id, parentId, code, name, lang, dest, sortNum, active, createBy, createDate, delFlag) VALUES (200000000072, '200000000071', 'gender_man', '男', 'zh_CN', null, 0, true, 200000000000, 1508470145117, false);
INSERT INTO Dictionary (id, parentId, code, name, lang, dest, sortNum, active, createBy, createDate, delFlag) VALUES (200000000073, '200000000071', 'gender_wom', '女', 'zh_CN', null, 0, true, 200000000000, 1508470145117, false);
INSERT INTO Dictionary (id, parentId, code, name, lang, dest, sortNum, active, createBy, createDate, delFlag) VALUES (200000000074, null, 'accoutStatus', '账户状态', null, null, 0, true, 200000000000, 1508470145117, false);
INSERT INTO Dictionary (id, parentId, code, name, lang, dest, sortNum, active, createBy, createDate, delFlag) VALUES (200000000075, '200000000074', 'accountNormal', '正常', 'zh_CN', null, 0, true, 200000000000, 1508470145117, false);
INSERT INTO Dictionary (id, parentId, code, name, lang, dest, sortNum, active, createBy, createDate, delFlag) VALUES (200000000076, '200000000074', 'accountFrozen', '冻结', 'zh_CN', null, 0, true, 200000000000, 1508470145117, false);
INSERT INTO Dictionary (id, parentId, code, name, lang, dest, sortNum, active, createBy, createDate, delFlag) VALUES (200000000077, '200000000074', 'accountClose', '注销', 'zh_CN', null, 0, true, 200000000000, 1508470145117, false);
INSERT INTO Dictionary (id, parentId, code, name, lang, dest, sortNum, active, createBy, createDate, delFlag) VALUES (200000000078, null, 'accountGoogleBind', '账户绑定GA验证器否', null, null, 0, true, 200000000000, 1508470145117, false);
INSERT INTO Dictionary (id, parentId, code, name, lang, dest, sortNum, active, createBy, createDate, delFlag) VALUES (200000000079, '200000000078', 'unBindGA', '未绑定GA', 'zh_CN', null, 0, true, 200000000000, 1508470145117, false);
INSERT INTO Dictionary (id, parentId, code, name, lang, dest, sortNum, active, createBy, createDate, delFlag) VALUES (200000000080, '200000000078', 'bindGA', '已绑定GA', 'zh_CN', null, 0, true, 200000000000, 1508470145117, false);
INSERT INTO Dictionary (id, parentId, code, name, lang, dest, sortNum, active, createBy, createDate, delFlag) VALUES (200000000089, null, 'fundDirect', '资金方向', null, null, 0, true, 200000000000, 1508470145117, false);
INSERT INTO Dictionary (id, parentId, code, name, lang, dest, sortNum, active, createBy, createDate, delFlag) VALUES (200000000090, '200000000089', 'collect', '收款', 'zh_CN', null, 0, true, 200000000000, 1508470145117, false);
INSERT INTO Dictionary (id, parentId, code, name, lang, dest, sortNum, active, createBy, createDate, delFlag) VALUES (200000000091, '200000000089', 'payment', '付款', 'zh_CN', null, 0, true, 200000000000, 1508470145117, false);
INSERT INTO Dictionary (id, parentId, code, name, lang, dest, sortNum, active, createBy, createDate, delFlag) VALUES (200000000092, null, 'confirmStatus', '确认状态', null, null, 0, true, 200000000000, 1508470145117, false);
INSERT INTO Dictionary (id, parentId, code, name, lang, dest, sortNum, active, createBy, createDate, delFlag) VALUES (200000000093, '200000000092', 'unconfirm', '未到账', 'zh_CN', null, 0, true, 200000000000, 1508470145117, false);
INSERT INTO Dictionary (id, parentId, code, name, lang, dest, sortNum, active, createBy, createDate, delFlag) VALUES (200000000094, '200000000092', 'confirm', '已完成', 'zh_CN', null, 0, true, 200000000000, 1508470145117, false);
INSERT INTO Dictionary (id, parentId, code, name, lang, dest, sortNum, active, createBy, createDate, delFlag) VALUES (200000000095, '200000000092', 'confirmFail', '确认失败', 'zh_CN', null, 0, true, 200000000000, 1508470145117, false);
INSERT INTO Dictionary (id, parentId, code, name, lang, dest, sortNum, active, createBy, createDate, delFlag) VALUES (200000000141, null, 'authStatus', '认证状态', null, null, 0, true, 200000000000, 1508470145117, false);
INSERT INTO Dictionary (id, parentId, code, name, lang, dest, sortNum, active, createBy, createDate, delFlag) VALUES (200000000142, '200000000141', 'unauth', '未认证', 'zh_CN', null, 0, true, 200000000000, 1508470145117, false);
INSERT INTO Dictionary (id, parentId, code, name, lang, dest, sortNum, active, createBy, createDate, delFlag) VALUES (200000000143, '200000000141', 'auth', '已认证', 'zh_CN', null, 0, true, 200000000000, 1508470145117, false);
INSERT INTO Dictionary (id, parentId, code, name, lang, dest, sortNum, active, createBy, createDate, delFlag) VALUES (200000000148, null, 'msgTemplateType', '消息模板类型', 'zh_CN', null, 0, true, 200000000000, 1508470145117, false);
INSERT INTO Dictionary (id, parentId, code, name, lang, dest, sortNum, active, createBy, createDate, delFlag) VALUES (200000000149, '200000000148', 'email', '邮件', 'zh_CN', null, 0, true, 200000000000, 1508470145117, false);
INSERT INTO Dictionary (id, parentId, code, name, lang, dest, sortNum, active, createBy, createDate, delFlag) VALUES (200000000150, '200000000148', 'sms', '短信', 'zh_CN', null, 0, true, 200000000000, 1508470145117, false);

commit;
