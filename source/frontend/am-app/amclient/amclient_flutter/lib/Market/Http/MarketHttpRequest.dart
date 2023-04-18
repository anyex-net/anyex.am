import 'package:amclient_flutter/Base/HttpRequest.dart';

//查询外盘期货全行情
WpfuturesWpfuturesQuoteWholeAllMarketData()async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/wpfutures/wpfuturesQuoteWhole/allMarketData";
  Map<String, String> data = {
    // "\"exchangeNo\"": "\"" + exchangeNo + "\"",
  };
  return await httpHeader(kWPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GET');
}

//查询外盘现货全行情
WpSpotDepthMarketDataAllMarketData()async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/wpspot/wpSpotDepthMarketData/allMarketData";
  Map<String, String> data = {
    // "\"exchangeNo\"": "\"" + exchangeNo + "\"",
  };
  return await httpHeader(kNPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GET');
}

//查询内盘期货全行情
NpfuturesNpfuturesDepthMarketDataAllMarketData()async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/npfutures/npfuturesDepthMarketData/allMarketData";
  Map<String, String> data = {
    // "\"exchangeNo\"": "\"" + exchangeNo + "\"",
  };
  return await httpHeader(kNPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GET');
}

//查询内盘现货全行情
NpSpotDepthMarketDataAllMarketData()async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/npspot/npSpotDepthMarketData/allMarketData";
  Map<String, String> data = {
    // "\"exchangeNo\"": "\"" + exchangeNo + "\"",
  };
  return await httpHeader(kNPFuturesAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GET');
}


//查询数字货币全行情
DigitalcurrencyOkexMarketGetTickersAll()async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/digitalcurrency/okex/market/getTickers/all";
  Map<String, String> data = {
    // "\"exchangeNo\"": "\"" + exchangeNo + "\"",
  };
  return await httpHeader(kDigitalAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GET');
}

//行情资讯
CommonNoticeData()async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/common/notice/data";
  Map<String, String> data = {
    // "\"exchangeNo\"": "\"" + exchangeNo + "\"",
  };
  return await httpHeader(kAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GET');
}
//行情资讯 单条
CommonNoticeFindByData(String id )async{
  var _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _timestampStr = _timestamp.toString();
  String _url = "/common/notice/findBy/" + id;
  Map<String, String> data = {
    // "\"exchangeNo\"": "\"" + exchangeNo + "\"",
  };
  return await httpHeader(kAddress, _url, data.toString(), _timestampStr,HttpTypes: 'GET');
}