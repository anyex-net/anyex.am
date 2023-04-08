drop table if exists RoleInfo;
create table RoleInfo
(
    id         bigint(18)  not null comment '主键' primary key,
    roleCode   varchar(32) not null comment '角色编码',
    roleName   varchar(64) not null comment '角色名称',
    roleDest   text        null comment '角色描述',
    createBy   bigint(18)  null comment '创建人',
    createDate bigint(13)  null comment '创建时间',
    updateBy   bigint(18)  null comment '修改人',
    updateDate bigint(13)  null comment '修改时间',
    needGa     bit         null comment '需要GA验证 1需要 0不需要',
    delFlag    bit         null comment '删除标识'
)
comment '角色信息表';

INSERT INTO RoleInfo (id, roleCode, roleName, roleDest, createBy, createDate, updateBy, updateDate, needGa, delFlag) 
VALUES (200000000000, 'ROLE_ADMIN', '管理员', '管理员', 200000000000, 1501467844534, 200000000000, 1501467844534, false, false);

commit;