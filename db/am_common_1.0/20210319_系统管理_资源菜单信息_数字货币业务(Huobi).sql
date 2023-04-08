-- 火币
delete from Resources where id between 240000000001 and 249999999999;

INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000001, null, 'huobi:index', '数字货币(Huobi)', null, false, 'fi-widget', 6, '#', 200000000000, 1501467844534, 200000000000, 1572240046622, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000002, 240000000001, 'huobi:HuobiAccountDepositAddress:index', '现货充值地址', null, false, 'fi-results-demographics', 2, '/huobi/huobiAccountDepositAddress', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000003, 240000000002, 'huobi:HuobiAccountDepositAddress:operator', '操作权限', null, true, null, 2, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000004, 240000000002, 'huobi:HuobiAccountDepositAddress:data', '查询权限', null, true, null, 3, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000005, 240000000001, 'huobi:HuobiAccountWithdrawAddress:index', '现货提币地址', null, false, 'fi-results-demographics', 5, '/huobi/huobiAccountWithdrawAddress', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000006, 240000000005, 'huobi:HuobiAccountWithdrawAddress:operator', '操作权限', null, true, null, 5, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000007, 240000000005, 'huobi:HuobiAccountWithdrawAddress:data', '查询权限', null, true, null, 6, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000008, 240000000001, 'huobi:HuobiCurrencys:index', '所有币种', null, false, 'fi-results-demographics', 8, '/huobi/huobiCurrencys', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000009, 240000000008, 'huobi:HuobiCurrencys:operator', '操作权限', null, true, null, 8, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000010, 240000000008, 'huobi:HuobiCurrencys:data', '查询权限', null, true, null, 9, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000011, 240000000001, 'huobi:HuobiDepositWithdrawRecord:index', '现货充提记录', null, false, 'fi-results-demographics', 11, '/huobi/huobiDepositWithdrawRecord', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000012, 240000000011, 'huobi:HuobiDepositWithdrawRecord:operator', '操作权限', null, true, null, 11, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000013, 240000000011, 'huobi:HuobiDepositWithdrawRecord:data', '查询权限', null, true, null, 12, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000014, 240000000001, 'huobi:HuobiFuturesAccountAsset:index', '交割合约(币)账户信息', null, false, 'fi-results-demographics', 14, '/huobi/huobiFuturesAccountAsset', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000015, 240000000014, 'huobi:HuobiFuturesAccountAsset:operator', '操作权限', null, true, null, 14, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000016, 240000000014, 'huobi:HuobiFuturesAccountAsset:data', '查询权限', null, true, null, 15, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000017, 240000000001, 'huobi:HuobiFuturesAccountPosition:index', '交割合约(币)账户持仓', null, false, 'fi-results-demographics', 17, '/huobi/huobiFuturesAccountPosition', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000018, 240000000017, 'huobi:HuobiFuturesAccountPosition:operator', '操作权限', null, true, null, 17, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000019, 240000000017, 'huobi:HuobiFuturesAccountPosition:data', '查询权限', null, true, null, 18, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000020, 240000000001, 'huobi:HuobiFuturesCoinInstruments:index', '交割合约(币)交易对', null, false, 'fi-results-demographics', 20, '/huobi/huobiFuturesCoinInstruments', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000021, 240000000020, 'huobi:HuobiFuturesCoinInstruments:operator', '操作权限', null, true, null, 20, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000022, 240000000020, 'huobi:HuobiFuturesCoinInstruments:data', '查询权限', null, true, null, 21, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000023, 240000000001, 'huobi:HuobiFuturesFinancialRecord:index', '交割合约(币)财务记录', null, false, 'fi-results-demographics', 23, '/huobi/huobiFuturesFinancialRecord', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000024, 240000000023, 'huobi:HuobiFuturesFinancialRecord:operator', '操作权限', null, true, null, 23, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000025, 240000000023, 'huobi:HuobiFuturesFinancialRecord:data', '查询权限', null, true, null, 24, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000026, 240000000001, 'huobi:HuobiFuturesOrder:index', '交割合约(币)订单信息', null, false, 'fi-results-demographics', 26, '/huobi/huobiFuturesOrder', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000027, 240000000026, 'huobi:HuobiFuturesOrder:operator', '操作权限', null, true, null, 26, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000028, 240000000026, 'huobi:HuobiFuturesOrder:data', '查询权限', null, true, null, 27, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000029, 240000000001, 'huobi:HuobiFuturesOrderDetail:index', '交割合约(币)成交明细', null, false, 'fi-results-demographics', 29, '/huobi/huobiFuturesOrderDetail', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000030, 240000000029, 'huobi:HuobiFuturesOrderDetail:operator', '操作权限', null, true, null, 29, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000031, 240000000029, 'huobi:HuobiFuturesOrderDetail:data', '查询权限', null, true, null, 30, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000032, 240000000001, 'huobi:HuobiFuturesOrderPlan:index', '交割合约(币)计划委托', null, false, 'fi-results-demographics', 32, '/huobi/huobiFuturesOrderPlan', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000033, 240000000032, 'huobi:HuobiFuturesOrderPlan:operator', '操作权限', null, true, null, 32, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000034, 240000000032, 'huobi:HuobiFuturesOrderPlan:data', '查询权限', null, true, null, 33, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000035, 240000000001, 'huobi:HuobiFuturesOrderTpsl:index', '交割合约(币)止盈止损', null, false, 'fi-results-demographics', 35, '/huobi/huobiFuturesOrderTpsl', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000036, 240000000035, 'huobi:HuobiFuturesOrderTpsl:operator', '操作权限', null, true, null, 35, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000037, 240000000035, 'huobi:HuobiFuturesOrderTpsl:data', '查询权限', null, true, null, 36, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000038, 240000000001, 'huobi:HuobiFuturesSettlementRecord:index', '交割合约(币)结算记录', null, false, 'fi-results-demographics', 38, '/huobi/huobiFuturesSettlementRecord', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000039, 240000000038, 'huobi:HuobiFuturesSettlementRecord:operator', '操作权限', null, true, null, 38, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000040, 240000000038, 'huobi:HuobiFuturesSettlementRecord:data', '查询权限', null, true, null, 39, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000041, 240000000001, 'huobi:HuobiMarginAccountInfo:index', '借币账户信息(逐仓)', null, false, 'fi-results-demographics', 41, '/huobi/huobiMarginAccountInfo', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000042, 240000000041, 'huobi:HuobiMarginAccountInfo:operator', '操作权限', null, true, null, 41, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000043, 240000000041, 'huobi:HuobiMarginAccountInfo:data', '查询权限', null, true, null, 42, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000044, 240000000001, 'huobi:HuobiMarginCrossAccountInfo:index', '借币账户信息(全仓)', null, false, 'fi-results-demographics', 44, '/huobi/huobiMarginCrossAccountInfo', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000045, 240000000044, 'huobi:HuobiMarginCrossAccountInfo:operator', '操作权限', null, true, null, 44, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000046, 240000000044, 'huobi:HuobiMarginCrossAccountInfo:data', '查询权限', null, true, null, 45, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000047, 240000000001, 'huobi:HuobiMarginCrossOrder:index', '借币订单(全仓)', null, false, 'fi-results-demographics', 47, '/huobi/huobiMarginCrossOrder', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000048, 240000000047, 'huobi:HuobiMarginCrossOrder:operator', '操作权限', null, true, null, 47, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000049, 240000000047, 'huobi:HuobiMarginCrossOrder:data', '查询权限', null, true, null, 48, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000050, 240000000001, 'huobi:HuobiMarginLoanInfo:index', '借币基础信息', null, false, 'fi-results-demographics', 50, '/huobi/huobiMarginLoanInfo', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000051, 240000000050, 'huobi:HuobiMarginLoanInfo:operator', '操作权限', null, true, null, 50, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000052, 240000000050, 'huobi:HuobiMarginLoanInfo:data', '查询权限', null, true, null, 51, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000053, 240000000001, 'huobi:HuobiMarginOrder:index', '借币订单(逐仓)', null, false, 'fi-results-demographics', 53, '/huobi/huobiMarginOrder', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000054, 240000000053, 'huobi:HuobiMarginOrder:operator', '操作权限', null, true, null, 53, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000055, 240000000053, 'huobi:HuobiMarginOrder:data', '查询权限', null, true, null, 54, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000056, 240000000001, 'huobi:HuobiSpotAccountBalance:index', '现货账户余额', null, false, 'fi-results-demographics', 56, '/huobi/huobiSpotAccountBalance', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000057, 240000000056, 'huobi:HuobiSpotAccountBalance:operator', '操作权限', null, true, null, 56, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000058, 240000000056, 'huobi:HuobiSpotAccountBalance:data', '查询权限', null, true, null, 57, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000059, 240000000001, 'huobi:HuobiSpotAccountFund:index', '现货账户流水', null, false, 'fi-results-demographics', 59, '/huobi/huobiSpotAccountFund', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000060, 240000000059, 'huobi:HuobiSpotAccountFund:operator', '操作权限', null, true, null, 59, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000061, 240000000059, 'huobi:HuobiSpotAccountFund:data', '查询权限', null, true, null, 60, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000062, 240000000001, 'huobi:HuobiSpotAccountInfo:index', '现货账户信息', null, false, 'fi-results-demographics', 62, '/huobi/huobiSpotAccountInfo', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000063, 240000000062, 'huobi:HuobiSpotAccountInfo:operator', '操作权限', null, true, null, 62, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000064, 240000000062, 'huobi:HuobiSpotAccountInfo:data', '查询权限', null, true, null, 63, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000065, 240000000001, 'huobi:HuobiSpotAccountLedger:index', '现货账户财务流水', null, false, 'fi-results-demographics', 65, '/huobi/huobiSpotAccountLedger', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000066, 240000000065, 'huobi:HuobiSpotAccountLedger:operator', '操作权限', null, true, null, 65, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000067, 240000000065, 'huobi:HuobiSpotAccountLedger:data', '查询权限', null, true, null, 66, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000068, 240000000001, 'huobi:HuobiSpotAccountOrder:index', '现货订单', null, false, 'fi-results-demographics', 68, '/huobi/huobiSpotAccountOrder', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000069, 240000000068, 'huobi:HuobiSpotAccountOrder:operator', '操作权限', null, true, null, 68, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000070, 240000000068, 'huobi:HuobiSpotAccountOrder:data', '查询权限', null, true, null, 69, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000071, 240000000001, 'huobi:HuobiSpotAccountOrderAlgo:index', '现货策略委托', null, false, 'fi-results-demographics', 71, '/huobi/huobiSpotAccountOrderAlgo', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000072, 240000000071, 'huobi:HuobiSpotAccountOrderAlgo:operator', '操作权限', null, true, null, 71, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000073, 240000000071, 'huobi:HuobiSpotAccountOrderAlgo:data', '查询权限', null, true, null, 72, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000074, 240000000001, 'huobi:HuobiSpotAccountOrderDetail:index', '现货成交明细', null, false, 'fi-results-demographics', 74, '/huobi/huobiSpotAccountOrderDetail', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000075, 240000000074, 'huobi:HuobiSpotAccountOrderDetail:operator', '操作权限', null, true, null, 74, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000076, 240000000074, 'huobi:HuobiSpotAccountOrderDetail:data', '查询权限', null, true, null, 75, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000077, 240000000001, 'huobi:HuobiSpotInstruments:index', '现货交易对', null, false, 'fi-results-demographics', 77, '/huobi/huobiSpotInstruments', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000078, 240000000077, 'huobi:HuobiSpotInstruments:operator', '操作权限', null, true, null, 77, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000079, 240000000077, 'huobi:HuobiSpotInstruments:data', '查询权限', null, true, null, 78, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000080, 240000000001, 'huobi:HuobiSwapCoinAccountAsset:index', '永续合约(币)账户信息', null, false, 'fi-results-demographics', 80, '/huobi/huobiSwapCoinAccountAsset', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000081, 240000000080, 'huobi:HuobiSwapCoinAccountAsset:operator', '操作权限', null, true, null, 80, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000082, 240000000080, 'huobi:HuobiSwapCoinAccountAsset:data', '查询权限', null, true, null, 81, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000083, 240000000001, 'huobi:HuobiSwapCoinAccountPosition:index', '永续合约(币)持仓信息', null, false, 'fi-results-demographics', 83, '/huobi/huobiSwapCoinAccountPosition', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000084, 240000000083, 'huobi:HuobiSwapCoinAccountPosition:operator', '操作权限', null, true, null, 83, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000085, 240000000083, 'huobi:HuobiSwapCoinAccountPosition:data', '查询权限', null, true, null, 84, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000086, 240000000001, 'huobi:HuobiSwapCoinCoinInstruments:index', '永续合约(币)交易对', null, false, 'fi-results-demographics', 86, '/huobi/huobiSwapCoinCoinInstruments', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000087, 240000000086, 'huobi:HuobiSwapCoinCoinInstruments:operator', '操作权限', null, true, null, 86, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000088, 240000000086, 'huobi:HuobiSwapCoinCoinInstruments:data', '查询权限', null, true, null, 87, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000089, 240000000001, 'huobi:HuobiSwapCoinFinancialRecord:index', '永续合约(币)财务记录', null, false, 'fi-results-demographics', 89, '/huobi/huobiSwapCoinFinancialRecord', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000090, 240000000089, 'huobi:HuobiSwapCoinFinancialRecord:operator', '操作权限', null, true, null, 89, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000091, 240000000089, 'huobi:HuobiSwapCoinFinancialRecord:data', '查询权限', null, true, null, 90, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000092, 240000000001, 'huobi:HuobiSwapCoinOrder:index', '永续合约(币)订单信息', null, false, 'fi-results-demographics', 92, '/huobi/huobiSwapCoinOrder', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000093, 240000000092, 'huobi:HuobiSwapCoinOrder:operator', '操作权限', null, true, null, 92, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000094, 240000000092, 'huobi:HuobiSwapCoinOrder:data', '查询权限', null, true, null, 93, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000095, 240000000001, 'huobi:HuobiSwapCoinOrderDetail:index', '永续合约(币)成交明细', null, false, 'fi-results-demographics', 95, '/huobi/huobiSwapCoinOrderDetail', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000096, 240000000095, 'huobi:HuobiSwapCoinOrderDetail:operator', '操作权限', null, true, null, 95, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000097, 240000000095, 'huobi:HuobiSwapCoinOrderDetail:data', '查询权限', null, true, null, 96, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000098, 240000000001, 'huobi:HuobiSwapCoinOrderPlan:index', '永续合约(币)计划委托', null, false, 'fi-results-demographics', 98, '/huobi/huobiSwapCoinOrderPlan', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000099, 240000000098, 'huobi:HuobiSwapCoinOrderPlan:operator', '操作权限', null, true, null, 98, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000100, 240000000098, 'huobi:HuobiSwapCoinOrderPlan:data', '查询权限', null, true, null, 99, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000101, 240000000001, 'huobi:HuobiSwapCoinOrderTpsl:index', '永续合约(币)止盈止损', null, false, 'fi-results-demographics', 101, '/huobi/huobiSwapCoinOrderTpsl', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000102, 240000000101, 'huobi:HuobiSwapCoinOrderTpsl:operator', '操作权限', null, true, null, 101, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000103, 240000000101, 'huobi:HuobiSwapCoinOrderTpsl:data', '查询权限', null, true, null, 102, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000104, 240000000001, 'huobi:HuobiSwapCoinSettlementRecord:index', '永续合约(币)结算记录', null, false, 'fi-results-demographics', 104, '/huobi/huobiSwapCoinSettlementRecord', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000105, 240000000104, 'huobi:HuobiSwapCoinSettlementRecord:operator', '操作权限', null, true, null, 104, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000106, 240000000104, 'huobi:HuobiSwapCoinSettlementRecord:data', '查询权限', null, true, null, 105, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000107, 240000000001, 'huobi:HuobiSwapCrossUsdtSettlementRecord:index', '永续合约(U)全仓结算记录', null, false, 'fi-results-demographics', 107, '/huobi/huobiSwapCrossUsdtSettlementRecord', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000108, 240000000107, 'huobi:HuobiSwapCrossUsdtSettlementRecord:operator', '操作权限', null, true, null, 107, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000109, 240000000107, 'huobi:HuobiSwapCrossUsdtSettlementRecord:data', '查询权限', null, true, null, 108, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000110, 240000000001, 'huobi:HuobiSwapUsdtAccountAsset:index', '永续合约(U)逐仓账户', null, false, 'fi-results-demographics', 110, '/huobi/huobiSwapUsdtAccountAsset', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000111, 240000000110, 'huobi:HuobiSwapUsdtAccountAsset:operator', '操作权限', null, true, null, 110, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000112, 240000000110, 'huobi:HuobiSwapUsdtAccountAsset:data', '查询权限', null, true, null, 111, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000113, 240000000001, 'huobi:HuobiSwapUsdtAccountPosition:index', '永续合约(U)逐仓持仓', null, false, 'fi-results-demographics', 113, '/huobi/huobiSwapUsdtAccountPosition', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000114, 240000000113, 'huobi:HuobiSwapUsdtAccountPosition:operator', '操作权限', null, true, null, 113, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000115, 240000000113, 'huobi:HuobiSwapUsdtAccountPosition:data', '查询权限', null, true, null, 114, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000116, 240000000001, 'huobi:HuobiSwapUsdtCoinInstruments:index', '永续合约(U)交易对', null, false, 'fi-results-demographics', 116, '/huobi/huobiSwapUsdtCoinInstruments', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000117, 240000000116, 'huobi:HuobiSwapUsdtCoinInstruments:operator', '操作权限', null, true, null, 116, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000118, 240000000116, 'huobi:HuobiSwapUsdtCoinInstruments:data', '查询权限', null, true, null, 117, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000119, 240000000001, 'huobi:HuobiSwapUsdtCrossAccountAsset:index', '永续合约(U)全仓账户', null, false, 'fi-results-demographics', 119, '/huobi/huobiSwapUsdtCrossAccountAsset', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000120, 240000000119, 'huobi:HuobiSwapUsdtCrossAccountAsset:operator', '操作权限', null, true, null, 119, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000121, 240000000119, 'huobi:HuobiSwapUsdtCrossAccountAsset:data', '查询权限', null, true, null, 120, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000122, 240000000001, 'huobi:HuobiSwapUsdtCrossAccountAssetDetail:index', '永续合约(U)全仓账户明细', null, false, 'fi-results-demographics', 122, '/huobi/huobiSwapUsdtCrossAccountAssetDetail', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000123, 240000000122, 'huobi:HuobiSwapUsdtCrossAccountAssetDetail:operator', '操作权限', null, true, null, 122, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000124, 240000000122, 'huobi:HuobiSwapUsdtCrossAccountAssetDetail:data', '查询权限', null, true, null, 123, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000125, 240000000001, 'huobi:HuobiSwapUsdtCrossAccountPosition:index', '永续合约(U)全仓持仓', null, false, 'fi-results-demographics', 125, '/huobi/huobiSwapUsdtCrossAccountPosition', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000126, 240000000125, 'huobi:HuobiSwapUsdtCrossAccountPosition:operator', '操作权限', null, true, null, 125, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000127, 240000000125, 'huobi:HuobiSwapUsdtCrossAccountPosition:data', '查询权限', null, true, null, 126, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000128, 240000000001, 'huobi:HuobiSwapUsdtFinancialRecord:index', '永续合约(U)财务记录', null, false, 'fi-results-demographics', 128, '/huobi/huobiSwapUsdtFinancialRecord', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000129, 240000000128, 'huobi:HuobiSwapUsdtFinancialRecord:operator', '操作权限', null, true, null, 128, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000130, 240000000128, 'huobi:HuobiSwapUsdtFinancialRecord:data', '查询权限', null, true, null, 129, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000131, 240000000001, 'huobi:HuobiSwapUsdtOrder:index', '永续合约(U)订单信息', null, false, 'fi-results-demographics', 131, '/huobi/huobiSwapUsdtOrder', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000132, 240000000131, 'huobi:HuobiSwapUsdtOrder:operator', '操作权限', null, true, null, 131, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000133, 240000000131, 'huobi:HuobiSwapUsdtOrder:data', '查询权限', null, true, null, 132, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000134, 240000000001, 'huobi:HuobiSwapUsdtOrderDetail:index', '永续合约(U)成交明细', null, false, 'fi-results-demographics', 134, '/huobi/huobiSwapUsdtOrderDetail', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000135, 240000000134, 'huobi:HuobiSwapUsdtOrderDetail:operator', '操作权限', null, true, null, 134, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000136, 240000000134, 'huobi:HuobiSwapUsdtOrderDetail:data', '查询权限', null, true, null, 135, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000137, 240000000001, 'huobi:HuobiSwapUsdtOrderPlan:index', '永续合约(U)计划委托', null, false, 'fi-results-demographics', 137, '/huobi/huobiSwapUsdtOrderPlan', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000138, 240000000137, 'huobi:HuobiSwapUsdtOrderPlan:operator', '操作权限', null, true, null, 137, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000139, 240000000137, 'huobi:HuobiSwapUsdtOrderPlan:data', '查询权限', null, true, null, 138, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000140, 240000000001, 'huobi:HuobiSwapUsdtOrderTpsl:index', '永续合约(U)止盈止损', null, false, 'fi-results-demographics', 140, '/huobi/huobiSwapUsdtOrderTpsl', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000141, 240000000140, 'huobi:HuobiSwapUsdtOrderTpsl:operator', '操作权限', null, true, null, 140, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000142, 240000000140, 'huobi:HuobiSwapUsdtOrderTpsl:data', '查询权限', null, true, null, 141, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000143, 240000000001, 'huobi:HuobiSwapUsdtSettlementRecord:index', '永续合约(U)逐仓结算记录', null, false, 'fi-results-demographics', 143, '/huobi/huobiSwapUsdtSettlementRecord', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000144, 240000000143, 'huobi:HuobiSwapUsdtSettlementRecord:operator', '操作权限', null, true, null, 143, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000145, 240000000143, 'huobi:HuobiSwapUsdtSettlementRecord:data', '查询权限', null, true, null, 144, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000146, 240000000001, 'common:ExchangeApiConfig:index', '交易所api管理', null, false, 'fi-results-demographics', 0, '/huobi/exchangeApiConfig', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000147, 240000000146, 'common:ExchangeApiConfig:operator', '操作权限', null, true, null, 47, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);
INSERT INTO Resources (id, parentId, resCode, resName, resDest, type, icon, sortNum, resUrl, createBy, createDate, updateBy, updateDate, delFlag)
VALUES (240000000148, 240000000146, 'common:ExchangeApiConfig:data', '查询权限', null, true, null, 48, '#', 200000000000, 1501467844534, 200000000000, 1501467844534, false);

commit;
