class WPFuturesBrokerInfoResponseModel{

  final int? code;
  final String? message;
  final List<WPFuturesBrokerInfoResponseData>? object;

  WPFuturesBrokerInfoResponseModel({this.code, this.message, this.object});

  factory WPFuturesBrokerInfoResponseModel.fromJson(Map<dynamic, dynamic> json) {
    return WPFuturesBrokerInfoResponseModel(
      code : json['code'],
      message : json['message'].toString(),
      object: (json['object'] as List)
          .map((i) => WPFuturesBrokerInfoResponseData.fromJson(i))
          .toList(),
    );
  }
}

class WPFuturesBrokerInfoResponseData{
  final String? id;
  final String? brokerNo;
  final String? brokerName;
  final String? brokerDomain;

  WPFuturesBrokerInfoResponseData({this.id, this.brokerNo, this.brokerName, this.brokerDomain});

  factory WPFuturesBrokerInfoResponseData.fromJson(Map<dynamic, dynamic> json) {
    return WPFuturesBrokerInfoResponseData(
      id : json['id'].toString(),
      brokerNo : json['brokerNo'].toString(),
      brokerName : json['brokerName'].toString(),
      brokerDomain : json['brokerDomain'].toString(),
    );
  }
}