delete from Resources where id between 260000000001 and 269999999999;

INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (260000000001, null, 'npfutures:index', '内盘期货(易盛版)', null, false, 'fi-widget', 4, '#', 200000000000, 1501467844534, 200000000000, 1572540046625, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (260000000002, 260000000001, 'npfutures:EsNpfuturesBrokerInfo:index', '期货经纪商', null, false, 'fi-database', 1, '/npfutures/EsNpfuturesBrokerInfo', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (260000000003, 260000000002, 'npfutures:EsNpfuturesBrokerInfo:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (260000000004, 260000000002, 'npfutures:EsNpfuturesBrokerInfo:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (260000000005, 260000000001, 'npfutures:EsNpfuturesExchangeInfo:index', '期货交易所', null, false, 'fi-database', 2, '/npfutures/EsNpfuturesExchangeInfo', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (260000000006, 260000000005, 'npfutures:EsNpfuturesExchangeInfo:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (260000000007, 260000000005, 'npfutures:EsNpfuturesExchangeInfo:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (260000000008, 260000000001, 'npfutures:EsNpfuturesExchangeCommodity:index', '期货品种', null, false, 'fi-database', 3, '/npfutures/EsNpfuturesExchangeCommodity', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (260000000009, 260000000008, 'npfutures:EsNpfuturesExchangeCommodity:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (260000000010, 260000000008, 'npfutures:EsNpfuturesExchangeCommodity:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (260000000011, 260000000001, 'npfutures:EsNpfuturesExchangeContract:index', '期货合约', null, false, 'fi-database', 4, '/npfutures/EsNpfuturesExchangeContract', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (260000000012, 260000000011, 'npfutures:EsNpfuturesExchangeContract:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (260000000013, 260000000011, 'npfutures:EsNpfuturesExchangeContract:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (260000000014, 260000000001, 'npfutures:EsNpfuturesQuoteWhole:index', '期货行情', null, false, 'fi-database', 5, '/npfutures/EsNpfuturesQuoteWhole', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (260000000015, 260000000014, 'npfutures:EsNpfuturesQuoteWhole:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (260000000016, 260000000014, 'npfutures:EsNpfuturesQuoteWhole:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);

INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (260000000017, 260000000001, 'npfutures:EsNpfuturesAccountInfo:index', '期货资金帐号', null, false, 'fi-database', 6, '/npfutures/EsNpfuturesAccountInfo', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (260000000018, 260000000017, 'npfutures:EsNpfuturesAccountInfo:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (260000000019, 260000000017, 'npfutures:EsNpfuturesAccountInfo:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);

INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (260000000020, 260000000001, 'npfutures:EsNpfuturesFundData:index', '期货资金信息', null, false, 'fi-database', 7, '/npfutures/EsNpfuturesFundData', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (260000000021, 260000000020, 'npfutures:EsNpfuturesFundData:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (260000000022, 260000000020, 'npfutures:EsNpfuturesFundData:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);

INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (260000000023, 260000000001, 'npfutures:EsNpfuturesPositionInfo:index', '期货持仓明细', null, false, 'fi-database', 8, '/npfutures/EsNpfuturesPositionInfo', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (260000000024, 260000000023, 'npfutures:EsNpfuturesPositionInfo:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (260000000025, 260000000023, 'npfutures:EsNpfuturesPositionInfo:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);

INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (260000000026, 260000000001, 'npfutures:EsNpfuturesCloseInfo:index', '期货平仓记录', null, false, 'fi-database', 9, '/npfutures/EsNpfuturesCloseInfo', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (260000000027, 260000000026, 'npfutures:EsNpfuturesCloseInfo:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (260000000028, 260000000026, 'npfutures:EsNpfuturesCloseInfo:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);

INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (260000000029, 260000000001, 'npfutures:EsNpfuturesOrderInfo:index', '期货委托订单', null, false, 'fi-database', 10, '/npfutures/EsNpfuturesOrderInfo', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (260000000030, 260000000029, 'npfutures:EsNpfuturesOrderInfo:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (260000000031, 260000000029, 'npfutures:EsNpfuturesOrderInfo:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (260000000032, 260000000001, 'npfutures:EsNpfuturesFillInfo:index', '期货成交信息', null, false, 'fi-database', 11, '/npfutures/EsNpfuturesFillInfo', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (260000000033, 260000000032, 'npfutures:EsNpfuturesFillInfo:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (260000000034, 260000000032, 'npfutures:EsNpfuturesFillInfo:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);

INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (260000000035, 260000000001, 'npfutures:EsNpfuturesAccountRentInfo:index', '期货客户费率', null, false, 'fi-database', 12, '/npfutures/EsNpfuturesAccountRentInfo', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (260000000036, 260000000035, 'npfutures:EsNpfuturesAccountRentInfo:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (260000000037, 260000000035, 'npfutures:EsNpfuturesAccountRentInfo:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);

INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (260000000038, 260000000001, 'npfutures:EsNpfuturesExchangeTradeDay:index', '内盘交易日', null, false, 'fi-database', 13, '/npfutures/EsNpfuturesExchangeTradeDay', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (260000000039, 260000000038, 'npfutures:EsNpfuturesExchangeTradeDay:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (260000000040, 260000000038, 'npfutures:EsNpfuturesExchangeTradeDay:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);

INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (260000000041, 260000000001, 'npfutures:EsNpfuturesOrderInfoHis:index', '期货委托订单历史', null, false, 'fi-database', 14, '/npfutures/EsNpfuturesOrderInfoHis', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (260000000042, 260000000041, 'npfutures:EsNpfuturesOrderInfoHis:operator', '操作权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (260000000043, 260000000041, 'npfutures:EsNpfuturesOrderInfoHis:data', '查询权限', null, true, null, null, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);


commit;
