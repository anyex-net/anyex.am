class WPSpotAccountInfoResponseModel{

  final int? code;
  final String? message;
  final List<WPSpotAccountInfoResponseData>? object;

  WPSpotAccountInfoResponseModel({this.code, this.message, this.object});

  factory WPSpotAccountInfoResponseModel.fromJson(Map<dynamic, dynamic> json) {
    return WPSpotAccountInfoResponseModel(
      code : json['code'],
      message : json['message'].toString(),
      object: (json['object'] as List)
          .map((i) => WPSpotAccountInfoResponseData.fromJson(i))
          .toList(),
    );
  }
}

class WPSpotAccountInfoResponseData{

  final String? id;
  final String? accountId;
  final String? brokerID;
  final String? investorID;
  final String? investorPassword;
  final String? authCode;
  final String? appID;
  final String? mdFrontAddr;
  final String? tradeFrontAddr;

  WPSpotAccountInfoResponseData({this.id, this.accountId, this.brokerID, this.investorID, this.investorPassword, this.authCode, this.appID, this.mdFrontAddr, this.tradeFrontAddr});

  factory WPSpotAccountInfoResponseData.fromJson(Map<dynamic, dynamic> json) {
    return WPSpotAccountInfoResponseData(
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