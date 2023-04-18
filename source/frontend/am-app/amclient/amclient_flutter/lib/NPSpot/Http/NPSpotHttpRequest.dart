import 'package:amclient_flutter/Base/HttpRequest.dart';

//查询内盘期货投资者帐号
NpSpotAccountInfoData({String exchangeNo = ''})async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/npspot/npSpotAccountInfo/data";
  Map<String, String> data = {
    // "\"exchangeNo\"": "\"" + exchangeNo + "\"",
  };
  return await httpHeader(kNPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GET');
}


//查询内盘现货经纪商信息表
NpspotBrokerData({String exchangeNo = ''})async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/npspot/npSpotBroker/data";
  Map<String, String> data = {
    // "\"exchangeNo\"": "\"" + exchangeNo + "\"",
  };
  return await httpHeader(kNPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GET');
}

//保存内盘现货投资者帐号
NpSpotAccountInfoSave({String appID = '',String authCode = '',String brokerID = '',String investorID = '',String investorPassword = '', String mdFrontAddr = '',String tradeFrontAddr = '',})async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/npspot/npSpotAccountInfo/save";
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

//内盘现货 根据指定ID删除API
NpSpotAccountInfoDel({String id = ''}) async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/npspot/npSpotAccountInfo/del/" + id;
  Map<String, String> data = {
  };
  return await httpHeader(kNPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'POST');
}


//内盘现货资金账户息表
NpSpotTradingAccountData()async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/npspot/npSpotTradingAccount/data";
  Map<String, String> data = {
  };
  return await httpHeader(kNPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GET');
}

//查询内盘现货委托订单表
NpSpotOrderData({int page = 1, String rows = '20'})async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/npspot/npSpotOrder/data";
  Map<String, String> data = {
    "\"page\"": "\"" + page.toString() + "\"",
    "\"rows\"": "\"" + rows + "\"",
  };
  return await httpHeader(kNPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GETBODY');
}

//查询内盘现货历史委托订单表
NpSpotOrderHisData({int page = 1, String rows = '20'})async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/npspot/npSpotOrderHis/data";
  Map<String, String> data = {
    "\"page\"": "\"" + page.toString() + "\"",
    "\"rows\"": "\"" + rows + "\"",
  };
  return await httpHeader(kNPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GETBODY');
}

//查询内盘现货成交表
NpSpotTradeData({int page = 1, String rows = '20'})async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/npspot/npSpotTrade/data";
  Map<String, String> data = {
    "\"page\"": "\"" + page.toString() + "\"",
    "\"rows\"": "\"" + rows + "\"",
  };
  return await httpHeader(kNPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'POST');
}

//查询内盘现货持仓汇总表
NpSpotInvestorPositionData({int page = 1, String rows = '20'})async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/npspot/npSpotInvestorPosition/data";
  Map<String, String> data = {
    "\"page\"": "\"" + page.toString() + "\"",
    "\"rows\"": "\"" + rows + "\"",
  };
  return await httpHeader(kNPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GETBODY');
}

//内盘现货委托批量撤单
NpSpotOrderBatchCancelOrder()async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/npspot/npSpotOrder/batchCancelOrder";
  Map<String, String> data = {
  };
  return await httpHeader(kNPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'POST');
}

//内盘现货委托撤单
NpSpotOrderOrderAction({String exchangeID = '',String instrumentID = '',String investorID = '',String orderRef = '',String frontID = '',String sessionID = ''})async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/npspot/npSpotOrder/orderAction";
  Map<String, String> data = {
    "\"exchangeID\"": "\"" + exchangeID + "\"",
    "\"instrumentID\"": "\"" + instrumentID + "\"",
    "\"investorID\"": "\"" + investorID + "\"",
    "\"orderRef\"": "\"" + orderRef + "\"",
    "\"frontID\"": "\"" + frontID + "\"",
    "\"sessionID\"": "\"" + sessionID + "\"",
  };
  return await httpHeader(kNPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'POST');
}


//内盘现货下单
NpSpotOrderOrderInsert({
  String combHedgeFlag = '',String combOffsetFlag = '',String direction = '',
  String exchangeID = '',String instrumentID = '',String investorID = '',
  String limitPrice = '',String orderPriceType = '',String volumeTotalOriginal = '',
})async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/npspot/npSpotOrder/orderInsert";
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

//查询内盘现货交易所表
NpSpotExchangeData() async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/npspot/npSpotExchange/data";
  Map<String, String> data = {
  };
  return await httpHeader(kNPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GET');
}

//查询内盘现货交易所期货合约表
NpSpotExchangeInstrumentData({String exchangeID = '',String instrumentID = '',String productID = ''})async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/npspot/npSpotExchangeInstrument/data";
  Map<String, String> data = {
    "\"exchangeID\"": "\"" + exchangeID + "\"",
    "\"instrumentID\"": "\"" + instrumentID + "\"",
    "\"productID\"": "\"" + productID + "\"",
  };
  return await httpHeader(kNPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GETBODY');
}

//初始化内盘现货部分公共数据
NpSpotExchangeQryCtpCommonData() async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/npspot/npSpotExchange/qryCtpCommonData";
  Map<String, String> data = {
  };
  return await httpHeader(kNPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GET');
}

//内盘现货默认合约
NpSpotExchangeInstrumentInit()async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/npspot/npSpotExchangeInstrument/init";
  Map<String, String> data = {
  };
  return await httpHeader(kNPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GET');
}

//内盘期货 订阅内盘现货深度行情
NpSpotDepthMarketDataSubscribeMarketData({String ppInstrumentID = ''})async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/npspot/npSpotDepthMarketData/subscribeMarketData";
  Map<String, String> data = {
    "\"ppInstrumentID\"": "\"" + ppInstrumentID + "\"",
  };
  return await httpHeader(kNPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GETBODY');
}

//内盘期货 取消订阅内盘现货深度行情
NpSpotDepthMarketDataUnSubscribeMarketData({String ppInstrumentID = ''})async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/npspot/npSpotDepthMarketData/unSubscribeMarketData";
  Map<String, String> data = {
    "\"ppInstrumentID\"": "\"" + ppInstrumentID + "\"",
  };
  return await httpHeader(kNPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GETBODY');
}

