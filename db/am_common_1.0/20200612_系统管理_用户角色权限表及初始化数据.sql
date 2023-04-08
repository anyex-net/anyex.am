drop table if exists UserRole;
create table UserRole
(
    id     bigint(18) not null comment '主键' primary key,
    roleId bigint(18) not null comment '角色ID',
    userId bigint(18) not null comment '用户ID'
)
comment '用户角色权限表';

INSERT INTO UserRole (id, roleId, userId) VALUES (200000000000, 200000000000, 200000000000);

commit;