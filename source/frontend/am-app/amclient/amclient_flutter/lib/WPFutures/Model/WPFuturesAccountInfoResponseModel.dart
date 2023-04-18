class WPFuturesAccountInfoResponseModel{

  final int? code;
  final String? message;
  final List<WPFuturesAccountInfoResponseData>? object;

  WPFuturesAccountInfoResponseModel({this.code, this.message, this.object});

  factory WPFuturesAccountInfoResponseModel.fromJson(Map<dynamic, dynamic> json) {
    return WPFuturesAccountInfoResponseModel(
      code : json['code'],
      message : json['message'].toString(),
      object: (json['object'] as List)
          .map((i) => WPFuturesAccountInfoResponseData.fromJson(i))
          .toList(),
    );
  }
}

class WPFuturesAccountInfoResponseData{
  final String? id;
  final String? accountId;
  final String? brokerNo;
  final String? accountNo;
  final String? accountType;
  final String? accountState;
  final String? accountTradeRight;
  final String? commodityGroupNo;
  final String? accountShortName;
  final String? accountEnShortName;
  final String? accountPassword;
  final String? accountAuthCode;
  final String? internalApiIp;
  final String? internalApiPort;
  final String? internalBizApiIp;
  final String? internalBizApiPort;
  final String? externalQuoteApiIp;
  final String? externalQuoteApiPort;
  final String? externalTradeApiIp;
  final String? externalTradeApiPort;
  final String? quoteApiAddr;
  final String? tradeApiAddr;
  final String? quoteAccountNo;

  WPFuturesAccountInfoResponseData({this.quoteAccountNo,this.quoteApiAddr,this.tradeApiAddr,this.id, this.accountId, this.brokerNo, this.accountNo, this.accountType, this.accountState, this.accountTradeRight, this.commodityGroupNo, this.accountShortName, this.accountEnShortName, this.accountPassword, this.accountAuthCode, this.internalApiIp, this.internalApiPort, this.internalBizApiIp, this.internalBizApiPort, this.externalQuoteApiIp, this.externalQuoteApiPort, this.externalTradeApiIp, this.externalTradeApiPort});

  factory WPFuturesAccountInfoResponseData.fromJson(Map<dynamic, dynamic> json) {
    return WPFuturesAccountInfoResponseData(
      id : json['id'].toString(),
      accountId : json['accountId'].toString(),
      brokerNo : json['brokerNo'].toString(),
      accountNo : json['accountNo'].toString(),
      accountType : json['accountType'].toString(),
      accountState : json['accountState'].toString(),
      accountTradeRight : json['accountTradeRight'].toString(),
      commodityGroupNo : json['commodityGroupNo'].toString(),
      accountShortName : json['accountShortName'].toString(),
      accountEnShortName : json['accountEnShortName'].toString(),
      accountPassword : json['accountPassword'].toString(),
      accountAuthCode : json['accountAuthCode'].toString(),
      internalApiIp : json['internalApiIp'].toString(),
      internalApiPort : json['internalApiPort'].toString(),
      internalBizApiIp : json['internalBizApiIp'].toString(),
      internalBizApiPort : json['internalBizApiPort'].toString(),
      externalQuoteApiIp : json['externalQuoteApiIp'].toString(),
      externalQuoteApiPort : json['externalQuoteApiPort'].toString(),
      externalTradeApiIp : json['externalTradeApiIp'].toString(),
      externalTradeApiPort : json['externalTradeApiPort'].toString(),
      quoteApiAddr : json['quoteApiAddr'].toString(),
      tradeApiAddr : json['tradeApiAddr'].toString(),
      quoteAccountNo : json['quoteAccountNo'].toString(),
    );
  }
}