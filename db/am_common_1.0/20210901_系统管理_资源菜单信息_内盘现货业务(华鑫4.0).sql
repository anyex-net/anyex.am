delete from Resources where id between 280000000001 and 289999999999;

INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (280000000001, null, 'npspot:index', '内盘现货(华鑫4.0版)', null, false, 'fi-widget', 7, '#', 200000000000, 1501467844534, 200000000000, 1572540046625, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (280000000002, 280000000001, 'npspot:StpNpSpotBroker:index', '现货经纪商', null, false, 'fi-database', 1, '/npspot/StpNpSpotBroker', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (280000000003, 280000000002, 'npspot:StpNpSpotBroker:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (280000000004, 280000000002, 'npspot:StpNpSpotBroker:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (280000000005, 280000000001, 'npspot:StpNpSpotExchange:index', '现货交易所', null, false, 'fi-database', 2, '/npspot/StpNpSpotExchange', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (280000000006, 280000000005, 'npspot:StpNpSpotExchange:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (280000000007, 280000000005, 'npspot:StpNpSpotExchange:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (280000000008, 280000000001, 'npspot:StpNpSpotSecurity:index', '现货证券信息', null, false, 'fi-database', 3, '/npspot/StpNpSpotSecurity', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (280000000009, 280000000008, 'npspot:StpNpSpotSecurity:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (280000000010, 280000000008, 'npspot:StpNpSpotSecurity:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (280000000011, 280000000001, 'npspot:StpNpSpotMarketData:index', '现货证券行情', null, false, 'fi-database', 4, '/npspot/StpNpSpotMarketData', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (280000000012, 280000000011, 'npspot:StpNpSpotMarketData:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (280000000013, 280000000011, 'npspot:StpNpSpotMarketData:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (280000000014, 280000000001, 'npspot:StpNpSpotExchangeTradeDay:index', '现货交易日', null, false, 'fi-database', 5, '/npspot/StpNpSpotExchangeTradeDay', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (280000000015, 280000000014, 'npspot:StpNpSpotExchangeTradeDay:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (280000000016, 280000000014, 'npspot:StpNpSpotExchangeTradeDay:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);

INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (280000000017, 280000000001, 'npspot:StpNpSpotAccountInfo:index', '现货投资者帐号', null, false, 'fi-database', 6, '/npspot/StpNpSpotAccountInfo', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (280000000018, 280000000017, 'npspot:StpNpSpotAccountInfo:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (280000000019, 280000000017, 'npspot:StpNpSpotAccountInfo:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);

INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (280000000020, 280000000001, 'npspot:StpNpSpotInvestorTradingFee:index', '现货佣金费率', null, false, 'fi-database', 7, '/npspot/StpNpSpotInvestorTradingFee', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (280000000021, 280000000020, 'npspot:StpNpSpotInvestorTradingFee:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (280000000022, 280000000020, 'npspot:StpNpSpotInvestorTradingFee:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);

INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (280000000023, 280000000001, 'npspot:StpNpSpotTradingFee:index', '现货基础交易费率', null, false, 'fi-database', 8, '/npspot/StpNpSpotTradingFee', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (280000000024, 280000000023, 'npspot:StpNpSpotTradingFee:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (280000000025, 280000000023, 'npspot:StpNpSpotTradingFee:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);

INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (280000000026, 280000000001, 'npspot:StpNpSpotShareHolderAccount:index', '现货股东账户', null, false, 'fi-database', 9, '/npspot/StpNpSpotShareHolderAccount', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (280000000027, 280000000026, 'npspot:StpNpSpotShareHolderAccount:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (280000000028, 280000000026, 'npspot:StpNpSpotShareHolderAccount:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);

INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (280000000029, 280000000001, 'npspot:StpNpSpotTradingAccount:index', '现货资金信息', null, false, 'fi-database', 10, '/npspot/StpNpSpotTradingAccount', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (280000000030, 280000000029, 'npspot:StpNpSpotTradingAccount:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (280000000031, 280000000029, 'npspot:StpNpSpotTradingAccount:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (280000000032, 280000000001, 'npspot:StpNpSpotPosition:index', '现货持仓汇总', null, false, 'fi-database', 11, '/npspot/StpNpSpotPosition', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (280000000033, 280000000032, 'npspot:StpNpSpotPosition:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (280000000034, 280000000032, 'npspot:StpNpSpotPosition:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (280000000035, 280000000001, 'npspot:StpNpSpotOrder:index', '现货委托订单', null, false, 'fi-database', 12, '/npspot/StpNpSpotOrder', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (280000000036, 280000000035, 'npspot:StpNpSpotOrder:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (280000000037, 280000000035, 'npspot:StpNpSpotOrder:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (280000000038, 280000000001, 'npspot:StpNpSpotTrade:index', '现货成交信息', null, false, 'fi-database', 13, '/npspot/StpNpSpotTrade', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (280000000039, 280000000038, 'npspot:StpNpSpotTrade:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (280000000040, 280000000038, 'npspot:StpNpSpotTrade:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (280000000041, 280000000001, 'npspot:StpNpSpotOrderHis:index', '现货委托订单历史', null, false, 'fi-database', 14, '/npspot/StpNpSpotOrderHis', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (280000000042, 280000000041, 'npspot:StpNpSpotOrderHis:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (280000000043, 280000000041, 'npspot:StpNpSpotOrderHis:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);

--子账户菜单
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (281000000001, 280000000001, 'npspot:SubStpNpSpotAccountInfo:index', '子账户投资帐号', null, false, 'fi-database', 15, '/npspot/SubStpNpSpotAccountInfo', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (281000000002, 281000000001, 'npspot:SubStpNpSpotAccountInfo:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (281000000003, 281000000001, 'npspot:SubStpNpSpotAccountInfo:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (281000000004, 280000000001, 'npspot:SubStpNpSpotTradingAccount:index', '子账户资金信息', null, false, 'fi-database', 16, '/npspot/SubStpNpSpotTradingAccount', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (281000000005, 281000000004, 'npspot:SubStpNpSpotTradingAccount:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (281000000006, 281000000004, 'npspot:SubStpNpSpotTradingAccount:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (281000000007, 280000000001, 'npspot:SubStpNpSpotPosition:index', '子账户持仓汇总', null, false, 'fi-database', 17, '/npspot/SubStpNpSpotPosition', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (281000000008, 281000000007, 'npspot:SubStpNpSpotPosition:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (281000000009, 281000000007, 'npspot:SubStpNpSpotPosition:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (281000000010, 280000000001, 'npspot:SubStpNpSpotOrder:index', '子账户委托订单', null, false, 'fi-database', 18, '/npspot/SubStpNpSpotOrder', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (281000000011, 281000000010, 'npspot:SubStpNpSpotOrder:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (281000000012, 281000000010, 'npspot:SubStpNpSpotOrder:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (281000000013, 280000000001, 'npspot:SubStpNpSpotTrade:index', '子账户委托成交', null, false, 'fi-database', 19, '/npspot/SubStpNpSpotTrade', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (281000000014, 281000000013, 'npspot:SubStpNpSpotTrade:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (281000000015, 281000000013, 'npspot:SubStpNpSpotTrade:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (281000000016, 280000000001, 'npspot:SubStpNpSpotOrderHis:index', '子账户委托订单历史', null, false, 'fi-database', 20, '/npspot/SubStpNpSpotOrderHis', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (281000000017, 281000000016, 'npspot:SubStpNpSpotOrderHis:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (281000000018, 281000000016, 'npspot:SubStpNpSpotOrderHis:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);

commit;
