class SettingPersonalInfoResponseModel{

  final int? code;
  final String? message;
  final SettingPersonalInfoResponseData? object;

  SettingPersonalInfoResponseModel({this.code, this.message, this.object});

  factory SettingPersonalInfoResponseModel.fromJson(Map<dynamic, dynamic> json) {
    return SettingPersonalInfoResponseModel(
      code : json['code'],
      message : json['message'].toString(),
      object: SettingPersonalInfoResponseData.fromJson(json['object']),
    );
  }
}

class SettingPersonalInfoResponseData{
  final String? id;
  final String? uid;
  final String? accountName;
  final String? loginPwd;
  final String? cashPwd;
  final String? email;
  final String? country;
  final String? mobNo;
  final String? gaauthKey;
  final String? lang;
  final String? location;
  final String? status;
  final String? thawTime;
  final String? securityPolicy;
  final String? tradePolicy;
  final String? inviteCode;
  final String? riskEvaluation;
  final String? remark;
  final int? createDate;
  final String? updateDate;

  SettingPersonalInfoResponseData({this.id, this.uid, this.accountName, this.loginPwd, this.cashPwd, this.email, this.country, this.mobNo, this.gaauthKey, this.lang, this.location, this.status, this.thawTime, this.securityPolicy, this.tradePolicy, this.inviteCode, this.riskEvaluation, this.remark, this.createDate, this.updateDate});

  factory SettingPersonalInfoResponseData.fromJson(Map<dynamic, dynamic> json) {
    return SettingPersonalInfoResponseData(
      id : json['id'].toString(),
      uid : json['uid'].toString(),
      accountName : json['accountName'].toString(),
      loginPwd : json['loginPwd'].toString(),
      cashPwd : json['cashPwd'].toString(),
      email : json['email'].toString(),
      country : json['country'].toString(),
      mobNo : json['mobNo'].toString(),
      gaauthKey : json['gaauthKey'].toString(),
      lang : json['lang'].toString(),
      location : json['location'].toString(),
      status : json['status'].toString(),
      thawTime : json['thawTime'].toString(),
      securityPolicy : json['securityPolicy'].toString(),
      tradePolicy : json['tradePolicy'].toString(),
      inviteCode : json['inviteCode'].toString(),
      riskEvaluation : json['riskEvaluation'].toString(),
      remark : json['remark'].toString(),
      createDate : json['createDate'],
      updateDate : json['updateDate'].toString(),
    );
  }
}