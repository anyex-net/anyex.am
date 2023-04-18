import 'package:amclient_flutter/Base/HttpRequest.dart';

//外盘现货 查询外盘现货资金账号
WpSpotAccountInfoAccountInfoData() async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/wpspot/wpSpotAccountInfo/data";
  Map<String, String> data = {
  };
  return await httpHeader(kWPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GET');
}

//外盘现货 根据指定ID删除API
WpSpotAccountInfoAccountInfoDel({String id = ''}) async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/wpspot/wpSpotAccountInfo/del/" + id;
  Map<String, String> data = {
  };
  return await httpHeader(kWPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'POST');
}


//外盘现货 新增API 经销商编码
WpSpotBrokerInfoData() async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/wpspot/wpSpotBroker/data";
  Map<String, String> data = {
  };
  return await httpHeader(kWPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GET');
}

//外盘现货 新增API 新增
WpSpotAccountInfoAccountInfoSave({
  String appID = '',String authCode = '',String brokerID = '',
  String investorID = '',String investorPassword = '',String mdFrontAddr = '',
  String tradeFrontAddr = '',
}) async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/wpspot/wpSpotAccountInfo/save";
  Map<String, String> data = {
    "\"appID\"": "\"" + appID + "\"",
    "\"authCode\"": "\"" + authCode + "\"",
    "\"brokerID\"": "\"" + brokerID + "\"",
    "\"investorID\"": "\"" + investorID + "\"",
    "\"investorPassword\"": "\"" + investorPassword + "\"",
    "\"mdFrontAddr\"": "\"" + mdFrontAddr + "\"",
    "\"tradeFrontAddr\"": "\"" + tradeFrontAddr + "\"",
  };
  return await httpHeader(kWPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'POST');
}


//外盘现货 初始化外盘现货部分公共数据
WpSpotExchangeQryOpenCtpCommonData()async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/wpspot/wpSpotExchange/qryOpenCtpCommonData";
  Map<String, String> data = {
  };
  return await httpHeader(kWPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GET');
}

//外盘现货 交易所信息
WpSpotExchangeData()async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/wpspot/wpSpotExchange/data";
  Map<String, String> data = {
  };
  return await httpHeader(kWPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GET');
}

//查询外盘现货交易所期货合约表
WpSpotExchangeInstrumentData({String exchangeID = '',String instrumentID = '',String productID = ''})async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/wpspot/wpSpotExchangeInstrument/data";
  Map<String, String> data = {
    "\"exchangeID\"": "\"" + exchangeID + "\"",
    "\"instrumentID\"": "\"" + instrumentID + "\"",
    "\"productID\"": "\"" + productID + "\"",
  };
  return await httpHeader(kWPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GETBODY');
}

//外盘现货默认合约
WpSpotExchangeInstrumentInit()async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/wpspot/wpSpotExchangeInstrument/init";
  Map<String, String> data = {
  };
  return await httpHeader(kWPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GET');
}

//外盘现货资金账户息表
WpSpotTradingAccountData()async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/wpspot/wpSpotTradingAccount/data";
  Map<String, String> data = {
  };
  return await httpHeader(kWPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GET');
}

//查询外盘现货委托订单表
WpSpotOrderData({int page = 1, String rows = '20'})async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/wpspot/wpSpotOrder/data";
  Map<String, String> data = {
    "\"page\"": "\"" + page.toString() + "\"",
    "\"rows\"": "\"" + rows + "\"",
  };
  return await httpHeader(kWPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GETBODY');
}

//查询外盘现货历史委托订单表
WpSpotOrderHisData({int page = 1, String rows = '20'})async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/wpspot/wpSpotOrderHis/data";
  Map<String, String> data = {
    "\"page\"": "\"" + page.toString() + "\"",
    "\"rows\"": "\"" + rows + "\"",
  };
  return await httpHeader(kWPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GETBODY');
}

//查询外盘现货成交表
WpSpotTradeData({int page = 1, String rows = '20'})async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/wpspot/wpSpotTrade/data";
  Map<String, String> data = {
    "\"page\"": "\"" + page.toString() + "\"",
    "\"rows\"": "\"" + rows + "\"",
  };
  return await httpHeader(kWPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GETBODY');
}

//查询外盘现货持仓汇总表
WpSpotInvestorPositionData({int page = 1, String rows = '20'})async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/wpspot/wpSpotInvestorPosition/data";
  Map<String, String> data = {
    "\"page\"": "\"" + page.toString() + "\"",
    "\"rows\"": "\"" + rows + "\"",
  };
  return await httpHeader(kWPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GETBODY');
}

//外盘现货委托批量撤单
WpSpotOrderBatchCancelOrder()async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/wpspot/wpSpotOrder/batchCancelOrder";
  Map<String, String> data = {
  };
  return await httpHeader(kWPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'POST');
}

//外盘现货委托撤单
WpSpotOrderOrderAction({String exchangeID = '',String instrumentID = '',String investorID = '',String orderRef = '',String frontID = '',String sessionID = ''})async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/wpspot/wpSpotOrder/orderAction";
  Map<String, String> data = {
    "\"exchangeID\"": "\"" + exchangeID + "\"",
    "\"instrumentID\"": "\"" + instrumentID + "\"",
    "\"investorID\"": "\"" + investorID + "\"",
    "\"orderRef\"": "\"" + orderRef + "\"",
    "\"frontID\"": "\"" + frontID + "\"",
    "\"sessionID\"": "\"" + sessionID + "\"",
  };
  return await httpHeader(kWPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'POST');
}

//外盘现货下单
WpSpotOrderOrderInsert({
  String combHedgeFlag = '',String combOffsetFlag = '',String direction = '',
  String exchangeID = '',String instrumentID = '',String investorID = '',
  String limitPrice = '',String orderPriceType = '',String volumeTotalOriginal = '',
})async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/wpspot/wpSpotOrder/orderInsert";
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
  return await httpHeader(kWPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'POST');
}


//外盘现货 订阅内盘现货深度行情
WpSpotDepthMarketDataSubscribeMarketData({String ppInstrumentID = ''})async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/wpspot/wpSpotDepthMarketData/subscribeMarketData";
  Map<String, String> data = {
    "\"ppInstrumentID\"": "\"" + ppInstrumentID + "\"",
  };
  return await httpHeader(kWPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GETBODY');
}


//外盘期货 取消订阅内盘现货深度行情
WpSpotDepthMarketDataUnSubscribeMarketData({String ppInstrumentID = ''})async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/wpspot/wpSpotDepthMarketData/unSubscribeMarketData";
  Map<String, String> data = {
    "\"ppInstrumentID\"": "\"" + ppInstrumentID + "\"",
  };
  return await httpHeader(kWPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GETBODY');
}

