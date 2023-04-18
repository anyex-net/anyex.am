class WPSpotBrokerInfoResponseModel{

  final int? code;
  final String? message;
  final List<WPSpotBrokerInfoResponseData>? object;

  WPSpotBrokerInfoResponseModel({this.code, this.message, this.object});

  factory WPSpotBrokerInfoResponseModel.fromJson(Map<dynamic, dynamic> json) {
    return WPSpotBrokerInfoResponseModel(
      code : json['code'],
      message : json['message'].toString(),
      object: (json['object'] as List)
          .map((i) => WPSpotBrokerInfoResponseData.fromJson(i))
          .toList(),
    );
  }
}

class WPSpotBrokerInfoResponseData{
  final String? id;
  final String? brokerID;
  final String? brokerAbbr;
  final String? brokerName;
  final String? brokerDomain;

  WPSpotBrokerInfoResponseData({this.id, this.brokerID, this.brokerAbbr, this.brokerName, this.brokerDomain});

  factory WPSpotBrokerInfoResponseData.fromJson(Map<dynamic, dynamic> json) {
    return WPSpotBrokerInfoResponseData(
      id : json['id'].toString(),
      brokerID : json['brokerID'].toString(),
      brokerAbbr : json['brokerAbbr'].toString(),
      brokerName : json['brokerName'].toString(),
      brokerDomain : json['brokerDomain'].toString(),
    );
  }
}