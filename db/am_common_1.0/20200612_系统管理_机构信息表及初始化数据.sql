/*use amcommon;*/

drop table if exists Organization;
create table Organization
(
    id         bigint(18)   not null comment '主键' primary key,
    parentId   bigint(18)   null comment '上级编号',
    orgCode    varchar(64)  not null comment '机构编码',
    orgName    varchar(128) not null comment '机构名称',
    orgDest    text         null comment '机构描述',
    createBy   varchar(18)  null comment '创建人',
    createDate bigint(13)   null comment '创建时间',
    updateBy   varchar(18)  null comment '修改人',
    updateDate bigint(13)   null comment '修改时间',
    sortNum    int(5)       null comment '排序号',
    delFlag    bit          null comment '删除标识'
)
comment '机构信息表';

INSERT INTO Organization (id, parentId, orgCode, orgName, orgDest, createBy, createDate, updateBy, updateDate, sortNum, delFlag) 
VALUES (200000000000, null, 'AM', 'AM', 'AM', '200000000000', 1501467844534, '200000000000', 1543375576284, 0, false);
INSERT INTO Organization (id, parentId, orgCode, orgName, orgDest, createBy, createDate, updateBy, updateDate, sortNum, delFlag) 
VALUES (200000000001, 200000000000, 'AM_MG', '管理层', '管理层', '200000000000', 1501467844534, '200000000000', 1501467844534, 0, false);
INSERT INTO Organization (id, parentId, orgCode, orgName, orgDest, createBy, createDate, updateBy, updateDate, sortNum, delFlag) 
VALUES (200000000002, 200000000000, 'AM_IT', '技术中心', '技术中心', '200000000000', 1501467844534, '200000000000', 1501467844534, 0, false);
INSERT INTO Organization (id, parentId, orgCode, orgName, orgDest, createBy, createDate, updateBy, updateDate, sortNum, delFlag) 
VALUES (200000000003, 200000000000, 'AM_OP', '运营部', '运营部', '200000000000', 1501467844534, '200000000000', 1501467844534, 0, false);
INSERT INTO Organization (id, parentId, orgCode, orgName, orgDest, createBy, createDate, updateBy, updateDate, sortNum, delFlag) 
VALUES (200000000004, 200000000000, 'AM_CC', '客服部', '客服部', '200000000000', 1501467844534, '200000000000', 1501467844534, 0, false);

commit;
