drop table if exists Resources;
create table Resources
(
    id         bigint(18)   not null comment '主键' primary key,
    parentId   bigint(18)   null comment ' 上级编号',
    resCode    varchar(64)  not null comment '资源编码',
    resName    varchar(128) not null comment '资源名称',
    resDest    varchar(512) null comment '资源描述',
    type       bit          null comment '类型（菜单、权限）',
    icon       varchar(64)  null comment '图标',
    sortNum    int(5)       null comment '排序号',
    resUrl     varchar(128) not null comment '资源地址',
    createBy   bigint(18)   null comment '创建人',
    createDate bigint(13)   null comment '创建时间',
    updateBy   bigint(18)   null comment '修改人',
    updateDate bigint(13)   null comment '修改时间',
    delFlag    bit          null comment '删除状态'
)
comment '资源菜单信息表';

INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag) 
VALUES (200000000001, null, 'system:index', '系统管理', null, false, 'fi-widget', 0, '#', 200000000000, 1501467844534, 200000000000, 1572240046622, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag) 
VALUES (200000000002, 200000000001, 'system:organiz:index', '机构管理', null, false, 'fi-results-demographics', 1, '/system/organiz', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag) 
VALUES (200000000003, 200000000002, 'system:organiz:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag) 
VALUES (200000000004, 200000000002, 'system:organiz:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag) 
VALUES (200000000005, 200000000001, 'system:resource:index', '资源管理', null, false, 'fi-database', 2, '/system/resource', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag) 
VALUES (200000000006, 200000000005, 'system:resource:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag) 
VALUES (200000000007, 200000000005, 'system:resource:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag) 
VALUES (200000000008, 200000000001, 'system:role:index', '角色管理', null, false, 'fi-torso-business', 3, '/system/role', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag) 
VALUES (200000000009, 200000000008, 'system:role:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag) 
VALUES (200000000010, 200000000008, 'system:role:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag) 
VALUES (200000000011, 200000000001, 'system:user:index', '用户管理', null, false, 'fi-torsos-all', 4, '/system/user', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag) 
VALUES (200000000012, 200000000011, 'system:user:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag) 
VALUES (200000000013, 200000000011, 'system:user:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag) 
VALUES (200000000014, 200000000001, 'system:cache:index', '缓存管理', null, false, 'fi-torsos-all', 5, '/system/cache', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag) 
VALUES (200000000015, 200000000014, 'system:cache:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag) 
VALUES (200000000016, 200000000014, 'system:cache:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);

INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag) 
VALUES (200000000017, null, 'common:index', '基础管理', null, false, null, 1, '#', 200000000000, 1571883511490, 200000000000, 1571884027177, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag) 
VALUES (200000000018, 200000000017, 'common:region:index', '区域代码', null, false, 'fi-torsos-all', 1, '/common/region', 200000000000, 1501467844534, 200000000000, 1571883572513, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag) 
VALUES (200000000019, 200000000018, 'common:region:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag) 
VALUES (200000000020, 200000000018, 'common:region:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag) 
VALUES (200000000021, 200000000017, 'common:dict:index', '数据字典', null, false, 'fi-list-thumbnails icon-green', 2, '/common/dict', 200000000000, 1501467844534, 200000000000, 1571883583741, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag) 
VALUES (200000000022, 200000000021, 'common:dict:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag) 
VALUES (200000000023, 200000000021, 'common:dict:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag) 
VALUES (200000000024, 200000000017, 'common:msgtemplate:index', '消息模板', null, false, 'fi-social-evernote', 3, '/common/msgtemplate', 200000000000, 1501467844534, 200000000000, 1571883593107, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag) 
VALUES (200000000025, 200000000024, 'common:msgtemplate:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag) 
VALUES (200000000026, 200000000024, 'common:msgtemplate:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag) 
VALUES (200000000027, 200000000017, 'common:msgrecord:index', '消息记录', null, false, 'fi-clipboard-pencil on', 4, '/common/msgrecord', 200000000000, 1519875042081, 200000000000, 1571907998769, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag) 
VALUES (200000000028, 200000000027, 'common:msgrecord:data', '查询权限', null, true, null, null, '#', 200000000000, 1519875247868, 200000000000, 1571884285532, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag) 
VALUES (200000000029, 200000000017, 'common:appversion:index', 'app版本', null, false, 'fi-book', 5, '/common/appversion', 200000000000, 1535541344641, 200000000000, 1571884411486, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag) 
VALUES (200000000030, 200000000029, 'common:appversion:data', '查询权限', null, true, null, null, '#', 200000000000, 1535542477761, 200000000000, 1535542477761, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag) 
VALUES (200000000031, 200000000029, 'common:appversion:operator', '操作权限', null, true, null, null, '#', 200000000000, 1535542724252, 200000000000, 1535542724252, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag) 
VALUES (200000000032, 200000000017, 'common:appdevice:index', 'app设备', null, false, 'fi-book', 6, '/common/appdevice', 200000000000, 1535541344641, 200000000000, 1571884411486, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag) 
VALUES (200000000033, 200000000032, 'common:appdevice:data', '查询权限', null, true, null, null, '#', 200000000000, 1535542477761, 200000000000, 1535542477761, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag) 
VALUES (200000000034, 200000000032, 'common:appdevice:operator', '操作权限', null, true, null, null, '#', 200000000000, 1535542724252, 200000000000, 1535542724252, false);

INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag) 
VALUES (200000000035, 200000000017, 'common:notice:index', '平台公告', null, false, 'fi-book', 7, '/common/notice', 200000000000, 1535541344641, 200000000000, 1571884411486, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag) 
VALUES (200000000036, 200000000035, 'common:notice:data', '查询权限', null, true, null, null, '#', 200000000000, 1535542477761, 200000000000, 1535542477761, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag) 
VALUES (200000000037, 200000000035, 'common:notice:operator', '操作权限', null, true, null, null, '#', 200000000000, 1535542724252, 200000000000, 1535542724252, false);


commit;
