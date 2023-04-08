delete from Resources where id between 250000000001 and 259999999999;

INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (250000000001, null, 'npfutures:index', '内盘期货(CTP版)', null, false, 'fi-widget', 4, '#', 200000000000, 1501467844534, 200000000000, 1572540046625, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (250000000002, 250000000001, 'npfutures:NpfuturesBroker:index', '期货经纪商', null, false, 'fi-database', 1, '/npfutures/NpfuturesBroker', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (250000000003, 250000000002, 'npfutures:NpfuturesBroker:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (250000000004, 250000000002, 'npfutures:NpfuturesBroker:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (250000000005, 250000000001, 'npfutures:NpfuturesExchange:index', '期货交易所', null, false, 'fi-database', 2, '/npfutures/NpfuturesExchange', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (250000000006, 250000000005, 'npfutures:NpfuturesExchange:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (250000000007, 250000000005, 'npfutures:NpfuturesExchange:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (250000000008, 250000000001, 'npfutures:NpfuturesExchangeProduct:index', '期货品种', null, false, 'fi-database', 3, '/npfutures/NpfuturesExchangeProduct', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (250000000009, 250000000008, 'npfutures:NpfuturesExchangeProduct:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (250000000010, 250000000008, 'npfutures:NpfuturesExchangeProduct:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (250000000011, 250000000001, 'npfutures:NpfuturesExchangeInstrument:index', '期货合约', null, false, 'fi-database', 4, '/npfutures/NpfuturesExchangeInstrument', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (250000000012, 250000000011, 'npfutures:NpfuturesExchangeInstrument:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (250000000013, 250000000011, 'npfutures:NpfuturesExchangeInstrument:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (250000000014, 250000000001, 'npfutures:NpfuturesDepthMarketData:index', '期货行情', null, false, 'fi-database', 5, '/npfutures/NpfuturesDepthMarketData', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (250000000015, 250000000014, 'npfutures:NpfuturesDepthMarketData:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (250000000016, 250000000014, 'npfutures:NpfuturesDepthMarketData:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);

INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (250000000017, 250000000001, 'npfutures:NpfuturesAccountInfo:index', '期货资金帐号', null, false, 'fi-database', 6, '/npfutures/NpfuturesAccountInfo', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (250000000018, 250000000017, 'npfutures:NpfuturesAccountInfo:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (250000000019, 250000000017, 'npfutures:NpfuturesAccountInfo:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);

INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (250000000020, 250000000001, 'npfutures:NpfuturesTradingAccount:index', '期货资金信息', null, false, 'fi-database', 7, '/npfutures/NpfuturesTradingAccount', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (250000000021, 250000000020, 'npfutures:NpfuturesTradingAccount:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (250000000022, 250000000020, 'npfutures:NpfuturesTradingAccount:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (250000000023, 250000000001, 'npfutures:NpfuturesInvestorPositionDetail:index', '期货持仓明细', null, false, 'fi-database', 8, '/npfutures/NpfuturesInvestorPositionDetail', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (250000000024, 250000000023, 'npfutures:NpfuturesInvestorPositionDetail:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (250000000025, 250000000023, 'npfutures:NpfuturesInvestorPositionDetail:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (250000000026, 250000000001, 'npfutures:NpfuturesInvestorPosition:index', '期货持仓汇总', null, false, 'fi-database', 9, '/npfutures/NpfuturesInvestorPosition', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (250000000027, 250000000026, 'npfutures:NpfuturesInvestorPosition:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (250000000028, 250000000026, 'npfutures:NpfuturesInvestorPosition:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (250000000029, 250000000001, 'npfutures:NpfuturesOrder:index', '期货委托订单', null, false, 'fi-database', 10, '/npfutures/NpfuturesOrder', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (250000000030, 250000000029, 'npfutures:NpfuturesOrder:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (250000000031, 250000000029, 'npfutures:NpfuturesOrder:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (250000000032, 250000000001, 'npfutures:NpfuturesTrade:index', '期货成交信息', null, false, 'fi-database', 11, '/npfutures/NpfuturesTrade', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (250000000033, 250000000032, 'npfutures:NpfuturesTrade:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (250000000034, 250000000032, 'npfutures:NpfuturesTrade:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);

INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (250000000035, 250000000001, 'npfutures:NpfuturesInstrumentCommissionRate:index', '期货手续费', null, false, 'fi-database', 12, '/npfutures/NpfuturesInstrumentCommissionRate', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (250000000036, 250000000035, 'npfutures:NpfuturesInstrumentCommissionRate:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (250000000037, 250000000035, 'npfutures:NpfuturesInstrumentCommissionRate:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (250000000038, 250000000001, 'npfutures:NpfuturesInstrumentMarginRate:index', '期货保证金', null, false, 'fi-database', 13, '/npfutures/NpfuturesInstrumentMarginRate', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (250000000039, 250000000038, 'npfutures:NpfuturesInstrumentMarginRate:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (250000000040, 250000000038, 'npfutures:NpfuturesInstrumentMarginRate:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (250000000041, 250000000001, 'npfutures:NpfuturesInstrumentOrderCommRate:index', '期货报单手续费(中金)', null, false, 'fi-database', 14, '/npfutures/NpfuturesInstrumentOrderCommRate', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (250000000042, 250000000041, 'npfutures:NpfuturesInstrumentOrderCommRate:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (250000000043, 250000000041, 'npfutures:NpfuturesInstrumentOrderCommRate:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (250000000044, 250000000001, 'npfutures:NpfuturesBrokerTradingParams:index', '期货经纪交易参数', null, false, 'fi-database', 15, '/npfutures/NpfuturesBrokerTradingParams', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (250000000045, 250000000044, 'npfutures:NpfuturesBrokerTradingParams:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (250000000046, 250000000044, 'npfutures:NpfuturesBrokerTradingParams:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);

INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (250000000047, 250000000001, 'npfutures:NpfuturesExchangeTradeDay:index', '内盘交易日', null, false, 'fi-database', 16, '/npfutures/NpfuturesExchangeTradeDay', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (250000000048, 250000000047, 'npfutures:NpfuturesExchangeTradeDay:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (250000000049, 250000000047, 'npfutures:NpfuturesExchangeTradeDay:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);

INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (250000000050, 250000000001, 'npfutures:NpfuturesOrderHis:index', '期货委托订单历史', null, false, 'fi-database', 17, '/npfutures/NpfuturesOrderHis', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (250000000051, 250000000050, 'npfutures:NpfuturesOrderHis:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (250000000052, 250000000050, 'npfutures:NpfuturesOrderHis:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);

--子账户菜单
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (251000000001, 250000000001, 'npfutures:SubNpfuturesAccountInfo:index', '子账户投资帐号', null, false, 'fi-database', 18, '/npfutures/SubNpfuturesAccountInfo', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (251000000002, 251000000001, 'npfutures:SubNpfuturesAccountInfo:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (251000000003, 251000000001, 'npfutures:SubNpfuturesAccountInfo:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (251000000004, 250000000001, 'npfutures:SubNpfuturesTradingAccount:index', '子账户资金信息', null, false, 'fi-database', 19, '/npfutures/SubNpfuturesTradingAccount', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (251000000005, 251000000004, 'npfutures:SubNpfuturesTradingAccount:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (251000000006, 251000000004, 'npfutures:SubNpfuturesTradingAccount:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (251000000007, 250000000001, 'npfutures:SubNpfuturesPosition:index', '子账户持仓汇总', null, false, 'fi-database', 20, '/npfutures/SubNpfuturesPosition', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (251000000008, 251000000007, 'npfutures:SubNpfuturesPosition:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (251000000009, 251000000007, 'npfutures:SubNpfuturesPosition:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (251000000010, 250000000001, 'npfutures:SubNpfuturesPositionDetail:index', '子账户持仓明细', null, false, 'fi-database', 21, '/npfutures/SubNpfuturesPositionDetail', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (251000000011, 251000000010, 'npfutures:SubNpfuturesPositionDetail:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (251000000012, 251000000010, 'npfutures:SubNpfuturesPositionDetail:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (251000000013, 250000000001, 'npfutures:SubNpfuturesOrder:index', '子账户委托订单', null, false, 'fi-database', 22, '/npfutures/SubNpfuturesOrder', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (251000000014, 251000000013, 'npfutures:SubNpfuturesOrder:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (251000000015, 251000000013, 'npfutures:SubNpfuturesOrder:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (251000000016, 250000000001, 'npfutures:SubNpfuturesTrade:index', '子账户委托成交', null, false, 'fi-database', 23, '/npfutures/SubNpfuturesTrade', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (251000000017, 251000000016, 'npfutures:SubNpfuturesTrade:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (251000000018, 251000000016, 'npfutures:SubNpfuturesTrade:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);

INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (251000000019, 250000000001, 'npfutures:SubNpfuturesOrderHis:index', '子账户委托订单历史', null, false, 'fi-database', 24, '/npfutures/SubNpfuturesOrderHis', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (251000000020, 251000000019, 'npfutures:SubNpfuturesOrderHis:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (251000000021, 251000000019, 'npfutures:SubNpfuturesOrderHis:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);

commit;
