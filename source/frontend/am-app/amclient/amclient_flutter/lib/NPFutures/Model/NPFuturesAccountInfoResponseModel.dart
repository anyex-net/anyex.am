//内盘期货账户列表
class NPFuturesAccountInfoResponseModel{

  final int? code;
  final String? message;
  final List<NPFuturesAccountInfoResponseData>? object;

  NPFuturesAccountInfoResponseModel({this.code, this.message, this.object});

  factory NPFuturesAccountInfoResponseModel.fromJson(Map<dynamic, dynamic> json) {
    return NPFuturesAccountInfoResponseModel(
      code : json['code'],
      message : json['message'].toString(),
      object: (json['object'] as List)
          .map((i) => NPFuturesAccountInfoResponseData.fromJson(i))
          .toList(),
    );
  }
}
class NPFuturesAccountInfoResponseData{
  final String? id;
  final String? accountId;
  final String? brokerID;
  final String? investorID;
  final String? investorPassword;
  final String? authCode;
  final String? appID;
  final String? mdFrontAddr;
  final String? tradeFrontAddr;

  NPFuturesAccountInfoResponseData({this.id, this.accountId, this.brokerID, this.investorID, this.investorPassword, this.authCode, this.appID, this.mdFrontAddr, this.tradeFrontAddr});

  factory NPFuturesAccountInfoResponseData.fromJson(Map<dynamic, dynamic> json) {
    return NPFuturesAccountInfoResponseData(
      id : json['id'].toString(),
      accountId : json['accountId'].toString(),
      brokerID : json['brokerID'].toString(),
      investorID : json['investorID'].toString(),
      investorPassword : json['investorPassword'].toString(),
      authCode : json['authCode'].toString(),
      appID : json['appID'].toString(),
      mdFrontAddr : json['mdFrontAddr'].toString(),
      tradeFrontAddr : json['tradeFrontAddr'].toString(),
    );
  }
}
//内盘期货经纪商信息表
class NPFuturesBrokerInfoResponseModel{

  final int? code;
  final String? message;
  final List<NPFuturesBrokerInfoResponseData>? object;

  NPFuturesBrokerInfoResponseModel({this.code, this.message, this.object});

  factory NPFuturesBrokerInfoResponseModel.fromJson(Map<dynamic, dynamic> json) {
    return NPFuturesBrokerInfoResponseModel(
      code : json['code'],
      message : json['message'].toString(),
      object: (json['object'] as List)
          .map((i) => NPFuturesBrokerInfoResponseData.fromJson(i))
          .toList(),
    );
  }
}
class NPFuturesBrokerInfoResponseData{
  final String? id;
  final String? brokerID;
  final String? brokerAbbr;
  final String? brokerName;
  final String? brokerDomain;

  NPFuturesBrokerInfoResponseData({this.id, this.brokerID, this.brokerAbbr, this.brokerName, this.brokerDomain});

  factory NPFuturesBrokerInfoResponseData.fromJson(Map<dynamic, dynamic> json) {
    return NPFuturesBrokerInfoResponseData(
      id : json['id'].toString(),
      brokerID : json['brokerID'].toString(),
      brokerAbbr : json['brokerAbbr'].toString(),
      brokerName : json['brokerName'].toString(),
      brokerDomain : json['brokerDomain'].toString(),
    );
  }

}