class DigitalCurrencyExchangeApiResponseModel{
  final int? code;
  final String? message;
  final List<DigitalCurrencyExchangeApiResponseData>? object;

  DigitalCurrencyExchangeApiResponseModel({this.code, this.message, this.object});

  factory DigitalCurrencyExchangeApiResponseModel.fromJson(Map<dynamic, dynamic> json) {
    return DigitalCurrencyExchangeApiResponseModel(
      code : json['code'],
      message : json['message'].toString(),
      object: (json['object'] as List)
          .map((i) => DigitalCurrencyExchangeApiResponseData.fromJson(i))
          .toList(),
    );
  }
}

class DigitalCurrencyExchangeApiResponseData{
  final String? id;
  final String? accountId;
  final String? exchange;
  final String? exchangeAccount;
  final String? apiKey;
  final String? authorigty;
  final String? ip;
  final String? spotAccountId;
  final String? remark;
  final int? createdate;
  final String? relatedExchangeAccount;
  final String? simpleApiKey;
  final String? purpose;
  final String? wsClientStatus;

  DigitalCurrencyExchangeApiResponseData({this.wsClientStatus,this.id, this.accountId, this.exchange, this.exchangeAccount, this.apiKey, this.authorigty, this.ip, this.spotAccountId, this.remark, this.createdate, this.relatedExchangeAccount, this.simpleApiKey, this.purpose});

  factory DigitalCurrencyExchangeApiResponseData.fromJson(Map<dynamic, dynamic> json) {
    return DigitalCurrencyExchangeApiResponseData(
      id : json['id'].toString(),
      accountId : json['accountId'].toString(),
      exchange : json['exchange'].toString(),
      exchangeAccount : json['exchangeAccount'].toString(),
      apiKey : json['apiKey'].toString(),
      authorigty : json['authorigty'].toString(),
      ip : json['ip'].toString(),
      spotAccountId : json['spotAccountId'].toString(),
      remark : json['remark'].toString(),
      relatedExchangeAccount : json['relatedExchangeAccount'].toString(),
      simpleApiKey : json['simpleApiKey'].toString(),
      purpose : json['purpose'].toString(),
      createdate : json['createdate'],
      wsClientStatus : json['wsClientStatus'].toString(),
    );
  }
}