import 'package:amclient_flutter/Base/HttpRequest.dart';

//外盘期货 查询外盘期货资金账号
WPFuturesWpfuturesAccountInfoData() async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/wpfutures/wpfuturesAccountInfo/data";
  Map<String, String> data = {
  };
  return await httpHeader(kWPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GET');
}

//外盘期货 根据指定ID删除API
WPFuturesWpfuturesAccountInfoDel({String id = ''}) async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/wpfutures/wpfuturesAccountInfo/del/" + id;
  Map<String, String> data = {
  };
  return await httpHeader(kWPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'POST');
}


//外盘期货 新增API 经销商编码
WPFuturesWpfuturesBrokerInfoData() async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/wpfutures/wpfuturesBrokerInfo/data";
  Map<String, String> data = {
  };
  return await httpHeader(kWPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GET');
}

//外盘期货 新增API 新增
WPFuturesWpfuturesAccountInfoSave({String accountAuthCode = '',String accountNo = '',String accountPassword = '',
  String brokerNo = '',String quoteAccountNo = '',String quoteAccountPassword = '',
  String quoteAccountAuthCode = '',String quoteApiAddr = '',String tradeApiAddr = '',
}) async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/wpfutures/wpfuturesAccountInfo/save";
  Map<String, String> data = {
    "\"accountAuthCode\"": "\"" + accountAuthCode + "\"",
    "\"accountNo\"": "\"" + accountNo + "\"",
    "\"accountPassword\"": "\"" + accountPassword + "\"",
    "\"brokerNo\"": "\"" + brokerNo + "\"",
    "\"quoteAccountNo\"": "\"" + quoteAccountNo + "\"",
    "\"quoteAccountPassword\"": "\"" + quoteAccountPassword + "\"",
    "\"quoteAccountAuthCode\"": "\"" + quoteAccountAuthCode + "\"",
    "\"quoteApiAddr\"": "\"" + quoteApiAddr + "\"",
    "\"tradeApiAddr\"": "\"" + tradeApiAddr + "\"",
  };
  return await httpHeader(kWPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'POST');
}

//外盘期货 交易所信息
WPFuturesWpfuturesExchangeInfoData()async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/wpfutures/wpfuturesExchangeInfo/data";
  Map<String, String> data = {
  };
  return await httpHeader(kWPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GET');
}

//外盘期货交易所期货品种信息管理
WPFuturesWpfuturesExchangeCommodityData({String exchangeNo = ''})async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/wpfutures/wpfuturesExchangeCommodity/data";
  Map<String, String> data = {
    "\"exchangeNo\"": "\"" + exchangeNo + "\"",
  };
  return await httpHeader(kWPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GETBODY');
}

//外盘期货交易所期货合约信息管理
WPFuturesWpfuturesExchangeContractData({String exchangeNo = '',String commodityNo = ''})async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/wpfutures/wpfuturesExchangeContract/data";
  Map<String, String> data = {
    "\"exchangeNo\"": "\"" + exchangeNo + "\"",
    "\"commodityNo\"": "\"" + commodityNo + "\"",
  };
  return await httpHeader(kWPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GETBODY');
}


//外盘期货交易所期货合约信息管理 默认取值
WPFuturesWpfuturesExchangeContractInit()async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/wpfutures/wpfuturesExchangeContract/init";
  Map<String, String> data = {
  };
  return await httpHeader(kWPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GET');
}

//查询外盘期货资金账号资金信息
WPFuturesWpfuturesFundDataData()async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/wpfutures/wpfuturesFundData/data";
  Map<String, String> data = {
  };
  return await httpHeader(kWPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GETBODY');
}

//查询外盘期货资金账号资金信息
WPFuturesWpfuturesFundDataFindByData({String id = ''})async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/wpfutures/wpfuturesFundData/findBy/" + id;
  Map<String, String> data = {
  };
  return await httpHeader(kWPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GETBODY');
}

//查询外盘期货成交
WPFuturesWpfuturesFillInfoData({int page = 1, String rows = '20'})async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/wpfutures/wpfuturesFillInfo/data";
  Map<String, String> data = {
    "\"page\"": "\"" + page.toString() + "\"",
    "\"rows\"": "\"" + rows + "\"",
  };
  return await httpHeader(kWPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GETBODY');
}

//查询外盘期货成交 - 根据ID查
WPFuturesWpfuturesFillInfoFindByData({String id = ''})async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/wpfutures/wpfuturesFillInfo/findBy/" + id;
  Map<String, String> data = {
    // "\"exchangeNo\"": "\"" + exchangeNo + "\"",
    // "\"commodityNo\"": "\"" + commodityNo + "\"",
  };
  return await httpHeader(kWPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GETBODY');
}

//查询外盘期货所有持仓信息
WPFuturesWpfuturesPositionSummaryInfoData({int page = 1, String rows = '20'})async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/wpfutures/wpfuturesPositionSummaryInfo/data";
  Map<String, String> data = {
    "\"page\"": "\"" + page.toString() + "\"",
    "\"rows\"": "\"" + rows + "\"",
  };
  return await httpHeader(kWPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GETBODY');
}

//查询外盘期货委托订单
WPFuturesWpfuturesOrderInfoData({int page = 1, String rows = '20'})async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/wpfutures/wpfuturesOrderInfo/data";
  Map<String, String> data = {
    "\"page\"": "\"" + page.toString() + "\"",
    "\"rows\"": "\"" + rows + "\"",
  };
  return await httpHeader(kWPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GETBODY');
}

