import 'package:amclient_flutter/Base/HttpRequest.dart';

//数字货币 API 新增保存
DigitalcurrencyExchangeapiSave({String apiKey ='',String apiSecret = '', String divisor = '',String exchange ='',String exchangeAccount = '', String passPhrase ='',String purpose = '',String remark = '',}) async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/digitalcurrency/exchangeapi/save";
  Map<String, String> data = {
    "\"exchange\"": "\"" + exchange + "\"",
    "\"exchangeAccount\"": "\"" + exchangeAccount + "\"",
    "\"apiKey\"": "\"" + apiKey + "\"",
    "\"apiSecret\"": "\"" + apiSecret + "\"",
    "\"passPhrase\"": "\"" + passPhrase + "\"",
    "\"purpose\"": "\"" + purpose + "\"",
    "\"divisor\"": "\"" + divisor + "\"",
    "\"remark\"": "\"" + remark + "\"",
  };
  return await httpHeader(kDigitalAddress, _url, data.toString(), _timestampStr,HttpTypes: 'POST');
}

//数字货币 API 列表
DigitalcurrencyExchangeapiList({String apiKey ='',String apiSecret = '', String divisor = '',String exchange ='',String exchangeAccount = '', String passPhrase ='',String purpose = '',String remark = '',}) async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/digitalcurrency/exchangeapi/list";
  Map<String, String> data = {
  };
  return await httpHeader(kDigitalAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GET');
}

//数字货币 API 列表 删除
DigitalcurrencyExchangeapiDel({String id = ''}) async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/digitalcurrency/exchangeapi/del";
  Map<String, String> data = {
    "\"id\"": "\"" + id + "\"",
  };
  return await httpHeader(kDigitalAddress, _url, data.toString(), _timestampStr,HttpTypes: 'POST');
}

//数字货币 API 列表 修改备注名和关联账户
DigitalcurrencyExchangeapiSaveRemark({String id = '',String relatedExchangeAccount = '',String remark = ''}) async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/digitalcurrency/exchangeapi/saveRemark";
  Map<String, String> data = {
    "\"id\"": "\"" + id + "\"",
    "\"relatedExchangeAccount\"": "\"" + relatedExchangeAccount + "\"",
    "\"remark\"": "\"" + remark + "\"",
  };
  return await httpHeader(kDigitalAddress, _url, data.toString(), _timestampStr,HttpTypes: 'POST');
}

//数字货币 获取5大币种
DigitalcurrencyOkexPubilcInstruments() async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/digitalcurrency/okex/pubilc/instruments";
  Map<String, String> data = {
  };
  return await httpHeader(kDigitalAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GET');
}

//数字货币 获取私有类登陆文本
DigitalcurrencyOkexPrivateGetWebsocketSign({String apiKey = '',}) async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/digitalcurrency/okex/private/getWebsocketSign";
  Map<String, String> data = {
    "\"apiKey\"": "\"" + apiKey + "\"",
    "\"salt\"": "\"" + _timestampStr + '\0\0\0' + "\"",
  };
  return await httpHeader(kDigitalAddress, _url, data.toString(), _timestampStr,HttpTypes: 'POST');
}

//数字货币 获取历史委托
DigitalcurrencyOkexTradeGetOrderHistory7days({String after = '',String before = '',String instId = '',String instType = '', String limit = '',String ordType = '',String state = '',String uly = '', String apiKey = '',}) async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/digitalcurrency/okex/trade/getOrderHistory7days";
  Map<String, String> data = {
    "\"apiKey\"": "\"" + apiKey + "\"",
    "\"after\"": "\"" + after + "\"",
    "\"before\"": "\"" + before + "\"",
    "\"instId\"": "\"" + instId + "\"",
    "\"instType\"": "\"" + instType + "\"",
    "\"limit\"": "\"" + limit + "\"",
    "\"ordType\"": "\"" + ordType + "\"",
    "\"state\"": "\"" + state + "\"",
    "\"uly\"": "\"" + uly + "\"",
  };
  return await httpHeader(kDigitalAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GETBODY');
}

//数字货币 获取当前委托
DigitalcurrencyOkexTradeGetOrderList({String after = '',String before = '',String instId = '',String instType = '', String limit = '',String ordType = '',String state = '',String uly = '', String apiKey = '',}) async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/digitalcurrency/okex/trade/getOrderList";
  Map<String, String> data = {
    "\"apiKey\"": "\"" + apiKey + "\"",
    "\"after\"": "\"" + after + "\"",
    "\"before\"": "\"" + before + "\"",
    "\"instId\"": "\"" + instId + "\"",
    "\"instType\"": "\"" + instType + "\"",
    "\"limit\"": "\"" + limit + "\"",
    "\"ordType\"": "\"" + ordType + "\"",
    "\"state\"": "\"" + state + "\"",
    "\"uly\"": "\"" + uly + "\"",
  };
  return await httpHeader(kDigitalAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GETBODY');
}

//单币种下的 最大可用数量
DigitalcurrencyOkexAccountGetMaximumAvailableTradableAmount({String apiKey = '',String ccy = '',String instId = '',String reduceOnly = '',String tdMode = ''}) async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/digitalcurrency/okex/account/getMaximumAvailableTradableAmount";
  Map<String, String> data = {
    "\"apiKey\"": "\"" + apiKey + "\"",
    "\"ccy\"": "\"" + ccy + "\"",
    "\"instId\"": "\"" + instId + "\"",
    "\"reduceOnly\"": "\"" + reduceOnly + "\"",
    "\"tdMode\"": "\"" + tdMode + "\"",
  };
  return await httpHeader(kDigitalAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GETBODY');
}

