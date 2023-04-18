import 'package:amclient_flutter/Base/HttpRequest.dart';

//查询内盘期货投资者帐号
NpfuturesNpfuturesAccountInfoData({String exchangeNo = ''})async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/npfutures/npfuturesAccountInfo/data";
  Map<String, String> data = {
    // "\"exchangeNo\"": "\"" + exchangeNo + "\"",
  };
  return await httpHeader(kNPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'POST');
}

//查询内盘期货经纪商信息表
NpfuturesNpfuturesBrokerData({String exchangeNo = ''})async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/npfutures/npfuturesBroker/data";
  Map<String, String> data = {
    // "\"exchangeNo\"": "\"" + exchangeNo + "\"",
  };
  return await httpHeader(kNPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'POST');
}

//保存内盘期货投资者帐号
NpfuturesNpfuturesAccountInfoSave({String appID = '',String authCode = '',String brokerID = '',String investorID = '',String investorPassword = '', String mdFrontAddr = '',String tradeFrontAddr = '',})async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/npfutures/npfuturesAccountInfo/save";
  Map<String, String> data = {
    "\"appID\"": "\"" + appID + "\"",
    "\"authCode\"": "\"" + authCode + "\"",
    "\"brokerID\"": "\"" + brokerID + "\"",
    "\"investorID\"": "\"" + investorID + "\"",
    "\"investorPassword\"": "\"" + investorPassword + "\"",
    "\"mdFrontAddr\"": "\"" + mdFrontAddr + "\"",
    "\"tradeFrontAddr\"": "\"" + tradeFrontAddr + "\"",
  };
  return await httpHeader(kNPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'POST');
}

//内盘期货 根据指定ID删除API
NPFuturesNpfuturesAccountInfoDel({String id = ''}) async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/npfutures/npfuturesAccountInfo/del/" + id;
  Map<String, String> data = {
  };
  return await httpHeader(kNPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'POST');
}

//查询内盘期货交易所表
NPFuturesNpfuturesExchangeData() async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/npfutures/npfuturesExchange/data";
  Map<String, String> data = {
  };
  return await httpHeader(kNPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GET');
}
//初始化内盘期货部分公共数据
NPFuturesNpfuturesExchangeQryCtpCommonData() async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/npfutures/npfuturesExchange/qryCtpCommonData";
  Map<String, String> data = {
  };
  return await httpHeader(kNPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GET');
}

//内盘期货交易所期货产品表
NpfuturesNpfuturesExchangeProductData({String exchangeID = ''})async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/npfutures/npfuturesExchangeProduct/data";
  Map<String, String> data = {
    "\"exchangeID\"": "\"" + exchangeID + "\"",
  };
  return await httpHeader(kNPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GETBODY');
}

//查询内盘期货交易所期货合约表
NpfuturesNpfuturesExchangeInstrumentData({String exchangeID = '',String instrumentID = '',String productID = ''})async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/npfutures/npfuturesExchangeInstrument/data";
  Map<String, String> data = {
    "\"exchangeID\"": "\"" + exchangeID + "\"",
    "\"instrumentID\"": "\"" + instrumentID + "\"",
    "\"productID\"": "\"" + productID + "\"",
  };
  return await httpHeader(kNPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GETBODY');
}

//内盘默认合约
NpfuturesNpfuturesExchangeInstrumentNpfuturesExchangeContractInit()async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/npfutures/npfuturesExchangeInstrument/npfuturesExchangeContract/init";
  Map<String, String> data = {
  };
  return await httpHeader(kNPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GET');
}

//内盘期货资金账户息表
NpfuturesNpfuturesTradingAccountData()async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/npfutures/npfuturesTradingAccount/data";
  Map<String, String> data = {
  };
  return await httpHeader(kNPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GET');
}

//查询内盘期货委托订单表
NpfuturesNpfuturesOrderData({int page = 1, String rows = '20'})async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/npfutures/npfuturesOrder/data";
  Map<String, String> data = {
    "\"page\"": "\"" + page.toString() + "\"",
    "\"rows\"": "\"" + rows + "\"",
  };
  return await httpHeader(kNPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GETBODY');
}

//查询内盘期货历史委托订单表
NpfuturesNpfuturesOrderHisData({int page = 1, String rows = '20'})async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/npfutures/npfuturesOrderHis/data";
  Map<String, String> data = {
    "\"page\"": "\"" + page.toString() + "\"",
    "\"rows\"": "\"" + rows + "\"",
  };
  return await httpHeader(kNPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GETBODY');
}

//查询内盘期货成交表
NpfuturesNpfuturesTradeData({int page = 1, String rows = '20'})async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/npfutures/npfuturesTrade/data";
  Map<String, String> data = {
    "\"page\"": "\"" + page.toString() + "\"",
    "\"rows\"": "\"" + rows + "\"",
  };
  return await httpHeader(kNPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GETBODY');
}

//查询内盘期货持仓汇总表
NpfuturesNpfuturesInvestorPositionData({int page = 1, String rows = '20'})async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/npfutures/npfuturesInvestorPosition/data";
  Map<String, String> data = {
    "\"page\"": "\"" + page.toString() + "\"",
    "\"rows\"": "\"" + rows + "\"",
  };
  return await httpHeader(kNPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GETBODY');
}

//内盘期货委托批量撤单
NpfuturesNpfuturesOrderBatchCancelOrder()async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/npfutures/npfuturesOrder/batchCancelOrder";
  Map<String, String> data = {
  };
  return await httpHeader(kNPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'POST');
}

//内盘期货委托撤单
NpfuturesNpfuturesOrderOrderAction({String instrumentID = '',String investorID = '',String orderRef = '',String frontID = '',String sessionID = ''})async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/npfutures/npfuturesOrder/orderAction";
  Map<String, String> data = {
    "\"instrumentID\"": "\"" + instrumentID + "\"",
    "\"investorID\"": "\"" + investorID + "\"",
    "\"orderRef\"": "\"" + orderRef + "\"",
    "\"frontID\"": "\"" + frontID + "\"",
    "\"sessionID\"": "\"" + sessionID + "\"",
  };
  return await httpHeader(kNPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'POST');
}

//内盘下单
NpfuturesNpfuturesOrderOrderInsert({
  String combHedgeFlag = '',String combOffsetFlag = '',String direction = '',
  String exchangeID = '',String instrumentID = '',String investorID = '',
  String limitPrice = '',String orderPriceType = '',String volumeTotalOriginal = '',
})async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/npfutures/npfuturesOrder/orderInsert";
  Map<String, String> data = {
    "\"combHedgeFlag\"": "\"" + combHedgeFlag + "\"",
    "\"combOffsetFlag\"": "\"" + combOffsetFlag + "\"",
    "\"direction\"": "\"" + direction + "\"",
    "\"exchangeID\"": "\"" + exchangeID + "\"",
    "\"instrumentID\"": "\"" + instrumentID + "\"",
    // "\"investorID\"": "\"" + investorID + "\"",
    "\"limitPrice\"": "\"" + limitPrice + "\"",
    "\"orderPriceType\"": "\"" + orderPriceType + "\"",
    "\"volumeTotalOriginal\"": "\"" + volumeTotalOriginal + "\"",
  };
  return await httpHeader(kNPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'POST');
}