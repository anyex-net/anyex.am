delete from Resources where id between 270000000001 and 279999999999;

INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (270000000001, null, 'npspot:index', '内盘现货(CTP2STP)', null, false, 'fi-widget', 7, '#', 200000000000, 1501467844534, 200000000000, 1572540046625, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (270000000002, 270000000001, 'npspot:NpSpotBroker:index', '现货经纪商', null, false, 'fi-database', 1, '/npspot/NpSpotBroker', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (270000000003, 270000000002, 'npspot:NpSpotBroker:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (270000000004, 270000000002, 'npspot:NpSpotBroker:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (270000000005, 270000000001, 'npspot:NpSpotExchange:index', '现货交易所', null, false, 'fi-database', 2, '/npspot/NpSpotExchange', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (270000000006, 270000000005, 'npspot:NpSpotExchange:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (270000000007, 270000000005, 'npspot:NpSpotExchange:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (270000000008, 270000000001, 'npspot:NpSpotExchangeInstrument:index', '现货证券信息', null, false, 'fi-database', 3, '/npspot/NpSpotExchangeInstrument', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (270000000009, 270000000008, 'npspot:NpSpotExchangeInstrument:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (270000000010, 270000000008, 'npspot:NpSpotExchangeInstrument:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (270000000011, 270000000001, 'npspot:NpSpotDepthMarketData:index', '现货证券行情', null, false, 'fi-database', 4, '/npspot/NpSpotDepthMarketData', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (270000000012, 270000000011, 'npspot:NpSpotDepthMarketData:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (270000000013, 270000000011, 'npspot:NpSpotDepthMarketData:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (270000000014, 270000000001, 'npspot:NpSpotExchangeTradeDay:index', '现货交易日', null, false, 'fi-database', 5, '/npspot/NpSpotExchangeTradeDay', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (270000000015, 270000000014, 'npspot:NpSpotExchangeTradeDay:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (270000000016, 270000000014, 'npspot:NpSpotExchangeTradeDay:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);

INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (270000000017, 270000000001, 'npspot:NpSpotAccountInfo:index', '现货投资者帐号', null, false, 'fi-database', 6, '/npspot/NpSpotAccountInfo', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (270000000018, 270000000017, 'npspot:NpSpotAccountInfo:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (270000000019, 270000000017, 'npspot:NpSpotAccountInfo:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);

INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (270000000020, 270000000001, 'npspot:NpSpotTradingAccount:index', '现货资金信息', null, false, 'fi-database', 7, '/npspot/NpSpotTradingAccount', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (270000000021, 270000000020, 'npspot:NpSpotTradingAccount:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (270000000022, 270000000020, 'npspot:NpSpotTradingAccount:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (270000000023, 270000000001, 'npspot:NpSpotInvestorPosition:index', '现货持仓汇总', null, false, 'fi-database', 8, '/npspot/NpSpotInvestorPosition', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (270000000024, 270000000023, 'npspot:NpSpotInvestorPosition:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (270000000025, 270000000023, 'npspot:NpSpotInvestorPosition:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (270000000026, 270000000001, 'npspot:NpSpotOrder:index', '现货委托订单', null, false, 'fi-database', 9, '/npspot/NpSpotOrder', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (270000000027, 270000000026, 'npspot:NpSpotOrder:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (270000000028, 270000000026, 'npspot:NpSpotOrder:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (270000000029, 270000000001, 'npspot:NpSpotTrade:index', '现货成交信息', null, false, 'fi-database', 10, '/npspot/NpSpotTrade', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (270000000030, 270000000029, 'npspot:NpSpotTrade:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (270000000031, 270000000029, 'npspot:NpSpotTrade:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (270000000032, 270000000001, 'npspot:NpSpotOrderHis:index', '现货委托订单历史', null, false, 'fi-database', 11, '/npspot/NpSpotOrderHis', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (270000000033, 270000000032, 'npspot:NpSpotOrderHis:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (270000000034, 270000000032, 'npspot:NpSpotOrderHis:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);


commit;
