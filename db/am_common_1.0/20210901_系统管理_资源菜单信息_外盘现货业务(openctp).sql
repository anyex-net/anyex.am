delete from Resources where id between 290000000001 and 299999999999;

INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (290000000001, null, 'wpspot:index', '外盘现货(OPENCTP)', null, false, 'fi-widget', 8, '#', 200000000000, 1501467844534, 200000000000, 1572540046625, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (290000000002, 290000000001, 'wpspot:WpSpotBroker:index', '现货经纪商', null, false, 'fi-database', 1, '/wpspot/WpSpotBroker', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (290000000003, 290000000002, 'wpspot:WpSpotBroker:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (290000000004, 290000000002, 'wpspot:WpSpotBroker:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (290000000005, 290000000001, 'wpspot:WpSpotExchange:index', '现货交易所', null, false, 'fi-database', 2, '/wpspot/WpSpotExchange', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (290000000006, 290000000005, 'wpspot:WpSpotExchange:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (290000000007, 290000000005, 'wpspot:WpSpotExchange:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (290000000008, 290000000001, 'wpspot:WpSpotExchangeInstrument:index', '现货证券信息', null, false, 'fi-database', 3, '/wpspot/WpSpotExchangeInstrument', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (290000000009, 290000000008, 'wpspot:WpSpotExchangeInstrument:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (290000000010, 290000000008, 'wpspot:WpSpotExchangeInstrument:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (290000000011, 290000000001, 'wpspot:WpSpotDepthMarketData:index', '现货证券行情', null, false, 'fi-database', 4, '/wpspot/WpSpotDepthMarketData', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (290000000012, 290000000011, 'wpspot:WpSpotDepthMarketData:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (290000000013, 290000000011, 'wpspot:WpSpotDepthMarketData:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (290000000014, 290000000001, 'wpspot:WpSpotExchangeTradeDay:index', '现货交易日', null, false, 'fi-database', 5, '/wpspot/WpSpotExchangeTradeDay', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (290000000015, 290000000014, 'wpspot:WpSpotExchangeTradeDay:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (290000000016, 290000000014, 'wpspot:WpSpotExchangeTradeDay:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);

INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (290000000017, 290000000001, 'wpspot:WpSpotInstrumentCommissionRate:index', '现货手续费率', null, false, 'fi-database', 6, '/wpspot/WpSpotInstrumentCommissionRate', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (290000000018, 290000000017, 'wpspot:WpSpotInstrumentCommissionRate:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (290000000019, 290000000017, 'wpspot:WpSpotInstrumentCommissionRate:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);

INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (290000000020, 290000000001, 'wpspot:WpSpotAccountInfo:index', '现货投资者帐号', null, false, 'fi-database', 7, '/wpspot/WpSpotAccountInfo', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (290000000021, 290000000020, 'wpspot:WpSpotAccountInfo:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (290000000022, 290000000020, 'wpspot:WpSpotAccountInfo:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);

INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (290000000023, 290000000001, 'wpspot:WpSpotTradingAccount:index', '现货资金信息', null, false, 'fi-database', 8, '/wpspot/WpSpotTradingAccount', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (290000000024, 290000000023, 'wpspot:WpSpotTradingAccount:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (290000000025, 290000000023, 'wpspot:WpSpotTradingAccount:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (290000000026, 290000000001, 'wpspot:WpSpotInvestorPosition:index', '现货持仓汇总', null, false, 'fi-database', 9, '/wpspot/WpSpotInvestorPosition', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (290000000027, 290000000026, 'wpspot:WpSpotInvestorPosition:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (290000000028, 290000000026, 'wpspot:WpSpotInvestorPosition:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);

INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (290000000029, 290000000001, 'wpspot:WpSpotInvestorPositionDetail:index', '现货持仓明细', null, false, 'fi-database', 10, '/wpspot/WpSpotInvestorPositionDetail', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (290000000030, 290000000029, 'wpspot:WpSpotInvestorPositionDetail:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (290000000031, 290000000029, 'wpspot:WpSpotInvestorPositionDetail:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);

INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (290000000032, 290000000001, 'wpspot:WpSpotOrder:index', '现货委托订单', null, false, 'fi-database', 11, '/wpspot/WpSpotOrder', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (290000000033, 290000000032, 'wpspot:WpSpotOrder:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (290000000034, 290000000032, 'wpspot:WpSpotOrder:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (290000000035, 290000000001, 'wpspot:WpSpotTrade:index', '现货成交信息', null, false, 'fi-database', 12, '/wpspot/WpSpotTrade', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (290000000036, 290000000035, 'wpspot:WpSpotTrade:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (290000000037, 290000000035, 'wpspot:WpSpotTrade:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (290000000038, 290000000001, 'wpspot:WpSpotOrderHis:index', '现货委托订单历史', null, false, 'fi-database', 13, '/wpspot/WpSpotOrderHis', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (290000000039, 290000000038, 'wpspot:WpSpotOrderHis:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (290000000040, 290000000038, 'wpspot:WpSpotOrderHis:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);


--子账户菜单
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (291000000001, 290000000001, 'wpspot:SubWpSpotAccountInfo:index', '子账户投资者帐号', null, false, 'fi-database', 14, '/wpspot/SubWpSpotAccountInfo', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (291000000002, 291000000001, 'wpspot:SubWpSpotAccountInfo:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (291000000003, 291000000001, 'wpspot:SubWpSpotAccountInfo:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);

INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (291000000004, 290000000001, 'wpspot:SubWpSpotTradingAccount:index', '子账户资金信息', null, false, 'fi-database', 15, '/wpspot/SubWpSpotTradingAccount', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (291000000005, 291000000004, 'wpspot:SubWpSpotTradingAccount:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (291000000006, 291000000004, 'wpspot:SubWpSpotTradingAccount:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (291000000007, 290000000001, 'wpspot:SubWpSpotPosition:index', '子账户持仓汇总', null, false, 'fi-database', 16, '/wpspot/SubWpSpotPosition', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (291000000008, 291000000007, 'wpspot:SubWpSpotPosition:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (291000000009, 291000000007, 'wpspot:SubWpSpotPosition:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);

INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (291000000010, 290000000001, 'wpspot:SubWpSpotPositionDetail:index', '子账户持仓明细', null, false, 'fi-database', 17, '/wpspot/SubWpSpotPositionDetail', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (291000000011, 291000000010, 'wpspot:SubWpSpotPositionDetail:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (291000000012, 291000000010, 'wpspot:SubWpSpotPositionDetail:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);

INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (291000000013, 290000000001, 'wpspot:SubWpSpotOrder:index', '子账户委托订单', null, false, 'fi-database', 18, '/wpspot/SubWpSpotOrder', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (291000000014, 291000000013, 'wpspot:SubWpSpotOrder:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (291000000015, 291000000013, 'wpspot:SubWpSpotOrder:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (291000000016, 290000000001, 'wpspot:SubWpSpotTrade:index', '子账户成交信息', null, false, 'fi-database', 19, '/wpspot/SubWpSpotTrade', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (291000000017, 291000000016, 'wpspot:SubWpSpotTrade:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (291000000018, 291000000016, 'wpspot:SubWpSpotTrade:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (291000000019, 290000000001, 'wpspot:SubWpSpotOrderHis:index', '子账户委托订单历史', null, false, 'fi-database', 20, '/wpspot/SubWpSpotOrderHis', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (291000000020, 291000000019, 'wpspot:SubWpSpotOrderHis:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (291000000021, 291000000019, 'wpspot:SubWpSpotOrderHis:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);


commit;