//单币种下的 最大可交易数量
DigitalcurrencyOkexAccountGtMaximumTradableSizeForInstrument({String apiKey = '',String ccy = '',String instId = '',String px = '',String tdMode = ''}) async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/digitalcurrency/okex/account/getMaximumTradableSizeForInstrument";
  Map<String, String> data = {
    "\"apiKey\"": "\"" + apiKey + "\"",
    "\"ccy\"": "\"" + ccy + "\"",
    "\"instId\"": "\"" + instId + "\"",
    "\"px\"": "\"" + px + "\"",
    "\"tdMode\"": "\"" + tdMode + "\"",
  };
  return await httpHeader(kDigitalAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GETBODY');
}

//下单
DigitalcurrencyOkexTradePlaceOrder({String apiKey = '',String ccy = '',String clOrdId = '',String instId = '',String ordType = '', String posSide = '',String px = '',String side = '',String sz = '',String tag = '',String tdMode = '',}) async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/digitalcurrency/okex/trade/placeOrder";
  Map<String, String> data = {
    "\"apiKey\"": "\"" + apiKey + "\"",
    "\"ccy\"": "\"" + ccy + "\"",
    "\"clOrdId\"": "\"" + clOrdId + "\"",
    "\"instId\"": "\"" + instId + "\"",
    "\"ordType\"": "\"" + ordType + "\"",
    "\"posSide\"": "\"" + posSide + "\"",
    "\"px\"": "\"" + px + "\"",
    "\"side\"": "\"" + side + "\"",
    "\"sz\"": "\"" + sz + "\"",
    "\"tag\"": "\"" + tag + "\"",
    "\"tdMode\"": "\"" + tdMode + "\"",
  };
  return await httpHeader(kDigitalAddress, _url, data.toString(), _timestampStr,HttpTypes: 'POST');
}

//委托策略下单
DigitalcurrencyOkexTradePlaceAlgoOrder({
  String apiKey = '',String ccy = '', String instId = '',
  String ordType = '', String posSide = '', String side = '',
  String sz = '', String tdMode = '',String tpTriggerPx = '',
  String tpOrdPx = '',String slTriggerPx = '',String slOrdPx = ''}) async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/digitalcurrency/okex/trade/placeAlgoOrder";
  Map<String, String> data = {
    "\"apiKey\"": "\"" + apiKey + "\"",
    "\"ccy\"": "\"" + ccy + "\"",
    "\"instId\"": "\"" + instId + "\"",
    "\"ordType\"": "\"" + ordType + "\"",
    "\"posSide\"": "\"" + posSide + "\"",
    "\"side\"": "\"" + side + "\"",
    "\"sz\"": "\"" + sz + "\"",
    "\"tdMode\"": "\"" + tdMode + "\"",
    "\"tpTriggerPx\"": "\"" + tpTriggerPx + "\"",
    "\"tpOrdPx\"": "\"" + tpOrdPx + "\"",
    "\"slTriggerPx\"": "\"" + slTriggerPx + "\"",
    "\"slOrdPx\"": "\"" + slOrdPx + "\"",

  };
  return await httpHeader(kDigitalAddress, _url, data.toString(), _timestampStr,HttpTypes: 'POST');
}



//批量撤单
DigitalcurrencyOkexTradeCancelMultipleOrders({String apiKey = '',String instId = '',}) async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/digitalcurrency/okex/trade/cancelMultipleOrdersv2";
  Map<String, String> data = {
    "\"apiKey\"": "\"" + apiKey + "\"",
    // "\"list\"": "[{" + "\"instId\"" + ":\"" + instId + "\"" + "}]",
  };
  return await httpHeader(kDigitalAddress, _url, data.toString(), _timestampStr,HttpTypes: 'POST');
}

//撤单
DigitalcurrencyOkexTradeCancelOrder({String apiKey = '',String instId = '',String ordId = ''}) async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/digitalcurrency/okex/trade/cancelOrder";
  Map<String, String> data = {
    "\"apiKey\"": "\"" + apiKey + "\"",
    "\"instId\"": "\"" + instId + "\"",
    "\"ordId\"": "\"" + ordId + "\"",
  };
  return await httpHeader(kDigitalAddress, _url, data.toString(), _timestampStr,HttpTypes: 'POST');
}

//数字货币 获取K线
DigitalcurrencyOkexMarketGetCandlesticks({String instId = '',String bar = ''}) async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/digitalcurrency/okex/market/getCandlesticks";
  Map<String, String> data = {
    "\"instId\"": "\"" + instId + "\"",
    "\"bar\"": "\"" + bar + "\"",
  };
  return await httpHeader(kDigitalAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GETBODY');
}

//数字货币 查询余额
DigitalcurrencyOkexTradeFundGetBalance({String apiKey = '',String instId = '',String ordId = ''}) async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/digitalcurrency/okex/fund/getBalance";
  Map<String, String> data = {
    "\"apiKey\"": "\"" + apiKey + "\"",
  };
  return await httpHeader(kDigitalAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GETBODY');
}


