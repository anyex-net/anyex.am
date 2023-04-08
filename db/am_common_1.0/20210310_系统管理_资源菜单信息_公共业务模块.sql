delete from Resources where id between 210000000001 and 219999999999;

INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag) 
VALUES (210000000001, null, 'account:index', '账户管理', null, false, 'fi-widget', 2, '#', 200000000000, 1501467844534, 200000000000, 1572240046622, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag) 
VALUES (210000000002, 210000000001, 'account:account:index', '账户管理', null, false, 'fi-results-demographics', 1, '/account/account', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag) 
VALUES (210000000003, 210000000002, 'account:account:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag) 
VALUES (210000000004, 210000000002, 'account:account:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag) 
VALUES (210000000005, 210000000001, 'account:accountKyc:index', '账户认证', null, false, 'fi-database', 2, '/account/accountKyc', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag) 
VALUES (210000000006, 210000000005, 'account:accountKyc:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag) 
VALUES (210000000007, 210000000005, 'account:accountKyc:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);

commit;