//查询外盘期货历史委托订单
WPFuturesWpfuturesOrderInfoHisData({int page = 1, String rows = '20'})async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/wpfutures/wpfuturesOrderInfoHis/data";
  Map<String, String> data = {
    "\"page\"": "\"" + page.toString() + "\"",
    "\"rows\"": "\"" + rows + "\"",
  };
  return await httpHeader(kWPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GETBODY');
}


//外盘期货委托撤单
WPFuturesWpfuturesOrderInfoCancelOrder({String accountNo = '',String orderNo = ''})async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/wpfutures/wpfuturesOrderInfo/cancelOrder";
  Map<String, String> data = {
    "\"accountNo\"": "\"" + accountNo + "\"",
    "\"orderNo\"": "\"" + orderNo + "\"",
  };
  return await httpHeader(kWPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'POST');
}

//外盘期货委托批量撤单
WPFuturesWpfuturesOrderInfoBatchCancelOrder()async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/wpfutures/wpfuturesOrderInfo/batchCancelOrder";
  Map<String, String> data = {
  };
  return await httpHeader(kWPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'POST');
}


//外盘期货委托下单
WPFuturesWpfuturesOrderInfoInsertOrder({
  String accountNo = '',String commodityNo = '',String contractNo = '',
  String exchangeNo = '',String orderPrice = '',String orderQty = '',
  String orderSide = '',String orderType = '',String timeInForce = '',
})async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/wpfutures/wpfuturesOrderInfo/insertOrder";
  Map<String, String> data = {
    // "\"accountNo\"": "\"" + accountNo + "\"",
    "\"commodityNo\"": "\"" + commodityNo + "\"",
    "\"contractNo\"": "\"" + contractNo + "\"",
    "\"exchangeNo\"": "\"" + exchangeNo + "\"",
    "\"orderPrice\"": "\"" + orderPrice + "\"",
    "\"orderQty\"": "\"" + orderQty + "\"",
    "\"orderSide\"": "\"" + orderSide + "\"",
    "\"orderType\"": "\"" + orderType + "\"",
    "\"timeInForce\"": "\"" + timeInForce + "\"",
  };
  return await httpHeader(kWPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'POST');
}

//初始化外盘期货部分公共数据
WPFuturesWpfuturesExchangeInfoQryEsunnyCommonData()async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/wpfutures/wpfuturesExchangeInfo/qryEsunnyCommonData";
  Map<String, String> data = {
  };
  return await httpHeader(kWPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GET');
}

//初始化外盘期货交易所期货合约信息
WPFuturesWpfuturesExchangeContractQryExchangeContractByAccountNoExchangeNo({String commodityNo = '',String exchangeNo = ''})async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/wpfutures/wpfuturesExchangeContract/qryExchangeContractByAccountNoExchangeNo";
  Map<String, String> data = {
    "\"commodityNo\"": "\"" + commodityNo + "\"",
    "\"exchangeNo\"": "\"" + exchangeNo + "\"",
  };
  return await httpHeader(kWPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GETBODY');
}

//初始化外盘期货行情
WPFuturesWpfuturesSubscribeQuoteWholeSubscribeQuoteWhole({String commodityNo = '',String exchangeNo = '',String contractNo = ''})async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/wpfutures/wpfuturesQuoteWhole/subscribeQuoteWhole";
  Map<String, String> data = {
    "\"commodityNo\"": "\"" + commodityNo + "\"",
    "\"contractNo\"": "\"" + contractNo + "\"",
    "\"exchangeNo\"": "\"" + exchangeNo + "\"",
  };
  return await httpHeader(kWPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GETBODY');
}

//取消外盘期货行情
WPFuturesWpfuturesSubscribeQuoteWholeUnSubscribeQuoteWhole({String commodityNo = '',String exchangeNo = '',String contractNo = ''})async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/wpfutures/wpfuturesQuoteWhole/unSubscribeQuoteWhole";
  Map<String, String> data = {
    "\"commodityNo\"": "\"" + commodityNo + "\"",
    "\"contractNo\"": "\"" + contractNo + "\"",
    "\"exchangeNo\"": "\"" + exchangeNo + "\"",
  };
  return await httpHeader(kWPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GETBODY');
}

//外盘期货 保证金率
WpfuturesWpfuturesAccountMarginRentData({String contractNo = '', String commodityNo = '',String exchangeNo = '',String commodityType = ''})async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/wpfutures/wpfuturesAccountMarginRent/data";
  Map<String, String> data = {
    "\"commodityNo\"": "\"" + commodityNo + "\"",
    "\"exchangeNo\"": "\"" + exchangeNo + "\"",
    "\"contractNo\"": "\"" + contractNo + "\"",
    "\"commodityType\"": "\"" + commodityType + "\"",
  };
  return await httpHeader(kWPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GETBODY');
}

//外盘期货 手续费率
WpfuturesWpfuturesAccountFeeRentData({String commodityNo = '',String exchangeNo = '',String commodityType = ''})async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/wpfutures/wpfuturesAccountFeeRent/data";
  Map<String, String> data = {
    "\"commodityNo\"": "\"" + commodityNo + "\"",
    "\"exchangeNo\"": "\"" + exchangeNo + "\"",
    "\"commodityType\"": "\"" + commodityType + "\"",
  };
  return await httpHeader(kWPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GETBODY');
}